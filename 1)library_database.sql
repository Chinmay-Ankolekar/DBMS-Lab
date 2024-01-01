# Consider the following schema for a Library Database:
# BOOK (Book_id, Title, Publisher_Name, Pub_Year)
# BOOK_AUTHORS (Book_id, Author_Name)
# PUBLISHER (Name, Address, Phone)
# BOOK_COPIES (Book_id, Branch_id, No-of_Copies)
# BOOK_LENDING (Book_id, Branch_id, Card_No, Date_Out, Due_Date)
# LIBRARY_BRANCH (Branch_id, Branch_Name, Address)

create database library;
use library;

create table publisher(
    name varchar(20) primary key,
    address varchar(20),
    phone varchar(10)
);

create table book(
    book_id int primary key,
    title varchar(10),
    publisher_name varchar(20),
    pub_year year,
    foreign key (publisher_name) references publisher(name) on delete cascade
);

create table book_authors(
    book_id int primary key,
    author_name varchar(10),
    foreign key (book_id) references book(book_id) on delete cascade
);

create table library_branch(
    branch_id int primary key,
    branch_name varchar(20),
    address varchar(20)
);

create table book_copies(
    book_id int,
    branch_id int,
    no_of_copies int,
    foreign key (book_id) references book(book_id) on delete cascade ,
    foreign key (branch_id) references library_branch(branch_id) on delete cascade
);

create table book_lending(
    book_id int,
    branch_id int,
    card_no int,
    date_out date,
    due_date date,
    foreign key (book_id) references book(book_id) on delete cascade ,
    foreign key (branch_id) references library_branch(branch_id) on delete cascade
);

# Value Insertion

insert into publisher
    (name, address, phone)
values
    ('A', 'BENGALURU', '9879879879'),
    ('B', 'BENGALURU', '8798798791'),
    ('C', 'MYSURU',   '7897897892');

select * from publisher;

insert into book
    (book_id, title, publisher_name, pub_year)
values
    (1, 'DSA', 'A', 1998),
    (2, 'ADA', 'A', 2000),
    (3, 'DBMS', 'B', 2005),
    (4, 'SE', 'C', 2005);

select * from book;

insert into book_authors
    (book_id, author_name)
values
    (1, 'AB'),
    (2, 'CD'),
    (3, 'EF'),
    (4, 'GH');

select * from book_authors;

insert into library_branch
    (branch_id, branch_name, address)
values
    (11, 'LIB1', 'MYSURU'),
    (22, 'LIB2', 'MYSURU'),
    (33, 'LIB3', 'BENGALURU'),
    (44, 'LIB4', 'MANGALURU');

select * from library_branch;

insert into book_copies
    (book_id, branch_id, no_of_copies)
values
    (1, 11, 10),
    (1, 22, 20),
    (2, 22, 30),
    (3, 33, 40),
    (4, 44, 25),
    (4, 33, 15);

select * from book_copies;

insert into book_lending
    (book_id, branch_id, card_no, date_out, due_date)
values
    (1, 11, 1010, '2020-01-02', '2020-02-01'),
    (2, 22, 1010, '2020-03-01', '2020-04-01'),
    (3, 33, 1010, '2021-02-02', '2021-03-02'),
    (4, 44, 1010, '2022-01-02', '2022-02-01'),
    (1, 22, 1012, '2020-01-02', '2020-02-01');

select * from book_lending;

# Queries

# 1. Retrieve the details of all books in the library – id, title, name of publisher, authors,
# number of copies in each branch, etc.
select b.book_id, b.title, b.publisher_name, ba.author_name, bc.branch_id, bc.no_of_copies
from book b
natural join book_authors ba
natural join book_copies bc;

# 2. Get the particular borrowers who have borrowed more than 3 books from Jan 2020 to
# Jun 2022.
select card_no
from book_lending
where date_out between '2020-01-01' and '2022-07-31'
group by card_no
having count(*) > 3;

# 3. Delete a book in BOOK table and Update the contents of other tables using DML
# statements.
delete from book where book_id = 1;

update book
set publisher_name = 'B'
where book_id = 2;

# 4. Create the view for BOOK table based on year of publication and demonstrate its
# working with a simple query.
create view publication_year as
    select book_id, title, publisher_name, pub_year
    from book
    order by pub_year;

select * from publication_year;

select * from publication_year where pub_year = '2000';

# 5. Create a view of all books and its number of copies which are currently available in the
# Library.
create view available_books as
    select b.book_id, b.title, l.branch_id, bc.no_of_copies
    from book b
    natural join book_copies bc
    natural join library_branch l;

select * from available_books;
