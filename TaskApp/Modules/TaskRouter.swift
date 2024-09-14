//
//  TaskRouter.swift
//  TaskApp
//
//  Created by Pavel Popov on 14.09.2024.
//

import SwiftUI
import CoreData

class TaskRouter {
    func createModule(managedObjectContext: NSManagedObjectContext) -> some View {
        let interactor = TaskInteractor(managedObjectContext: managedObjectContext)
        let presenter = TaskPresenter(interactor: interactor)
        return TaskListView(presenter: presenter)
    }
}
