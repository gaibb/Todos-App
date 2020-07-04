//
//  TodosController.swift
//  Todos
//
//  Created by gaibb on 2020/7/3.
//  Copyright © 2020 gaibb. All rights reserved.
//

import UIKit
import RealmSwift

class TodosController: UITableViewController {

//    var todos = [Todo]()
    var todos: Results<Todo>?
    var row = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //从realm中取出数据
        todos = realm.objects(Todo.self)
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todos", for: indexPath) as! TodoCell

        // Configure the cell...
        if let todos = todos {
            cell.todo.text = todos[indexPath.row].name
            cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""
        } else {
            cell.todo.text = "null"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing {
            //修改数据
            if let todos = todos {
                do {
                    try realm.write({
                        todos[indexPath.row].checked = !todos[indexPath.row].checked
                    })
                } catch {
                    print(error)
                }
            }
            //更新视图
            tableView.reloadData()
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //修改数据
            do {
                try realm.write({
                    realm.delete(todos![indexPath.row])
                })
            } catch {
                print(error)
            }
            //更新视图
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TodoController
        vc.delegate = self
        if segue.identifier == "editTodo" {
            let cell = sender as! TodoCell
            vc.name = cell.todo.text
            row = tableView.indexPath(for: cell)!.row
        }
    }
    
    @IBAction func multipleDelete(_ sender: Any) {
        //modify data
        let indexPaths = tableView.indexPathsForSelectedRows
        if let indexPaths = indexPaths {
            for indexPath in indexPaths.reversed() {
//                todos.remove(at: indexPath.row)
                do {
                    try realm.write({
                        realm.delete((todos![indexPath.row]))
                    })
                } catch {
                    print(error)
                }
            }
            //update view
            tableView.beginUpdates()
            tableView.deleteRows(at: indexPaths, with: .automatic)
            tableView.endUpdates()
        }
    }
    
}

extension TodosController: TodoDelegate, UISearchBarDelegate {
    func editTodo(name: String) {
        //修改数据
        do {
            try realm.write({
                todos![row].name = name
            })
        } catch  {
            print(error)
        }
        //更新视图
        tableView.reloadData()
    }
    
    func addTodo(name: String) {
        let todo = Todo()
        todo.name = name
        saveData(todo: todo)
        tableView.reloadData()  //调用cellForRowAt方法
    }
    
    func saveData(todo: Todo) -> Void {
        do {
            try realm.write({
                realm.add(todo)
            })
        } catch  {
            print(error)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //查询数据
        todos = realm.objects(Todo.self).filter("name CONTAINS %@", searchBar.text ?? "").sorted(byKeyPath: "createTime", ascending: true)
        //更新视图
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            todos = realm.objects(Todo.self)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
