//
//  Category.swift
//  Todoey
//
//  Created by fatih maytalman on 8.01.2019.
//  Copyright © 2019 fatih maytalman. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
