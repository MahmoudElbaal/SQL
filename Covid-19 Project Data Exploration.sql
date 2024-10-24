select * from PortfolioProject..CovidDeaths where continent is not null order by 3,4

--select * from PortfolioProject..CovidVaccinations order by 3,4

select location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths 
order by 1,2

-- looking at the total cases vs total deaths 
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths where location like '%Egypt%'
order by 1,2

-- looking at the total cases vs population
select location, date, population, total_cases,(total_cases/population)*100 as PercentofPopulationInfected
from PortfolioProject..CovidDeaths where location like '%Egypt%'
order by 1,2

-- looking at countries	with the highest infection rate compared to population
select location,continent ,population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 
as PercentofPopulationInfected from PortfolioProject..CovidDeaths where continent is not null
group by location,continent ,population 
order by PercentofPopulationInfected desc

-- looking at countries	with the highest death count per population
select location,continent , Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths where continent is not null
group by location, continent
order by TotalDeathCount desc

-- Breaking things down with continents   
-- There is issues in the database itself with continent and location thats why we named location as continent
-- { select location as Continent }

-- showing continents with the highest death count per population
select location as Continent,population, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths where continent is null
group by location, population
order by TotalDeathCount desc

-- Global Numbers
select sum(new_cases)as Total_Cases,sum(cast(new_deaths as int))as Total_Deaths
, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathsPercentage
from PortfolioProject..CovidDeaths where continent is not null 
order by 1,2



select * from PortfolioProject..CovidVaccinations
	
select * from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
    on dea.location=vac.location and dea.date=vac.date

-- looking at total population vs Vaccinations
select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
    on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
order by 2,3


select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location ORDER BY dea.location , dea.date)
as RollingPeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
    on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3 

-- USE CTE { if u wanna use a big query in a calculation }
With PopvsVac (continent, location, date, population,new_vaccinations, RollingPeoplevaccinated)
as
(
select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location ORDER BY dea.location , dea.date)
as RollingPeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
    on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
-- order by 2,3 
)
select *,(RollingPeoplevaccinated/population)*100 as Percentage
from PopvsVac

-- Temp Table 
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
data datetime,
population numeric,
new_vaccinations numeric,
RollingPeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location ORDER BY dea.location , dea.date)
as RollingPeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
    on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
-- order by 2,3 

select *,(RollingPeoplevaccinated/population)*100 as Percentage
from #percentpopulationvaccinated

-- creating view to store data for later visualizations 

Create View percentpopulationvaccinated as 
select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location ORDER BY dea.location , dea.date)
as RollingPeoplevaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac 
    on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
-- order by 2,3 

select * from percentpopulationvaccinated
