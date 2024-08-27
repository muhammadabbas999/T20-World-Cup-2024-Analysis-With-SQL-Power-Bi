create database t20WorldCup2024;

use t20WorldCup2024;


-- Data Files

select * from batting
select * from bowling
select * from fielding
select * from match_result
select * from wicket


-- Data Cleaning & Preparation

alter table batting alter column Runs int
alter table bowling alter column Wkts int
alter table bowling alter column Econ float
alter table batting alter column Count_100 int
alter table batting alter column Count_50 int
alter table wicket alter column Ct int
alter table wicket alter column St int
alter table wicket alter column Dis int
alter table fielding alter column Ct int
alter table fielding alter column Ct int
alter table batting alter column SR float
alter table bowling alter column Runs int
alter table bowling alter column Balls int


alter table fielding alter column Max int
alter table wicket drop column fdc

alter table batting add Match_Host varchar(50)
alter table bowling add  Match_Host varchar(50)
alter table fielding add  Match_Host varchar(50)
alter table wicket add  Match_Host varchar(50)
alter table fielding add  fdc int
alter table bowling add  Overs int


update batting set Match_Host='USA & WEST' where Match_Host is null
update bowling set Match_Host='USA & WEST' where Match_Host is null
update fielding set Match_Host='USA & WEST' where Match_Host is null
update wicket set Match_Host='USA & WEST' where Match_Host is null
update fielding set fdc = fct - fcp where fdc is null
update bowling set Overs= Balls/6 where Overs is null

delete from batting where Player is null

Exec sp_rename 'dbo.batting.100',  'Count_100' , 'column'
Exec sp_rename 'dbo.batting.50',  'Count_50' , 'column'
Exec sp_rename 'dbo.match_result.[Team 1]',  'Team1' , 'column'
Exec sp_rename 'dbo.match_result.[Team 2]',  'Team2' , 'column'
Exec sp_rename 'dbo.fielding.Max',  'fcp' , 'column'
Exec sp_rename 'dbo.fielding.Ct',  'fct' , 'column'


-- Data Analysis 

-- Show that the top perform batter in season

select top 10
Player,
Team,
Inns,
sum(Runs) as 'Highest Score',
Ave as Average
from batting
group by Player , Team , Ave,Inns
Order by 'Highest Score' desc


-- Show the top bowlers of the season

Select top 10
Player ,
Team,
Inns as Inning,
sum(Wkts) as Wicket,
Econ as Economy
from bowling
group by Player, Team , Inns , Econ
Order by Wicket desc


-- Most Economical Bowlers Of the season

Select top 10
Player,
Team,
Inns as Inning,
sum(Wkts) as Wicket,
Econ as 'Most Economical'
from bowling
group by Player , Team , Econ , Inns , Wkts
order by Econ asc


-- Show that the Most Matches Winning Teams in this season

select top 10
Winner ,
count(Winner) as 'Total Wins'
from match_result
group by Winner 
Order by 'Total Wins' desc



-- Check the Winning Ratio By Toss Decision

select
sum(case when Margin  like '%r%'   then 1 else 0 end) as 'First Bating',
sum(case when Margin  like '%w%'  then 1 else 0 end) as 'Second Bating',
sum(case when Margin  like '%-%'  then 1 else 0 end) as 'No Result'
from match_result


-- Analyze the Ground Which Is best for first innings'

Select 
Ground,
sum(case when Margin  like '%r%'   then 1 else 0 end) as 'Good For 1st Bating'
from match_result
group by Ground
order by 'Good For 1st Bating' desc


-- Analyze the Ground Which Is best for Second innings'

Select 
Ground,
sum(case when Margin  like '%w%'   then 1 else 0 end) as 'Good For 2nd Bating'
from match_result
group by Ground
order by 'Good For 2nd Bating' desc




-- Analyze the Which teams wins Most in First innings

Select top 10
Winner,
sum(case when Margin  like '%r%'   then 1 else 0 end) as 'Best In 1st Bating'
from match_result
group by Winner
order by 'Best In 1st Bating' desc


-- Analyze the Which teams wins Most in second innings

Select top 10
Winner,
sum(case when Margin  like '%w%'   then 1 else 0 end) as 'Best In 2nd Bating'
from match_result
group by Winner
order by 'Best In 2nd Bating' desc



-- Determine the Most Hundard & Fities of players in this season

select top 10
Player ,
Inns,
sum(Count_50) as 'Most Fifties',
sum(Count_100) as 'Most Hundard',
SR
from batting
group by Player , Inns , SR
order by 'Most Fifties' desc


-- Analyze the which keepar is good through out the season

select  top 5
Player,
Team,
Inns as Inning,
(Ct + St) as 'Total Catch',
Ct as 'Catch Pick'
from wicket
order by 'Catch Pick' desc


-- Analyze the which keepar is not good through out the season

select  top 5
Player,
Team,
Inns as Inning,
(Ct + St) as 'Total Catch',
St as 'Catch Drop'
from wicket
order by 'Catch Drop' desc


-- Analyze the total catches which is drop or picked by keepers

select
sum(Dis) as 'Total Catch',
sum(Ct ) as 'Total Picked',
sum(St) as 'Total Drop'
from wicket 


-- Analyze the total catches which is drop or picked by fielders

select
sum(fct) as 'Total Catch',
sum(fcp) as 'Total Picked',
sum(fdc)  as 'Total Drop'
from fielding



-- show the which player have higest strike rate

select top 10
Player,
Team,
Inns,
SR,
Runs
from batting 
order by SR desc

-- Datermine the which bowlers gives most runs

select top 10
Player,
Team,
Inns,
Overs,
Runs,
Econ
from bowling
order by Runs desc