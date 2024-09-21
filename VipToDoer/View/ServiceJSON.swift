//
//  TodoService.swift
//  VipToDoer
//
//  Created by Pavel Popov on 17.09.2024.
//

import Foundation

struct ToDo: Codable, Identifiable {
    
    enum CodingKeys: CodingKey {
        case id
        case todo
        case completed
        case userId
    }
    
    let id = UUID()
    let todo: String
    let completed: Bool
    let userId: Int
}

class ServiceJSON: ObservableObject {
    @Published var listJSON = [ToDo]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        
        let urlString = "https://dummyjson.com/todos"
        guard let url = URL(string: urlString) else { print("json not found"); return }
        
        let data = try? Data(contentsOf: url)
        let listJSON = try? JSONDecoder().decode([ToDo].self, from: data!)
        
        self.listJSON = listJSON!
    }
}

