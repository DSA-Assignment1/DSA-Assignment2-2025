
import ballerinax/kafka;
import ballerina/http;

service /ticketingSystem/notification on new http:Listener(9090){
    private final kafka:Producer trips_producer;

    function init() returns error? {
        self.trips_producer = check new(kafka:DEFAULT_URL);
    }


}
