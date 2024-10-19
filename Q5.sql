# Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields

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