# Consider the schema of the call detail table to partitioned primary index:
#  CREATE TABLE calldetail (
#  phone_number DECIMAL(10) NOT NULL,
#  call_start TIMESTAMP,
#  call_duration INTEGER,
#  call_description VARCHAR(30))
#  PRIMARY INDEX (phone_number, call_start);
# Demonstrate the query against this table be optimized by partitioning its primary index 
# using partitioning techniques.

create database if not exists prog6;
use prog6;

create table call_detail (
    phone_number decimal(10) not null,
    call_start timestamp,
    call_duration integer,
    call_description varchar(30),
    primary key (phone_number, call_start)
)
partition by range(unix_timestamp(call_start)) (
    partition p0 values less than (unix_timestamp('2023-01-22 00:00:00')),
    partition p1 values less than (unix_timestamp('2023-01-23 00:00:00'))
);

desc call_detail;

create index idx on call_detail(phone_number, call_start);

show index from call_detail;

insert into call_detail values
(122434231, '2023-01-20 00:00:00', 50, 'FDF'),
(122343243, '2023-01-22 10:00:00', 40, 'FFR'),
(122434230, '2023-01-11 00:00:00', 50, 'FDF'),
(122343242, '2023-01-10 10:00:00', 40, 'FFR'),
(123232323, '2022-01-11 10:00:00', 30, 'eed');


select * from call_detail;

select * from call_detail partition (p0);

select * from call_detail partition (p1);

