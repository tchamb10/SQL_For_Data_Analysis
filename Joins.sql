-- Active: 1661453407611@@127.0.0.1@3306@parchposey
USE parchposey;

SELECT *
FROM orders
JOIN accounts 
ON orders.account_id = accounts.id;

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

SELECT *
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

-- Joining specific columns within tables
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, 
       accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Joining multiple tables
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;

-- Using alias to rename table names for convenience
SELECT *
FROM web_events w
JOIN accounts a
ON w.account_id = a.id;

--Provide a table for all web_events associated with account name of Walmart. 
--There should be three columns. Be sure to include the primary_poc, time of the event, 
--and the channel for each event. Additionally, you might choose to add a fourth column to 
--assure only Walmart events were chosen.
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w 
JOIN accounts a 
ON w.account_id = a.id
WHERE a.name = 'Walmart';

--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--Your final table should include three columns: the region name, the sales rep name, 
--and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name, s.name, a.name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;

--Provide the name for each region for every order, as well as the account name and the unit 
--price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: 
--region name, account name, and unit price. A few accounts have 0 for total, so I divided by 
--(total + 0.01) to assure not dividing by zero.
SELECT r.name, a.name, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id

