//
//  ViewController.swift
//  Todoey
//
//  Created by fatih maytalman on 3.01.2019.
//  Copyright © 2019 fatih maytalman. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "kill bill"
        let newItem2 = Item()
        newItem2.title = "hello"
        itemArray.append(newItem2)
        
        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.check == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].check = !itemArray[indexPath.row].check
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    // MARK: Add new item to the list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                let newItem = Item()
                newItem.title = textField.text!
                print(newItem.title)
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "pleaase type new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error deoding item array, \(error)")
            }
            
        }
    }
}


