<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
#buttons{
    display:flex;
}
table {
    font-family: arial, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

td, th {
    border: 1px solid #dddddd;
    text-align: left;
    padding: 8px;
}

tr:nth-child(even) {
    background-color: #dddddd;
}
</style>
<meta charset="ISO-8859-1">
<title>Browse Auction Menu </title>
</head>
<body>
<div id = "buttons">
<form action='browseAuctions.jsp'><input type="submit" value = "Sort by Auction ID" /></form>
<form action='browseAuctionsType.jsp'><input type="submit" value = "Sort by Type" /></form>
<form action='browseAuctionsManu.jsp'><input type="submit" value = "Sort by Manufracturer" /></form>
<form action='browseAuctionsModel.jsp'><input type="submit" value = "Sort by Model" /></form>
<form action='browseAuctionsAmount.jsp'><input type="submit" value = "Sort by Price" /></form>
<form action='browseAuctionsEndTime.jsp'><input type="submit" value = "Sort by Ending Soonest" /></form>
</div>
	<% 
	//Create a connection string
	
	String url = "jdbc:mysql://cs336db.ceppltipnhmk.us-east-1.rds.amazonaws.com:3306/cs336Project";
	//Load JDBC driver
	Class.forName("com.mysql.jdbc.Driver");
	
	//Get the database connection
	Connection con = DriverManager.getConnection(url, "cs336", "gamer5221");
	//Create a SQL statement
	Statement stmt = con.createStatement();
	ResultSet result = null;

	if(session.getAttribute("ACCOUNT_TYPE").equals("seller"))
	{
		out.print("Logged in as: Seller");
		out.print("<br/>");
		out.print("Username: " +  session.getAttribute("USERNAME"));
		out.print("<br/>");
	}
	
	if(session.getAttribute("ACCOUNT_TYPE").equals("buyer"))
	{
		out.print("Logged in as: Buyer");
		out.print("<br/>");
		out.print("Username: " +  session.getAttribute("USERNAME"));
		out.print("<br/>");
	}
	
	try {
		String str = "SELECT * " +
				"FROM Auction " + 
				"JOIN Items using (item_id)" +
				"JOIN Bids using (auction_id)" +
				"WHERE (auction_id, amount) IN" +
				"( SELECT auction_id, MAX(amount)" +
				  "FROM Auction " +
				"JOIN Items using (item_id)" + 
				"JOIN Bids using (auction_id)" + 
				  "GROUP BY auction_id" + 
				")ORDER BY (model) ASC;";
			//Run the query against the database.
			 result = stmt.executeQuery(str);
			
			//Make an HTML table to show the results in:
			out.print("<table>");
			//make a row
			out.print("<tr>");
			out.print("<th>");
			out.print("Auction ID ");
			out.print("</th>");		

			out.print("<th>");
			out.print("Type");
			out.print("</th>");	

			out.print("<th>");
			out.print("Manufac.");
			out.print("</th>");	

			out.print("<th>");
			out.print("Model");
			out.print("</th>");
			
			out.print("<th>");
			out.print("Current Bid");
			out.print("</th>");

			out.print("<th>");
			out.print("Start Time");
			out.print("</th>");	

			out.print("<th>");
			out.print("End Time");
			out.print("</th>");
			
			out.print("<th>");
			out.print("Winner");
			out.print("</th>");
			
			
			out.print("<th>");
			out.print("Status");
			out.print("</th>");
			
			out.print("<th>");
			out.print(" ");
			out.print("</th>");
			out.print("</tr>");
			
			while (result.next()) 
			{
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("auction_id"));
				out.print("</td>");

				out.print("<td>");
				out.print(result.getString("type"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(result.getString("maker"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(result.getString("model"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("$" + result.getString("amount"));
				out.print("</td>");
		 
				out.print("<td>");
				out.print(result.getString("start_date"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(result.getString("end_date"));
				out.print("</td>");
				
				out.print("<td>");
				String tempwinner = result.getString("winner");
				if (result.wasNull())
					tempwinner = " ";
				out.print(tempwinner); 
				out.print("</td>");
				
				out.print("<th>");
				out.print(result.getString("status"));
				out.print("</th>");
			
				out.print("<td>");
				out.print("<form action='itemBid.jsp' method='get'><button name='auct' type='submit' value='" + result.getString("auction_id") + "'>View Item</button></form>");
				out.print("</td>");
				out.print("</tr>");
			}
			out.print("</table>");	
			
		} 
	catch (Exception e) 
	{
			out.print(e);
	}
	finally
	{
		if (result != null) result.close();
		if (stmt != null) stmt.close();
		if (con != null) con.close();
	}%>

			


</body>
</html>