select * from coviddeathsnew;# where continent is not null;

select * from covidvaccinations; #where continent is not null;



select location, date, total_cases, new_cases,total_deaths,population
from coviddeathsnew order by 1,2;

#Looking at total cases vs total deaths
# Shows the likelihood of death in case of infected with Covid in India
select location, date, total_cases,total_deaths, (total_deaths/total_cases) *100 as percent_death
from coviddeathsnew 
where location = 'India'
order by 1,2;

# Shows the likelihood of death in case of infected with Covid in UK
select location, date, total_cases,total_deaths, (total_deaths/total_cases) *100 as percent_death
from coviddeathsnew 
where location like '%kingdom%'
order by 1,2;

select location, date, new_cases,new_deaths, (new_deaths/new_cases) *100 as percent_death
from coviddeathsnew 
where location like '%kingdom%'
order by 2;

# Population vs Total cases
# Showing below what percent of total population of UK has been infected with covid
select location, date, total_cases,population, (total_cases/population) *100 as percent_infected
from coviddeathsnew 
where location like '%kingdom%'
order by 1,2;


# showing countries with highest infecion rate compared to population

select location,population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) *100 as HighestInfectionPercent
from coviddeathsnew 
group by location, population
order by HighestInfectionPercent desc;


# Showing countries with highest death count for population

select location, MAX(total_deaths) as TotalDeathCount #, MAX(total_deaths/population) *100 as HighestDeathPercent
from coviddeathsnew 
where continent is not null
group by location
order by TotalDeathCount desc;



-- Viewing results by continent

select continent, MAX(total_deaths) as TotalDeathCount #, MAX(total_deaths/population) *100 as HighestDeathPercent
from coviddeathsnew 
where continent is not null
group by continent
order by TotalDeathCount desc;

#use covid;


-- Global Numbers

-- death percentage each day across the world
select  date, sum(new_cases) as total_cases,sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) *100 as percent_death
from coviddeathsnew 
where continent is not null
group by date
order by 1,4;


-- total death percent across the world
select   sum(new_cases) as total_cases,sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) *100 as percent_death
from coviddeathsnew 
where continent is not null; -- o/p: 1.45% of the world population died of covid untill 7/02/2022


-- Taking a look at Covid vaccinations record
select * from covidvaccinations; #where continent is not null;


-- Joining covid deaths table with covid vaccinations table

select * from 
covidDeathsnew as deaths
join covidvaccinations as vax 
on deaths.location = vax.location 
and deaths.date = vax.date;


-- looking at total population vs vaccinations

/*select deaths.continent, deaths.location, deaths.date,deaths.population, vax.new_vaccinations from 
covidDeathsnew as deaths
join covidvaccinations as vax 
on deaths.location = vax.location 
and deaths.date = vax.date

where deaths.continent is not null #and deaths.location like 'canada'
order by 2,3;*/


-- Location wise  new vaccination count

select deaths.continent, deaths.location, deaths.date,deaths.population, vax.new_vaccinations, sum(vax.new_vaccinations)
 over (partition by deaths.location order by deaths.location, deaths.date) as rolling_vax_sum
from covidDeathsnew as deaths
join covidvaccinations as vax 
on deaths.location = vax.location 
and deaths.date = vax.date
where deaths.continent is not null #and deaths.location like 'canada'
order by 2,3;

-- percent of population vaccinated

with PopvsVax(Continent, Location, Date, Population, New_vaccitions, RollingVaccinatedPeople)
AS (select deaths.continent, deaths.location, deaths.date,deaths.population, vax.new_vaccinations, sum(vax.new_vaccinations)
 over (partition by deaths.location order by deaths.location, deaths.date) as rolling_vax_sum
from covidDeathsnew as deaths
join covidvaccinations as vax 
on deaths.location = vax.location 
and deaths.date = vax.date
where deaths.continent is not null )
#order by 2,3)

select *,(rollingvaccinatedpeople/population)*100
 from Popvsvax;


-- Create view for visualizations

create view PercentPopulationVaccinated 
as (select deaths.continent, deaths.location, deaths.date,deaths.population, vax.new_vaccinations, sum(vax.new_vaccinations)
 over (partition by deaths.location order by deaths.location, deaths.date) as rolling_vax_sum
from covidDeathsnew as deaths
join covidvaccinations as vax 
on deaths.location = vax.location 
and deaths.date = vax.date
where deaths.continent is not null );

















