//
//  ViewController.swift
//  GetHeartRates
//
//  Created by morse on 6/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authorizeHealthKit()
        loadAndPrintHeartRates()
    }
    
    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let success):
                print("HealthKit Authorized: \(success)")
            }
        }
    }
    
    private func loadAndPrintHeartRates() {
        HRDataStore.getHeartRates { result in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let heartRates):
                print("Got \(heartRates.count) heart rates.")
                print("\(heartRates.first!)")
//                let unit = HKUnit.
                var total = 0
//                for heartRate in heartRates {
////                    print(heartRate)
//                    total += heartRate.
//                }
            }
        }
    }

}

