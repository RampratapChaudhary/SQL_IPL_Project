create database ipl;
use ipl;
select * from ipl_ball;
select * from ipl_matches_2020;
#1 find out all details where winner team win with 100 or more runs margin?
 select * from ipl_matches_2020 where result='runs' and result_margin>=100;
 
 #2find out which player has won maximum player of matches?
 select player_of_match,count(*) as PLAYER_OF_MATHCES from ipl_matches_2020 group by player_of_match
 having COUNT(player_of_match)>1 order by PLAYER_OF_MATHCES desc; 
 
 #3 fetch data of all the matches where the final scores of both teams tied and order
 #it in descending order of the date?
 select * from ipl_matches_2020 where result='tie' order by date desc;
 
 #4 Get the count of cities that have hosted an ipl match?
 select count(distinct city) from ipl_matches_2020;
 
 #5 Create table deliveries with all the columns of the table ipl_ball and an additional
 # column ball result containing values boundary, dot or other depending on the total run
 create table  deliveries_v02 as select *,  
    CASE WHEN total_runs >= 4 then 'boundary'  
         WHEN total_runs = 0 THEN 'dot' 
   else 'other' 
     END as ball_result  
   FROM ipl_ball
    
#6 Write a query to fetch the total n0.of boundaries and dot balls from 
 the deliveries_v02
select ball_result, count(ball_result) as count_all from deliveries_v02
 group by ball_result
 select ball_result, count(*) as count_all from deliveries_v02
 group by ball_result having count(ball_result)>1
 
 #7 Write a query to fetch the total no.of boundaries scored by each team from the 
 # deliveries_v02 table and order it in descending order of the number of boundaries scored
 select batting_team,count(ball_result) as no_of_boundaries
 from deliveries_v02 
 where ball_result='boundary' group by batting_team order by no_of_boundaries desc;
 
 #8 Write a query to fetch the total no.of dot balls bowled by each team and and order it
 # in descending order of the total no. of dot balls bowled;
 select bowling_team, count(*) as no_of_dot from deliveries_v02 where ball_result='dot' 
 group by bowling_team order by no_of_dot desc; 
 
 #9 Write a query to fetch the total no. of dismissals by dismissals kinds
 #where dismissal kind is not known
 select dismissal_kind,count(*) as no_of_dimissals from deliveries_v02 where dismissal_KIND<>'NA' 
 group by dismissal_kind order by no_of_dimissals desc; 
 
 #10 Write a query to get the top 5 who conceded maximum extra runs from the deliveries table
 select bowler,sum(extra_runs) as total_extra_runs 
  from deliveries_v02 group by bowler order by total_extra_runs desc limit 5;
  
 #11 Write a query to create a table deliveries_v03 with all the columns of deliveries_v02 table
 # and two additional column(named venue and match date) of venue and date from table matches
 create table deliveries as select a.*,b.venue,b.match_date from deliveries_v02 as a
 left join (select max(venue) as venue, max(date) as match_date,id from ipl_matches_2020
 group by id) as b
 on a.id=b.id
 select * from deliveries;
 select * from ipl_matches_2020
 
 #12 Write a query to fetch the total runs scored for each venue and order it in the descending
 #order of total runs scored
 select venue,sum(total_runs) as Sum_total_runs from deliveries group by venue
  order by Sum_total_runs desc ;
  
  #13 Write a query to fetch the year-wise total runs scored at eden gardens and order it in 
   #the descending order of total runs scored
  select year(match_date)as ipl_year,venue,sum(total_runs) as Sum_total_runs from deliveries
    where venue='Eden Gardens' group by ipl_year order by Sum_total_runs desc;
    
#14 Get unique team1 names from ipl_matches_2020,yo will notice that there are 2 entries for
 # Rising Pune Supergiant one with Rising Pune Supergiant and another with Rising Pune Supergiants
 select distinct team1 from ipl_matches_2020
 create table ipl_matches_2020_corrected as select *, replace(team1, 'Rising Pune Supergiants', 'Rising Pune Supergiant') as team1_corr 
, replace(team2, 'Rising Pune Supergiants', 'Rising Pune Supergiant') as team2_corr from ipl_matches_2020; 
 
select distinct team1_corr from ipl_matches_2020_corrected; 

#15 Create a new table deliveries_v03 with the first column as ball_id containing information
 # of id,inning,over and ball separated by'-' (for ex.3359821-1-0-1-id-inning-over-ball)
 # rest of the columns same as deliveries
 create table deliveries_v03 as select *,concat(id,'-',inning,'-','over','-',ball) 
 as ball_id from deliveries
 
 #16 Compare the total count of rows and total count of distinct ball_id in deliveries_v03
  select * from deliveries_v03 limit 20; 
select count(distinct ball_id) from deliveries_v03; 
select count(*) from deliveries_v03;

#17 Create table deliveries_v04 with all columns of deliveries_v03 and an additional column
 for row number partition over ball_id.(HINT: Syntax to add along with other columns,
 row_number() over(partition by ball_id) as r_num)
 create table deliveries_v04 as select *, row_number() over(partition by ball_id) as r_num
 from deliveries_v03;
 select * from deliveries_v04;
 
 #18 Use the r_num created indeliveries_v04  to identify instances where ball_id is 
 # repeating.(HINT:select * from deliveries_v04 where r_num=02;)
  select count(*) from deliveries_v04; 
select sum(r_num) from deliveries_v04; 
select * from deliveries_v04 order by r_num  limit 20; 
select * from deliveries_v04 WHERE r_num=2; 

#19 use subqueries to fetch data of all the ball_id which are repeating
SELECT * FROM deliveries_v04 WHERE ball_id 
in (select BALL_ID from deliveries_v04 WHERE r_num=2); 
