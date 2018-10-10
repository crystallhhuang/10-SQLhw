#1a
SELECT 
    first_name, last_name
FROM
    actor;


#1b
SELECT 
    CONCAT_WS(' ', UPPER(first_name), UPPER(last_name)) AS 'Actor Name'
FROM
    actor;


#2a
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';


#2b
SELECT 
    *
FROM
    actor
WHERE
    LOCATE('GEN', last_name) > 0;
    
#2c
SELECT 
    *
FROM
    actor
WHERE
    LOCATE('LI', last_name) > 0
ORDER BY first_name , last_name;


#2d
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
    

#3a
ALTER TABLE actor ADD description BLOB;


#3b
ALTER TABLE actor DROP description;


#4a
SELECT 
    last_name, COUNT(*) AS 'actor number'
FROM
    actor
GROUP BY last_name;

#4b
SELECT 
    last_name, COUNT(*) AS 'actor number'
FROM
    actor
GROUP BY last_name
HAVING COUNT(*) > 1;


#4c
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';


#4d
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO' AND actor_id >= 0;
    

#5a
SHOW CREATE TABLE address;

#6a
SELECT 
    first_name, last_name, address
FROM
    staff
        JOIN
    address ON staff.address_id = address.address_id;
    

#6b
SELECT 
    staff.staff_id,
    CONCAT_WS(' ', staff.first_name, staff.last_name) AS 'Staff Name',
    SUM(amount) AS 'total amount'
FROM
    staff
        JOIN
    payment ON staff.staff_id = payment.staff_id
        AND DATE_FORMAT(payment.payment_date, '%Y%M') = '2005August'
GROUP BY staff.staff_id;

 
#6c
SELECT 
    film.film_id,
    film.title,
    COUNT(actor_id) AS 'the number of actors'
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

#6d
SELECT 
    COUNT(store_id) AS 'amount'
FROM
    film
        JOIN
    inventory ON film.film_id = inventory.film_id
        AND film.title = 'Hunchback Impossible';
        

#6e
SELECT 
    customer.customer_id,
    CONCAT_WS(' ',
            customer.first_name,
            customer.last_name) AS 'Customer Name',
    SUM(amount) AS 'total amount'
FROM
    customer
        JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;


#7a
SELECT 
    title
FROM
    film
WHERE
    language_id = (SELECT 
            language_id
        FROM
            language
        WHERE
            language.name = 'English')
        AND (LEFT(title, 1) = 'K'
        OR LEFT(title, 1) = 'Q');
        

#7b
SELECT 
    CONCAT_WS(' ', UPPER(first_name), UPPER(last_name)) AS 'Actor Name'
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));
                    

#7c
SELECT 
    CONCAT_WS(' ',
            customer.first_name,
            customer.last_name) AS 'Customer Name',
    customer.email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
                JOIN
            city
                JOIN
            country ON address.city_id = city.city_id
                AND city.country_id = country.country_id
        WHERE
            country.country = 'Canada');
            

#7d
SELECT 
    film_id, film.title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_category.film_id
        FROM
            category
                JOIN
            film_category ON category.category_id = film_category.category_id
        WHERE
            category.name = 'family');


#7e
SELECT 
    film.film_id, film.title, t1.filmRentCount
FROM
    (SELECT 
        inventory.film_id, COUNT(*) AS 'filmRentCount'
    FROM
        inventory
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    GROUP BY inventory.film_id
    ORDER BY filmRentCount DESC) t1
        JOIN
    film ON t1.film_id = film.film_id
ORDER BY t1.filmRentCount DESC;


#7f
SELECT 
    inventory.store_id, SUM(amount) AS 'business'
FROM
    payment
        JOIN
    rental
        JOIN
    inventory ON payment.rental_id = rental.rental_id
        AND rental.inventory_id = inventory.inventory_id
GROUP BY inventory.store_id;


#7g
SELECT 
    store.store_id, city.city, country.country
FROM
    store
        JOIN
    address
        JOIN
    city
        JOIN
    country ON store.address_id = address.address_id
        AND address.city_id = city.city_id
        AND city.country_id = country.country_id;
        

#7h
SELECT 
    category.category_id,
    category.name,
    COUNT(payment.amount) AS 'gross_revenue'
FROM
    category
        JOIN
    film_category
        JOIN
    inventory
        JOIN
    rental
        JOIN
    payment ON category.category_id = film_category.category_id
        AND film_category.film_id = inventory.film_id
        AND inventory.inventory_id = rental.inventory_id
        AND rental.rental_id = payment.rental_id
GROUP BY category.category_id
ORDER BY gross_revenue DESC
LIMIT 5; 


#8a
CREATE VIEW top_five_genres AS
    SELECT 
        category.category_id,
        category.name,
        COUNT(payment.amount) AS 'gross_revenue'
    FROM
        category
            JOIN
        film_category
            JOIN
        inventory
            JOIN
        rental
            JOIN
        payment ON category.category_id = film_category.category_id
            AND film_category.film_id = inventory.film_id
            AND inventory.inventory_id = rental.inventory_id
            AND rental.rental_id = payment.rental_id
    GROUP BY category.category_id
    ORDER BY gross_revenue DESC
    LIMIT 5; 
    

#8b
SELECT 
    *
FROM
    top_five_genres;
    

#8c
DROP VIEW top_five_genres;

    