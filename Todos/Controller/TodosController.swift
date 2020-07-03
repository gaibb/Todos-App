//
//  TodosController.swift
//  Todos
//
//  Created by gaibb on 2020/7/3.
//  Copyright © 2020 gaibb. All rights reserved.
//

import UIKit

class TodosController: UITableViewController {

    var todos = [
        Todo(name: "eating dinner", checked: false),
        Todo(name: "sleeping for 6 hours", checked: false),
        Todo(name: "playing LOL", checked: false)
    ]
    var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if let data = UserDefaults.standard.data(forKey: "todos") {
            do {
                todos = try JSONDecoder().decode([Todo].self, from: data)
            } catch  {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todos", for: indexPath) as! TodoCell

        // Configure the cell...
        cell.todo.text = todos[indexPath.row].name
        cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing {
            todos[indexPath.row].checked = !todos[indexPath.row].checked
            let cell = tableView.cellForRow(at: indexPath) as! TodoCell
            cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""
            tableView.deselectRow(at: indexPath, animated: true)
            saveData()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            saveData()
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let todo = todos.remove(at: fromIndexPath.row)
        todos.insert(todo, at: to.row)
        tableView.moveRow(at: fromIndexPath, to: to)
        saveData()
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
        let indexPaths = tableView.indexPathsForSelectedRows
        if let indexPaths = indexPaths {
            for indexPath in indexPaths {
                todos.remove(at: indexPath.row)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: indexPaths, with: .automatic)
            tableView.endUpdates()
            saveData()
        }
    }
    
}

extension TodosController: TodoDelegate {
    func editTodo(name: String) {
        todos[row].name = name
        let indexPath = IndexPath(row: row, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! TodoCell
        cell.todo.text = name
        saveData()
    }
    
    func addTodo(name: String) {
        todos.append(Todo(name: name, checked: false))
        saveData()
        let indexPath = IndexPath(row: todos.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func saveData() -> Void {
        do {
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        } catch {
            print(error)
        }
    }
}
