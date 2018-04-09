package packagename.boundary;

import javax.ejb.Stateless;

@Stateless
public class HelloService {
    public String hello() {
        return "hello @" + System.currentTimeMillis();
    }
    
}