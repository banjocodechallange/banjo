/*
 * DTO class for contact list
 */ 
global without sharing class ContactsDTO {
    
    global List<Contact> contacts;
    
    public static ContactsDTO parse(String json) {
		return (ContactsDTO) System.JSON.deserialize(json, ContactsDTO.class);
	} 
    
    global without sharing class Contact {
        public String firstName;
        public String lastName;
        public String mobilePhone;
        public String email; // Required
        public String birthDate;
        public String street;
        public String city;
        public String state;
        public String country;
        public String errorMessage;
        public String status; //Indicate the status of the record in salesforce
    }
}