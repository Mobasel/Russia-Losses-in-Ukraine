-- The next code will put the average growth rate of losses for each category in comparison.
WITH daily_changes AS (
    SELECT -- This view extract the daily growth rate of each category by subracting the losses of yesterday from today's losses.
        Date,
        Aircraft - LAG(Aircraft) OVER (ORDER BY Date) AS Aircraft_Growth,
        Helicopter - LAG(Helicopter) OVER (ORDER BY Date) AS Helicopter_Growth,
        Tank - LAG(Tank) OVER (ORDER BY Date) AS Tank_Growth,
        Apc - LAG(Apc) OVER (ORDER BY Date) AS Apc_Growth,
        [Field Artillery] - LAG([Field Artillery]) OVER (ORDER BY Date) AS Field_Artillery_Growth,
        Mrl - LAG(Mrl) OVER (ORDER BY Date) AS Mrl_Growth,
        Drone - LAG(Drone) OVER (ORDER BY Date) AS Drone_Growth,
        [Naval Ship] - LAG([Naval Ship]) OVER (ORDER BY Date) AS Naval_Ship_Growth,
        [Anti-Aircraft Warfare] - LAG([Anti-Aircraft Warfare]) OVER (ORDER BY Date) AS Anti_Aircraft_Growth,
        [Special Equipment] - LAG([Special Equipment]) OVER (ORDER BY Date) AS Special_Equipment_Growth,
        [Vehicles And Fuel Tanks] - LAG([Vehicles And Fuel Tanks]) OVER (ORDER BY Date) AS Vehicles_Fuel_Growth,
        [Cruise Missiles] - LAG([Cruise Missiles]) OVER (ORDER BY Date) AS Cruise_Missiles_Growth,
        Submarines - LAG(Submarines) OVER (ORDER BY Date) AS Submarines_Growth
    FROM russia_equipment

	-- WHERE Date >= DATEADD(DAY, -180, GETDATE()) 
	-- ** We can also add WHERE Clause to select only the average growth rate for each category for specific period of time like 6 months ago.
),
average_growth AS (
    SELECT -- This view gets the average daily growth for each category
        'Aircraft' AS Category, ROUND(AVG(Aircraft_Growth),2) AS Avg_Growth FROM daily_changes UNION ALL
    SELECT 'Helicopter', ROUND(AVG(Helicopter_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Tank', ROUND(AVG(Tank_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'APC', ROUND(AVG(Apc_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Field Artillery', ROUND(AVG(Field_Artillery_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'MRL', ROUND(AVG(Mrl_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Drone', ROUND(AVG(Drone_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Naval Ship', ROUND(AVG(Naval_Ship_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Anti-Aircraft Warfare', ROUND(AVG(Anti_Aircraft_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Special Equipment', ROUND(AVG(Special_Equipment_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Vehicles and Fuel Tanks', ROUND(AVG(Vehicles_Fuel_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Cruise Missiles', ROUND(AVG(Cruise_Missiles_Growth), 2) FROM daily_changes UNION ALL
    SELECT 'Submarines', ROUND(AVG(Submarines_Growth), 2) FROM daily_changes
)
-- The following query order the results by the average daily growth DESC
-- We can see that Vehicles and Fuel Tanks category has the highest daily growth, and Submarines has the lowest.
SELECT *
FROM average_growth
ORDER BY Avg_Growth DESC;