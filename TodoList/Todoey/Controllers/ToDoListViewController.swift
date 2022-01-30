//
//  ViewController.swift
//  Todoey
//
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    
    //срабатывает при загрузке страницы
    var selectedCategory: Category? {
        didSet {
            print("items загрузка по категории")
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }
    
    //MARK: - Table view Delegate method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
           
            if item.selection == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
                //перезапишем используя тернарный оператор
               // cell.accessoryType = item.selection == true ? .checkmark : .none
            //или даже так
                //cell.accessoryType = item.selection ? .checkmark : .none
            }
        } else {
            cell.textLabel?.text = "No items there"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row]{
            do {
                try realm.write({
                    item.selection = !item.selection
                })
            } catch {
                print ("Error saving selection status \(error)")
            }
        }
        tableView.reloadData()
        //функция выполняет то,что происходит когла ячейка выбрана
        //print(itemArray?[indexPath.row].title)
        
        // меняем статус элемента при нажатии его ячейки
        //if itemArray?[indexPath.row].selection == false {
       //     itemArray?[indexPath.row].selection = true
//        } else {
//            itemArray?[indexPath.row].selection = false
//        }
        //необходимо обновлять таблицу, чтобы обновить значение selection у выбранных items
        //те снова вызывается метод по созданию ячейки таблицы
       // tableView.reloadData(),   saveItems() уже содержит эту строку
        
        //saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func updateData(at indexPath: IndexPath) {
        if let itemForDelete = itemArray?[indexPath.row]{
            do{
                try realm.write({
                    realm.delete(itemForDelete)
                })
            } catch {
                print("Can't delete the item \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: - Add new items
    
    @IBAction func addNewTaskButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавьте новую задачу", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
            if (textField.text != " "  && textField.text != nil) {

                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write({
                            let userItem = Item()
                            userItem.title = textField.text!
                            userItem.dataCreated = Date()
                            currentCategory.items.append(userItem)
                        })
                    } catch {
                        print("ERROR when tried save data \(error)")
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Новая задача"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
        
    
    func loadItems(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "dataCreated", ascending: true)
        tableView.reloadData()
    }
}
    
    
//MARK: - Additional methods
    
//    func saveItems(){
//        do {
//            try context.save()
//        } catch {
//            print ("ОШИБКА!!! \(error)")
//        }
//        self.tableView.reloadData()
//    }
//
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        //selectedCategory мы получили из segue
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        // делаем проверку что входящий предикат не нил. И если он не нил то предикат будет составной из двух
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do{
//            itemArray = try context.fetch(request)
//        } catch {
//            print ("error is \(error)")
//        }
//        tableView.reloadData()
//    }
   
//}

//MARK: - Serach bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
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
