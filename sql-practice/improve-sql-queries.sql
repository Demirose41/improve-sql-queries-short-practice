----------
-- Step 0 - Create a Query 
----------
-- Query: Select all cats that have a toy with an id of 5

-- SELECT name FROM cats 
-- WHERE id IN (
--     SELECT cat_id
--     FROM cat_toys
--     WHERE 
--         toy_id = 5
-- );

-- Paste your results below (as a comment):

-- Rodger
-- Jamal
-- Rachele


DROP INDEX idx_covering_index; 
----------
-- Step 1 - Analyze the Query
----------
-- Query:

EXPLAIN QUERY PLAN SELECT * FROM cats 
WHERE id IN (
    SELECT cat_id
    FROM cat_toys
    WHERE 
        toy_id = 5
);

-- Paste your results below (as a comment):

-- QUERY PLAN
--SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
--LIST SUBQUERY 1
   --SCAN cat_toys


-- What do your results mean?

    -- Was this a SEARCH or SCAN?
        -- SCAN

    -- What does that mean?
        -- Our query is going through each row in hte cat_toys tables



----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):


.timer on
SELECT name FROM cats 
WHERE id IN (
    SELECT cat_id
    FROM cat_toys
    WHERE 
        toy_id = 5
);
.timer off
-- Paste your results below (as a comment):

-- Run Time: real 0.001 user 0.000305 sys 0.000000



----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:


CREATE UNIQUE INDEX idx_covering_index ON cat_toys(toy_id,cat_id);

-- Analyze Query:

EXPLAIN QUERY PLAN SELECT * FROM cats 
WHERE id IN (
    SELECT cat_id
    FROM cat_toys
    WHERE 
        toy_id = 5
);

-- Paste your results below (as a comment):

-- QUERY PLAN
-- |--SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 1
--    `--SEARCH cat_toys USING COVERING INDEX idx_covering_index (toy_id=?)
-- Run Time: real 0.001 user 0.000054 sys 0.000000

-- Analyze Results:

    -- Is the new index being applied in this query?
    -- yes



----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

.timer on
SELECT name FROM cats 
WHERE id IN (
    SELECT cat_id
    FROM cat_toys
    WHERE 
        toy_id = 5
);
.timer off

-- Paste your results below (as a comment):

-- QUERY PLAN
-- |--SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
-- `--LIST SUBQUERY 1
--    `--SEARCH cat_toys USING COVERING INDEX idx_covering_index (toy_id=?)
-- Rodger
-- Jamal
-- Rachele
-- Run Time: real 0.000 user 0.000065 sys 0.000000

-- Analyze Results:
    -- Are you still getting the correct query results?

      -- Yes

    -- Did the execution time improve (decrease)?

        -- Yes

    -- Do you see any other opportunities for making this query more efficient?

        -- 

---------------------------------
-- Notes From Further Exploration
---------------------------------