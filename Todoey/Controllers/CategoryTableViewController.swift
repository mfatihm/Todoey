//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by fatih maytalman on 8.01.2019.
//  Copyright © 2019 fatih maytalman. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "no category yet"
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "FFFFFF")
        
        if let color = cell.backgroundColor{
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        //print(UIColor.randomFlat.hexValue())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.category = categoryArray?[indexPath.row]
            }
            
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text != ""{
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                //self.categoryArray.append(newCategory)
                
                self.saveCategories(category: newCategory)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "pleaase type new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: tableview datasource methods
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        //        do{
//            try categoryArray = context.fetch(request)
//        }catch{
//            print("Error occured in loading, \(error)")
//        }
    }
    
    func saveCategories(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error in saving catregory, \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        if let deletedCategory = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deletedCategory)
                }
            }catch{
                print("Error in delete catregory, \(error)")
            }
        }
    }
}
