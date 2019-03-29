//
//  AddCategoryViewController.swift
//  taskapp
//
//  Created by まるやまゆうき on 2019/03/28.
//  Copyright © 2019 yuuki.maruyama. All rights reserved.
//

import UIKit
import RealmSwift

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    
    let realm = try! Realm()
    var category = Category()
    var categoryArrayRealm = try! Realm().objects(Category.self).sorted(byKeyPath: "categoryId", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    @IBAction func saveCategoryButton(_ sender: Any) {
        // 文字が入力されてる場合、レルムに保存する。
        if categoryTextField.text != "" {
            try! realm.write {
                self.category.categoryName = self.categoryTextField.text!
                let allCategory = realm.objects(Category.self)
                self.category.categoryId = allCategory.max(ofProperty: "categoryId")! + 1
                self.realm.add(self.category, update: true)
            }
        }
        // テキストフィールドは空白にしておく（初期の状態にしたい）
        categoryTextField.text = ""
    }
}
