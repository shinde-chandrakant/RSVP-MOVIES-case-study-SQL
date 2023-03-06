USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*) AS director_mapping_records
FROM
    director_mapping;

-- director_mapping table has 3867 no. of rows.


SELECT 
    COUNT(*) AS genre_records
FROM
    genre;

-- genre table has 14662 no. of rows.


SELECT 
    COUNT(*) AS movie_records
FROM
    movie;

-- movie table has 7997 no. of rows.


SELECT 
    COUNT(*) AS names_records
FROM
    names;

-- names table has 25735 no. of rows.


SELECT 
    COUNT(*) AS ratings_records
FROM
    ratings;

-- ratings table has 7997 no. of rows.


SELECT 
    COUNT(*) AS role_mapping_records
FROM
    role_mapping;

-- role_mapping table has 15615 no. of rows.


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select 
	sum(case when id is null then 1 else 0 end) as id_null_count, 
    sum(case when title is null then 1 else 0 end) as title_null_count,
    sum(case when year is null then 1 else 0 end) as year_null_count,
    sum(case when date_published is null then 1 else 0 end) as date_published_null_count,
    sum(case when duration is null then 1 else 0 end) as duration_null_count,
    sum(case when country is null then 1 else 0 end) as country_null_count,
    sum(case when worlwide_gross_income is null then 1 else 0 end) as  world_gross_income_null_count,
    sum(case when languages is null then 1 else 0 end) as languages_null_count,
    sum(case when production_company is null then 1 else 0 end) as production_company_null_count

from movie;

-- columns with null values: 

-- worlwide_gross_income - 3724
-- production_company - 528
-- languages - 194
-- country - 20


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year;


SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;


-- Observations: 
-- 1. We see negative trend in movie release year on year. 
-- 2. Highest no. movies were released in month of March and in December movie release count was low.


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) AS movie_count
FROM
    movie
WHERE
    year = 2019
        AND (country REGEXP 'USA'
        OR country REGEXP 'India');

-- Observation:
-- 1059 movies were produced in the USA or India in the year 2019


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre AS genre
FROM
    genre;


-- List of Genre: Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery, Others


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, COUNT(id) AS movies
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
WHERE
    year = 2019
GROUP BY genre
ORDER BY movies DESC
LIMIT 1;

-- Drama Genre has highest no. of movies i.e. 1078 in year 2019.

SELECT 
    genre, COUNT(id) AS movies
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY genre
ORDER BY movies DESC
LIMIT 1 ;

-- Drama Genre has highest no. of movies i.e. 4285 overall.



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH single_genre_count AS
(
SELECT 
	movie_id,
    COUNT(genre) as genre_count
FROM
    genre
GROUP BY movie_id
HAVING COUNT(genre) = 1
)
SELECT 
	COUNT(movie_id) AS movie_count
FROM single_genre_count;


-- Observations: 3289 movies belong to only one genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC ;


-- Observations: Average duration for genre Action is highest i.e. 113 min. Whereas Horror has less duration (92.72).


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH rank_genre AS (
SELECT 
    genre, 
    COUNT(id) AS movies_count,
    rank() over(order by COUNT(id) desc) AS genre_rank
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY genre
)
SELECT *
FROM rank_genre
where genre = 'Thriller';


-- Observations: Rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced is 3.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;
    
 
-- Observation: So, the minimum and maximum values in each column of the ratings table are in the expected range. 
-- This implies there are no outliers in the table.


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT 
	title,
    avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM 
	ratings AS r
    INNER JOIN movie AS m 
    ON r.movie_id = m.id
LIMIT 10 ;


/*
Observations: 
Top 10 movies were having average rating above 9.4.
Top 10 movies by average rating:
	Kirket
	Love in Kilnerry
	Gini Helida Kathe
	Runam
	Fan
	Android Kunjappan Version 5.25
	Yeh Suhaagraat Impossible
	Safe
	The Brighton Miracle
	Shibu
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT
	median_rating,
    COUNT(movie_id) AS movie_count
FROM 
	ratings
GROUP BY median_rating
ORDER BY movie_count DESC ;


-- Observations: We have highest movie count of 2257 for median rating 7.




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_rank AS
(
SELECT 
	production_company,
	COUNT(id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM 
	movie AS m
	INNER JOIN ratings AS r
    ON m.id = r.movie_id
WHERE avg_rating > 8 AND production_company is NOT NULL
GROUP BY production_company
)
SELECT
	*
FROM
	production_company_rank
WHERE prod_company_rank = 1;


-- Observation: RSVP Movies can partner with Dream Warrior Pictures or National Theatre Live for its next project.


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, COUNT(id) AS movies_count
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
        INNER JOIN
    genre AS g ON m.id = g.movie_id
WHERE
    MONTH(date_published) = 03
        AND year = 2017
        AND country REGEXP 'USA'
        AND total_votes > 1000
GROUP BY genre
ORDER BY movies_count DESC ;


-- Observations: In March 2017 movies released in USA, Drama genre was having highest 
-- movies released whereas Family genre was having lowest movies released. 



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, avg_rating, genre
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
        INNER JOIN
    genre AS g ON m.id = g.movie_id
WHERE title regexp '^The' AND avg_rating > 8 
ORDER BY avg_rating DESC;


-- Observation: The movie "The Brighton Miracle" has highest avg_rating of 9.5


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT COUNT(id) AS movie_count
FROM
	movie m
		INNER JOIN 
    ratings r ON m.id = r.movie_id
WHERE median_rating = 8 AND date_published BETWEEN '2018-04-01' AND '2019-04-01' ;


-- Observations: 361 movies released between 1 April 2018 and 1 April 2019 with median rating of 8.



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


WITH movies_in_german
     AS (SELECT languages, SUM(total_votes) AS T_votes
         FROM   ratings r
                inner join movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%German%'
         GROUP  BY languages) 
SELECT 'German'         AS LANGUAGE,
       SUM(T_votes) AS Total_votes
FROM   movies_in_german

UNION

(WITH movies_in_italian
     AS (SELECT languages, SUM(total_votes) AS T_votes
         FROM   ratings r
                inner join movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Italian%'
         GROUP  BY languages)
SELECT 'Italian'        AS LANGUAGE,
       SUM(T_votes) AS Total_votes
FROM   movies_in_italian);



-- Observations: 
-- When checking language-wise German movies has total votes 4421525 whereas Italian movies has 2559540 votes.
-- So we can say that German movies get more votes than Italian movies.
 

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


select 
	sum(case when name is null then 1 else 0 end) as name_nulls, 
    sum(case when height is null then 1 else 0 end) as height_nulls,
    sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
    sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls

from names;

/*
Observations: 
name - 0 nulls
height - 17335 nulls
date_of_birth - 13431 nulls
known_for_movies - 15226 nulls
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top3genre AS(
	SELECT genre
		FROM
			genre g
				INNER JOIN
			ratings m ON g.movie_id = m.movie_id
		WHERE avg_rating > 8
		GROUP BY genre
		ORDER BY COUNT(g.movie_id) DESC
		LIMIT 3
)
SELECT name AS director_name, COUNT(d.movie_id) AS movie_count
FROM
	genre g
		INNER JOIN
	director_mapping d ON g.movie_id = d.movie_id
		INNER JOIN
	names n ON d.name_id = n.id
		INNER JOIN
	ratings r ON r.movie_id = d.movie_id
WHERE avg_rating > 8 AND genre IN (SELECT genre FROM top3genre) 
GROUP BY name
ORDER BY movie_count DESC
LIMIT 3
;


-- Observations: 
-- James Mangold, Anthony Russo, Joe Russo are top 3 directors. 
-- James Mangold can be hired as the director for RSVP's next project.
-- Top 3 genre were Drama, Comedy, Thriller based on movie count.


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_actors AS
(
SELECT 
	name AS actor_name, 
    COUNT(r.movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actor_rank
FROM
	names n
		INNER JOIN 
	role_mapping rm ON n.id = rm.name_id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
WHERE median_rating >=8 AND category = 'actor'
GROUP BY name
ORDER BY movie_count DESC 
)
SELECT
	actor_name,
    movie_count
FROM 
	top_actors
WHERE actor_rank <=2;


-- Observations: Based on ratings and movie count, top 2 ranked actors are: Mammootty, Mohanlal



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_production_house AS
(
SELECT
	production_company,
    SUM(total_votes) AS vote_count,
    RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM
	movie m
		INNER JOIN
	ratings r ON m.id = r.movie_id 
GROUP BY production_company
)
SELECT *
FROM top_production_house
WHERE prod_comp_rank <=3 ;


-- Observations: 
-- Top 3 production Houses based on vote count: Marvel Studios, Twentieth Century Fox, Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH indian_actor AS
(
SELECT 
	name AS actor_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(total_votes * avg_rating)/ SUM(total_votes), 2) AS actor_avg_rating,
    RANK() OVER(ORDER BY SUM(total_votes * avg_rating)/ SUM(total_votes) DESC, SUM(total_votes) DESC) AS actor_rank
FROM
	names n
		INNER JOIN
	role_mapping rm ON rm.name_id = n.id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
		INNER JOIN
	movie m ON m.id = r.movie_id
WHERE country REGEXP 'India' AND category = 'actor'
GROUP BY name
HAVING movie_count >= 5 
)
SELECT *
FROM indian_actor
WHERE actor_rank = 1 ;


-- Observations:
-- Vijay Sethupathi is having highest average rating of 8.42 with 5 movies released in India.


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH indian_actress AS
(
SELECT 
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(total_votes * avg_rating)/ SUM(total_votes), 2) AS actress_avg_rating,
    RANK() OVER(ORDER BY SUM(total_votes * avg_rating)/ SUM(total_votes) DESC, SUM(total_votes) DESC) AS actress_rank
FROM
	names n
		INNER JOIN
	role_mapping rm ON rm.name_id = n.id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
		INNER JOIN
	movie m ON m.id = r.movie_id
WHERE country REGEXP 'India' AND category = 'actress' AND languages REGEXP 'Hindi'
GROUP BY name
HAVING movie_count >= 3
)
SELECT *
FROM indian_actress
WHERE actress_rank <= 5 ;


-- Observations:
-- Top actress names by average ratings: 
	-- Taapsee Pannu
	-- Kriti Sanon
	-- Divya Dutta
	-- Shraddha Kapoor
	-- Kriti Kharbanda


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
	title,
    avg_rating,
    (CASE
		WHEN avg_rating >8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
        END ) AS movie_category
FROM
	movie m
		INNER JOIN
	ratings r ON m.id = r.movie_id
		INNER JOIN
	genre g ON r.movie_id = g.movie_id
WHERE genre = 'Thriller';



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_wise_avg_duration AS
(
	SELECT 
		genre,
		AVG(duration) AS avg_duration
	FROM 
		genre g
			INNER JOIN
		movie m ON g.movie_id = m.id
	GROUP BY genre
)
SELECT 
	*,
    ROUND(SUM(avg_duration) OVER w, 2) AS running_total_duration,
    ROUND(AVG(avg_duration) OVER w, 2) AS moving_avg_duration
FROM 
	genre_wise_avg_duration
WINDOW 
w AS (ORDER BY avg_duration ROWS UNBOUNDED PRECEDING)
;

-- Observations: Action and Romance genre have high average duration for movies.
-- Romance	109.5342
-- Action	112.8829


-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top3genre AS(
	SELECT genre
	FROM
		genre
	GROUP BY genre
	ORDER BY COUNT(movie_id) DESC
	LIMIT 3
), currency_converted AS
(
SELECT
	id,
    CASE
		 WHEN worlwide_gross_income LIKE 'INR%' 
			THEN Cast(Replace(worlwide_gross_income, 'INR', '') AS DECIMAL(12)) / 75
		 WHEN worlwide_gross_income LIKE '$%' 
			THEN Cast(Replace(worlwide_gross_income, '$', '') AS DECIMAL(12))
		 ELSE Cast(worlwide_gross_income AS DECIMAL(12))
	END AS worldwide_gross_income
FROM 
	movie
), ranked_movies AS
(SELECT 
	genre,
	year,
    title AS movie_name,
	ROUND(cc.worldwide_gross_income) AS 'worldwide_gross_income ($)',
    DENSE_RANK() OVER(PARTITION BY year ORDER BY cc.worldwide_gross_income DESC) movie_rank
FROM
	movie m
		INNER JOIN
    genre g ON m.id = g.movie_id
		INNER JOIN 
	currency_converted cc On cc.id = m.id
WHERE genre IN (SELECT * FROM top3genre)
)
SELECT* FROM ranked_movies
WHERE movie_rank <=5 ;

/*
Observations: Top 5 movies by gross world-wide income

2017	The Fate of the Furious
		Despicable Me 3
		Jumanji: Welcome to the Jungle
		Zhan lang II
		Guardians of the Galaxy Vol. 2
        
2018	Bohemian Rhapsody
		Venom
		Mission: Impossible - Fallout
		Deadpool 2
		Ant-Man and the Wasp

2019	Avengers: Endgame
		The Lion King
		Toy Story 4
		Joker
		Ne Zha zhi mo tong jiang shi
*/


-- Top 3 Genres based on most number of movies
-- Drama
-- Comedy
-- Thriller



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_rank as
(
SELECT
	production_company,
    COUNT(id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(id) DESC) prod_comp_rank
FROM
	movie m
		INNER JOIN
	ratings r ON m.id = r.movie_id
WHERE median_rating >= 8 AND POSITION(',' IN languages)>0 AND production_company IS NOT NULL
GROUP BY production_company
)
SELECT *
FROM production_company_rank
WHERE prod_comp_rank <=2 ;


-- Observations: 
-- Star Cinema, Twentieth Century Fox are top 2 production companys which produced higher number of Multilingual movies.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_ranking AS
(
SELECT 
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(total_votes * avg_rating)/SUM(total_votes), 2) AS actress_avg_rating,
	ROW_NUMBER() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank 
FROM
	names n
		INNER JOIN
	role_mapping rm ON n.id = rm.name_id
		INNER JOIN
	genre g ON g.movie_id = rm.movie_id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
WHERE avg_rating > 8 AND genre = 'Drama' AND category = 'actress'
GROUP BY name 
)
SELECT *
FROM actress_ranking
WHERE actress_rank <=3 ;


-- Observations:
-- 	Top 3 actress: 
-- 	Parvathy Thiruvothu, Susan Brown, Amanda Lawrence 


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_info AS
(
SELECT
	dm.name_id AS director_id,
    name AS director_name,
    dm.movie_id AS movie_id,
    date_published,
    LEAD(date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY date_published) AS next_date_published,
    total_votes,
    avg_rating,
    duration
FROM
	names n
		INNER JOIN
	director_mapping dm ON dm.name_id = n.id
		INNER JOIN 
	movie m ON m.id = dm.movie_id
		INNER JOIN
	ratings r ON r.movie_id = m.id
), top_directors AS
(
SELECT 
	director_id,
    director_name,
	COUNT(movie_id) number_of_movies,
	ROUND(AVG(datediff(next_date_published, date_published)), 2) as avg_inter_movie_days,
    ROUND(SUM(avg_rating * total_votes)/ SUM(total_votes), 2) AS avg_rating,
    SUM(total_votes)AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) as movie_rank
FROM
	director_info
GROUP BY director_id 
)
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   top_directors
WHERE  movie_rank <= 9;


/*
Observations:
Based on movies directed these are the top 9 directores: 
	A.L. Vijay
	Andrew Jones
	Steven Soderbergh
	Jesse V. Johnson
	Sam Liu
	Sion Sono
	Chris Stokes
	Justin Price
	Özgür Bakar
*/