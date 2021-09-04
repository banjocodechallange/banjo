/*
 * Contact object trigger handler
 */
public class ContactTriggerHandler {
    
    /*
     * auto submit approval process
     * paramter 
     * 	cnts : List of contacts needed for approval
     */
    public static void autoSubmitContact(List<Contact> cnts) {
        for(Contact cnt : cnts) {
            if(!cnt.Active__c) {
                System.debug('---------> Submit approval process');
                Approval.ProcessSubmitRequest req =  new Approval.ProcessSubmitRequest();
                req.setObjectId(cnt.id);
                req.setComments('New contact created. Please review and approve');
                Approval.ProcessResult res = Approval.process(req);
            }
        } 
    }
    
    /*
     * Find the list of contacts needed count recalculation based on active flag
     * paramter 
     * 	oldCntMap : Map of old context contacts
     * 	newCntMap : Map of new context contacts 
     */
    public static List<Contact> updateRequestedContactListBasedOnActiveFlag(Map<id, Contact> oldCntMap, Map<id, Contact> newCntMap) {
        List<Contact> cnts = new List<Contact>();
        for(Id cntId : oldCntMap.keySet()) {
            Contact oldCnt = oldCntMap.get(cntId);
            Contact newCnt = newCntMap.get(cntId);
            if(oldCnt.Active__c != newCnt.Active__c) {
               cnts.add(newCnt);
            }
        }
        return cnts;
    }
    
    /*
     * Find the correct contact count based on account details and active flag on contact. Then update the account
     * This is in used for delete and update context as well as handled bulk records.
     * paramter 
     * 	oldCntMap : Map of old context contacts
     * 	newCntMap : Map of new context contacts 
     */
    public static void updateContactCountOnAccountOnUpdate(List<Contact> cnts) {
        System.debug('---------> In updateContactCountOnAccountOnUpdate');
        if(cnts.size() == 0) { // No records to handle
            System.debug('---------> No need for update');
            return;
        }
        System.debug('---------> In update flag process');
        Map<ID, ID> accMap = new Map<ID, ID>(); // Map is easy to work as its easy to get element wiothout for loop
        List<Account> updatedAccList = new List<Account>();
        for(Contact cnt : cnts) {
            if(cnt.AccountId != null) { // to void the contacts that has no account linked
                accMap.put(cnt.AccountId, cnt.AccountId);
            }
        }
        
        if(!accMap.isEmpty()) { // Only continue if there are accounts in the list
            System.debug('---------> In update account process');
            // Find number of active contacts based on accounts. This way the count is always correct and no need manual +/-
            AggregateResult[] aggResults = [SELECT AccountId, count(id) 
                                            FROM contact 
                                            WHERE AccountId IN :accMap.keySet() 
                                                AND active__c = true 
                                            GROUP BY AccountId];
            for (AggregateResult agg : aggResults)  {
                String accID = String.valueOf(agg.get('AccountId'));
                Integer totalActiveContacts = Integer.valueOf(agg.get('expr0'));
                Account updateAcc = new Account(id = accID, total_contacts__c = totalActiveContacts);
                updatedAccList.add(updateAcc);
                accMap.remove(accID);
            }
            
            // There may be accounts that has no contacts(after delete all active contacts).
            // This logic will set those to 0
            for(ID noContactAccId : accMap.keySet()) {
                Account noContactAcc = new Account(id = noContactAccId, total_contacts__c = 0);
                updatedAccList.add(noContactAcc);
            }
            
            update updatedAccList;
        }
    }
}