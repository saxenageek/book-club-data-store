<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.bookclub.BookDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>LMS - HOME</title>
<meta charset="utf-8" />
<meta name="description" content="" />
<meta name="author" content="" />
<link rel="stylesheet" href="css/base.css" />
<link rel="stylesheet" href="css/layout.css" />
<link rel="stylesheet" href="css/login.css" />
<link rel="stylesheet" href="css/tableutils.css" />
<link rel="stylesheet" href="css/bootstrap.css" />

<script src="js/jquery.js"></script>
<script src="js/jquery-migrate.js"></script>
<script src="js/jquery-cookie.js"></script>
<script src="js/taffy.js"></script>
<script src="js/db.js"></script>
<script src="js/custom.js"></script>
<script src="js/html5.js"></script>
<script src="js/bootstrap-transition.js"></script>
<script src="js/bootstrap-modal.js"></script>

<script src="js/logging.js"></script>
<script src="js/login.js"></script>
<script src="js/shortcut.js"></script>
<script src="js/tableutils.js"></script>
<script src="js/index.js"></script>
</head>
<body>

<div id="content-wrap">
	<header class="container"> 
		<hgroup>
			<h1><a href="index.jsp">Library</a></h1>
			<h3>Nothing is Obvious</h3>
		</hgroup> 
	<div id="menu_and_login">
		<nav id="nav-wrap" class="cf">
		<ul id="menu" style="float: left; vertical-align: bottom;">
			<li class="current"><a href="#">Home</a></li>
			<li><a href="Javascript:openBooks();">Books</a></li>
			<li><a href="#">Blog</a></li>
			<li><a href="#">Archives</a></li>
			<li><a href="#">About</a></li>
		</ul>
		<div id="search_section" style="float: right; vertical-align: bottom;">
			<span id="userName"></span> <b></b>
			<a href="Javascript:login();" style="font-size: 18px;" id="login" style="display:none;">login</a>
		</div>
		</nav>
	</div>
	</header>
	<!-- footer
	<!-- login modal -->
	<div class="modal hide" id="myModal">
	<div class="modal-header"><a class="close" data-dismiss="modal">�</a>
	<h3>Login</h3>
	</div>
	<div class="modal-body">
	<label for="ldap">Ldap:</label>
	<input type="text" name="ldap" tabindex="1" autofocus required placeholder="ldap" onblur="checkUser();" onclick="enableAgain();"/> 
	<label for="passwd">Password:</label>
	<input type="password" name="passwd" tabindex="2" required placeholder="password"/>
	</div>
	<div class="modal-footer"><a href="Javascript:loginClicked();" class="btn" tabindex="3">Login</a> <a
		href="Javascript:closeDialog();" class="btn btn-primary" tabindex="4">Close</a></div>
	</div>
	<!-- login modal -->
	<br />
	<form action="IssueDetailServlet" method="post" name="IssueDetailServlet">
		<input type="hidden" id="mode" name="mode"/>
		<input type="hidden" id="title" name="title"/>
	</form>
	<% 
		List<Entity> iterList = BookDAO.getAllIssuedBooks(); 
	  	if(iterList.size() == 0){
	%>
	<div style="margin-left: 340px; display:none;" id="issuedBooksDiv">
	<%	}else{ %>
	<div style="margin-left: 340px; display:block;" id="issuedBooksDiv">
	<%	} %>
		<h3>List of Issued Books</h3>
		<br />
		<table id="issuedBooks" width="900px">
		<thead>
			<tr>
				<th width="3%" align="left"></th>
				<th width="20%" align="left">Title</th>
				<th width="20%" align="left">Author</th>
				<th width="15%" align="left">Genre</th>
				<th width="15%" align="left">Year</th>
				<th width="15%" align="left">Owner</th>
				<th width="15%" align="left"></th>
			</tr>
		</thead>
		<tbody>
		<%  
			for(Entity book : iterList){	
		%>
		<tr>
			<td width="3%" align="left"><input name="rec" type="radio" onchange="setLocal(event);"></td>
			<td width="20%" align="left"><%= book.getProperty("title") %></td>
			<td width="20%" align="left"><%= book.getProperty("author") %></td>
			<td width="15%" align="left"><%= book.getProperty("genre") %></td>
			<td width="15%" align="left"><%= book.getProperty("year") %></td>
			<td width="15%" align="left"><%= book.getProperty("owner") %></td>
			<td width="15%" align="left"><a href="#" onclick="returnBook(event);">Return</a></td>
		</tr>
		<%	} %>
		</tbody>
		</table>
	</div>
</div>
<footer class="container">

<!-- footer-bottom
      ================================================== -->
<div id="footer-bottom" class="grid12 first">

<p>2013 Copyright Info &nbsp; &nbsp; &nbsp; Design by <a href="#/">Engineers</a></p>

<!-- Back To Top Button -->
<div id="go-top"><a href="#" title="Back to Top">Go To Top</a></div>

</div>

</footer>
<script>
$('#issuedBooks').tableutils( {
	fixHeader: { width: 900, height: 260 }, 				 
	paginate: { type: 'numeric', pageSize: 5 },	
	sort: { type: [ 'alphanumeric', 'alphanumeric' , 'alphanumeric', 'numeric', 'alphanumeric'] },
	
	columns: [ { label: ''},				       
	           { label: 'Title', name: 'title' },
	           { label: 'Author', name: 'author'},
	           { label: 'Genre', name: 'genre' }, 
	           { label: 'Year', name: 'year' },
	           { label: 'Owner', name: 'owner' },
	           { label: ''},
	           ]
} );
</script>
</body>
</html>