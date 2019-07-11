//
//  ViewController.swift
//  Todoey
//
//  Created by Mattia Marini on 08/07/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
   
    
    var myDictionary = [String : Bool]()
        
    var itemArray = [ItemDataModel]()
    
        let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let newItem = ItemDataModel()
        newItem.itemName = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = ItemDataModel()
        newItem2.itemName = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = ItemDataModel()
        newItem3.itemName = "Destroy Demogorgon"
        itemArray.append(newItem3)

        if let items = defaults.array(forKey: "ToDoListArray") as? [ItemDataModel] {
           itemArray = items
        }
        
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.itemName
        
        /*
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
         Ternary operator
         value = condition (if Bool, the true value is inferred, no need to specify it) ? valueIfTrue : valueIfFalse
        */
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*
         if itemArray[indexPath.row].done == true {
         itemArray[indexPath.row].done = false
         } else {
         itemArray[indexPath.row].done = true
         }
         
         set value as opposit of itself with " ! " before the value ==>
         */
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creating popup
        let alert = UIAlertController(title: "Add New Item To List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = ItemDataModel()
            newItem.itemName = textField.text!
            self.itemArray.append(newItem)

            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            //To show new cell on TableView
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //Adding Action section to popup view
        alert.addAction(action)
        
        //Showing popup
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}

