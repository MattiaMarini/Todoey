//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mattia Marini on 13/07/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {

    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try  realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
       tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
    }
    
    //MARK: - Data Deletion Method
    
    override func updateModel(at indexpath: IndexPath) {
        if let cellSelected = self.categories?[indexpath.row] {
                            do {
                                try self.realm.write {
                                    self.realm.delete(cellSelected)
                                }
                            } catch {
                                print("Error deleting row, \(error)")
                            }
                        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            
            self.save(category: newCategory)
    
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Inserisci Categoria"
            textfield = alertTextField
        }
        
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
        
    }

}
