-- Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти
-- запрос вернет все адреса, в значении номера дома которых есть знак дроби
select * from catalog.address a where a.building like '%/%';
-- запрос вернет все адреса, значение номера дома которых заканчивается на литеру А или Б
select * from catalog.address a where a.building similar to '%(А|Б)';

-- Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?
-- создает выборку с полным именем человека, его должностью и датой рождения
-- для inner join порядок соединения не имеет значения, запросы 1 и 2 равносильны
-- 1. select * from a inner join b on a.b_id = b.id
-- 2. select * from b inner join a on a.b_id = b.id
select concat(e.last_name, ' ', e.first_name) as full_name,
       p.name as position,
       e.birthday
       from catalog.employee e
       inner join catalog.position p on e.position_id = p.id;

-- в этом запрос порядок следования join-ов имеет значение
-- во-первых? соединения таблиц выполняются справа налево
-- во-вторых? наличие outer left join влияет на конечный результат,
-- потому что в таблице request есть кортежи без отношения request -> patient_card
-- запрос создает выборку вызовов с  телефонным номером, оператором, оформившим вызов и данными о пациенте
select r.phone_number,
       concat(e.last_name, ' ', e.first_name) as "operator",
       c.patient_name,
       c.patient_age
       from work.request r
       join catalog.employee e on r.registered_by = e.id
       left join work.patient_card c on r.patient_card_id = c.id

-- Напишите запрос на добавление данных с выводом информации о добавленных строках.
-- добавляет значачения в таблицу адресов, возвращая сгенерированные id-значения
insert into catalog.address
    values (default, 'Ярославская область', 'Ярославль', 'ул. Серенко', '25', null)
    returning address.id;

-- Напишите запрос с обновлением данные используя UPDATE FROM.
-- добавляем колонку mat_type в material и заполняем ее из material_type
alter table catalog.material add column mat_type varchar(64);
update catalog.material as m
    set mat_type = t.name
    from catalog.material_type as t
    where m.type_id = t.id;

--Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.
alter table work.patient_card rename column id to patient_card_id;
delete from work.request r join work.patient_card p using (patient_card_id)
where r.status_id = 4 or p.patient_age > 80;

-- Приведите пример использования утилиты COPY (по желанию)
-- копируем причины вызовов, у которых четный id в файл csv формата с недефолтным разделителем
copy (select c.code, c.name from catalog.cause c where (c.id % 2 = 0))
    to '/var/lib/postgresql/data/pgdata/even_causes.csv'
    with csv delimiter '|'