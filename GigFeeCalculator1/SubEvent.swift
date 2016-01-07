//
//  SubEvent.swift
//  GigFeeCalculator1
//
//  Created by David Balcher on 12/13/14.
//  Copyright (c) 2014 David Balcher. All rights reserved.
//

import Foundation

class SubEvent: Event {

    func subEventRate(serviceLength: Double, numMusicians: Int) -> Int{
        let rawRate:Int = Int(serviceLength*(Double(numMusicians*costPerMusicianHour)))
        let rate = round(rawNumber: rawRate, roundingAmount: 10)
        return rate
    }
}