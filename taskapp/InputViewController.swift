//
//  InputViewController.swift
//  taskapp
//
//  Created by まるやまゆうき on 2019/03/17.
//  Copyright © 2019 yuuki.maruyama. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    let realm = try! Realm()
    var task: Task!
    var category: Category! = Category()
    var categoryArrayRealm = try! Realm().objects(Category.self).sorted(byKeyPath: "categoryId", ascending: false)
    var categoryArray: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    func setCategoryPcker(){
        // カテゴリーの配列のデータが0の時、カテゴリー無しを表示したい
        if categoryArrayRealm.count == 0 {
            categoryArray.append("カテゴリーなし")
            try! realm.write {
                self.category.categoryName = "カテゴリーなし"
                self.category.categoryId = 0
                
                self.realm.add(self.category, update: true)
            }
        } else {
            categoryArray.removeAll()
            // レルムに入れておいたカテゴリーを、Stringの配列に入れる
            // Stringの配列に入れているカテゴリーを、ピッカーで表示する
            for i in 1 ... categoryArrayRealm.count {
                categoryArray.append(categoryArrayRealm[categoryArrayRealm.count - i].categoryName)
            }
        }
        categoryPicker.reloadAllComponents()
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 表示する列数
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCategoryPcker()
        categoryPicker.selectRow(task.categoryId, inComponent: 0, animated: false)
    }
    
    // タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を認定（中身がない場合メッセージなしで音だけの通知になるので「xxなし）」を表示する）
        if task.title == ""{
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == ""{
            content.body = "(内容なし)"
        } else {
            content.body = task.contents + task.categoryName
        }
        
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtriggr（日付マッチ）を作成
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK") // errorがnilならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    
    // 保存ボタンを押したら、タスクを保存する
    @IBAction func tapSaveButton(_ sender: Any) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.categoryId = categoryPicker.selectedRow(inComponent: 0)
            self.task.categoryName = self.categoryArray[categoryPicker.selectedRow(inComponent: 0)]!
            self.realm.add(self.task, update: true)
        }
        setNotification(task: task)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
}
