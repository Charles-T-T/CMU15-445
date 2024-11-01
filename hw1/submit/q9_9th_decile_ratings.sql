WITH avg_ratings AS (
  -- average movie rating of individuals born in 1955
  SELECT p.name, p.person_id, ROUND(AVG(r.rating), 2) as avg_rating
  FROM ratings r
  JOIN titles t ON r.title_id = t.title_id
  JOIN crew c ON c.title_id = r.title_id
  JOIN people p ON p.person_id = c.person_id
  WHERE p.born = 1955
  GROUP BY c.person_id
),
quantiles AS (
  SELECT 
    name, 
    avg_rating,
    NTILE(10) OVER (ORDER BY avg_rating ASC) AS quantile
  FROM avg_ratings
)
SELECT name, avg_rating
FROM quantiles
WHERE quantile = 9
ORDER BY avg_rating DESC, name ASC;