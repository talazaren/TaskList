//
//  StorageManager.swift
//  TaskList
//
//  Created by Tatiana Lazarenko on 3/30/24.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    var taskList: [ToDoTask] = []
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        print(context.hasChanges)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() {
        let fetchRequest = ToDoTask.fetchRequest()
        
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    func save(_ taskName: String) {
        let task = ToDoTask(context: persistentContainer.viewContext)
        task.title = taskName
        taskList.append(task)
        
        saveContext()
    }
    
    func delete(_ indexPath: Int) {
        let task = taskList[indexPath]
        taskList.remove(at: indexPath)
        persistentContainer.viewContext.delete(task)
        
        saveContext()
    }
    
    func edit(_ indexPath: Int, taskName: String) {
        let task = taskList[indexPath]
        task.title = taskName
        
        saveContext()
    }
}
