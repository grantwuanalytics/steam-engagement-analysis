# Steam Market Strategy | Pricing & Genre Opportunities

**An end-to-end data analytics project using SQL, Python, and Tableau to identify pricing opportunities, evaluate player engagement, and inform game development and portfolio strategies.**

[![Tableau Public](https://img.shields.io/badge/Tableau_Public-Interactive_Dashboard-orange?style=for-the-badge&logo=tableau)](https://public.tableau.com/views/SteamMarketStrategyPricingGenreOpportunities/Dashboard2)
![Python](https://img.shields.io/badge/Python-EDA-blue?style=for-the-badge&logo=python)
![SQL](https://img.shields.io/badge/SQL-Analysis-lightgrey?style=for-the-badge)

## Executive Summary

This project analyzes 48,759 Steam games to explore relationships between game pricing, player engagement, and user satisfaction across different price tiers and genres.

Using SQL for data preparation and querying, Python for exploratory data analysis, and Tableau for visualization, I developed an interactive dashboard that translates market patterns into business recommendations for game developers.

**Key finding:** Games priced between $15 and $30 demonstrate the highest engagement ratio (143.5) while maintaining approximately 79% positive user reviews, suggesting a promising segment for further pricing research.

## Interactive Tableau Dashboard

### [View the Live Tableau Dashboard](https://public.tableau.com/views/SteamMarketStrategyPricingGenreOpportunities/Dashboard2)

The dashboard presents a market-level overview of Steam game pricing, engagement, and user satisfaction.

**Dashboard Features:**

- **Market Overview:** 48,759 games analyzed, with an average price of $10.66.
- **Pricing Opportunities:** Comparison of engagement ratios across five price segments, highlighting the $15–$30 segment.
- **Genre Opportunities & Risks:** Scatterplot comparing genre-level engagement ratios and positive review percentages.
- **Interactive Exploration:** Hover tooltips provide additional metrics, including engagement ratios, review sentiment, and game counts.
- **Business Recommendations:** Three strategic considerations addressing pricing, genre development, and player satisfaction.

The packaged Tableau workbook is also available in this repository:

**[View Tableau Workbook](Steam_Market_Strategy.twbx)**

## Business Recommendations

### 1. Pricing Strategy — Evaluate the $15–$30 Segment

Games priced at $15–$30 demonstrate the highest engagement ratio (143.5) while maintaining a strong 79% positive review rate.

**Business implication:** Developers should consider this segment when evaluating pricing strategies that balance engagement and player satisfaction, while accounting for differences in genre, game quality, and target audience.

### 2. Genre Strategy — Explore Adventure & RPG

Adventure (195.4) and RPG (126.4) demonstrate strong engagement ratios alongside approximately 79–80% positive reviews.

**Business implication:** These genres represent potential opportunities for future game development and market research. Developers can investigate competitive positioning and audience expectations before making portfolio decisions.

### 3. Player Experience — Investigate Potential Satisfaction Risks

Premium-priced games ($55+) average 69% positive reviews, while Massively Multiplayer games average 67%.

**Business implication:** Developers should investigate potential satisfaction gaps across existing player bases and competing titles to identify opportunities for improvement before making pricing or portfolio decisions.

## Technical Workflow

### 1. Data Preparation — SQL

- Structured raw Steam marketplace records into analysis-ready tables.
- Converted and standardized fields for quantitative analysis.
- Applied data-quality checks and prepared metrics for subsequent analysis.

**File:** [`01_steam_data_preparation.sql`](01_steam_data_preparation.sql)

### 2. Exploratory Analysis — SQL

- Analyzed pricing distributions and player engagement across five price tiers.
- Examined positive review percentages and concurrent player metrics.
- Compared genre-level performance to identify opportunities and potential risks.

**File:** [`02_steam_analysis.sql`](02_steam_analysis.sql)

### 3. Exploratory Data Analysis — Python

- Used Pandas and NumPy to process and analyze Steam marketplace data.
- Examined relationships among pricing, engagement, and review sentiment.
- Developed correlation heatmaps and scatterplots to explore patterns.
- Exported processed datasets and summary tables for visualization.

**File:** [`03_exploratory_eda.ipynb`](03_exploratory_eda.ipynb)

### 4. Business Intelligence — Tableau

- Developed an interactive dashboard comparing price-tier and genre performance.
- Incorporated hover tooltips to display detailed metrics for individual categories.
- Highlighted the $15–$30 pricing segment as a potential market opportunity.
- Translated analytical findings into three business recommendations.

**File:** [`Steam_Market_Strategy.twbx`](Steam_Market_Strategy.twbx)

## Tools & Technologies

| Tool | Application |
|---|---|
| SQL / PostgreSQL | Data preparation, querying, and exploratory analysis |
| Python | Data processing and exploratory analysis |
| Pandas & NumPy | Data manipulation and quantitative analysis |
| Matplotlib & Seaborn | Statistical and exploratory visualizations |
| Tableau Public | Interactive dashboard and business storytelling |
| GitHub | Project documentation and version control |

## Data & Methodology

The analysis examines pricing, engagement, and review sentiment using Steam game-level records.

**Price segments:** Under $5, $5–14.99, $15–29.99, $30–54.99, and $55+.

**Engagement ratio:** An exploratory metric comparing average playtime with peak concurrent players. It is not a direct measure of player retention.

**Positive review percentage:** The proportion of positive user reviews, used as an indicator of player satisfaction.

**Limitations:** Findings describe associations rather than causal relationships. Differences in genre, release timing, audience size, and other factors may influence observed patterns. Genre categories may overlap, and the engagement ratio should be interpreted cautiously.

## Repository Contents

| File | Description |
|---|---|
| `01_steam_data_preparation.sql` | SQL data preparation |
| `02_steam_analysis.sql` | SQL exploratory analysis |
| `03_exploratory_eda.ipynb` | Python exploratory analysis and visualizations |
| `steam_games_processed.csv` | Processed game-level dataset |
| `price_tier_summary.csv` | Price-tier summary metrics |
| `genre_summary.csv` | Genre-level summary metrics |
| `Steam_Market_Strategy.twbx` | Tableau packaged workbook |

## Project Takeaway

This project strengthened my ability to connect technical analysis with business decision-making. Beyond exploring Steam marketplace data, I focused on translating quantitative findings into practical considerations for game pricing, portfolio strategy, and player experience.

The project demonstrates an end-to-end analytics workflow, from data preparation and exploratory analysis to interactive visualization and business recommendations.
