
-- The following code extract the percentage of the losses_growth_rate over the quarters of each year.

WITH Quarter_losses AS 
( -- This view group the data by the year & quarter, and extract the maximum losses which will be in the last day of the quarter.
SELECT Year, Quarter, 
        MAX(Aircraft) AS Total_Aircraft,
        MAX(Helicopter) AS Total_Helicopter,
        MAX(Tank) AS Total_Tank,
        MAX(Apc) AS Total_APC,
        MAX([Field Artillery]) AS Total_Field_Artillery,
        MAX(Mrl) AS Total_MRL,
        MAX(Drone) AS Total_Drone,
        MAX([Naval Ship]) AS Total_Naval_Ship,
        MAX([Anti-Aircraft Warfare]) AS Total_Anti_Aircraft,
        MAX([Special Equipment]) AS Total_Special_Equipment,
        MAX([Vehicles And Fuel Tanks]) AS Total_Vehicles_Fuel,
        MAX([Cruise Missiles]) AS Total_Cruise_Missiles,
        MAX(Submarines) AS Total_Submarines

FROM russia_equipment
GROUP BY Year, Quarter
)

-- The next query extract will give us the percentage of the growth of losses quarterly, with a comparison between the losses of Tanks & Drones.
-- Ordered by year, quarter.
-- We can also partition by quarter to get the growth rate for the same quarter, but, last year.

SELECT 
    Year, Quarter, 
    Total_Tank, 
    LAG(Total_Tank) OVER (PARTITION BY Year ORDER BY Quarter) AS Previous_Quarter_Tank,
    CONCAT(ROUND((Total_Tank - LAG(Total_Tank) OVER (PARTITION BY Year ORDER BY Quarter)) * 100.0 
          / LAG(Total_Tank) OVER (PARTITION BY Year ORDER BY Quarter), 2), '%') AS Tank_Percent_Change,
    
    Total_Drone, 
    LAG(Total_Drone) OVER (PARTITION BY Year ORDER BY Quarter) AS Previous_Quarter_Drone,
    CONCAT(ROUND((Total_Drone - LAG(Total_Drone) OVER (PARTITION BY Year ORDER BY Quarter)) * 100.0 
          / LAG(Total_Drone) OVER (PARTITION BY Year ORDER BY Quarter), 2), '%') AS Drone_Percent_Change
		  
FROM Quarter_losses
ORDER BY Year DESC, Quarter DESC;
