 -- Selecting Our Datasets --
Select *
FROM AirlineProject..[Airline Loyalty Data Dictionary]

SELECT *
FROM AirlineProject.dbo.[Customer Loyalty History]


-- Selecting Our Variables --
Select Loyalty_Number, Year, Month, Flights_Booked, Flights_with_Companions, Total_Flights, Distance, Points_Accumulated, Points_Redeemed, Dollar_Cost_Points_Redeemed
FROM AirlineProject..[Airline Loyalty Data Dictionary]
ORDER BY 3,4

SELECT Loyalty_Number, Country, Province, City, Postal_Code, Gender, Education, Salary, Marital_Status, Loyalty_Card, CLV, Enrollment_Type, Enrollment_Month, Enrollment_Year, Cancellation_Year, Cancellation_Month
FROM AirlineProject..[Customer Loyalty History]
ORDER BY 3,4

-- Looking at Number of Loyalty Members by City
Select
	Country,
	Province,
	City,
	Gender,
	Loyalty_Number
FROM AirlineProject..[Customer Loyalty History]
ORDER BY City ASC;

-- Looking at Loyalty Number by Gender and Marital Status
SELECT
	Gender,
	Loyalty_Number,
	Marital_Status
FROM AirlineProject..[Customer Loyalty History]
ORDER BY Loyalty_Number  ASC;
-- Exploratory Data Analysis--
SELECT AVG(Salary) as MeanSalary
FROM AirlineProject..[Customer Loyalty History]

SELECT AVG(CLV) as MeanCLV
FROM AirlineProject..[Customer Loyalty History]

Select AVG(Flights_Booked) as MeanFlightsBooked
FROM AirlineProject..[Airline Loyalty Data Dictionary]

SELECT AVG(Distance) as MeanDistance
FROM AirlineProject..[Airline Loyalty Data Dictionary]

SELECT AVG(Points_Accumulated) as MeanPointsAccumulated
FROM AirlineProject..[Airline Loyalty Data Dictionary]

SELECT MAX(Salary) as MaxSalary
FROM AirlineProject..[Customer Loyalty History]

SELECT MAX(CLV) AS MaxCLV
FROM AirlineProject..[Customer Loyalty History]

SELECT MAX(Flights_Booked) as MaxFlightsBooked
FROM AirlineProject..[Airline Loyalty Data Dictionary]

Select MAX(Distance) as MaxDistance
FROM AirlineProject..[Airline Loyalty Data Dictionary]

Select MAX(Points_Accumulated) as MaxPointsAccumulated
FROM AirlineProject..[Airline Loyalty Data Dictionary]

Select STDEV(Salary) as STDEVSalary
FROM AirlineProject..[Customer Loyalty History]

SELECT STDEV(CLV) AS STDEVCLV
FROM AirlineProject..[Customer Loyalty History]

SELECT STDEV(Flights_Booked) as STDEVFlightsBooked
FROM AirlineProject..[Airline Loyalty Data Dictionary]

SELECT STDEV(Distance) as STDEVDistance
FROM AirlineProject..[Airline Loyalty Data Dictionary]

SELECT STDEV(Points_Accumulated) as STDEVPointsAccumulated
FROM AirlineProject..[Airline Loyalty Data Dictionary]

SELECT MIN(Salary) as MinSalary
FROM AirlineProject..[Customer Loyalty History]

SELECT MIN(CLV) AS MinCLV
FROM AirlineProject..[Customer Loyalty History]

--Looking at Loyalty program members by	Province

SELECT Province, COUNT(*) AS MemberCount
FROM AirlineProject..[Customer Loyalty History]
GROUP BY Province
ORDER BY MemberCount DESC;


--Looking at Loyalty Program Members by City--

SELECT City, COUNT(*) AS MemberCount
FROM AirlineProject..[Customer Loyalty History]
GROUP BY City
ORDER BY MemberCount Desc;

-- Looking at Loyalty members based on enrollment year and province--

SELECT Enrollment_Year, Province, SUM(Loyalty_Number) AS TotalLoyaltyNumbers
FROM AirlineProject..[Customer Loyalty History]
GROUP BY Enrollment_Year, Province
ORDER BY Enrollment_Year, Province;

-- Analyzing Cancellation Years and Months--

SELECT 
	Cancellation_Year,
	Cancellation_Month,
	count(*) AS CancellationCount
FROM AirlineProject..[Customer Loyalty History]
WHERE
    Cancellation_Year IS NOT NULL
GROUP BY
    Cancellation_Year,
    Cancellation_Month
ORDER BY
    Cancellation_Year, Cancellation_Month;

-- Segment Members--

SELECT
    CASE
        WHEN Gender = 'Male' THEN 'Male'
        WHEN Gender = 'Female' THEN 'Female'
        ELSE 'Other'
    END AS GenderSegment,
    CASE
        WHEN Education = 'High School or Below' THEN 'High School'
        WHEN Education = 'Bachelor' THEN 'Bachelor Degree'
		WHEN Education = 'Master' THEN 'Masters Degree'
		WHEN Education = 'Doctor' THEN 'Doctor Degree'
		WHEN Education = 'College' THEN 'SomeCollege'
        ELSE 'Other'
    END AS EducationSegment,
    CASE
        WHEN Marital_Status = 'Single' THEN 'Single'
        WHEN Marital_Status = 'Married' THEN 'Married'
        WHEN Marital_Status = 'Divorced' THEN 'Divorced'
    END AS MaritalStatusSegment,
    Loyalty_Number
FROM
    AirlineProject..[Customer Loyalty History];

-- Examining CLV and Salary per Loyalty Member

SELECT
    CustomerSegment,
    COUNT(*) AS MemberCount
FROM (
    SELECT
        CASE
            WHEN CLV >= 10000 AND Salary >= 80000 THEN 'High-Value'
            WHEN CLV >= 5000 AND Salary >= 60000 THEN 'Medium-Value'
            ELSE 'Low-Value'
        END AS CustomerSegment
    FROM
       AirlineProject.[dbo].[Customer Loyalty History]
) AS SegmentedData
GROUP BY
    CustomerSegment;


-- Examing the retention rate of loyalty program members through enrollments vs cancellations

SELECT
    (1 - (SUM(CASE WHEN Cancellation_Year IS NOT NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*))) * 100 AS RetentionRate
FROM
    AirlineProject..[Customer Loyalty History];

-- Correlation Analysis
ALTER TABLE AirlineProject.dbo.[Airline Loyalty Data Dictionary]
ALTER COLUMN [Flights_Booked] BIGINT;

ALTER TABLE AirlineProject.dbo.[Airline Loyalty Data Dictionary]
ALTER COLUMN [Distance] BIGINT;

SELECT
	Points_Accumulated,
	Distance,
	Total_Flights
FROM AirlineProject..[Airline Loyalty Data Dictionary]
ORDER BY Total_Flights ASC;

-- Total Points Accumulated vs Redeemed

SELECT
    SUM([Points_Accumulated]) AS TotalPointsAccumulated,
    SUM([Points_Redeemed]) AS TotalPointsRedeemed
FROM
    AirlineProject.dbo.[Airline Loyalty Data Dictionary];

-- Dollar Cost vs Points Redeemed

SELECT SUM(Dollar_Cost_Points_Redeemed) AS TotalDollarCostPointsRedeemed
FROM AirlineProject..[Airline Loyalty Data Dictionary]

Select MAX(Dollar_Cost_Points_Redeemed) as MaxDollarCostPointsRedeemed
FROM AirlineProject..[Airline Loyalty Data Dictionary]

Select MIN(Dollar_Cost_Points_Redeemed) as MinDollarCostPointsRedeemed
FROM AirlineProject..[Airline Loyalty Data Dictionary]
	

-- Time Series--
SELECT
	YEAR,
	Month,
	Points_Accumulated as TotalPointsAccumulated,
	Flights_Booked as TotalFlightsBooked
From AirlineProject..[Airline Loyalty Data Dictionary]
ORDER BY Year, Month;

--TRENDS--
--Enrollment Trends

WITH EnrollmentTrends AS (
    SELECT
        [Enrollment_Year],
        [Enrollment_Month],
        COUNT(*) AS EnrollmentCount
    FROM
        AirlineProject.dbo.[Customer Loyalty History]
    GROUP BY
        [Enrollment_Year],
        [Enrollment_Month]
)

SELECT
    [Enrollment_Year],
    [Enrollment_Month],
    EnrollmentCount
FROM
    EnrollmentTrends
ORDER BY
    [Enrollment_Year], [Enrollment_Month];

--Cancellation Trends

WITH CancellationTrends AS (
    SELECT
        [Cancellation_Year],
        [Cancellation_Month],
        COUNT(*) AS CancellationCount
    FROM
        AirlineProject.dbo.[Customer Loyalty History]
    WHERE
        [Cancellation_Year] IS NOT NULL
    GROUP BY
        [Cancellation_Year],
        [Cancellation_Month]
)

SELECT
    [Cancellation_Year],
    [Cancellation_Month],
    CancellationCount
FROM
    CancellationTrends
ORDER BY
    [Cancellation_Year], [Cancellation_Month];

-- Booking Trends

WITH BookingTrends AS (
    SELECT
        Year,
        Month,
        SUM([Flights_Booked]) AS TotalFlightsBooked
    FROM
        AirlineProject.dbo.[Airline Loyalty Data Dictionary]
    GROUP BY
        Year, Month
)

SELECT
    Year,
    Month,
    TotalFlightsBooked
FROM
    BookingTrends
ORDER BY
    Year, Month;


--Selecting Loyalty Card per Status

SELECT *
FROM AirlineProject.dbo.[Customer Loyalty History]
WHERE Loyalty_Card IN ('Star', 'Nova', 'Aurora');


--Comparing Loyalty Card vs Province

SELECT
    Loyalty_Card,
    Province,
    CASE
        WHEN Loyalty_Card = 'Nova' THEN 'Nova'
        WHEN Loyalty_Card = 'Aurora' THEN 'Aurora'
        WHEN Loyalty_Card = 'Star' THEN 'Star'
        ELSE 'Other'
    END AS CardCategory
FROM
    AirlineProject..[Customer Loyalty History]
ORDER BY
    Province ASC;



