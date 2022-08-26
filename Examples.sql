-- Active: 1661453407611@@127.0.0.1@3306
USE parchposey;

SELECT *
FROM web_events;

SELECT account_id, occurred_at
FROM orders;

-- limits the number of rows shown to 5
SELECT *
FROM orders
LIMIT 5;

-- orders the table by total in descending order
SELECT *
FROM orders
ORDER BY total DESC
LIMIT 10;

-- shows all table entries where gloss_qty is greater than 10
SELECT *
FROM orders
WHERE gloss_qty > 10;

-- Creating Derived Column under 'std_percent' using AS keyword
-- Derived columns only last for the duration of the query
SELECT id, occurred_at, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders;

-- filtering by rows in the column 'channel' that contain 'adwords'
-- *NOTE* the percent sign represents us saying we want any number of characters after or before 'adwords'
SELECT *
FROM web_events
WHERE channel LIKE '%adwords%';

SELECT *
FROM accounts
WHERE name LIKE '%s';

-- IN operator allows you to use = operator but for more than one column or value
SELECT *
FROM orders
WHERE account_id IN (1001,1021);

SELECT *
FROM web_events
WHERE channel IN ('organic','adwords');

-- NOT operator can be used with LIKE and IN to find the opposite of LIKE and IN
SELECT *
FROM accounts
WHERE 'name' NOT LIKE 'C%';

SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');

SELECT *
FROM orders
WHERE occurred_at >= '2016-04-01' AND occurred_at <= '2016-10-01'
ORDER BY occurred_at DESC;

-- OR can be used by itself or with other operators
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT *
FROM accounts
WHERE (`name` LIKE 'C%' or `name` LIKE 'W%') AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND (primary_poc NOT LIKE '%eana%');



