WITH NK_works AS (
  -- Nicole Kidman's all works (title_id)
  SELECT title_id
  FROM crew
  WHERE person_id = (
    SELECT person_id
    FROM people
    WHERE name = 'Nicole Kidman'
  )
)
SELECT DISTINCT(p.name)
FROM crew c
JOIN people p ON c.person_id = p.person_id
WHERE (c.category = 'actor' OR c.category = 'actress')
AND c.title_id IN NK_works
ORDER BY p.name ASC;