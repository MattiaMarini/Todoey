//
//  Item.swift
//  Todoey
//
//  Created by Mattia Marini on 14/07/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: NSDate = NSDate()
    @objc dynamic var colour: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
