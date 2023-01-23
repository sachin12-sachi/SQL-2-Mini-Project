			-- ICC Test Cricket-- 
-- 1.	Import the csv file to a table in the database.
CREATE DATABASE icc_test_cricket;
USE icc_test_cricket; 
SELECT *
FROM   `icc test batting figures`;

-- 2.	Remove the column 'Player Profile' from the table.
SELECT *
FROM   `icc test batting figures`;
ALTER TABLE `icc test batting figures` drop column `Player Profile`;
-- 3.	Extract the country name and player names from the given data and store it in seperate columns for further usage.
SELECT *
FROM   `icc test batting figures`
LIMIT  20;

ALTER TABLE `icc test batting figures`
  ADD COLUMN player_name VARCHAR(25);

SET sql_safe_updates = 0;

UPDATE `icc test batting figures`
SET    player_name = Substr(player, 1, Position('(' IN player) - 1)
WHERE  player_name IS NULL;

ALTER TABLE `icc test batting figures`
  modify COLUMN player_name VARCHAR(25) after player;

ALTER TABLE `icc test batting figures`
  ADD COLUMN country_name VARCHAR(10);

UPDATE `icc test batting figures`
SET    country_name = Substr(player, Position('(' IN player) + 1,
                      Length(player) - Position('(' IN player) - 2); 
-- 4.	From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.
ALTER TABLE `icc test batting figures`
  ADD COLUMN start_year INT;

UPDATE `icc test batting figures`
SET    start_year = Substr(span, 1, 4)
WHERE  start_year IS NULL;

ALTER TABLE `icc test batting figures`
  modify COLUMN start_year INT after span;

SELECT *
FROM   `icc test batting figures`
LIMIT  10;

ALTER TABLE `icc test batting figures`
ADD COLUMN end_year INT;
    
-- 5.	The column 'HS' has the highest score scored by the player so far in any given match.
## The column also has details if the player had completed the match in a NOT OUT status.
## Extract the data and store the highest runs and the NOT OUT status in different columns.
SELECT *
FROM   `icc test batting figures`
LIMIT  10;

ALTER TABLE `icc test batting figures`
  ADD COLUMN out_status VARCHAR(25);

UPDATE `icc test batting figures`
SET    out_status = ( CASE
                        WHEN Substr(hs, Length(hs)) = '*' THEN 'not out'
                        ELSE 'out'
                      end )
WHERE  out_status IS NULL;

ALTER TABLE `icc test batting figures`
  ADD COLUMN highest_runs INT;

UPDATE `icc test batting figures`
SET    highest_runs = ( CASE
                          WHEN Substr(hs, Length(hs)) = '*' THEN
                          Substr(hs, 1, Length(hs) - 1)
                          ELSE hs
                        end );

ALTER TABLE `icc test batting figures`
  modify COLUMN highest_runs INT after runs;

-- 6.	Using the data given, considering the players who were active in the year of 2019,
# create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.

SELECT   *,
         Rank() OVER(ORDER BY avg DESC) good_avg
FROM     `icc test batting figures`
WHERE    (
                  2019 BETWEEN start_year AND      end_year )
AND      country_name='INDIA' limit 6;

-- 7.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for India.

SELECT   *,
         Row_number() OVER( ORDER BY '100' DESC) no_of_100_ranking
FROM     `icc test batting figures`
WHERE    (
                  2019 BETWEEN start_year AND      end_year )
AND      country_name='INDIA' limit 6;
-- 8.	Using the data given, considering the players who were active in the year of 2019, 
# create a set of batting order of best 6 players using 2 selection criterias of your own for India.
SELECT   *,
         Rank() OVER( ORDER BY mat ) no_of_match
FROM     `icc test batting figures`
WHERE    (
                  2019 BETWEEN start_year AND      end_year )
AND      country_name='INDIA' limit 6;

SELECT   *,
         Row_number() OVER( ORDER BY '100','50' DESC) rank_ing
FROM     `icc test batting figures`
WHERE    (
                  2019 BETWEEN start_year AND      end_year )
AND      country_name='INDIA' limit 7;

-- 9.Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were active in the year of 2019,
 #create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for South Africa.
 
CREATE view batting_order_goodavgscorers_sa
AS
  SELECT *
  FROM   `icc test batting figures`
  WHERE  2019 BETWEEN start_year AND end_year
         AND country_name = 'SA'
  ORDER  BY avg DESC
  LIMIT  6;

SELECT *
FROM   batting_order_goodavgscorers_sa;  

-- 10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who were active in the year of 2019,
 #create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.
 
 CREATE OR REPLACE VIEW Batting_Order_HighestCenturyScorers_SA AS
    SELECT 
        *
    FROM
        `icc test batting figures`
    WHERE
        span LIKE '%2019'
            AND country_name = 'SA'
    GROUP BY player_name
    ORDER BY `100` DESC
    LIMIT 6;
    select * from Batting_Order_HighestCenturyScorers_SA;