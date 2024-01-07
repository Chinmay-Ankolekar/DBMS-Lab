-- Consider the schema for Company Database:
-- EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
-- DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate)
-- DLOCATION (DNo,DLoc)
-- PROJECT (PNo, PName, PLocation, DNo)
-- WORKS_ON (SSN, PNo, Hours)

create database company;
use company;

create table department (
    dno varchar(20) primary key,
    dname varchar(20),
    mgrssn varchar(20),
    mgrStartDate date
);

desc department;

create table employee (
    ssn varchar(20) primary key,
    name varchar(20),
    address varchar(30),
    sex char(1),
    salary int,
    superssn varchar(20),
    dno varchar(20),
    foreign key (superssn) references employee(ssn),
    foreign key (dno) references department(dno)
);

desc employee;

alter table department
add foreign key (mgrssn) references employee(ssn);

create table dlocation (
    dno varchar(20),
    dloc varchar(20),
    foreign key (dno) references department(dno)
);

create table project (
    pno int primary key,
    pname varchar(20),
    plocation varchar(20),
    dno varchar(20),
    foreign key (dno) references department(dno)
);

create table works_on (
    ssn varchar(20),
    pno int,
    hours int,
    foreign key (ssn) references employee(ssn),
    foreign key (pno) references project(pno)
);

#Insertion

-- Insert into EMPLOYEE
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc01','ben scott','bangalore','m', 450000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc02','harry smith','bangalore','m', 500000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc03','lean baker','bangalore','m', 700000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc04','martin scott','mysore','m', 500000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc05','ravan hegde','mangalore','m', 650000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc06','girish hosur','mysore','m', 450000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc07','neela sharma','bangalore','f', 800000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc08','adya kolar','mangalore','f', 350000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc09','prasanna kumar','mangalore','m', 300000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc10','veena kumari','mysore','m', 600000);
INSERT INTO employee (ssn, name, address, sex, salary) VALUES
 ('abc11','deepak raj','bangalore','m', 500000);

-- Select from EMPLOYEE
SELECT * FROM employee;

-- Insert into DEPARTMENT
INSERT INTO department VALUES ('1','accounts','abc09', '2016-01-03');
INSERT INTO department VALUES ('2','it','abc11', '2017-02-04');
INSERT INTO department VALUES ('3','hr','abc01', '2016-04-05');
INSERT INTO department VALUES ('4','helpdesk', 'abc10', '2017-06-03');
INSERT INTO department VALUES ('5','sales','abc06', '2017-01-08');

-- Select from DEPARTMENT
SELECT * FROM department;

-- Update EMPLOYEE
UPDATE employee SET
superssn=NULL, dno='3'
WHERE ssn='abc01';

UPDATE employee SET
superssn='abc03', dno='5'
WHERE ssn='abc02';

UPDATE employee SET
superssn='abc04', dno='5'
WHERE ssn='abc03';

UPDATE employee SET
superssn='abc06', dno='5'
WHERE ssn='abc04';

UPDATE employee SET
dno='5', superssn='abc06'
WHERE ssn='abc05';

UPDATE employee SET
dno='5', superssn='abc07'
WHERE ssn='abc06';

UPDATE employee SET
dno='5', superssn=NULL
WHERE ssn='abc07';

UPDATE employee SET
dno='1', superssn='abc09'
WHERE ssn='abc08';

UPDATE employee SET
dno='1', superssn=NULL
WHERE ssn='abc09';

UPDATE employee SET
dno='4', superssn=NULL
WHERE ssn='abc10';

UPDATE employee SET
dno='2', superssn=NULL
WHERE ssn='abc11';

-- Select from EMPLOYEE
SELECT * FROM employee;

-- Insert into DLOCATION
INSERT INTO dlocation VALUES ('1', 'bengaluru');
INSERT INTO dlocation VALUES ('2', 'bengaluru');
INSERT INTO dlocation VALUES ('3', 'bengaluru');
INSERT INTO dlocation VALUES ('4', 'mysore');
INSERT INTO dlocation VALUES ('5', 'mysore');

-- Select from DLOCATION
SELECT * FROM dlocation;

-- Insert into PROJECT
INSERT INTO project VALUES (1000,'iot','bengaluru','5');
INSERT INTO project VALUES (1001,'cloud','bengaluru','5');
INSERT INTO project VALUES (1002,'bigdata','bengaluru','5');
INSERT INTO project VALUES (1003,'sensors','bengaluru','3');
INSERT INTO project VALUES (1004,'bank management','bengaluru','1');
INSERT INTO project VALUES (1005,'salary management','bangalore','1');
INSERT INTO project VALUES (1006,'openstack','bengaluru','4');
INSERT INTO project VALUES (1007,'smart city','bengaluru','2');

-- Select from PROJECT
SELECT * FROM project;

-- Insert into WORKS_ON
INSERT INTO works_on VALUES ('abc02', 1000, 4);
INSERT INTO works_on VALUES ('abc02', 1001, 6);
INSERT INTO works_on VALUES ('abc02', 1002, 8);
INSERT INTO works_on VALUES ('abc03', 1000, 10);
INSERT INTO works_on VALUES ('abc05', 1000, 3);
INSERT INTO works_on VALUES ('abc06', 1001, 4);
INSERT INTO works_on VALUES ('abc07', 1002, 5);
INSERT INTO works_on VALUES ('abc04', 1002, 6);
INSERT INTO works_on VALUES ('abc01', 1003, 7);
INSERT INTO works_on VALUES ('abc08', 1004, 5);
INSERT INTO works_on VALUES ('abc09', 1005, 6);
INSERT INTO works_on VALUES ('abc10', 1006, 4);
INSERT INTO works_on VALUES ('abc11', 1007, 10);

-- Select from WORKS_ON
SELECT * FROM works_on;

#Queries:

# 1. Make a list of all project numbers for projects that involve an employee whose last name
# is ‘Scott’, either as a worker or as a manager of the department that controls the project.
SELECT DISTINCT p.pno
FROM project p, department d, employee e
WHERE p.dno = d.dno
AND d.mgrssn = e.ssn
AND e.name LIKE '%scott'
UNION
SELECT DISTINCT p1.pno
FROM project p1, works_on w, employee e1
WHERE p1.pno = w.pno
AND e1.ssn = w.ssn
AND e1.name LIKE '%scott';

# 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10
 # percent raise.
select e.name, 1.1 * e.salary as incr_sal
from employee e, works_on w, project p
where e.ssn = w.ssn
and w.pno = p.pno
and p.pname = 'iot';

# 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the
# maximum salary, the minimum salary, and the average salary in this department
select sum(e.salary), max(e.salary), min(e.salary), avg(e.salary)
from employee e, department d
where e.dno = d.dno
and d.dname = 'accounts';

# 4. Retrieve the name of each employee who works on all the projects controlled by
# department number.5 (use NOT EXISTS operator).
SELECT e.name
FROM employee e
WHERE NOT EXISTS (
    SELECT pno
    FROM project
    WHERE dno = '5' AND pno NOT IN (
        SELECT pno
        FROM works_on
        WHERE e.ssn = ssn
    )
);

#5. For each department that has more than five employees,
# retrieve the department number and the number of its employees who are making more than
# Rs.6, 00,000.
SELECT d.dno, count(*)
FROM department d, employee e
WHERE d.dno = e.dno
AND e.salary > 600000
AND d.dno IN (
    SELECT e1.dno
    FROM employee e1
    GROUP BY e1.dno
    HAVING COUNT(*) > 5
)
GROUP BY d.dno;


/*
test 
create database company_test;
use  company_test;

create table department (
    dno int primary key,
    dname varchar(20),
    mgrssn varchar(10),
    mgrstartdate date
);

create table employee (
    ssn varchar(10) primary key,
    name varchar(20),
    address varchar(20),
    sex char(1),
    salary int,
    superssn varchar(10),
    dno int,
    foreign key (dno) references department(dno) on delete cascade,
    foreign key (superssn) references employee(ssn) on delete cascade
);

desc department;

alter table department
add foreign key (mgrssn) references employee(ssn) on delete cascade;

create table dlocation (
    dno int,
    dloc varchar(20),
 foreign key (dno) references department(dno) on delete cascade
);

create table project (
    pno int primary key,
    pname varchar(20),
    plocation varchar(20),
    dno int,
    foreign key (dno) references department(dno) on delete cascade
);

create table works_on (
    ssn varchar(20),
    pno int,
    hours int,
    foreign key (ssn) references employee(ssn) on delete cascade,
    foreign key (pno) references project(pno) on delete cascade
);

drop table works_on;

insert into employee
    (ssn, name, address, sex, salary)
values
    ('a1', 'charles scott', 'beng', 'm', 500000),
    ('a2', 'michael scott', 'mys', 'm', 700000),
    ('a3', 'anhi', 'beng', 'm', 100000),
    ('a4', 'nayana', 'mang', 'f', 890000),
    ('a5', 'gayana', 'hubli', 'f', 788888);

select * from employee;

insert into department (dno, dname, mgrssn, mgrstartdate)
values
    (1, 'accounts', 'a1', '2023-01-01'),
    (2, 'testing', 'a2', '2023-01-01'),
    (3, 'f-engineer', 'a3', '2023-01-01'),
    (4, 'b-engineer', 'a4', '2023-01-01'),
    (5, 'db-admin', 'a5', '2023-01-01');

select * from department;

update employee
set superssn = null , dno ='5'
where ssn = 'a1';
update employee
set superssn = 'a1' , dno ='3'
where ssn = 'a2';
update employee
set superssn = 'a2' , dno ='5'
where ssn = 'a3';
update employee
set superssn = 'a1' , dno ='2'
where ssn = 'a4';
update employee
set superssn = 'a4' , dno ='1'
where ssn = 'a5';

insert into dlocation (dno, dloc)
values
    (1, 'beng'),
    (2,'mys'),
    (3, 'mys'),
    (4, 'hubli'),
    (5, 'beng');

select * from dlocation;

insert into project (pno, pname, plocation, dno)
values
    (101, 'iot', 'beng', 1),
    (102, 'sensors', 'mys', 2),
    (103, 'prog1', 'mys', 5),
    (104, 'prog2', 'beng', 5),
    (105, 'prog3', 'mys', 5);

insert into project (pno, pname, plocation, dno)
values (106, 'p6', 'mys', 3);

insert into works_on (ssn, pno, hours)
values
    ('a2', 106, 70),
    ('a2', 101, 30),
    ('a1', 103, 45);

insert into works_on (ssn, pno, hours)
values
    ('a3',101, 30),
    ('a4', 101, 30);

insert into works_on(ssn, pno, hours) values
    ('a5', 103, 30),
    ('a5', 104, 30),
    ('a5', 105, 30);

#q1
select distinct p.pno
from project p,employee e, department d
where p.dno = d.dno and
      d.mgrssn = e.ssn and
      e.name like '%scott'
union
select distinct p.pno
from project p,employee e, works_on w
where w.pno = p.pno and
      w.ssn = e.ssn and
      e.name like '%scott';

#2
select e.name,e.ssn, 1.1*e.salary
from employee e, project p, works_on w
where p.pno = w.pno and
      e.ssn = w.ssn and
      p.pname = 'iot';

#3
select max(employee.salary),min(employee.salary),avg(employee.salary),sum(employee.salary)
from employee , department d
where employee.dno = d.dno and
      d.dname = 'accounts';

#4
select e.name, e.ssn
from employee e
where not exists(
    select pno
    from project
    where dno = '5' and pno not in (
        select pno
        from works_on
        where e.ssn = ssn
        )
);

#5
update employee
set salary = 1000000
where ssn = 'a3';

select d.dno, count(*) as count
from department d , employee e
where d.dno = e.dno
and e.salary > 600000
and d.dno in (
    select e1.dno
    from employee e1
    group by e1.dno
    having count(*)>1
    )
group by d.dno;
*/
