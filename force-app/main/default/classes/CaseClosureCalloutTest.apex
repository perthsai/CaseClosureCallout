@isTest
global class CaseClosureCalloutTest  {
   @testSetup static void createMyData () {
     List<Case> MyCaseList = new List<Case>();    
 // create test data
        // create 200 cases
    for (integer cnt = 0; cnt<20; cnt++)
    {
      Case myNewCase =TestUtility.createCase('Closed');
      MyCaseList.add(myNewCase);
     }
     insert MyCaseList;
     System.debug('The number of Cases'+MyCaseList.size());    
    List<Case> CaseList =[select id from Case ];
    Set<Id> CaseIds = (new Map<Id,Case>(CaseList)).keySet();
    System.debug('The total case id is ' + CaseIds.size()); 
  }     
  
   @isTest static void testPostCallout() {
     Map<ID, Case> caseMap = new Map<ID, Case>([SELECT Id, OwnerId FROM Case LIMIT 10]);
     CaseClosureCallOut.caseClosureStatus(caseMap);
     // Set mock callout class
    String expectedValue = '{"sucess":true,"secretKey":"cfc5792c-b51f-415e-a034-8dae1481035f"}';
    Test.setMock(HttpCalloutMock.class, new CaseClosureCalloutMock());  
    HttpResponse response=CaseClosureCallOut.sendNotificationWithoutFuture();
    System.debug(response.getBody()); 
   
 }  
    
}