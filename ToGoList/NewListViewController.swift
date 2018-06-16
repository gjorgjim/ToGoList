//
//  NewListViewController.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/16/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import UIKit
import Firebase

class NewListViewController: UIViewController {

    var ref: DatabaseReference!
    @IBOutlet weak var backIv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClickBackArrow(tapGestureRecognizer:)))
        backIv.isUserInteractionEnabled = true
        backIv.addGestureRecognizer(tapGestureRecognizer)
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
