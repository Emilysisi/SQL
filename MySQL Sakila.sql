
USE SAKILA


1--Which actors have the first name 'Scarlett'

select *
from actor
where first_name = 'Scarlett'

2--Which actors have the last name 'Johansson'

select *
from actor 
where last_name = 'Johansson'
address
3--How many distinct actors last names are there?

Select count(distinct last_name)
from actor

4--Which last names are not repeated?

Select last_name, count(distinct first_name)
From actor
Group by last_name
Having count(distinct first_name) = 1

5--Which last names appear more than once?

Select last_name, count(distinct first_name)
From actor
Group by last_name
Having count(distinct first_name) > 1

6--Which actor has appeared in the most films?

set @max_film=
(
select max(count_film) as max_film
from(Select b.first_name, b.last_name, count(distinct film_id) as count_film
from film_actor a
join actor b
on a.actor_id = b.actor_id
group by b.actor_id
order by count_film
)temp
);

select @max_film

Select b.first_name, b.last_name, count(distinct film_id) as count_film
from film_actor a
join actor b
on a.actor_id = b.actor_id
group by b.actor_id
having count_film = @max_film


7--Is 'Academy Dinosaur' available for rent from Store 1?

select b.film_id, b.title, a.store_id 
from inventory a
join film b
on a.film_id = b.film_id
where title = 'ACADEMY DINOSAUR' and store_id = '1'


8--When is 'Academy Dinosaur' due?

select film_id, inventory_id, title,rental_date,rental_duration,DATE_ADD(rental_date,INTERVAL 6 DAY)as duedate
from 
(select 
a.film_id, a.title, a.rental_duration, c.rental_date, c.inventory_id
from 
film a join inventory b on a.film_id = b.film_id
join rental c on b.inventory_id = c.inventory_id
where title = 'ACADEMY DINOSAUR' 
order by rental_date)temp

9--What is that average length of all the films in the sakila DB?

set @AVG_lenght=
(select AVG(length) as AVG_length
from film);

select @AVG_lenght

10--What is the average length of films by category?

select b.category_id, AVG(length)
from category a join film_category b on a.category_id = b.category_id
join film c on b.film_id = c.film_id 
group by category_id
order by category_id

11--Which film categories are long? Long = lengh is longer than the average film length?

set @AVG_lenght=
(select AVG(length) as AVG_length
from film);

select @AVG_lenght

select b.category_id, AVG(length)
from category a join film_category b on a.category_id = b.category_id
join film c on b.film_id = c.film_id 
group by category_id
having AVG(length) > @AVG_lenght

Part 2 

 
-- 1a. Display the first and last names of all actors from the table actor.

select first_name, last_name
from actor
order by first_name

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name？

SELECT actor_id, UCASE(fullname) 
FROM 
(select actor_id,concat(first_name, "   ", last_name) as `Fullname` 
 from actor)temp;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."

Select actor_id,first_name,last_name 
from actor
where first_name = 'joe'

-- 2b. Find all actors whose last name contain the letters GEN

Select*
from actor 
where last_name like '%GEN%'

 
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

Select*
from actor 
where last_name like '%LI%'
order by last_name,first_name

 
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

Select country_id, country
from country
WHERE country in ('Afghanistan', 'Bangladesh', 'China')

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

alter table actor
add column middle_name VARCHAR(15) after first_name

-- 3b. You realize that some of these actors have tremendously long last names.
--  Change the data type of the middle_name column to blobs.

alter table actor
modify middle_name blob

-- 3c. Now delete the middle_name column.

ALTER TABLE actor
DROP COLUMN middle_name

select *
from actor

-- 4a. List the last names of actors, as well as how many actors have that last name.

Select count(last_name)
from actor 

-- 4b. List last names of actors and the number of actors who have that last name,
-- 	but only for names that are shared by at least two actors

Select count(distinct last_name,last_name)
from actor 

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS,
-- 	the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

？
UPDATE actor SET  first_name= 'HARPO '
WHERE Last_name = 'WILLIAMS'

select *
from actor
WHERE Last_name = 'WILLIAMS'

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct

？
UPDATE actor SET  first_name= 'HARPO GROUCHO'
WHERE Last_name = 'WILLIAMS'

select *
from actor
WHERE Last_name = 'WILLIAMS'

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

？ mysqldump 


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select a.staff_id, a.first_name, a.last_name, b.address
from staff a
join address b
on a.address_id = b.address_id
order by staff_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select a.staff_id, a.first_name, a.last_name, sum(amount)
from staff a
join payment b
on a.staff_id = b.staff_id 
where month(payment_date) = '8'
group by b.staff_id 
order by staff_id

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select b.film_id, b.title, count(actor_id)
from film_actor a
join film b
on a.film_id = b. film_id 
group by film_id
order by film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select a.film_id, a.title, count(inventory_id)as amount_inventory
from film a
join inventory b
on a.film_id = b.film_id
where title like '%Hunchback%'
group by film_id
order by film_id

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- 	List the customers alphabetically by last name:

select b.customer_id, b.first_name, b.last_name, count(amount)
from payment a
join customer b
on a.customer_id = b.customer_id
group by b.customer_id
order by last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
--  films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of
--  movies starting with the letters K and Q whose language is English.

select *
from film a
join language b
on a.language_id = b.language_id
where (title like'k%' or title like'Q%') and a.language_id = 1;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

select a.title, a.film_id, c.actor_id, c.first_name, c.last_name 
from film a
join film_actor b 
on a.film_id = b.film_id 
join actor c 
on b.actor_id = c.actor_id
where title = 'Alone Trip'
group by film_id, actor_id

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and
-- 	email addresses of all Canadian customers.
-- 	Use joins to retrieve this information.

Select a.first_name, a.last_name, a.email, d.country
from customer a
join address b
on a.address_id = b.address_id
join city c
on b.city_id = c.city_id
join country d
on c.country_id = d.country_id
where d.country = 'Canada'

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as famiy films.

select a.film_id, a.title, c.name
from film a
join film_category b
on a.film_id = b.film_id
join category c
on b.category_id = c.category_id
where name = 'Family'
order by film_id

-- 7e. Display the most frequently rented movies in descending order.

1.
set @max_count=
(
select max(count)as max_count
from(select a.film_id, a.title, count(a.film_id) as count
from film a
join inventory b 
on a.film_id = b.film_id
join rental c
on b.inventory_id = c.inventory_id 
join payment d
on c.rental_id = d.rental_id 
group by a.film_id
order by a.film_id
)temp
);

select @max_count

select a.film_id, a.title, count(a.film_id) as count
from film a
join inventory b 
on a.film_id = b.film_id
join rental c
on b.inventory_id = c.inventory_id 
join payment d
on c.rental_id = d.rental_id 
group by a.film_id
having count = @max_count

2.
select a.film_id, a.title, count(a.film_id) as count
from film a
join inventory b 
on a.film_id = b.film_id
join rental c
on b.inventory_id = c.inventory_id 
join payment d
on c.rental_id = d.rental_id 
group by a.film_id
order by count desc

-- 7f. Write a query to display how much business, in dollars, each store brought in.

select c.store_id, count(amount)
from payment a 
join staff b 
on a.staff_id = b.staff_id 
join store c
on b.store_id = c.store_id 
group by store_id 

-- 7g. Write a query to display for each store its store ID, city, and country.

select a.store_id, c.city, d.country
from store a
join address b 
on a.address_id = b.address_id
join city c
on b.city_id = c.city_id 
join country d
on c.country_id = d.country_id 
group by store_id 

-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select count(amount), e.category_id, e.name
from payment a
join rental b
on a.rental_id = b.rental_id
join inventory c
on b.inventory_id = c.inventory_id
join film_category d
on c.film_id = d.film_id
join category e
on d.category_id = e.category_id
group by e.category_id
order by count(amount)desc
limit 5

-- 8a. In your new role as an executive, you would like to have an easy way of viewing
--  	the Top five genres by gross revenue. Use the solution from the problem above to create a view.
--  	If you haven't solved 7h, you can substitute another query to create a view.

create view view_top5genres
as select count(amount), e.category_id, e.name
from payment a
join rental b
on a.rental_id = b.rental_id
join inventory c
on b.inventory_id = c.inventory_id
join film_category d
on c.film_id = d.film_id
join category e
on d.category_id = e.category_id
group by e.category_id
order by count(amount)desc
limit 5;

-- 8b. How would you display the view that you created in 8a?
show tables

SHOW FULL TABLES

select *
from view_top5genres

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view view_top5genres

show tables