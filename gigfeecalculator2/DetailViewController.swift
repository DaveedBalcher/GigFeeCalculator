//
//  DetailViewController.swift
//  GigFeeCalculator2
//
//  Created by David Balcher on 12/27/14.
//  Copyright (c) 2014 David Balcher. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    //Numeric input text fields for calculations
    @IBOutlet weak var serviceLengthField: UITextField!
    @IBOutlet weak var numMusiciansField: UITextField!
    @IBOutlet weak var travelTimeField: UITextField!
    @IBOutlet weak var travelDistanceField: UITextField!
    @IBOutlet weak var numGuestsField: UITextField!
    
    //Text fields for proposel write-up
    @IBOutlet weak var hostNameField: UITextField!
    @IBOutlet weak var eventTypeField: UITextField!
    @IBOutlet weak var eventDateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var venueField: UITextField!
    @IBOutlet weak var bandField: UITextField!

    @IBOutlet weak var subEventController: UISegmentedControl!
    
    var subEvent:Int = 0
    var currentEvent:Event?
    var previousText = ""
    var textFieldCounter = 0
    var allTextFields = [UITextField]()
    var arrayOfEventDetails = [String]()
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true) //When
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentEvent = allEvents[currentEventIndex]
        
        allTextFields = [serviceLengthField, numMusiciansField, travelTimeField, travelDistanceField, numGuestsField, hostNameField, eventTypeField, eventDateField, cityField, venueField, bandField]
     
        arrayOfEventDetails = currentEvent!.createArrayOfEventDetails(subEvent)
        updateTextFields()
        
        hostNameField.delegate = self
        eventTypeField.delegate = self
        eventDateField.delegate = self
        numGuestsField.delegate = self
        cityField.delegate = self
        venueField.delegate = self
        travelTimeField.delegate = self
        travelDistanceField.delegate = self
        bandField.delegate = self
        serviceLengthField.delegate = self
        numMusiciansField.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        Event.saveEvents()
        eventTable?.reloadData()
    }
    
    
    //This function loads details from a saved event
    func updateTextFields() {
        for var detail = 0; detail < allTextFields.count; detail++ {
            let thisDetail = arrayOfEventDetails[detail]
            let firstChar = advance(thisDetail.startIndex, 0)
            if (thisDetail != "" && thisDetail[firstChar] != "0"){
                allTextFields[detail].text = arrayOfEventDetails[detail]
            }
        }
    }
    
    @IBAction func eventTypeDidChange(sender: AnyObject) {
        subEvent = subEventController.selectedSegmentIndex
        resetSubEventFields()
    }
    
    func resetSubEventFields() {
        if (currentEvent!.serviceLength[subEvent] == 0) {
            serviceLengthField.text = "Service Length"
        } else {
            serviceLengthField.text = "\(currentEvent!.serviceLength[subEvent]) service hours"
        }
        if (currentEvent!.numMusicians[subEvent] == 0) {
            numMusiciansField.text = "# of Musicians"
        } else {
            numMusiciansField.text = "\(currentEvent!.numMusicians[subEvent]) musicians"
        }
    }
    
    
     
    //Custom functionality for text fields
    func textFieldDidBeginEditing(textField: UITextField!) ->  Bool {
        //delegate method
        previousText = textField.text
        textField.text = ""
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) -> Bool {
        //delegate method
        var isNumeric = false
        if (textField.text.toDouble() != nil) {
            isNumeric = true
            switch (textField) {
            case (serviceLengthField):
                currentEvent!.serviceLength[subEvent] = serviceLengthField.text.toDouble()!
                serviceLengthField.text = "\(currentEvent!.serviceLength[subEvent]) service hours"
            case (numMusiciansField):
                currentEvent!.numMusicians[subEvent] = numMusiciansField.text.toInt()!
                numMusiciansField.text = "\(currentEvent!.numMusicians[subEvent]) musicians"
            case (travelTimeField):
                currentEvent!.travelTime = travelTimeField.text.toDouble()!
                travelTimeField.text = "\(currentEvent!.travelTime) travel hours"
            case (travelDistanceField):
                currentEvent!.milage = travelDistanceField.text.toDouble()!
                travelDistanceField.text = "\(currentEvent!.milage) travel miles"
            case (numGuestsField):
                currentEvent!.numGuests = numGuestsField.text.toInt()!
                numGuestsField.text = "\(currentEvent!.numGuests) guests"
            default:
                println("error1")
            }
        }
        
        if (!isNumeric) {
            switch (textField) {
            case (hostNameField):
                currentEvent!.hostName = textField.text
            case (eventTypeField):
                currentEvent!.eventType = textField.text
            case (eventDateField):
                currentEvent!.eventDate = textField.text
            case (cityField):
                currentEvent!.city = textField.text
            case (venueField):
                currentEvent!.venue = textField.text
            case (bandField):
                currentEvent!.band[subEvent] = textField.text
            default:
                println("error2")
            }
        }
        
        //If the user does not enter text, the field will revert to the previous text label
        if (textField.text == "") {
            textField.text = previousText
        }
        
        allEvents[currentEventIndex] = currentEvent!
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        //delegate method
        textField.resignFirstResponder()
        return true
    }

//    // MARK: - Segues
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var thirdScene = segue.destinationViewController as ResultsViewController
//        // Pass the selected object to the new view controller.
//        thirdScene.currentEvent = currentEvent
//        
////        var firstScene = segue.destinationViewController as MasterViewController
////        // Pass the selected object to the new view controller.
////        firstScene.events = events
//        
//    }



}


extension String {
    //allows for a String to be converted to a Double
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    
    //get nth charactor of a String
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    subscript (r: Range<Int>) -> String {
        var start = advance(startIndex, r.startIndex)
        var end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }
}

