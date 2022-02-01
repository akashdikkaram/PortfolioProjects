select 
* from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select 
--* from PortfolioProject..CovidVaccinations
--order by 3,4

-- selecting data that we will be using
select
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- calculating death percentage total_deaths vs total_cases
select
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at total_cases vs population
-- shows  what percentage of population got covid
select
	location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 as covid_population_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- finding higest infection rate 
select
	location,
	population,
	max(total_cases) as Highest_Infection_count,
	max((total_cases/population))*100 as covid_population_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by covid_population_Percentage desc


-- finding highest death count per population
select
	location,
	max(cast (total_deaths as int)) as Highest_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by Highest_death_count desc


-- Break things by continent death count
select
	continent,
	max(cast (total_deaths as int)) as Highest_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by Highest_death_count desc

-- Global new cases and deaths
select
	sum(new_cases) as total_new_cases,
	sum(cast(new_deaths as int)) as total_new_death,
	sum(cast(new_deaths as int))/sum(new_cases) as Death_percentage
from PortfolioProject..CovidDeaths
	where continent is not null
	order by 1,2

-- Looking at total population and vaccination
select
	CovidDeaths.continent,
	CovidDeaths.location,
	CovidDeaths.date,
	CovidDeaths.population,
	CovidVaccinations.new_vaccinations,
	SUM(cast(CovidVaccinations.new_vaccinations as bigint)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date ) as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths
join PortfolioProject..CovidVaccinations
on CovidDeaths.location = CovidVaccinations.location
and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
order by 2,3;

-- with CTE to calculate vaccination percentage

with population_vaccination (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as 
(
select
	CovidDeaths.continent,
	CovidDeaths.location,
	CovidDeaths.date,
	CovidDeaths.population,
	CovidVaccinations.new_vaccinations,
	SUM(cast(CovidVaccinations.new_vaccinations as bigint)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date ) as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths
join PortfolioProject..CovidVaccinations
on CovidDeaths.location = CovidVaccinations.location
and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
--order by 2,3;
)
select 
*, (RollingPeopleVaccinated/population)*100
from population_vaccination

-- create view for visualization

create view vaccinationVisuals as
select
	CovidDeaths.continent,
	CovidDeaths.location,
	CovidDeaths.date,
	CovidDeaths.population,
	CovidVaccinations.new_vaccinations,
	SUM(cast(CovidVaccinations.new_vaccinations as bigint)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date ) as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths
join PortfolioProject..CovidVaccinations
on CovidDeaths.location = CovidVaccinations.location
and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
--order by 2,3

select 
* from vaccinationVisuals