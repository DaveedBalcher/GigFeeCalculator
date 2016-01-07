//
//  Calculate.swift
//  GigFeeCalculator2
//
//  Created by David Balcher on 12/28/14.
//  Copyright (c) 2014 David Balcher. All rights reserved.
//

import Foundation

class Calculate {
    
    let costPerMusicianHour = 95
    let costPerTravelHour = 12.0
    let depositPercentage = 0.3
    let numGuests: Int?
    
    let gasPerMile = 0.25 //25 cents a mile; 12 miles a gallon; $3.00 a gallon
    
    init(numGuests: Int) {
        self.numGuests = numGuests
    }
    
    func eventRate(serviceLength: Double, numMusicians: Int) -> Int{
        let newCostPerMusicianHour = numGuestsBias()
        let rawRate:Int = Int(serviceLength*(Double(numMusicians*newCostPerMusicianHour)))
        let rate = round(rawNumber: rawRate, roundingAmount: 10)
        return rate
    }
    
    func travelCost(numMusicians: Int, milage: Double, travelTime: Double) ->Int {
        let cars:Double = Double(numMusicians/2)
        let trips = 2.0
        let rawMilageCharge:Int = Int(trips*milage*gasPerMile*cars)
        let rawTravelTimeCharge = Int(trips*(travelTime)*Double(numMusicians)*costPerTravelHour)
        let rawTravelCharge = rawMilageCharge+rawTravelTimeCharge
        let travelCharge = round(rawNumber: rawTravelCharge, roundingAmount: 10)
        return travelCharge
    }
    
    func depositCost(eventRate: Int) -> Int {
        let rawDeposit: Int = Int(Double(eventRate)*depositPercentage)
        let deposit = round(rawNumber: rawDeposit, roundingAmount: 50)
        return deposit
    }
    
    func round(#rawNumber: Int, roundingAmount: Int) -> Int {
        var roundUp = 0
        if (rawNumber - (rawNumber/roundingAmount)*roundingAmount > roundingAmount/2) {
            roundUp = 1
        }
        return ((rawNumber/roundingAmount)+roundUp)*roundingAmount
    }
    
    func numGuestsBias() -> Int {
        var newCostPerMusicianHour = costPerMusicianHour
        if (numGuests != nil && numGuests != 0) {
            newCostPerMusicianHour = (costPerMusicianHour - 15) + (numGuests!/10)
        } else {
            newCostPerMusicianHour = costPerMusicianHour
        }
        return newCostPerMusicianHour
    }
    
}