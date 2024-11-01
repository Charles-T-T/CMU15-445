SELECT primary_title, premiered, (runtime_minutes || ' (mins)') AS runtime_mins
FROM titles
WHERE genres LIKE '%Sci-Fi%'
ORDER BY runtime_minutes DESC
LIMIT 10;