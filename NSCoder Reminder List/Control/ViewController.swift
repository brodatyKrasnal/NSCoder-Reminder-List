//
//  NSCoder Reminder List : ViewController.swift by tymek on 01/09/2020 21:23.
//  Copyright © 2020  Tymon Golęba Frygies. All rights reserved.


import UIKit

class NSCoderVC: UITableViewController {
    
    var notes = [Note]()
    
    let dataLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("NSCoderReminderList")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataLocation!)
        loadData()
        notes.count == 0 ? welcomeAlert() : loadData()
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].name
        cell.accessoryType = notes[indexPath.row].completion == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notes[indexPath.row].completion = !notes[indexPath.row].completion
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        saveItems()
    }
    
    
    //MARK: - Adding new items
    @IBAction func addNewItem(_ sender: Any) {
        var textPopup = UITextField()
        let popup = UIAlertController(title: "Add new", message: "Add new item to the list", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add item", style: .default) { (addAction) in
            let newItem = Note()
            newItem.name = textPopup.text!
            self.notes.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        
        popup.addTextField { (textInput) in
            textInput.placeholder = "Add new item to the list"
            textInput.textAlignment = .center
            textPopup = textInput
        }
        
        popup.addAction(add)
        popup.addAction(cancel)
        
        present(popup, animated: true)
    }
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.notes)
            try data.write(to: self.dataLocation!)
        } catch {
            print("Error while encoding data: \(error)")
        }
    }
    
    func loadData () {
        
        if let data = try? Data(contentsOf: dataLocation!) {
            let decoder = PropertyListDecoder()
            do {
                notes = try decoder.decode([Note].self, from: data)
            } catch {
                print("Error while decodingd data: \(error)")
            }
        }
        tableView.reloadData()
    }
    
    func welcomeAlert () {
        
        let messageAlert = UIAlertController (title: "No items yet!", message: "There's nothing here yet. Add some items to the list =) ", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        messageAlert.addAction(action)
        present(messageAlert, animated: true, completion: nil)
    }
    
}

