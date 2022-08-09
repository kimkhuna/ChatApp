//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by 김경훈 on 2022/08/07.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct Message {
    let sender: String
    let body: String
}

class MessageTableViewCell: UITableViewCell {


 
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var leftimgView: UIImageView!
    @IBOutlet weak var rightimgView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        
        
        if message.sender == Auth.auth().currentUser?.email{
            messageCell.leftimgView.isHidden = true
            messageCell.rightimgView.isHidden = false
            messageCell.messageView.backgroundColor = UIColor.lightGray
            messageCell.messageLabel.textColor = UIColor.black
        }else{
            messageCell.leftimgView.isHidden = false
            messageCell.rightimgView.isHidden = true
            messageCell.messageView.backgroundColor = UIColor.black
            messageCell.messageLabel.textColor = UIColor.white
        }
        
        
        messageCell.messageLabel.text = message.body
        
        return messageCell
    }
    
   
}
