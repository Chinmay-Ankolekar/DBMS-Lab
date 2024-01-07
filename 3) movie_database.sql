-- 3)
-- Consider the schema for Movie Database:
-- ACTOR (Act_id, Act_Name, Act_Gender) DIRECTOR (Dir_id, Dir_Name, Dir_Phone)
-- MOVIES (Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id) 
-- MOVIE_CAST (Act_id, Mov_id, Role)
-- RATING (Mov_id, Rev_Stars) 

create database movie;

use movie;

create table actor (
  act_id int not null primary key,
  act_name varchar(20) ,
  act_gender char(1)
);

create table director (
  dir_id int not null primary key,
  dir_name varchar(20),
  dir_phone varchar(20)
);

create table movies(
  mov_id int not null primary key,
  mov_title varchar(20),
  mov_year year,
  mov_lang varchar(20),
  dir_id int references director(dir_id) on delete cascade
);

desc movie_cast;

create table movie_cast (
  act_id int ,
  mov_id int,
  role varchar(20),
  foreign key (act_id) references actor(act_id) on delete cascade,
   foreign key (mov_id) references movies(mov_id) on delete cascade
);

create table rating(
  mov_id int,
  rev_stars varchar(25),
  foreign key (mov_id) references  movies(mov_id) on delete cascade
);

INSERT INTO actor  VALUES(101,'RAHUL','M');
INSERT INTO actor  VALUES(102,'ANKITHA','F');
INSERT INTO actor  VALUES(103,'RADHIKA','F');
INSERT INTO actor  VALUES(104,'CHETHAN','M');
INSERT INTO actor  VALUES(105,'VIVAN','M');

select * from ACTOR;

INSERT INTO DIRECTOR VALUES(201,'ANUP',918181818);
INSERT INTO DIRECTOR VALUES(202,'HITCHCOCK',918181812);
INSERT INTO DIRECTOR VALUES(203,'SHASHANK',918181813);
INSERT INTO DIRECTOR VALUES(204,'STEVEN SPIELBERG',918181814);
INSERT INTO DIRECTOR VALUES(205,'ANAND',918181815);

select * from director; 

INSERT INTO MOVIES VALUES(1001,'MANASU',2017,'KANNADA',201);
INSERT INTO MOVIES VALUES(1002,'AAKASHAM',2015,'TELUGU',204);
INSERT INTO MOVIES VALUES(1003,'KALIYONA',2008,'KANNADA',201);
INSERT INTO MOVIES VALUES(1004,'WAR HORSE',2011,'ENGLISH',202);
INSERT INTO MOVIES VALUES(1005,'HOME',2012,'ENGLISH',205);

INSERT INTO MOVIE_CAST VALUES(101,1002,'HERO');
INSERT INTO MOVIE_CAST VALUES(101,1001,'HERO');
INSERT INTO MOVIE_CAST VALUES(103,1003,'HEROINE');
INSERT INTO MOVIE_CAST VALUES(103,1002,'GUEST');
INSERT INTO MOVIE_CAST VALUES(104,1004,'HERO');

select * from movie_cast;

INSERT INTO RATING VALUES(1001,4);
INSERT INTO RATING VALUES(1002,2);
INSERT INTO RATING VALUES(1003,5);
INSERT INTO RATING VALUES(1004,4);
INSERT INTO RATING VALUES(1005,3);

delete from rating where mov_id = 1002;


-- 1)List the titles of all movies directed by ‘Hitchcock’.
select mov_title 
from movies 
where dir_id = (select dir_id from director
                 where dir_name = 'HITCHCOCK') 
                 
--                 or
                 
SELECT M.Mov_Title
FROM MOVIES M
NATURAL JOIN DIRECTOR D
WHERE D.Dir_Name = 'Hitchcock';



-- 2)Find the movie names where one or more actors acted in two or more movies.
select m.mov_title
    from movies m
    natural join movie_cast mc
     where act_id in (select act_id
     from movie_cast
     group by act_id
     having count(act_id)>1)
     group by mov_title
     having count(*) > 1;

-- 3)List all actors who acted in a movie before 2000 and also in a movie after 2020 (use JOIN 
-- operation).
select distinct act_name
from (actor join movie_cast using(act_id)) join movies using(mov_id)
where mov_year not between 2000 and 2015;

-- 4)Find the title of movies and number of stars for each movie that has at least one rating and 
-- find the highest number of stars that movie received. Sort the result by movie title
SELECT MOV_TITLE,MAX(REV_STARS)
FROM MOVIES
INNER JOIN RATING USING (MOV_ID)
GROUP BY MOV_TITLE
HAVING MAX(REV_STARS)>0
ORDER BY MOV_TITLE;

-- or

select mov_title , max(rev_stars) 
from movies natural join rating
group by mov_title
order by max(rev_stars) desc;

-- #5) Update rating of all movies directed by ‘Steven Spielberg’ to 5.
update rating
set rev_stars = 5
where mov_id in ( select mov_id 
                  from director natural join movies
                  where dir_name = 'STEVEN SPIELBERG'
 );

select * from rating
order by mov_id;




 




