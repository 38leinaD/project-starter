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
		return "Hello @ " + System.currentTimeMillis();
	}
}
