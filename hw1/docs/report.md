# Homework #1 - SQL

:man_student: Charles

---

### Q1 [0 points] (q1_sample):

The purpose of this query is to make sure that the formatting of your output matches exactly the formatting of our auto-grading script.

**Details:** List all Category Names ordered alphabetically.

**Answer**: Here's the correct SQL query and expected output:

```
sqlite> SELECT DISTINCT(language)
   ...> FROM akas
   ...> ORDER BY language
   ...> LIMIT 10;

af
ar
az
be
bg
bn
bs
ca
cmn
```

You should put this SQL query into the appropriate file (`q1_sample.sql`) in the submission directory (`placeholder`). The empty line in the result is there on purpose! A NULL value shows up as a blank line and is part of the intended output

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
SELECT DISTINCT(language)
FROM akas
ORDER BY language
LIMIT 10;
```

---

### Q2 [5 points] (q2_sci_fi):

Find the 10 `Sci-Fi` works with the longest runtimes.

**Details:** Print the title of the work, the premiere date, and the runtime. The column listing the runtime should be suffixed with the string " (mins)", for example, if the `runtime_mins` value is `12`, you should output `12 (mins)`. Note a work is `Sci-Fi` even if it is categorized in multiple genres, as long as `Sci-Fi` is one of the genres.
Your first row should look like this: `Cicak-Man 2: Planet Hitam|2008|999 (mins)`

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
SELECT primary_title, premiered, (runtime_minutes || ' (mins)') AS runtime_mins
FROM titles
WHERE genres LIKE '%Sci-Fi%'
ORDER BY runtime_minutes DESC
LIMIT 10;
```

> [!NOTE]
>
> 在SQLite中，用 `||` 来连接字符串，而不是像MySQL之类的DBMS那样用 `CONCAT` 。
>
> 我一开始用的 `CONCAT` ，本地能跑，但是提交到Gradescope上面提示 `no such function` ，可能是最新版本的 SQLite才开始支持 `CONCAT` 。
>
> btw，官方题解还显式地把 `runtime_minutes` 进行了类型转换：
>
> ```sql
> CAST(runtime_minutes AS VARCHAR) || " (mins)"
> ```
>
> 我没这么做，但是好在SQLite遇到 `||` 的时候会自动把非字符串类型转化为 `TEXT` 的。
>
> > [!CAUTION]
> >
> > 最后排序时要用 `INTEGER` 的 `runtime_minutes` ，我一开始写成字符串连接后的 `runtime_mins` 了，导致排序错误（变成按字符串字典序排了 :clown_face: ​）。

---

### Q3 [5 points] (q3_oldest_people):

Determine the oldest people in the dataset who were born in or after 1900. You should assume that a person without a known death year is still alive.

**Details:** Print the name and age of each person. People should be ordered by a compound value of their age and secondly their name in alphabetical order. Return the first 20 results.
Your output should have the format: `NAME|AGE`

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
SELECT 
  name, 
  CASE 
    WHEN died IS NOT NULL
    THEN died - born
    ELSE 2022 - born
  END AS age
FROM people
WHERE born >= 1900
ORDER BY age DESC, name ASC
LIMIT 20;
```

> [!CAUTION]
>
> 题目提示 *You should assume that a person without a known death year is still alive* ，让人很容易直接用
>
> ```sql
> WHERE died IS NOT NULL
> ```
>
> 来筛掉还活着的，但是活着的人也要用 `2022 - born` 来算年龄的啊 :rofl: ​

---

### Q4 [10 points] (q4_crew_appears_most):

Find the people who appear most frequently as crew members.

**Details:** Print the names and number of appearances of the 20 people with the most crew appearances ordered by their number of appearances in a descending fashion.
Your output should look like this: `NAME|NUM_APPEARANCES`

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
SELECT p.name, COUNT(*) AS NUM_APPEARANCES
FROM people p
JOIN crew c ON p.person_id = c.person_id
GROUP BY c.person_id
ORDER BY NUM_APPEARANCES DESC
LIMIT 20;
```

---

### Q5 [10 points] (q5_decade_ratings):

Compute intersting statistics on the ratings of content on a per-decade basis.

**Details:** Get the average rating (rounded to two decimal places), top rating, min rating, and the number of releases in each decade. Exclude titles which have not been premiered (i.e. where premiered is `NULL`). Print the relevant decade in a fancier format by constructing a string that looks like this: `1990s`. Order the decades first by their average rating in a descending fashion and secondly by the decade, ascending, to break ties.
Your output should have the format: `DECADE|AVG_RATING|TOP_RATING|MIN_RATING|NUM_RELEASES`

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
SELECT 
  ((t.premiered - t.premiered % 10) || 's') AS decade,
  ROUND(AVG(r.rating), 2) AS avg_rating,
  MAX(r.rating) AS top_rating,
  MIN(r.rating) AS min_rating,
  COUNT(*) AS num_releases
FROM titles t
JOIN ratings r ON t.title_id = r.title_id
WHERE t.premiered IS NOT NULL
GROUP BY decade
ORDER BY avg_rating DESC, decade ASC;
```

---

### Q6 [10 points] (q6_cruiseing_altitude):

Determine the most popular works with a person who has "Cruise" in their name and is born in 1962.

**Details:** Get the works with the most votes that have a person in the crew with "Cruise" in their name who was born in 1962. Return both the name of the work and the number of votes and only list the top 10 results in order from most to least votes. Make sure your output is formatted as follows: `Top Gun|408389`

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
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
```

---

### Q7 [15 points] (q7_year_of_thieves):

List the number of works that premiered in the same year that "Army of Thieves" premiered.

**Details:** Print only the total number of works. The answer should include "Army of Thieves" itself. For this question, determine distinct works by their `title_id`, not their names.

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
SELECT COUNT(*)
FROM titles
WHERE premiered = (
  SELECT premiered
  FROM titles
  WHERE primary_title = 'Army of Thieves'
);
```

---

### Q8 [15 points] (q8_kidman_colleagues):

List the all the different actors and actresses who have starred in a work with Nicole Kidman (born in 1967).

**Details:** Print only the names of the actors and actresses in alphabetical order. The answer should include Nicole Kidman herself. Each name should only appear once in the output.
**Note:** As mentioned in the schema, when considering the role of an individual on the crew, refer to the field `category`. The roles "actor" and "actress" are different and should be accounted for as such.

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
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
```

> [!CAUTION]
>
> 此处的 `WHERE` 判断语句中既有 `OR` 又有 `AND` ， **记得对 `OR` 部分加括号！** 
>
> 否则， **SQL中默认 `AND` 优先级更高** ，会导致本题判断逻辑错误。

---

### Q9 [15 points] (q9_9th_decile_ratings):

For all people born in 1955, get their name and average rating on all movies they have been part of through their careers. Output the 9th decile of individuals as measured by their average career movie rating.

**Details:** Calculate average ratings for each individual born in 1955 across only the **movies** they have been part of. Compute the quantiles for each individual's average rating using [NTILE(10)](https://www.sqlitetutorial.net/sqlite-window-functions/sqlite-ntile/).
Make sure your output is formatted as follows (round average rating to the nearest hundredth, results should be ordered by a compound value of their ratings descending and secondly their name in alphabetical order): `Stanley Nelson|7.13`
**Note:** You should take quantiles after processing the average career movie rating of individuals. In other words, find the individuals who have an average career movie rating in the 9th decile of all individuals.

:arrow_down_small: **My Answer** :arrow_down_small: 

```sql
WITH avg_ratings AS (
  -- average movie rating of individuals born in 1955
  SELECT p.name, p.person_id, ROUND(AVG(r.rating), 2) as avg_rating
  FROM ratings r
  JOIN titles t ON r.title_id = t.title_id
  JOIN crew c ON c.title_id = r.title_id
  JOIN people p ON p.person_id = c.person_id
  WHERE p.born = 1955 AND t.type = 'movie'
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
```

> [!NOTE]
>
> 我这个解法有点暴力，第一个CTE中直接连接了4张表 :eyes:
>
> 官方题解稍微优雅一丢丢：
>
> ```sql
> WITH actors_and_movies_1955 AS (
>      SELECT
>           people.person_id,
>           people.name,
>           titles.title_id,
>           titles.primary_title
>      FROM
>           people
>      INNER JOIN
>           crew ON people.person_id = crew.person_id
>      INNER JOIN
>           titles ON crew.title_id = titles.title_id
>      WHERE people.born = 1955 AND titles.type = "movie"
> ),
> actor_ratings AS (
>      SELECT
>           name,
>           ROUND(AVG(ratings.rating), 2) as rating
>      FROM ratings
>      INNER JOIN actors_and_movies_1955 ON ratings.title_id = actors_and_movies_1955.title_id
>      GROUP BY actors_and_movies_1955.person_id
> ),
> quartiles AS (
>      SELECT *, NTILE(10) OVER (ORDER BY rating ASC) AS RatingQuartile FROM actor_ratings
> )
> SELECT name, rating
> FROM quartiles
> WHERE RatingQuartile = 9
> ORDER BY rating DESC, name ASC;
> ```

---

TODO: q10
