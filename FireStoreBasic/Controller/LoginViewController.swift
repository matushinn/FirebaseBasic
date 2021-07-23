//
//  LoginViewController.swift
//  FireStoreBasic
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //一度だけ
    }
    
    //毎回呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func login(){
        
        Auth.auth().signInAnonymously { result, error in
            
            if error != nil{
                print(error.debugDescription)
            }
            
            let user = result?.user
            print(user)
            
            UserDefaults.standard.set(self.textField.text!, forKey: "userName")
            
            //画面遷移
            let viewVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as! ViewController
            self.navigationController?.pushViewController(viewVC, animated: true)
            
            
        }
    }
    
    @IBAction func done(_ sender: Any) {
        login()
    }
    

}
