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
    
    
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userimgView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let db = Firestore.firestore()
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMessage()
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
            db.collection("Message").addDocument(data:[ "sender" : messageSender, "body" : messageBody, "date" : Date().timeIntervalSince1970]){(error) in
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
        
        db.collection("Message").order(by: "date").addSnapshotListener{(QuerySnapshot, error)in
            
            self.messages = []
            
            if let e = error {
                print(e.localizedDescription)
            }else{
                if let snapshotDocuments = QuerySnapshot?.documents{
                    snapshotDocuments.forEach{(doc) in
                        let data = doc.data()
                        if let sender = data["sender"] as? String, let body = data["body"] as? String{
                            self.messages.append(Message(sender: sender, body: body))
                            
                            
                            DispatchQueue.main.async {
                                self.messageTableView.reloadData()
                                self.messageTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
 

    
    
    
}





