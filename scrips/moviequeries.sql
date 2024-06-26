-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
-- SELECT 
-- 	film_title AS title,
-- 	release_year,
-- 	worldwide_gross AS worldwide_gross
-- FROM specs
-- LEFT JOIN revenue
-- 	ON specs.movie_id = revenue.movie_id
-- 		order by worldwide_gross
-- limit 10;

-- "Semi-Tough"	1977	37187139


-- 2. What year has the highest average imdb rating?

-- Select
-- 	specs.release_year,
-- 	round(avg(rating.imdb_rating),2) as average_rating
-- from specs
-- 	left join rating
-- on specs.movie_id = rating.movie_id
	
-- 	group by specs.release_year
-- 	order by average_rating;

-- 	1983 6.50


-- 3. What is the highest grossing G-rated movie? Which company distributed it?

-- select 
-- 	distributors.distrbutor,
-- 	specs.movie_title,
-- 	revenue.worldwide_gross
-- from specs
-- left join revenue
-- 	on specs.movie_id = revenue.movie_id
-- left join distributors
-- 	on specs.domestic_distributor_id = distributors.distributor_id
	
-- where mpaa_rating = 'G'
-- order by worldwide_gross
-- limit 3;

-- ERRORRRS

-- 4. Write a query that returns, for each distributor in the distributors table,
-- the distributor name and the number of movies associated with that distributor 
-- 	in the movies table. 
-- Your result set should include all of the distributors, whether or not
-- they have any movies in the movies table.

-- SELECT 
-- 	distributors.company_name AS distributor_name,
-- 	count(specs.domestic_distributor_id) AS number_of_movies
-- FROM distributors
-- 	LEFT JOIN specs
-- 	ON distributors.distributor_id = specs.domestic_distributor_id
-- 	GROUP BY distributors.company_name
-- 	ORDER BY number_of_movies desc;

-- DONE

-- 5. Write a query that returns the five distributors with the 
-- highest average movie budget.

SELECT
	distributors.company_name AS company_name,
	AVG(revenue.film_budget) AS film_budget
FROM distributors
	LEFT JOIN specs
	ON distributors.distributor_id = specs.movie_id
	
	LEFT JOIN revenue
	ON specs.movie_id = revenue.movie_id
	GROUP BY company_name
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;

-- GETTING NULLS

-- 6. How many movies in the dataset are distributed by a company
-- which is not headquartered in California? 
-- Which of these movies has the highest imdb rating?

-- SELECT specs.film_title AS film_title,
-- 	rating.imdb_rating AS imdb_rating,
-- 	distributors.headquarters AS hq
-- From specs
-- 	left join distributors
-- 	on specs.domestic_distributor_id = distributors.distributor_id
-- 	left join rating
-- 	on specs.movie_id = rating.movie_id
-- WHERE distributors.headquarters NOT LIKE '%CA%'
-- ORDER BY imdb_rating desc
-- ;
-- 2 movies, dirty dancing 7 and my big fat greek wedding 6.5 were not in CA


-- 7. Which have a higher average rating, movies which are over two
-- hours long or movies which are under two hours?
-- SELECT
-- 	AVG(rating.IMDB_RATING) AS imdb_rating
-- FROM specs
-- 	LEFT JOIN rating
-- 	USING (movie_id)
-- WHERE (length_in_min/60) >= 2
-- ORDER BY IMDB_RATING;
-- imdb rating is this	7.2497584541062802

-- SELECT
-- 	AVG(rating.IMDB_RATING) AS imdb_rating
-- FROM specs
-- 	left join rating
-- 	USING (movie_id)
-- WHERE (length_in_min/60) < 2
-- ORDER BY IMDB_RATING;
-- imdb rating is this 6.9161434977578475

-- 2 hour run time wins

-- ## Joins Exercise Bonus Questions

-- 1.	Find the total worldwide gross and average imdb rating by decade. Then alter your query so it returns JUST the second highest average imdb rating and its decade. This should result in a table with just one row.

-- 2.	Our goal in this question is to compare the worldwide gross for movies compared to their sequels.   
-- 	a.	Start by finding all movies whose titles end with a space and then the number 2.  
-- 	b.	For each of these movies, create a new column showing the original film’s name by removing the last two characters of the film title. For example, for the film “Cars 2”, the original title would be “Cars”. Hint: You may find the string functions listed in Table 9-10 of https://www.postgresql.org/docs/current/functions-string.html to be helpful for this. 
-- 	c.	Bonus: This method will not work for movies like “Harry Potter and the Deathly Hallows: Part 2”, where the original title should be “Harry Potter and the Deathly Hallows: Part 1”. Modify your query to fix these issues.  
-- 	d.	Now, build off of the query you wrote for the previous part to pull in worldwide revenue for both the original movie and its sequel. Do sequels tend to make more in revenue? Hint: You will likely need to perform a self-join on the specs table in order to get the movie_id values for both the original films and their sequels. Bonus: A common data entry problem is trailing whitespace. In this dataset, it shows up in the film_title field, where the movie “Deadpool” is recorded as “Deadpool “. One way to fix this problem is to use the TRIM function. Incorporate this into your query to ensure that you are matching as many sequels as possible.

-- 3.	Sometimes movie series can be found by looking for titles that contain a colon. For example, Transformers: Dark of the Moon is part of the Transformers series of films.  
-- 	a.	Write a query which, for each film will extract the portion of the film name that occurs before the colon. For example, “Transformers: Dark of the Moon” should result in “Transformers”.  If the film title does not contain a colon, it should return the full film name. For example, “Transformers” should result in “Transformers”. Your query should return two columns, the film_title and the extracted value in a column named series. Hint: You may find the split_part function useful for this task.
-- 	b.	Keep only rows which actually belong to a series. Your results should not include “Shark Tale” but should include both “Transformers” and “Transformers: Dark of the Moon”. Hint: to accomplish this task, you could use a WHERE clause which checks whether the film title either contains a colon or is in the list of series values for films that do contain a colon.  
-- 	c.	Which film series contains the most installments?  
-- 	d.	Which film series has the highest average imdb rating? Which has the lowest average imdb rating?

-- 4.	How many film titles contain the word “the” either upper or lowercase? How many contain it twice? three times? four times? Hint: Look at the sting functions and operators here: https://www.postgresql.org/docs/current/functions-string.html 

-- 5.	For each distributor, find its highest rated movie. Report the company name, the film title, and the imdb rating. Hint: you may find the LATERAL keyword useful for this question. This keyword allows you to join two or more tables together and to reference columns provided by preceding FROM items in later items. See this article for examples of lateral joins in postgres: https://www.cybertec-postgresql.com/en/understanding-lateral-joins-in-postgresql/ 

-- 6.	Follow-up: Another way to answer 5 is to use DISTINCT ON so that your query returns only one row per company. You can read about DISTINCT ON on this page: https://www.postgresql.org/docs/current/sql-select.html. 

-- 7.	Which distributors had movies in the dataset that were released in consecutive years? For example, Orion Pictures released Dances with Wolves in 1990 and The Silence of the Lambs in 1991. Hint: Join the specs table to itself and think carefully about what you want to join ON. 