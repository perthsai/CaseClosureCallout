public class TestUtility {
    // generic account where name is specified: Record type is the default
    public static Case createCase(String Status)
    {        
        Case Cas = new Case();
       // Set Initial default values: Case Field values that are 
        Cas.Status = Status;
        Cas.Subject='Testing Case';
        Cas.OwnerId= UserInfo.getUserId();
        Cas.Origin='Phone';
        
        return Cas; 
    }
}