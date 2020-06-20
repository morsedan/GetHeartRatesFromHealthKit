//
//  HealthKitSetupAssistant.swift
//  GetHeartRates
//
//  Created by morse on 6/16/20.
//  Copyright © 2020 morse. All rights reserved.
//

import HealthKit

class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
        case unknownError
    }
    
    class func authorizeHealthKit(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(HealthkitSetupError.notAvailableOnDevice))
            return
        }
        
        guard let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(.failure(HealthkitSetupError.dataTypeNotAvailable))
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [heartRate]
        
        HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if success {
                completion(.success(success))
            } else {
                completion(.failure(HealthkitSetupError.unknownError))
            }
        }
    }
}
