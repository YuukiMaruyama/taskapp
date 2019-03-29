//
//  Category.swift
//  taskapp
//
//  Created by まるやまゆうき on 2019/03/28.
//  Copyright © 2019 yuuki.maruyama. All rights reserved.
//

import RealmSwift

class Category: Object {
    // 管理用　ID。プライマリーキー
    @objc dynamic var categoryId = 0
    
    // カテゴリー名称
    @objc dynamic var categoryName = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "categoryId"
    }
}
