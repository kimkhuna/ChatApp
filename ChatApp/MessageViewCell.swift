//
//  MessageViewCell.swift
//  ChatApp
//
//  Created by 김경훈 on 2022/08/10.
//

import UIKit

class MessageViewCell: UITableViewCell {
    
    @IBOutlet weak var sendmessage: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
