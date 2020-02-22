//
//  ViewController.swift
//  CoreData1
//
//  Created by Murilo Teixeira on 01/08/19.
//  Copyright © 2019 Murilo Teixeira. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.text = "username | email | password\n"
        
    }
    
    @IBAction func criar(_ sender: Any) {
        createData()
    }
    
    @IBAction func buscar(_ sender: Any) {
        retrieveData()
    }
    
    @IBAction func atualizar(_ sender: Any) {
        updateData()
    }
    
    @IBAction func deletar(_ sender: Any) {
        deleteData()
    }
    
    func createData() {
        let dataManager = DataManager()
        
        let managedContext = dataManager.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(username.text, forKey: "username")
        user.setValue(email.text, forKey: "email")
        user.setValue(password.text, forKey: "password")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Não foi possível salvar. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        let dataManager = DataManager()
        
        let managedContext = dataManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "password = %@", "1234567")
//        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: true)]
        
        textView.text = "username | email | password\n"
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                textView.text.append("\(data.value(forKey: "username") as! String) | ")
                textView.text.append("\(data.value(forKey: "email") as! String) | ")
                textView.text.append("\(data.value(forKey: "password") as! String)\n")
            }
        } catch {
            print("Falha")
        }
    }
    
    func updateData() {
        let dataManager = DataManager()
        
        let managedContext = dataManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "username = %@", username.text!)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            guard test.count > 0 else {
                print("Nao encontrado")
                return
            }
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(username.text, forKey: "username")
            objectUpdate.setValue(email.text, forKey: "email")
            objectUpdate.setValue(password.text, forKey: "password")
            do{
                try managedContext.save()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteData() {
        let dataManager = DataManager()
        
        let managedContext = dataManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "username = %@", username.text!)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            guard test.count > 0 else {
                print("Nao encontrado")
                return
            }
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do{
                try managedContext.save()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
}

