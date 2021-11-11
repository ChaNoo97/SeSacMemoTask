//
//  ContentViewController.swift
//  MemoApp
//
//  Created by Hoo's MacBookAir on 2021/11/09.
//

import UIKit
import RealmSwift

class ContentViewController: UIViewController {

	@IBOutlet weak var contentTextView: UITextView!
	
	let localRealm = try! Realm()
	
	var text: String? = nil
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let text = text {
			contentTextView.text = text
		} else {
			contentTextView.text = ""
		}
		
		contentTextView.becomeFirstResponder()
		
		let shareButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
		shareButton.image = UIImage(systemName: "square.and.arrow.up")
		let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonClicked(_:)))
		
		navigationItem.setRightBarButtonItems([finishButton,shareButton], animated: true)
		
		navigationController?.navigationBar.tintColor = .orange
		
		 
    }
	
	func realmSave() {
		let memoTitle: String
		let memoContent: String
		let date = Date()
		let splitText = contentTextView.text.split(separator: "\n", maxSplits: 1)
		if splitText.isEmpty {
			//pop and delete
			print("empty")
			return
		} else if splitText.count == 1 {
			//only title and only content 구분 x ㅠㅠ
			print("1")
			memoTitle = String(splitText[0])
			memoContent = ""
		} else {
			print("2")
			memoTitle = String(splitText[0])
			memoContent = String(splitText[1])
 		}
		
		let task = UserMemo(title: memoTitle, content: memoContent, date: date)
		
		
		try! localRealm.write {
			localRealm.add(task)
		}
		
	}
	
	@objc func finishButtonClicked(_ sender: UIBarButtonItem) {
		realmSave()
		print(#function)
	}
	
}

