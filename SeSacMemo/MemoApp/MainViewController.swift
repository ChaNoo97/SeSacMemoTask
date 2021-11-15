//
//  MainViewController.swift
//  MemoApp
//
//  Created by Hoo's MacBookAir on 2021/11/08.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
	
	@IBOutlet weak var mainTableView: UITableView!
	@IBOutlet weak var mainToolbar: UIToolbar!
	
	@IBOutlet weak var editToolbarButton: UIBarButtonItem!
	
	let localRealm = try! Realm()
	
	var unPinTasks: Results<UserMemo>!
	var pinTasks: Results<UserMemo>!
	var Tasks: Results<UserMemo>!
	
	var filterTasks: Results<UserMemo>!
	
	let searchController = UISearchController(searchResultsController: nil)
	
	var searchedText: String = ""
	
	let firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
	
	class FirstLaunch {
		let wasLaunchedBefore: Bool
		var isFirstLaunch: Bool { return !wasLaunchedBefore }
		init(getWasLaunchedBefore: () -> Bool,
			 setWasLaunchedBefore: (Bool) -> ()) {
			let wasLaunchedBefore = getWasLaunchedBefore()
			self.wasLaunchedBefore = wasLaunchedBefore
			if !wasLaunchedBefore {
				setWasLaunchedBefore(true)
			}
		}
		convenience init(userDefaults: UserDefaults, key: String) { self.init(getWasLaunchedBefore: { userDefaults.bool(forKey: key) }, setWasLaunchedBefore: { userDefaults.set($0, forKey: key) })
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		print("realmLocated:", localRealm.configuration.fileURL!)
		
		unPinTasks = localRealm.objects(UserMemo.self).filter("pin == %@", false)
		pinTasks = localRealm.objects(UserMemo.self).filter("pin == %@",true)
		Tasks = localRealm.objects(UserMemo.self)
		
		
		
		
		mainTableView.delegate = self
		mainTableView.dataSource = self
		
		self.navigationItem.searchController = searchController
		
		let nibName = UINib(nibName: "MainTableViewCell", bundle: nil)
		mainTableView.register(nibName, forCellReuseIdentifier: "MainTableViewCell")
		
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .automatic
		
		editToolbarButton.image = UIImage(systemName: "square.and.pencil")
		editToolbarButton.tintColor = .orange
		
		
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Memo"
		definesPresentationContext = true
		
		if firstLaunch.isFirstLaunch {
			guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewbieViewController") as?
					NewbieViewController else {return}
			vc.modalPresentationStyle = .fullScreen
			present(vc, animated: true, completion: nil)
			
		}

		
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		
		mainTableView.reloadData()
		navigationItem.title = "\(Tasks.count)개의 메모"
	}
	
 
	@IBAction func editToolbarButtonClicked(_ sender: UIButton) {
		let sb = UIStoryboard.init(name: "Content", bundle: nil)
		guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else { return }
		
		navigationItem.title = "메모"
		vc.newContentIdentifier = true
		self.navigationController?.pushViewController(vc, animated: true)
		
	}


}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print(isFiltering())
		
		if isFiltering() {
			if section == 1 {
				return filterTasks.count
			} else {
				return 0
			}
		} else {
			if section == 0 {
				return pinTasks.count
			} else {
				return unPinTasks.count
			}
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "고정된 메모"
		} else {
			if isFiltering() {
				return "\(filterTasks.count)검색"
			} else {
				return "메모"
			}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy.MM.dd a hh시mm분"
		dateFormatter.locale = Locale(identifier: "ko-KR")
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
		
		if indexPath.section == 0 {
			
			let row = pinTasks[indexPath.row]
			print(row)
			let convertDate = dateFormatter.string(from: row.date)
			
			cell.titleLabel.text = row.title
			cell.titleLabel.font = .boldSystemFont(ofSize: 20)
			cell.contentLabel.text = row.content
			cell.dateLabel.text = convertDate
			
			if !isFiltering() {
				cell.titleLabel.textColor = UIColor.init(named: "myColor")
			}
			return cell
		} else if indexPath.section == 1 {
			if isFiltering() {
				let row: UserMemo
				row = filterTasks[indexPath.row]
				let convertDate = dateFormatter.string(from: row.date)
				cell.titleLabel.highlight(searchText: searchController.searchBar.text!)
				cell.titleLabel.text = row.title
				cell.dateLabel.text = convertDate
				cell.contentLabel.text = row.content
			} else {
				let row = unPinTasks[indexPath.row]
				let convertDate = dateFormatter.string(from: row.date)
				cell.titleLabel.text = row.title
				cell.titleLabel.font = .boldSystemFont(ofSize: 20)
				cell.contentLabel.text = row.content
				cell.dateLabel.text = convertDate
			}
		}
		if !isFiltering() {
			cell.titleLabel.textColor = UIColor.init(named: "myColor")
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			let row = pinTasks[indexPath.row]
			let sb = UIStoryboard.init(name: "Content", bundle: nil)
			guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else {return}
			vc.text = "\(row.title)"+"\n\(row.content)"
			vc.comeMemo = pinTasks[indexPath.row]
			navigationItem.title = "메모"
			self.navigationController?.pushViewController(vc, animated: true)
		} else if indexPath.section == 1{
			if isFiltering() {
				let row = filterTasks[indexPath.row]
				let sb = UIStoryboard.init(name: "Content", bundle: nil)
				guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else {return}
				vc.text = "\(row.title)"+"\n\(row.content)"
				vc.comeMemo = filterTasks[indexPath.row]
				navigationItem.title = "검색"
				self.navigationController?.pushViewController(vc, animated: true)
			} else {
				let row = unPinTasks[indexPath.row]
				let sb = UIStoryboard.init(name: "Content", bundle: nil)
				guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else {return}
				vc.text = "\(row.title)"+"\n\(row.content)"
				vc.comeMemo = unPinTasks[indexPath.row]
				navigationItem.title = "메모"
				self.navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else {return}
		header.textLabel?.font = .boldSystemFont(ofSize: 20)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if pinTasks.count == 0 && section == 0 {
			return 0
		}
		
		if isFiltering() {
			return 0
		}
		
		return 35
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 75
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let section = indexPath.section
		
		if isFiltering() {
			let row = filterTasks[indexPath.row]
			if row.pin {
				let cancelPin = UIContextualAction(style: .normal, title: nil) { (cancelPin, view, completionHandler) in
					try! self.localRealm.write {
						row.pin.toggle()
					}
					tableView.reloadData()
				}
				cancelPin.image = UIImage(systemName: "pin.slash.fill")
				cancelPin.backgroundColor = .orange
				
				return UISwipeActionsConfiguration(actions: [cancelPin])
			} else {
				let pin = UIContextualAction(style: .normal, title: nil) { (pinAction, view, completionHandler) in
					if self.pinTasks.count == 5 {
						let alert = UIAlertController(title: "죄송합니다.", message: "무료버전은 5개밖에 고정되지 않아요 ㅜ.ㅜ \n월 1990원으로 프리미엄 혜택을 누려보세요!", preferredStyle: .alert)
						
						let cancle = UIAlertAction(title: "cancel", style: .cancel) { [self] action in
							self.mainTableView.reloadData()
						}
						
						alert.addAction(cancle)
						
						self.present(alert, animated: true, completion: nil)

					} else {
						try! self.localRealm.write {
							row.pin.toggle()
						}
						tableView.reloadData()
					}
				}
				pin.image = UIImage(systemName: "pin.fill")
				pin.backgroundColor = .orange
		
				return UISwipeActionsConfiguration(actions: [pin])
			}
		} else {
				if section == 0 {
					let cancelPin = UIContextualAction(style: .normal, title: nil) { (cancelPin, view, completionHandler) in
						let pinRow = self.pinTasks[indexPath.row]
						try! self.localRealm.write {
							pinRow.pin.toggle()
						}
						tableView.reloadData()
					}
					cancelPin.image = UIImage(systemName: "pin.slash.fill")
					cancelPin.backgroundColor = .orange
					
					return UISwipeActionsConfiguration(actions: [cancelPin])
				} else {
					let row = self.unPinTasks[indexPath.row]
					let pin = UIContextualAction(style: .normal, title: nil) { (pinAction, view, completionHandler) in
						if self.pinTasks.count == 5 {
							let alert = UIAlertController(title: "죄송합니다.", message: "무료버전은 5개밖에 고정되지 않아요 ㅜ.ㅜ \n월 2990원으로 프리미엄 혜택을 누려보세요!", preferredStyle: .alert)
							
							let cancle = UIAlertAction(title: "cancel", style: .cancel) { action in
								self.mainTableView.reloadData()
							}
							
							alert.addAction(cancle)
							
							self.present(alert, animated: true, completion: nil)

						} else {
							try! self.localRealm.write {
								row.pin.toggle()
							}
							tableView.reloadData()
						}
					}
					pin.image = UIImage(systemName: "pin.fill")
					pin.backgroundColor = .orange
			
					return UISwipeActionsConfiguration(actions: [pin])
				}
			}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		let section = indexPath.section
		if isFiltering() {
			if section == 1 {
				let row = filterTasks[indexPath.row]
				try! localRealm.write {
					localRealm.delete(row)
				}
				//삭제하는 섹션만 리로드 가능 (reload.section)
				mainTableView.reloadData()
			}
		} else {
			if section == 0 {
				let row = pinTasks[indexPath.row]
				try! localRealm.write {
					localRealm.delete(row)
				}
			} else {
				let row = unPinTasks[indexPath.row]
				try! localRealm.write {
					localRealm.delete(row)
				}
			}
			mainTableView.reloadData()
		}
		navigationItem.title = "\(Tasks.count)개의 메모"
	}
	
	func searchBarIsEmpty() -> Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	func filterContentForSearchText(_ searchText: String, scope: String = "All") {
		searchedText = searchText
		filterTasks = localRealm.objects(UserMemo.self).filter("title CONTAINS[c] %@",searchText)
		mainTableView.reloadData()
	}
	
	func isFiltering() -> Bool {
		return searchController.isActive && !searchBarIsEmpty()
	}
	
}

extension MainViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	}
	
	
}

extension UILabel {
  
	func highlight(searchText: String, color: UIColor = .orange) {
		guard let labelText = self.text else { return }
		do {
			let mutableString = NSMutableAttributedString(string: labelText)
			let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
			
			for match in regex.matches(in: labelText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: labelText.utf16.count)) as [NSTextCheckingResult] {
				mutableString.addAttribute(.foregroundColor, value: color, range: match.range)
			}
			self.attributedText = mutableString
		} catch {
			print(error)
		}
	}
}

