$(window).load(function(){
	document.getElementById('files').addEventListener('change', handleFileSelect, false);
	if ($.cookie("logged_user") != undefined){
		localStorage.clear();
		document.getElementById("login").style.display = 'none';
		document.getElementById("userName").innerHTML = "<b>" + $.cookie("logged_user_msg") + "</b>"
		+ "&nbsp;<a href=\"Javascript:logout();\">logout</a>";	
	}else if($.cookie("loggedout") == undefined){
		$('#myModal').modal('show');
	}
});

document.onmousedown=disablerightclick;
var status = "Right click is disabled";
function disablerightclick(event)
{
	if(event.button==2)
	{
		alert(status);
		return false;    
	}
}

function setLocal(event){
	var tr = event.srcElement.parentNode.parentNode;
	localStorage.setItem("edit_title",tr.cells[1].innerText);
	localStorage.setItem("edit_author",tr.cells[2].innerText);
	localStorage.setItem("edit_genre",tr.cells[3].innerText);
	localStorage.setItem("edit_year",tr.cells[4].innerText);
	localStorage.setItem("edit_owner",tr.cells[5].innerText);
}

function editRecord(msg){
	if(msg == "update"){
		localStorage.setItem("mode","update");
		if(localStorage.getItem("edit_title") != null){
			$('#edit_author').val(localStorage.getItem("edit_author")); 
			$('#edit_genre').val(localStorage.getItem("edit_genre")); 
			$('#edit_year').val(localStorage.getItem("edit_year"));
			$('#edit_title').val(localStorage.getItem("edit_title"));
			$('#edit_owner').val(localStorage.getItem("edit_owner"));
			openModal("editModal");
		}
		else{
			alert("Please select some record to edit.");
		}
	}
	else if(msg == "new"){
		localStorage.setItem("mode","new");
		openModal("editModal");
	}
}

function openModal(id){
	$('#' + id).modal('show');
}

function deleteRecord(){
	if(localStorage.getItem("edit_title") != null){
		var ans = confirm("Are you sure you want to delete " + localStorage.getItem("edit_title") + " ?");
		if (ans == true)
		{		
			$('#mode').val("delete");
			$('#title').val(localStorage.getItem("edit_title"));
			document.forms["BookDetailServlet"].submit();
			alert("Book Deleted Successfully.");
			localStorage.clear();
		}
		else
		{
			return;
		}
	}
	else{
		alert("Please select some record to delete.");
	}
}

function deleteAllRecords(){
	var ans = confirm("Are you sure you want to delete all records?");
	if (ans == true)
	{
		var again = confirm("This action cannot be reversed.. Want to delete anyways ?");
		if(again == true){
			$('#mode').val("deleteall");
			document.forms["BookDetailServlet"].submit();
			alert("All Books Deleted Successfully.");
			localStorage.clear();
		}
		else{
			return;
		}
	}
	else
	{
		return;
	}	
}

function closeModal(id){
	$('#' + id).modal('hide');
}

function saveEditedBook(){
	if(localStorage.getItem("mode") == "update"){
		$('#mode').val("update");
	}
	else if(localStorage.getItem("mode") == "new"){
		$('#mode').val("new");
	}
	if(localStorage.getItem("edit_title") != null && localStorage.getItem("edit_title") != undefined)
		$('#title').val(localStorage.getItem("edit_title"));
	else
		$('#title').val($('#edit_title').val());
	
	document.forms["BookDetailServlet"].submit();
	alert("Book Details Saved Successfully.");
	localStorage.clear();
}

//<!--add multiple files function -->
function handleFileSelect(evt) {
	var files = evt.target.files;

	for (var i = 0, f; f = files[i]; i++) {
		var reader = new FileReader();

		reader.onload = (function(theFile) {
			return function(e) {
				var data = e.target.result.split("\n");
				$('#data').val(data);
				$('#mode').val("addbulk");
				document.forms["BookDetailServlet"].submit();
				alert("Book Details Saved Successfully.");
				localStorage.clear();
			};
		})(f);

		reader.readAsText(f);
	}
}
//<!--add multiple files function -->

//<!--export to excel function -->
var tableToExcel = (function() {
	  var uri = 'data:application/vnd.ms-excel;base64,'
	    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
	    , base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))); }
	    , format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
	  return function(table, name) {
	    if (!table.nodeType) table = document.getElementById(table)
	    var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
	    window.location.href = uri + base64(format(template, ctx));
	  }
})();
//<!--export to excel function -->

function issueBook(event){
	var tr = event.srcElement.parentNode.parentNode;
	var selected = tr.cells[1].innerText;
	var owner = tr.cells[5].innerText;
	var issue_date = new Date();
	var duedate = new Date();
	duedate.setDate(issue_date.getDate()+14);
	
	duedate = duedate.toString("dd-MMM-yyyy");
	issue_date = issue_date.toString("dd-MMM-yyyy");
	if(localStorage.getItem("edit_title") != null){
		if(selected != localStorage.getItem("edit_title")){
			alert("Please click on issue link on the same row which you have selected.");
			return;
		}
		
		var msg = "The book '"+ localStorage.getItem("edit_title") +"' will be issued to you for 14 days. Your due date is " + duedate
			+ ". Press OK to issue book.";
		var ans = confirm(msg);
		if(ans == true){
			$('#title').val(localStorage.getItem("edit_title"));
			var data = owner + ";" + issue_date + ";" + duedate + ";" + $.cookie("logged_user");
			$('#data').val(data);
			$('#mode').val("issue");
			console.log(data);
			document.forms["BookDetailServlet"].submit();
			alert("Your book has been issued successfully.");
		}
		else{
			return;
		}
	}
	else{
		alert("Please select some book to issue.");
	}
}