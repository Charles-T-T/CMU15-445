SELECT p.name, COUNT(*) AS NUM_APPEARANCES
FROM people p
JOIN crew c ON p.person_id = c.person_id
GROUP BY c.person_id
ORDER BY NUM_APPEARANCES DESC
LIMIT 20;