##Retrieve the total number of orders placed.
select count(distinct(order_id)) as total_orders from orders;
---- Total order is "21350"----
##Calculate the total revenue generated from pizza sales.
SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
----- Total revenue is '817860.049999993'----
##Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
----- 'The Greek Pizza', '35.95' this pizza have maximum price-----
###Identify the most common pizza size ordered.
SELECT 
    pizzas.size, COUNT(order_details.quantity)
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY size
LIMIT 1;

----- Piza size L have orderd most frequently----
###List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;
----- The Classic Deluxe Pizza	2453,The Barbecue Chicken Pizza	2432,The Hawaiian Pizza	2422,The Pepperoni Pizza	2418 and The Thai Chicken Pizza	2371-----
###Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category;
---- classic category pizza have more quantity then otherrs---
###Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time), COUNT(order_id) AS total_ordered
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY total_ordered DESC;

###Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(pizza_type_id)
FROM
    pizza_types
GROUP BY category
ORDER BY COUNT(pizza_type_id) DESC;
---- the supreme and veggie category have more number----
###Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0) AS total_quantity
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
---- total 138 pizas order per day -----
###Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;
----- the "Thai Chicken Pizza" has max revenue---
###Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    SUM(order_details.quantity * pizzas.price) AS total_revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            0) AS revenue_percentage
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category;
----- the classic category pizza have more revenue percentage----
###Analyze the cumulative revenue generated over time.
 select  order_date, sum(revenue) over (order by order_date) as cumulative_revenue from
 (select orders.order_date, sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on order_details.order_id = orders.order_id
group by orders.order_date) as total_sales;

###Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT 
    pizza_types.category,
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category , pizza_types.name
ORDER BY total_revenue DESC
LIMIT 3;
----- the top 3 most ordered pizza is chicke pizza based on revenue----

