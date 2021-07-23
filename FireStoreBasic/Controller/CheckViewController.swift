//
//  CheckViewController.swift
//  FireStoreBasic
//
//  Created by 大江祥太郎 on 2021/07/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class CheckViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    

    var odaiString = String()
    
    @IBOutlet weak var odaiLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var dataSets:[AnswersModel] = []
    //var dataSets = [AnswersModel]()も同じ
    
    
    
    /*
     TableVIewに表示させるものは何か？
     for文を回してデータをモデルを使って取ってくる。
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        odaiLabel.text = odaiString
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
        
        let answerLabel = cell.contentView.viewWithTag(1) as! UILabel
        answerLabel.numberOfLines = 0
        answerLabel.text = "\(self.dataSets[indexPath.row].userName)君の回答\n\(self.dataSets[indexPath.row].answers)"
        
        
        return cell
        
    }
    
    //可変のセルを作る
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentVC = self.storyboard?.instantiateViewController(identifier: "commentVC") as! CommentViewController
        
        commentVC.idString = dataSets[indexPath.row].docID
        commentVC.kaitouString = "\(self.dataSets[indexPath.row].userName)君の回答\n\(self.dataSets[indexPath.row].answers)"
        self.navigationController?.pushViewController(commentVC, animated: true)
        
    }
    func loadData(){
        //Answersのdocument達を引っ張ってくる->postDateを投稿したものが下に来るように
        
        
        //dataSetsに入れる。Answersモデル型として
        
        db.collection("Answers").order(by: "postDate").addSnapshotListener { snapShot, error in
            self.dataSets = []
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapDhotDoc = snapShot?.documents{
                for doc in snapDhotDoc{
                    let data = doc.data()
                    if let answer = data["answer"] as? String,let userName = data["userName"] as? String{
                        let answerModel = AnswersModel(answers: answer, userName: userName, docID: doc.documentID)
                        
                        self.dataSets.append(answerModel)
                    }
                    
                }
                //新しいものを上に表示する
                self.dataSets.reverse()
                self.tableView.reloadData()
            }
        }
    }
    

}
