package packagename.boundary;

import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Stateless
@Path("hello")
public class HelloResource {

	@Inject
	Service s;

	@GET
	public String test() {
		System.out.println("Hello World1233433333333333335634321!");
		System.out.println("Hello WORLKD2");
		System.out.println("HELLO OOOOO");
		return "Hello @ " + System.currentTimeMillis();
	}
}
