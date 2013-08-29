package com.google.bookclub;

import java.util.ArrayList;
import java.util.List;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;

public class BookDAO {
	@SuppressWarnings("deprecation")
	public static List<Entity> getAllAvailableBooks(){
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq;
		
		Query issueQuery = new Query("Issue").addFilter("status", FilterOperator.EQUAL, "issued");
		pq = datastore.prepare(issueQuery);
		List<Entity> issueList = pq.asList(FetchOptions.Builder.withDefaults());
		
		Query bookQuery = new Query("Book");
		pq = datastore.prepare(bookQuery);
		List<Entity> bookList = pq.asList(FetchOptions.Builder.withDefaults());
		
		List<Entity> iterList = new ArrayList<Entity>();
		
		for(Entity book : bookList){
			String t1 = book.getProperty("title").toString();
			int flag = 0;
			for(Entity issue : issueList){
				String t2 = issue.getProperty("title").toString();
				if(t1.equals(t2)){
					flag = 1;
					break;
				}
			}
			if(flag == 0){
				iterList.add(book);
			}
		}
		return iterList;
	}
	
	@SuppressWarnings("deprecation")
	public static List<Entity> getAllIssuedBooks(){
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq;
		
		Query issueQuery = new Query("Issue").addFilter("status", FilterOperator.EQUAL, "issued");
		pq = datastore.prepare(issueQuery);
		List<Entity> issueList = pq.asList(FetchOptions.Builder.withDefaults());
		
		Query bookQuery = new Query("Book");
		pq = datastore.prepare(bookQuery);
		List<Entity> bookList = pq.asList(FetchOptions.Builder.withDefaults());
		
		List<Entity> iterList = new ArrayList<Entity>();
		
		for(Entity book : bookList){
			String t1 = book.getProperty("title").toString();
			for(Entity issue : issueList){
				String t2 = issue.getProperty("title").toString();
				if(t1.equals(t2)){
					iterList.add(book);
					break;
				}
			}
		}
		return iterList;
	}
}
