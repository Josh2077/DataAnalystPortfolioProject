  

  select * from CovidDeaths 
  where continent is not null
  order by 3, 4


 --Looking at total cases vs total deaths
 -- shows the likelihood of dying if you contract covid-19 in your country
 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
  from CovidDeaths
  where location = 'nigeria' and    continent is not null
   order by 1, 2

   --Looking at total cases vs population
   --shows what percentage of population got covid
 select location, date, population,  total_cases,  (total_cases/population)*100 as PercentageofPopulationInfected
  from CovidDeaths
  where location = 'nigeria' and   continent is not null
  order by 1, 2
 
  select location,   population,  max(total_cases) as HighestInfectionCount,  Max(total_cases/population)*100 as PercentageofPopulationInfected
  from CovidDeaths  where continent is not null
  --where location = 'nigeria'
  Group by population, location 
   order by PercentageofPopulationInfected desc

   --showing countries with the highest deathcount per/population
  select continent,  Max(cast(total_deaths as int)) as Totaldeathcount
  from CovidDeaths
  --where location = 'nigeria'
   where continent is not  null
  Group by  continent
   order by Totaldeathcount desc

   select  sum(new_cases) as totalcases , sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum
   (new_cases)*100 as DeathPercentage
   from CovidDeaths
   where continent is not null
   --Group by date
   order by 1, 2


--create temp table
create table #PercentagePopulationVaccinated
(
Continent varchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentagePopulationVaccinated

--Looking at total population vs vaccination
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,  
 sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.Date)
 as RollingPeopleVaccinated
 from 
 CovidDeaths dea
 join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by  2 , 3
 select * from #PercentagePopulationVaccinated
 