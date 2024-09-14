//
//  TaskListView.swift
//  TaskApp
//
//  Created by Pavel Popov on 14.09.2024.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var presenter: TaskPresenter
    @State private var filterDate: Date = Date()
    @State private var showPendingTasks: Bool = true
    @State private var showCompletedTasks: Bool = true
    
    var body: some View {
        List {
            DatePicker("Select Date", selection: $filterDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: filterDate) { newValue in
                    presenter.loadTasks(for: newValue)
                }
            
            DisclosureGroup(isExpanded: $showPendingTasks) {
                if presenter.pendingTasks.isEmpty {
                    Text("No pending tasks")
                } else {
                    ForEach(presenter.pendingTasks, id: \.id) { task in
                        TaskRow(task: task) {
                            presenter.toggleTaskCompletion(task: task)
                        }
                    }
                }
            } label: {
                Text("Pending Tasks (\(presenter.pendingTasks.count))")
            }
            
            DisclosureGroup(isExpanded: $showCompletedTasks) {
                if $presenter.completedTasks.isEmpty {
                    Text("No completed tasks")
                } else {
                    ForEach($presenter.completedTasks, id: \.id) { $task in
                        TaskRow(task: task) {
                            presenter.toggleTaskCompletion(task: task)
                        }
                    }
                }
            } label: {
                Text("Completed Tasks (\(presenter.completedTasks.count))")
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    presenter.addTask(with: "New Task", date: filterDate)
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Task")
                    }
                }
            }
        }
        .onAppear {
            presenter.loadTasks(for: filterDate)
        }
    }
}

struct TaskRow: View {
    let task: TaskEntity
    var onToggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            Text(task.todo)
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}



