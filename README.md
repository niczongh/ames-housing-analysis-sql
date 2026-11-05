**SQl Analysis of housing sales**
I analyzed 2,930 home sales in Ames, Iowa (2006 to 2010) using SQL in SQLite. I wanted a hands-on project that shows how I use SQL to answer real business questions about housing prices, which connects to my day-to-day work in real estate analytics.

**Skills demonstrated**
aggregations, GROUP BY / HAVING, CASE, subqueries, CTEs, window functions (AVG OVER PARTITION BY, LAG)

**Questions answered & Key Findings**
The numbers below match the numbered queries in ames_analysis.sql.

1. **What does the data look like?** Each row is one home sale, with 82 columns covering things like neighborhood, sale price, year built, living area, and sale condition.

2. **How many homes are there?** 2,930 home sales across 28 neighborhoods.

3. **What is the average price and number of homes sold by neighborhood?** Northridge (NoRidge) is the priciest at about $330,000 on average, and Meadow Village (MeadowV) is the cheapest at about $96,000. That is more than 3x apart. A few neighborhoods have very few sales (Landmrk has 1, GrnHill has 2), so their averages mean very little.

4. **How many homes sold per year?** About 620 to 690 homes sold each year from 2006 to 2009. 2010 only has 341, so it looks like a partial year and I treat it with caution.

5. **How many homes sold for over $300,000, and what share of all homes is that?** 230 homes, or 7.8% of all sales. Expensive homes are a small slice of this market.

6. **Does central air affect price?** Homes with central air averaged about $186,000, versus about $102,000 for homes without it. That does not mean air conditioning alone causes the gap. Homes with it also tend to be newer and bigger. Only 196 homes lack central air, so that group is much smaller.

7. **How does price (min, max, average) vary by total number of rooms?** Average price rises steadily with room count, from about $109,000 at 3 rooms to about $317,000 at 11 rooms. It then drops to about $243,000 at 12 rooms. That group is small (16 homes), so I would not read much into it.

8. **What are the minimum, maximum, and average prices in each neighborhood?** The averages hide a wide spread. The most expensive home in the dataset sold for $755,000 in Northridge, a neighborhood whose average is about $330,000.

9. **What is the average price per square foot of living area, by neighborhood?** Stone Brook (StoneBr) and Northridge Heights (NridgHt) lead at about $166 per square foot. The lowest are Iowa DOT and Rail Road (IDOTRR) and South and West of Iowa State (SWISU), both near $89. I left out GrnHill's top spot ($199) because it only has 2 homes.

10. **How do homes split into Budget, Mid, and Premium tiers?** I set Budget as under $125,000, Mid as $125,000 to $250,000, and Premium as $250,000 and up. Mid is the bulk of the market at 63.5% (1,861 homes), Budget is 20.8%, and Premium is 15.7%. The average Premium home sells for about 3x the average Budget home.

11. **How do home counts and average prices compare by decade built?** Newer homes sell for more. Homes built before 1940 average about $130,000, while homes from the 2000s average about $248,000. The 2010s group has only 3 homes, so I would not compare it.

12. **How does each home's price compare to its neighborhood average?** I used a window function to attach each neighborhood's average to every home, so I can see how far any home sits above or below its neighborhood. This is the base for the bargain finder below.

13. **What is the most expensive home in each neighborhood?** The top sale in each neighborhood ranges widely. Northridge tops the list at $755,000, followed by Northridge Heights at $615,000 and Stone Brook at about $592,000.

14. **Which homes sold well below their neighborhood average (a "bargain finder")?** I set the cutoff at 25% below the neighborhood average. 403 homes (13.8% of all sales) qualify. College Creek (CollgCr) has the most at 57, followed by Edwards (40) and Old Town (39). The biggest discount is an Old Town home that sold for $12,789, almost 90% below its neighborhood average. A low price alone does not prove a bargain, since some of these could be small homes or unusual sales, and I did not filter for those.

15. **How did average sale price change year over year?** Prices stayed within a narrow band: about $182,000 in 2006, up 1.9% in 2007, down 3.4% in 2008, up 1.4% in 2009, and down 4.9% to about $173,000 in 2010. The 2010 drop is based on a partial year, so it is less reliable.
    
**Data**
Ames Housing dataset (https://www.kaggle.com/datasets/marcopale/housing)

**Files**
ames_analysis.sql (comments are also in the file for answered questions)
