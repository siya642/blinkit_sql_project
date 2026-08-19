# Find the Top 10 Best-Selling Products based on sold_quantity
SELECT 
    product_id, product_name, sold_quantity
FROM
    blinkit.blinkit_dataset
ORDER BY sold_quantity DESC
LIMIT 10;


#Calculate the Total Revenue for each category
SELECT category,
    ROUND(SUM(sold_quantity * price), 2) AS total_revenue
FROM
    blinkit.blinkit_dataset
group by category
order by total_revenue desc;


#find the average rating of each brand and display only brands with an average rating greater then 4.0.
SELECT 
    brand, AVG(rating) AS avg_rating
FROM
    blinkit.blinkit_dataset
GROUP BY brand
HAVING AVG(rating) > 4.0;


#retrive all product where stock is less then the record level.
SELECT 
    product_name, stock, reorder_level
FROM
    blinkit.blinkit_dataset
WHERE
    stock > reorder_level;


#display the top 10 product with the highest profit margin percentage.
SELECT 
    product_name, profit_margin_pct
FROM
    blinkit.blinkit_dataset
ORDER BY profit_margin_pct
LIMIT 10;


# find the total number of organic product ,there average rating,and total quantity sold.
SELECT 
    COUNT(*) AS total_organic_product,
    ROUND(AVG(rating), 2) AS average_rating,
    SUM(sold_quantity) AS total_quantity_sold
FROM
    blinkit.blinkit_dataset
WHERE
    is_organic = 'true';


# calculate the total sales revenue for each city.
SELECT 
    city, SUM(price * sold_quantity) AS total_sale_revenue
FROM
    blinkit.blinkit_dataset
GROUP BY city
ORDER BY total_sale_revenue DESC;



#find each sellers . 
# total number of product.
# total quantity sold.
# total revenue.

SELECT 
    seller,
    COUNT(product_name) AS total_product,
    SUM(sold_quantity) AS total_quantity,
    SUM(final_price * sold_quantity) AS total_revenue
FROM
    blinkit.blinkit_dataset
GROUP BY seller
ORDER BY total_product DESC;


#calculate the percentage of on-time and delayed delivery based on delivery_status.
SELECT 
    ROUND(SUM(CASE
                WHEN delivery_status = 'on-time' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS on_time_percentage,
    ROUND(SUM(CASE
                WHEN delivery_status = 'delayed' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS delayed_percentage
FROM
    blinkit.blinkit_dataset;


#find the top 5 highest rating product with more than 100 reviews.
SELECT 
    product_name, rating, num_reviews
FROM
    blinkit.blinkit_dataset
WHERE
    num_reviews > 100
ORDER BY rating DESC , num_reviews DESC
LIMIT 5;


#compare the average sold quantity of product with discount and without discount.
SELECT 
    CASE
        WHEN discount_pct > 0 THEN 'discount'
        ELSE 'not discount'
    END AS discount_status,
    ROUND(AVG(sold_quantity), 2) AS avg_quantity
FROM
    blinkit.blinkit_dataset
GROUP BY discount_pct;


#find the average rating and total revenue for each packaging_type.
 SELECT 
    packaging_type,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(SUM(final_price * sold_quantity), 2) AS total_revenue
FROM
    blinkit.blinkit_dataset
GROUP BY packaging_type;


#display product with a shelf life greatest then 180 days and a rating above 4.5.
SELECT 
    product_name, shelf_life_days, rating
FROM
    blinkit.blinkit_dataset
WHERE
    shelf_life_days > 180 AND rating > 4.5;


# find product where:
#demand_index > 80 
#stock > reorder_level
#these product require immediate restoring.
SELECT 
    product_name, demand_index, stock, reorder_level
FROM
    blinkit.blinkit_dataset
WHERE
    demand_index > 80
        AND stock > reorder_level;


#rank product within each category based on revenue. (using a window function rank(),dense_rank())
select category,product_name,final_price*sold_quantity as revenue,
rank()over(partition by category 
	order by final_price*sold_quantity desc) as revenue_rank
from blinkit.blinkit_dataset;


#find the top 5 categories by total revenue.
SELECT 
    category, final_price * sold_quantity AS total_revenue
FROM
    blinkit.blinkit_dataset
LIMIT 5;


#calculate the average delivery time for each city.
SELECT 
    city, AVG(delivery_time_min) AS avg_delivery_time
FROM
    blinkit.blinkit_dataset
GROUP BY city
ORDER BY avg_delivery_time DESC;


# find the most expensive product in each category.
select product_name,category,final_price
        from (select *,
    rank()over( partition by category
order by final_price desc) as rnk
from blinkit.blinkit_dataset) as t
where rnk=1;


#find the top 3 brand with highest total sales revenue.
SELECT 
    brand,
    SUM(final_price * sold_quantity) AS total_sales_revenue
FROM
    blinkit.blinkit_dataset
GROUP BY brand
ORDER BY total_sales_revenue DESC
LIMIT 3;


# create a sales dashboard query showing:
SELECT 
    COUNT(DISTINCT product_name) AS total_product,
    SUM(final_price * sold_quantity) AS total_revenue,
    SUM(sold_quantity) AS total_sold_quantity,
    ROUND(AVG(rating), 2) AS average_rating,
    (SELECT 
            product_name
        FROM
            blinkit.blinkit_dataset
        ORDER BY sold_quantity DESC
        LIMIT 1) AS best_selling_product,
    (SELECT 
            category
        FROM
            blinkit.blinkit_dataset
        GROUP BY category
        ORDER BY SUM(sold_quantity * final_price) DESC
        LIMIT 1) AS highest_revenue_category,
    (SELECT 
            seller
        FROM
            blinkit.blinkit_dataset
        GROUP BY seller
        ORDER BY SUM(sold_quantity * final_price) DESC
        LIMIT 1) AS best_seller_revenue,
    ROUND(SUM(CASE
                WHEN delivery_status = 'on-time' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS on_time_percentage
FROM
    blinkit.blinkit_dataset;

