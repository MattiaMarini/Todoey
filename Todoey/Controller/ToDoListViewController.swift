//
//  ViewController.swift
//  Todoey
//
//  Created by Mattia Marini on 08/07/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var myDictionary = [String : Bool]()
        
    var itemArray : [Item] = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Do any additional setup after loading the view.

        loadItems()
        
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
         to delete objects frome CoreData, we first remove the object from the array, in order to reload the table view with the deletion apparent.
         secondly, we give the command context.delete in order to delete the obj from the database itself (if I just remove it from the array, I will have deleted the obj just from the context, not the databese, so at the next launch it will reappear)
        */
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        /*
         if itemArray[indexPath.row].done == true {
         itemArray[indexPath.row].done = false
         } else {
         itemArray[indexPath.row].done = true
         }
         
         set value as opposit of itself with " ! " before the value ==>
         */
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creating popup
        let alert = UIAlertController(title: "Add New Item To List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
        
            let newItem = Item(context: self.context)
            newItem.itemName = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)

           self.saveItems()
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
    
    func saveItems() {
    
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data, \(error)")
        }
        tableView.reloadData()
    }

}


//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        /*
         original code, I changed it with dinamic code:
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate  = NSPredicate(format: "itemName CONTAINS [cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        loadItems(with: request)
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data, \(error)")
        }
         */
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
    
        } else {
            //create dinamic search bar
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate  = NSPredicate(format: "itemName CONTAINS [cd] %@", searchBar.text!)
            
            
            request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
            
            loadItems(with: request)
        }
        
    }
}
