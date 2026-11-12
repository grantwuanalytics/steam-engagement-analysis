-- ============================================================
-- STEAM GAME ANALYSIS
-- 01 | Data Preparation
-- ============================================================
-- Purpose:
-- Import raw Steam game data and prepare a structured dataset
-- for subsequent pricing, engagement, and genre analysis.
--
-- Database: PostgreSQL
-- Input: steam_games.csv
-- Output: steam_games_clean
-- ============================================================


-- 1. CREATE RAW STAGING TABLE
-- Store source fields as text before converting data types.

DROP TABLE IF EXISTS steam_games;

CREATE TABLE steam_games (
    app_id TEXT,
    name TEXT,
    release_date TEXT,
    price TEXT,
    price_status TEXT,
    estimated_owners TEXT,
    developers TEXT,
    publishers TEXT,
    genres TEXT,
    categories TEXT,
    tags TEXT,
    positive TEXT,
    negative TEXT,
    recommendations TEXT,
    peak_ccu TEXT,
    metacritic_score TEXT,
    user_score TEXT,
    average_playtime_forever TEXT,
    median_playtime_forever TEXT,
    average_playtime_2weeks TEXT,
    median_playtime_2weeks TEXT,
    short_description TEXT,
    about_the_game TEXT,
    detailed_description TEXT,
    notes TEXT,
    achievements TEXT,
    dlc_count TEXT,
    packages TEXT,
    supported_languages TEXT,
    full_audio_languages TEXT,
    windows TEXT,
    mac TEXT,
    linux TEXT,
    header_image TEXT,
    screenshots TEXT,
    movies TEXT,
    website TEXT,
    support_url TEXT,
    support_email TEXT,
    metacritic_url TEXT,
    steam_store_available TEXT,
    steam_spy_available TEXT
);


-- 2. IMPORT RAW DATA
-- Update the file path to match the local CSV location.
-- COPY reads from the PostgreSQL server's filesystem.

COPY steam_games
FROM '/tmp/steam_games.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '"'
);


-- 3. CREATE ANALYSIS-READY TABLE
-- Retain relevant fields and convert numeric columns.
-- Empty strings are converted to NULL before casting.

DROP TABLE IF EXISTS steam_games_clean;

CREATE TABLE steam_games_clean AS
SELECT
    NULLIF(app_id, '')::numeric::integer AS app_id,
    name,
    release_date,
    NULLIF(price, '')::numeric AS price,
    price_status,
    estimated_owners,
    developers,
    publishers,
    genres,
    categories,
    tags,
    NULLIF(positive, '')::numeric::integer AS positive_reviews,
    NULLIF(negative, '')::numeric::integer AS negative_reviews,
    NULLIF(recommendations, '')::numeric::integer AS recommendations,
    NULLIF(peak_ccu, '')::numeric::integer AS peak_ccu,
    NULLIF(metacritic_score, '')::numeric::integer AS metacritic_score,
    NULLIF(user_score, '')::numeric AS user_score,
    NULLIF(average_playtime_forever, '')::numeric::integer AS avg_hours_played,
    NULLIF(median_playtime_forever, '')::numeric::integer AS median_hours_played,
    NULLIF(dlc_count, '')::numeric::integer AS dlc_count,
    windows,
    mac,
    linux
FROM steam_games;


-- 4. VALIDATE PREPARED DATA
-- Check record count and inspect the resulting table.

SELECT COUNT(*) AS total_games
FROM steam_games_clean;

SELECT *
FROM steam_games_clean
LIMIT 10;
