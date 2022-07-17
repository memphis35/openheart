insert into work.brigade
values (1, 1, 1, 17, 1),
       (2, 2, 5, 18, 1),
       (3, 1, 2, 19, 1),
       (4, 2, 6, 20, 2),
       (5, 1, 3, 21, 1),
       (6, 2, 7, 22, 5),
       (7, 1, 4, 23, 3),
       (8, 2, 8, 24, 1);

insert into work.brigade_employee_ids
values (1, 1),
       (1, 2),
       (2, 3),
       (2, 4),
       (3, 5),
       (3, 6),
       (4, 7),
       (4, 8),
       (5, 9),
       (5, 10),
       (6, 11),
       (6, 12),
       (7, 13),
       (7, 14),
       (8, 15),
       (8, 16);

insert into work.working_unit
values (1, now(), 1),
       (2, now(), 2),
       (3, now(), 3),
       (4, now(), 4);

insert into work.unit_brigade_ids
values (1, 1),
       (1, 2),
       (2, 3),
       (2, 4),
       (3, 5),
       (3, 6),
       (4, 7),
       (4, 8);

insert into work.request values
                             (1, 1, '+79215347285', now(), 25, 1, 1, default),
                             (2, 2, '+79232254673', now(), 25, 1, 1, default),
                             (3, 3, '+79225743967', now(), 25, 1, 1, default),
                             (4, 4, '+79219223465', now(), 25, 1, 1, default),
                             (5, 5, '+79210573812', now(), 25, 1, 1, default),
                             (6, 6, '+79214886923', now(), 25, 1, 1, default),
                             (7, 7, '+79219782640', now(), 25, 1, 1, default),
                             (8, 8, '+79215642995', now(), 25, 1, 1, default);