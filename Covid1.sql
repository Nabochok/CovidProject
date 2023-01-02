USE Project1;

SELECT *
FROM CovidDeaths
Order BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

-- Looking at total cases vs total deaths
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths as float)/CAST (total_cases as float))*100 as death_percantage
FROM CovidDeaths
WHERE location like 'Ukr%'
ORDER BY 1,2

--Looking at total_cases vs population
--Shows what percantage of population got covid
SELECT location, date, total_cases, population, (CAST(total_cases as float)/CAST (population as float))*100 as percent_of_pop_infected
FROM CovidDeaths
WHERE location like 'Ukr%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population 
SELECT location, population, MAX(total_cases) as highest_inf_count,MAX((CAST(total_cases as float)/CAST (population as float))*100) as percent_of_pop_infected
FROM CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

--Showing countries with highest deth rate
SELECT location, MAX(total_deaths) as max_death
FROM CovidDeaths
Where continent is not null
GROUP BY location
ORDER BY 2 DESC  


--Lets break things down by continent
SELECT continent, MAX(total_deaths) as max_death
FROM CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY 2 DESC 

--Showing continents with highest death count per population
SELECT continent, MAX(total_deaths) as highest_inf_count,MAX((CAST(total_deaths as float)/CAST (population as float))*100) as percent_of_pop_death
FROM CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY 3 DESC

SElECT SUM(new_cases) as total_cases,
SUM(new_deaths) as total_death,
(SUM(CAST(new_deaths as FLOAT))/SUM(new_cases))*100 as death_percentage
FROM CovidDeaths
Where continent is not null


--Looking at total population and vaccination
WITH PopVsVac (continent, location, date, population, new_vaccinations, rolling_peop_vac)
as
(
SELECT det.continent,det.location, det.date, det.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by det.location ORDER BY det.location, det.date) as rolling_peop_vac
FROM CovidDeaths det
JOIN CovidVaccinations vac
ON det.location=vac.location and vac.date = det.date
Where det.continent is not null
--ORDER BY 2,3
)
SELECT *, 
(rolling_peop_vac/CAST(population as float))*100 as pvc
FROM PopVsVac

--Create temp table

CREATE TABLE #PopulVsVaccine (
continent nvarchar(255),
location nvarchar(255),
date datetime, 
population numeric, 
new_vaccinations numeric, 
rolling_peop_vac numeric
)

INSERT INTO #PopulVsVaccine
SELECT det.continent,det.location, det.date, det.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by det.location ORDER BY det.location, det.date) as rolling_peop_vac
FROM CovidDeaths det
JOIN CovidVaccinations vac
ON det.location=vac.location and vac.date = det.date
Where det.continent is not null

SELECT *
FROM #PopulVsVaccine


--Creating view for later vizualization
CREATE VIEW PopulVsVaccine
as
SELECT det.continent,det.location, det.date, det.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by det.location ORDER BY det.location, det.date) as rolling_peop_vac
FROM CovidDeaths det
JOIN CovidVaccinations vac
ON det.location=vac.location and vac.date = det.date
Where det.continent is not null

