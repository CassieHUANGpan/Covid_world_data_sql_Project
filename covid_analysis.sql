--Shows the vaccination rate by country with the rolling day by day trend
With cte as(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(cast(new_vaccinations as float)) over (partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from covid_death d
join covid_vaccination v
    on d.location=v.location
	and d.date=v.date
where d.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100 as rollingVaccineRate
from cte
order by location,date


--Shows the death rate by infection, vaccination rate, and hospital bed per 1000
Create view Correlation_hospitalBed as
select d.location, d.population, v.hospital_beds_per_thousand,
max(total_deaths)/d.population*100 as death_rate
,max(people_fully_vaccinated)/d.population*100 as vaccine_rate
from covid_death d
join covid_vaccination v
    on d.location=v.location
	and d.date=v.date
where d.continent is not null
group by d.location,d.population,v.hospital_beds_per_thousand
--order by death_rate desc