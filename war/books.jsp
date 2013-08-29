<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.bookclub.BookDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.datastore.Entity"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>LMS - BOOKS</title>
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
<script src="js/date.js"></script>
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
<script src="js/books.js"></script>
</head>
<body>

<div id="content-wrap">

<header class="container"> 
	<hgroup>
		<h1><a href="index.html">Library</a></h1>
		<h3>Nothing is Obvious</h3>
	</hgroup>
	<div id="menu_and_login">
		<nav id="nav-wrap" class="cf">
		<ul id="menu" style="float: left; vertical-align: bottom;">
			<li><a href="index.jsp">Home</a></li>
			<li class="current"><a href="#">Books</a></li>
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
<!-- edit modal start-->
<div class="modal hide" id="editModal">
	<div class="modal-header"><a class="close" data-dismiss="modal">�</a>
		<h3>Add/Update Book</h3>
	</div>
	<form action="BookDetailServlet" method="post" name="BookDetailServlet">
		<input type="hidden" id="mode" name="mode"/>
		<input type="hidden" id="title" name="title"/>
		<input type="hidden" id="data" name="data"/>
		<div class="modal-body">
			<label for="title">Title:</label> <input type="text" name="edit_title" id="edit_title" tabindex="1" autofocus required /> 
			<label for="author">Author:</label> <input type="text" name="edit_author" id="edit_author" tabindex="2" required />
			<label for="genre">Genre:</label> <input type="text" name="edit_genre" id="edit_genre" tabindex="3" required />
			<label for="year">Year:</label> <input type="text" name="edit_year" id="edit_year" tabindex="4" required />
			<label for="owner">Owner:</label> <input type="text" name="edit_owner" id="edit_owner" tabindex="5" required />
		</div>
			
		<div class="modal-footer">
			<a href="Javascript:saveEditedBook();" class="btn" tabindex="6">Save</a> 
			<a href="Javascript:closeModal('editModal');" class="btn btn-primary" tabindex="7">Cancel</a>
		</div>
	</form>
</div>
<!-- edit modal end-->
<!-- upload modal start-->
<div class="modal hide" id="uploadModal">
	<div class="modal-header"><a class="close" data-dismiss="modal">�</a>
		<h3>Upload File to add Multiple Books</h3>
	</div>
	<div class="modal-body">
		<input type="file" id="files" name="files[]" multiple />
		<output id="list"></output>
	</div>
		
	<div class="modal-footer">
		<a href="Javascript:closeModal('uploadModal');" class="btn">Close</a> 
	</div>
</div>
<!-- upload modal end-->
<br /><br />
<div style="margin-left: 340px;">
<h3>List of Available Books</h3>
<br />
<table>
<tr>
	<th width="10%" align="left">
		<img src="images/add5.png" height="20px" width="20px" style="cursor: pointer;" title="Add New Record" onclick="editRecord('new');"/>
	</th>
	<th width="10%" align="left">
		<img src="images/list.png" height="20px" width="20px" style="cursor: pointer;" title="Add New Records from File" onclick="openModal('uploadModal');" />
	</th>
	<th width="10%" align="left">
		<img src="images/edit1.png" height="20px" width="20px" style="cursor: pointer;" title="Select & Edit Record" onclick="editRecord('update');" />
	</th>
	<th width="10%" align="left">
		<img src="images/no1.png" height="20px" width="20px" style="cursor: pointer;" title="Select & Delete Record" onclick="deleteRecord();"/>
	</th>
	<th width="10%" align="left">
		<img src="images/no2.png" height="20px" width="20px" style="cursor: pointer;" title="Delete All Records" onclick="deleteAllRecords();"/>
	</th>
	<th width="10%" align="left">
		<img src="images/export_excel.jpg" height="20px" width="20px" style="cursor: pointer;" title="Export All Records" onclick="tableToExcel('books', 'Books Table')" />
	</th>
</tr>
</table>
<br />
<table id="books" width="900px">
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
		List<Entity> iterList = BookDAO.getAllAvailableBooks(); 
		for(Entity book : iterList){
	%>
		<tr>
			<td width="3%" align="left"><input name="rec" type="radio" onchange="setLocal(event);"></td>
			<td width="20%" align="left"><%= book.getProperty("title") %></td>
			<td width="20%" align="left"><%= book.getProperty("author") %></td>
			<td width="15%" align="left"><%= book.getProperty("genre") %></td>
			<td width="15%" align="left"><%= book.getProperty("year") %></td>
			<td width="15%" align="left"><%= book.getProperty("owner") %></td>
			<td width="15%" align="left"><a href="#" onclick="issueBook(event);">Issue</a></td>
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
$('#books').tableutils({
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
});
</script>
</body>
</html>