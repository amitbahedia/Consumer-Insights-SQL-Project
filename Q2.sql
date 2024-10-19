# What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
# unique_products_2020
# unique_products_2021
# percentage_chg
  
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