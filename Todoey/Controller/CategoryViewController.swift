//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Muzafar on 30/01/2019.
//  Copyright © 2019 Muzafar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [CategoryForItems]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name

//        let category = categoryArray[indexPath.row]

        return cell

    }
    

    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! ToDoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }

    }
    
    
    //MARK: - TableView Manipulation Methods (CRUD)
        
    
    func saveData(){
        
        do {
            try context.save()
        } catch {
            print("Error saving context is \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadData (with request: NSFetchRequest<CategoryForItems> = CategoryForItems.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context is \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a category to ToDoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            // This is what happens when the user clicks ok on the Add Item UIAlert
            
            let newCategory = CategoryForItems(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
