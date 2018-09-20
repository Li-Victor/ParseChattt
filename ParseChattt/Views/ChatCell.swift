//
//  ChatCell.swift
//  ParseChattt
//
//  Created by Victor Li on 9/20/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class ChatCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var chatMessageLabel: UILabel!
    
    var chatMessage: PFObject! {
        didSet {
            chatMessageLabel.text = chatMessage["text"] as? String
            
            if let user = chatMessage["user"] as? PFUser {
                usernameLabel.text = user.username!
            } else {
                // No user found, set default username
                usernameLabel.text = "🤖"
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
