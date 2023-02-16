//
//  ViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController, TodoAddViewControllerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Do, Try, Catch in AppDelegate. Docs say after initial unwrap Realm call wont fail.
    //Force unwrap is safe.
    private let realm = try! Realm()
    
    //Switched from <Results>? to [Item]
    private var todoItems: [Item] = []
    
    private var segmentedControlSelected: String {
        if segmentedControl.selectedSegmentIndex == 0 {
            return  "open"
        } else {
            return "complete"
        }
    }
    
    private var itemSelectedIndex: Int? {
        tableView.indexPathForSelectedRow?.row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    func todoAddViewControllerDidDismiss(_ viewController: TodoAddViewController) {
        loadItems()
        tableView.reloadData()
        print("AddVC dismissed in delegate")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ListVC")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("bye ListVC")
    }
    
    //MARK: - TableView swipe action
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if self.segmentedControlSelected != "open" {
            //stops swipe return below. This removes the swipe for completed TODOs
            return nil
        }
        
        let complete = UIContextualAction(style: .destructive, title: "Complete!") { _, _, _ in
            
            tableView.beginUpdates()
            let todoToUpdate = self.todoItems[indexPath.row]
            try! self.realm.write {
                todoToUpdate.done = true
            }
            self.loadItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
        complete.backgroundColor = .systemGreen
        let swipe = UISwipeActionsConfiguration(actions: [complete])
        return swipe
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath) as! TodoListCell
        
        let item = todoItems[indexPath.row]
        cell.mainLabel.text = item.title
        cell.detailLabel.text = item.desc
        cell.detailLabel.numberOfLines = 2
        cell.dateLabel.text = item.date + item.time
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goTodoDetail", sender: self)
    }
    
    //MARK: - Item CRUD to Realm
    
    func loadItems() {
        let completed = segmentedControlSelected == "complete"
        todoItems = realm.objects(Item.self).where {
            $0.done == completed
        }
        .sorted(byKeyPath: "dateActual", ascending: false)
        .map({ $0 }) //map creates an array of the items sorted by date.
        tableView.reloadData()
    }
    
    func editItem(title: String, desc: String, status: Bool) {
        //FIRST FIX for ItemSelected change to computed prop
        guard let itemSelectedIndex else {
            assertionFailure()
            return
        }
        
        let todoToUpdate = todoItems[itemSelectedIndex]
        
        do{
            try realm.write {
                todoToUpdate.title = title
                todoToUpdate.desc = desc
                todoToUpdate.done = status
                todoToUpdate.dateActual = Date()
                let currentDate = dateFormatter(itemDate: todoToUpdate.dateActual)
                todoToUpdate.date = currentDate[0]
                todoToUpdate.time = currentDate[1]
            }
        } catch {
            print("Error encoding item array\(error)")
        }
        loadItems()
    }
    
    //MARK: - Segmented controller
    
    @IBAction func segmentedControlTap(_ sender: UISegmentedControl) {
        loadItems()
        tableView.reloadData()
    }
    
    func dateFormatter(itemDate: Date) -> [String] { //Could move to utilities file
        let currentDate =  itemDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle     = .short
        dateFormatter.timeStyle     = .short
        dateFormatter.locale        = Locale(identifier: "en_US")
        let newDate = dateFormatter.string(from: currentDate).components(separatedBy: ",")
        return newDate
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTodoDetail" {
            guard let itemSelectedIndex else {
                assertionFailure()
                return
            }
                
            let item = todoItems[itemSelectedIndex]
            
            let destinationVC = segue.destination as! TodoDetailViewController
            destinationVC.itemSelectedTodoList = item
        } else if segue.identifier == "goTodoAdd" {
            let destinationVC = segue.destination as! UINavigationController
            let addVC = destinationVC.visibleViewController as! TodoAddViewController
            addVC.delegate = self
        }
    }
    
    @IBAction func unwindTodoListViewController(unwindSegue: UIStoryboardSegue) {
    }
}





//Extra

//          Move this to segue, but it resulted in error
//          deselecting was stoping item from being grabed and sent to detailVC

//            if let indexPath = tableView.indexPathForSelectedRow {
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
