//
//  Item.swift
//  Todoey
//
//  Created by Галина Збитнева on 29.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted  var title: String = ""
    @Persisted  var selection: Bool = false
    //укажем обратную связь для Item. КАждая Item имеет только одну категорию
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<Category>
    
}
