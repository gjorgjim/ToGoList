//
//  ListViewController.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/16/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import UIKit
import Firebase

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var listNameLbl: UILabel!
    @IBOutlet weak var listPlaceLbl: UILabel!
}

class ListViewController: UITableViewController {

    var ref: DatabaseReference!
    var lists: [List] = [List]()
    @IBAction func onClickNewList(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newListViewController = storyboard.instantiateViewController(withIdentifier: "NewListStoryboard") as! NewListViewController
        self.present(newListViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        _ = ref.child(Auth.auth().currentUser!.uid).child("lists").observe(DataEventType.childAdded, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let list = List(name: (value["name"] as? String)!, description: (value["description"] as? String)!,
                            place: Place(title: (value["place"] as? String)!, latitude: 0, longitude: 0),
                            inNotificationCenter: (value["inNotificationCenter"] as? Bool)!)
            self.lists.append(list)
            self.tableView.reloadData()
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
