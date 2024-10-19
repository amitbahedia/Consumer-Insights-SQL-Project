# Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month . This analysis helps to get an idea of low and high-performing months and take strategic decisions

# The final report contains these columns: Month, Year, Gross sales Amount

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


