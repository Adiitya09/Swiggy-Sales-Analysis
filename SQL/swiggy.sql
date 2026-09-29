create database swiggy_database;
use swiggy_database;

-- Imported swiggy data from excel
-- table1 : swiggy 
-- table2 : swiggy_data 
show tables;
desc swiggy;
select * from swiggy;
select * from swiggy_data;

-- total number of restaurants.
select count(*) as `total number of restaurants` from swiggy ;

-- number of unique areas.
select count(distinct(Area)) as `number of unique areas` from swiggy; -- swiggy
select count(distinct(Area)) as `number of unique areas`  from swiggy_data;

-- number of unique cuisines.
select count(distinct(Cuisine))as `number of unique cuisines`  from swiggy_data;

-- minimum, maximum, and average restaurant price.
select avg(price) as Avg_price, max(price) as Max_Price, min(Price) as Min_Price from swiggy;
select round(avg(avg_price),2) as Avg_price, max(avg_price) as Max_Price, min(avg_Price) as Min_Price from swiggy_data;

-- minimum, maximum, and average price per restaurant.
select restaurant,price, 
		avg(price) over(partition by restaurant) as Avg_price, 
		max(price) over(partition by restaurant)  as Max_Price, 
        min(Price)  over(partition by restaurant)  as Min_Price 
        from swiggy ;
        
select distinct(Restaurant_Name), 
		avg(avg_price) over(partition by Restaurant_Name) as Avg_price, 
		max(avg_price) over(partition by Restaurant_Name)  as Max_Price, 
        min(avg_price)  over(partition by Restaurant_Name)  as Min_Price 
        from swiggy_data ;
        
        
-- minimum, maximum, and average rating
select round(avg(avg_ratings),2) as Avg_ratings, max(avg_ratings) as Max_ratings, min(avg_ratings) as Min_ratings from swiggy;
select round(avg(rating),2) as Avg_ratings, max(rating) as Max_ratings, min(rating) as Min_ratings from swiggy_data;

-- minimum, maximum, and average rating per restuarant
select restaurant,avg_ratings, 
		avg(avg_ratings) over(partition by restaurant) as Avg_rating, 
		max(avg_ratings) over(partition by restaurant)  as Max_rating, 
        min(avg_ratings)  over(partition by restaurant)  as Min_rating 
        from swiggy ;

select distinct(Restaurant_Name), 
		avg(rating) over(partition by Restaurant_Name) as Avg_rating, 
		max(rating) over(partition by Restaurant_Name)  as Max_rating, 
        min(rating)  over(partition by Restaurant_Name)  as Min_rating 
        from swiggy_data ;


-- duplicate restaurant records
select restaurant as `duplicate restaurant`, count(*) as count from swiggy group by restaurant having count(*)>1;

select Restaurant_Name as `duplicate restaurant`, count(*) as count from swiggy_data group by Restaurant_Name having count(*)>1;

-- restaurants with a rating above 4.0.
select Restaurant, avg_ratings from swiggy where avg_ratings >=4.0;
select Restaurant_Name, rating from swiggy_data where rating >=4.0;


-- restaurants with a rating below 3.0.
select Restaurant , avg_ratings from swiggy where avg_ratings < 3.0;
select Restaurant_Name, rating from swiggy_data where rating <3.0;


-- highly rated restaurants with a price below 300.
select Restaurant , avg_ratings, price from swiggy where avg_ratings > 3.5 and price<300;
select Restaurant_Name, rating,avg_price from swiggy_data where rating >3.5 and avg_price <300;

-- expensive restaurants with a rating below 3.5.
select Restaurant , avg_ratings, price from swiggy where avg_ratings < 3.5 and price > 500;
select Restaurant_Name, rating,avg_price from swiggy_data where rating <3.5 and avg_price > 500;

-- vegetarian restaurants with a rating above 4.0.
select Restaurant_Name, rating, pure_veg  from swiggy_data where rating >4.0 and pure_veg like "%yes%";

-- restaurants with more than 100 ratings.
select restaurant , total_ratings from swiggy where total_ratings >100;
select restaurant_name , number_of_ratings from swiggy_data where number_of_ratings >100;

-- restaurants offering discounts/offers.
select restaurant_name,`offer name` from swiggy_data where `offer name` is not null;

-- top 10 restaurants based on rating.
select restaurant , avg_ratings from swiggy order by avg_ratings desc limit 10;
select restaurant_name , rating from swiggy_data order by rating desc limit 10;

-- areas having more than 5 restaurants.
select Area ,count(*) as Restaurants from swiggy group by Area having count(*)>5;
select Area ,count(*) as Restaurants from swiggy_data group by Area having count(*)>5;

-- cuisines having more than 10 restaurants.
select cuisine , count(*) as Restaurants from swiggy_data group by cuisine having count(*) > 10;

-- Rank restaurants by rating within each area
select Area, Restaurant,avg_ratings, rank() over(partition by area order by avg_ratings asc  ) as `Rank` from swiggy ;
select Area, Restaurant_name,rating, rank() over(partition by area order by rating asc  ) as `Rank` from swiggy_data ;

-- Rank restaurants by price within each area.
select Area, Restaurant,price, rank() over(partition by area order by price asc  ) as `Rank` from swiggy ;
select Area, Restaurant_name,avg_price, rank() over(partition by area order by avg_price asc  ) as `Rank` from swiggy_data ;

--  top 3 restaurants in every area.
with top as (
			select area, restaurant, 
            row_number() over (partition by area ) as rn 
            from swiggy )
select area , restaurant , rn as `Rank` from top where rn<4;


with top as (
			select area, restaurant_name, 
            row_number() over (partition by area ) as rn 
            from swiggy_data )
select area , restaurant_name , rn as `Rank` from top where rn<4;


--  top 3 cuisines based on average rating

with top as(
			select cuisine , rating,
            row_number() over(partition by cuisine) as rn
            from swiggy_data)
select cuisine , rating,rn from top where rn <4;
            
select cuisine, rating from swiggy_data order by rating desc limit 3;


 -- top 5 restaurants based on customer ratings
 
 with top as (
			select avg_ratings, restaurant,
            row_number() over(partition by avg_ratings ) as rn
            from swiggy )
select avg_ratings,restaurant ,  rn from top where rn < 6;

 with top as (
			select rating, restaurant_name,
            row_number() over(partition by rating ) as rn
            from swiggy_data )
select rating,restaurant_name ,  rn from top where rn < 6;

select restaurant, avg_ratings from swiggy order by avg_ratings desc limit 5;
select restaurant_name, rating from swiggy_data order by rating desc limit 5;


--  restaurants whose rating is above the overall average

select avg(avg_ratings) as `avg` from swiggy ;
select restaurant , avg_ratings from swiggy where avg_ratings > (
				select avg(avg_ratings) as `avg` from swiggy );

select avg(rating) as `avg` from swiggy_data ;
select restaurant_name , rating from swiggy_data where rating > (
				select avg(rating) as `avg` from swiggy_data );


-- restaurants whose price is below the overall average

select avg(price) as `avg` from swiggy ;
select restaurant , price from swiggy where price < (
				select avg(price) as `avg` from swiggy );


select avg(avg_price) as `avg` from swiggy_data ;
select restaurant_name , avg_price from swiggy_data where avg_price < (
				select avg(avg_price) as `avg` from swiggy_data );


--  restaurants that have more ratings than the average restaurant.

select avg(total_ratings) as `avg` from swiggy ;
select restaurant , total_ratings from swiggy where total_ratings > (
				select avg(total_ratings) as `avg` from swiggy );

select avg(number_of_ratings) as `avg` from swiggy_data ;
select restaurant_name , number_of_ratings from swiggy_data where number_of_ratings < (
				select avg(number_of_ratings) as `avg` from swiggy_data );


-- 























-- ########################

-- restaurants located in Indiranagar.
select restaurant from swiggy where Area = "Indiranagar";

--  restaurants with a rating above 4.0.
select restaurant, avg_ratings from swiggy where avg_ratings >= 4.0;

-- restaurants with a price below 300.
select restaurant, avg_ratings from swiggy where avg_ratings >= 4.0;

-- restaurants with a price below 300.
select restaurant, Price from swiggy where Price >300;

--  vegetarian restaurants with a rating above 4.0.
select Restaurant_Name , pure_veg, rating from swiggy_data where pure_veg = "Yes" and Rating>4.0;

-- the top 5 restaurants with the highest ratings.
select restaurant, avg_ratings from swiggy order by avg_ratings desc limit 5;

-- restaurants from the cheapest to the most expensive.
select restaurant , round(avg(price),2) as price from swiggy  group by restaurant order by avg(price) asc;


-- ###################################
-- Cities With Avg Rating 
alter table swiggy rename column `Avg ratings` to avg_ratings;
select City, round(avg(avg_ratings),2) as rating from swiggy group by City;

-- Cities with most rating number 
alter table swiggy rename column `Total ratings` to total_ratings;
select City, avg(total_ratings) as avg_countOfRatings from swiggy group by City;
 
 -- Cities with delivery Time
alter table swiggy rename column `Delivery time` to delivery_time ;
select City , avg(delivery_time) as delivery_time from swiggy group by City;
 
 -- Rating Based on Delivery Time
select distinct(avg_ratings) as Rating ,  avg(delivery_time) over(partition by avg_ratings) as Delivery_Time from swiggy order by avg_ratings asc; 
 
 -- Rating Based On Count of Rating
select distinct(avg_ratings) as Rating ,  round(sum(total_ratings) over(partition by avg_ratings), 0) as Total_Rating from swiggy order by avg_ratings asc; 

-- Cities With Count of Restaurant 
select City, count(Restaurant) as total_Rest from swiggy group by City;
 
 -- Count of Restaurant as per Ratings
select distinct(avg_ratings) as Rating ,  round(count(Restaurant) over(partition by avg_ratings), 0) as Restaurant from swiggy order by avg_ratings asc; 

 -- Cities With avg Delivery Time
select City, round(avg(delivery_time),1) as delivery_time from swiggy group by City;
 
 -- ###############
 alter table swiggy_data rename column `Number of  ratings` to number_of_ratings ;
 alter table swiggy_data rename column `Average Price` to avg_price;
 alter table swiggy_data rename column `Number of Offers` to number_of_offers ;
 alter table swiggy_data rename column `ï»¿Restaurant Name` to Restaurant_Name ;
 alter table swiggy_data rename column `Pure Veg` to pure_veg ;

 
 -- Rating based On avg prices
 select distinct(Rating) , round(avg(avg_price)  over(partition by Rating),2) avg_price,  sum(number_of_offers) over(partition by Rating) as Total_Offers from swiggy_data;
 
 -- Restaurants with attributes 
 select  distinct(Restaurant_name), (pure_veg) , avg(Rating) over (partition by Restaurant_name) as rating, 
						sum(number_of_ratings) over (partition by Restaurant_name) as count_Ratings,
                        avg(avg_price) over (partition by Restaurant_name) as avg_price,
                        sum(number_of_offers) over (partition by Restaurant_name) as Total_offers
                        from swiggy_data;
                        
-- type of Cuisine
select distinct(pure_veg) , count(Cuisine) over(partition by pure_veg) as count_of_cuisine from swiggy_data;
 
 
 
 
 