//
//  TaskPresenter.swift
//  TaskApp
//
//  Created by Pavel Popov on 14.09.2024.
//

import Foundation

protocol TaskPresenterProtocol: ObservableObject {
    var pendingTasks: [TaskEntity] { get }
    var completedTasks: [TaskEntity] { get }
    func loadTasks(for date: Date)
    func addTask(with title: String, date: Date)
    func toggleTaskCompletion(task: TaskEntity)
    func deleteTask(task: TaskEntity)
}

class TaskPresenter: TaskPresenterProtocol {
    @Published var pendingTasks: [TaskEntity] = []
    @Published var completedTasks: [TaskEntity] = []
    
    private let interactor: TaskInteractorProtocol
    
    init(interactor: TaskInteractorProtocol) {
        self.interactor = interactor
    }
    
    func loadTasks(for date: Date) {
        let (pending, completed) = interactor.fetchTasks(for: date)
        self.pendingTasks = pending
        self.completedTasks = completed
    }
    
    func addTask(with title: String, date: Date) {
        interactor.addTask(with: title, date: date)
        loadTasks(for: date)
    }
    
    func toggleTaskCompletion(task: TaskEntity) {
        interactor.toggleTaskCompletion(task: task)
        loadTasks(for: task.date)
    }
    
    func deleteTask(task: TaskEntity) {
        interactor.deleteTask(task: task)
        loadTasks(for: task.date)
    }
}

