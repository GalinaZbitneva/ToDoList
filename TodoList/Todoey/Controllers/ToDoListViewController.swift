//
//  ViewController.swift
//  Todoey
//
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
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
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }
    
    //MARK: - Table view Delegate method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if let reusecell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell") {
            //переиспользуем ячейку
            cell = reusecell
        } else {
            //создаем новую ячейку
            cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        }
        
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
        //функция выполняет то,что происходит когла ячейка выбрана
        print(itemArray?[indexPath.row].title)
        
        // меняем статус элемента при нажатии его ячейки
        if itemArray?[indexPath.row].selection == false {
            itemArray?[indexPath.row].selection = true
        } else {
            itemArray?[indexPath.row].selection = false
        }
        //необходимо обновлять таблицу, чтобы обновить значение selection у выбранных items
        //те снова вызывается метод по созданию ячейки таблицы
       // tableView.reloadData(),   saveItems() уже содержит эту строку
        
        //saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            var itemForDelete = Item(context: context)
//            itemForDelete = itemArray[indexPath.row]
//            context.delete(itemForDelete)
//            itemArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            saveItems()
//        }
//    }
//
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
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
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

//extension ToDoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let searchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//
//        searchRequest.predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
//
//       // let sortDescription = NSSortDescriptor(key: "title", ascending: true)
//
//        //searchRequest.sortDescriptors = [sortDescription]
//        //две строчки заменили одной
//        searchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: searchRequest, predicate: searchRequest.predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
}
