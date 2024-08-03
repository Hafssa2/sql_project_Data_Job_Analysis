# Introduction 
🌟 Dive into the data job market! This highlights top-paying data analyst roles📈, the hottest skills, and where high demand meets high salaries in data analytics.

🔍SQL queriers? Check them out here: [project_sql folder](/project_sql/)

# Background
This project aims to identify top-paid and in-demand skills in the data analyst job market, helping others find optimal jobs.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these 3. top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project focused on mining specific aspects of the data analyst job market. Here's the approach:

**1. Top Paying Data Analyst Jobs:**  
   To find the highest-paying roles, I mined data by filtering positions based on average yearly salary and location, prioritizing remote jobs. This query highlights lucrative opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
Here’s a summary of the top data analyst jobs in 2023:
- **Wide Salary Range:** Salaries range from $184,000 to $650,000, highlighting significant earning potential.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T offer high salaries, showing broad industry interest.
- **Job Title Variety:** Roles vary from Data Analyst to Director of Analytics, indicating a wide range of specializations. 

![Top Paying Roles](assets\top_paying_roles.png)
*Bar graph visualizing the top 10 data analyst salaries, generated from my SQL query results using ChatGPT.*

**2. Skills for Top Paying Jobs**

To identify skills required for top-paying jobs, I joined job postings with skills data, revealing what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

![Top Paying Jobs](assets\top_demand_jobs.png)
*Bar graph visualizing the top 10 data analyst salaries, generated from my SQL query results using ChatGPT.*

**3. In-Demand Skills for Data Analysts**

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
Here's the breakdown of the most demanded skills for data analysts in 2023:

- **SQL and Excel**: Key foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are crucial for data storytelling and decision support.

| **Skills** | **Demand Count** |
|------------|------------------|
| SQL        | 7,291            |
| Excel      | 4,611            |
| Python     | 4,330            |
| Tableau    | 3,745            |
| Power BI   | 2,609            |

*Table of the demand for the top 5 skills in data analyst job postings*

**4. Skill Bazed on Salary**

Identifying the highest-paying skills involved analyzing average salaries associated with different skill sets.


```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

Here's a breakdown of the results for top paying skills for Data Analysts:

- ***High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.


| Skill          | Average Salary ($) |
|----------------|---------------------|
| pyspark        | 208,172             |
| bitbucket      | 189,155             |
| couchbase      | 160,515             |
| watson         | 160,515             |
| datarobot      | 155,486             |
| gitlab         | 154,500             |
| swift          | 153,750             |
| jupyter        | 152,777             |
| pandas         | 151,821             |
| elasticsearch  | 145,000             |

*Table of the average salary for the top 10 paying skills for data analysts*

**5. Most Optimal Skills to Learn**

This query identified skills with high demand and salaries to guide strategic skill development.

```sql 
WITH skills_demand AS (
SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE 
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id 
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

Here’s the table formatted for you:

| Skill ID | Skills      | Demand Count | Average Salary ($) |
|----------|-------------|--------------|---------------------|
| 8        | go          | 27           | 115,320             |
| 234      | confluence  | 11           | 114,210             |
| 97       | hadoop      | 22           | 113,193             |
| 80       | snowflake   | 37           | 112,948             |
| 74       | azure       | 34           | 111,225             |
| 77       | bigquery    | 13           | 109,654             |
| 76       | aws         | 32           | 108,317             |
| 4        | java        | 17           | 106,906             |
| 194      | ssis        | 12           | 106,683             |
| 233      | jira        | 20           | 104,918             |

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

🧩 **Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.   
📊 **Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
💡 **Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

Insights
From the analysis, several general insights emerged:

**1. Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
**2. Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.  
**3. Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.   
**4. Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.  
**5. Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.


### Closing Thoughts
This project improved my SQL skills and offered insights into the data analyst job market. The analysis helps prioritize skill development and job search efforts, guiding aspiring data analysts to focus on high-demand, high-salary skills. It underscores the importance of continuous learning and adapting to trends in data analytics.
<<<<<<< HEAD



=======
>>>>>>> 57fc6f50a39a8bb028fd18f95a1435af5a671f44
