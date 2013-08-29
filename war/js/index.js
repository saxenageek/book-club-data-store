$(window).load(function(){
	
	if ($.cookie("logged_user") != undefined){
		localStorage.clear();
		document.getElementById("login").style.display = 'none';
		document.getElementById("userName").innerHTML = "<b>" + $.cookie("logged_user_msg") + "</b>"
		+ "&nbsp;<a href=\"Javascript:logout();\">logout</a>";	
	}else if($.cookie('loggedout') == undefined){
		$('#myModal').modal('show');
	}
});

function setLocal(event){
	var tr = event.srcElement.parentNode.parentNode;
	localStorage.setItem("edit_title",tr.cells[1].innerText);
	localStorage.setItem("edit_author",tr.cells[2].innerText);
	localStorage.setItem("edit_genre",tr.cells[3].innerText);
	localStorage.setItem("edit_year",tr.cells[4].innerText);
	localStorage.setItem("edit_owner",tr.cells[5].innerText);
}

function returnBook(event){
	var tr = event.srcElement.parentNode.parentNode;
	var selected = tr.cells[1].innerText;

	var return_date = new Date();
	return_date = return_date.toString("dd-MMM-yyyy");

	if(localStorage.getItem("edit_title") != null){
		if(selected != localStorage.getItem("edit_title")){
			alert("Please click on return link on the same row which you have selected.");
			return;
		}
		
		var msg = "Are you sure you want to return the book '"+ localStorage.getItem("edit_title") +"'. Press OK to return book.";
		var ans = confirm(msg);
		if(ans == true){
			$('#mode').val("return");
			$('#title').val(localStorage.getItem("edit_title"));
			document.forms["IssueDetailServlet"].submit();
			alert("Your book has been returned successfully.");
		}
		else{
			return;
		}
	}
	else{
		alert("Please select some book to return.");
	}
}

function openBooks(){
	if ($.cookie("logged_user") != undefined){
		window.open("books.jsp", "_parent");
	}
	else
		return;
}