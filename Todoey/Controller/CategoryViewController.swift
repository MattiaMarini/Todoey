//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mattia Marini on 13/07/2019.
//  Copyright © 2019 Mattia Marini. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try  context.save()
        } catch {
            print("Error saving category, \(error)")
        }
       tableView.reloadData()
    }
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            try categories = context.fetch(request)
        } catch  {
            print("Error fetching category, \(error)")
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text
            
            self.categories.append(newCategory)
            self.saveCategories()
    
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Inserisci Categoria"
            textfield = alertTextField
        }
        
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
        
    }
  

    
    
}
