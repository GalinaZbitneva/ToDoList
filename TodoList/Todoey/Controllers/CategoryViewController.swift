//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Галина Збитнева on 15.12.2021.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        tableView.rowHeight = 80.0

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No categories added"
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            var categoryForDelete = categoryArray?[indexPath.row]
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        }
//    }
   // MARK: - tableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert =  UIAlertController(title: "Новая категория", message: "Укажите имя новой категории", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if (textField.text != "" && textField.text != " ") {
                let newCategory = Category()
                newCategory.name = textField.text!
                
                self.saveCategory(category: newCategory)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add your category"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
   
    
    func saveCategory(category: Category){
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print ("ОШИБКА!!! \(error)")
        }
        self.tableView.reloadData()
    }
   
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateData(at indexPath: IndexPath) {
        if let categoryForDelete = self.categoryArray?[indexPath.row] {
            
            do{
                try self.realm.write({
                    realm.delete(categoryForDelete.items)
                    realm.delete(categoryForDelete)
                })
            } catch {
                print ("Error for delete \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}



