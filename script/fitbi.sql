
-- DROP SCHEMA fitbi;

CREATE SCHEMA fitbi AUTHORIZATION pg_database_owner;

-- DROP SEQUENCE fitbi.enrollment_primary_key_seq;

CREATE SEQUENCE fitbi.enrollment_primary_key_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE fitbi.lecturer_scientific_work_work_id_seq;

CREATE SEQUENCE fitbi.lecturer_scientific_work_work_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE fitbi.score_fact_score_id_seq;

CREATE SEQUENCE fitbi.score_fact_score_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- fitbi."class" definition

-- Drop table

-- DROP TABLE fitbi."class";

CREATE TABLE fitbi."class" (
	class_id int8 NOT NULL,
	class_name varchar NULL,
	last_modified_date date NULL,
	CONSTRAINT class_pk PRIMARY KEY (class_id)
);


-- fitbi.course definition

-- Drop table

-- DROP TABLE fitbi.course;

CREATE TABLE fitbi.course (
	course_id int4 NOT NULL,
	course_name varchar NULL,
	desc_course varchar NULL,
	total_credit int4 NULL,
	theory_credit int4 NULL,
	practice_credit int4 NULL,
	self_study_credit int4 NULL,
	subject_group varchar NULL,
	is_mandatory bool NULL,
	course_name_eng varchar(255) NULL,
	last_modified_date date NULL,
	CONSTRAINT course_pkey PRIMARY KEY (course_id)
);


-- fitbi.datetime_dim definition

-- Drop table

-- DROP TABLE fitbi.datetime_dim;

-- CREATE TABLE fitbi.datetime_dim (
-- 	date_id varchar NOT NULL,
-- 	date_val date NULL,
-- 	day_of_week int4 NULL,
-- 	day_of_month int4 NULL,
-- 	day_of_year int4 NULL,
-- 	day_name varchar NULL,
-- 	week_id int4 NULL,
-- 	week_of_month int4 NULL,
-- 	week_of_year int4 NULL,
-- 	month_id int4 NULL,
-- 	month_of_year int4 NULL,
-- 	month_name varchar NULL,
-- 	semester_of_year int4 NULL,
-- 	quarter_id int4 NULL,
-- 	quarter_in_year varchar NULL,
-- 	year_val int4 NULL,
-- 	is_holiday bool NULL,
-- 	record_created_date date NULL,
-- 	record_modified_date date NULL,
-- 	record_by_who varchar NULL,
-- 	week_start_date date NULL,
-- 	week_end_date date NULL,
-- 	week_alias varchar NULL,
-- 	CONSTRAINT datetime_dim_pkey PRIMARY KEY (date_id)
-- );


-- fitbi.lecturer definition

-- Drop table

-- DROP TABLE fitbi.lecturer;

CREATE TABLE fitbi.lecturer (
	lecturer_id int8 NOT NULL,
	lecturer_name varchar NULL,
	year_of_birth int8 NULL,
	"position" varchar NULL,
	academic_title varchar NULL,
	academic_country varchar NULL,
	graduatated_year int4 NULL,
	start_work_year int4 NULL,
	work_place varchar NULL,
	major varchar NULL,
	insurance_id int4 NULL,
	time_teaching int4 NULL,
	contract_type varchar NULL,
	orcid varchar(50) NULL,
	last_modified_date date NULL,
	CONSTRAINT lecturer_id_pkey PRIMARY KEY (lecturer_id)
);

-- Table Triggers
-- fitbi."program" definition

-- Drop table

-- DROP TABLE fitbi."program";

CREATE TABLE fitbi."program" (
	program_id varchar(22) NOT NULL,
	cohort int4 NULL,
	start_date date NULL,
	end_date date NULL,
	graduation_time date NULL,
	program_length float4 NULL,
	extra_time float4 NULL,
	"key" varchar(22) NULL,
	major_eng varchar(50) NULL,
	last_modified_date date NULL,
	major varchar(50) NULL,
	CONSTRAINT program_pkey PRIMARY KEY (program_id)
);


-- fitbi.score_type_mapper definition

-- Drop table

-- DROP TABLE fitbi.score_type_mapper;

CREATE TABLE fitbi.score_type_mapper (
	score_key varchar(50) NULL,
	academic_rank varchar(50) NULL,
	min_score_10 float4 NULL,
	max_score_10 float4 NULL,
	score_4 float4 NULL
);


-- fitbi.student definition

-- Drop table

-- DROP TABLE fitbi.student;

CREATE TABLE fitbi.student (
	student_id int4 NOT NULL,
	edu_mail varchar NULL,
	class_name varchar NULL,
	student_name varchar NULL,
	national_id varchar NULL,
	student_dob date NULL,
	key_year varchar NULL,
	student_major varchar NULL,
	class_of_major varchar(27) NULL,
	gender varchar(10) NULL,
	last_modified_date date NULL,
	CONSTRAINT student_pkey PRIMARY KEY (student_id)
);


-- fitbi.course_outcome definition

-- Drop table

-- DROP TABLE fitbi.course_outcome;

CREATE TABLE fitbi.course_outcome (
	course_outcome_id int4 NOT NULL,
	course_id int4 NULL,
	"CLO" varchar NULL,
	standard_outcome varchar NULL,
	"PLO" varchar NULL,
	teaching_method varchar NULL,
	self_study_guide varchar NULL,
	last_modified_date date NULL,
	CONSTRAINT course_outcome_pkey PRIMARY KEY (course_outcome_id),
	CONSTRAINT course_outcome_course_id_fkey FOREIGN KEY (course_id) REFERENCES fitbi.course(course_id)
);


-- fitbi.course_syllabus definition

-- Drop table

-- DROP TABLE fitbi.course_syllabus;

CREATE TABLE fitbi.course_syllabus (
	course_syllabus_id int4 NOT NULL,
	course_id int4 NULL,
	syllabus varchar NULL,
	"CLOs" varchar NULL,
	last_modified_date date NULL,
	CONSTRAINT course_syllabus_pkey PRIMARY KEY (course_syllabus_id),
	CONSTRAINT course_syllabus_course_id_fkey FOREIGN KEY (course_id) REFERENCES fitbi.course(course_id)
);


-- fitbi.enrollment_fact definition

-- Drop table

-- DROP TABLE fitbi.enrollment_fact;

CREATE TABLE fitbi.enrollment_fact (
	enrollment_id int8 NOT NULL DEFAULT nextval('enrollment_primary_key_seq'::regclass),
	instruction_id int4 NULL,
	program_id varchar(22) NULL,
	course_id int4 NULL,
	student_id int4 NULL,
	lecturer_id int8 NULL,
	enrollment_time date NULL,
	enrollment_end_time date NULL,
	enrollment_start_time date NULL,
	enrollment_class varchar NULL,
	course_name varchar NULL,
	enrollment_status varchar NULL,
	semester_of_year int4 NULL,
	total_credit int4 NULL,
	p_condition varchar NULL,
	num_lab_session int4 NULL,
	num_theory_session int4 NULL,
	semester_of_program int4 NULL,
	last_modified_date date NULL,
	etl_date date NULL,
	class_id int4 NULL,
	CONSTRAINT enrollment_fact_pkey PRIMARY KEY (enrollment_id),
	CONSTRAINT enrollment_fact_semester_of_program_check CHECK (((semester_of_program > 0) AND (semester_of_program <= 10))),
	CONSTRAINT enrollment_fact_course_id_fkey FOREIGN KEY (course_id) REFERENCES fitbi.course(course_id),
	CONSTRAINT enrollment_fact_program_id_fkey FOREIGN KEY (program_id) REFERENCES fitbi."program"(program_id),
	CONSTRAINT enrollment_fact_student_id_fkey FOREIGN KEY (student_id) REFERENCES fitbi.student(student_id),
	CONSTRAINT fk_enrollment_fact_class FOREIGN KEY (class_id) REFERENCES fitbi."class"(class_id)
);


-- fitbi.instruction_fact definition

-- Drop table

-- DROP TABLE fitbi.instruction_fact;

CREATE TABLE fitbi.instruction_fact (
	instruction_id int8 NOT NULL,
	program_id varchar NULL,
	course_id int8 NULL,
	lecturer_id int8 NULL,
	semester_of_program int4 NULL,
	class_name varchar NULL,
	lecturer_name varchar NULL,
	course_name varchar NULL,
	is_required bool NULL,
	total_credit int4 NULL,
	instruction_status varchar NULL,
	instruction_allocate date NULL,
	instruction_time_end date NULL,
	instruction_time_start date NULL,
	last_modified_date date NULL,
	etl_date date NULL,
	p_lecturer_id int8 NULL,
	class_id int4 NULL,
	CONSTRAINT instruction_id_pkey PRIMARY KEY (instruction_id),
	CONSTRAINT fk_instruction_fact_class FOREIGN KEY (class_id) REFERENCES fitbi."class"(class_id),
	CONSTRAINT instruction_fact_course_id_fkey FOREIGN KEY (course_id) REFERENCES fitbi.course(course_id),
	CONSTRAINT instruction_fact_lecturer_id_fkey FOREIGN KEY (lecturer_id) REFERENCES fitbi.lecturer(lecturer_id),
	CONSTRAINT instruction_fact_program_id_fkey FOREIGN KEY (program_id) REFERENCES fitbi."program"(program_id)
);


-- fitbi.lecturer_scientific_work definition

-- Drop table

-- DROP TABLE fitbi.lecturer_scientific_work;

CREATE TABLE fitbi.lecturer_scientific_work (
	work_id serial4 NOT NULL,
	orcid varchar NULL,
	work_title varchar NULL,
	general_info varchar NULL,
	publish_date varchar NULL,
	contributors varchar NULL,
	work_type varchar NULL,
	identifiers varchar NULL,
	url varchar NULL,
	lecturer_id int4 NULL,
	last_modified_date date NULL,
	CONSTRAINT scientific_work_pkey PRIMARY KEY (work_id),
	CONSTRAINT lecturer_scientific_work_lecturer_id_fkey FOREIGN KEY (lecturer_id) REFERENCES fitbi.lecturer(lecturer_id)
);


-- fitbi.program_instruction definition

-- Drop table

-- DROP TABLE fitbi.program_instruction;

CREATE TABLE fitbi.program_instruction (
	"_id" int8 NULL,
	program_id varchar(22) NULL,
	course_id int8 NULL,
	lecturer_id int8 NULL,
	semester_of_program int4 NULL,
	class_name varchar NULL,
	lecturer_name varchar NULL,
	course_name varchar NULL,
	is_required bool NULL,
	total_credit int4 NULL,
	p_lecturer_id int8 NULL,
	cohort int4 NULL,
	major varchar(50) NULL,
	last_modified_date date NULL,
	CONSTRAINT program_instruction_fk FOREIGN KEY (program_id) REFERENCES fitbi."program"(program_id)
);


-- fitbi.score_fact definition

-- Drop table

-- DROP TABLE fitbi.score_fact;

CREATE TABLE fitbi.score_fact (
	score_id serial4 NOT NULL,
	course_id int4 NULL,
	instruction_id int4 NULL,
	student_id int4 NULL,
	semester_of_program int4 NULL,
	course_name varchar NULL,
	total_credit int4 NULL,
	regular_score_1 float8 NULL,
	regular_score_2 float8 NULL,
	regular_score_3 float8 NULL,
	mid_term_score float8 NULL,
	final_term_score float8 NULL,
	practice_score_1 float8 NULL,
	practice_score_2 float8 NULL,
	practice_score_3 float8 NULL,
	final_score float8 NULL,
	final_score_4 float8 NULL,
	final_score_letter varchar NULL,
	academic_rank varchar NULL,
	is_practice varchar NULL,
	last_modified_date date NULL,
	etl_date date NULL,
	class_id int4 NULL,
	program_id varchar(22) NULL,
	lecturer_id int8 NULL,
	CONSTRAINT score_fact_pkey PRIMARY KEY (score_id),
	CONSTRAINT fk_score_fact_class FOREIGN KEY (class_id) REFERENCES fitbi."class"(class_id),
	CONSTRAINT fk_score_fact_lecturer FOREIGN KEY (lecturer_id) REFERENCES fitbi.lecturer(lecturer_id),
	CONSTRAINT fk_score_fact_program FOREIGN KEY (program_id) REFERENCES fitbi."program"(program_id),
	CONSTRAINT score_fact_course_id_fkey FOREIGN KEY (course_id) REFERENCES fitbi.course(course_id),
	CONSTRAINT score_fact_student_id_fkey FOREIGN KEY (student_id) REFERENCES fitbi.student(student_id)
);


