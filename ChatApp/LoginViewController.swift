//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 김경훈 on 2022/08/04.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
        if let textID = emailTextField.text, let textPW = pwTextField.text{
            
            if textID.count < 1 || textPW.count < 1{
                print("아이디와 비밀번호를 입력하세요")
                return
            }
        
            
            Auth.auth().signIn(withEmail: textID, password: textPW){
                [weak self] user, error in
                guard let _ = self else {return}
                
                
                
                let user = Auth.auth().currentUser
                print("\(String(describing: user?.email)), \(user?.uid)")
                self!.gotoMain()
            }
            
        }else{
            print("아이디와 비밀번호를 확인하세요")
            return
        }
    }




func gotoMain(){
    
    let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
    self.navigationController?.pushViewController(ChatVC, animated: true)
        }
    
    
}


