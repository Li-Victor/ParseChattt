//
//  ChatViewController.swift
//  ParseChattt
//
//  Created by Victor Li on 9/20/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ChatViewController: UIViewController, UITableViewDataSource {
    
    private var chatMessages: [PFObject] = [] {
        didSet {
            chatTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var navBar: UINavigationItem!
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
    
    @objc func onLogout() {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ChatViewController.onLogout))
        navBar.rightBarButtonItem = logoutBarButtonItem
        
        let userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        let username = PFUser.current()!.username!
        userImageView.af_setImage(withURL: URL(string: "https://api.adorable.io/avatars/88/\(username)")!, completion: {(response) in
            
            let userImage = response.value!.withRenderingMode(.alwaysOriginal)
            
            let navUserImage = UIBarButtonItem(image: userImage, style: .plain, target: self, action: nil)
            self.navBar.leftBarButtonItem = navUserImage
            
        })
        
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 80
        chatTableView.separatorStyle = .none
        
        // add refresh control on top of tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.fetchChatMessages), for: .valueChanged)
        chatTableView.insertSubview(refreshControl, at: 0)
        
        fetchChatMessages()
        
        Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.fetchChatMessages), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
