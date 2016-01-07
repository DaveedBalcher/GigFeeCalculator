//
//  ViewController.swift
//  GigFeeCalculator1
//
//  Created by David Balcher on 12/12/14.
//  Copyright (c) 2014 David Balcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var bandNameField: UITextField!
    @IBOutlet weak var bandManagerField: UITextField!
    @IBOutlet weak var bandTypeField: UITextField!
    @IBOutlet weak var performanceLinkField: UITextField!
    
    //Selectors for subevents
    @IBOutlet weak var ceremonyButton: UIButton!
    @IBOutlet weak var cocktailButton: UIButton!
    @IBOutlet weak var receptionButton: UIButton!
    
    //Labels to display calculations
    @IBOutlet weak var ceremonyRateLabel: UILabel!
    @IBOutlet weak var cocktailRateLabel: UILabel!
    @IBOutlet weak var receptionRateLabel: UILabel!
    @IBOutlet weak var eventRateLabel: UILabel!
    @IBOutlet weak var travelCostLabel: UILabel!
    @IBOutlet weak var eventTravelCostLabel: UILabel!
    @IBOutlet weak var depositCostLabel: UILabel!

    @IBOutlet weak var clipboardButton: UIButton!
    
    //Numeric input for calculations
    var serviceLength = [0.0,0.0,0.0,0.0]
    var numMusicians = [0,0,0,0]
    var travelTime = 0.0
    var milage = 0.0
    var numGuests = 0
    var subEvent = 0
    var textFieldCounter = 0
    var previousText = ""
    
    //Text input for proposel write-up
    var hostName = "______"
    var eventType = "______"
    var eventDate = "__/__/__"
    var city = "______"
    var venue = "______"
    var bandName = "______"
    var bandManager = "______"
    var bandType = ["______","______","______","______"]
    var performanceLink = ["______","______","______","______"]


    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true) //When 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hostNameField.delegate = self
        eventTypeField.delegate = self
        eventDateField.delegate = self
        numGuestsField.delegate = self
        cityField.delegate = self
        venueField.delegate = self
        travelTimeField.delegate = self
        travelDistanceField.delegate = self
        bandNameField.delegate = self
        bandManagerField.delegate = self
        bandTypeField.delegate = self
        serviceLengthField.delegate = self
        numMusiciansField.delegate = self
        performanceLinkField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectSubEvent(sender: UIButton) {
        if let subEventButton = sender.titleLabel?.text {
            switch (subEventButton) {
            case ("Ceremony"):
                subEvent = 1
            case ("Cocktail"):
                subEvent = 2
            case ("Reception"):
                subEvent = 3
            default:
                subEvent = 0
            }
            resetSubEventFields()
            setButtonColor()
        }
    }
    
    
    //Sets the button color to red when the sub-event is active
    func setButtonColor() {
        let myRed: UIColor = UIColor(red: 0xde/255, green: 0x53/255, blue: 0x5f/255, alpha: 1.0)
        let myBlue: UIColor = UIColor(red: 0x91/255, green: 0xcb/255, blue: 0xff/255, alpha: 1.0)
        if(subEvent == 1) {
            ceremonyButton.setTitleColor(myRed, forState: UIControlState.Normal)
        } else {
            ceremonyButton.setTitleColor(myBlue, forState: UIControlState.Normal)
        }
        if(subEvent == 2) {
            cocktailButton.setTitleColor(myRed, forState: UIControlState.Normal)
        } else {
            cocktailButton.setTitleColor(myBlue, forState: UIControlState.Normal)
        }
        if(subEvent == 3) {
            receptionButton.setTitleColor(myRed, forState: UIControlState.Normal)
        } else {
            receptionButton.setTitleColor(myBlue, forState: UIControlState.Normal)
        }
    }
    
    
    
    func resetSubEventFields() {
        if (serviceLength[subEvent] == 0) {
            serviceLengthField.text = "Service Length"
        } else {
            serviceLengthField.text = "\(serviceLength[subEvent]) service hours"
        }
        if (numMusicians[subEvent] == 0) {
            numMusiciansField.text = "# of Musicians"
        } else {
            numMusiciansField.text = "\(numMusicians[subEvent]) musicians"
        }
    }

    //Calculates rates for entire event, sub-events, travel and deposit amount
    @IBAction func calculateButton() {
        
        let newEvent = Event(numGuests: numGuests)
        var eventRate = 0
        var travelCost = 0
        if (subEvent == 0) {
            eventRate = newEvent.eventRate(serviceLength[0], numMusicians: numMusicians[0])
            travelCost = newEvent.travelCost(numMusicians[0], milage: milage, travelTime: travelTime)
            
        } else {
            var ceremonyRate = 0
            var cocktailRate = 0
            var receptionRate = 0
            if (serviceLength[1] != 0) {
                ceremonyRate = newEvent.eventRate(serviceLength[1], numMusicians: numMusicians[1])
                ceremonyRateLabel.text = "$\(ceremonyRate).00"
            }
            if (serviceLength[2] != 0) {
                cocktailRate = newEvent.eventRate(serviceLength[2], numMusicians: numMusicians[2])
                cocktailRateLabel.text = "$\(cocktailRate).00"
            }
            if (serviceLength[3] != 0) {
                receptionRate = newEvent.eventRate(serviceLength[3], numMusicians: numMusicians[3])
                receptionRateLabel.text = "$\(receptionRate).00"
            }
            
            eventRate = ceremonyRate + cocktailRate + receptionRate
            
            let greatestNumMusicians = findGreatestNumberMusicians()
            
            travelCost = newEvent.travelCost(greatestNumMusicians, milage: milage, travelTime: travelTime)
            
        }
        eventRateLabel.text = "$\(eventRate).00"
        travelCostLabel.text = "$\(travelCost).00"
        eventTravelCostLabel.text = "$\(eventRate + travelCost).00"
        
        let depositCost = newEvent.depositCost(eventRate)
        depositCostLabel.text = "$\(depositCost).00"
    }

    func findGreatestNumberMusicians() -> Int{
        var greatestNumMusicians = 0
        for var i = 1; i < 4; i++ {
        if (greatestNumMusicians < numMusicians[i]) {
            greatestNumMusicians = numMusicians[i]
            }
        }
        return greatestNumMusicians
    }
    
    @IBAction func writeUpToClipboard() {
        let musicians = findGreatestNumberMusicians()
        let proposalIntro = "Hello \(hostNameField.text!), " + "Thank you for your request! We hope that we can provide your party with an environment enhancing musical accompaniment. "
        
//        let proposalBody:String = "Our cover band is made of up of the finest local musicians. To fit your needs, we’re able to do a variety of genres such as Classic Rock, Pop, Funk and Jazz. Presently, we perform at acclaimed venues (Triumph, National Mechanics), Weddings, Cocktail hours, Fundraisers and Private House events. Check out two Event Horizon cover music videos: "
//        
//        let links:String = performanceLink[1] + " " + performanceLink[2] + " " + performanceLink[3]
//        
//        let proposalConclusion:String = "Our Event Horizon Band consists of: Vocals, Drums, Guitars, Bass, Keyboard and Horns. Our " + "(findGreatestNumberMusicians())" + " ensemble can be customize to fit the different stages of your wedding (ceremony, cocktail, reception). Our quote for your five and half hour reception is "
        
        let end:String = eventTravelCostLabel.text! + ". In order to move forward with finalizing details, discussions would best be held over phone."
        
        let proposal:String = proposalIntro + end
        
//        proposalBody + links + proposalConclusion
        
        UIPasteboard.generalPasteboard().string = proposal
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
            case (numGuestsField):
                numGuests = numGuestsField.text.toInt()!
                numGuestsField.text = "\(numGuests) guests"
            case (travelTimeField):
                travelTime = travelTimeField.text.toDouble()!
                travelTimeField.text = "\(travelTime) travel hours"
            case (travelDistanceField):
                milage = travelDistanceField.text.toDouble()!
                travelDistanceField.text = "\(milage) travel miles"
            case (serviceLengthField):
                serviceLength[subEvent] = serviceLengthField.text.toDouble()!
                serviceLengthField.text = "\(serviceLength[subEvent]) service hours"
            case (numMusiciansField):
                numMusicians[subEvent] = numMusiciansField.text.toInt()!
                numMusiciansField.text = "\(numMusicians[subEvent]) musicians"
            default:
                print()
            }
        }
        
        if (!isNumeric) {
            switch (textField) {
            case (hostNameField):
                hostName = textField.text
            case (eventTypeField):
                eventType = textField.text
            case (eventDateField):
                eventDate = textField.text
            case (hostNameField):
                hostName = textField.text
            case (eventTypeField):
                eventType = textField.text
            case (eventDateField):
                eventDate = textField.text
            case (cityField):
                city = textField.text
            case (venueField):
                venue = textField.text
            case (bandNameField):
                bandName = textField.text
            case (bandManagerField):
                bandManager = textField.text
            case (bandTypeField):
                bandType[subEvent] = textField.text
            case (performanceLinkField):
                performanceLink[subEvent] = textField.text
            default:
                print()
            }
        }
        
        //If the user does not enter text, the field will revert to the previous text label
        if (textField.text == "") {
            textField.text = previousText
        }
        
        return true
    }

        func textFieldShouldReturn(textField: UITextField!) -> Bool {
            //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
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

