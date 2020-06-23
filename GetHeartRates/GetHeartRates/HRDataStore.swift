//
//  HRDataStore.swift
//  GetHeartRates
//
//  Created by morse on 6/17/20.
//  Copyright © 2020 morse. All rights reserved.
//

import HealthKit

class HRDataStore {
    class func getHeartRates(completion: @escaping (Result<[HKSample], Error>) -> Void) {
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Sample Type is no longer available in HealthKit.")
            completion(.failure(NSError()))
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 100
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error retrieving Heart Rates: \(error)")
                    completion(.failure(error))
                    return
                }
                if let samples = samples {
                    completion(.success(samples))
                } else {
                    completion(.failure(NSError()))
                }
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    class func loadWorkouts(completion: @escaping (Result<[HKWorkout], Error>) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .cycling)
        let sourcePredicate = HKQuery.predicateForObjects(withMetadataKey: )
    }
}
