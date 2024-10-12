
# Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields,
# channel, gross_sales_mln, percentage

with sales_by_channel as
(
SELECT c.channel, sum(f.sold_quantity * g.gross_price)/1000000 as gross_sales_mln

from dim_customer c 
join fact_sales_monthly f 
on c. customer_code = f.customer_code
join fact_gross_price g 
on g.product_code = f.product_code
where f.fiscal_year = 2021
group by c.channel

), 

total_sales as
(
select sum(gross_sales_mln) as totaL_sales
from sales_by_channel
)

select s.channel, s.gross_sales_mln, round((s.gross_sales_mln / t.totaL_sales)*100,2) as percentage
from sales_by_channel s, totaL_sales t
order by s.gross_sales_mln desc
