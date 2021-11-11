//
//  RealmModel.swift
//  MemoApp
//
//  Created by Hoo's MacBookAir on 2021/11/09.
//

import Foundation
import RealmSwift

class UserMemo: Object {
	@Persisted var title: String
	@Persisted var content: String
	@Persisted var date: Date
	@Persisted var pin: Bool
		
	@Persisted(primaryKey: true) var _id: ObjectId
	
	convenience init(title: String, content: String, date: Date) {
		self.init()
		
		self.title = title
		self.content = content
		self.date = date
		self.pin = false
	}
}
