select *
from Portfolio_Project..covid_deaths$
where continent is not NULL
order by 3,4
--select *
--from Portfolio_Project..covid_vaccinations$
--order by 3,4

-- Select Data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Project..covid_deaths$
order by 1,2

--Looking at total_cases vs total_deaths
--shows likelihood of dying if you contract covid in India
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from Portfolio_Project..covid_deaths$
where location like '%india%'
order by 1,2

--Looking at Total Cases vs Population in India 
-- Shows likelihood of contracting covid in India
select location, date, total_cases, population, (total_cases/population)*100 as infected_percentage 
from Portfolio_Project..covid_deaths$
where location like '%india%'
order by 1,2

-- Countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as infected_percentage 
from Portfolio_Project..covid_deaths$
group by location, population
order by infected_percentage desc

--Countries with Highest Death Count per population
select location, population, max(total_deaths) as HighestDeathCount, max((total_deaths/population))*100 as death_percentage 
from Portfolio_Project..covid_deaths$
group by location, population
order by death_percentage desc

--Countries with Highest Death Count per total_cases by continent
select continent, max(cast(total_deaths as int)) as TotalDeathCount, (sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage 
from Portfolio_Project..covid_deaths$
where continent is not NULL
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS
select max(cast(total_deaths as int)) as TotalDeathCount, sum(new_cases) as total_cases, (sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage 
from Portfolio_Project..covid_deaths$
where continent is not NULL
--group by continent
--order by TotalDeathCount desc

--looking at people vaccinated in india
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolio_Project..covid_deaths$ dea
join Portfolio_Project..covid_vaccinations$ vac
on dea.location = vac.location and
dea.date = vac.date
where dea.continent is not null and dea.location like '%india%'
order by 2,3

--using CTE for rolling count of new vaccinations
With popvsvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated 
from Portfolio_Project..covid_deaths$ dea
join Portfolio_Project..covid_vaccinations$ vac
on dea.location = vac.location and
dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rolling_people_vaccinated/population)*100 as percent_vaccinated
from popvsvac 


--creating views for further usage while visualization

drop view if exists PercentPopulationVaccinated

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated,  (vac.total_vaccinations/dea.population) * 100 as percent_vaccinated
from Portfolio_Project..covid_deaths$ dea
join Portfolio_Project..covid_vaccinations$ vac
on dea.location = vac.location and
dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select * from PercentPopulationVaccinated

drop view if exists death_count_by_continent

create view death_count_by_continent as 
select continent, max(cast(total_deaths as int)) as TotalDeathCount, (sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage 
from Portfolio_Project..covid_deaths$
where continent is not NULL
group by continent
--order by TotalDeathCount desc

select * from death_count_by_continent order by TotalDeathCount