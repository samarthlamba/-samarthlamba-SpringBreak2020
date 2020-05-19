//
//  jsonFileTableViewController.swift
//  sb202021
//
//  Created by Hugh Thomas on 3/10/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class myCustomTodoCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoSwitch: UISwitch!
}

class jsonFileTableViewController: UITableViewController {

    
    //var allTodos:[String:String] = [:]
    var allTodos: [Todo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // let jsonData = JSONBlob.data(using: .utf8)!
        // get the JSON from the internet
        
        let mySession = URLSession(configuration: URLSessionConfiguration.default)

        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        
        let task = mySession.dataTask(with: url) { data, response, error in

        // ensure there is no error for this HTTP response
        guard error == nil else {
            print ("error: \(error!)")
            return
        }

        // ensure there is data returned from this HTTP response
        guard let jsonData = data else {
            print("No data")
            return
        }
        
        print("Got the data from network")
            
        // decode the JSON
        do {
            self.allTodos = try JSONDecoder().decode([Todo].self, from: jsonData)
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        catch {
            print("Error JSON Decode failed \(error)")
        }
        
        }
        
        task.resume()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTodos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTodoCell", for: indexPath) as! myCustomTodoCell

        // Configure the cell...

        cell.todoLabel.text = allTodos[indexPath.row].title
        cell.todoSwitch.isOn = allTodos[indexPath.row].completed
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    struct Todo: Decodable {
        let userId: Int
        let id: Int
        let title: String
        let completed: Bool
    }
    
}
