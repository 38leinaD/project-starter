package packagename.boundary;

import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Stateless
@Path("hello")
public class HelloResource {

	@Inject
	HelloService service;

	@GET
	public String test() {
		return service.hello();
	}
}
