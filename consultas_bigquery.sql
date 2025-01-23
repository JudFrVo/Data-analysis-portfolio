
-- Fechas mínimas y máximas
SELECT MIN(Date) AS min_date, MAX(Date) AS max_date
FROM sales.sales_info;

-- Longitud mínima y máxima de un vehículo
SELECT MIN(length) AS min_length, MAX(length) AS max_length
FROM positive-notch-438915-r1.cars.car_info;

-- Promedio de temperatura en junio de 2020
SELECT AVG(temperature)
FROM positive-notch-438915-r1.demos.nyc_weather
WHERE date BETWEEN '2020-06-01' AND '2020-06-30';

-- Filtrar hospitalizaciones por industria
SELECT products_industry_name, COUNT(report_number) AS count_hospitalizations
FROM bigquery-public-data.fda_food.food_events
WHERE products_industry_name IN (
    SELECT products_industry_name
    FROM bigquery-public-data.fda_food.food_events
    GROUP BY products_industry_name
    ORDER BY COUNT(report_number) DESC LIMIT 10)
AND outcomes LIKE '%Hospitalization%'
GROUP BY products_industry_name
ORDER BY count_hospitalizations DESC;

-- Reportes por tipo de industria
SELECT products_industry_name, COUNT(report_number) AS count_reports
FROM bigquery-public-data.fda_food.food_events
GROUP BY products_industry_name
ORDER BY count_reports DESC
LIMIT 10;

-- Información de equipos y sus mascotes
SELECT seasons.market AS university, seasons.name AS team_name,
       mascots.mascot AS team_mascot, AVG(seasons.wins) AS avg_wins,
       AVG(seasons.losses) AS avg_losses, AVG(seasons.ties) AS avg_ties
FROM bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons AS seasons
INNER JOIN bigquery-public-data.ncaa_basketball.mascots AS mascots
ON seasons.team_id = mascots.id
WHERE seasons.season BETWEEN 1990 AND 1999
  AND seasons.division = 1
GROUP BY 1, 2, 3
ORDER BY avg_wins DESC, university;

-- Estaciones con duración promedio más alta
SELECT subquery.start_station_id, subquery.avg_duration
FROM (
    SELECT start_station_id, AVG(tripduration) AS avg_duration
    FROM bigquery-public-data.new_york_citibike.citibike_trips
    GROUP BY start_station_id) AS subquery
ORDER BY avg_duration DESC;

-- Actualizar valores mal escritos
UPDATE positive-notch-438915-r1.cars.car_info
SET num_of_cylinders = "two"
WHERE num_of_cylinders = "tow";

-- Eliminar registros con compresión incorrecta
DELETE FROM positive-notch-438915-r1.cars.car_info
WHERE compression_ratio = 70;

-- Corregir número de puertas
UPDATE positive-notch-438915-r1.cars.car_info
SET num_of_doors = "four"
WHERE make = "dodge" AND fuel_type = "gas" AND body_style = "sedan";

-- Duración promedio de viajes y su diferencia
SELECT starttime, start_station_id, tripduration,
       ROUND(tripduration - (SELECT AVG(tripduration)
                            FROM bigquery-public-data.new_york_citibike.citibike_trips
                            WHERE start_station_id = outer_trips.start_station_id), 2) AS difference_from_avg
FROM bigquery-public-data.new_york_citibike.citibike_trips AS outer_trips
ORDER BY difference_from_avg DESC
LIMIT 25;
