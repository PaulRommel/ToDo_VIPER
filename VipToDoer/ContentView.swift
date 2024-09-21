//
//  ContentView.swift
//  VipToDoer
//
//  Created by Pavel Popov on 06.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("V.t.D")
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
    
