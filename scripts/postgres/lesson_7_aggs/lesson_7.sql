-- 1. Создайте таблицу
create table if not exists statistic
(
    player_name varchar(100) not null,
    player_id   int          not null,
    year_game   smallint     not null check (year_game > 0),
    points      decimal(12, 2) check (points >= 0),
    primary key (player_name, year_game)
);

-- 2. Заполните таблицу данными
insert into statistic(player_name, player_id, year_game, points)
values ('Mike', 1, 2018, 18),
       ('Jack', 2, 2018, 14),
       ('Jackie', 3, 2018, 30),
       ('Jackie', 3, 2018, 99),
       ('Jet', 4, 2018, 30),
       ('Luke', 1, 2019, 16),
       ('Mike', 2, 2019, 14),
       ('Jack', 3, 2019, 15),
       ('Jackie', 4, 2019, 28),
       ('Jet', 5, 2019, 25),
       ('Luke', 1, 2020, 19),
       ('Mike', 2, 2020, 17),
       ('Jack', 3, 2020, 18),
       ('Jackie', 4, 2020, 29),
       ('Jet', 5, 2020, 27)
on conflict do nothing;

-- 3. Написать запрос суммы очков с группировкой и сортировкой по годам
select year_game, sum(points)
from statistic
group by year_game
order by year_game;

-- 4. Написать cte, показывающее тоже самое
with year_scores as (select year_game as year, points as scores
                     from statistic
                     order by year_game)
select ysc.year, sum(ysc.scores)
from year_scores as ysc
group by ysc.year;

-- 5. Используя функцию LAG вывести кол-во очков по всем игрокам за текущий код и за предыдущий.
--    (добавил еще для сравнения следующий год)
select year_game,
       lag(sum(points)) over (order by year_game)  as previous_year_pts,
       sum(points)                                 as current_year_pts,
       lead(sum(points)) over (order by year_game) as next_year_pts
from statistic
group by year_game;