//
//  HeartRatesTableViewController.swift
//  GetHeartRates
//
//  Created by morse on 6/17/20.
//  Copyright © 2020 morse. All rights reserved.
//

let sampleWorkouts = """

From Apple Watch:
<HKWorkout> (13)  6ED283F6-5EE3-4BF6-8AFF-30E2B641F6C0 "Daniel’s Apple Watch" (6.0), "Watch3,4" (6.0)"Apple Watch" metadata: {
    HKAverageMETs = "5.96718 kcal/hr\\U00b7kg";
    HKElevationAscended = "1798 cm";
    HKIndoorWorkout = 0;
    HKTimeZone = "America/Los_Angeles";
    HKWeatherHumidity = "63 %";
    HKWeatherTemperature = "58 degF";
} (2020-06-08 20:20:03 -0700 - 2020-06-08 20:38:21 -0700)

From Elemnt:
<HKWorkout> (13)  6D01D5CB-8483-4032-B273-7CFAE533FBF8 "ELEMNT" (1543), "iPhone11,2" (12.3.1) (2019-08-01 17:18:28 -0700 - 2019-08-01 17:29:28 -0700), <HKWorkout> (13)  2CBAD673-FFDF-44B9-8277-38BF1A346782 "ELEMNT" (1543), "iPhone11,2" (12.3.1) (2019-08-01 17:39:28 -0700 - 2019-08-01 17:59:05 -0700), <HKWorkout> (13)  3B185002-C87B-4412-A08F-5440EF736828 "ELEMNT" (1543), "iPhone11,2" (12.3.1) (2019-08-01 18:00:55 -0700 - 2019-08-01 18:05:08 -0700), <HKWorkout> (13)  78A6C62E-8670-4A1F-BF22-EFB5E91F237B "Lose It!" (1), "iPhone11,2" (12.3.1)metadata: {
    HKExternalUUID = "466CAF29-C342-4BFD-B191-E67335538BB4";
} (2019-08-01 22:59:59 -0700 - 2019-08-01 22:59:59 -0700)
"""

import UIKit
import HealthKit

class HeartRatesTableViewController: UITableViewController {
    
    var readings: [HKSample] = []
    var workouts: [HKWorkout]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authorizeHealthKit()
//        loadAndDisplayHeartRates()
        loadAndPrintWorkouts { workouts, error in
            print(workouts ?? "no workouts", error ?? "no error", workouts?.count ?? "0")
            print("here\n", workouts?.last ?? "no workouts")
        }
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
    
    private func loadAndDisplayHeartRates() {
        HRDataStore.getHeartRates { result in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let heartRates):
                print("Got \(heartRates.count) heart rates.")
                print("\(String(describing: heartRates.first))")
                self.readings = heartRates
                self.tableView.reloadData()
            }
        }
    }
    
    func loadAndPrintWorkouts(completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .cycling)
        let sourcePredicate = HKQuery.predicateForObjectsWithNoCorrelation()
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [workoutPredicate, sourcePredicate])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: compound, limit: 0, sortDescriptors: [sortDescriptor]) { query, samples, error in
            DispatchQueue.main.async {
                guard let samples = samples as? [HKWorkout], error == nil else {
                    completion(nil, error)
                    return
                }
                completion(samples, nil)
            }
        }
        
        HKHealthStore().execute(query)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return readings.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = readings[indexPath.row].description
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
