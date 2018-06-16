//
//  NewListViewController.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/16/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import UIKit
import Firebase

class NewListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedPlace = pickerData[row]
    }

    var ref: DatabaseReference!
    var pickerData: [Place] = [Place]()
    var pickedPlace: Place? = nil
    @IBOutlet weak var backIv: UIImageView!
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var placePicker: UIPickerView!
    @IBAction func onClickNewPlace(_ sender: Any) {
        let alert = UIAlertController(title: "New Place", message: "Enter title and coordinates", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Latitude"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Langitude"
        }
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (alertAction) in
            let place = Place(title: alert.textFields![0].text!, latitude: Float(alert.textFields![1].text!)!, longitude: Float(alert.textFields![2].text!)!)
            self.ref.child(Auth.auth().currentUser!.uid).child("places").child(place.title).setValue(place)
        }))
        alert.addAction(UIAlertAction(title: "Not now", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func onClickAddNewList(_ sender: Any) {
        if(!(titleTf.text?.isEmpty)! && !descriptionTv.text.isEmpty) {
            let list = List(name: titleTf.text!, description: descriptionTv.text!, place: pickedPlace!)
            ref.child(Auth.auth().currentUser!.uid).child("lists").child(list.name).setValue(list.toNSDictionary())
        } else {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        placePicker.delegate = self
        placePicker.dataSource = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClickBackArrow(tapGestureRecognizer:)))
        backIv.isUserInteractionEnabled = true
        backIv.addGestureRecognizer(tapGestureRecognizer)
        
        _ = ref.child(Auth.auth().currentUser!.uid).child("places").observe(DataEventType.childAdded, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let place = Place(title: (value["title"] as? String)!, latitude: (value["latitude"] as? Float)!, longitude: (value["longitude"] as? Float)!)
            if(self.pickedPlace == nil) {
                self.pickedPlace = place
            }
            self.pickerData.append(place)
            self.placePicker.reloadAllComponents()
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

    @objc func onClickBackArrow(tapGestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listViewController = storyboard.instantiateViewController(withIdentifier: "ListStoryboard") as! ListViewController
        self.present(listViewController, animated: true, completion: nil)
    }
}
