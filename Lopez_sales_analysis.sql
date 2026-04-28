USE sample_sales;
-- My manager is Jim Heck, the reigion/territory I am analyzing is the West coast in Colorado
-- Finding my assigned manager and region
SELECT *
FROM management
WHERE SalesManager= 'Jim Heck';
-- Finding all of Jim's stores in his region
SELECT *
FROM Store_Locations
WHERE State = 'Colorado'
ORDER BY StoreID;
-- Jim Heck's questions that he wants to know

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?
SELECT sum(Sale_Amount) AS Total_Revenue,
	   min(Transaction_Date) AS Start_Date,
	   max(Transaction_Date) AS End_Date
FROM Store_Sales
WHERE Store_ID BETWEEN 701 AND 718;

--  What is the month by month revenue breakdown for the sales territory? 
-- I would have to find a way to group the months in order to show each revenue of the stores
SELECT date_format(Transaction_Date, '%Y-%m') AS Month,
	   sum(Sale_Amount) AS Monthly_Revenue
FROM Store_Sales
WHERE Store_ID BETWEEN 701 AND 718
-- I still use those ID's based off of my previous query
GROUP BY Month 
ORDER BY Month;
-- I used ORDER BY to have the months ascend from january to december to have the data be readable a lot easier

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
-- Would have to find a way to unite tables in order to compare revenue for the territory and the region
SELECT 'Colorado (In-Store)' AS Territory, 
		-- These are my physical stores
	    sum(Sale_Amount) AS Total_Revenue 
        -- Want to know there revenue
FROM Store_Sales
WHERE Store_ID BETWEEN 701 AND 718
UNION ALL 
-- Want to combine the two tables to compare
SELECT 'WEST (Online)' AS Territory,
	    sum(SalesTotal) AS Total_Revenue
FROM Online_Sales
WHERE ShipToState = 'Colorado';


-- What is the number of transactions per month and average transaction size by product category for the sales territory?
--  I need to find the average of transactions per month and size by product, so I have to find what tables i can join together
SELECT date_format(ss.Transaction_Date, '%Y-%m') AS Month,
	   ic.Category,
	   count(*) AS Num_Transactions,
       round(avg(ss.Sale_Amount), 2) AS Avg_Transaction_Size
FROM Store_Sales ss
JOIN Products p ON ss.Prod_Num = p.ProdNum
JOIN Inventory_Categories ic ON p.CategoryID = ic.CategoryID
WHERE ss.Store_ID BETWEEN 701 AND 718
GROUP BY Month, ic.Category
ORDER BY Month, ic.Category;

-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
SELECT sl.StoreLocation AS Store,
	   sl.State,
       sum(ss.Sale_Amount) AS Total_Revenue,
RANK() OVER (ORDER BY sum(ss.Sale_Amount) DESC) AS Revenue_Rank
FROM Store_Sales ss
JOIN Store_Locations sl ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Colorado'
GROUP BY sl.StoreLocation, sl.State
ORDER BY Revenue_Rank;
-- Denver is the number 1 ranked store in Colorado with $917,471.53

-- ============ -- 

-- My Recommendation

-- With the top 9 stores already producing over $300k of revenue, our sales attention should focus on stores that are ranked at 10-18 in the next quarter to get them close or over $300k in revenue.
-- We're aware that Denver is our best peforming store and is pretty much at its peak.
-- What steps can we take in the next quarter to avoid Parker from underpeforming again.
-- Technology & Accessories has the highest avg transaction value sitting at $400.
-- If we can target some promotions to that category in our lower revenue stores, we can lift our revenue without having to fetch for new customers. 