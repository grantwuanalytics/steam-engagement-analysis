--Creating a new table with concise organized information
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
    ROUND((positive_reviews::numeric / NULLIF(positive_reviews + negative_reviews, 0)) * 100, 2) AS positive_pct,
    avg_hours_played,
    peak_ccu
FROM steam_games_clean
WHERE price > 0                          -- Excludes free-to-play & unpriced games
  AND (positive_reviews + negative_reviews) >= 10 -- Filters out our definition of low-engagement games
  AND categories IS NOT NULL                 -- Excludes NULL categories
  AND TRIM(categories) not IN ('', '[]');                -- Excludes empty text string categories
SELECT * FROM steam_commercial_games LIMIT 5;
SELECT COUNT(*) FROM steam_commercial_games;
-- 49,041 rows of paid games and over 10 reviews

SELECT 
    ROUND(AVG(price), 2) AS mean_price,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) AS p25_price,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price) AS median_price,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) AS p75_price,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY price) AS p90_price,
    ROUND(STDDEV(price), 2) AS std_dev_price
FROM steam_commercial_games;
--Mean is 10.76, Median is 7.99, showing that the data is right skewed, the small amount of expensive games is driving prices
-- 75% of all commericial games on Steam sell for 14.99 or less


--Creating buckets for game prices
SELECT 
    CASE 
        WHEN price < 5.00 THEN '1. Budget (< $5)'
        WHEN price BETWEEN 5.00 AND 14.99 THEN '2. Indie / Standard ($5 - $14.99)'
        WHEN price BETWEEN 15.00 AND 29.99 THEN '3. Mid-Tier ($15 - $29.99)'
        WHEN price BETWEEN 30.00 AND 54.99 THEN '4. AA / High-Tier ($30 - $59.99)'
        ELSE '5. AAA / Premium ($55+)'
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
--tiers are based on the Steam pricing strategy and my own business domain knowledge 
--after years or playing and purchasing games
--also based on that Steam has a $15 games section specifically which tells me that is a good cut off for the median price range





--My initial hypothesis was that I would hypothesis that the more expensive a game is the less people spent time to play it, 
--The traditional games that have recently became popular especally during covid, and warrant many hours of play are actually all cheaper games, not AAA. 
--value and price have a negative relatinoship such as as price increases, play time decreases. Also on that note then the play time will have a positive relationshi such 
--that as playtime increases then positive sentimen increases in most situations. so this question as a whole targets how many relates to positive sentiment
SELECT 
    CASE 
        WHEN price < 5.00 THEN '1. Micro / Impulse (< $5)'
        WHEN price BETWEEN 5.00 AND 14.99 THEN '2. Indie Core ($5 - $14.99)'
        WHEN price BETWEEN 15.00 AND 29.99 THEN '3. Lower Mid ($15 - $29.99)'
        WHEN price BETWEEN 30.00 AND 54.99 THEN '4. Mid-Tier ($30 - $59.99)'
        ELSE '5. Premium / AAA ($55+)'
    END AS custom_price_tier,
    COUNT(*) AS total_games,
    ROUND(AVG(avg_hours_played), 2) AS mean_hours_played,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY avg_hours_played) AS median_hours_played,
    ROUND(AVG(peak_ccu), 0) AS avg_peak_ccu,
    ROUND(AVG(positive_pct), 2) AS avg_positive_pct
FROM steam_commercial_games
GROUP BY custom_price_tier
ORDER BY custom_price_tier;
 --it looks like theres definitely a drop off in percetnage of positive reviews past the low mid tier games which is what I predicted! 
 --What is interesting is that premium games has a significantly higher amount of mean hours played even with less games which mean the premium games are people's "go to" games to play. 
 --they obviously have a higher peak ccu probably because of the churn. This suggests that actually longevity of the game is given to more expensive games? even if they are "worse" 
--medium hours at 0 suggest that a few games are pulling up the average like crazy 

--now testing for the skewness in premium games
select * 
from steam_commercial_games
where price >= 60
order by avg_hours_played desc;

--discovered that Steam sells software which accounts for the premium games horus spike. Went back to remove those in steam commercial dataset
--hypothesis analysis in google doc



--Now turning attention to churn
SELECT 
    CASE 
        WHEN price < 5.00 THEN '1. Micro / Impulse (< $5)'
        WHEN price < 15.00 THEN '2. Indie Core ($5 - $14.99)'
        WHEN price < 30.00 THEN '3. Lower Mid ($15 - $29.99)'
        WHEN price < 55.00 THEN '4. Mid-Tier ($30 - $54.99)'
        ELSE '5. Premium / AAA ($55+)'
    END AS custom_price_tier,
    COUNT(*) AS total_games,
    ROUND(AVG(peak_ccu), 0) AS avg_peak_ccu,
    ROUND(AVG(avg_hours_played), 2) AS mean_hours_played,
    -- Hype Ratio: High numbers indicate high launch spike relative to review volume
    ROUND(AVG(peak_ccu::numeric / NULLIF(total_reviews, 0)), 4) AS hype_ratio,
    -- Retention Ratio: High numbers indicate long-term engagement relative to launch peak
    ROUND(AVG(avg_hours_played::numeric / NULLIF(peak_ccu, 0)), 2) AS retention_ratio,
    ROUND(AVG(positive_pct), 2) AS avg_positive_pct
FROM steam_commercial_games
GROUP BY custom_price_tier
ORDER BY custom_price_tier
-- it seems that the 15-30 dollar price range is a good spot for player retention while expensive games have more hype around them and loose players. Also premium games have lower reviews 
--while lower mid and mid tier games have higher reviews


--Final part: Relating categories and genres to player retention
WITH unnested_data AS (
    SELECT 
        price,
        avg_hours_played,
        peak_ccu,
        positive_pct,
        total_reviews,
        TRIM(BOTH ' []"' FROM UNNEST(STRING_TO_ARRAY(genres, ','))) AS clean_genre
    FROM steam_commercial_games
)		
SELECT
    clean_genre,
    COUNT(*) AS total_games,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(avg_hours_played::numeric / NULLIF(peak_ccu, 0)), 2) AS retention_ratio,
    ROUND(AVG(positive_pct), 2) AS avg_positive_pct
FROM unnested_data
WHERE clean_genre NOT IN ('Utilities', 'Animation & Modeling', 'Design & Illustration', 'Software', 'Web Publishing', 'Audio Production', '')
  AND clean_genre NOT LIKE '{"%'
  AND clean_genre NOT LIKE 'description:%'
GROUP BY clean_genre
HAVING COUNT(*) >= 50
ORDER BY retention_ratio DESC;

	


