//
//  ViewController.swift
//  GetHeartRates
//
//  Created by morse on 6/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authorizeHealthKit()
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
        
    }

}

