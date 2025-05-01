select * from brands;
select * from categories;
select * from customers;
select * from order_items;
select * from orders;
select * from products;
select * from staffs;
select * from stocks;
select * from stores;



-- (Profitability Analysis by Brand and Category) Average margin per product category or brand. Suggest focus areas for marketing or stock increase.



-- (Staff Sales Leaderboard) Rank sales staff by revenue generated and number of orders.
with staff_summary as
(
select s.staff_id, s.first_name, s.last_name, count(o.customer_id) as num_of_customers, sum(oi.list_price * oi.quantity) as total_revenue
from staffs as s
left join orders as o on s.staff_id = o.staff_id
left join order_items as oi on o.order_id = oi.order_id
group by s.staff_id, s.first_name, s.last_name 
), ranking_summary as
(
select *, rank() over(order by total_revenue desc) as ranking
from staff_summary
) 
select  *
from ranking_summary
where  total_revenue = 0 or total_revenue is null;


-- (Product Stock Efficiency) Track inventory turnover: which products have low stock but high demand? Suggest restocking priorities.
select product_name, sum(s.quantity) as total_sotcks , sum(oi.list_price * oi.quantity) as total_price
 from products as p
 join order_items as oi on p.product_id = oi.product_id
 join stocks as s on p.product_id = s.product_id
 group by product_name
 order by sum(s.quantity) asc, sum(oi.list_price * oi.quantity) desc;



-- (Customer Segmentation by Purchase Behavior) Group customers by purchase frequency and total spend (RFM). Identify your most valuable customers.
with customer_Summary as
(
select c.customer_id, c.first_name, c.last_name, max(o.order_date) as last_purchase, count(o.customer_id) as frequency, sum(quantity * list_price) as total_spent 
from customers as c
join orders as o on c.customer_id = o.customer_id
join order_items as oi on o.order_id = oi.order_id
group by c.customer_id, c.first_name, c.last_name
), 
RFM_summary as
(
select customer_id, first_name, last_name, last_purchase, frequency, total_spent, 
ntile(5) over (order by datediff(curdate(), last_purchase)) AS recency_rank, 
ntile(5) over (order by frequency desc) as frequency_rank,
ntile(5) over (order by total_spent desc) as monetary_rank
from customer_Summary
),
concat_summary as
(
select customer_id, first_name, last_name, last_purchase, frequency, total_spent, recency_rank, frequency_rank, monetary_rank,
CONCAT(recency_rank, frequency_rank, monetary_rank) as rfm_score
from RFM_summary
), 
segment_summary as
(
select first_name, last_name, last_purchase, frequency, total_spent, recency_rank, frequency_rank, monetary_rank,
case  
when rfm_score = '111' then 'Top Customers'
when rfm_score like '1__' then 'Loyal Buyers'
when rfm_score like '_1_' then 'Frequent Buyer'
when rfm_score like '__1' then 'Big Spender'
when rfm_score like '5__' then 'At Risk'
when rfm_score like '__5' then 'Low Value'
else 'Others'
end as segemnt
from concat_summary
) 
select * 
from segment_summary 
where segemnt = 'Low Value';	


-- Total sales by store, month, and product category. Compare store performance and identify top sellers.
select s.store_name, date_format(o.order_date, '%y-%m') as sale_month, c.category_name, sum(oi.quantity * oi.list_price) as total_sales
from products as p
join categories as c on p.category_id = c.category_id
join order_items as oi on p.product_id = oi.product_id
join orders as o on oi.order_id = o.order_id
join stores as s on o.store_id = s.store_id
group by store_name, date_format(o.order_date, '%y-%m'), c.category_name;
