/*
 * Contact object trigger
 */
trigger ContactTrigger on Contact (after insert, after update, after delete) {
    
    if(trigger.isInsert) {
        System.debug('---------> In insert trigger');
        ContactTriggerHandler.autoSubmitContact(Trigger.new); //Auto submit approval flow handler
    }
    
    if(trigger.isUpdate) {
        System.debug('---------> In update trigger');
        //Find the list that changed the active flag on update traction
        List<Contact> activeFlagChangedCntList = ContactTriggerHandler.updateRequestedContactListBasedOnActiveFlag(Trigger.oldMap, Trigger.newMap);
        //Execute update count method for required contacts only
        ContactTriggerHandler.updateContactCountOnAccountOnUpdate(activeFlagChangedCntList);
    }
    
    if(trigger.isDelete) {
        System.debug('---------> In delete trigger');
        //Execute update count method for deleted contacts
        ContactTriggerHandler.updateContactCountOnAccountOnUpdate(Trigger.old);
    }

}