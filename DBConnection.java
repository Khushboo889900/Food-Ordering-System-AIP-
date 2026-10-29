
package com.food;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection()
            throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC driver is missing. Check WEB-INF/lib.",
                e
            );
        }

        String url =
            "jdbc:mysql://localhost:3306/food_ordering";
        String user = "root";
        String password = "@Khushu1";

        return DriverManager.getConnection(
            url, user, password
        );
    }
}
