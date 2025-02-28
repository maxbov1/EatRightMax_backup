//
//  HeaderView.swift
//  eatRight
//
//  Created by Nicolas Boving on 10/13/24.
//
import SwiftUI

struct HeaderView: View {
	@Binding var showingProfile: Bool
	@Binding var selectedTab: Tab
	@Binding var showingMyMeals: Bool

	var switchToFavorites: () -> Void
	var switchToMyMeals: () -> Void

	var body: some View {
		VStack {
			ZStack {
				// Background with seamless color transition
				LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.blue.opacity(0.3)]),
							   startPoint: .topLeading, endPoint: .bottomTrailing)
					.ignoresSafeArea(edges: .top)
					.frame(height: 80) // Adjust height for the logo area

				// Text logo overlaying the background
				Text("Eat")
					.font(.system(size: 36, weight: .bold, design: .serif))
					.foregroundColor(Color.green.opacity(0.7)) // Muted green for "Eat"
					+
				Text("Right")
					.font(.system(size: 36, weight: .bold, design: .serif))
					.foregroundColor(Color.orange.opacity(0.7)) // Muted orange for "Right"
					.italic() // Italicize "Right"

			}

			// Tabs HStack including Profile in one long box, with vertical separators
			HStack(spacing: 0) {
				// Tab Buttons
				Group {
					// Tab: Home
					createTabButton(title: "Home", tab: .home) {
						selectedTab = .home
						showingMyMeals = false // Hide My Meals view
					}

					Divider() // Vertical divider between tabs

					// Tab: Favorites
					createTabButton(title: "Favorites", tab: .favorites) {
						switchToFavorites() // Switch to Favorites tab
						showingMyMeals = false // Hide My Meals view when switching
					}

					Divider() // Vertical divider between tabs

					// Tab: My Meals
					createTabButton(title: "My Meals", tab: .myMeals) {
						selectedTab = .myMeals // Directly set selectedTab to myMeals
						showingMyMeals = false // Ensure My Meals view is displayed properly
					}
				}

				// Profile button with adjusted size and positioning
				Button(action: {
					showingProfile.toggle()
				}) {
					Image(systemName: "person.circle.fill")
						.resizable()
						.frame(width: 40, height: 40) // Adjust size as needed
						.foregroundColor(.green)
				}
				.padding(.leading, 10) // Adjusted padding to center
				.sheet(isPresented: $showingProfile) {
					ProfileView(showingProfile: $showingProfile) // Pass binding to ProfileView
						.onDisappear {
							// Reset state when dismissing
							showingMyMeals = false // Ensure My Meals is hidden when ProfileView is dismissed
							selectedTab = .home // Optionally switch back to home when profile is closed
						}
				}
			}
			.frame(maxHeight: 40) // Make the long box match the vertical lines height
			.background(Color.white)
			.cornerRadius(10)
			.shadow(radius: 5)

			Divider()
				.background(Color.green.opacity(0.7)) // Match the divider color to the background
		}
	}

	// Function to create tab buttons
	private func createTabButton(title: String, tab: Tab, action: @escaping () -> Void) -> some View {
		Button(action: {
			action()
		}) {
			Text(title)
				.frame(maxWidth: .infinity)
				.padding()
				.foregroundColor(.green) // Set all tab titles to green
				.background(selectedTab == tab ? Color.white : Color.clear)
				.cornerRadius(5)
		}
	}
}

// Preview for HeaderView
struct HeaderView_Previews: PreviewProvider {
	@State static var showingProfile: Bool = false
	@State static var selectedTab: Tab = .home
	@State static var showingMyMeals: Bool = false

	static var previews: some View {
		HeaderView(
			showingProfile: $showingProfile,
			selectedTab: $selectedTab,
			showingMyMeals: $showingMyMeals,
			switchToFavorites: {},
			switchToMyMeals: {}
		)
		.previewLayout(.sizeThatFits)
		.padding()
	}
}
