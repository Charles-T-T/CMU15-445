-- -- CREATE INDEX ix_people_name ON people (name);
-- -- CREATE INDEX ix_titles_type ON titles (type);
-- -- CREATE INDEX ix_titles_primary_title ON titles (primary_title);
-- -- CREATE INDEX ix_titles_original_title ON titles (original_title);
-- -- CREATE INDEX ix_akas_title_id ON akas (title_id); 
-- -- CREATE INDEX ix_akas_title ON akas (title);
-- -- CREATE INDEX ix_crew_title_id ON crew (title_id);
-- -- CREATE INDEX ix_crew_person_id ON crew (person_id);

-- -- q1
-- SELECT DISTINCT(language)
-- FROM akas
-- ORDER BY language
-- LIMIT 10;

-- -- q2
-- SELECT primary_title, premiered, (runtime_minutes || ' (mins)') AS runtime_mins
-- FROM titles
-- WHERE genres LIKE '%Sci-Fi%'
-- ORDER BY runtime_minutes DESC
-- LIMIT 10;

-- q3
SELECT name, (died - born) AS age
FROM people
WHERE died IS NOT NULL
AND born >= 1900
ORDER BY age DESC, name ASC
LIMIT 20;

-- -- q4
-- SELECT p.name, COUNT(*) AS NUM_APPEARANCES
-- FROM people p
-- JOIN crew c ON p.person_id = c.person_id
-- GROUP BY c.person_id
-- ORDER BY NUM_APPEARANCES DESC
-- LIMIT 20;

-- -- q5
-- SELECT 
--   ((t.premiered - t.premiered % 10) || 's') AS decade,
--   ROUND(AVG(r.rating), 2) AS avg_rating,
--   MAX(r.rating) AS top_rating,
--   MIN(r.rating) AS min_rating,
--   COUNT(*) AS num_releases
-- FROM titles t
-- JOIN ratings r ON t.title_id = r.title_id
-- WHERE t.premiered IS NOT NULL
-- GROUP BY decade
-- ORDER BY avg_rating DESC, decade ASC;

-- -- q6
-- SELECT t.primary_title, r.votes
-- FROM titles t
-- JOIN ratings r ON t.title_id = r.title_id
-- WHERE EXISTS (
--   SELECT *
--   FROM crew c
--   JOIN people p ON c.person_id = p.person_id
--   WHERE c.title_id = t.title_id
--   AND p.name LIKE '%Cruise%' COLLATE BINARY
-- )
-- ORDER BY r.votes DESC
-- LIMIT 10;

-- -- q7
-- SELECT COUNT(*)
-- FROM titles
-- WHERE premiered = (
--   SELECT premiered
--   FROM titles
--   WHERE primary_title = 'Army of Thieves'
-- );

-- -- q8
-- WITH NK_works AS (
--   -- Nicole Kidman's all works (title_id)
--   SELECT title_id
--   FROM crew
--   WHERE person_id = (
--     SELECT person_id
--     FROM people
--     WHERE name = 'Nicole Kidman'
--   )
-- )
-- SELECT DISTINCT(p.name)
-- FROM crew c
-- JOIN people p ON c.person_id = p.person_id
-- WHERE c.category = 'actor' OR c.category = 'actress'
-- AND c.title_id IN NK_works
-- ORDER BY p.name;

-- -- q9
-- WITH avg_ratings AS (
--   -- average movie rating of individuals born in 1955
--   SELECT p.name, p.person_id, ROUND(AVG(r.rating), 2) as avg_rating
--   FROM ratings r
--   JOIN titles t ON r.title_id = t.title_id
--   JOIN crew c ON c.title_id = r.title_id
--   JOIN people p ON p.person_id = c.person_id
--   WHERE p.born = 1955
--   GROUP BY c.person_id
-- ),
-- quantiles AS (
--   SELECT 
--     name, 
--     avg_rating,
--     NTILE(10) OVER (ORDER BY avg_rating ASC) AS quantile
--   FROM avg_ratings
-- )
-- SELECT name, avg_rating
-- FROM quantiles
-- WHERE quantile = 9
-- ORDER BY avg_rating DESC, name ASC;

-- q10

