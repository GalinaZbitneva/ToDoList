//
//  Category.swift
//  Todoey
//
//  Created by Галина Збитнева on 29.12.2021.

import Foundation
import RealmSwift

class Category: Object {
    @Persisted  var name: String = ""
    @Persisted  var color: String = ""
    //укажем тип взаимосвязи между Item и Category
    //эта связь -  список из элементов типа Item
    @Persisted  var items = List<Item>()
    
}
