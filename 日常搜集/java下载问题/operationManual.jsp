<%@ page import="org.apache.axis.attachments.MimeUtils" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@page language="java" contentType="application/x-msdownload" pageEncoding="utf-8" %>
<%

    BufferedInputStream bis = null;
    BufferedOutputStream bos = null;

    String filePath = pageContext.getServletContext().getRealPath("resources/documentation/") + "操作手册.chm";
    String fileName = "操作手册.chm";

    bis = new BufferedInputStream(new FileInputStream(filePath));
    bos = new BufferedOutputStream(response.getOutputStream());

    long fileLength = new File(filePath).length();

    response.setCharacterEncoding("UTF-8");
    response.setContentType("multipart/form-data");
    /*
     * 解决各浏览器的中文乱码问题
     */
    String userAgent = request.getHeader("User-Agent"); //获取浏览器标识
    if (userAgent.contains("MSIE") || userAgent.contains("Trident")) {
        // IE
        fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
    } else {
        // Chrome
        byte[] bytes = userAgent.contains("MSIE") ? fileName.getBytes() : fileName.getBytes("UTF-8"); // fileName.getBytes("UTF-8")处理safari的乱码问题
        fileName = new String(bytes, "ISO-8859-1"); // 各浏览器基本都支持ISO编码
    }
    response.setHeader("Content-disposition", String.format("attachment; filename=\"%s\"", fileName));

    response.setHeader("Content-Length", String.valueOf(fileLength));
    byte[] buff = new byte[2048];
    int bytesRead;
    while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
        bos.write(buff, 0, bytesRead);
    }
    bis.close();
    bos.close();

%>