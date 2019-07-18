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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var HRVLabel: UILabel!
    @IBOutlet weak var hrvProgressView: UIProgressView!
    
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // MARK: CHECK HEALTH DATA AVAILIBILITY
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here.
            print("Health data is available")
            
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!])
            
            
            // MARK: REQUEST AUTHORIZATION
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
    
    
    // MARK: HRV & HR VALUE
    func getHRVSampleQuery() {
        let HRVType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        let HRType = HKQuantityType.quantityType(forIdentifier: .heartRate)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        
        let startDate = Date() - 7 * 24 * 60 * 60 // start date is a week from now
        //  Set the Predicates & Interval
        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
        
        let sampleQueryHRV = HKSampleQuery(sampleType: HRVType!, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { sampleQuery, results, error  in
            if(error == nil) {
                for result in results! {
//                    print("Startdate")
//                    print(result.startDate)
//                    print(result)
                    let r = result as! HKQuantitySample
                    let quantity = r.quantity
                    
                    let formater = DateFormatter()
                    formater.dateFormat = "h:mm a"
                    let updatedDate = formater.string(from: result.startDate)
                    let countHRVDouble = quantity.doubleValue(for: HKUnit(from: "ms"))
                    var countHRV = Float(countHRVDouble)/65
                    if countHRV>1 {
                        countHRV = Float.random(in: 0..<0.2)
                    }
                    let countHRVtoProgress = 1-Float(countHRVDouble)/65
                    print(countHRVtoProgress)
                    
                    DispatchQueue.main.async {
                        self.dateLabel.text = "Today \(updatedDate)"
                        self.HRVLabel.text = String(format: "HRV: %.2f ms", countHRVDouble)
                        self.hrvProgressView.setProgress(countHRVtoProgress, animated: true)
                    }
                    
                    //Today 09.00 AM
                }
            }
        }
        
        let sampleQuery = HKSampleQuery(sampleType: HRType!, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { sampleQuery, results, error  in
            if(error == nil) {
                for result in results! {
                    let r = result as! HKQuantitySample
                    let quantity = r.quantity
                    let countHR = quantity.doubleValue(for: HKUnit(from: "count/min"))
                    print(" heartRate \(countHR)")
                    
                    DispatchQueue.main.async {
                    self.heartRateLabel.text = String(format: "HeartRate: %.1f ms", countHR)
                    }
//                    print(result)
                    
//                    let formater = DateFormatter()
//                    formater.dateFormat = "h:mm a"
//                    let updatedDate = formater.string(from: result.startDate)
//                    let countHRV = quantity.doubleValue(for: HKUnit(from: "ms"))
//                    print("HRV: \(countHRV) ms , date: \(updatedDate)")
//                    self.dateLabel.text = "Today \(updatedDate)"
//                    self.HRVLabel.text = String(format: "HRV: %.2f ms", countHRV)
                    
                    //Today 09.00 AM
                }
            }
        }
        healthStore.execute(sampleQueryHRV)
        healthStore.execute(sampleQuery)
        
    }
    
//    func fetchHeartRates(){
//        let HRVType = HKObjectType.quantityType(forIdentifier: .heartRate)
//
//        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
//
//        let startDate = Date() - 7 * 24 * 60 * 60 // start date is a week from now
//        //  Set the Predicates & Interval
//        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
//
//        let sampleQuery = HKSampleQuery(sampleType: HRVType!, predicate: predicate, limit: 10, sortDescriptors: [sortDescriptor]) { sampleQuery, results, error  in
//            if(error == nil) {
//                for result in results! {
//                    print("Startdate")
//                    print(result.startDate)
//                    print(result.sampleType)
//                    print(result)
//
//
//
//                    //                    print(result.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)))
//                    //                    print(result)
//
//                    // print(result.metadata)
//                }
//            }
//        }
//        healthStore.execute(sampleQuery)
//    }
    
    
}

// MARK: Resources

//developer.apple.com/documentation/healthkit/setting_up_healthkit

//stackoverflow.com/questions/47355242/cannot-get-hrv-readings-in-sensible-format-from-healthkit
//stackoverflow.com/questions/47040640/track-beat-to-beat-heart-rate-apple-watch-through-hrv
