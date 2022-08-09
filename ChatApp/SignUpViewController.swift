
import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func signupBtn(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {return}
        
        guard let pw = pwTextField.text
            else {return}
        
        Auth.auth().createUser(withEmail: email, password: pw){
            authResult, error in
            if let e = error {
                print(e)
            }else{
                self.performSegue(withIdentifier: "SignUpVC", sender: self)
            }
        }
        
    }
    


}
