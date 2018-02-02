package packagename;

import java.lang.System.Logger.Level;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;
import org.junit.Test;

public class AppTest {
    
    @Test
    public void testApp() {
        assertThat(true, is(true));     
    }
}