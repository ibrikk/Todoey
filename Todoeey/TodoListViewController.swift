//
//  ViewController.swift
//  Todoeey
//
//  Created by Ibrahim Khalilov on 2022-11-03.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Todos.plist")
    
    var itemsArray = [Todo]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Todo()
        newItem.title = "Load the Dishwaher"
        newItem.done = true
        itemsArray.append(newItem)
        
        let newItem2 = Todo()
        newItem2.title = "Walk the Cat"
        itemsArray.append(newItem2)
        
        let newItem3 = Todo()
        newItem3.title = "Watch TV"
        itemsArray.append(newItem3)
        
        //        if let items = defaults.array(forKey: "TodosListArray") as? [Todo] {
        //            itemsArray = items
        //        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let todo = itemsArray[indexPath.row]
        
        cell.textLabel?.text = todo.title
        
        cell.accessoryType = todo.done ? .checkmark : .none
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        
        saveItems()
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            // Alert action
            let newTodo = Todo()
            newTodo.title = textField.text!
            self.itemsArray.append(newTodo)

            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item in array \(error)")
        }
    }
    
    
    
}

