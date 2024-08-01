SELECT  
    job_title_short,
    job_location,
CASE 
    when job_location = 'Anywhere' THEN 'Remote'
    when job_location = 'New York, NY' then 'local'
    else 'Onsite'
    END AS locatin_category
FROM job_postings_fact;


SELECT
    company_id,
     name AS company_name 
FROM
     company_dim
WHERE 
    company_id IN (
    SELECT 
        company_id
    FROM
        job_postings_fact
    WHERE 
        job_no_degree_mention = true
)

/*
Find the company thet have the most job openings.
    -Get the total number of job postings per company id (job_postins_fact)
    -Return the total number of jobs with the company name (company_dim)
*/
 
WITH company_job_count AS (   
SELECT 
    company_id,
    COUNT(*) AS total_jobs
FROM   
    job_postings_fact
GROUP BY
    company_id 
)
SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC

/*
Find the count of the number of remote jobs postings per skills 
    -Display the top 5 skills by their demand in remote jobs
    -Include skill ID, name, and count of postings requiring the skill 
*/

WITH remote_job_skills AS (
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE AND 
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)
SELECT    
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
skill_count DESC
LIMIT 5;


SELECT 
        '2023-02-19'::DATE,
        '123'::INTEGER,
        'true'::BOOLEAN,
        '3.14'::REAL;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(YEAR FROM job_posted_date) AS date_year,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM
    job_postings_fact
    limit 5;

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month 
ORDER BY
    job_posted_count DESC;


 CREATE TABLE january_jobs AS 
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 1;
        
CREATE TABLE february_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

 CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

--UNION 

   SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
UNION 
 
   SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs 

UNION --combine another table 

SELECT
     job_title_short,
    company_id,
    job_location
FROM
    march_jobs


/*
Find job postings from the first quarter that have a salary greater than $70K
- Combine job potings tables from the first quarter of 2023 (Jan-Mar)
- Gets job posting with an average yearly salary > $70,000
*/

             
SELECT 
    quarte1_job_postings.job_location,
    quarte1_job_postings.job_via,
    quarte1_job_postings.job_posted_date::DATE,
    quarte1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarte1_job_postings
WHERE 
    quarte1_job_postings.salary_year_avg > 70000 AND
    quarte1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarte1_job_postings.salary_year_avg DESC
    




