create database college;

use college;

create table STUDENT(
 USN VARCHAR(20) primary key,
 SNAME VARCHAR(20),
 ADDRESS VARCHAR(40),
 PHONE VARCHAR(10),
 GENDER CHAR
);

desc STUDENT;

create TABLE SEMSEC(
  SSID VARCHAR(20) primary KEY,
  SEM INT,
  SEC CHAR 
);

create TABLE CLASS (
   USN VARCHAR(20),
   SSID VARCHAR(20),
   foreign key (USN) references STUDENT(USN) on delete cascade,
   foreign key (SSID) references SEMSEC(SSID) on delete CASCADE
);

create table SUBJECT (
   SUBCODE VARCHAR(10) primary key,
   TITLE VARCHAR(10),
   SEM INT,
   CREDITS INT
);

create table IAMARKS (
   USN VARCHAR(20),
   SUBCODE VARCHAR(10),
   SSID VARCHAR(20),
   TEST1 INT,
   TEST2 INT,
   TEST3 INT,
   FINALIA INT,
   foreign key (USN) references STUDENT(USN) on delete cascade,
   foreign key (SSID) references SEMSEC(SSID) on delete cascade,
   foreign key (SUBCODE) references SUBJECT(SUBCODE) on delete CASCADE
);

desc student ;

insert into STUDENT
values (
    '01JST21IS001', 'ABHIBHAVA','UK', '1111111111', 'M' );
   
   
 insert into STUDENT
values   ('01JST21IS002', 'ABHILASH','MYS', '2222222222', 'M');
 insert into STUDENT
values    ('01JST21IS003', 'ADITHYA','MYS', '4545454545', 'M');
  insert into STUDENT
values    ('01JST21CS001', 'AJITH','BLR', '5656565656', 'M');
insert into STUDENT
values      ('01JST21EC001', 'RAGHAV','UK', '9898989898', 'M');
 insert into STUDENT
values     ('01JST21IS005', 'SHRUTI','CKM', '6565676767', 'F');

desc semsec;

insert into SEMSEC values ('5B', 5, 'B');
insert into SEMSEC values ('3A', 3, 'A');
insert into SEMSEC values ('4B', 4, 'B');
insert into SEMSEC values ('2A', 2, 'A');
insert into SEMSEC values ('1D', 1, 'D');
insert into SEMSEC values ('5A', 5, 'A');

select * from SEMSEC;
select * from STUDENT;

insert into CLASS values (
  '01JST21IS001', '5B'
);
insert into CLASS values (
  '01JST21IS002', '5B'
);
insert into CLASS values (
  '01JST21IS003', '5A'
);
insert into CLASS values (
  '01JST21CS001', '1D'
);
insert into CLASS values ( 
  '01JST21EC001', '2A'
);
insert into CLASS values (
  '01JST21IS005', '5B'
)

insert into SUBJECT values (
  '15IS411', 'DBMS', 5, 4
);
insert into SUBJECT values (
  '15IS34', 'CN', 5, 4
);
insert into SUBJECT values (
  '15IS456', 'CO', 3, 4
);
insert into SUBJECT values (
  '15IS23', 'DSA', 2, 3
);
insert into SUBJECT values (
  '15IS89', 'FLAT', 1, 1.5
);

delete from SUBJECT where SUBCODE = 'I5IS89';

insert into IAMARKS values (
  '01JST21IS001', '15IS411', '5B', 19, 19, 19, 19
);
insert into IAMARKS values (
  '01JST21IS002', '15IS34', '5B', 18, 18, 17, 18
);
insert into IAMARKS values (
  '01JST21IS002', '15IS411', '5B', 16, 15, 17, 15
);
insert into IAMARKS values (
  '01JST21EC001', '15IS23', '2A', 13, 11, 9, 10
);

delete from IAMARKS where USN = '01JST21EC001';

insert into IAMARKS values (
  '01JST21CS001', '15IS89', '1D', 9, 19, 20, 15
);

select * from IAMARKS;
select * from CLASS;


-- QUERIES
-- 1). List all the student details studying in fifth semester ‘B’ section
SELECT S.*,SS.SEM,SS.SEC
     FROM STUDENT S,SEMSEC SS,CLASS C WHERE S.USN=C.USN
     AND SS.SSID=C.SSID
     AND SS.SEM=5 AND SS.SEC='B';
    
--     OR
    
SELECT S.USN, S.SName, S.Address, S.Phone, S.Gender
FROM STUDENT S
NATURAL JOIN CLASS C
NATURAL JOIN SEMSEC SS
WHERE SS.Sem = 5 AND SS.Sec = 'B';

-- 2)Compute the total number of male and female students in each semester and in each section
SELECT SS.SEM,SS.SEC,S.GENDER,COUNT(S.GENDER) AS COUNT 
FROM STUDENT S,SEMSEC SS,CLASS C 
WHERE S.USN=C.USN
AND SS.SSID=C.SSID 
GROUP BY SS.SEM,SS.SEC,S.GENDER
ORDER BY SEM;

-- OR

SELECT SS.Sem, SS.Sec, S.Gender, COUNT(*) as TotalStudents
FROM STUDENT S
NATURAL JOIN CLASS C
NATURAL JOIN SEMSEC SS
GROUP BY SS.Sem, SS.Sec, S.Gender
ORDER BY SS.Sem;

-- 3)Create a view of Event 1 marks of student USN ‘01JST IS ’ in all subjects.
CREATE VIEW STUDENT_TEST1_MARKS_VIEW
     AS SELECT TEST1, SUBCODE
     FROM IAMARKS
     WHERE USN='01JST21IS002';
  
     
SELECT * FROM STUDENT_TEST1_MARKS_VIEW; 

-- 4)Calculate the Final IA (average of best two test marks) and update the corresponding table 
-- for all students.
UPDATE IAMARKS I
SET I.FinalIA = (I.Test1 + I.Test2 + I.Test3 - LEAST(I.Test1, I.Test2, I.Test3)) / 2

SELECT * FROM IAMARKS;

-- 5) Categorize students based on the following criterion:
-- If Final IA = 17 to 20 then CAT =‘Outstanding’ 
-- If Final IA = 12 to 16 then CAT = ‘Average’
--  If Final IA< 12 then CAT = ‘Weak’
-- Give these details only for 8th semester A, B, and C section students.

SELECT S.USN, S.SName, S.Gender, SS.Sem, SS.Sec,
    CASE
        WHEN I.FinalIA BETWEEN 17 AND 20 THEN 'Outstanding'
        WHEN I.FinalIA BETWEEN 12 AND 16 THEN 'Average'
        WHEN I.FinalIA < 12 THEN 'Weak'
    END AS CAT
FROM STUDENT S
NATURAL JOIN CLASS C
NATURAL JOIN SEMSEC SS
NATURAL JOIN IAMARKS I
WHERE SS.Sem = 5 AND SS.Sec IN ('A', 'B', 'C');




    













