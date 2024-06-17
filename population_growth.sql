/* PART A. Data cleaning and preprocessing codes */ 


/* Change column names */
ALTER TABLE population_and_demography RENAME COLUMN "Country name" TO country_name;
ALTER TABLE population_and_demography RENAME COLUMN "Year" TO population_year;
ALTER TABLE population_and_demography RENAME COLUMN "Population" TO population;
ALTER TABLE population_and_demography RENAME COLUMN "Population of children under the age of 1" TO population_children_under_1;
ALTER TABLE population_and_demography RENAME COLUMN "Population of children under the age of 5" TO population_children_under_5;
ALTER TABLE population_and_demography RENAME COLUMN "Population of children under the age of 15" TO population_children_under_15;
ALTER TABLE population_and_demography RENAME COLUMN "Population under the age of 25" TO population_under_25;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 15 to 64 years" TO population_15_to_64;
ALTER TABLE population_and_demography RENAME COLUMN "Population older than 15 years" TO population_older_15;
ALTER TABLE population_and_demography RENAME COLUMN "Population older than 18 years" TO population_older_18;
ALTER TABLE population_and_demography RENAME COLUMN "Population at age 1" TO population_at_1;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 1 to 4 years" TO population_1_to_4;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 5 to 9 years" TO population_5_to_9;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 10 to 14 years" TO population_10_to_14;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 15 to 19 years" TO population_15_to_19;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 20 to 29 years" TO population_20_to_29;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 30 to 39 years" TO population_30_to_39;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 40 to 49 years" TO population_40_to_49;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 50 to 59 years" TO population_50_to_59;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 60 to 69 years" TO population_60_to_69;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 70 to 79 years" TO population_70_to_79;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 80 to 89 years" TO population_80_to_89;
ALTER TABLE population_and_demography RENAME COLUMN "Population aged 90 to 99 years" TO population_90_to_99;
ALTER TABLE population_and_demography RENAME COLUMN "Population older than 100 years" TO population_100_above;
ALTER TABLE population_and_demography RENAME COLUMN population__all__20_24__records TO population_all_20_to_24;
ALTER TABLE population_and_demography RENAME COLUMN population__all__25_29__records TO population_all_25_to_29;
ALTER TABLE population_and_demography RENAME COLUMN population__all__30_34__records TO population_all_30_to_34;
ALTER TABLE population_and_demography RENAME COLUMN population__all__35_39__records TO population_all_35_to_39;
ALTER TABLE population_and_demography RENAME COLUMN population__all__40_44__records TO population_all_40_to_44;
ALTER TABLE population_and_demography RENAME COLUMN population__all__45_49__records TO population_all_45_to_49;
ALTER TABLE population_and_demography RENAME COLUMN population__all__50_54__records TO population_all_50_to_54;
ALTER TABLE population_and_demography RENAME COLUMN population__all__55_59__records TO population_all_55_to_59;
ALTER TABLE population_and_demography RENAME COLUMN population__all__60_64__records TO population_all_60_to_64;
ALTER TABLE population_and_demography RENAME COLUMN population__all__65_69__records TO population_all_65_to_69;
ALTER TABLE population_and_demography RENAME COLUMN population__all__70_74__records TO population_all_70_to_74;
ALTER TABLE population_and_demography RENAME COLUMN population__all__75_79__records TO population_all_75_to_79;
ALTER TABLE population_and_demography RENAME COLUMN population__all__80_84__records TO population_all_80_to_84;
ALTER TABLE population_and_demography RENAME COLUMN population__all__85_89__records TO population_all_85_to_89;
ALTER TABLE population_and_demography RENAME COLUMN population__all__90_94__records TO population_all_90_to_94;
ALTER TABLE population_and_demography RENAME COLUMN population__all__95_99__records TO population_all_95_to_99;



/* Update records */
SELECT DISTINCT country_name
FROM population_and_demography
WHERE country_name LIKE '%(UN)%';

/* Add record_type to table */
ALTER TABLE population_and_demography 
ADD COLUMN record_type VARCHAR(100);

UPDATE population_and_demography 
SET record_type = 'Continent'
WHERE country_name LIKE '%(UN)%';


SELECT DISTINCT country_name
FROM population_and_demography
WHERE record_type IS NULL;

UPDATE population_and_demography 
SET record_type = 'Category'
WHERE country_name IN (
	'High-income countries',
	'Land-locked developing countries (LLDC)',
	'Least developed countries',
	'Less developed regions',
	'Less developed regions, excluding China',
	'Less developed regions, excluding least developed countries',
	'Low-income countries',
	'Lower-middle-income countries',
	'More developed regions',
	'Small island developing states (SIDS)',
	'Upper-middle-income countries',
	'World'
	);

UPDATE population_and_demography 
SET record_type = 'Country'
WHERE record_type IS NULL;

/* to check */
SELECT *
FROM population_and_demography;



/* PART B. Questions */


/* Question 1: What is the population of people aged 90+ in each country? */

SELECT 
	country_name,
	population_year,
	population_90_to_99 + population_100_above AS pop_90_above
FROM population_and_demography
WHERE population_year = 2021 and record_type = 'Country'
ORDER BY country_name;



/* Question 2: Which countries have the highest population growth in the last year 
 * (number of people, and by percentage)?  */

SELECT 
	country_name,
	population_2020,
	population_2021,
	population_2021 - population_2020 AS pop_growth_num,
	ROUND(CAST((population_2021 - population_2020) AS DECIMAL) / population_2020 * 100, 2) AS pop_growth_pct
FROM (
	SELECT 
		p.country_name,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2020
	) AS population_2020,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2021
	) AS population_2021
	FROM population_and_demography p
	WHERE p.record_type = 'Country'
	AND p.population_year = 2021
) p3
ORDER BY pop_growth_num DESC;



/* Question 3: Which single country has the highest population decline in the last year? */

SELECT 
	country_name,
	population_2020,
	population_2021,
	population_2021 - population_2020 AS pop_growth_num,
	ROUND(CAST((population_2021 - population_2020) AS DECIMAL) / population_2020 * 100, 2) AS pop_growth_pct
FROM (
	SELECT 
		p.country_name,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2020
	) AS population_2020,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2021
	) AS population_2021
	FROM population_and_demography p
	WHERE p.record_type = 'Country'
	AND p.population_year = 2021
) p3
ORDER BY pop_growth_num ASC
LIMIT 1;



/* Question 4: Which age group has the highest population out of all countries in the last year? */

SELECT *
FROM population_and_demography
WHERE country_name = 'World' AND population_year = 2021;

SELECT 
UNNEST(array[
	'population_1_to_9',
	'population_10_to_19',
	'population_20_to_29',
	'population_30_to_39',
	'population_40_to_49',
	'population_50_to_59',
	'population_60_to_69',
	'population_70_to_79',
	'population_80_to_89',
	'population_90_to_99'
]) AS age_group,
UNNEST(array[
	population_1_to_4 + population_5_to_9,
	population_10_to_14 + population_15_to_19,
	population_20_to_29,
	population_30_to_39,
	population_40_to_49,
	population_50_to_59,
	population_60_to_69,
	population_70_to_79,
	population_80_to_89,
	population_90_to_99
]) AS population
FROM population_and_demography
WHERE country_name = 'World' AND population_year = 2021
ORDER BY population DESC;



/* Question 5: What are the top 10 countries with the highest population growth in the last 10 years 
 * (based on the population number, not percentage)?  */

SELECT 
	country_name,
	population_2011,
	population_2021,
	population_2021 - population_2011 AS pop_growth_num
FROM (
	SELECT 
		p.country_name,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2011
	) AS population_2011,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2021
	) AS population_2021
	FROM population_and_demography p
	WHERE p.record_type = 'Country'
	AND p.population_year = 2021
) p3
ORDER BY pop_growth_num DESC
LIMIT 10;



/* Question 6: Which country has the highest percentage growth since the first year (1950)? */

CREATE VIEW population_by_year AS
SELECT 
	country_name,
	population_1950,
	population_2011,
	population_2020,
	population_2021
FROM (
	SELECT 
		p.country_name,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 1950
	) AS population_1950,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2011
	) AS population_2011,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2020
	) AS population_2020,
	(
		SELECT p1.population
		FROM population_and_demography p1
		WHERE p1.country_name = p.country_name
		AND p1.population_year = 2021
	) AS population_2021
	FROM population_and_demography p
	WHERE p.record_type = 'Country'
	AND p.population_year = 2021
) p3;



SELECT 
	country_name,
	population_1950,
	population_2021,
	ROUND(CAST((population_2021 - population_1950) AS DECIMAL) / population_1950 * 100, 2) AS pop_growth_pct
FROM population_by_year
ORDER BY pop_growth_pct DESC;



/* Question 7: Which country has the highest population at age 1 as a percentage of their overall population? */

SELECT 
	country_name,
	population,
	population_at_1,
	ROUND(CAST(population_at_1 AS DECIMAL) / population * 100, 2) AS pop_ratio
FROM population_and_demography
WHERE record_type = 'Country'
AND population_year = 2021
ORDER BY pop_ratio DESC;
	


/* Question 8: What is the population of each continent in each year, and how much has it changed each year? */

SELECT
	country_name,
	population_year,
	population,
	LAG(population, 1) OVER(
		PARTITION BY country_name 
		ORDER BY population_year ASC) AS population_change
FROM population_and_demography
WHERE record_type = 'Continent'
ORDER BY country_name ASC, population_year ASC;

