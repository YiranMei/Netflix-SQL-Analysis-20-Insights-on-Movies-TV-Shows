# Netflix Data Insights

**Author:** Winifred Mei  
**Date:** August 2025

This project explores the **Netflix Titles Dataset (`netflix_titles.csv`)** using MySQL to uncover content trends across countries, genres, and years. The analysis is implemented in **`Netflix_Data_Insights.sql`**, featuring queries with grouping, filtering, and advanced window functions.

### Key Highlights
- Distribution of movies vs. TV shows by year, including yearly percentage breakdowns
- Top producing countries per year and overall contribution
- Genre popularity and counts per year
- Rating analysis and content suitable for different age groups
- Duration analysis for movies and TV shows
- Identification of prolific directors and actors
- Year-over-year content growth and percentage changes
- Advanced SQL techniques using **CTEs, recursive queries, and window functions (RANK, DENSE_RANK, ROW_NUMBER)**
- Categorization of content based on keywords and tagging for parental guidance

### Files
- `netflix_titles.csv` – Source dataset
- `Netflix_Data_Insights.sql` – SQL analysis code with 20+ queries

### How to Run
1. Import `netflix_titles.csv` into your MySQL database.
2. Open `Netflix_Data_Insights.sql` in your MySQL client.
3. Run the queries sequentially to reproduce the analysis.
4. Modify filters (year, country, genre) for customized insights.

This repository provides a detailed **SQL-based exploration and analysis of Netflix content**, demonstrating how to generate meaningful insights with advanced query techniques, trends evaluation, and content segmentation.
