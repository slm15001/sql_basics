#1a
select sakila.actor.first_name, sakila.actor.last_name
from sakila.actor;
#1b
select 
concat(sakila.actor.first_name," ",sakila.actor.last_name) AS actor_name
from sakila.actor
group by 1;
#2B
select sakila.actor.last_name
from sakila.actor
where sakila.actor.last_name LIKE '%GEN%'
group by 1; 

#2C
select sakila.actor.last_name, sakila.actor.first_name
from sakila.actor
where sakila.actor.last_name LIKE '%LI%'
order by sakila.actor.last_name asc;

#2D
select sakila.country.country_id, sakila.country.country
from sakila.country
where sakila.country.country IN ('Afghanistan', 'Bangladesh', 'China');

#3A create a column in the table actor named description
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

#3b delete description colum
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

#4a/b List the last names of actors, as well as how many actors have that last name
select distinct sakila.actor.last_name, count(sakila.actor.last_name) as last_name_count
from sakila.actor
group by sakila.actor.last_name
having (count(sakila.actor.last_name)>=2);

#5
Create address; 

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select sakila.staff.first_name, sakila.staff.first_name, sakila.address.address
from sakila.staff inner join sakila.address 
on  sakila.staff.address_id = sakila.address.address_id;

# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select sakila.staff.staff_id,
sum(sakila.payment.amount) as August_Payments
from sakila.staff  inner join sakila.payment
on sakila.staff.staff_id = sakila.payment.staff_id
where (sakila.payment.payment_date between '2005-07-31 00:00:00' AND '2005-09-01 00:00:00')
group by sakila.staff.staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select sakila.film.title, count(sakila.film_actor.actor_id) as actor_count
from sakila.film inner join sakila.film_actor
on sakila.film.film_id = sakila.film_actor.film_id
group by 1;

#6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select sakila.film.title,
count(sakila.inventory.inventory_id) as Inventory_Count
from sakila.film inner join sakila.inventory
on sakila.film.film_id = sakila.inventory.film_id
where sakila.film.title in('HUNCHBACK IMPOSSIBLE')
group by sakila.film.title;

#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select sakila.customer.customer_id, sakila.customer.last_name,
sum(sakila.payment.amount) as amount
from sakila.customer inner join sakila.payment
on sakila.customer.customer_id = sakila.payment.customer_id
group by sakila.customer.customer_id, sakila.customer.last_name
order by sakila.customer.last_name asc;

#7aUse subqueries to display the titles of movies starting with the letters K and Q whose language is English
select * from sakila.film
where (sakila.film.title LIKE 'k%' or sakila.film.title LIKE 'q%');

#7b. Use subqueries to display all actors who appear in the film Alone Trip

Select  sakila.film_actor.actor_id
FROM sakila.film_actor
WHERE sakila.film_actor.film_id IN (select sakila.film.film_id
from sakila.film
where sakila.film.title IN ('ALONE TRIP'));

#add inner join
Select  sakila.film_actor.actor_id, sakila.actor.first_name, sakila.actor.last_name
FROM sakila.film_actor inner join sakila.actor
on sakila.film_actor.actor_id = sakila.actor.actor_id
WHERE sakila.film_actor.film_id IN (select sakila.film.film_id
from sakila.film
where sakila.film.title IN ('ALONE TRIP'));



#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select sakila.customer.email
from sakila.customer inner join sakila.address
on sakila.customer.address_id = sakila.address.address_id
where sakila.address.city_id IN (select sakila.city.city_id
from sakila.city
where sakila.city.country_id =20);

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from sakila.film_category;
select * from sakila.film_text;
select * from sakila.film;

#7e. Display the most frequently rented movies in descending order.


select sakila.inventory.film_id,
count(sakila.rental.inventory_id) as rental_count
from sakila.rental inner join sakila.inventory
on sakila.rental.inventory_id = sakila.inventory.inventory_id
group by 1
order by count(sakila.rental.inventory_id) desc;

#7f. Write a query to display how much business, in dollars, each store brought in.

select sakila.store.store_id, concat('$', FORMAT(SUM(sakila.payment.amount),0))as payments
from sakila.payment inner join sakila.store
on sakila.payment.staff_id= sakila.store.manager_staff_id
group by 1;

#7g Write a query to display for each store its store ID, city, and country.
select sakila.store.store_id, sakila.city.city, sakila.country.country
from sakila.store inner join sakila.address on sakila.store.address_id = sakila.address.address_id
inner join sakila.city on sakila.address.city_id = sakila.city.city_id
inner join sakila.country on sakila.city.country_id = sakila.country.country_id
group by 1,2,3;

#7h List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select sakila.category.name, sum(sakila.payment.amount) as payment_amount
from sakila.category inner join sakila.film_category on sakila.category.category_id=sakila.film_category.category_id
inner join sakila.inventory on sakila.film_category.film_id=sakila.inventory.film_id
inner join sakila.rental on sakila.inventory.inventory_id = sakila.rental.inventory_id
inner join sakila.payment on sakila.rental.rental_id = sakila.payment.rental_id
group by 1
order by sum(sakila.payment.amount) desc 
limit 5;

#8 
CREATE VIEW category_payment_amount AS 
	select sakila.category.name, sum(sakila.payment.amount) as payment_amount
	from sakila.category inner join sakila.film_category on sakila.category.category_id=sakila.film_category.category_id
	inner join sakila.inventory on sakila.film_category.film_id=sakila.inventory.film_id
	inner join sakila.rental on sakila.inventory.inventory_id = sakila.rental.inventory_id
	inner join sakila.payment on sakila.rental.rental_id = sakila.payment.rental_id
	group by 1
	order by sum(sakila.payment.amount) desc;

#8b display the view
select * from favorite_db.category_payment_amount;



#8c
DROP favorite_db.category_payment_amount;