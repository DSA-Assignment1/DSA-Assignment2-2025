import ballerina/http;
import ballerina/io;
type registerRequest record {
    string username;
    string email;
    string password;
    string userRole;
};

type loginRequest record {
    string username;
    string password;
};


http:Client url = check new("http://localhost:9090/ticketingSystem");


public function main() returns error?{
    string username1 = io:readln("enter username");
    string password1 = io:readln("password");
    string email1 = io:readln("email");
    

    registerRequest req = {
        username:username1,
        password:password1,
        email:email1,
        userRole: "passenger"
    };
     
    string response = check url->post("/registerPassenger", req);
    io:println(response);
}