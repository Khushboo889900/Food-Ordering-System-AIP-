
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.food.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Map<Integer, Integer> cart =
        (Map<Integer, Integer>) session.getAttribute("cart");

    if (cart == null) {
        cart = new LinkedHashMap<Integer, Integer>();
        session.setAttribute("cart", cart);
    }

    String action = request.getParameter("action");

    // Remove an item from the cart
    if ("remove".equals(action)) {
        try {
            int foodId = Integer.parseInt(
                request.getParameter("foodId")
            );
            cart.remove(foodId);
            session.setAttribute("cart", cart);
        } catch (Exception e) {
            // Ignore invalid food IDs
        }

        response.sendRedirect("cart.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Cart - Taste of Heaven</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #fff8f0;
            color: #333;
            margin: 0;
        }

        header {
            background: #8b2500;
            color: white;
            text-align: center;
            padding: 25px;
        }

        header h1 {
            margin: 0 0 10px;
        }

        nav {
            background: #5e1a00;
            text-align: center;
            padding: 15px;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: bold;
        }

        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 20px;
        }

        .card {
            background: white;
            padding: 22px;
            margin: 18px 0;
            border-radius: 12px;
            box-shadow: 0 3px 12px #ddd;
        }

        h2, h3 {
            color: #8b2500;
        }

        .price {
            color: #b83b00;
            font-weight: bold;
        }

        .total {
            background: #ffe8d6;
            padding: 18px;
            border-radius: 8px;
            font-size: 21px;
            font-weight: bold;
        }

        button {
            background: #e85d04;
            color: white;
            border: none;
            padding: 11px 17px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        button:hover {
            background: #b83b00;
        }

        .remove {
            background: #b42318;
        }

        .remove:hover {
            background: #851b13;
        }

        input[type="text"] {
            padding: 11px;
            width: 90%;
            max-width: 350px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin: 10px 0 15px;
        }

        .empty {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: #666;
        }
    </style>
</head>

<body>

<header>
    <h1>Taste of Heaven</h1>
    <p>Your selected food, ready to order!</p>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="menu.jsp">Food Menu</a>
    <a href="cart.jsp">My Cart</a>
</nav>

<div class="container">

    <h2>My Shopping Cart</h2>
    <p>Review your selected food before placing your order.</p>

    <%
        double total = 0.0;
        boolean hasItems = false;

        try (Connection con = DBConnection.getConnection()) {

            if (cart.isEmpty()) {
    %>

        <div class="empty">
            <h3>Your cart is empty!</h3>
            <p>Please explore our menu and add your favourite food.</p>
            <a href="menu.jsp">Go to Food Menu</a>
        </div>

    <%
            } else {
    %>

        <%
                for (Map.Entry<Integer, Integer> item :
                        cart.entrySet()) {

                    int foodId = item.getKey();
                    int quantity = item.getValue();

                    try (PreparedStatement ps =
                        con.prepareStatement(
                            "SELECT name, price, description " +
                            "FROM foods WHERE id = ?")) {

                        ps.setInt(1, foodId);

                        try (ResultSet rs = ps.executeQuery()) {

                            if (rs.next()) {
                                hasItems = true;

                                double price =
                                    rs.getDouble("price");

                                double subtotal =
                                    price * quantity;

                                total += subtotal;
        %>

            <div class="card">
                <h3><%= rs.getString("name") %></h3>

                <p>
                    <%= rs.getString("description") %>
                </p>

                <p>Price per item:
                    <span class="price">
                        Rs. <%= String.format("%.2f", price) %>
                    </span>
                </p>

                <p>Quantity: <%= quantity %></p>

                <p>Subtotal:
                    <span class="price">
                        Rs. <%= String.format("%.2f", subtotal) %>
                    </span>
                </p>

                <form action="cart.jsp" method="post">
                    <input type="hidden"
                           name="action" value="remove">

                    <input type="hidden"
                           name="foodId" value="<%= foodId %>">

                    <button class="remove" type="submit">
                        Remove Item
                    </button>
                </form>
            </div>

        <%
                            }
                        }
                    }
                }

                if (hasItems) {
        %>

            <div class="total">
                Total Amount: Rs.
                <%= String.format("%.2f", total) %>
            </div>

            <div class="card">
                <h3>Customer Details</h3>

                <form action="place-order" method="post">
                    <label for="customer_name">
                        Enter Your Name:
                    </label>
                    <br>

                    <input type="text"
                           id="customer_name"
                           name="customer_name"
                           placeholder="Enter your full name"
                           required>

                    <br>

                    <button type="submit">
                        Place Order
                    </button>
                </form>
            </div>

        <%
                } else {
        %>

            <div class="empty">
                <h3>No valid food items found.</h3>
                <a href="menu.jsp">Return to Food Menu</a>
            </div>

        <%
                }
            }

        } catch (Exception e) {
    %>

        <div class="empty">
            <h3>Unable to load your cart.</h3>
            <p><%= e.getMessage() %></p>
        </div>

    <%
            e.printStackTrace();
        }
    %>

</div>

<footer>
    <p>© Taste of Heaven | Online Food Ordering System</p>
</footer>

</body>
</html>
