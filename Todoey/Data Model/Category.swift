//
//  Category.swift
//  Todoey
//
//  Created by Mattia Marini on 14/07/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    var items = List<Item>()
}
