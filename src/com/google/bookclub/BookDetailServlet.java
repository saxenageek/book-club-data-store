package com.google.bookclub;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;

public class BookDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String mode = req.getParameter("mode");
		String title = req.getParameter("title");
		Entity bookEntity;
		Entity issueEntity;
		List<Entity> bulkadd = new ArrayList<Entity>();
		List<Key> bulkdel = new ArrayList<Key>();
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    
		if(mode.equals("issue")){
			String data = req.getParameter("data");
			String[] temp = data.split(";");
			String owner = temp[0];
			String issuedate = temp[1];
			String duedate = temp[2];
			String issuedby = temp[3];
			issueEntity = new Entity("Issue", title);
			issueEntity.setProperty("title", title);
			issueEntity.setProperty("issuedby", issuedby);
			issueEntity.setProperty("owner", owner);
			issueEntity.setProperty("status", "issued");
			issueEntity.setProperty("issuedate", issuedate);
			issueEntity.setProperty("duedate", duedate);
			issueEntity.setProperty("returndate", "");
			datastore.put(issueEntity);	
		}
		//saving book data as a single entity in datastore
		if(mode.equals("new") || mode.equals("update")){ 
			bookEntity = new Entity("Book", title);
			String author = req.getParameter("edit_author");
			String genre = req.getParameter("edit_genre");
			String year = req.getParameter("edit_year");
			String owner = req.getParameter("edit_owner");
			bookEntity.setProperty("title", title);
			bookEntity.setProperty("author", author);
			bookEntity.setProperty("genre", genre);
			bookEntity.setProperty("year", year);
			bookEntity.setProperty("owner", owner);
			bookEntity.setProperty("qty", 1);
			datastore.put(bookEntity);	
		}
		if(mode.equals("delete")){
			bookEntity = new Entity("Book", title);
			datastore.delete(bookEntity.getKey());
		}
		if(mode.equals("deleteall")){
			Query gaeQuery = new Query("Book");
			PreparedQuery pq = datastore.prepare(gaeQuery);
			List<Entity> list = pq.asList(FetchOptions.Builder.withDefaults());
			for(Entity item : list){
				bulkdel.add(item.getKey());
			}
			datastore.delete(bulkdel);
		}
		if(mode.equals("addbulk")){
			String data = req.getParameter("data");
			String[] temp = data.split(",");
			for(String item : temp){
				String[] row = item.split("\t");
				bookEntity = new Entity("Book", row[0]);
				bookEntity.setProperty("title", row[0]);
				bookEntity.setProperty("author", row[1]);
				bookEntity.setProperty("genre", row[2]);
				bookEntity.setProperty("year", row[3]);
				bookEntity.setProperty("owner", row[4]);
				bookEntity.setProperty("qty", 1);
				bulkadd.add(bookEntity);	
			}
			datastore.put(bulkadd);
		}
		resp.sendRedirect("books.jsp");
	}
}