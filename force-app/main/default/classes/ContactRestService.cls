@RestResource(urlMapping='/contacts/*')
/*
 * RESTFul resource service
 */
global with sharing class ContactRestService {
    
    
    //This will update contacts have valid date and pouplate error message if its invalid
    @HttpPut //As we need update existing contacts. 
    global static String updateContacts(String contactList) {
        System.debug('------> contactList ' + contactList);
        ContactsDTO conntacts;
        try {
        	conntacts = ContactsDTO.parse(contactList);
            ContactService.processContacts(conntacts);
        } catch(Exception e) {
            System.debug('-------' +  e.getStackTraceString());
        }
        //Return the contacts with updated status and errorMessage
        return JSON.serialize(conntacts);
    }
}