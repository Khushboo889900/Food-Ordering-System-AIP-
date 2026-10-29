
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Object orderId = session.getAttribute("orderId");
    Object orderTotal = session.getAttribute("orderTotal");

    if (orderId == null || orderTotal == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    BigDecimal total = (BigDecimal) orderTotal;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - Taste of Heaven</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #fff8f0;
            color: #333;
            margin: 0;
            text-align: center;
        }

        header {
            background: #8b2500;
            color: white;
            padding: 25px;
        }

        header h1 {
            margin: 0 0 10px;
        }

        nav {
            background: #5e1a00;
            padding: 15px;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: bold;
        }

        .container {
            max-width: 650px;
            margin: 50px auto;
            padding: 20px;
        }

        .card {
            background: white;
            padding: 35px 25px;
            border-radius: 15px;
            box-shadow: 0 4px 15px #ddd;
        }

        .success-icon {
            width: 75px;
            height: 75px;
            line-height: 75px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: #e4f7e8;
            color: #218838;
            font-size: 45px;
        }

        h2 {
            color: #218838;
        }

        .order-details {
            background: #fff8f0;
            padding: 18px;
            margin: 25px 0;
            border-radius: 8px;
            text-align: left;
        }

        .order-details p {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }

        .amount {
            color: #b83b00;
            font-size: 22px;
            font-weight: bold;
        }

        .button {
            display: inline-block;
            background: #e85d04;
            color: white;
            padding: 12px 22px;
            margin: 8px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
        }

        .button:hover {
            background: #b83b00;
        }

        footer {
            padding: 20px;
            color: #666;
        }
    </style>
</head>

<body>

<header>
    <h1>Taste of Heaven</h1>
    <p>Delicious food, delivered with love!</p>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="menu.jsp">Food Menu</a>
    <a href="cart.jsp">My Cart</a>
</nav>

<div class="container">
    <div class="card">

        <div class="success-icon">&#10003;</div>

        <h2>Order Placed Successfully!</h2>

        <p>Thank you for choosing Taste of Heaven.</p>
        <p>Your order has been received successfully.</p>

        <div class="order-details">
            <h3>Order Details</h3>

            <p>
                <strong>Order ID:</strong>
                <%= orderId %>
            </p>

            <p>
                <strong>Total Amount:</strong>
                <span class="amount">
                    Rs. <%= total %>
                </span>
            </p>

            <p>
                <strong>Order Status:</strong>
                Confirmed
            </p>
        </div>

        <p>Your delicious food order is confirmed!</p>

        <a href="menu.jsp" class="button">Order More Food</a>
        <a href="index.jsp" class="button">Back to Home</a>

    </div>
</div>

<footer>
    <p>© Taste of Heaven | Online Food Ordering System</p>
</footer>

</body>
</html>
