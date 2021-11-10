//
//  ContentViewController.swift
//  MemoApp
//
//  Created by Hoo's MacBookAir on 2021/11/09.
//

import UIKit

class ContentViewController: UIViewController {

	@IBOutlet weak var contentTextView: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		contentTextView.becomeFirstResponder()
		contentTextView.text = "안녕하세요"
		
		let shareButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
		shareButton.image = UIImage(systemName: "square.and.arrow.up")
		let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
		
		navigationItem.setRightBarButtonItems([finishButton,shareButton], animated: true)
		
		navigationController?.navigationBar.tintColor = .orange
		
		 
    }

	
}

