
CREATE DATABASE bank_data;

USE bank_data;

CREATE TABLE Bank_Churn (
    CustomerId BIGINT PRIMARY KEY,
    Surname VARCHAR(50),
    CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Tenure INT,
    Balance DECIMAL(15,2),
    NumOfProducts INT,
    HasCrCard TINYINT(1),
    IsActiveMember TINYINT(1),
    EstimatedSalary DECIMAL(15,2),
    Exited TINYINT(1)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bank+Customer+Churn/Bank_churn.csv'
INTO TABLE Bank_Churn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerId, Surname, CreditScore, Geography, Gender, Age, Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, Exited);


SELECT * FROM bankchurn;

-- How many customers are there in total?

SELECT COUNT(*) AS Total_Customers FROM bankchurn;

-- What is the overall churn rate?

SELECT 
  COUNT(CASE WHEN Exited = 1 THEN 1 END) * 100.0 / COUNT(*) AS Churn_Rate_Percentage
FROM bankchurn;

-- What is the churn rate by Geography?

SELECT 
  Geography,
  COUNT(*) AS Total_Customers,
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned,
  ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM bankchurn
GROUP BY Geography;

-- Average age of churned vs retained?

SELECT 
  Exited,
  ROUND(AVG(Age), 2) AS Avg_Age
FROM bankchurn
GROUP BY Exited;

-- What is the distribution of churn by Gender?

SELECT  
  Gender, 
  COUNT(*) AS Total, 
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned, 
  ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS 
Churn_Rate 
FROM bankchurn 
GROUP BY Gender;

-- Is there a correlation between Credit Score and churn?

SELECT  
  Exited, 
  ROUND(AVG(CreditScore), 2) AS Avg_CreditScore 
FROM bankchurn 
GROUP BY Exited; 

-- How does Tenure relate to churn?

SELECT  
  Tenure, 
  COUNT(*) AS Total, 
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned 
FROM bankchurn 
GROUP BY Tenure 
ORDER BY Tenure;

-- Churn rate by number of products? 

SELECT  
  NumOfProducts, 
  COUNT(*) AS Total, 
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned 
FROM bankchurn 
GROUP BY NumOfProducts;

-- What’s the impact of being an active member on churn? 

SELECT  
  IsActiveMember, 
  COUNT(*) AS Total, 
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned 
FROM bankchurn  
GROUP BY IsActiveMember; 

--  Churn analysis based on balance ranges

SELECT  
  CASE  
     WHEN Balance = 0 THEN 'No Balance' 
     WHEN Balance BETWEEN 0 AND 50000 THEN '0-50K' 
     WHEN Balance BETWEEN 50001 AND 100000 THEN '50K-100K' 
     ELSE '100K+' 
  END AS Balance_Range, 
  COUNT(*) AS Total, 
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned 
FROM bankchurn 
GROUP BY  
  CASE  
    WHEN Balance = 0 THEN 'No Balance' 
    WHEN Balance BETWEEN 0 AND 50000 THEN '0-50K' 
    WHEN Balance BETWEEN 50001 AND 100000 THEN '50K-100K' 
    ELSE '100K+' 
  END; 

-- Top 10 high-salary churned customers

SELECT * 
FROM bankchurn 
WHERE Exited = 1 
ORDER BY EstimatedSalary DESC 
LIMIT 10; 

-- Which Gender and Geography combination has the highest churn rate?

SELECT  
  Geography,  
  Gender, 
  COUNT(*) AS Total, 
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned, 
  ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate 
FROM bankchurn 
GROUP BY Geography, Gender 
ORDER BY Churn_Rate DESC; 

-- How does salary relate to churn?

SELECT  
  Exited, 
  ROUND(AVG(EstimatedSalary), 2) AS Avg_Salary 
FROM bankchurn 
GROUP BY Exited;

