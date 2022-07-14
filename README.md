# Tomcat and Angular Deeplinks

For single-page webapps, there is only one 'page': `/yourapp/index.html`.
Frameworks like Angular can rewrite the URL in the browser to appear to the user
that there are multiple pages, like `/yourapp/profiles/john.doe/groups`.

The problem is that if someone were to copy/paste the above link into their browser
or refresh the page, the browser will actually request `/yourapp/profiles/john.doe/groups`
from the server, which doesn't exist. You would then get a 404 error page

## Solutions

- Using a `WEB-INF/web.xml` file (found in this project), you could tell the server
to send your app as the custom 404 page with the below. You can use this kind of
configuration to create nicer custom error pages for anything (400, 404, 500, etc.)

    ```xml
    <!-- WEB-INF/web.xml -->
    <error-page>
        <error-code>404</error-code>
        <location>/index.html</location>
    </error-page>
    ```

    The `/` in the `location` element is important. It specifies the root of your webapp, not
    a relative link from the URL the user requested. This solution works well in
    browsers

    Now if you were to open `/yourapp/profiles/john.doe/groups`, you would
    see your Angular app loading correctly (assuming you have the right `<base href="/yourapp/">`)
    in your `index.html` file. If you opened your Network tab in Developer Tools, though,
    you'd see that the server is still sending a 404 status. Applications like Microsoft
    Office, when opening links, will complain that your page doesn't exist as a result

- The "full" solution (short of implementing a WAR file with some Java code to handle `/yourapp/*`)
is to use a JSP file as your error page, like this:

    ```xml
    <!-- /WEB-INF/web.xml -->
    <error-page>
        <error-code>404</error-code>
        <location>/my404.jsp</location>
    </error-page>
    ```

    This JSP file allows you to call some code to set the status of your HTTP request to 200
    instead of 404:

    ```java
    <%-- /my404.jsp --%>
    <%@ include file="index.html" %>
    <% response.setStatus(200); %>
    ```

    Now, when someone refreshes your page or clicks a link from their browser or any
    other application, they will get the Angular app with a status of 200, as if the
    page existed on the server

