//
//  Todo.swift
//  Todos
//
//  Created by gaibb on 2020/7/3.
//  Copyright © 2020 gaibb. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var name = ""
    @objc dynamic var checked = false
    @objc dynamic var createTime = Date()
}
