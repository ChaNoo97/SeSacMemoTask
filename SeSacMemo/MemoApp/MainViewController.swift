//
//  MainViewController.swift
//  MemoApp
//
//  Created by Hoo's MacBookAir on 2021/11/08.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
	
	//삭제 필요
	let exarr = [1,2,3,4,5]
	
	@IBOutlet weak var mainTableView: UITableView!
	@IBOutlet weak var mainToolbar: UIToolbar!
	
	@IBOutlet weak var editToolbarButton: UIBarButtonItem!
	
	let localRealm = try! Realm()
	var tasks: Results<UserMemo>!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		print("realmLocated:", localRealm.configuration.fileURL!)
		
		mainTableView.delegate = self
		mainTableView.dataSource = self
		
		let searchController = UISearchController(searchResultsController: nil)
		self.navigationItem.searchController = searchController
		
		let nibName = UINib(nibName: "MainTableViewCell", bundle: nil)
		mainTableView.register(nibName, forCellReuseIdentifier: "MainTableViewCell")
		
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .automatic
		navigationItem.title = "1212개의 메모"
		
		editToolbarButton.image = UIImage(systemName: "square.and.pencil")
		editToolbarButton.tintColor = .orange
		
    }
	
 
	@IBAction func editToolbarButtonClicked(_ sender: UIButton) {
		let sb = UIStoryboard.init(name: "Content", bundle: nil)
		guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else { return }
		
		// contentview -> mainview 오면 title 변경됨... 해결해야함
		navigationItem.title = "메모"
		
	
		self.navigationController?.pushViewController(vc, animated: true)
		
	}


}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 5
		} else {
			return 10
		}
		
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "고정된 메모"
		} else {
			return "메모"
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
		
		if indexPath.section == 0 {
			cell.titleLabel.text = "title고정"
			cell.titleLabel.font = .boldSystemFont(ofSize: 20)
			cell.contentLabel.text = "content"
			cell.dateLabel.text = "date"
			
			return cell
		} else {
			cell.titleLabel.text = "title"
			cell.titleLabel.font = .boldSystemFont(ofSize: 20)
			cell.contentLabel.text = "content"
			cell.dateLabel.text = "date"
		
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else {return}
		header.textLabel?.font = .boldSystemFont(ofSize: 20)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 35
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 75
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let section = indexPath.section
//		let row = indexPath.row
		
		if section == 0 {
			let cancelPin = UIContextualAction(style: .normal, title: nil) { (cancelPin, view, completionHandler) in
				print("\(indexPath) canclepin")
			}
			cancelPin.image = UIImage(systemName: "pin.slash.fill")
			cancelPin.backgroundColor = .orange
			
			return UISwipeActionsConfiguration(actions: [cancelPin])
		} else {
			let pin = UIContextualAction(style: .normal, title: nil) { (pinAction, view, completionHandler) in
				if self.exarr.count == 5 {
					let alert = UIAlertController(title: "죄송합니다.", message: "무료버전은 5개밖에 고정되지 않아요 ㅜ.ㅜ \n월 1990원으로 프리미엄 혜택을 누려보세요!", preferredStyle: .alert)
					
					let cancle = UIAlertAction(title: "cancle", style: .cancel) { action in
						//cnacle handler
					}
					
					alert.addAction(cancle)
					
					self.present(alert, animated: true, completion: nil)

				} else {
					print("\(indexPath) pin")
				}
				
			}
			pin.image = UIImage(systemName: "pin.fill")
			pin.backgroundColor = .orange
	
			return UISwipeActionsConfiguration(actions: [pin])
		}
	}
}
