-- 1. Look at the data
SELECT * FROM homes LIMIT 10;
 
-- 2. How many homes are there?
SELECT COUNT(*) AS total_homes FROM homes;
 
-- 3. Average price by neighborhood
SELECT Neighborhood,
       ROUND(AVG(SalePrice)) AS avg_price,
       COUNT(*) AS homes_sold
FROM homes
GROUP BY Neighborhood
ORDER BY avg_price DESC;
 
-- 4. How many homes sold per year?
SELECT "Yr Sold", COUNT(*) AS homes_sold
FROM homes
GROUP BY "Yr Sold"
ORDER BY "Yr Sold";
 
-- 5. How many homes sold for over $300,000, and what share of all homes is that?
SELECT COUNT(*) AS homes_over_300k,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM homes), 1) AS pct_of_all_homes
FROM homes
WHERE SalePrice > 300000;
 
-- 6. Does central air affect price?
SELECT "Central Air",
       COUNT(*) AS homes,
       ROUND(AVG(SalePrice)) AS avg_price
FROM homes
GROUP BY "Central Air";
 
-- 7. Price by total rooms (min, max, average), ignoring tiny groups
SELECT "TotRms AbvGrd" AS total_rooms,
       COUNT(*) AS homes,
       MIN(SalePrice) AS min_price,
       MAX(SalePrice) AS max_price,
       ROUND(AVG(SalePrice)) AS avg_price
FROM homes
GROUP BY "TotRms AbvGrd"
HAVING COUNT(*) >= 10
ORDER BY "TotRms AbvGrd";
 
-- 8. Min, max, and average price in each neighborhood
SELECT Neighborhood,
       ROUND(AVG(SalePrice)) AS avg_price,
       MIN(SalePrice) AS min_price,
       MAX(SalePrice) AS max_price
FROM homes
GROUP BY Neighborhood
ORDER BY avg_price DESC;

-- 9. Price per square foot of living area, by neighborhood
SELECT Neighborhood,
       COUNT(*) AS homes,
       ROUND(AVG(SalePrice * 1.0 / "Gr Liv Area"), 2) AS price_per_sf
FROM homes
GROUP BY Neighborhood
ORDER BY price_per_sf DESC;
 
-- 10. Label homes Budget / Mid / Premium by price
SELECT CASE
         WHEN SalePrice < 125000 THEN 'Budget'
         WHEN SalePrice < 250000 THEN 'Mid'
         ELSE 'Premium'
       END AS price_tier,
       COUNT(*) AS homes,
       ROUND(AVG(SalePrice)) AS avg_price,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM homes), 1) AS pct_of_homes
FROM homes
GROUP BY price_tier
ORDER BY MIN(SalePrice);
 
-- 11. Homes and average price by decade built
SELECT CASE
         WHEN "Year Built" < 1940 THEN 'Pre-1940'
         WHEN "Year Built" BETWEEN 1940 AND 1949 THEN '1940s'
         WHEN "Year Built" BETWEEN 1950 AND 1959 THEN '1950s'
         WHEN "Year Built" BETWEEN 1960 AND 1969 THEN '1960s'
         WHEN "Year Built" BETWEEN 1970 AND 1979 THEN '1970s'
         WHEN "Year Built" BETWEEN 1980 AND 1989 THEN '1980s'
         WHEN "Year Built" BETWEEN 1990 AND 1999 THEN '1990s'
         WHEN "Year Built" BETWEEN 2000 AND 2009 THEN '2000s'
         ELSE '2010s'
       END AS decade,
       COUNT(*) AS homes,
       ROUND(AVG(SalePrice)) AS avg_price
FROM homes
GROUP BY decade
ORDER BY MIN("Year Built");
-- 12. Compare home price to its neighborhood's average
select PID, Neighborhood, SalePrice, round(avg(SalePrice) over (partition by Neighborhood)) as neighborhood_avg,
round(SalePrice - avg(SalePrice) over (partition by Neighborhood)) as price_diff
from homes
order by Neighborhood, SalePrice desc;
-- 13. Find the most expensive home in each neighborhood
select max(SalePrice) as most_expensive_home, Neighborhood
from homes
group by Neighborhood;
-- 14. Find homes that sold well below their neighborhood average, a “bargain finder” (I chose 25% under)
WITH with_avg AS (
  SELECT PID,	
		Neighborhood,
		SalePrice,
		AVG(SalePrice) OVER (PARTITION BY Neighborhood) AS neighborhood_avg
  FROM homes
)
SELECT PID, 
	   Neighborhood,
       SalePrice,
       ROUND(neighborhood_avg) AS neighborhood_avg,
       ROUND(100.0 * (SalePrice - neighborhood_avg) / neighborhood_avg, 1) AS pct_vs_avg
FROM with_avg
WHERE SalePrice < 0.8 * neighborhood_avg
ORDER BY pct_vs_avg;
-- 15. Year-over-year change in average price
with yearly as (
select "Yr Sold" as sale_year,
avg(SalePrice) as avg_price
from homes
group by "Yr Sold")
select sale_year, 
	round(avg_price) as avg_price,
	round(lag(avg_price) over (order by sale_year)) as prev_year_avg,
	round(avg_price-lag(avg_price) over (order by sale_year)) as price_change
FROM yearly
ORDER BY sale_year;