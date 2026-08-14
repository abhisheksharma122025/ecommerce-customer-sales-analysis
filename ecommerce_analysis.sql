-- E-commerce Customer & Sales Analysis
-- PostgreSQL / standard SQL

-- 1. Overall KPIs
SELECT ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit,
       COUNT(DISTINCT order_id) AS total_orders
FROM orders WHERE order_status='Delivered';

-- 2. Monthly sales trend
SELECT DATE_TRUNC('month',order_date) AS month, ROUND(SUM(sales),2) AS sales,
       ROUND(SUM(profit),2) AS profit
FROM orders WHERE order_status='Delivered'
GROUP BY 1 ORDER BY 1;

-- 3. Sales by region
SELECT c.region, ROUND(SUM(o.sales),2) AS sales, ROUND(SUM(o.profit),2) AS profit
FROM orders o JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_status='Delivered'
GROUP BY c.region ORDER BY sales DESC;

-- 4. Category performance
SELECT p.category, ROUND(SUM(o.sales),2) AS sales, ROUND(SUM(o.profit),2) AS profit,
       SUM(o.quantity) AS units_sold
FROM orders o JOIN products p ON o.product_id=p.product_id
WHERE o.order_status='Delivered'
GROUP BY p.category ORDER BY sales DESC;

-- 5. Top 10 products
SELECT p.product_name, p.category, ROUND(SUM(o.sales),2) AS sales, SUM(o.quantity) AS units_sold
FROM orders o JOIN products p ON o.product_id=p.product_id
WHERE o.order_status='Delivered'
GROUP BY p.product_name,p.category ORDER BY sales DESC LIMIT 10;

-- 6. Customer segment performance
SELECT c.customer_segment, COUNT(DISTINCT c.customer_id) AS customers,
       ROUND(SUM(o.sales),2) AS sales, ROUND(AVG(o.sales),2) AS avg_order_value
FROM orders o JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_status='Delivered'
GROUP BY c.customer_segment ORDER BY sales DESC;

-- 7. Average order value
SELECT ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) AS average_order_value
FROM orders WHERE order_status='Delivered';

-- 8. Repeat customers
SELECT customer_id, COUNT(DISTINCT order_id) AS order_count, ROUND(SUM(sales),2) AS customer_sales
FROM orders WHERE order_status='Delivered'
GROUP BY customer_id HAVING COUNT(DISTINCT order_id)>1
ORDER BY customer_sales DESC;

-- 9. Channel performance
SELECT channel, COUNT(DISTINCT order_id) AS orders, ROUND(SUM(sales),2) AS sales,
       ROUND(SUM(profit),2) AS profit
FROM orders WHERE order_status='Delivered'
GROUP BY channel ORDER BY sales DESC;

-- 10. Returned/cancelled rate
SELECT ROUND(100.0*SUM(CASE WHEN order_status IN ('Returned','Cancelled') THEN 1 ELSE 0 END)/COUNT(*),2)
       AS non_delivered_rate_pct
FROM orders;
