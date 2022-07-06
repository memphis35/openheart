create tablespace slow_read_space location '/tablespaces/slowdata';
create tablespace fast_read_space location '/tablespaces/fastdata';

alter table catalog.address set tablespace slow_read_space;
alter table catalog.car set tablespace slow_read_space;
alter table catalog.cause set tablespace slow_read_space;
alter table catalog.department set tablespace slow_read_space;
alter table catalog.employee set tablespace slow_read_space;
alter table catalog.material set tablespace slow_read_space;
alter table catalog.material_type set tablespace slow_read_space;
alter table catalog.position set tablespace slow_read_space;
alter table catalog.specialization set tablespace slow_read_space;
alter table catalog.status set tablespace slow_read_space;

alter index catalog.address_unique set tablespace fast_read_space;
alter index catalog.employee_security_number_unique set tablespace fast_read_space;
alter index catalog.material_name_unique set tablespace fast_read_space;

alter table work.brigade set tablespace fast_read_space;
alter table work.brigade_employee_ids set tablespace fast_read_space;
alter table work.consumed_material set tablespace fast_read_space;
alter table work.patient_card set tablespace fast_read_space;
alter table work.request set tablespace fast_read_space;
alter table work.unit_brigade_ids set tablespace fast_read_space;
alter table work.working_unit set tablespace fast_read_space;
