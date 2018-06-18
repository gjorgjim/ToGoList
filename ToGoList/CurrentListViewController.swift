//
//  CurrentListViewController.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/18/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import UIKit
import Firebase

class CurrentListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
    var currentList: List? = nil
    var pickerData: [Place] = [Place]()
    var pickedPlace: Place? = nil
    var placeName: String = String()
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var placePicker: UIPickerView!
    @IBOutlet weak var backIv: UIImageView!
    @IBAction func onClickSaveList(_ sender: Any) {
        currentList?.name = titleTf.text!
        currentList?.description = descriptionTv.text
        currentList?.place = pickedPlace!
        
        ref.child(Auth.auth().currentUser!.uid).child("lists").child(placeName).setValue(currentList?.toNSDictionary())
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listViewController = storyboard.instantiateViewController(withIdentifier: "ListStoryboard") as! ListViewController
        self.present(listViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClickBackArrow(tapGestureRecognizer:)))
        backIv.isUserInteractionEnabled = true
        backIv.addGestureRecognizer(tapGestureRecognizer)
        
        placeName = currentList!.name
        titleTf.text = currentList?.name
        descriptionTv.text = currentList?.description
        
        pickedPlace = currentList?.place
        
        placePicker.delegate = self
        placePicker.dataSource = self
        _ = ref.child(Auth.auth().currentUser!.uid).child("places").observe(DataEventType.childAdded, with: { (snapshot) in
            print("Child added called")
            let value = snapshot.value as! NSDictionary
            let place = Place(title: (value["title"] as? String)!, latitude: (value["latitude"] as? Float)!, longitude: (value["longitude"] as? Float)!)
            self.pickerData.append(place)
            self.placePicker.reloadAllComponents()
            if(self.pickedPlace?.title == place.title) {
                self.setPickerValue()
            }
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
    
    func setPickerValue() {
        var i: Int = 0
        while(i < pickerData.count) {
            if(pickerData[i].title == pickedPlace?.title) {
                self.placePicker.selectRow(i, inComponent: 0, animated: true)
            }
            i+=1
        }
    }
    
    @objc func onClickBackArrow(tapGestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listViewController = storyboard.instantiateViewController(withIdentifier: "ListStoryboard") as! ListViewController
        self.present(listViewController, animated: true, completion: nil)
    }
}
