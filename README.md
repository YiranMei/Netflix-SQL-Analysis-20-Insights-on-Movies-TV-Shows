# Netflix Data Analysis Project

**Author:** Winifred Mei  
**Date:** August 2025  

---

##  Project Overview
This project explores the **Netflix Titles Dataset** (`netflix_titles.csv`) using **SQL in MySQL** to uncover meaningful insights about content distribution, ratings, genres, and release trends.  
The analysis demonstrates how advanced SQL techniques such as **Common Table Expressions (CTEs)**, **window functions**, **aggregations**, and **ranking methods** can be applied to real-world datasets.

The repository also includes structured outputs, example query results, and a consolidated Jupyter Notebook/PDF for demonstration purposes.

---

##  Repository Contents
- **`netflix_titles.csv`** → Raw dataset containing metadata about Netflix movies and TV shows.  
- **`Netflix_Data_Insights.sql`** → SQL script with all analysis queries.  
- **`results.zip`** → Zipped folder with exported outputs from SQL queries.  
- **`Netflix Data Analysis Results Output.ipynb`** → Jupyter Notebook containing code, questions, and sampled results (limited to 10 rows for display).  
- **`Netflix Data Analysis Results Output.pdf`** → PDF version of the notebook for easy review.  

---

## 🛠️ Methods & SQL Techniques Used
The project leverages a wide range of SQL techniques to analyze and summarize the dataset:

1. **Aggregation & Grouping**  
   - `COUNT()`, `GROUP BY` used to compare the number of Movies vs. TV Shows.  
   - Identification of the most common content ratings.  

2. **Common Table Expressions (CTEs)**  
   - Used for cleaner modular queries, e.g., calculating frequency of ratings per content type before ranking.  

3. **Window Functions**  
   - `ROW_NUMBER()` and `RANK()` applied to find most common categories (ratings, genres) by type.  
   - Rolling/partitioned analysis to observe release distribution across years.  

4. **String Functions & Filtering**  
   - Queries filtering by keywords in title or director fields to explore subsets (e.g., by genre or region).  

5. **Date Functions**  
   - Extraction of release year and trend analysis of content growth over time.  

6. **Join Operations**  
   - Cross-analysis across attributes, e.g., country vs. release year breakdown.  

7. **Triggers (conceptual extension)**  
   - Demonstrated as an example of how automatic logging could be applied when inserting new Netflix records (not actively applied in outputs, but included for completeness).  

---

##  Key Insights from Analysis
- **Movies dominate Netflix’s catalog** compared to TV shows, but TV shows have shown consistent growth in recent years.  
- **TV-MA and TV-14** are the most common ratings, highlighting Netflix’s large volume of teen and adult-oriented content.  
- **United States, India, and the UK** lead in content production, but regional diversity is increasing.  
- Release trends reveal a **sharp increase in content after 2015**, consistent with Netflix’s global expansion.  
- Frequent collaborations with prominent directors and production countries reinforce Netflix’s **international strategy**.  

---

##  How to Run the Project
1. **Set up MySQL** and create a new database (e.g., `netflix`).  
2. **Load the dataset**:
   ```sql
   LOAD DATA INFILE 'path/to/netflix_titles.csv'
   INTO TABLE netflix
   FIELDS TERMINATED BY ','
   ENCLOSED BY '"'
   IGNORE 1 ROWS;
3. **Execute the analysis script:**
```sql
source Netflix_Data_Insights.sql;
```
4. **Check outputs:**
Raw SQL results can be found in `results.zip`.
For demonstration, open `Netflix Data Analysis Results Output.ipynb` or the PDF version.

