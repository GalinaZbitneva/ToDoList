//
//  Category.swift
//  Todoey
//
//  Created by Галина Збитнева on 29.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted  var name: String = ""
    //укажем тип взаимосвязи между Item и Category
    //эта связь -  список из элементов типа Item
    @Persisted  var items = List<Item>()
    
}
