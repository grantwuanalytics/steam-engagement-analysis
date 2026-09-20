![Tableau Public Dashboard](https://img.shields.io/badge/Tableau_Public-Interactive_Dashboard-orange?style=for-the-badge&logo=tableau)
![Python](https://img.shields.io/badge/Python-3.x-blue?style=for-the-badge&logo=python)
![SQL](https://img.shields.io/badge/SQL-Data_Cleaning-lightgrey?style=for-the-badge&logo=sql)

## Executive Summary

An end-to-end data analytics project evaluating player engagement, pricing dynamics, and genre retention performance across the Steam gaming catalog. Built as an interactive executive dashboard to inform monetization and portfolio strategies.

---

## Interactive Dashboard

> **[View Interactive Dashboard on Tableau Public](YOUR_TABLEAU_PUBLIC_URL_HERE)**

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
