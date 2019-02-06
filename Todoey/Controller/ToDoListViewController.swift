//
//  ViewController.swift
//  Todoey
//
//  Created by Muzafar on 13/01/2019.
//  Copyright © 2019 Muzafar. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    let realm = try! Realm()

    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"

        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        if let item = toDoItems?[indexPath.row] {
                do {
                    try realm.write {
                        item.done = !item.done
                    }
                } catch {
                    print("Error updating realm data is \(error)")
                }
        }
        
        self.tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    
    //MARK: - Add new categories
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add an item to ToDoey", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        // This is what happens when the user clicks ok on the Add Item UIAlert

            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)                    }
                } catch {
                    print("Error saving items \(error)")
                }
            }

            self.tableView.reloadData()

        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }

    
    func loadData (){

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }
}

//MARK: - Extension of class. Deals with SearchBar

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text!.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
