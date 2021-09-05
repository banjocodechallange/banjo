public class ContactService {
    
    //Process provided contacts into SF
    public static ContactsDTO processContacts(ContactsDTO cntList) {
        Map<String, ContactsDTO.Contact> cnts = new Map<String, ContactsDTO.Contact>();
        Map<String, String> exsitngContactEmails = new Map<String, String>();
        Boolean isValid = true;
        for(ContactsDTO.Contact cnt : cntList.contacts) {
            if(String.isEmpty(cnt.email)) { //Email mandatory validation
                cnt.errorMessage = 'missing mandatory field. email';
                cnt.status = 'error';
            } else {
                cnts.put(cnt.email, cnt); //Has valid email
            }
        }
        
        if(cnts.size() > 0) {
            System.debug('=======> cnts.size()  ' + cnts.size() );
            List<Contact> contactList = [SELECT id, firstName, lastname, email, mobilePhone, birthDate //Only consider these fields for now
                                         FROM contact 
                                         WHERE email IN : cnts.keySet()];
            for(Contact cnt : contactList) { // List of contacts in SF with email. Assume email address is unique
                exsitngContactEmails.put(cnt.email, cnt.email);
                ContactsDTO.Contact extCnt = cnts.get(cnt.email);
                // Fields to update in SF
                try {
                    System.debug('=======> Try');
                    if(!String.isEmpty(extCnt.mobilePhone)) {
                    	cnt.mobilePhone = extCnt.mobilePhone;
                    }
                    if(!String.isEmpty(extCnt.birthDate)) {
                    	cnt.birthDate = Date.valueOf(extCnt.birthDate);
                    }
                    if(!String.isEmpty(extCnt.firstName)) {
                    	cnt.firstName = extCnt.firstName;
                    }
                    if(!String.isEmpty(extCnt.lastName)) {
                    	cnt.lastName = extCnt.lastName;
                    }
                    extCnt.status = 'success'; //Set record as error with response
                } catch(Exception e) { // Any data format error will capture here. If need can do each field validation based on detail requirements 
                    System.debug('=======> EEEEEE' + e.getStackTraceString());
                    extCnt.errorMessage = 'Invalid data provided for contact fields.'; 
                    extCnt.status = 'error'; //Set record as error with response
                }  
            }
            System.debug('=======> contactList  ' + contactList );
            update contactList;
            
            for(ContactsDTO.Contact cnt : cntList.contacts) {
                if(!String.isEmpty(cnt.email) && !exsitngContactEmails.containsKey(cnt.email)) {
                    cnt.errorMessage = 'Cannot update contact. Contact not found';
                    cnt.status = 'error'; //Set record as error with response
                }
            }
        }
        
        return cntList;
    }

}