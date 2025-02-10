-- The next two views extract the current day total losses, the last day total losses, the difference between them, and the daily growth.

with last_day_losses AS
(SELECT Date, Day, [Total Losses] AS Today_total_losses, 
	   LAG([Total Losses], 1) OVER(ORDER BY Date) AS Last_day_losses
FROM russia_equipment
)

-- The following query will extract the current day total losses, the last day total losses, the difference between them, and the daily growth. Ordered by Date.
-- We can Also apply any filter to get the daily new cases that over a particular number to show when the losses have spiked.

SELECT *, (Today_total_losses - Last_day_losses) AS Today_new_losses, 
			ROUND((((Today_total_losses - Last_day_losses)*100)/Last_day_losses), 2) AS Daily_growth_in_losses
FROM last_day_losses
-- WHERE Daily_growth_in_losses >= 1.5
ORDER BY Daily_growth_in_losses desc;

-- The results are ordered by the daily growth rate with the highest daily growth rate in losses in the top.

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Aircrafts, Helicopters, and Tanks daily growth rate in comparison. 


-- The following Query puts the losses of Aircrafts, Helicopters, and Tanks in comparison.

With losses_comparison AS
(SELECT Date, year, Quarter, Day, 
	Aircraft AS Current_day_aircraft_losses, LAG(Aircraft, 1) OVER(ORDER BY  Date) AS Last_day_aircraft_losses, 
	(Aircraft - LAG(Aircraft, 1) OVER(ORDER BY  Date)) AS Newly_Aircraft_Losses, 

	Helicopter AS Current_day_Helicopter_losses, LAG(Helicopter, 1) OVER(ORDER BY  Date) AS Last_day_Helicopter_losses, 
	(Helicopter - LAG(Helicopter, 1) OVER(ORDER BY  Date)) AS Newly_Helicopter_Losses,

	Tank AS Current_day_tank_losses, LAG(Tank, 1) OVER(ORDER BY  Date) AS Last_day_Tank_losses,
	(Tank - LAG(Tank, 1) OVER(ORDER BY  Date)) AS Newly_Tank_Losses

FROM russia_equipment
)

SELECT Date, Year, Quarter, Day, 
	Newly_Aircraft_Losses,
	CONCAT(ROUND((Newly_Aircraft_Losses*100)/ Last_day_aircraft_losses , 2),  ' %') AS Aircraft_daily_growth,

	Newly_Helicopter_Losses, 
	CONCAT(ROUND(((Newly_Helicopter_Losses*100)/ Last_day_Helicopter_losses), 2), ' %') AS Helicopter_daily_growth,

	Newly_Tank_Losses, 
	CONCAT(ROUND(((Newly_Tank_Losses*100) / Last_day_Tank_losses), 2), ' %') AS Tank_daily_growth

FROM losses_comparison
WHERE Date IS NOT NULL
ORDER BY Date DESC;

-- From the results, we can see that the daily growth in lossses is not big for the Aircraft and Helicopter, 
-- but, the losses for the tanks is continuous, it's not huge as 2 years ago, but, still there are new daily losses.

	



