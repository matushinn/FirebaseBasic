    //
    //  CommentViewController.swift
    //  FireStoreBasic
    //
    //  Created by 大江祥太郎 on 2021/07/24.
    //
    
    import UIKit
    import Firebase
    import FirebaseFirestore
    
    
    class CommentViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
        
        
        
        var idString = String()
        var kaitouString = String()
        
        @IBOutlet weak var textfield: UITextField!
        @IBOutlet weak var kaitoLabel: UILabel!
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var sendButton: UIButton!
        
        var userName = String()
        
        let db = Firestore.firestore()
        
        var dataSets:[CommentModel] = []
        
        //全てのサイズ
        let screenSize = UIScreen.main.bounds.size
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            
            tableView.delegate = self
            tableView.dataSource = self
            
            kaitoLabel.text = kaitouString
            
            //ユーザーネームの取得
            if UserDefaults.standard.object(forKey: "userName") != nil {
                userName = UserDefaults.standard.object(forKey: "userName") as! String
            }
            
            //テキストフィールドをキーボードの高さ分移動させる
            //キーボードが上に上がったら？
            NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            //キーボードが下がった時の処理
            NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        //テキストフィールドをキーボードの高さ分移動させる
        @objc func keyboardWillShow(_ notification:NSNotification){
            
            let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
            
            textfield.frame.origin.y = screenSize.height - keyboardHeight - textfield.frame.height
            
            sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height
            
            
        }
        
        @objc func keyboardWillHide(_ notification:NSNotification){
            
            textfield.frame.origin.y = screenSize.height - textfield.frame.height
            
            sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
            
            
            guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
            
            
            UIView.animate(withDuration: duration) {
                
                let transform = CGAffineTransform(translationX: 0, y: 0)
                self.view.transform = transform
                
            }
            
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            self.navigationController?.isNavigationBarHidden = false
            loadData()
        }
        
        func loadData(){
            
            db.collection("Answers").document(idString).collection("comments").order(by: "postDate").addSnapshotListener { snapShot, error in
                
                self.dataSets = []
                
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                
                if let snapShotDoc = snapShot?.documents{
                    
                    for doc in snapShotDoc {
                        
                        let data = doc.data()
                        
                        if let userName = data["userName"] as? String,let comment = data["comment"] as? String,let postDate = data["postDate"] as? Double {
                            let commentModel = CommentModel(userName: userName, comment: comment, postDate: postDate)
                            self.dataSets.append(commentModel)
                            
                        }
                        
                    }
                    self.dataSets.reverse()
                    self.tableView.reloadData()
                }
            }
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSets.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            tableView.rowHeight = 200
            
            let commentLabel = cell.contentView.viewWithTag(1) as! UILabel
            commentLabel.numberOfLines = 0
            
            commentLabel.text = "\(self.dataSets[indexPath.row].userName)君の回答\n\(self.dataSets[indexPath.row].comment)"
            
            
            return cell
            
        }
        //可変のセルを作る
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            tableView.estimatedRowHeight = 100
            return UITableView.automaticDimension
        }
        
        @IBAction func sendAction(_ sender: Any) {
            
            //Firebase直接コメントを消すことも可能である。
            if textfield.text?.isEmpty == true {
                print("文字を書きなさい")
                return
            }
            db.collection("Answers").document(idString).collection("comments").document().setData(["userName":userName as Any,"comment":textfield.text! as Any,"postDate":Date().timeIntervalSince1970])
            
            textfield.resignFirstResponder()
            textfield.text = ""
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            textfield.resignFirstResponder()
        }
        
    }
