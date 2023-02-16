//
//  Item.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var desc: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateActual: Date = Date() //added prop - used Realm merg
    @Persisted var date: String = ""
    @Persisted var time: String = ""
}
