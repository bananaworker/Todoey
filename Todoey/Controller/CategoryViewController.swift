//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Muzafar on 30/01/2019.
//  Copyright © 2019 Muzafar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories entered yet"
        
        return cell

    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! ToDoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }

    }
    
    //MARK: - TableView Manipulation Methods (CRUD)
    
    func save(category : Category){
        
        try! realm.write {
            realm.add(category)
        }
        
        self.tableView.reloadData()
    }
    
    func loadData (){

        categories = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a category to ToDoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            // This is what happens when the user clicks ok on the Add Item UIAlert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
