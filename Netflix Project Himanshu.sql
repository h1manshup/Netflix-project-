/* PROJECT - 
Data cleaning and analysis for Netflix using SQL (DATED - 18-july-2023)

Netflix, a leading global streaming platform, possesses a dataset containing information about its shows.
 However, the dataset requires cleaning and analysis to derive valuable insights for business decision-making.
 As a data analyst with SQL expertise, your objective is to perform data cleaning and analysis on the Netflix 
 dataset to help the company gain insights into their content offerings.




NETFLIX ASSIGNMENT WITH ALL 8 SEGMENTS COVERED 
Pointers to be noted - 
1.Database name - netflix
2.Table name - netflixx
3.COlumn name TYPE is changed to content_type (for better udnerstanding).
4. All segments are line wise.
5. All query are checked and running succesfully at time of submission.
6.Appropriate comments are written with each segment best of my understanding.
7.The code is written concisely with appropriate indentations.

*/

-- SEGMENT 1 DATABASE - TABLES COLUMNS AND RELATIONSHIPS.

select * from netflixx;
use netflix;

-- QUESTION 1 
-- Netflixx is the table in dataset with columns details using decribe.
DESCRIBE netflixx;

--  QUESTION 2 Number of rows in the "netflixx" table output 8790 rows .
SELECT COUNT(*) AS no_rows FROM netflixx;

--  QUESTION 3 identify and handle any missing values in the dataset:
SELECT *
FROM netflixx
WHERE id IS NULL OR show_id IS NULL OR type IS NULL OR 
title IS NULL or director IS NULL or country IS NULL OR 
date_added IS NULL or release_year IS NULL or 
rating IS NULL or duration IS NULL or listed_in IS NULL;

-- output  no missinng value found zero  so null values are null and we can go ahead with segments and start solving query as no missing value treatment to be done in this case 




-- SEGMENT 2 CONTENT ANALYSIS


-- QUESTION 1 - Analyse the distribution of content types (movies vs. TV shows) in the dataset.

-- Count the number of movies and TV shows  - OUTPUT IS - TOTAL MOVIE - 6126 AND TV SHOW - 2664 

SELECT content_type, COUNT(*) AS content_count 
FROM netflixx GROUP BY content_type;
    
    
    
    
-- QUESTION 2. Determine the top 10 countries with the highest number of productions on Netflix.
--  number of productions by country and display the top 10 (with united states leading the chart with massive number of 3240 productions.
SELECT country,COUNT(*) AS production_count
FROM netflixx GROUP BY country
ORDER BY production_count DESC LIMIT 10;


-- QUESTION 3 Investigate the trend of content additions over the years.

-- trend edition number of content additions (upload of movie and tv shows) done by year till date and how fast it is increasing each year  
-- FROM 2016 TO 2021 MASSIVE UPLOAD INCREAMENT TREND
 
SELECT YEAR(STR_TO_DATE(date_added, '%m/%d/%Y')) AS year,
COUNT(*) AS content_count
FROM netflixx GROUP BY YEAR ORDER BY year;


-- question 4 Analyse the relationship between content duration and release year.
/*Calculate the  duration of content by release year  we can focus on the distribution 
of average content duration over different release years.
 group the data by release year and examine the various average content durations for seasons (in number) and movie in minutes
 available for each year. STARTING FROM 2008 , DISRTIBUTION OF DURATION OF CONTENT 
 */

select content_type,release_year,
       AVG(CASE WHEN content_type = 'Movie' THEN duration_minutes END) AS avg_movie_duration,
       AVG(CASE WHEN content_type = 'TV Show' THEN duration_seasons END) AS avg_tv_show_duration
FROM (
    SELECT *,
           CASE WHEN content_type = 'Movie' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_minutes,
           CASE WHEN content_type = 'TV Show' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_seasons
    FROM netflixx
) AS data  
group by content_type , release_year;


  
  
--  question 5 Count the number of productions by director and display the top 10 directors
-- made filter in director column by using count , order by , and limit funnction.
SELECT director, COUNT(*) AS production_count
FROM netflixx GROUP BY director
ORDER BY production_count DESC
LIMIT 10;
  
  
  
-- SEGMENT 3  GENRE(column name in tablle - listed_in)or Category Analysis 

SELECT * FROM netflix.netflixx;

use netflix;

-- 	question 1 Determine the unique genres / categories present in the dataset(distinct)
SELECT distinct content_type as genres,listed_in as categories 
FROM netflixx
group by TYPE,listed_in; 
 
-- question 2 	Calculate the percentage of movies and TV shows in each genre

-- output with 70% of movies against 30% of tv series but the trend of tv_series is growing phenominal in recent years 
SELECT content_type,COUNT(show_id)*100/(select count(show_id) from netflixx) as percentage 
FROM netflixx
group by content_type;



-- question 3 Identify the most popular genres/categories based on the number of productions.

-- output 1. Dramas, International Movies  following with documentires these are the most popular as its the most relased so customers are liking it .

SELECT listed_in AS genre_category,
       COUNT(*) AS production_count
FROM netflixx GROUP BY listed_in ORDER BY production_count DESC;


-- question 4  Calculate the cumulative sum of content duration within each genre.
-- movie  content duration- 610057
-- tv shows total seasons sum -  4667 seasons
 
 SELECT content_type , 
 sum(duration) as total_sum 
 from netflixx group by content_type;
 

 

-- SEGMENT 4 - Release Date Analysis 


SELECT * FROM netflix.netflixx;
use netflixx;

-- QUESTION 1 Determine the distribution of content releases by month and year.
-- with year and month complete table is in output for content year and month wise 
SELECT 
    MONTHNAME(STR_TO_DATE(date_added, '%m/%d/%Y')) AS month_name,
YEAR(STR_TO_DATE(date_added, '%m/%d/%Y')) AS year,
COUNT(*) AS count
FROM Netflixx
GROUP BY  month_name ,year;




--  QUESTION 2 Analyse the seasonal patterns in content releases.
-- seasonal pattern is almost same for netflix for each month , but most release are in month  july with total 827 dollowing december 
-- and may and feb are month with lowest realse can be very helful to analyse seasonal change in numbers 
SELECT
    count(*) as content_count,
    MONTHNAME(STR_TO_DATE(date_added, '%m/%d/%Y')) AS month_name
FROM
    netflixx
    GROUP BY  month_name ORDER BY content_count desc;




-- QUESTION 3 Identify the months and years with the highest number of releases.
-- jan-2021 with highest relase of 257. 

SELECT
     MONTHNAME(STR_TO_DATE(date_added, '%m/%d/%Y')) AS month_name,
    year(STR_TO_DATE(date_added, '%m/%d/%Y')) AS year,
COUNT(*) AS MOST_RELEASE
FROM NetflixX
GROUP BY month_name, year
ORDER BY MOST_RELEASE DESC;



-- SEGMENT 5  Rating Analysis 

-- question 1 Investigate the distribution of ratings across different genres:

/* This query will provide a list of genres, their corresponding ratings, 
and the count of each rating within each genre. 
This way, you can observe how different ratings are distributed 
across various genres on Netflix.
*/

SELECT listed_in,
       rating,
       COUNT(*) AS rating_count
FROM netflixx
GROUP BY listed_in, rating
ORDER BY rating_count desc;

-- question.2 Analyse the relationship between ratings and content duration.
/*  breakdown of ratings for each content duration. 
You can use this information to see how ratings are distributed 
across different content durations.
In this situation first did with minimum maximum  duration and second by average oF duration for season and movie 
 
 */

SELECT rating,
    MIN(CASE
        WHEN duration REGEXP '^[0-9]+$' THEN CAST(duration AS UNSIGNED)
        WHEN duration REGEXP '^[0-9]+ min$' THEN CAST(SUBSTRING(duration, 1, LENGTH(duration) - 4) AS UNSIGNED)
        ELSE NULL
    END) AS min_duration,
    MAX(CASE
        WHEN duration REGEXP '^[0-9]+$' THEN CAST(duration AS UNSIGNED)
        WHEN duration REGEXP '^[0-9]+ min$' THEN CAST(SUBSTRING(duration, 1, LENGTH(duration) - 4) AS UNSIGNED)
        ELSE NULL
    END) AS max_duration
FROM netflixx
WHERE duration IS NOT NULL AND duration <> ''
    AND (
        duration REGEXP '^[0-9]+$'
        OR duration REGEXP '^[0-9]+ min$'
    )
GROUP BY rating  ORDER BY rating DESC;
    
   
   
   -- option 2 
SELECT rating, 
AVG(CASE WHEN content_type = 'Movie' THEN duration_minutes END) AS avg_movie_duration,
AVG(CASE WHEN content_type = 'TV Show' THEN duration_seasons END) AS avg_tv_show_duration
FROM (
    SELECT *,
           CASE WHEN content_type = 'Movie' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_minutes,
           CASE WHEN content_type = 'TV Show' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_seasons
    FROM netflixx
) AS data GROUP BY rating order by rating ;
    
    
    
    
    
-- SEGMENT 6. co-occurence analysis 


-- Question 1 Identify the most common pairs of genres/categories that occur together in content.
/* Dramas, International Movies is the best category with co_occurence of 362 times.
*/

SELECT * FROM
(
SELECT distinct content_type,listed_in,
count(*) over (partition by content_type,listed_in) as co_occurence
FROM netflixx
) netflixx
where co_occurence>1 
ORDER BY co_occurence desc
;


-- Question 2 Analyse the relationship between genres/categories and content duration.   
/*relationship between  durqation and genre can be  best analysed by  using
 average comparision between both them side by side in terms of 
season and duration of movies in minutes as can be seen in output
 but for reference also done with SECOND METHOD by 	CO-OCCURENCE with each genre and duration.
*/
SELECT listed_in AS genre_category,
       AVG(CASE WHEN content_type = 'Movie' THEN duration_minutes END) AS avg_movie_duration,
       AVG(CASE WHEN content_type = 'TV Show' THEN duration_seasons END) AS avg_tv_show_duration
FROM (
    SELECT *,
           CASE WHEN content_type = 'Movie' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_minutes,
           CASE WHEN content_type = 'TV Show' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_seasons
    FROM netflix.netflixx
) AS data GROUP BY listed_in;
    
--  OR 
-- if we do by co_occurence method 

SELECT * FROM
(
SELECT distinct content_type,listed_in,duration,
count(*) over (partition by content_type,listed_in,duration) as co_occurence
FROM netflixx
) t
where co_occurence>1
ORDER BY content_type,listed_in,duration;






-- SEGMENT 7 INTERNATIONAL EXPANSION ANALYSIS 



-- question 1  identify the countries where Netflix has expanded its content offerings 

-- THIS WILL SHOW ALL COUNTRY WITH NETFLIX CONTENT 
SELECT DISTINCT country
FROM netflixx;
 
/* Using sum  for tv series and movied both and ordering in 
ascending format to see which country has lowest movies and tv shows
and we as a netflix can focus to bring content  from  there as well 
this country are with lowest movie and tv show so might be netflix starting listing this country movies and shows now only .
*/ 

SELECT country,count(*) as content_count,
    SUM(CASE WHEN content_type = 'Movie' THEN 1 ELSE 0 END) AS movies_count,
    SUM(CASE WHEN content_type = 'TV Show' THEN 1 ELSE 0 END) AS tv_shows_count
FROM netflixx GROUP BY country ORDER BY content_count asc;



-- question 2 Analyse the distribution of content types in different countries.

/* This query will provide a list of countries along with the count
 of movies and TV shows available from each country. It allows you to see the 
 distribution of content types from  different country and identify  more tv series or movies are from  which coutry 
 also to  analyse country content offering on netflix  for example egypt has 109 movies against only 14 tv-shows (that means egypt make more movies) ,  
 we can identify why this is and how to increase and research further  to improve and expand 
*/
SELECT  country,

    SUM(CASE WHEN content_type = 'Movie' THEN 1 ELSE 0 END) AS movies_count,
    SUM(CASE WHEN content_type = 'TV Show' THEN 1 ELSE 0 END) AS tv_shows_count
FROM netflixx
GROUP BY country ORDER BY country ;




-- question 3 Investigate the relationship between content duration and country of production.

/* question 3  This query will provide a breakdown of content
 durations for each content type in different countries,
 showing the avearge  of each content duration country wise .
*/


SELECT country,
       AVG(CASE WHEN content_type = 'Movie' THEN duration_minutes END) AS avg_movie_duration,
       AVG(CASE WHEN content_type = 'TV Show' THEN duration_seasons END) AS avg_tv_show_duration
FROM (
    SELECT *,
           CASE WHEN content_type = 'Movie' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_minutes,
           CASE WHEN content_type = 'TV Show' THEN CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) END AS duration_seasons
    FROM netflixx
) AS data
GROUP BY country;    
    
    
-- SEGMENT 8 Recommendations for Content Strategy

/*
question 1 Based on the analysis, provide recommendations for the types of content Netflix should focus on producing.
Based on the analysis of the dataset and the insights gathered from various segments, 
here are some recommendations for the types of content Netflix should focus on producing:

1. Original Series and Episodic Content: Invest in creating original series and episodic content across popular genres.
 The data suggests that TV shows are highly preferred by subscribers, and original content can help differentiate Netflix
 from competitors.

2. Popular Genres with Longer Content Duration**: Focus on producing content in genres 
that have both high production numbers and longer content durations. This includes genres 
like Drama, Comedy, and Crime, which have shown strong audience engagement.


3. Season-Based Content: Continue investing in series and episodic content,
 taking advantage of the popularity of season-based formats. Engaging storylines and well-crafted
 episodes can lead to increased viewer retention.

4. Exclusive Content and Franchises: Acquire exclusive rights to popular 
content and franchises to attract new subscribers and retain existing ones. 
Exclusive content creates a competitive advantage and drives viewer loyalty.

5. content for Specific Regions: Tailor content for specific regions to meet 
regional preferences and cultural tastes. Customizing content offerings can 
enhance engagement and viewership in those regions.


By implementing these recommendations, Netflix can enhance its content library, appeal to a wider audience, and maintain its position as a leading global streaming platform. The analysis provides valuable insights into viewer preferences, regional trends, and content performance, 
enabling Netflix to make informed decisions and tailor content strategies for continued growth and success.





question 2 -Identify potential areas for expansion and growth based on the analysis of the dataset.
Based on the analysis of the dataset and the potential areas for expansion and growth, here are some key potential areas that Netflix can consider for future growth:

1. International Expansion: Netflix should focus on expanding its content offerings 
in high-growth countries and emerging markets. Analyzing the dataset for countries with 
the highest number of productions and growth potential can help identify new markets for expansion.


2. and personalized content recommendations can enhance viewer satisfaction and retention. 
Utilizing data-driven insights to understand user behavior is critical in achieving this goal.

3. Embrace New Technologies: Exploring and investing in emerging technologies
 such as virtual reality, augmented reality, and interactive storytelling
 can create unique and immersive viewing experiences.

4. Continued Data Analysis: Netflix should continue to leverage data analysis 
to understand viewer behavior, content performance, and emerging trends. Data-driven decision-making 
will remain crucial for successful content strategies.

By strategically implementing these potential areas for expansion and growth, Netflix can 
strengthen its position as a global entertainment leader, attract new subscribers,
 and enhance viewer satisfaction across various regions and demographics.    

*/
