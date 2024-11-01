SELECT t.primary_title, r.votes
FROM titles t
JOIN ratings r ON t.title_id = r.title_id
WHERE EXISTS (
  SELECT *
  FROM crew c
  JOIN people p ON c.person_id = p.person_id
  WHERE c.title_id = t.title_id
  AND p.name LIKE '%Cruise%' COLLATE BINARY
)
ORDER BY r.votes DESC
LIMIT 10;