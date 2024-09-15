//
//  VipToDoerApp.swift
//  VipToDoer
//
//  Created by Pavel Popov on 06.09.2024.
//

import SwiftUI

@main
struct VipToDoerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
