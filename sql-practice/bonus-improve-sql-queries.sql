----------
-- Step 0 - Create a Query 
----------
-- Query: Find a count of `toys` records that have a price greater than
    -- 55 and belong to a cat that has the color "Olive".
SELECT COUNT(*) FROM cat_toys
    WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive')
    AND toy_id IN (SELECT id FROM toys WHERE price > 55);
-- Paste your results below (as a comment): 215

DROP INDEX IF EXISTS idx_cats_color ;
DROP INDEX IF EXISTS idx_toys_price ;
----------
-- Step 1 - Analyze the Query
----------
-- Query:

EXPLAIN QUERY PLAN SELECT COUNT(*) FROM cat_toys
    WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive')
    AND toy_id IN (SELECT id FROM toys WHERE price > 55);

-- Paste your results below (as a comment):
-- QUERY PLAN
-- |--SCAN cat_toys
-- |--LIST SUBQUERY 1
-- |  `--SCAN cats
-- `--LIST SUBQUERY 2
--    `--SCAN toys

-- What do your results mean?

    -- Was this a SEARCH or SCAN?

        -- Double scans
    -- What does that mean?
        -- The query is going through each entry in cats and toys tables



----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):

.timer on
SELECT COUNT(*) FROM cat_toys
    WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive')
    AND toy_id IN (SELECT id FROM toys WHERE price > 55);
.timer off
-- Paste your results below (as a comment):

-- Run Time: real 0.002 user 0.002189 sys 0.000000


----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:

    CREATE INDEX idx_cats_color ON cats(id, color);
    CREATE INDEX idx_toys_price ON toys(id, price);

-- Analyze Query:
    EXPLAIN QUERY PLAN SELECT COUNT(*) FROM cat_toys
    WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive')
    AND toy_id IN (SELECT id FROM toys WHERE price > 55);

-- Paste your results below (as a comment):

-- QUERY PLAN
-- |--SCAN cat_toys
-- |--LIST SUBQUERY 1
-- |  `--SEARCH cats USING COVERING INDEX idx_cats_color (color=?)
-- `--LIST SUBQUERY 2
--    `--SCAN toys


-- Analyze Results:

    -- Is the new index being applied in this query?
        -- YES



----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

.timer on
SELECT COUNT(*) FROM cat_toys
    WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive')
    AND toy_id IN (SELECT id FROM toys WHERE price > 55);
.timer off

-- Paste your results below (as a comment):


-- Analyze Results:
    -- Are you still getting the correct query results?
        -- Yes

    -- Did the execution time improve (decrease)?
        -- Very slightly

    -- Do you see any other opportunities for making this query more efficient?
        -- ADD A SECOND INDEX


---------------------------------
-- Notes From Further Exploration
---------------------------------
