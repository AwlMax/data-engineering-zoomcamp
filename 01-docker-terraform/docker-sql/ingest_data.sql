SELECT
    lpep_pickup_datetime,
    lpep_dropoff_datetime,
    total_amount,
    CONCAT(zpu."Borough", ' | ', zpu."Zone") AS "pickup_loc",
    CONCAT(zdo."Borough", ' | ', zdo."Zone") AS "dropoff_loc"
FROM
    green_taxi_data t,
    taxi_zone_lookup zpu,
    taxi_zone_lookup zdo
WHERE
    t."PULocationID" = zpu."LocationID"
    AND t."DOLocationID" = zdo."LocationID"
LIMIT 100;


SELECT
    lpep_pickup_datetime,
    lpep_dropoff_datetime,
    total_amount,
    CONCAT(zpu."Borough", ' | ', zpu."Zone") AS "pickup_loc",
    CONCAT(zdo."Borough", ' | ', zdo."Zone") AS "dropoff_loc"
FROM
    green_taxi_data t
RIGHT JOIN
    taxi_zone_lookup zpu ON t."PULocationID" = zpu."LocationID"
JOIN
    taxi_zone_lookup zdo ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;


SELECT
    CAST(lpep_dropoff_datetime AS DATE) AS "day",
    COUNT(1) AS "count"
FROM
    green_taxi_data
GROUP BY
    CAST(lpep_dropoff_datetime AS DATE)
ORDER BY
    "count" DESC
LIMIT 100;


SELECT
    CAST(lpep_dropoff_datetime AS DATE) AS "day",
    "DOLocationID",
    COUNT(1) AS "count",
    MAX(total_amount) AS "total_amount",
    MAX(passenger_count) AS "passenger_count"
FROM
    green_taxi_data
GROUP BY
    1, 2
ORDER BY
    "day" ASC,
    "DOLocationID" ASC
LIMIT 100;