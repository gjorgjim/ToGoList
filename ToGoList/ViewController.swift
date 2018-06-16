//
//  ViewController.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/4/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func onClickSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterStoryboard") as! RegisterViewController
        self.present(registerViewController, animated: true, completion: nil)
    }
    @IBAction func onClickLogin(_ sender: Any) {
        if((emailTf.text?.isEmpty)! && (passwordTf.text?.isEmpty)!) {
            self.errorLbl.text = "Please fill the empty fields"
            self.errorLbl.isHidden = false
        } else {
            Auth.auth().signIn(withEmail: emailTf.text!, password: passwordTf.text!) {(user, error) in
                if(error != nil) {
                    self.errorLbl.text = "Email or password incorrect"
                    self.errorLbl.isHidden = false
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let listViewController = storyboard.instantiateViewController(withIdentifier: "ListStoryboard") as! ListViewController
                    self.present(listViewController, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        errorLbl.isHidden = true
        emailTf.underlined()
        passwordTf.underlined()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

