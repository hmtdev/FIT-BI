
--CREATE TABLE datetime_dim (
--	date_id varchar NOT NULL,
--	date_val date NULL,
--	day_of_week int4 NULL,
--	day_of_month int4 NULL,
--	day_of_year int4 NULL,
--	day_name varchar NULL,
--	week_id varchar NULL,
--	week_of_month int4 NULL,
--	week_of_year int4 NULL,
--	month_id int4 NULL,
--	month_of_year int4 NULL,
--	month_name varchar NULL,
--	semester_of_year varchar NULL,
--	quarter_id varchar NULL,
--	quarter_in_year varchar NULL,
--	year_val int4 NULL,
--	is_holiday bool NULL,
--	record_created_date date NULL,
--	record_modified_date date NULL,
--	record_by_who varchar NULL,
--	week_start_date date NULL,
--	week_end_date date NULL,
--	week_alias varchar NULL,
--	CONSTRAINT datetime_dim_pkey PRIMARY KEY (date_id)
--);

with raw_datum as (
    select '2019-05-10'::date + sequence.day datum
    from generate_series(0,3650) sequence(day)
),

data_table AS (
select to_char(datum, 'yyyymmdd') date_id
, datum date_val 

, mod(to_char(datum, 'D')::int +7 -2, 7) +1 day_of_week
, to_char(datum, 'DD')::int day_of_month
, to_char(datum, 'DDD')::int day_of_year
, to_char(datum, 'TMDay') day_name

, to_char(datum, 'yyyyWW') week_id
, to_char(datum, 'W')::int week_of_month
, to_char(datum, 'WW')::int week_of_year

, to_char(datum, 'yyyyMM')::int month_id
, to_char(datum, 'FM MM')::int month_of_year
, to_char(datum, 'Mon') month_name
, case when to_char(datum, 'MM') in ('01','02','03','04','05') then '1' 
		when to_char(datum, 'MM') in ('06','07','08')	then '2'
		else '3' end as semester_of_year 
, concat(to_char(datum, 'yyyy'), (CEILING((to_char(datum, 'MM')::float/3))::text)) quarter_id
, CEILING((to_char(datum, 'MM')::float/3))::text quarter_in_year

, to_char(datum, 'yyyy')::int year_val
, false  is_holiday
, current_timestamp record_created_date
, current_timestamp record_modified_date
, 'admin.toan' record_by_who
, datum + (0 - mod(to_char(datum, 'D')::int +7 -2, 7)) week_start_date
, datum + (6 - mod(to_char(datum, 'D')::int +7 -2, 7)) week_end_date
, concat('Week ', to_char(datum, 'FM WW'),': ',to_char(datum + (0 - mod(to_char(datum, 'D')::int +7 -2, 7)),'yyyy-mm-dd'),' to ',to_char(datum + (7 - mod(to_char(datum, 'D')::int +7 -2, 7)),'yyyy-mm-dd')) week_alias
from raw_datum
order by date_val ASC
)
INSERT INTO datetime_dim
SELECT * FROM data_table