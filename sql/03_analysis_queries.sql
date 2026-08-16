USE sql_project;

-- ============================================================
-- CUSTOMER SALES & REVENUE ANALYSIS
-- Business Questions and SQL Analysis
-- ============================================================


-- Q1. How many customers are there in each city?
SELECT
    city,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY city
ORDER BY total_customers DESC;


-- Q2. What is the total revenue generated from all orders?
SELECT
    SUM(p.price * o.quantity) AS total_revenue
FROM Orders o
INNER JOIN Products p
    ON o.product_id = p.product_id;


-- Q3. What are the total number of orders and total quantity sold?

SELECT
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_quantity_sold
FROM Orders;


-- Q4. Which products generate the highest revenue?
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM Products p
INNER JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;


-- Q5. What are the top 5 products by total revenue?
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM Products p
INNER JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;


-- Q6. Which products have the highest quantity sold?
SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity_sold
FROM Products p
INNER JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


-- Q7. Which product categories generate the highest revenue?
SELECT
    p.category,
    SUM(p.price * o.quantity) AS total_revenue
FROM Products p
INNER JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Q8. Which cities generate the highest revenue?
SELECT
    c.city,
    SUM(p.price * o.quantity) AS total_revenue
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
INNER JOIN Products p
    ON o.product_id = p.product_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- Q9. Who are the top 5 customers by total revenue?
SELECT
    c.customer_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
INNER JOIN Products p
    ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 5;


-- Q10. Which customers have placed at least 2 orders?
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2
ORDER BY total_orders DESC;


-- Q11. Which customers have never placed an order?
SELECT
    c.customer_id,
    c.customer_name,
    c.city
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Q12. What is the average order value?
SELECT
    AVG(p.price * o.quantity) AS average_order_value
FROM Orders o
INNER JOIN Products p
    ON o.product_id = p.product_id;


-- Q13. Which customers have total spending above the average customer spending?
WITH CustomerSpending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(p.price * o.quantity) AS total_spending
    FROM Customers c
    INNER JOIN Orders o
        ON c.customer_id = o.customer_id
    INNER JOIN Products p
        ON o.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_spending
FROM CustomerSpending
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM CustomerSpending
)
ORDER BY total_spending DESC;


-- Q14. What is the monthly revenue trend?
SELECT
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    SUM(p.price * o.quantity) AS total_revenue
FROM Orders o
INNER JOIN Products p
    ON o.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY year, month;


-- Q15. What is the total revenue generated in each year?
SELECT
    YEAR(o.order_date) AS year,
    SUM(p.price * o.quantity) AS total_revenue
FROM Orders o
INNER JOIN Products p
    ON o.product_id = p.product_id
GROUP BY YEAR(o.order_date)
ORDER BY total_revenue DESC;


-- Q16. What is the latest order placed by each customer?
WITH LatestOrders AS (
    SELECT
        c.customer_name,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id
            ORDER BY o.order_date DESC
        ) AS rn
    FROM Customers c
    INNER JOIN Orders o
        ON c.customer_id = o.customer_id
)
SELECT
    customer_name,
    order_id,
    order_date
FROM LatestOrders
WHERE rn = 1;


-- Q17. What was the previous order date for each customer?
SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    LAG(o.order_date) OVER (
        PARTITION BY c.customer_id
        ORDER BY o.order_date
    ) AS previous_order_date
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_name, o.order_date;


-- Q18. How do products rank based on total revenue?
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(p.price * o.quantity) DESC
    ) AS revenue_rank
FROM Products p
INNER JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;


-- Q19. How can products be segmented based on their price?
SELECT
    product_name,
    price,
    CASE
        WHEN price >= 50000 THEN 'Premium'
        WHEN price >= 10000 THEN 'Standard'
        ELSE 'Budget'
    END AS price_segment
FROM Products
ORDER BY price DESC;


-- Q20. What is the total number of orders and revenue generated by each customer?
SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.price * o.quantity) AS total_revenue
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
INNER JOIN Products p
    ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC;


-- Q21. What are the total quantity sold and revenue generated by each category?
SELECT
    p.category,
    SUM(o.quantity) AS total_quantity_sold,
    SUM(p.price * o.quantity) AS total_revenue
FROM Products p
INNER JOIN Orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Q22. Which individual order generated the highest revenue?
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    o.quantity,
    p.price * o.quantity AS order_value
FROM Orders o
INNER JOIN Customers c
    ON o.customer_id = c.customer_id
INNER JOIN Products p
    ON o.product_id = p.product_id
ORDER BY order_value DESC
LIMIT 1;


-- Q23. Which customers have an average order value greater than 20,000?
SELECT
    c.customer_name,
    AVG(p.price * o.quantity) AS average_order_value
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
INNER JOIN Products p
    ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING AVG(p.price * o.quantity) > 20000
ORDER BY average_order_value DESC;


-- Q24. What is the second-highest product price?
SELECT
    product_name,
    price
FROM Products
WHERE price = (
    SELECT MAX(price)
    FROM Products
    WHERE price < (
        SELECT MAX(price)
        FROM Products
    )
);


-- Q25. Which customers have placed 3 or more orders?
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 3
ORDER BY total_orders DESC;
