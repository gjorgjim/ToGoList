//
//  RegisterViewController.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/16/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var repeatPasswordTf: UITextField!
    @IBOutlet weak var backIv: UIImageView!
    @IBAction func onClickSignUp(_ sender: Any) {
        if(!(emailTf.text?.isEmpty)! && !(passwordTf.text?.isEmpty)! && !(repeatPasswordTf.text?.isEmpty)!) {
            if(passwordTf.text == repeatPasswordTf.text) {
                Auth.auth().createUser(withEmail: emailTf.text!, password: passwordTf.text!) { (result, error) in
                    if(error != nil) {
                        self.errorLbl.text = "Email is already registered"
                        self.errorLbl.isHidden = false
                    } else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let listViewController = storyboard.instantiateViewController(withIdentifier: "ListStoryboard") as! ListViewController
                        self.present(listViewController, animated: true, completion: nil)
                    }
                }
            } else {
                errorLbl.text = "Passwords do not match"
                errorLbl.isHidden = false
            }
        } else {
            errorLbl.text = "Please fill the empty fields"
            errorLbl.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
        emailTf.underlined()
        passwordTf.underlined()
        repeatPasswordTf.underlined()
        
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
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginStoryboard") as! ViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
}
