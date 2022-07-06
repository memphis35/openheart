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