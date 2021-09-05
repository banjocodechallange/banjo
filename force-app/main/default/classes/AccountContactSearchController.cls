public with sharing class AccountContactSearchController {

    @AuraEnabled(cacheable=true)
    public static List<SerachResult> searchData(String keyword) {
        List<SerachResult> results = new List<SerachResult>();
        
        List<List<SObject>> searchResults =  [FIND :keyword IN ALL FIELDS RETURNING Contact(Name, ID), Account(Name, ID) ];
        List<Contact> cntList = (Contact[])searchResults[0];
        for(Contact cnt : cntList) { 
            results.add(new SerachResult(cnt.name, 'Contact', '/' + cnt.id));
        }
        List<Account> accList = (Account[])searchResults[1];
        for(Account acc : accList) {
            results.add(new SerachResult(acc.name, 'Account', '/' + acc.id));
        }
        System.debug('-----> results ' + results);
        return results;
    }
}