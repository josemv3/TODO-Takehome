//
//  TodoDetailViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    @IBOutlet weak var todoDetailsTitleTextField: UITextField!
    @IBOutlet weak var todoDetailsTextView: UITextView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var completeBtn: UIBarButtonItem!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    
    var itemSelectedTodoList = Item()
    var completeStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        checkStatus()
        completeBtn.isEnabled = false
        todoDetailsTextView.isEditable = false
        todoDetailsTitleTextField.isUserInteractionEnabled = false
        todoDetailsTitleTextField.text = itemSelectedTodoList.title
        todoDetailsTextView.text = itemSelectedTodoList.desc
    }
    
    func checkStatus() {
        if itemSelectedTodoList.done == true {
            completeStatus = true
            statusDescriptionLabel.text = "Complete"
            statusDescriptionLabel.backgroundColor = .systemGreen
        }
    }
    
    @IBAction func editBtnTap(_ sender: UIBarButtonItem) {
        if todoDetailsTextView.isEditable == false {
            todoDetailsTextView.isEditable = true
            todoDetailsTitleTextField.isUserInteractionEnabled = true
            completeBtn.isEnabled = true
        } else {
            todoDetailsTextView.isEditable = false
            todoDetailsTitleTextField.isUserInteractionEnabled = false
            completeBtn.isEnabled = false
        }
    }
    
    @IBAction func completeBtnTap(_ sender: UIBarButtonItem) {
        if itemSelectedTodoList.done == false {
            completeStatus = true
            statusDescriptionLabel.text = "Complete"
            statusDescriptionLabel.backgroundColor = .systemGreen
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        destinationVC.editItem(title: todoDetailsTitleTextField.text ?? "", desc: todoDetailsTextView.text, status: completeStatus)
    }
}
