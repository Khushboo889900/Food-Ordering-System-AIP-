
package com.food;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/place-order")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String customerName = request.getParameter("customer_name");

        if (customerName == null || customerName.trim().isEmpty()) {
            response.sendError(400, "Customer name is required.");
            return;
        }

        HttpSession session = request.getSession();

        Map<Integer, Integer> cart =
            (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendError(400, "Your cart is empty.");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                BigDecimal total = BigDecimal.ZERO;

                // Calculate the total using database prices.
                for (Map.Entry<Integer, Integer> item : cart.entrySet()) {
                    int foodId = item.getKey();
                    int quantity = item.getValue();

                    if (quantity <= 0) {
                        throw new SQLException("Invalid quantity.");
                    }

                    try (PreparedStatement ps = con.prepareStatement(
                        "SELECT price FROM foods WHERE id = ?")) {

                        ps.setInt(1, foodId);

                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) {
                                throw new SQLException("Food not found.");
                            }

                            BigDecimal price = rs.getBigDecimal("price");
                            total = total.add(
                                price.multiply(BigDecimal.valueOf(quantity))
                            );
                        }
                    }
                }

                // Save the main order.
                int orderId;

                try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO orders (customer_name, total_amount) " +
                    "VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {

                    ps.setString(1, customerName.trim());
                    ps.setBigDecimal(2, total);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException("Order ID not generated.");
                        }
                        orderId = keys.getInt(1);
                    }
                }

                // Save each food item in the order.
                String sql =
                    "INSERT INTO order_items " +
                    "(order_id, food_id, quantity, price) VALUES (?, ?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    for (Map.Entry<Integer, Integer> item : cart.entrySet()) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.getKey());
                        ps.setInt(3, item.getValue());

                        try (PreparedStatement pricePs = con.prepareStatement(
                            "SELECT price FROM foods WHERE id = ?")) {

                            pricePs.setInt(1, item.getKey());

                            try (ResultSet rs = pricePs.executeQuery()) {
                                if (!rs.next()) {
                                    throw new SQLException("Food not found.");
                                }
                                ps.setBigDecimal(4, rs.getBigDecimal("price"));
                            }
                        }

                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                con.commit();

                session.setAttribute("orderId", orderId);
                session.setAttribute("orderTotal", total);
                session.removeAttribute("cart");

                response.sendRedirect("order-confirmation.jsp");

            } catch (Exception e) {
                con.rollback();
                throw e;
            }

        } catch (Exception e) {
            throw new ServletException("Unable to save order.", e);
        }
    }
}
