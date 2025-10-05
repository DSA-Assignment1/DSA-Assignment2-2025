import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerinax/kafka;
import ballerina/io;

enum ticketState {
    CREATED,
    PAID,
    VALIDATED,
    EXPIRED
};

enum ticketType {
    single,
    multi,
    pass
}

type tickets record {
    int id;
    string ticket_code;
    int user_id;
    int trip_id;
    string ticket_type;
    float price;
    string state;
    string createdAt;
    string expires_at;
};

type ticketRequest record {
    int user_id;
    int trip_id;
    string ticket_type;
    float price;
};


listener kafka:Listener ticket_listener = new(kafka:DEFAULT_URL, {
    groupId: "ticket_service_group",
    topics: "ticket.requested"
});

service on ticket_listener {
    private final mysql:Client db_client;
    
    function init() returns error? {
        self.db_client = check new ("127.0.0.1", "root", "password", "smart_ticketing",3306);
        
    }
    remote function onConsumerRecord(tickets[] requestedTickets) returns error? {
        foreach var req in requestedTickets {
            io:println(`New ticket request received for user ID: " + ${req.user_id}` );
        }
        
      
    }
}