//
//  MiniC02App.swift
//  MiniC02
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/23.
//

import SwiftUI

@main
struct MiniC02App: App {
	
	@StateObject private var viewModel = ViewModel()
	var eventC = EventCRU()
	
    var body: some Scene {
        WindowGroup {
            HomeView()
				  .environment(\.managedObjectContext, CoreDataController.shared.viewContext)
				  .environmentObject(viewModel)
				  .environmentObject(eventC)
        }
    }
}
