//
//  TaskInteractor.swift
//  TaskApp
//
//  Created by Pavel Popov on 14.09.2024.
//

import CoreData

protocol TaskInteractorProtocol {
    func fetchTasks(for date: Date) -> ([TaskEntity], [TaskEntity])
    func addTask(with title: String, date: Date)
    func toggleTaskCompletion(task: TaskEntity)
    func deleteTask(task: TaskEntity)
}

class TaskInteractor: TaskInteractorProtocol {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func fetchTasks(for date: Date) -> ([TaskEntity], [TaskEntity]) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as CVarArg, endOfDay as CVarArg)

        do {
            let tasks = try managedObjectContext.fetch(request)
            let pendingTasks = tasks.filter { !$0.isCompleted }.map { TaskEntity(id: $0.id!, todo: $0.todo ?? "", date: $0.date ?? Date(), isCompleted: $0.isCompleted) }
            let completedTasks = tasks.filter { $0.isCompleted }.map { TaskEntity(id: $0.id!, todo: $0.todo ?? "", date: $0.date ?? Date(), isCompleted: $0.isCompleted) }
            return (pendingTasks, completedTasks)
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            return ([], [])
        }
    }
    
    func addTask(with title: String, date: Date) {
        let task = Task(context: managedObjectContext)
        task.id = UUID()
        task.todo = title
        task.date = date
        task.isCompleted = false
        saveContext()
    }
    
    func toggleTaskCompletion(task: TaskEntity) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        if let fetchedTask = try? managedObjectContext.fetch(request).first {
            fetchedTask.isCompleted.toggle()
            saveContext()
        }
    }
    
    func deleteTask(task: TaskEntity) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        if let fetchedTask = try? managedObjectContext.fetch(request).first {
            managedObjectContext.delete(fetchedTask)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}

