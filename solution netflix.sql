create database Netflixdb;
SHOW DATABASES;
USE netflixdb;
CREATE TABLE Netflix (
    show_id VARCHAR(6),
    typess VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year VARCHAR(10),
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(150),
    descriptions VARCHAR(250)
);
select * from Netflix;
select count(*) as total_content from Netflix;
SELECT DISTINCT typess FROM netflix;
-- business problems & soultions
-- count the number of Movies vs TV shows
select typess, count(*) as Total
from Netflix
group by typess;
-- find the most common rating for movies and tv shows
SELECT typess, COUNT(*) AS total
FROM Netflix
GROUP BY typess;
-- list all movies released in a specific year(e.g. 2020)
select show_id,typess,title,director,casts,country,date_added,release_year,rating,duration,listed_in,descriptions from Netflix
where typess= 'Movie';
-- find the top 5 countries with the most content on Netflix.
SELECT country_name, COUNT(*) AS total_content
FROM (
    SELECT TRIM(country_name) AS country_name
    FROM Netflix,
    JSON_TABLE(
        CONCAT('["', REPLACE(country, ',', '","'), '"]'),
        '$[*]' COLUMNS (country_name VARCHAR(100) PATH '$')
    ) AS jt
) AS country_list
GROUP BY country_name
ORDER BY total_content DESC
LIMIT 5;
-- identify the longest movie
select * from Netflix
order by Duration Desc
Limit 1;
-- method two
select * from netflix
where typess='Movie'and duration=(select max(duration)from netflix);
-- find contect added in the last 5 years
select *,str_to_date(date_added,'%d/%M/%y')from Netflix;
SELECT
    *,
    DATE_FORMAT(STR_TO_DATE(date_added, '%d-%b-%y'), '%d/%m/%Y') AS formatted_date
FROM Netflix;
select 
    *,
    DATE_FORMAT(STR_TO_DATE(date_added, '%d-%b-%y'), '%d/%m/%Y') AS formatted_date 
FROM Netflix
WHERE STR_TO_DATE(date_added, '%d-%b-%y') >= CURDATE() - INTERVAL 5 YEAR;
-- list all the movies/ TV shows by director 'Toshiya Shinohara'
SELECT *
FROM Netflix
WHERE director = 'Toshiya Shinohara';
-- list all tv shows with more than 5 seasons
select * from Netflix
where typess like 'TV Show%' and duration not like 'min%' and duration >'5 Seasons';
-- count the no. of content items in each genre
SELECT 
    genre,
    COUNT(*) AS total_content
FROM (
    SELECT 
        n.title,
        TRIM(jt.genre) AS genre
    FROM Netflix n,
    JSON_TABLE(
        CONCAT('["', REPLACE(n.listed_in, ', ', '","'), '"]'),
        '$[*]' COLUMNS (genre VARCHAR(255) PATH '$')
    ) AS jt
) AS genre_list
GROUP BY genre
ORDER BY total_content DESC;
-- List all movies that are documentaries
SELECT *
FROM (
    SELECT 
        n.typess,
        TRIM(jt.documentaries) AS documentaries
    FROM netflix n
    JOIN JSON_TABLE(
        CONCAT('["', REPLACE(n.listed_in, ', ', '","'), '"]'),
        '$[*]' COLUMNS (documentaries VARCHAR(255) PATH '$')
    ) AS jt
) AS documentaries_list
WHERE documentaries LIKE '%Documentaries%'
  AND typess LIKE '%Movie%';
 SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%'
  AND typess = 'Movie';
  -- Find all content without a director
SELECT *
FROM netflix
WHERE director = '';
-- Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM netflix
WHERE 
  casts LIKE '%Salman Khan%'
  AND release_year >= YEAR(CURDATE()) - 10;
-- Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
    TRIM(actor) AS actor,
    COUNT(*) AS appearances
FROM netflix
JOIN JSON_TABLE(
    CONCAT('["', REPLACE(casts, ',', '","'), '"]'),
    "$[*]" COLUMNS(actor VARCHAR(255) PATH "$")
) AS cast_list
WHERE country = 'India'
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
SELECT *,
       CASE 
           WHEN descriptions LIKE '%kill%' OR descriptions LIKE '%violence%' 
           THEN 'bad' 
           ELSE 'good' 
       END AS content_type
FROM netflix;











  
  

  






















   












 




