//
//  ViewController.swift
//  Todoey
//
//  Created by fatih maytalman on 3.01.2019.
//  Copyright © 2019 fatih maytalman. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category: Category?{
        didSet{
           loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        //print(dataFilePath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let color = category?.color{
            title = category!.name
            searchBar.barTintColor = UIColor(hexString: color)
            updateNavBar(hexForm: color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let originalColor = #colorLiteral(red: 1, green: 0.5352332592, blue: 0.8550300002, alpha: 1)
        
        updateNavBar(hexForm: originalColor.hexValue())
    }
    //MARK: NavBar Setup Methods
    func updateNavBar(hexForm color: String){
        guard let navBar = navigationController?.navigationBar else{fatalError("navigation controller doesnot exist")}
        
        if let navBarColor = UIColor(hexString: color){
            navBar.barTintColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.check == true ? .checkmark : .none
            if let color = UIColor(hexString: category!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
        else{
            cell.textLabel?.text = "no items added yet"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.check = !item.check
                }
            }catch{
                print("Error on update item, \(error)")
            }
        }
        tableView.reloadData()
        //        context.delete(itemArray[indexPath.row])
//
//        itemArray.remove(at: indexPath.row)
   //     let item = todoItems?[indexPath.row].check = !itemArray?[indexPath.row].check ?? false
  //      saveItems(item)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new item to the list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                if let selectedCategory = self.category{
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            selectedCategory.items.append(newItem)
                        }
                    }catch{
                        print("Error in saving catregory, \(error)")
                    }
                }
                
                self.tableView.reloadData()
                
                //category
//                newItem.parentCategory = self.category
//                self.itemArray.append(newItem)
                
                //self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "pleaase type new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
//        func saveItems(category: Category){
//
//            do{
//                try realm.write {
//                    realm.add(category)
//                }
//            }catch{
//                print("Error in saving catregory, \(error)")
//            }
//    //        do{
//    //            try context.save()
//    //        } catch{
//    //            print("Error encoding item array, \(error)")
//    //        }
//            tableView.reloadData()
//
//        }
    
    func loadItems(){
        todoItems = category?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath){
        if let deletedItem = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deletedItem)
                }
            }catch{
                print("Error in delete catregory, \(error)")
            }
        }
    }
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
