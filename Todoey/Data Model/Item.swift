//
//  Item.swift
//  Todoey
//
//  Created by fatih maytalman on 8.01.2019.
//  Copyright © 2019 fatih maytalman. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var check: Bool = false
    @objc dynamic var dateCreated: Date?

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
