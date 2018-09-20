//
//  LoginViewController.swift
//  ParseChattt
//
//  Created by Victor Li on 9/19/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func onSignUp(_ sender: Any) {
        guard !(usernameField.text!.isEmpty) else {
            displayAlert(title: "Username Required", message: "Please enter a username")
            return
        }
        
        guard !(passwordField.text!.isEmpty) else {
            displayAlert(title: "Password Required", message: "Please enter a password")
            return
        }
        
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("created a new user")
            } else {
                self.displayAlert(title: "Sign Up Error", message: error?.localizedDescription ?? "ERROR")
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard !(usernameField.text!.isEmpty) else {
            displayAlert(title: "Username Required", message: "Please enter a username")
            return
        }
        
        guard !(passwordField.text!.isEmpty) else {
            displayAlert(title: "Password Required", message: "Please enter a password")
            return
        }
        
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("login")
            } else {
                self.displayAlert(title: "Login Error", message: error?.localizedDescription ?? "ERROR")
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
