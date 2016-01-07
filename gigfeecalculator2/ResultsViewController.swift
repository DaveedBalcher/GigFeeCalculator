//
//  ResultsViewController.swift
//  GigFeeCalculator2
//
//  Created by David Balcher on 12/27/14.
//  Copyright (c) 2014 David Balcher. All rights reserved.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController {
    
    
    //Labels to display calculations
    @IBOutlet weak var ceremonyRateLabel: UILabel!
    @IBOutlet weak var cocktailRateLabel: UILabel!
    @IBOutlet weak var receptionRateLabel: UILabel!
    @IBOutlet weak var eventRateLabel: UILabel!
    @IBOutlet weak var travelCostLabel: UILabel!
    @IBOutlet weak var eventTravelCostLabel: UILabel!
    @IBOutlet weak var depositCostLabel: UILabel!
    
    
    var eventRate = 0
    var travelCost = 0
    var ceremonyRate = 0
    var cocktailRate = 0
    var receptionRate = 0
    var depositCost = 0
    
    var currentEvent:Event?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentEvent = allEvents[currentEventIndex]
        calculate()
        showResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calculates rates for entire event, sub-events, travel and deposit amount
    func calculate() {
        
        let newEvent = Calculate(numGuests: currentEvent!.numGuests)
        if (currentEvent!.serviceLength[0] != 0) {
            ceremonyRate = newEvent.eventRate(currentEvent!.serviceLength[0], numMusicians: currentEvent!.numMusicians[0])
        }
        if (currentEvent!.serviceLength[1] != 0) {
            cocktailRate = newEvent.eventRate(currentEvent!.serviceLength[1], numMusicians: currentEvent!.numMusicians[1])
        }
        if (currentEvent!.serviceLength[2] != 0) {
            receptionRate = newEvent.eventRate(currentEvent!.serviceLength[2], numMusicians: currentEvent!.numMusicians[2])
        }
        
        eventRate = ceremonyRate + cocktailRate + receptionRate
        
        let greatestNumMusicians = findGreatestNumberMusicians()
        
        travelCost = newEvent.travelCost(greatestNumMusicians, milage: currentEvent!.milage, travelTime: currentEvent!.travelTime)
        
        depositCost = newEvent.depositCost(eventRate)
    }
    
    func findGreatestNumberMusicians() -> Int{
        var greatestNumMusicians = 0
        for var i = 1; i < 3; i++ {
            if (greatestNumMusicians < currentEvent!.numMusicians[i]) {
                greatestNumMusicians = currentEvent!.numMusicians[i]
            }
        }
        return greatestNumMusicians
    }
    

    
    func showResults() {
        ceremonyRateLabel.text = "  $\(ceremonyRate).00"
        cocktailRateLabel.text = "  $\(cocktailRate).00"
        receptionRateLabel.text = "  $\(receptionRate).00"
        eventRateLabel.text = "  $\(eventRate).00"
        travelCostLabel.text = "  $\(travelCost).00"
        eventTravelCostLabel.text = "  $\(eventRate + travelCost).00"
        depositCostLabel.text = "  $\(depositCost).00"
        
        
    }
    
}
