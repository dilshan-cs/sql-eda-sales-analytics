select 
*
from datawarehouseanalytics.dim_products
;
--  distict countries-- 
select
distinct country
from datawarehouseanalytics.dim_customers
;
-- make hierarchie for oders
select
category,
subcategory,
product_name
from datawarehouseanalytics.dim_products
order by 1,2,3
;
-- latest and oldest orders and order range
select
min(order_date) as oldest_order,
max(order_date) as lastest_order,
timestampdiff(year,min(order_date),max(order_date) ) as order_range
from datawarehouseanalytics.fact_sales
where order_date != ''
;

 -- show youngest and oldest ages

select
min(birthdate) as oldest_birthdate,
timestampdiff(year,min(birthdate),curdate()  ) as oldest_age,
max(birthdate) as youngest_birthdate,
timestampdiff(year,max(birthdate),curdate()  ) as youngest_age
from datawarehouseanalytics.dim_customers c
where birthdate != ''
;



-- find the total sales
select
sum(sales_amount)
from datawarehouseanalytics.fact_sales
;
-- find how many items sold
select
sum(quantity)
from datawarehouseanalytics.fact_sales
;

-- find avg selling price
select
avg(price)
from datawarehouseanalytics.fact_sales
;
-- find total number of orders
select
count(distinct order_number)
from datawarehouseanalytics.fact_sales
;
-- find total total number of products
select
count(distinct product_key)
from datawarehouseanalytics.dim_products
;

-- find total number of customers
select	
count( customer_key)
from datawarehouseanalytics.dim_customers
;

-- find total number of customer that has placed an order
select	
count(distinct customer_key)
from datawarehouseanalytics.fact_sales
;


-- ------------------------------------------------------ 
-- generate report

select
'Total Sales' as measure_name,
sum(sales_amount) as measure_value
from datawarehouseanalytics.fact_sales
union all
select
'Total Quantity' as measure_name,
sum(quantity) as measure_value
from datawarehouseanalytics.fact_sales
union all
select
'Avg price' as measure_name,
avg(price) as measure_value
from datawarehouseanalytics.fact_sales
union all
select
'Total orders' as measure_name,
count(distinct order_number) as measure_value
from datawarehouseanalytics.fact_sales
union all
select
'Total products' as measure_name,
count(distinct product_key) as measure_value
from datawarehouseanalytics.fact_sales
union all
select
'Total customer' as measure_name,
count(customer_key) as measure_value
from datawarehouseanalytics.dim_customers
;


-- ------------------------------------------------------ 
-- magnitute analysis

-- total customers by country
select
country,
count(customer_key) as total_customers
from datawarehouseanalytics.dim_customers
group by country
;
-- total customers by gender
select
gender,
count(customer_key) as total_customers
from datawarehouseanalytics.dim_customers
group by gender
;

-- total products by category
select
category,
count(product_key) as total_product
from datawarehouseanalytics.dim_products
group by category
;

-- avg cost per category
select
category,
avg(cost) as avg_cost
from datawarehouseanalytics.dim_products
group by category
order by avg_cost desc
;

-- total revenue by category
select
p.category,
sum(price) as total_revenue
from datawarehouseanalytics.fact_sales f
left join datawarehouseanalytics.dim_products p
on f.product_key = p.product_key
group by p.category
order by total_revenue desc
;

-- total revenue by customer
select
c.customer_key,
c.first_name,
c.last_name,
sum(price) as total_revenue
from datawarehouseanalytics.fact_sales f
left join datawarehouseanalytics.dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key,c.first_name,c.last_name
order by total_revenue desc
;

-- total revenue by country
select
c.country,
sum(f.quantity) as total_quantity
from datawarehouseanalytics.fact_sales f
left join datawarehouseanalytics.dim_customers c
on f.customer_key = c.customer_key
group by c.country
order by total_quantity desc
;
-- ------------------------------------------------------ 
-- Ranking

select 
p.product_name,
sum(price) as total_revenue,
dense_rank() over(order by sum(price) desc) as ranking
from datawarehouseanalytics.fact_sales f
left join datawarehouseanalytics.dim_products p
on f.product_key = p.product_key
group by p.product_name
order by total_revenue desc
;

