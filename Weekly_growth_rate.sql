-- The following code extract the week number from our data, and each week losses.
WITH ranked_data AS 
(
    SELECT 
        Date, 
        RANK() OVER (ORDER BY Date) AS Week_no, [Total Losses] -- In this view, I ranked the records by date.
    FROM russia_equipment
),
week_number AS
(SELECT Date, 
       CEILING(Week_no / 7) AS Week_num,  -- In this view, I ranked the already ranked data in the last view, to rank over it again, but, each 7 records, to get the week no.
	   [Total Losses]
FROM ranked_data
Where Date is not null
), 
last_week AS 
(
SELECT Week_num, MAX([Total Losses]) AS current_losses_per_week
FROM week_number -- Because, the losses are accumulated, I used MaX to get the higher Total_losses which will be in the last day (7th), and this for each week. 
Group by Week_num
)

-- The next query will select all the columns in the last view, then, adding the losses of the last week to extract the weekly growth rate in the following column.
-- It's ordered by the Weekly growth rate.
SELECT *, LAG(current_losses_per_week, 1) OVER(ORDER BY week_num) AS Last_week_total_losses, 
		ROUND(((current_losses_per_week - LAG(current_losses_per_week, 1) OVER(ORDER BY week_num))*100)/LAG(current_losses_per_week, 1) OVER(ORDER BY week_num), 2) 
				AS weekly_growth_rate
FROM last_week
Order BY weekly_growth_rate DESC;
