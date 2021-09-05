global class SerachResult {
    
    public SerachResult(){}
    
    public SerachResult(string namePara, String objectTypePara, String objectIdPara) {
        this.name = namePara;
        this.objectType = objectTypePara;
        this.objectId = objectIdPara;
    }
    
    @AuraEnabled
    public string name{ get; set; }
    @AuraEnabled
    public String objectType{ get; set; }
    @AuraEnabled
    public String objectId{ get; set; }
}