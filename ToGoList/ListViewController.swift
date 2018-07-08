//
//  ListViewController.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/16/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import CoreLocation

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var listNameLbl: UILabel!
    @IBOutlet weak var listPlaceLbl: UILabel!
}

class ListViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    var ref: DatabaseReference!
    var lists = [List]()
    @IBAction func onClickLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginStoryboard") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func onClickNewList(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newListViewController = storyboard.instantiateViewController(withIdentifier: "NewListStoryboard") as! NewListViewController
        self.present(newListViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // less batery ussage
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("NotificationCenter Authorization Granted!")
            }
        }
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference()
        _ = ref.child(Auth.auth().currentUser!.uid).child("lists").observe(DataEventType.childAdded, with: { [unowned self] (snapshot) in
            let value = snapshot.value as! NSDictionary
            let list = List(name: (value["name"] as? String)!, description: (value["description"] as? String)!,
                            place: Place(title: (value["place"] as? String)!, latitude: 0, longitude: 0),
                            inNotificationCenter: (value["inNotificationCenter"] as? Bool)!,
                            done: (value["done"] as? Bool)!)
            self.lists.append(list)
            self.tableView.reloadData()
            if(!list.done && !list.inNotificationCenter) {
                let content = UNMutableNotificationContent()
                content.title = "ToGo List"
                content.body = "You have a ToGo list in this area"
                content.categoryIdentifier = "alarm"
                content.sound = UNNotificationSound.default()
                
                
                // Ex. Trigger within a Location
                let centerLoc = CLLocationCoordinate2D(latitude: Double(list.place.latitude), longitude: Double(list.place.longitude))
                let region = CLCircularRegion(center: centerLoc, radius: 1.0, identifier: UUID().uuidString) // radius in meters
                region.notifyOnEntry = true
                region.notifyOnExit = false
                let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                self.notificationCenter.add(request)
                list.inNotificationCenter = true
                self.ref.child((Auth.auth().currentUser?.uid)!).child("lists").child(list.name).child("inNotificationCenter").setValue(true)
            }
            //TODO: Set notifications based on location
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        
        let list = lists[indexPath.row]
        cell.listNameLbl?.text = list.name
        cell.listPlaceLbl?.text = list.place.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("List item clicked")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentListViewController = storyboard.instantiateViewController(withIdentifier: "CurrentListStoryboard") as! CurrentListViewController
        currentListViewController.currentList = lists[indexPath.row]
        self.present(currentListViewController, animated: true, completion: nil)
    }
}
