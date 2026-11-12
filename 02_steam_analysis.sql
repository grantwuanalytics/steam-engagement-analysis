-- ============================================================
-- STEAM GAME ANALYSIS
-- 02 | Pricing, Engagement & Genre Analysis
-- ============================================================
-- Purpose:
-- Analyze commercial Steam games to identify relationships
-- between pricing, player engagement, and review sentiment.
--
-- Input: steam_games_clean
-- Output: steam_commercial_games and analytical summaries
-- ============================================================


-- 1. PREPARE COMMERCIAL GAME DATASET
-- Exclude free games, low-review titles, and missing categories.

DROP TABLE IF EXISTS steam_commercial_games;

CREATE TABLE steam_commercial_games AS
SELECT
    app_id,
    name,
    release_date,
    price,
    genres,
    categories,
    metacritic_score,
    positive_reviews,
    negative_reviews,
    (positive_reviews + negative_reviews) AS total_reviews,
    ROUND(
        positive_reviews::numeric /
        NULLIF(positive_reviews + negative_reviews, 0) * 100,
        2
    ) AS positive_pct,
    avg_hours_played,
    peak_ccu
FROM steam_games_clean
WHERE price > 0
    AND (positive_reviews + negative_reviews) >= 10
    AND categories IS NOT NULL
    AND TRIM(categories) NOT IN ('', '[]');


-- Validate the filtered dataset.
SELECT COUNT(*) AS total_games
FROM steam_commercial_games;


-- 2. PRICING ANALYSIS
-- Examine the distribution of commercial game prices.

SELECT
    ROUND(AVG(price), 2) AS mean_price,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) AS p25_price,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price) AS median_price,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) AS p75_price,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY price) AS p90_price,
    ROUND(STDDEV(price), 2) AS std_dev_price
FROM steam_commercial_games;


-- 3. PRICE-TIER PERFORMANCE
-- Compare game counts, pricing, reviews, and engagement
-- across five custom price segments.

SELECT
    CASE
        WHEN price < 5.00 THEN '1. Budget (< $5)'
        WHEN price < 15.00 THEN '2. Standard ($5 - $14.99)'
        WHEN price < 30.00 THEN '3. Mid-Tier ($15 - $29.99)'
        WHEN price < 55.00 THEN '4. High-Tier ($30 - $54.99)'
        ELSE '5. Premium ($55+)'
    END AS price_tier,
    COUNT(*) AS game_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(positive_pct), 2) AS avg_positive_pct,
    ROUND(AVG(total_reviews), 0) AS avg_total_reviews,
    ROUND(AVG(peak_ccu), 0) AS avg_peak_ccu,
    ROUND(AVG(avg_hours_played), 2) AS avg_hours_played
FROM steam_commercial_games
GROUP BY price_tier
ORDER BY price_tier;

-- 4. PRICING & PLAYER ENGAGEMENT
-- Investigate whether higher game prices are associated
-- with lower playtime and differences in review sentiment.
-- Compare both mean and median playtime to identify skew.

SELECT
    CASE
        WHEN price < 5.00 THEN '1. Budget (< $5)'
        WHEN price < 15.00 THEN '2. Standard ($5 - $14.99)'
        WHEN price < 30.00 THEN '3. Mid-Tier ($15 - $29.99)'
        WHEN price < 55.00 THEN '4. High-Tier ($30 - $54.99)'
        ELSE '5. Premium ($55+)'
    END AS price_tier,
    COUNT(*) AS total_games,
    ROUND(AVG(avg_hours_played), 2) AS mean_hours_played,
    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY avg_hours_played) AS median_hours_played,
    ROUND(AVG(peak_ccu), 0) AS avg_peak_ccu,
    ROUND(AVG(positive_pct), 2) AS avg_positive_pct
FROM steam_commercial_games
GROUP BY price_tier
ORDER BY price_tier;


-- Inspect high-priced games with unusually high playtime.
-- This helps identify potential outliers or non-game software.

SELECT
    app_id,
    name,
    price,
    avg_hours_played,
    peak_ccu,
    categories
FROM steam_commercial_games
WHERE price >= 60
ORDER BY avg_hours_played DESC;

-- 5. ENGAGEMENT ANALYSIS BY PRICE TIER
-- Compare player engagement and review sentiment across
-- price segments using two exploratory engagement ratios.

SELECT
    CASE
        WHEN price < 5.00 THEN '1. Budget (< $5)'
        WHEN price < 15.00 THEN '2. Standard ($5 - $14.99)'
        WHEN price < 30.00 THEN '3. Mid-Tier ($15 - $29.99)'
        WHEN price < 55.00 THEN '4. High-Tier ($30 - $54.99)'
        ELSE '5. Premium ($55+)'
    END AS price_tier,
    COUNT(*) AS total_games,
    ROUND(AVG(peak_ccu), 0) AS avg_peak_ccu,
    ROUND(AVG(avg_hours_played), 2) AS mean_hours_played,

    -- Peak concurrent players relative to review volume.
    ROUND(
        AVG(peak_ccu::numeric / NULLIF(total_reviews, 0)),
        4
    ) AS hype_ratio,

    -- Average playtime relative to peak concurrent players.
    ROUND(
        AVG(avg_hours_played::numeric / NULLIF(peak_ccu, 0)),
        2
    ) AS retention_ratio,

    ROUND(AVG(positive_pct), 2) AS avg_positive_pct
FROM steam_commercial_games
GROUP BY price_tier
ORDER BY price_tier;

-- 6. GENRE PERFORMANCE ANALYSIS
-- Split multi-genre entries into individual genres and
-- compare game counts, pricing, engagement, and sentiment.

WITH unnested_data AS (
    SELECT
        price,
        avg_hours_played,
        peak_ccu,
        positive_pct,
        total_reviews,
        TRIM(
            BOTH ' []"' FROM UNNEST(STRING_TO_ARRAY(genres, ','))
        ) AS clean_genre
    FROM steam_commercial_games
)
SELECT
    clean_genre,
    COUNT(*) AS total_games,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(
        AVG(avg_hours_played::numeric / NULLIF(peak_ccu, 0)),
        2
    ) AS retention_ratio,
    ROUND(AVG(positive_pct), 2) AS avg_positive_pct
FROM unnested_data
WHERE clean_genre NOT IN (
    'Utilities',
    'Animation & Modeling',
    'Design & Illustration',
    'Software',
    'Web Publishing',
    'Audio Production',
    ''
)
    AND clean_genre NOT LIKE '{"%'
    AND clean_genre NOT LIKE 'description:%'
GROUP BY clean_genre
HAVING COUNT(*) >= 50
ORDER BY retention_ratio DESC;


