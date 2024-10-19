
# In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity,
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
