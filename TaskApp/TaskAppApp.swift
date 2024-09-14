//
//  TaskAppApp.swift
//  TaskApp
//
//  Created by Pavel Popov on 14.09.2024.
//

import SwiftUI

@main
struct TaskAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskRouter().createModule(managedObjectContext: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
