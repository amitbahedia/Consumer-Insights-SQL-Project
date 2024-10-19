-- 1. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
-- unique_products_2020
-- unique_products_2021
-- percentage_chg
  
 with unique_products as
 (
 select
        (SELECT COUNT(DISTINCT product_code) FROM fact_gross_price WHERE fiscal_year = 2020) AS unique_products_2020,
       (SELECT COUNT(DISTINCT product_code) FROM fact_gross_price WHERE fiscal_year = 2021) AS unique_products_2021
    
)
SELECT 
    unique_products_2021, 
    unique_products_2020,
    ROUND((unique_products_2021 - unique_products_2020) * 100.0 / unique_products_2020, 2) AS percentage_chg
FROM unique_products;


-- 2. What is the percentage of 'in full' for each product and which product has the highest percentage, based on the data from the 'fact_order_lines' and 'dim_products' tables?

select p.product_name,

100 * count(case when f.In_Full = 1 then 1 END) / count(*) as in_full_perc

from dim_products p

join fact_order_lines f

on p.product_id = f.product_id

group by p.product_name

order by in_full_perc desc


-- 3. Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields

# product_code product manufacturing_cost



WITH RankedProducts AS (
  SELECT p.product_code, p.product, f.manufacturing_cost,
         ROW_NUMBER() OVER (ORDER BY f.manufacturing_cost DESC) AS rank_desc,
         ROW_NUMBER() OVER (ORDER BY f.manufacturing_cost ASC) AS rank_asc
  FROM dim_product p
  JOIN fact_manufacturing_cost f ON p.product_code = f.product_code
)
SELECT product_code, product, manufacturing_cost
FROM RankedProducts
WHERE rank_asc = 1 or rank_desc = 1


-- 4 Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month . This analysis helps to get an idea of low and high-performing months and take strategic decisions

-- The final report contains these columns: Month, Year, Gross sales Amount

SELECT MONTHNAME(f.date) AS month, 
       f.fiscal_year AS year, 
       round(SUM(f.sold_quantity * g.gross_price),2) AS Gross_Sales_Amount
FROM fact_sales_monthly f
JOIN fact_gross_price g 
    ON f.product_code = g.product_code
JOIN dim_customer c 
    ON c.customer_code = f.customer_code
WHERE c.customer = 'Atliq Exclusive'
GROUP BY month, f.fiscal_year


-- 5 # In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity,
# Quarter, total_sold_quantity


SELECT fiscal_year,
       CASE 
           WHEN MONTH(date) IN (9, 10, 11) THEN 'Q1'
           WHEN MONTH(date) IN (12, 1, 2) THEN 'Q2'
           WHEN MONTH(date) IN (3, 4, 5) THEN 'Q3'
           WHEN MONTH(date) IN (6, 7, 8) THEN 'Q4'
       END AS fiscal_quarter, 
       sum(sold_quantity) as total_sold_quantity
FROM fact_sales_monthly
where fiscal_year = 2020
group by fiscal_quarter
order by total_sold_quantity desc


-- 6. # Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these
# fields

# division, product_code, product, total_sold_quantity, rank_order

WITH ranked_products AS (
    SELECT p.division, 
           p.product_code, 
           p.product, 
           SUM(f.sold_quantity) AS total_sold_quantity,
           rank() OVER (PARTITION BY p.division ORDER BY SUM(f.sold_quantity) DESC) AS rank_order
    FROM dim_product p
    JOIN fact_sales_monthly f ON p.product_code = f.product_code
    WHERE f.fiscal_year = 2021
    GROUP BY p.division, p.product_code, p.product
)
SELECT division, 
       product_code, 
       product, 
       total_sold_quantity, 
       rank_order
FROM ranked_products
WHERE rank_order <= 3
ORDER BY division, rank_order;
