/*
Global Education Data Exploration

Skills used : Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting data types
*/

Select *
From PortfolioProject..['1- share-of-the-world-populatio$']
Where [Share of population with no formal education, 1820-2020] is not null
Order by 3,4

Select *
From PortfolioProject..['2- learning-adjusted-years-of-s$']
Order by 3,4

Select *
From PortfolioProject..['3- number-of-out-of-school-chil$']
Order by 3,4

Select *
From PortfolioProject..['4- gender-gap-education-levels$']
Order by 3,4

--Share of population with no formal education, 1820-2020 vs Share of popolation with some form of education, 1820-2020
--Shows  percentage of population in South Africa that had no formal education between 1820-2020

Select Entity, Code, Year, [Share of population with no formal education, 1820-2020],[Share of population with some formal education, 1820-2020], ([Share of population with no formal education, 1820-2020]/[Share of population with some formal education, 1820-2020])*100 as NoFormalEducationPercentage
From PortfolioProject..['1- share-of-the-world-populatio$']
Where Entity like '%South Africa%'
Order by 1,2

--Share of population with no formal education, 1820-2020 vs Share of popolation with some form of education, 1820-2020
--Shows percentage for Entity(Country) with lowest formal education

Select Entity, Code, Year, [Share of population with no formal education, 1820-2020],[Share of population with some formal education, 1820-2020], ([Share of population with no formal education, 1820-2020]/[Share of population with some formal education, 1820-2020])*100 as NoFormalEducationPercentage
From PortfolioProject..['1- share-of-the-world-populatio$']
--Where Entity like '%South Africa%'
Order by 1,2

--Entities with Highest No Formal Education Rate

Select Entity, [Share of population with no formal education, 1820-2020], MAX([Share of population with no formal education, 1820-2020]) as HigestNoFormalEducation
From PortfolioProject..['1- share-of-the-world-populatio$']
Group by Entity, [Share of population with no formal education, 1820-2020]
Order by HigestNoFormalEducation desc

--Entities with Highest Formal Education Rate

Select Entity, [Share of population with some formal education, 1820-2020], MAX([Share of population with some formal education, 1820-2020]) as HigestFormalEducation
From PortfolioProject..['1- share-of-the-world-populatio$']
Group by Entity, [Share of population with some formal education, 1820-2020]
Order by HigestFormalEducation desc


--Breaking Things Down By Entity(Country)

Select Entity, [Share of population with no formal education, 1820-2020],  MAX(cast([Share of population with no formal education, 1820-2020] as int)) as HigestNoFormalEducation
From PortfolioProject..['1- share-of-the-world-populatio$']
Where [Share of population with no formal education, 1820-2020] is not null
Group by Entity, [Share of population with no formal education, 1820-2020]
Order by HigestNoFormalEducation desc

-- Loking at how the learning has adjusted over the years of school

Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with no formal education, 1820-2020], learn.[Learning-Adjusted Years of School]
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['2- learning-adjusted-years-of-s$'] learn
     On share.Entity = learn.Entity
	 and share.Year = learn.Year
Where [Share of population with no formal education, 1820-2020] is not null
Order by 1,2,3

--Looking at how many children were out of school during the years 1820-2020

Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education], number.[Out-of-school children, adolescents and youth of primary and sec)], number.[Out-of-school children, adolescents and youth of primary and sec]
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['3- number-of-out-of-school-chil$'] number
     On share.Entity = number.Entity
	 and share.Year = number.Year
Where [Share of population with no formal education, 1820-2020] is not null
Order by 1,2,3

--Looking at the gender that was mostly enrolled in tertiary

Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education, 1820-2020], gender.[Combined gross enrolment ratio for tertiary education, female], gender.[Combined gross enrolment ratio for tertiary education, male]
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['4- gender-gap-education-levels$'] gender
     On share.Entity = gender.Entity
	 and share.Year = gender.Year
Where [Share of population with no formal education, 1820-2020] is not null

--Looking at the gender that was mostly enrolled in secondary school

Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education, 1820-2020], gender.[Combined total net enrolment rate, secondary, female] , gender.[Combined total net enrolment rate, secondary, male]
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['4- gender-gap-education-levels$'] gender
     On share.Entity = gender.Entity
	 and share.Year = gender.Year
Where [Combined total net enrolment rate, secondary, female] is not null
Order by 1,2,3

--Looking at the gender that was mostly enrolled in secondary school

Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education, 1820-2020], gender.[Combined total net enrolment rate, secondary, female] , gender.[Combined total net enrolment rate, secondary, male]
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['4- gender-gap-education-levels$'] gender
     On share.Entity = gender.Entity
	 and share.Year = gender.Year
Where [Combined total net enrolment rate, secondary, female] is not null
Order by 1,2,3


--World Population vs Total enrollment 

Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education, 1820-2020], gender.[Combined total net enrolment rate, secondary, female] , gender.[Combined total net enrolment rate, secondary, male]
, SUM(CONVERT(int,gender.[Combined total net enrolment rate, secondary, female], gender.[Combined total net enrolment rate, secondary, male])) OVER (Partition by share.Entity Order by share.Entity, share.Year) as GenderEnrollment
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['4- gender-gap-education-levels$'] gender
     On share.Entity = gender.Entity
	 and share.Year = gender.Year
Where [Combined total net enrolment rate, secondary, female] is not null
Order by 1,2,3

--Using CTE to perfom Calculation on Partion By in previous query

With PopulationvsEnrollment (Entity, Code, Year, [Share of population with no formal education, 1820-2020], [Share of population with some formal education, 1820-2020])
as
(
Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education, 1820-2020], gender.[Combined total net enrolment rate, secondary, female] , gender.[Combined total net enrolment rate, secondary, male]
, SUM(CONVERT(int,gender.[Combined total net enrolment rate, secondary, female], gender.[Combined total net enrolment rate, secondary, male])) OVER (Partition by share.Entity Order by share.Entity, share.Year) as GenderEnrollment
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['4- gender-gap-education-levels$'] gender
     On share.Entity = gender.Entity
	 and share.Year = gender.Year
Where [Combined total net enrolment rate, secondary, female] is not null
Order by 1,2,3
)
Select*

--Using Temp Table to perform calculation on Partition By in previous query

DROP Table if exists #GenderEnrollment
Create Table #GenderEnrollment
(
Entity nvarchar(255),
Code nvarchar(255),
Year numeric,
[Share of population with no formal education, 1820-2020] numeric,
[Share of population with some formal education, 1820-2020] numeric,
[Combined total net enrolment rate, secondary, female] nvarchar,
[Combined total net enrolment rate, secondary, male] nvarchar,
)

Insert into #GenderEnrollment
Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education, 1820-2020], gender.[Combined total net enrolment rate, secondary, female] , gender.[Combined total net enrolment rate, secondary, male]
, SUM(CONVERT(int,gender.[Combined total net enrolment rate, secondary, female], gender.[Combined total net enrolment rate, secondary, male])) OVER (Partition by share.Entity Order by share.Entity, share.Year) as GenderEnrollment
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['4- gender-gap-education-levels$'] gender
     On share.Entity = gender.Entity
	 and share.Year = gender.Year
--Where [Combined total net enrolment rate, secondary, female] is not null
--Order by 1,2,3

Select *
From #GenderEnrollment

--Creating View to store data for later Visualizations

Create View GenderEnrollment as
Select share.Entity, share.Code, share.Year, share.[Share of population with no formal education, 1820-2020], share.[Share of population with some formal education, 1820-2020], gender.[Combined total net enrolment rate, secondary, female] , gender.[Combined total net enrolment rate, secondary, male]
, SUM(CONVERT(int,gender.[Combined total net enrolment rate, secondary, female], gender.[Combined total net enrolment rate, secondary, male])) OVER (Partition by share.Entity Order by share.Entity, share.Year) as GenderEnrollment
From PortfolioProject..['1- share-of-the-world-populatio$'] share
Join PortfolioProject..['4- gender-gap-education-levels$'] gender
     On share.Entity = gender.Entity
	 and share.Year = gender.Year
Where [Combined total net enrolment rate, secondary, female] is not null
Order by 1,2,3