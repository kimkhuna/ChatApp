//
//  ChatViewController.swift
//  ChatApp
//
//  Created by 김경훈 on 2022/08/04.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics


class ChatViewController: UIViewController, UINavigationControllerDelegate{
    
    
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView xib등록
        messageTableView.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "SendCell")
        messageTableView.register(UINib(nibName: "ReceiveTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiveCell")
        loadMessage()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
    }
    


    @IBAction func logoutBtn(_ sender: UIButton) {
        
        
        let FirebaseAuth = Auth.auth()
        do{
            try FirebaseAuth.signOut()
        }catch let signOutError as NSError{
            print("signOut Error: %@", signOutError)
        }
        gotoMainVC()
    }
    
    func gotoMainVC(){
        let MainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        self.navigationController?.pushViewController(MainVC, animated: true)
        self.navigationController?.isNavigationBarHidden = true
       
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        
        
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection("Message").addDocument(data:
            [ "sender" : messageSender, "body" : messageBody, "date" : Date().timeIntervalSince1970]){(error) in
                if let e = error {
                    print(e.localizedDescription)
                }else{
                    print("Success save data")
                    
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                }
            }
        }
    }
    
    private func loadMessage(){
        
        
        db.collection("Message")
            .order(by: "date")
            .addSnapshotListener{(querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print(e.localizedDescription)
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    snapshotDocuments.forEach{(doc) in
                        let data = doc.data()
                        if let sender = data["sender"] as? String, let body = data["body"] as? String{
                        self.messages.append(Message(sender: sender, body: body))
                            
                            
                        DispatchQueue.main.async {
                        self.messageTableView.reloadData()
                            // MARK: 여기만 수정
                        self.messageTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at:.top , animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let ImessageCell = tableView.dequeueReusableCell(withIdentifier: "SendCell", for: indexPath) as! MessageViewCell
        let YoumessageCell = tableView.dequeueReusableCell(withIdentifier: "ReceiveCell", for: indexPath) as! ReceiveTableViewCell
    
        if message.sender == Auth.auth().currentUser?.email{
            
            ImessageCell.sendmessage.text = messages[indexPath.row].body
            ImessageCell.sendmessage.text = message.body
            return ImessageCell
            
        }else{
            
            YoumessageCell.receiveMessage.text = messages[indexPath.row].body
            YoumessageCell.receiveMessage.text = message.body
            return YoumessageCell
        }
        
        
        
    }
}






