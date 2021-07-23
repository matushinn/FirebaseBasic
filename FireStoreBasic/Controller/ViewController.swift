//
//  ViewController.swift
//  FireStoreBasic
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import EMAlertController
import FirebaseAuth

class ViewController: UIViewController {
    /*
     ユーザー名、お題解答テキスト、現在時刻をキーバリュー型でデータを送受信する
     お題のIDを取得、IDの中にあるcomment欄へデータを送信
     選択したお題のIDを取得、IDのcomment欄のデータを取得
     */
    
    //DBの場所を指定
    let db1 = Firestore.firestore().collection("Odai").document("Zo0oB9ar5UVyCsuX6idz")
    
    let db2 = Firestore.firestore()
    
    var userName = String()
    
    @IBOutlet weak var odaiLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //ユーザーネームの取得
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        loadQuestionData()
        
    }
    
    func loadQuestionData(){
        //Documentの中のdataをとってこれる
        db1.getDocument { snapShot, error in
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            let data = snapShot?.data()
            self.odaiLabel.text = data!["odaiText"] as! String
            
        }
        
    }
    
    @IBAction func send(_ sender: Any) {
        db2.collection("Answers").document().setData(
            ["answer":textView.text as Any,"userName":userName,"postDate":Date().timeIntervalSince1970])
        
        //解答後、空にする
        textView.text = ""
        //アラート
        let alert = EMAlertController(icon: UIImage(named: "check"), title: "投稿完了！", message: "みんなの回答を見てみよう！")
        let doneAction = EMAlertAction(title: "OK", style: .normal)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
        textView.text = ""
        
        
    }
    
    @IBAction func checkAnswer(_ sender: Any) {
        
        //画面遷移する
        let checkVC = self.storyboard?.instantiateViewController(identifier: "checkVC") as! CheckViewController
        
        checkVC.odaiString = odaiLabel.text!
        
        self.navigationController?.pushViewController(checkVC, animated: true)
    }
    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let error as NSError{
            print("error",error)
        }
        
        //画面を戻す
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}

