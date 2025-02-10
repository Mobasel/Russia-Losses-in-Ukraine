-- The following code extract each month total losses in comparison with the the last week losses to get the Month Growth Rate.
WITH ranked_data AS 
(
    SELECT 
        Date, 
        RANK() OVER (ORDER BY Date) AS ranked, [Total Losses] -- In this view, I ranked the records by date.
    FROM russia_equipment
),

Month_number AS 
(
SELECT CEILING(ranked / 30) AS Month_number, [Total Losses]	
FROM ranked_data -- In this view, I ranked the ranked data in the last view, to rank over it again, but, each 30 records, to get the Month no.
WHERE Date IS NOT NULL
), 
Last_month_losses AS 
(
SELECT Month_number, MAX([Total Losses]) AS Total_Monthly_Losses
FROM Month_number -- Because, the losses are accumulated, I used MaX to get the higher Total_losses which will be in the last day (30th), and this for each Month.
Group BY Month_number
)

-- The next query will select all the columns in the last view, then, adding the losses of the last month to extract the monthly growth rate in the following column.
-- It's ordered by the Monthly growth rate.

SELECT *, LAG(Total_Monthly_Losses, 1) OVER(ORDER BY Month_number) AS Last_week_losses, 
   ROUND(((Total_Monthly_Losses - LAG(Total_Monthly_Losses, 1) OVER(ORDER BY Month_number))*100)/ LAG(Total_Monthly_Losses, 1) OVER(ORDER BY Month_number), 2) AS Month_Growth_rate

FROM Last_month_losses
ORDER BY Month_Growth_rate DESC;greg