# System-tests for RESTful Web Services

This project contains a template for writing system-test for RESTful Web Services.
Systems-tests are run a docker-environment, defined via docker-compose.

## Usage

TODO

## Apache Bench

    ab -n 1000 -c 5 http://localhost/appname/resources/health
   
## JMeter

    jmeter -n -t stress.jmx