//
//  Task.swift
//  taskapp
//
//  Created by まるやまゆうき on 2019/03/17.
//  Copyright © 2019 yuuki.maruyama. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用　ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    // 日時
    @objc dynamic var date = Date()
    
    // カテゴリーID
    @objc dynamic var categoryId = 0
    
    // カテゴリー名称
    @objc dynamic var categoryName = ""
    
    /**
     id をプライマリーキーとして設定
    */
    override static func primaryKey() -> String? {
        return "id"
    }
}
