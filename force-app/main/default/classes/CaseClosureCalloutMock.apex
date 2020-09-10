@isTest
global class CaseClosureCalloutMock implements HttpCalloutMock{
// Implement this interface method
    global HTTPResponse respond(HTTPRequest request){
     HttpResponse response = new HttpResponse();   
     String responseBody = '{"sucess":true,"secretKey":"cfc5792c-b51f-415e-a034-8dae1481035f"}';   
     response.setHeader('Content-Type', 'application/json');
     response.setBody(responseBody);
     response.setStatusCode(200);
     return response;     
    }
}