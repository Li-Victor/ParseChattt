//
//  ChatViewController.swift
//  ParseChattt
//
//  Created by Victor Li on 9/20/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    @IBOutlet weak var chatMessageField: UITextField!
    
    @IBAction func onSendMessage(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageField.text ?? ""
        
        chatMessage.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else {
                self.displayAlert(title: "Error in Sending Message", message: error?.localizedDescription ?? "ERROR")
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
