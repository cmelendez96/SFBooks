//
//  ViewController.swift
//  SFBooks
//
//  Created by Chris Melendez on 12/7/20.
//  Copyright © 2020 Chris Melendez. All rights reserved.
//

import RealmSwift
import UIKit


class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet var table: UITableView!
    
    private var data = [ToDoListItem]()
    private let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = realm.objects(ToDoListItem.self).map({$0})
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return data.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        // Open the screen where we can see item info and dleete
        let item = data[indexPath.row]

        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
            return
        }

        vc.item = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
  
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }

        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "New Item"
         vc.navigationItem.largeTitleDisplayMode = .never
         navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.reloadData()
    }
    
    @IBDesignable class MyButton: UIButton
    {
        override func layoutSubviews() {
            super.layoutSubviews()

            updateCornerRadius()
        }

        @IBInspectable var rounded: Bool = false {
            didSet {
                updateCornerRadius()
            }
        }

        func updateCornerRadius() {
            layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        }
    }


}