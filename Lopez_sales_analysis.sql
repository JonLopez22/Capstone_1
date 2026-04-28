USE sample_sales;
-- Finding my assigned manager and region
SELECT *
FROM management
WHERE SalesManager= 'Jim Heck';
-- Finding all of Jim's stores in his region
SELECT *
FROM Store_Locations
WHERE State = 'Colorado'
ORDER BY StoreID;

-- -- 1. What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?
SELECT sum(Sale_Amount) AS Total_Revenue,
	   min(Transaction_Date) AS Start_Date,
	   max(Transaction_Date) AS End_Date
FROM Store_Sales
WHERE Store_ID BETWEEN 701 AND 718;

