use sakila;
-- 1a First and last names of all actors
select first_name,last_name 
from actor;

-- 1b First and last name columns in one column
select upper(concat(first_name, " ",last_name)) as "Actor Name"
from actor;

-- 2a First name Joe of actors
select actor_id, first_name, last_name
from actor 
where first_name like "%Joe";

-- 2b All last names with GEN
select last_name, first_name
from actor
where last_name like "%Gen%";

-- 2c All last names with LI
select last_name,first_name
from actor
where last_name like "%Li%"
order by last_name, first_name;

-- 2d Show country_id and country for three countries
select country_id, country
from country 
where country in ("Afghanistan","Bangladesh","China");

-- 3a Add description column
alter table actor
add description BLOB;

-- 3b Delete description column
alter table actor
drop column description;

-- 4a Last name of actors and how many share that last name
select last_name, count(last_name) as "Number of Same Last Names"
  from actor
group by last_name;

-- 4b Last name of actors who share last names, but only show
-- ones who have at least two
select last_name, count(last_name) as "Number of Same Last Names"
from actor
group by last_name
having count(*) > 1; 

-- 4c Change Groucho Williams to Harpo Williams in actor table
update actor
set first_name = "HARPO", last_name = "WILLIAMS"
where first_name = "Groucho" and last_name = "Williams";

-- 4d  If first name of actor is Harpo, chnage to Groucho
update actor
set first_name = "Groucho"
where first_name = "Harpo"; 

-- 5a Which query to re-create address table
CREATE TABLE Address (
    address_id smallint NOT NULL AUTO_INCREMENT,
    address varchar(50) NOT NULL,
    address2 varchar(50),
    district varchar(50),
    city_id smallint,
    postal_code varchar(10),
    phone varchar(20),
    location geometry,
    last_update datetime default CURRENT_TIMESTAMP,
    PRIMARY KEY (address_id)
);

-- 6a Use JOIN staff and address tables and display
 select staff.first_name,staff.last_name, address.address
 from staff
 inner join address on staff.address_id = address.address_id;

-- 6b Join staff and payment
select staff.first_name,staff.last_name,sum(payment.amount)
	as "Total Amount Rung by Staff"
from staff
inner join payment on staff.staff_id = payment.staff_id
group by staff.staff_id;

-- 6c Join film_actor and film
select film.title,count(film_actor.actor_id) as "Number of Actors"
from film
inner join film_actor on film.film_id = film_actor.film_id
group by actor_id; 

-- 6d Number of copies of Hunchback
select count(film.title) as "Number of Hunchback Impossible"
from film
inner join inventory on inventory.film_id = film.film_id
where inventory.film_id = 439 
group by inventory.film_id;

-- 6e  Join payment and customer
select customer.first_name, customer.last_name, sum(payment.amount)
	as "Total Amount Paid by Customers"
from customer
inner join payment on customer.customer_id = payment.customer_id
group by customer.customer_id
order by customer.last_name;

-- 7a

select title from film where title LIKE "K%" or title LIKE "Q%" and language_id 
in (select language_id from language where name = "English");


-- 7b

Select first_name, last_name 
from actor
where actor_id in (Select actor_id from film_actor 
where film_id in (select film_id from film where title = "Alone Trip"));


-- 7c All Canadian customers
select customer.first_name,customer.last_name,customer.email
from customer
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
where city.country_id = 20;

-- 7d All family movies
select film.title as "Family Films"
from film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where film_category.category_id = 8; 

-- 7e Most frequently rented moves in descending order
select film.title,count(film.title) as "Most Rented"
from film
inner join inventory on film.film_id=inventory.film_id
inner join rental on rental.inventory_id = inventory.inventory_id
group by inventory.film_id
order by count(film.title) DESC;

-- 7f How much money did each store make?
select store.store_id, sum(payment.amount) 
from payment 
join staff on payment.staff_id = staff.staff_id 
join store on store.store_id = staff.store_id group by store.store_id;

-- 7g Show for each store its' ID, city, and country
select store.store_id, city.city, country.country 
from store 
join address on store.address_id = address.address_id 
join city on address.city_id = city.city_id 
join country on city.country_id = country.country_id group by store.store_id;

-- 7h Top 5 genres by revenue
select category.name, sum(payment.amount) 
from category 
join film_category on category.category_id = film_category.category_id 
join inventory on inventory.film_id = film_category.film_id 
join rental on rental.inventory_id = inventory.inventory_id 
join payment on rental.rental_id = payment.rental_id 
group by category.name order by sum(payment.amount) DESC;

-- 8a View top 5 genres
CREATE VIEW Top_Gross_Genre 
AS select category.name, sum(payment.amount) as 'Total_Revenue' 
from category join film_category 
on category.category_id = film_category.category_id 
join inventory on inventory.film_id = film_category.film_id 
join rental on rental.inventory_id = inventory.inventory_id 
join payment on rental.rental_id = payment.rental_id 
group by category.name order by sum(payment.amount) DESC;

-- 8b Display view for above
select * from Top_Gross_Genre;

-- 8c Delete view
Drop view top_gross_genre;
