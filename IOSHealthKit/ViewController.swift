//
//  ViewController.swift
//  IOSHealthKit
//
//  Created by Fauzi Fauzi on 15/07/19.
//  Copyright © 2019 Fauzi. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here.
            print("Health data is available")
            
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!])
            
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                    print(error!)
                } else {
                    print("SUCCESS :\(success)")
                    self.getHRVSampleQuery()
                }
            }
        }
    }
    
    func getHRVSampleQuery() {
        let HRVType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        
        let startDate = Date() - 7 * 24 * 60 * 60 // start date is a week from now
        //  Set the Predicates & Interval
        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
        
        let sampleQuery = HKSampleQuery(sampleType: HRVType!, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { sampleQuery, results, error  in
            if(error == nil) {
                for result in results! {
                    print("Startdate")
                    print("\(result.startDate) \n")
                    print("\(result.sampleType) \n")

//                    print(result)
//                    print(result.me)
                }
            }
            
            print("error \(error)")
            print(results)
        }
        healthStore.execute(sampleQuery)
    }


}

// MARK: Resources

//developer.apple.com/documentation/healthkit/setting_up_healthkit

//stackoverflow.com/questions/47355242/cannot-get-hrv-readings-in-sensible-format-from-healthkit
//stackoverflow.com/questions/47040640/track-beat-to-beat-heart-rate-apple-watch-through-hrv
