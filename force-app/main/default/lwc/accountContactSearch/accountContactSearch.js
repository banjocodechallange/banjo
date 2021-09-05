import {LightningElement, wire} from 'lwc';
import searchData from '@salesforce/apex/AccountContactSearchController.searchData';

const columns = [
    { label: 'Record Name', fieldName: 'name', type: 'text' },    
    { label: 'Record Type', fieldName: 'objectType', type: 'text' },
    { label: 'Click to open', fieldName: 'objectId' , type: 'url', target: '_blank',typeAttributes: {
        label: 'View',
        target : '_blank'
    }},
];

export default class CategoryProductAssociation extends LightningElement {
    accCnt = [];
    columns = columns;
    searchKey;
    showResults = false;
    categoryID;

    searchData(){
        searchData({keyword: this.searchKey})
            .then(result => {
                this.accCnt = result;
                console.log('Results 0'+JSON.stringify(result));                
                if(result.length > 0) {
                    this.showResults = true;
                } else{
                    this.showResults = false;
                }
            })
            .catch(error => {
            });
    }

    handleKeyChange(event){
        this.searchKey = event.target.value;
    }
}