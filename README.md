--------Customer Sales & Revenue Analysis----------

## Project Overview

This project analyzes customer, product and order data to understand sales performance, customer purchasing behavior, product performance and revenue trends.

The analysis was designed to answer real-world business questions and identify useful insights that can support data-driven decision-making.

## Business Objectives

- Analyze overall sales and revenue performance
- Identify top-performing products and customers
- Understand revenue by product category and city
- Analyze customer purchasing behavior
- Identify repeat and inactive customers
- Track monthly and yearly revenue trends
- Evaluate order and product performance

## Dataset

The project contains three relational tables:

- **Customers** – customer details such as name, age, and city
- **Products** – product details including category and price
- **Orders** – order information including customer, product, quantity, and order date

### Database Relationships

Customers
   │
   │ #customer_id
   ↓
Orders
   │
   │ #product_id
   ↓
Products
