public class CaseClosureCallOut {
 public static Boolean RunOnce = false; // Boolean runonce is avoid recursive loop
  public static void caseClosureStatus(Map<Id,Case> caseNewMap){  //This method is called from Trigger after update event  when the status of Case update to 'Closure'
    if(!caseNewMap.keySet().isEmpty()){
      sendNotification(caseNewMap.keySet()); //Call future method for call out 
    } 
  }
  
 @future(callout=true)
   public static void sendNotification(Set<Id> caseIds){
   List<Case> caselist = [Select Id,Status,OwnerId,secretKey__c from Case where Id IN :caseIds LIMIT 20]; //SOQL is collect the Id and Ownerid(Case closure Id) to POST in external URL
   HttpRequest req = new HttpRequest();
   HttpResponse res = new HttpResponse();
   Http http = new Http();   
   //For loop to se    
    for(Case casegroup:caselist){
     if(String.isBlank(casegroup.secretKey__c)){  
      req.setEndpoint('https://nfapihub.herokuapp.com/');  //BestPractics to use is ('callout:herokuapp') from custome setting but for quick code i incorporated the url 
      req.setMethod('POST');
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');  
      req.setBody('{"id":caselist.Id, "agentid":caselist.OwnerId}');
      system.debug(' Body value ' +req );    
      req.setCompressed(true); // otherwise we hit a limit of 32000 lenght of URL
       try {
         res = http.send(req);
          if(res.getStatusCode() == 200) {
            System.debug(res.getBody()); 
            JSONWrapper wrapper=JSONWrapper.parse(res.getBody()); //Parse the responsbody to get seceretKey return from API 
            system.debug('wrapper : '+ wrapper.secretKey);
            casegroup.secretKey__c=wrapper.secretKey; 
            
            }
            else if(res.getStatusCode() == 500){
            System.debug(res.getBody());   
          }
         }
         catch(System.CalloutException e) {
         System.debug('Callout error: '+ e);
         System.debug(res.toString());
      }
    }
   
   }        
  } 
    
    

 //To Code Coverage without future    
 public static HttpResponse sendNotificationWithoutFuture(){
   System.debug('Inside Future call');
   HttpRequest req = new HttpRequest();
   HttpResponse res = new HttpResponse();
   Http http = new Http();  
   List<Case> CaseStatus = [Select Id,Status,OwnerId from Case LIMIT 1];
   for (Case casupdated :CaseStatus){
    Id id=casupdated.Id;
    String agentid =casupdated.OwnerId; 
    System.debug('The id and agent values are ' + id + ' ' + agentid);
    req.setEndpoint('https://nfapihub.herokuapp.com/');  //BestPractics is callout:herokuapp') for quick code i incorporated the url 
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');  
    req.setBody('{"id":id, "agentid":agentid}');
    system.debug(' Body value ' +req );    
    req.setCompressed(true); // otherwise we hit a limit of 32000  
    try {
        res = http.send(req);
        if(res.getStatusCode() == 200) {
          System.debug(res.getBody());
          
        }
        else if(res.getStatusCode() == 500){
          System.debug(res.getBody());   
        }
      } catch(System.CalloutException e) {
        System.debug('Callout error: '+ e);
        System.debug(res.toString());
    } 
   } 
   return res; 
  }
}