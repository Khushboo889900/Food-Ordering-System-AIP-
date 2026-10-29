
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

    if ("add".equals(action)) {
        try {
            int foodId = Integer.parseInt(
                request.getParameter("foodId")
            );

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT id FROM foods WHERE id = ?")) {

                ps.setInt(1, foodId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cart.put(
                            foodId,
                            cart.getOrDefault(foodId, 0) + 1
                        );
                        session.setAttribute("cart", cart);
                    }
                }
            }

            response.sendRedirect("menu.jsp?added=1");
            return;

        } catch (Exception e) {
            request.setAttribute("errorMessage",
                "Unable to add item: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Food Menu - Taste of Heaven</title>

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
            padding: 25px;
            text-align: center;
        }

        header h1 {
            margin: 0 0 10px;
        }

        nav {
            background: #5e1a00;
            padding: 15px;
            text-align: center;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: bold;
        }

        nav a:hover {
            text-decoration: underline;
        }

        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 20px;
        }

        .food-list {
            display: grid;
            grid-template-columns: repeat(
                auto-fit, minmax(220px, 1fr)
            );
            gap: 20px;
        }

        .card {
            background: white;
            padding: 22px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #ddd;
        }

        .card h3 {
            color: #8b2500;
            margin-top: 0;
        }

        .price {
            font-size: 19px;
            font-weight: bold;
            color: #b83b00;
        }

        button {
            background: #e85d04;
            color: white;
            border: none;
            padding: 11px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        button:hover {
            background: #b83b00;
        }

        .message {
            background: #e4f7e8;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            color: #176b2c;
        }

        .error {
            background: #ffe5e5;
            color: #a00000;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            overflow-wrap: anywhere;
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
    <p>Delicious food, delivered with love!</p>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="menu.jsp">Food Menu</a>
    <a href="cart.jsp">My Cart</a>
</nav>

<div class="container">

    <h2>Our Food Menu</h2>
    <p>Choose your favourite food and add it to your cart.</p>

    <% if ("1".equals(request.getParameter("added"))) { %>
        <div class="message">
            Food added to your cart successfully!
        </div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <div class="food-list">

        <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT id, name, price, description FROM foods");
             ResultSet rs = ps.executeQuery()) {

            boolean found = false;

            while (rs.next()) {
                found = true;
                int id = rs.getInt("id");
        %>

            <div class="card">
                <h3><%= rs.getString("name") %></h3>

                <p>
                    <%= rs.getString("description") %>
                </p>

                <p class="price">
                    Rs. <%= rs.getBigDecimal("price") %>
                </p>

                <form action="menu.jsp" method="post">
                    <input type="hidden"
                           name="action" value="add">

                    <input type="hidden"
                           name="foodId" value="<%= id %>">

                    <button type="submit">
                        Add to Cart
                    </button>
                </form>
            </div>

        <%
            }

            if (!found) {
        %>
            <p>No food items are available.</p>
        <%
            }

        } catch (Exception e) {
        %>
            <div class="error">
                Unable to load food from the database.
                <br>
                Error: <%= e.getMessage() %>
            </div>
        <%
            e.printStackTrace();
        }
        %>

    </div>

    <p>
        <a href="cart.jsp">Go to My Cart</a>
    </p>

</div>

<footer>
    <p>© Taste of Heaven | Online Food Ordering System</p>
</footer>

</body>
</html>
