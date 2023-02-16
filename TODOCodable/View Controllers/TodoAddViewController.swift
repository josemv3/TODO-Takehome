//
//  TodoAddViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit
import RealmSwift

protocol TodoAddViewControllerDelegate: AnyObject {
    func todoAddViewControllerDidDismiss(_ viewController: TodoAddViewController)
}

class TodoAddViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var todoAddTextView: UITextView!
    @IBOutlet weak var todoAddTitleTextField: UITextField!
    
    weak var delegate: TodoAddViewControllerDelegate?
    private let realm = try! Realm()
    private var newTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New"
        todoAddTextView.delegate = self
        todoAddTextView.text = "Tap here to write details..."
        todoAddTextView.textColor = UIColor.lightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        didDismiss()
        print("Bye AddVC")
    }
    
    func didDismiss() {
        delegate?.todoAddViewControllerDidDismiss(self)
    }
    
    //MARK: - Prepare user with placholder text
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tap here to write details..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func createNewItem() {
        let newItem = Item()
        newItem.title = todoAddTitleTextField.text ?? "Blank"
        newItem.desc = todoAddTextView.text
        let currentDate = dateFormatter(itemDate: newItem.dateActual)
        newItem.date = currentDate[0]
        newItem.time = currentDate[1]

        do {
            try realm.write {
                realm.add(newItem)
            }
        } catch {
            print("Error encoding item array\(error)")
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        createNewItem()
        self.dismiss(animated: true, completion: nil)
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
    
    //MARK: - Segue/Dismiss
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destinationVC = segue.destination as! TodoListViewController
    }
    
    @IBAction func cancelBtnTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

