create database Airline_Passenger_Satisfaction;

select count(*)
from airline_passenger_satisfaction;

-- ============================================================
-- TASK: Data Quality Check
-- PURPOSE: Check for nulls and understand what we're working
--          with before writing any business queries
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    COUNT(*)                                    AS total_rows,
    SUM(CASE WHEN Satisfaction IS NULL 
        THEN 1 ELSE 0 END)                      AS null_satisfaction,
    SUM(CASE WHEN `Arrival Delay` IS NULL 
        THEN 1 ELSE 0 END)                      AS null_arrival_delay,
    SUM(CASE WHEN Age IS NULL 
        THEN 1 ELSE 0 END)                      AS null_age,
    MIN(Age)                                    AS min_age,
    MAX(Age)                                    AS max_age,
    MIN(`Flight Distance`)                      AS min_distance,
    MAX(`Flight Distance`)                      AS max_distance
FROM airline_passenger_satisfaction;

-- ============================================================
-- TASK: Overall Passenger Satisfaction Rate
-- PURPOSE: Find what percentage of passengers are satisfied
--          to understand the airline's overall performance
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    COUNT(*)                    AS total_passengers,
    SUM(CASE WHEN Satisfaction = 'Satisfied' 
        THEN 1 ELSE 0 END)      AS satisfied_count,
    ROUND(
        SUM(CASE WHEN Satisfaction = 'Satisfied' 
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    )                           AS satisfied_percentage
FROM airline_passenger_satisfaction;

-- ============================================================
-- TASK: Satisfaction Rate by Customer Type
-- PURPOSE: Understand if first-time vs returning customers
--          have different satisfaction levels
-- DIFFICULTY: Beginner
-- ============================================================

SELECT 
    `Customer Type`                        AS customer_type,
    COUNT(*)                     AS total_passengers,
    ROUND(SUM(CASE WHEN Satisfaction = 'Satisfied' 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS satisfied_percentage
FROM airline_passenger_satisfaction
GROUP BY `Customer Type`;

-- ============================================================
-- TASK: Satisfaction Rate by Type of Travel
-- PURPOSE: Understand if business travellers are more satisfied
--          than personal travellers to identify where to focus
--          service improvements
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    `type of travel`                        AS customer_type,
    COUNT(*)                     AS total_passengers,
    ROUND(SUM(CASE WHEN Satisfaction = 'Satisfied' 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS satisfied_percentage
FROM airline_passenger_satisfaction
GROUP BY `Type of Travel`;

-- ============================================================
-- TASK: Satisfaction Rate by Travel Class
-- PURPOSE: Identify which class of travel has the highest
--          satisfaction to understand where service excels
--          and where it falls short
-- DIFFICULTY: Beginner
-- ============================================================
SELECT 
    `class`                        AS customer_type,
    COUNT(*)                     AS total_passengers,
    ROUND(SUM(CASE WHEN Satisfaction = 'Satisfied' 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS satisfied_percentage
FROM airline_passenger_satisfaction
GROUP BY `class`;

-- ============================================================
-- TASK: Average Ratings by Satisfaction Group
-- PURPOSE: Identify which factors differ most between satisfied
--          and dissatisfied passengers — these are the key
--          drivers of satisfaction
-- DIFFICULTY: Intermediate
-- ============================================================
SELECT
    Satisfaction,
    ROUND(AVG(`Seat Comfort`), 2)            AS avg_seat_comfort,
    ROUND(AVG(`Food and Drink`), 2)          AS avg_food,
    ROUND(AVG(`In-flight Wifi Service`), 2)  AS avg_wifi,
    ROUND(AVG(`In-flight Entertainment`), 2) AS avg_entertainment,
    ROUND(AVG(`On-board Service`), 2)        AS avg_onboard,
    ROUND(AVG(`Leg Room Service`), 2)        AS avg_legroom,
    ROUND(AVG(`Cleanliness`), 2)             AS avg_cleanliness,
    ROUND(AVG(`Check-in Service`), 2)        AS avg_checkin,
    ROUND(AVG(`Online Boarding`), 2)         AS avg_boarding,
    ROUND(AVG(`Baggage Handling`), 2)        AS avg_baggage
FROM airline_passenger_satisfaction
GROUP BY Satisfaction;


-- ============================================================
-- TASK: Satisfaction Rate by Flight Distance
-- PURPOSE: Understand if flight distance affects passenger
--          satisfaction to identify where service improvements
--          are needed most
-- DIFFICULTY: Intermediate
-- ============================================================

SELECT
    CASE 
        WHEN `Flight Distance` < 1000 THEN 'Short Haul'
        WHEN `Flight Distance` BETWEEN 1000 AND 3000 THEN 'Medium Haul'
        ELSE 'Long Haul'
    END                    AS distance_group,
    COUNT(*)               AS total_passengers,
    ROUND(AVG(`Flight Distance`), 0) AS avg_distance,  ROUND(SUM(CASE WHEN Satisfaction = 'Satisfied' 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS satisfied_percentage
FROM airline_passenger_satisfaction
GROUP BY distance_group
ORDER BY avg_distance;

-- ============================================================
-- TASK: Worst Performing Service Factors
-- PURPOSE: Identify which service areas need the most urgent
--          improvement across all passengers
-- DIFFICULTY: Intermediate
-- ============================================================
SELECT 'In-flight Wifi Service'    AS factor, ROUND(AVG(`In-flight Wifi Service`), 2)    AS avg_rating FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Online Boarding',           ROUND(AVG(`Online Boarding`), 2)           FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Food and Drink',            ROUND(AVG(`Food and Drink`), 2)            FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Gate Location',             ROUND(AVG(`Gate Location`), 2)             FROM airline_passenger_satisfaction
UNION ALL
SELECT 'In-flight Entertainment',   ROUND(AVG(`In-flight Entertainment`), 2)   FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Seat Comfort',              ROUND(AVG(`Seat Comfort`), 2)              FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Leg Room Service',          ROUND(AVG(`Leg Room Service`), 2)          FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Cleanliness',               ROUND(AVG(`Cleanliness`), 2)               FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Check-in Service',          ROUND(AVG(`Check-in Service`), 2)          FROM airline_passenger_satisfaction
UNION ALL
SELECT 'Baggage Handling',          ROUND(AVG(`Baggage Handling`), 2)          FROM airline_passenger_satisfaction
ORDER BY avg_rating ASC;