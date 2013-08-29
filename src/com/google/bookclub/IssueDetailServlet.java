package com.google.bookclub;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.KeyFactory;

public class IssueDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String mode = req.getParameter("mode");
		String title = req.getParameter("title");
		Entity returnEntity;
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		if(mode.equals("return")){
			SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yyyy");
			Date date = new Date();
			try {
				returnEntity = datastore.get(KeyFactory.createKey("Issue", title));
				returnEntity.setProperty("title", title);
				returnEntity.setProperty("status", "returned");
				returnEntity.setProperty("returndate", dt.format(date));
				datastore.put(returnEntity);	
			} catch (EntityNotFoundException e) {
				e.printStackTrace();
			}
		}
		resp.sendRedirect("index.jsp");
	}
}
