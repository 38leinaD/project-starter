package packagename.boundary;

import javax.ejb.Stateless;

@Stateless
public class Service {
    public String hello() {
        return "hello world";
    }
    
}