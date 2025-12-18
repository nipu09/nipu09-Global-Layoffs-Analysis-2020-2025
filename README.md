🌍 Global Layoffs Analysis (2020–2025)

A comprehensive data analysis project exploring global layoffs over the last five years. This project focuses on layoff intensity, company behavior, industry trends, and regional patterns using SQL and exploratory data analysis (EDA). The goal is to provide actionable insights into workforce trends worldwide.

🔹 Table of Contents

Project Overview

Dataset

Objectives

Analysis & Methodology

Key Insights

Technologies Used

Usage

Author

Contact

📌 Project Overview

This project investigates global layoffs between 2020 and 2025. By analyzing company-level layoff data, this study uncovers trends across industries, countries, and workforce scales. The analysis also highlights organizations with high layoff percentages and sectors most affected by workforce reductions.

📊 Dataset

Source: Cleaned layoff dataset collected from multiple verified sources.

Format: CSV / SQL tables (layoff3)

Key Columns:

company – Name of the organization

total_laid_off – Number of employees laid off

percentage_laid_off – Layoff as a percentage of workforce

industry – Industry sector

country – Country of the company

date – Layoff event date

🎯 Objectives

Analyze layoff intensity (average, median layoffs).

Identify companies with complete or significant workforce reductions.

Explore industry-specific and regional patterns.

Present data-driven insights through SQL queries and visualizations.

⚙️ Analysis & Methodology

Data Cleaning:

Converted numeric columns from strings to integers to avoid aggregation errors.

Handled missing and inconsistent values.

Exploratory Data Analysis (EDA):

Calculated average, median, and maximum layoffs.

Identified companies with high layoff percentages.

Explored trends by industry and country.

Visualized distributions and trends to highlight patterns.

SQL Queries Examples:

-- Average layoffs per event
SELECT AVG(total_laid_off) AS avg_layoffs_per_event
FROM layoff3;

-- Median layoffs
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_laid_off) AS median_layoffs
FROM layoff3;

-- Companies with 100% layoffs
SELECT company, percentage_laid_off
FROM layoff3
WHERE percentage_laid_off = 100;

-- Maximum layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff3;

🔑 Key Insights

The average layoff per event provides a benchmark for typical workforce reductions.

Certain companies and sectors experienced disproportionately high layoffs.

Regional trends highlight which countries faced the largest layoffs during this period.

Data visualizations allow easy interpretation of complex workforce trends.

🛠 Technologies Used

SQL – Data cleaning, aggregation, and analysis

Python (optional) – For visualizations and advanced EDA

Excel / CSV – Raw dataset handling

🚀 Usage

Clone the repository:

git clone https://github.com/YourUsername/global-layoffs-analysis.git


Open SQL or Python scripts to explore analysis queries and visualizations.

Replace the dataset path with your local file if needed.

👤 Author

Nipu Moni Dutta
Data Analytics & SQL Enthusiast

📬 Contact

LinkedIn: [linkedin.com/in/nipumoni-dutta](https://www.linkedin.com/in/nipu-moni-dutta9/)

GitHub: [github.com/nipu09](https://github.com/nipu09)
