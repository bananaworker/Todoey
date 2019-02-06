//
//  Category.swift
//  Todoey
//
//  Created by Muzafar on 03/02/2019.
//  Copyright © 2019 Muzafar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}

