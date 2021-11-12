//
//  NewbieViewController.swift
//  MemoApp
//
//  Created by Hoo's MacBookAir on 2021/11/12.
//

import UIKit

class NewbieViewController: UIViewController {

	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var dismissButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
	
		contentLabel.text = "환영합니다"
		contentLabel.font = .boldSystemFont(ofSize: 20)
		contentLabel.sizeToFit()
		contentLabel.textAlignment = .center
		
		dismissButton.setTitle("확 인", for: .normal)
		dismissButton.tintColor = .white
    }
    
	@IBAction func dismissButtonClicked(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
}
