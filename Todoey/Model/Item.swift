//
//  Item.swift
//  Todoey
//
//  Created by Muzafar on 03/02/2019.
//  Copyright © 2019 Muzafar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
