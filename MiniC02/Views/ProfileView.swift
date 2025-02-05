
//
//  ProfileView.swift
//  MiniC02
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 04/10/23.
//

import SwiftUI
import UIKit

struct ProfileView: View {
	
	@EnvironmentObject var vm : ViewModel
	@EnvironmentObject var eventC : EventCRU
	@Environment(\.dismiss) private var dismiss
	
	@State var yourEventsList: [EventModel] = []
	
	@State var sheetIsPresented = false
	@State var editProfileSheetIsOpened: Bool = false
	@State var deleteAccountButton = false
	
	@State var goesToDeleteView = false
	@State var isTryingToDeleteProfile = false
	
	@State var recadastrarSheetIsPresented = false
	
	@State var columns: [GridItem] = [
		GridItem(.adaptive(minimum: 150, maximum: 550)),
		GridItem(.adaptive(minimum: 150, maximum: 550)),
		GridItem(.adaptive(minimum: 150, maximum: 550)),
		GridItem(.adaptive(minimum: 150, maximum: 550))
	]
	
	let acctags = [""]
	let hobbytags = [""]
	
	let profilePicNames: [String]
	@Binding var isInPFPNames: Bool
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		NavigationStack {
			ZStack {
				
				Image(colorScheme == .light ? "blackgreenblob" : "whitegreenblob")
					.resizable()
					.scaledToFit()
					.frame(width: 80)
					.position(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.12)
				
				Image(colorScheme == .light ? "blackyellowstar" : "whiteyellowstar")
					.resizable()
					.scaledToFit()
					.frame(width: 100)
					.position(x: UIScreen.main.bounds.width - 30, y: UIScreen.main.bounds.height * 0.23)
				
				Image(colorScheme == .light ? "blackpeachsemicircleprofileiconpicture" : "whitepeachsemicircleprofileiconpicture")
					.resizable()
					.scaledToFit()
					.frame(height: 140)
					.position(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.35)
				
				Image(colorScheme == .light ? "blackleaf" : "whiteleaf")
					.resizable()
					.scaledToFit()
					.frame(width: 72)
					.position(x: UIScreen.main.bounds.width - 20, y: UIScreen.main.bounds.height * 0.50)
				
				ScrollView {
					VStack(alignment: .leading) {
						
						header
						
						identification
							.padding(.bottom)
						
						yourEvents
						
					}
					.padding(.horizontal, 28)
					
					
				}
				.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						backButton
					}
					
					ToolbarItem(placement: .topBarTrailing) {
						NavigationLink {
							SavedEventsView()
						} label: {
							Image(systemName: "bookmark")
								.foregroundStyle(Color("NewPeach"))
						}
						
					}
					
					ToolbarItem(placement: .topBarTrailing) {
						sheetViewButton
					}
				}
				.alert("Tem certeza que deseja continuar?", isPresented: $deleteAccountButton) {
					Button("Cancelar", role: .cancel) { }
					
					Button("Deletar conta", role: .destructive) {
						isTryingToDeleteProfile = true
					}
					
					
				}
				
				NavigationLink(isActive: $isTryingToDeleteProfile) {
					DeleteConfirmationView(recadastrarSheetIsPresented: $recadastrarSheetIsPresented)
				} label: {
					EmptyView()
				}
				
				//			.onAppear {
				//				UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .red
				//			}
				
			}
		}
		.background(
			Color("NewHomeBackground")
		)
		.navigationBarBackButtonHidden(true)
		
		
		.sheet(isPresented: $sheetIsPresented) {
			ProfileSheetView( deleteAccountButton: $deleteAccountButton, editProfileSheetIsOpened: $editProfileSheetIsOpened)
				.presentationDetents([.fraction(0.3)])
		}
		.sheet(isPresented: $editProfileSheetIsOpened) {
			EditProfileSheetView()
		}
		
		.fullScreenCover(isPresented: $recadastrarSheetIsPresented) {
			CadastroView(sheetIsPresented: $recadastrarSheetIsPresented)
		}
		
		
		
		
		
	}
}


extension ProfileView {
	
	private var header: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .top) {
				
				Image(systemName: "person")
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 100)
					.foregroundStyle(Color("NewPurple"))
				
				VStack(alignment: .leading) {
					Text(vm.profiles[0].name ?? "User")
						.font(.custom("SF Pro", size: 35))
						.bold()
					
					Text("@" + (vm.profiles[0].username ?? "user"))
						.foregroundStyle(.secondary)
				}
			}
		}
	}
	
	private var identification: some View {
		VStack(alignment: .leading) {
			Text("Identificação")
				.font(.custom("SF Pro", size: 20))
				.bold()
				.padding(.top, 53)
			
			ForEach(vm.profiles) { profile in
				ForEach(profile.tags) { tag in
					Text(tag.name ?? "laur")
						.padding(.horizontal)
						.padding(.vertical, 5)
						.background(Color("NewPeach"))
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.foregroundStyle(.white)
						.padding(.trailing, 8)
				}
			}
		}
	}
	
	private var yourEvents: some View {
		VStack(alignment: .leading, spacing: -5) {
			HStack {
				Text("Meus Eventos")
					.font(.custom("SF Pro", size: 20))
					.bold()
					.padding(.top, 26)
					.onAppear {
						yourEventsList = []
						for event in eventC.events {
							if event.hostname == vm.profiles[0].username {
								yourEventsList.append(event)
							}
						}
					}
				Spacer()
			}
			
			ForEach(yourEventsList) { event in
				EventCard(event: event, onYourProfile: true)
					.padding(.vertical)
			}
		}
	}
	
	private var backButton: some View {
		Button(action: {
			dismiss()
		}, label: {
			HStack {
				Image(systemName: "chevron.left")
				Text("Início")
			}
			.foregroundStyle(Color("NewPeach"))
		})
	}
	
	private var sheetViewButton: some View {
		Button(action: {
			sheetIsPresented.toggle()
		}) {
			Image(systemName: "ellipsis")
				.foregroundStyle(Color("NewPeach"))
		}
	}
}
