
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Taste of Heaven</title>
    <link rel="stylesheet" href="style.css">
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
        <h2>Welcome to Taste of Heaven!</h2>
        <p>Discover delicious food at affordable prices.</p>
        <p>Choose your favourite meal and place your order easily.</p>

        <form action="menu.jsp" method="get">
            <button type="submit">Explore Food Menu</button>
        </form>
    </div>
</div>

<footer>
    <p>© Taste of Heaven | Online Food Ordering System</p>
</footer>

</body>
</html>
