//
//  ViewController.swift
//  Todoey
//
//  Created by Mattia Marini on 08/07/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    lazy var realm:Realm = {
        return try! Realm()
    }()

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let hexColour = selectedCategory?.colour else {fatalError()}
            title = selectedCategory!.name
          updateNavBar(withHexCode: hexColour)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - Nav Bar Setup Methods
    
    func updateNavBar (withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.barTintColor = navBarColour
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
       
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row))/CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
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
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }

    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
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
        
//        todoItems?[indexPath.row].done = !(todoItems?[indexPath.row].done)!
        
//        saveItems(item: itemArray)
    }
    
    //MARK: - Tableview Deletion Methods
    
    override func updateModel(at indexpath: IndexPath) {
        if let cellSelected = self.todoItems?[indexpath.row] {
                        do {
                            try self.realm.write {
                                self.realm.delete(cellSelected)
                            }
                        } catch {
                            print("Error deleting row, \(error)")
                        }
                    }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creating popup
        let alert = UIAlertController(title: "Add New Item To List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = NSDate()
                        newItem.colour = UIColor.randomFlat.hexValue()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Unable to save Items, \(error)")
                }
            }
            
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
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//            } else {
//                request.predicate = categoryPredicate
//            }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data, \(error)")
//        }
        tableView.reloadData()
    }


}


//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {

    
    /*
     I'm using a dynamic search bar, so I commented out the 'search button pressed method'
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     }
    */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        } else {
            
            //create dinamic search bar, filter and sort on one line
          
            todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }

    }
}

////MARK: - Swipe cell methods

//
//
//
