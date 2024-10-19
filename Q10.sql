# Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these
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
