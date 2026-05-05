-- Creating database for customer behaviour analysis
CREATE DATABASE customer_behaviour_analysis;

-- Main data table
SELECT * FROM customer_behaviour;

----- Creating star-schema
-- Dimension tables

-- Customer table
CREATE TABLE customer(
        customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		age INT,
		age_grp VARCHAR(50),
		gender VARCHAR(50)
);

SELECT * FROM customer;

-- Product table
CREATE TABLE product(
        product_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		item_purchased VARCHAR(100),
		category VARCHAR(100)
);

SELECT * FROM product;

-- Location table
CREATE TABLE location(
        location_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		location VARCHAR(100)
);

SELECT * FROM location;

-- Shipping table
CREATE TABLE shipping(
        shipping_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		shipping_type VARCHAR(100)
);

SELECT * FROM shipping;

-- Payment table
CREATE TABLE payment(
        payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		payment_method VARCHAR(100),
		discount_applied VARCHAR(50)
);

SELECT * FROM payment;

-- Facts table
CREATE TABLE facts_customer(
        facts_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		customer_id INT,
		product_id INT,
		location_id INT,
		shipping_id INT,
		payment_id INT,
		purchase_amount INT,
		size VARCHAR(10),
		color VARCHAR(50),
		season VARCHAR(50),
		review_rating FLOAT,
		subscription_status VARCHAR(10),
		previous_puchases INT,
		frequency_of_puchases VARCHAR(50),
		CONSTRAINT fk_customer
		FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
		CONSTRAINT fk_product
		FOREIGN KEY (product_id) REFERENCES product(product_id),
		CONSTRAINT fk_location
		FOREIGN KEY (location_id) REFERENCES location(location_id),
		CONSTRAINT fk_shipping
		FOREIGN KEY (shipping_id) REFERENCES shipping(shipping_id),
		CONSTRAINT fk_payment
		FOREIGN KEY (payment_id) REFERENCES payment(payment_id)
);


SELECT * FROM facts_customer;


--- Inserting data into dimension tables

-- Customer table
INSERT INTO customer(age,age_grp,gender)
SELECT DISTINCT age,
                age_grp,
				gender
FROM customer_behaviour;

-- Product table
INSERT INTO product(item_purchased,category)
SELECT DISTINCT item_purchased,category
FROM customer_behaviour;

SELECT * FROM product;

-- Location table
INSERT INTO location(location)
SELECT DISTINCT location
FROM customer_behaviour;

SELECT * FROM location;


-- Shipping table
INSERT INTO shipping(shipping_type)
SELECT DISTINCT shipping_type
FROM customer_behaviour;

SELECT * FROM shipping;


-- Payment table
INSERT INTO payment(payment_method,discount_applied)
SELECT DISTINCT payment_method,discount_applied 
FROM customer_behaviour;

SELECT * FROM payment;


-- Facts table
INSERT INTO facts_customer(customer_id,product_id,location_id,shipping_id,payment_id,purchase_amount,size,color,season,review_rating,subscription_status,previous_purchases,frequency_of_purchases)
SELECT cu.customer_id,
       p.product_id,
	   l.location_id,
	   s.shipping_id,
	   pa.payment_id,
	   c.purchase_amount,
	   c.size,
	   c.color,
	   c.season,
	   c.review_rating,
	   c.subscription_status,
	   c.previous_purchases,
	   c.frequency_of_purchases
FROM customer_behaviour c
JOIN customer cu
     ON cu.age=c.age
	 AND cu.age_grp=c.age_grp
	 AND cu.gender=c.gender
JOIN product p
     ON p.item_purchased=c.item_purchased
	 AND p.category=c.category
JOIN location l
     ON l.location=c.location
JOIN shipping s
     ON s.shipping_type=c.shipping_type
JOIN payment pa
     ON pa.payment_method=c.payment_method
	 AND pa.discount_applied=c.discount_applied;

SELECT * FROM facts_customer;


-- All the data together
SELECT * FROM facts_customer f
JOIN customer c ON f.customer_id=c.customer_id  
JOIN product p ON f.product_id=p.product_id
JOIN location l ON f.location_id=l.location_id
JOIN shipping s ON f.shipping_id=s.shipping_id
JOIN payment pa ON f.payment_id=pa.payment_id;



----- KPI's and Analysis

-


