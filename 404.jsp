<%--
    The include directive sends the contents of our Angular
    app to the client, but because this a JSP file we can also
    send a 200 response instead of the default 404, allowing
    deep-linking for Angular and clicking links in MSWord
--%>
<%@ include file="index.html" %>
<% response.setStatus(200); %>
