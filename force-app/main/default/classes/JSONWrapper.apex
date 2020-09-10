public class JSONWrapper {
  public String success;
  public String  secretKey;
  public String  error;
    
  public static JSONWrapper parse(String json) {
        return (JSONWrapper) System.JSON.deserialize(json, JSONWrapper.class);
    } 
}