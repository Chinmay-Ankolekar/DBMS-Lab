-- 2) Consider the following schema for Order Database:
-- SALESMAN (Salesman_id, Name, City, Commission) 
-- CUSTOMER (Customer_id, Cust_Name, City, Grade,Salesman_id)
-- ORDERS (Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id) 

show databases;

create database order_database;

use order_database;

CREATE TABLE SALESMAN (
SALESMAN_ID INT(5) PRIMARY key not null,
 NAME VARCHAR(10) NOT NULL,
CITY VARCHAR(15) NOT NULL,
 COMMISSION INT(5)
 );
 
CREATE TABLE CUSTOMER (
CUSTOMER_ID INT(5) PRIMARY KEY,
CUST_NAME VARCHAR(10) NOT NULL, 
CITY VARCHAR(10) NOT NULL,
GRADE INT(5) NOT NULL,
SALESMAN_ID INT(5),
FOREIGN KEY (SALESMAN_ID)  REFERENCES
SALESMAN(SALESMAN_ID) ON DELETE CASCADE
);

CREATE TABLE ORDERS (
ORD_NO INT(5) PRIMARY KEY, 
PURCHASE_AMT INTEGER NOT NULL,
ORD_DATE DATE NOT NULL,
CUSTOMER_ID INT(5) ,
SALESMAN_ID INT(5) ,
FOREIGN KEY (CUSTOMER_ID)  REFERENCES CUSTOMER(CUSTOMER_ID) on delete CASCADE,
FOREIGN KEY (SALESMAN_ID) REFERENCES SALESMAN(SALESMAN_ID) ON DELETE cascade
);

INSERT INTO SALESMAN VALUES (1000,'RAJ','BENGALURU',50);
INSERT INTO SALESMAN VALUES (2000,'ASHWIN','TUMKUR',30);
INSERT INTO SALESMAN VALUES (3000,'BINDU','MUMBAI',40);
INSERT INTO SALESMAN VALUES (4000,'LAVANYA','BENGALURU',40);
INSERT INTO SALESMAN VALUES (5000,'ROHIT','MYSORE',60);

INSERT INTO CUSTOMER VALUES (11,'INFOSYS','BENGALURU',5,1000);
INSERT INTO CUSTOMER VALUES (22,'TCS','BENGALURU',4,2000);
INSERT INTO CUSTOMER VALUES (33,'WIPRO','MYSORE',7,1000);
INSERT INTO CUSTOMER VALUES (44,'TCS','MYSORE',6,2000);
INSERT INTO CUSTOMER VALUES (55,'ORACLE','TUMKUR',3,3000);
INSERT INTO CUSTOMER VALUES (66,'WDC','BENGALURU',9,3000);
INSERT INTO CUSTOMER VALUES (77,'APPLE','MUMBAI',2,3000);

INSERT INTO ORDERS VALUES (1,200000,'12-04-16',11,1000);
INSERT INTO ORDERS VALUES (2,300000,'12-04-16',33,2000);
INSERT INTO ORDERS VALUES (3,400000,'15-04-17',22,1000);
INSERT INTO ORDERS VALUES (4,500000,'15-04-17',44,3000);

-- QUERIES
-- 1)Count the customers with grades above Bangalor’s average.
SELECT COUNT(CUSTOMER_ID) 
FROM CUSTOMER 
WHERE GRADE> (SELECT AVG(GRADE)
               FROM CUSTOMER 
              WHERE CITY = 'BENGALURU');
             
-- 2)Find the name and numbers of all salesmen who had more than one customer.
SELECT NAME, COUNT(CUSTOMER_ID) 
FROM SALESMAN S, CUSTOMER C 
WHERE S.SALESMAN_ID=C.SALESMAN_ID 
GROUP BY NAME 
HAVING COUNT(CUSTOMER_ID)>1 ;

-- 3)List all salesmen and indicate those who have and don’t have customers in their cities
-- (Use UNION operation).
SELECT S.Salesman_id, S.Name, S.City, 'Has Customers' AS Status
FROM SALESMAN S
WHERE S.Salesman_id IN (
    SELECT DISTINCT Salesman_id
    FROM CUSTOMER
    WHERE City = S.City
)
union
SELECT S.Salesman_id, S.Name, S.City, 'No Customers' AS Status
FROM SALESMAN S
WHERE S.Salesman_id NOT IN (
    SELECT DISTINCT Salesman_id
    FROM CUSTOMER
    WHERE City = S.City
);

-- 4)Create a view that finds the salesman who has the customer with the highest
-- order of a day.
CREATE VIEW SALES_HIGHERODER AS SELECT SALESMAN_ID, PURCHASE_AMT 
FROM ORDERS 
WHERE PURCHASE_AMT= (SELECT MAX(O.PURCHASE_AMT) FROM ORDERS O
WHERE O.ORD_DATE='12-04-16');

select * from SALES_HIGHERODER;

-- 5). Demonstrate the DELETE operation by removing salesman with id 1000. All his orders 
-- must also be deleted.
DELETE FROM SALESMAN WHERE SALESMAN_ID= 1000;

select * from SALESMAN;
select * from ORDERS;

-- 6)Create an index on (Customer (id)) to demonstrate the usage.
alter table ORDERS add index keyy (CUSTOMER_ID);

show indexes from ORDERS;
drop index key on ORDERS;




