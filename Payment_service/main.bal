import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

type payments record {
    int id;
    int user_id;
    int ticket_id;
    float amount;
    string provider_ref;
    string status;
    string processed_at;
};

service /ticketingSystem/payments on new http:Listener(9090){
    private final mysql:Client db_client;


    function init() returns error? {
        self.db_client = check new ("localhost", "root", "Kalitheni@11", "logistics_db",3306);
    }

    resource function put payement(payments req) returns string|error? {
        sql:ParameterizedQuery insertQuery = `INSERT INTO payments (user_id, ticket_id, amount, provider_ref, status, processed_at) VALUES (${req.user_id}, ${req.ticket_id}, ${req.amount}, ${req.provider_ref}, ${req.status}, ${req.processed_at})`;
        sql:ExecutionResult|sql:Error result = check self.db_client->execute(insertQuery);
        if result is sql:ExecutionResult {
            return "Payment processed successfully";
        } else {
            return error("Failed to process payment: " + result.message());
        }
    }
    
}