    alter table work.working_unit drop constraint working_unit_unique;

    drop index if exists work.working_unit_date_idx;

    -- Seq Scan on working_unit  (cost=0.00..40.60 rows=10 width=12)
    --   Filter: (working_date = CURRENT_DATE)
    explain select * from work.working_unit where working_date = current_date;

-- 1. Создать индекс к какой-либо из таблиц вашей БД

    create index working_unit_date_idx on work.working_unit(working_date) tablespace fast_read_data;

-- 2. Прислать текстом результат команды explain, в которой используется данный индекс

    -- Seq Scan on working_unit  (cost=0.00..1.06 rows=1 width=12)
    --   Filter: (working_date = CURRENT_DATE)
    explain select * from work.working_unit where working_date = current_date;

    alter table work.working_unit add constraint working_unit_unique unique (department_id, working_date);

-- 3. Реализовать индекс для полнотекстового поиска

    create table catalog.full_text_search as
        select c.id as person_id,
               concat(c.first_name, ' ', c.last_name, ' ', c.security_number) as full_name,
               to_tsvector(concat(c.first_name, ' ', c.last_name, ' ', c.security_number))::tsvector as fio_lexeme
        from catalog.employee c;

    select fts.person_id, to_tsvector(fts.full_name) from catalog.full_text_search fts;

    select fts.person_id, fts.full_name, fts.fio_lexeme from catalog.full_text_search fts;

    create index fio_lexeme_idx on catalog.full_text_search using gin(fio_lexeme);
    drop index fio_lexeme_idx;
    analyze catalog.full_text_search;

    explain select fts.person_id, fts.full_name from catalog.full_text_search fts where fts.fio_lexeme @@ to_tsquery('Никита');

    drop table catalog.full_text_search;

-- 4. Реализовать индекс на часть таблицы или индекс на поле с функцией

    create index request_status_created_partial_idx on work.request(status_id) tablespace fast_read_data
        where status_id = (select  s.id from catalog.status s where s.name = 'Создан');

    create index request_status_active_partial_idx on work.request(status_id) tablespace fast_read_data
        where status_id = (select  s.id from catalog.status s where s.name = 'В пути');

    create index full_name_employee_idx on catalog.employee(concat(first_name, ' ', last_name)) tablespace fast_read_data;

-- 5. Создать индекс на несколько полей

    create index city_street_composite_idx on catalog.address(city, street) tablespace fast_read_data;

-- 6. Написать комментарии к каждому из индексов

    comment on index work.working_unit_date_idx is 'индекс для ускорения запросов на выборку рабочих смен по выбранной дате';
    comment on index work.request_status_created_partial_idx is 'частичный индекс для выборки всех созданных вызовов, на которые еще не назначена бригада СМП';
    comment on index work.request_status_active_partial_idx is 'частичный индекс для выборки всех созданных вызовов, на которые уже назначена бригада СМП';
    comment on index catalog.full_name_employee_idx is 'индекс для функции конкатенации имени и фамилии';
    comment on index catalog.city_street_composite_idx is 'композитный индекс для поиска улицы в выбранном городе';

-- 7. Описать что и как делали и с какими проблемами столкнулись

--    Не получилось создать индекс для полнотекстового поиска. Сначала думал, что когда создаю таблицу full_text_search, то
--    по умолчанию ф-я to_tsvector() создает поле типа TEXT, поэтому указал его явно при создании. Но после создания индекса
--    explain все равно показывает последовательное сканирование даже если в условии стоит точечное сравнение. Не понимаю, где ошибка.