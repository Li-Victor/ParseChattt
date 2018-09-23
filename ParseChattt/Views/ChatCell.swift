//
//  ChatCell.swift
//  ParseChattt
//
//  Created by Victor Li on 9/20/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ChatCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var chatMessageLabel: UILabel!
    
    var chatMessage: PFObject! {
        didSet {
            chatMessageLabel.text = chatMessage["text"] as? String
            
            bubbleView.layer.cornerRadius = 16
            bubbleView.clipsToBounds = true
            
            userImageView.layer.cornerRadius = 16
            userImageView.clipsToBounds = true
            
            let urlString = "https://api.adorable.io/avatars/32"
            
            if let user = chatMessage["user"] as? PFUser {
                userImageView.af_setImage(withURL: URL(string: "\(urlString)/\(user.username!)")!)
            } else {
                // No user found, set default username
                userImageView.af_setImage(withURL: URL(string: "\(urlString)")!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
