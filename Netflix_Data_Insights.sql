-- Netflix Data Analysis using SQL


use netflix;

select * 
from netflix;

-- 1. Count the number of Movies vs TV Shows

select type, count(*)
from netflix
group by type;

-- 2. Find the most common rating for movies and TV shows
with RatingCounts as(
	select type, rating, count(*) as rating_count
    from netflix
    group by type, rating),
RankedRatings as (
	select type, rating, rating_count, 
		rank() over (partition by type order by rating_count desc) as rnk
	from RatingCounts)
select type, rating as most_frequent_rating
from RankedRatings
where rnk = 1;

-- 3. List all movies released in a specific year
drop procedure GetMoviesByYear;
delimiter $$
create procedure GetMoviesByYear(IN input_year INT)
begin
	select *
    from netflix
    where release_year = input_year and type = 'Movie';
    
end  $$

delimiter ;

-- Test for 2020
CALL GetMoviesByYear(2020);


-- 4. Find the top 5 countries with the most content on Netflix

with recursive
  recursivesplit (country, remaining_countries) as
  (
    select
      substring_index(t.country, ',', 1) as country,
      substring(t.country, length(substring_index(t.country, ',', 1)) + 2) as remaining_countries
    from netflix as t
    where t.country is not null

    union all

    select
      substring_index(rs.remaining_countries, ',', 1),
      substring(rs.remaining_countries, length(substring_index(rs.remaining_countries, ',', 1)) + 2)
    from recursivesplit as rs
    where rs.remaining_countries <> ''
  )
select
  country,
  count(*) as total_content
from recursivesplit
where country is not null and country <> ''
group by
  country
order by
  total_content desc
limit 5;


-- 5. Identify the longest movie

select * 
from netflix
where type = 'Movie'
order by cast(substring_index(duration, ' ', 1) as signed) desc
limit 1;

-- 6. Find content released in the last 10 years

select *
from netflix
where release_year >= (year(curdate()) - 10);


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select *
from netflix
where director like '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
select *
from netflix
where type = 'TV Show' and duration like '%season%'
	and cast(substring_index(duration, ' ', 1) as unsigned) > 5; 
    

-- 9. Count the number of content items in each genre
	
with recursive genre_split as(
	select show_id, listed_in, trim(substring_index(listed_in, ',', 1)) as genre,
    substring(listed_in, length(substring_index(listed_in, ',', 1)) + 2) AS rest
    from netflix
    
    union all
    
    select show_id, rest, trim(substring_index(rest, ',', 1)) as genre,
    substring(rest, length(substring_index(rest, ',', 1)) + 2) AS rest
    from genre_split
    where rest <> ''
    )
select genre, count(*) as total_content
from genre_split
where genre is not null and genre != ' '
group by genre
order by total_content desc;


-- 10. percentage of total netflix content released by canada each year
-- return top 5 years with highest percentage after 2010

select 
    release_year,
    sum(country = 'Canada') as canada_release,
    round(sum(country = 'Canada') * 100.0 / count(show_id), 2) as pct_of_total
from netflix
where release_year > 2010
group by release_year
order by pct_of_total desc
limit 5;



-- 11. List all movies that are documentaries
select *
from netflix
where listed_in like '%Documentaries%';


-- 12. Find all content without a director
select * 
from netflix
where director is null;

-- 13. Find how many movies actor 'Adam Sandler' appeared in last 10 years
select *
from netflix
where cast like '%Adam Sandler%' and release_year > 2014;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in Canada.
with recursive actor_split as (
    select 
        show_id,
        trim(substring_index(`cast`, ',', 1)) as actor,
        substring(`cast`, length(substring_index(`cast`, ',', 1)) + 2) as rest
    from netflix
    where country = 'Canada' and `cast` is not null and `cast` != ''
    
    union all
    
    select
        show_id,
        trim(substring_index(rest, ',', 1)) as actor,
        substring(rest, length(substring_index(rest, ',', 1)) + 2) as rest
    from actor_split
    where rest != ''
)
select 
    actor,
    count(*) as times
from actor_split
where actor is not null and actor != ''
group by actor
order by times desc
limit 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field. 
-- Label content containing these keywords as 'Parental Guidance (PG)' and all other content as 'Suitable for All (G)'. 
-- Count how many items fall into each category.

select category, type, count(*) as num_of_contents
from (
select *,
	case when description like '%kill' or description like '%violence%'
		then 'Parental Guidance (PG)'
		else 'Suitable for All (G)'
    end as category
from netflix) as categorized
group by category, type
order by type;


-- 16. Analyze yearly content growth and changes after 2000
select 
    release_year,
    total_releases,
    lag(total_releases) over (order by release_year) as last_year_releases,
    round(
        (total_releases - lag(total_releases) over (order by release_year)) * 100.0 / 
        nullif(lag(total_releases) over (order by release_year), 0),
        2
    ) as pct_change
from (
    select release_year, count(*) as total_releases
    from netflix
    group by release_year
) as yearly_counts
where release_year > 2000
order by release_year;


-- 17. Identify the most prolific directors per genre
with recursive genre_director as (
    select 
        show_id,
        trim(substring_index(listed_in, ',', 1)) as genre,
        trim(substring_index(director, ',', 1)) as director,
        substring(listed_in, length(substring_index(listed_in, ',', 1)) + 2) as rest_genre,
        substring(director, length(substring_index(director, ',', 1)) + 2) as rest_director
    from netflix
    where director != '' and listed_in != ''
    
    union all
    
    select 
        show_id,
        trim(substring_index(rest_genre, ',', 1)) as genre,
        trim(substring_index(rest_director, ',', 1)) as director,
        substring(rest_genre, length(substring_index(rest_genre, ',', 1)) + 2),
        substring(rest_director, length(substring_index(rest_director, ',', 1)) + 2)
    from genre_director
    where rest_genre != '' and rest_director != ''
)

select genre, director, total_works
from (
    select 
        genre,
        director,
        count(*) as total_works,
        row_number() over (partition by genre order by count(*) desc) as rn
    from genre_director
    where genre != '' and director != ''
    group by genre, director
) as ranked
where rn = 1
order by total_works desc;

-- 18. Compare average duration of movies and TV shows by rating
select rating, type, avg_duration,
	max(avg_duration) over (partition by type) as type_max_duration,
    min(avg_duration) over (partition by type) as type_min_duration
from (
	select rating, type, 
    avg(cast(substring_index(duration, ' ', 1) as unsigned)) as avg_duration
    from netflix
    where duration like '%min%'
    group by rating, type) as t
order by type, avg_duration desc;


-- 19.  Find top 3 producing countries each year after 2020

select release_year, country, total_content, rnk
from(
	select release_year, country, count(*) as total_content,
    dense_rank() over (partition by release_year order by count(*) desc) as rnk
    from netflix
    where country != ''
    group by release_year, country
    ) as ranked
where rnk <= 3 and release_year >= 2000
order by release_year, total_content desc;


-- 20. Calculate the percentage of TV shows vs movies released each year after 2000
select release_year, 
	round(100 * sum(case when type = 'Movie' then 1 else 0 end) / count(*), 2) as movie_pct,
	round(100 * sum(case when type = 'TV Show' then 1 else 0 end) / count(*), 2) as tvshow_pct
from netflix
where release_year > 1999
group by release_year
order by release_year;

-- End of reports