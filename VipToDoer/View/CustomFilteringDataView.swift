//
//  CustomFilteringDataView.swift
//  VipToDoer
//
//  Created by Pavel Popov on 06.09.2024.
//

import SwiftUI


struct CustomFilteringDataView<Content: View>: View {
    var content: ([Task], [Task]) -> Content
    @FetchRequest private var result: FetchedResults<Task>
    @Binding private var filterDate: Date
    init(filterData: Binding<Date>, @ViewBuilder content: @escaping ([Task], [Task]) -> Content) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: filterData.wrappedValue)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!

        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])

        _result = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)], predicate: predicate, animation: .easeInOut(duration: 0.25))

        self.content = content
        self._filterDate = filterData
    }
    var body: some View {
        content(separateTasks().0, separateTasks().1)
            .onChange(of: filterDate) { newValue in
                /// Clearing Old Predicate
                result.nsPredicate = nil

                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: newValue)
                let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
                let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])

                /// Assingning New Predicate
                result.nsPredicate = predicate
            }
    }

    func separateTasks() -> ([Task], [Task]) {
        let pendingTasks = result.filter { !$0.isCompleted }
        let completedTasks = result.filter { $0.isCompleted }

        return (pendingTasks, completedTasks)
    }
}

struct CustomFilteringDataView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
