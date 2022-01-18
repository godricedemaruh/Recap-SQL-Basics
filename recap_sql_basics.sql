# Recap SQL Basics:
# Answer the questions

USE imdb_ijs;

# The big picture:

# How many actors are there in the actors table?
SELECT COUNT(id) FROM actors;   # 817718
# How many directors are there in the directors table?
SELECT COUNT(id) FROM directors;    # 86880
# How many movies are there in the movies table?
SELECT COUNT(id) FROM movies;    # 388269

# Exploring the movies

# From what year are the oldest and the newest movies? What are the names of those movies?
SELECT name, year FROM movies ORDER BY year ASC;   # oldest: Roundhay Garden Scene / 1888
SELECT name, year FROM movies ORDER BY year DESC;   # newest: Harry Potter and the Half-Blood Prince / 2008
# What movies have the highest and the lowest ranks?
SELECT name, rank FROM movies WHERE rank = 1;
SELECT name, rank FROM movies WHERE RANK >= 9.8 ORDER BY rank DESC;
# What is the most common movie title?
SELECT name, COUNT(name) FROM movies GROUP BY name HAVING COUNT(name) > 10 ORDER BY COUNT(name) DESC;

# Understanding the database

# Are there movies with multiple directors?
SELECT movie_id, COUNT(director_id) FROM movies_directors
GROUP BY movie_id
HAVING COUNT(director_id) > 1
ORDER BY COUNT(director_id) DESC;
# What is the movie with the most directors? Why do you think it has so many?  # movie_id = 382052 / the series has 26 seasons.
SELECT * FROM movies_directors
LEFT JOIN movies ON movie_id = id
WHERE movie_id = 382052;
# On average, how many actors are listed by movie?
# ....
# Are there movies with more than one “genre”?
SELECT movie_id, COUNT(genre) FROM movies_genres GROUP BY movie_id ORDER BY COUNT(genre) DESC;

# Looking for specific movies

# Can you find the movie called “Pulp Fiction”?
SELECT * FROM movies WHERE name = 'Pulp Fiction';
# Who directed it?
SELECT * FROM movies m
LEFT JOIN movies_directors md ON m.id = md.movie_id
LEFT JOIN directors d ON md.director_id = d.id
WHERE name = 'Pulp Fiction';
# Which actors where casted on it?
SELECT a.id, a.first_name, a.last_name FROM movies m
LEFT JOIN roles r ON m.id = r.movie_id
LEFT JOIN actors a ON r.actor_id = a.id
WHERE name = 'Pulp Fiction';

# Can you find the movie called “La Dolce Vita”?
SELECT * FROM movies WHERE name LIKE '%Dolce Vita%';   #  id = 89572
# Who directed it?
SELECT * FROM movies m
INNER JOIN movies_directors md on m.id = md.movie_id
INNER JOIN directors d on md.director_id = d.id
WHERE m.id = 89572;
# Which actors where casted on it?
SELECT a.id, a.first_name, a.last_name FROM movies m
INNER JOIN roles r on m.id = r.movie_id
INNER JOIN actors a on r.actor_id = a.id
WHERE m.id = 89572;

# When was the movie “Titanic” by James Cameron released?
SELECT * FROM movies m
INNER JOIN movies_directors md on m.id = md.movie_id
INNER JOIN directors d on md.director_id = d.id
WHERE m.name LIKE '%titanic%' AND d.last_name like '%cameron%';

# Actors and directors

# Who is the actor that acted more times as “Himself”?
SELECT a.id, a.first_name, a.last_name, COUNT(movie_id) FROM actors a
INNER JOIN roles r ON a.id = r.actor_id
WHERE r.role = 'Himself'
GROUP BY a.id, a.first_name, a.last_name
HAVING COUNT(movie_id) > 1
ORDER BY COUNT(movie_id) DESC;
# WAIT A SECOND, IS THAT TRUE???
SELECT * FROM actors a
INNER JOIN roles r ON a.id = r.actor_id
INNER JOIN movies m ON r.movie_id = m.id
WHERE last_name = 'Hitler';
# What is the most common name for actors? And for directors?
SELECT last_name, COUNT(id) FROM actors
GROUP BY last_name
ORDER BY COUNT(id) DESC
LIMIT 1 OFFSET 0;

# Analysing genders

# How many actors are male and how many are female?
SELECT gender, COUNT(id) FROM actors
GROUP BY gender;
# relation = 0.593

# Movies across time

# How many of the movies were released after the year 2000?
SELECT COUNT(id) FROM movies
WHERE year > 2000;
# How many of the movies where released between the years 1990 and 2000?
SELECT COUNT(id) FROM movies
WHERE 1990 <= year <= 2000;
# Which are the 3 years with the most movies? How many movies were produced on those years?
SELECT year, COUNT(id) FROM movies
GROUP BY year
ORDER BY COUNT(id) DESC
LIMIT 3 OFFSET 0;
# What are the top 5 movie genres?
SELECT genre, COUNT(movie_id) FROM movies_genres
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 5 OFFSET 0;
# What are the top 5 movie genres before 1920?
SELECT mg.genre, COUNT(mg.movie_id) FROM movies_genres mg
INNER JOIN movies m ON mg.movie_id = m.id
WHERE m.year < 1920 
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 5 OFFSET 0;
# What is the evolution of the top movie genres across all the decades of the 20th century?
SELECT mg.genre, COUNT(mg.movie_id) FROM movies_genres mg
INNER JOIN movies m ON mg.movie_id = m.id
WHERE 1900 <= m.year < 2000 
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 5 OFFSET 0;  # change the year range to get the data for each decade....

# Putting it all together: names, genders and time

# Has the most common name for actors changed over time?
# Get the most common actor name for each decade in the XX century.
# Re-do the analysis on most common names, splitted for males and females.
SELECT gender, COUNT(id) FROM actors  # How do I get the names in it????
GROUP BY gender
ORDER BY COUNT(id) DESC;
# Is the proportion of female directors greater after 1968, compared to before 1968?
# Data ?
# What is the movie genre where there are the most female directors? Answer the question both in absolute and relative terms.
# Data ?
# How many movies had a majority of females among their cast? Answer the question both in absolute and relative terms.
SELECT gender, COUNT(r.actor_id), r.movie_id FROM movies m
INNER JOIN roles r ON m.id = r.movie_id
INNER JOIN actors a ON r.actor_id = a.id
GROUP BY gender, r.movie_id
ORDER BY COUNT(r.actor_id) DESC; ##### not finished


