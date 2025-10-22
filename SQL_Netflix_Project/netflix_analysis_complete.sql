-- NETFLIX SHOWS AND MOVIES ANALYSIS - COMPLETE SQL SCRIPT
-- Dataset: Netflix TV Shows and Movies 2022
-- Source: https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies

-- STEP 1: EXPLORE THE DATASET
SELECT COUNT(*) AS total_movies
FROM titles
WHERE type = 'MOVIE';

SELECT COUNT(*) AS total_tv_shows
FROM titles
WHERE type = 'SHOW';

-- STEP 2: TOP 10 AND WORST 10 MOVIES AND TV SHOWS
SELECT title, type, imdb_score
FROM titles
WHERE type = 'MOVIE' AND imdb_score >= 8.0
ORDER BY imdb_score DESC
LIMIT 10;

SELECT title, type, imdb_score
FROM titles
WHERE type = 'MOVIE'
ORDER BY imdb_score ASC
LIMIT 10;

SELECT title, type, imdb_score
FROM titles
WHERE type = 'SHOW' AND imdb_score >= 8.0
ORDER BY imdb_score DESC
LIMIT 10;

SELECT title, type, imdb_score
FROM titles
WHERE type = 'SHOW'
ORDER BY imdb_score ASC
LIMIT 10;

-- STEP 3: TOP GENRES FOR MOVIES AND TV SHOWS
SELECT genres, 
       COUNT(*) AS number_of_titles
FROM titles 
WHERE type = 'MOVIE'
GROUP BY genres
ORDER BY number_of_titles DESC
LIMIT 10;

SELECT genres, 
       COUNT(*) AS number_of_titles
FROM titles 
WHERE type = 'SHOW'
GROUP BY genres
ORDER BY number_of_titles DESC
LIMIT 10;

SELECT genres, 
       COUNT(*) AS genre_title_count
FROM titles as t 
WHERE t.type = 'MOVIE' OR t.type = 'SHOW'
GROUP BY genres
ORDER BY genre_title_count DESC
LIMIT 3;

-- STEP 4: NUMBER OF MOVIES AND TV SHOWS BY DECADE
SELECT CONCAT(FLOOR(release_year/ 10) * 10, 's') AS decade,
       COUNT(*) AS movies_shows_count
FROM titles
WHERE release_year >= 1940
GROUP BY CONCAT(FLOOR(release_year/ 10) * 10, 's')
ORDER BY decade;

-- STEP 5: RELEASE YEAR - NUMBER OF TITLES AND WHICH ONE HAS THE MOST TITLES
SELECT release_year, 
       COUNT(*) AS title_count
FROM titles as t 
GROUP BY release_year
ORDER BY release_year DESC;

SELECT release_year, 
       COUNT(*) AS title_count
FROM titles as t 
GROUP BY release_year
ORDER BY title_count DESC
LIMIT 1;

-- STEP 6: RELEASE YEAR 2019 DEEPER DIVE
SELECT genres, 
       COUNT(*) as title_count
FROM titles as t
WHERE release_year = '2019'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 1;

SELECT title, type
FROM titles as t
WHERE release_year = '2019' AND t.genres IN
    (SELECT genres
     FROM titles as t
     WHERE release_year = '2019'
     GROUP BY genres
     ORDER BY COUNT(title) DESC
     LIMIT 1)
ORDER BY title ASC;

SELECT title, imdb_score
FROM titles
WHERE release_year = 2019
  AND SUBSTRING(genres,3,6) = 'comedy' 
  AND SUBSTRING(genres,10,2) = ']' 
  AND imdb_score IS NOT NULL
ORDER BY imdb_score DESC
LIMIT 1;

-- ADDITIONAL ANALYSIS QUERIES
SELECT 
    'Total Titles' as metric,
    COUNT(*) as value
FROM titles
UNION ALL
SELECT 
    'Total Movies' as metric,
    COUNT(*) as value
FROM titles
WHERE type = 'MOVIE'
UNION ALL
SELECT 
    'Total TV Shows' as metric,
    COUNT(*) as value
FROM titles
WHERE type = 'SHOW'
UNION ALL
SELECT 
    'Average IMDB Score' as metric,
    ROUND(AVG(imdb_score), 2) as value
FROM titles
WHERE imdb_score IS NOT NULL
UNION ALL
SELECT 
    'Highest IMDB Score' as metric,
    MAX(imdb_score) as value
FROM titles
WHERE imdb_score IS NOT NULL
UNION ALL
SELECT 
    'Lowest IMDB Score' as metric,
    MIN(imdb_score) as value
FROM titles
WHERE imdb_score IS NOT NULL;

SELECT 
    type,
    CONCAT(FLOOR(release_year/ 10) * 10, 's') AS decade,
    COUNT(*) AS count
FROM titles
WHERE release_year >= 1940
GROUP BY type, CONCAT(FLOOR(release_year/ 10) * 10, 's')
ORDER BY type, decade;

SELECT title, type, imdb_score, release_year, genres
FROM titles
WHERE imdb_score IS NOT NULL
ORDER BY imdb_score DESC
LIMIT 20;