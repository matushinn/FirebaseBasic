//
//  ViewController.swift
//  FireStoreBasic
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import UIKit
import Firebase
import FirebaseFirestore

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
        
    }
    
}

