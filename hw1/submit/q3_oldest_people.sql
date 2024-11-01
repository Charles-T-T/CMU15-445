SELECT name, (died - born) AS age
FROM people
WHERE died IS NOT NULL
AND born >= 1900
ORDER BY age DESC, name ASC
LIMIT 20;