![Tableau Public Dashboard](https://img.shields.io/badge/Tableau_Public-Interactive_Dashboard-orange?style=for-the-badge&logo=tableau)
![Python](https://img.shields.io/badge/Python-3.x-blue?style=for-the-badge&logo=python)
![SQL](https://img.shields.io/badge/SQL-Data_Cleaning-lightgrey?style=for-the-badge&logo=sql)

## Executive Summary

An end-to-end data analytics project evaluating player engagement, pricing dynamics, and genre retention performance across the Steam gaming catalog. Built as an interactive executive dashboard to inform monetization and portfolio strategies.

---

## Interactive Dashboard

> **[View Interactive Dashboard on Tableau Public](https://github.com/grantwuanalytics/steam-engagement-analysis)**

### Key Visualizations

1. **KPI Banner**: High-level catalog metrics tracking total game footprint and baseline average price points.
2. **Price Tier Engagement Analysis**: Bar chart breakdown comparing average player hours across price buckets ($0 to $30+).
3. **Genre Retention Matrix**: Scatter plot matrix positioning genres by retention ratio against positive user rating percentages.

---

## Data Pipeline & Architecture

The project ingests raw Steam marketplace data, executes SQL transformations, processes metrics via Python pipelines, and exports target datasets structured for BI reporting:

* `steam_data_cleaning.sql`: SQL scripts used for initial data extraction and transformation.
* `steam_games_processed.csv`: Cleansed game-level dataset with calculated pricing tiers and retention metrics.
* `price_tier_summary.csv`: Aggregated performance metrics binned by price bucket.
* `genre_summary.csv`: Cross-sectional genre metrics evaluating player satisfaction vs. long-term retention.

---

## Tech Stack

* **Database & Querying**: SQL
* **Data Processing**: Python (Pandas, NumPy, Matplotlib/Seaborn)
* **BI & Visualization**: Tableau Public (`.twbx`)
* **Version Control**: Git, GitHub

## Business Context & Methodology

### 1. Problem & Objectives
The primary goal of this analysis was to evaluate how paid pricing strategies impact game reception, initial launch momentum, and long-term player retention across the Steam catalog (excluding Free-to-Play titles). Specifically, the project focused on answering:
* How do paid price tiers impact positive user review percentages and launch hype (measured via Peak Concurrent Users / Peak CCU)?
* Does paying a premium price tier correlate with higher long-term player retention, or do mid-tier games hold higher sustained engagement?
* Which specific game genres drive the strongest long-term player retention relative to overall catalog performance?

### 2. Data Pipeline & Data Cleaning (SQL & Python)
* **Extraction & SQL Transformation (`steam_data_cleaning.sql`)**: 
  * Cleaned raw marketplace records by filtering out unreleased titles, corrupted rating values, and zero-playtime entries.
  * Aggregated user feedback metrics and computed custom retention proxies (average hours played relative to total catalog tenure).
* **Exploratory Data Analysis & Feature Engineering (`.ipynb`)**:
  * Utilized **Pandas** and **NumPy** to group game pricing into discrete bins (`> 4.99`, `5.00–$14.99`, `$15.00–$29.99`, `$30.00–$54.99`, `$55.00+`).
  * Generated summary metrics saved to `price_tier_summary.csv` and `genre_summary.csv` for BI modeling.
  * Rendered exploratory distributions using **Matplotlib** and **Seaborn** to validate visual relationships prior to dashboard construction.

### 3. Key Analytical Insights
**Price Tier vs. Retention Sweet Spot:** Refuted simple inverse linearity between price and engagement—median playtime remains low across all tiers, but mean playtime peaks in the **Lower Mid Tier ($15–$29.99)** at ~143 hours/peak user with ~79% positive sentiment. Higher price tiers ($55+) trigger higher expectations, dropping positive sentiment to ~68.76%.
* **Hype Dynamics & Retention Metric Engineering:** Engineered two relative ratios (`hype_ratio` = `peak_ccu / total_reviews` and `retention_ratio` = `avg_hours_played / peak_ccu`) to evaluate engagement depth beyond surface-level review counts and launch excitement.
* **Genre Category Winners:** Cleaned and unnested JSON-formatted genre strings (`UNNEST`, `STRING_TO_ARRAY`, string stripping), identifying **Adventure** (~195.38 retention ratio, ~80% positive rating) and **RPGs** (~126.43 retention ratio, ~79% positive rating) as top long-term engagement drivers.
**Exponential Pricing Elasticity:** Player engagement scales sharply at higher price points, with premium titles ($30+) generating over 10x higher mean playtime than budget tiers, demonstrating strong buyer retention commitment[cite: 1, 3].
* **High-Value Genre Strategy:** Strategic matrix mapping isolates RPG and Strategy mechanics as top-tier performers, consistently driving both high player retention ratios and positive sentiment[cite: 1].