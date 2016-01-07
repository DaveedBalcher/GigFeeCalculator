//
//  Event.swift
//  GigFeeCalculator2
//
//  Created by David Balcher on 12/27/14.
//  Copyright (c) 2014 David Balcher. All rights reserved.
//

import UIKit
import CoreData


var allEvents:[Event] = []
var currentEventIndex = -1
var eventTable:UITableView?

let kAllEvents = "events"

class Event:NSObject {
    
    //Numeric input for calculations
    var serviceLength: [Double]
    var numMusicians: [Int]
    var travelTime: Double
    var milage: Double
    var numGuests: Int
    
    //Text input for proposel write-up
    var hostName: String
    var eventType: String
    var eventDate: String
    var city: String
    var venue: String
    var band: [String]
    var dateCreated: String
    
    override init() {
        serviceLength = [0.0,0.0,0.0]
        numMusicians = [0,0,0]
        travelTime = 0.0
        milage = 0.0
        numGuests = 0
        
        hostName = ""
        eventType = ""
        eventDate = ""
        city = ""
        venue = ""
        band = ["","",""]
        dateCreated = NSDate().description
        
    }
    
    func detailsEdited() -> [Bool] {
        var detailsEditedArray = [Bool]()
        for index in 1...17 {
            detailsEditedArray.append(false)
            }
        return detailsEditedArray
    }
    
    
    func createArrayOfEventDetails(subEvent: Int) -> [String] {
        var arrayOfEventDetails = [String]()
        var newDetail = "\(serviceLength[subEvent]) service hours"
        arrayOfEventDetails.append(newDetail)
        newDetail = "\(numMusicians[subEvent]) musicians"
        arrayOfEventDetails.append(newDetail)
        newDetail = "\(travelTime) travel hours"
        arrayOfEventDetails.append(newDetail)
        newDetail = "\(milage) travel miles"
        arrayOfEventDetails.append(newDetail)
        newDetail = "\(numGuests) guests"
        arrayOfEventDetails.append(newDetail)
        
        arrayOfEventDetails.append(hostName)
        arrayOfEventDetails.append(eventType)
        arrayOfEventDetails.append(eventDate)
        arrayOfEventDetails.append(city)
        arrayOfEventDetails.append(venue)
        arrayOfEventDetails.append(band[subEvent])
        
        return arrayOfEventDetails
    }

    func dictionary() -> NSDictionary {
        return ["serviceLength":serviceLength, "numMusicians":numMusicians, "travelTime":travelTime, "milage":milage, "numGuests":numGuests, "hostName":hostName, "eventType":eventType, "eventDate":eventDate, "city": city, "venue":venue, "band":band, "dateCreated":dateCreated]
    }
    
    class func saveEvents() {
        var aDictionaries:[NSDictionary] = []
        for var i:Int = 0; i < allEvents.count; i++ {
            aDictionaries.append(allEvents[i].dictionary())
        }
        NSUserDefaults.standardUserDefaults().setObject(aDictionaries, forKey: kAllEvents)
    }
    
    class func loadEvents() {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var savedData:[NSDictionary]? = defaults.objectForKey(kAllEvents) as? [NSDictionary]
        if let data:[NSDictionary] = savedData {
            for var i:Int = 2; i < data.count; i++ {
                var e:Event = Event()
                e.setValuesForKeysWithDictionary(data[i])
                allEvents.append(e)
            }
        }
    }

}