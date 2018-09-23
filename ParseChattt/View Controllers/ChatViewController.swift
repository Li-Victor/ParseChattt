//
//  ChatViewController.swift
//  ParseChattt
//
//  Created by Victor Li on 9/20/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource {
    
    private var chatMessages: [PFObject] = [] {
        didSet {
            chatTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet private weak var chatTableView: UITableView!
    @IBOutlet private weak var chatMessageField: UITextField!
    
    @IBAction private func onSendMessage(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success: Bool, error: Error?) in
            if success {
                self.chatMessageField.text = ""
            } else {
                self.displayAlert(title: "Error in Sending Message", message: error?.localizedDescription ?? "ERROR")
            }
        }
    }
    
    private func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.chatMessage = chatMessages[indexPath.row]
        return cell
    }
    
    @objc private func fetchChatMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let objects = objects {
                self.chatMessages = objects
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 80
        chatTableView.separatorStyle = .none
        
        // add refresh control on top of tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.fetchChatMessages), for: .valueChanged)
        chatTableView.insertSubview(refreshControl, at: 0)
        
        fetchChatMessages()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.fetchChatMessages), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
