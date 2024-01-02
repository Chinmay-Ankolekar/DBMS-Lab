# Consider the following schema for Order Database:
# SALESMAN (Salesman_id, Name, City, Commission)
# CUSTOMER (Customer_id, Cust_Name, City, Grade,Salesman_id)
# ORDERS (Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id)

create database order_database;
use order_database;

create table salesman (
    salesman_id int primary key,
    name varchar(20),
    city varchar(20),
    commission varchar(20)
);

create table customer (
    customer_id int primary key,
    cust_name varchar(20),
    city varchar(20),
    grade int,
    salesman_id int,
    foreign key (salesman_id) references salesman(salesman_id) on delete cascade
);

create table orders (
    ord_no int primary key,
    purchase_amt int,
    ord_date date,
    customer_id int,
    salesman_id int,
    foreign key (customer_id) references customer(customer_id) on delete cascade,
    foreign key (salesman_id) references salesman(salesman_id) on delete cascade
);

#value insertion

insert into salesman
    (salesman_id, name, city, commission)
values
    (1000, 'A', 'BENGALURU', '20%'),
    (1001, 'B', 'BENGALURU', '30%'),
    (1002, 'C', 'MYSURU', '10%'),
    (1003, 'D', 'MANGALURU', '50%'),
    (1004, 'E', 'HUBLI', '60%');

select * from salesman;

insert into customer
    (customer_id, cust_name, city, grade, salesman_id)
values
    (100, 'AB', 'BENGALURU', 5, 1000),
    (101, 'BC', 'BENGALURU', 6, 1001),
    (102, 'CD', 'MYSURU', 6, 1002),
    (103, 'DE', 'MYSURU', 7, 1003),
    (104, 'EF', 'HUBLI', 4, 1003);

select  * from customer;

insert into orders
    (ord_no, purchase_amt, ord_date, customer_id, salesman_id)
values
    (1, 2000, '2022-04-11', 100, 1000),
    (2, 1000, '2022-05-12', 101, 1001),
    (3, 500, '2023-10-12', 102, 1002),
    (4, 1500, '2023-10-12', 103, 1003),
    (5, 750, '2023-11-11', 104, 1003);

select * from orders;

#Queries

# 1. Count the customers with grades above Bangalor’s average.
select count(customer_id)
from customer
where grade > (select avg(grade)
                from customer
                where city = 'BENGALURU'
                );

# 2. Find the name and numbers of all salesmen who had more than one customer.
select name, count(customer_id)
from salesman s, customer c
where s.salesman_id = c.salesman_id
group by name
having count(customer_id) > 1;

# 3. List all salesmen and indicate those who have and don’t have customers in their cities
# (Use UNION operation).
select s.salesman_id, s.name, s.city, 'Has Customer' as status
from salesman s
where s.salesman_id in ( select salesman_id
                         from customer
                         where city = s.city
                        )
union
select s.salesman_id, s.name, s.city, 'No Customer' as status
from salesman s
where s.salesman_id not in ( select salesman_id
                         from customer
                         where city = s.city
                        );

# 4. Create a view that finds the salesman who has the customer with the highest order of a
# day.
create view highest_order as
select o.ord_date, s.salesman_id, s.name
from salesman s, orders o
where s.salesman_id = o.salesman_id
and o.purchase_amt = (select max(purchase_amt)
from orders c
where c.ord_date = o.ord_date);

select * from highest_order;

# 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders
# must also be deleted.
delete from salesman
where salesman_id = 1000;

select * from salesman;
select * from customer;

# 6.Create an index on ( Customer (id) ) to demonstrate the usage.
create index index_customer_id on customer(customer_id);

show index from customer;
