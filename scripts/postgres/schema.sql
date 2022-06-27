create tablespace slow_read_space location '/tablespaces/slowdata';
create tablespace fast_read_space location '/tablespaces/fastdata';

create database openheart;

create role read_only nosuperuser;

grant select on all tables in schema catalog, work to read_only;

create role supervisor nosuperuser;

grant select, insert, update, delete
    on table catalog.material, catalog.material_type, catalog.car
    to supervisor;

create role dp_manager nosuperuser;

grant select, insert, update, delete on all tables in schema catalog to dp_manager;

create role director nosuperuser;

grant all privileges on database openheart to director;

create schema if not exists catalog;

create table if not exists catalog.address
(
    id        bigserial primary key,
    region    varchar(64)  not null,
    city      varchar(64)  not null,
    street    varchar(128) not null,
    building  varchar(10)  not null,
    apartment varchar(10)  null,
    constraint address_unique unique (region, city, street, building, apartment)
) tablespace slow_read_space;

create table if not exists catalog.car
(
    id                  serial primary key,
    registration_number varchar(6),
    model               varchar(128),
    capacity            int not null,
    constraint cars_registration_number_unique unique (registration_number)
) tablespace slow_read_space;

create table if not exists catalog.cause
(
    id       serial primary key,
    code     varchar(16)  not null,
    name     varchar(128) not null,
    priority int          not null,
    constraint cause_code_unique unique (code)
) tablespace slow_read_space;

create table if not exists catalog.department
(
    id           serial primary key,
    address      varchar(256) not null,
    phone_number varchar(20)  not null,
    constraint department_address_unique unique (address)
) tablespace slow_read_space;

create table if not exists catalog.material_type
(
    id            serial primary key,
    name          varchar(64) not null,
    is_restricted boolean     not null,
    constraint material_type_name_unique unique (name)
) tablespace slow_read_space;

create table if not exists catalog.position
(
    id   serial primary key,
    name varchar(32) not null,
    constraint position_name_unique unique (name)
) tablespace slow_read_space;

create table if not exists catalog.specialization
(
    id   serial primary key,
    name varchar(16) not null,
    constraint specialization_name_unique unique (name)
) tablespace slow_read_space;

create table if not exists catalog.status
(
    id   serial primary key,
    name varchar(32) not null,
    constraint status_name_unique unique (name)
) tablespace slow_read_space;

create table if not exists catalog.material
(
    id      serial primary key,
    name    varchar(64) not null,
    type_id int         not null,
    constraint material_name_unique unique (name),
    foreign key (type_id) references catalog.material_type (id)
) tablespace slow_read_space;

create table if not exists catalog.employee
(
    id              serial      not null,
    first_name      varchar(64) not null,
    last_name       varchar(64) not null,
    security_number varchar(12) not null,
    birthday        date        not null,
    position_id     int         not null,
    department_id   int,
    constraint employee_id_pk primary key (id) using index tablespace fast_read_space,
    constraint employee_security_number_unique unique (security_number) using index tablespace fast_read_space,
    foreign key (position_id) references catalog.position (id),
    foreign key (department_id) references catalog.department (id)
) tablespace slow_read_space;

create schema if not exists work;

create table work.brigade
(
    id                serial primary key,
    local_number      int not null,
    car_id            int not null,
    driver_id         int not null,
    specialization_id int not null,
    foreign key (car_id) references catalog.car (id),
    foreign key (driver_id) references catalog.employee (id)
) tablespace fast_read_space;

create table if not exists work.brigade_employee_ids
(
    brigade_id   int not null,
    paramedic_id int not null,
    foreign key (brigade_id) references work.brigade (id),
    foreign key (paramedic_id) references catalog.employee (id),
    constraint brigade_paramedic_ids_unique unique (brigade_id, paramedic_id)
) tablespace fast_read_space;

create table if not exists work.working_unit
(
    id             serial primary key,
    working_date   date not null default now(),
    department_id  int  not null,
    brigade_set_id int  not null,
    constraint working_unit_unique unique (working_date, department_id)
) tablespace fast_read_space;

create table work.unit_brigade_ids
(
    working_unit_id int not null,
    brigade_id      int not null,
    foreign key (working_unit_id) references work.working_unit (id),
    foreign key (brigade_id) references work.brigade (id),
    constraint unit_brigade_unique unique (working_unit_id, brigade_id)
) tablespace fast_read_space;

create table if not exists work.patient_card
(
    id             serial primary key,
    patient_name   varchar(128) not null,
    patient_age    int          not null,
    patient_gender varchar(1)   not null,
    cause_id       int          not null,
    decision       varchar(128) not null,
    constraint age_gt_zero check ( patient_age > 0 ),
    constraint gender_is_male_or_female check ( patient_gender IN ('M', 'F')),
    foreign key (cause_id) references catalog.cause (id)
) tablespace fast_read_space;

create table if not exists work.request
(
    id              serial primary key,
    address         int         not null,
    phone_number    varchar(20) not null,
    registered_at   timestamp   not null default now(),
    registered_by   int         not null,
    status_id       int         not null default 0,
    brigade_id      int,
    patient_card_id int,
    constraint request_unique unique (address, brigade_id, patient_card_id),
    foreign key (address) references catalog.address (id),
    foreign key (status_id) references catalog.status (id),
    foreign key (brigade_id) references work.brigade (id),
    foreign key (patient_card_id) references work.patient_card (id)
) tablespace fast_read_space;

create table if not exists work.consumed_material
(
    id              serial primary key,
    patient_card_id int not null,
    material_id     int not null,
    quantity        int not null,
    constraint quantity_check check ( quantity > 0 ),
    foreign key (patient_card_id) references work.patient_card (id),
    foreign key (material_id) references catalog.material (id)
) tablespace fast_read_space;