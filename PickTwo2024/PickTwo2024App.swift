//
//  PickTwo2024App.swift
//  PickTwo2024
//
//  Created by Brett Walton on 2/11/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct PickTwo2024App: App {
    
    // AppDelegate Init
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var loginVM = LoginView.ViewModel()
    @StateObject var profileVM = ProfileView.ViewModel()
    @State var username: String?

    var body: some Scene {
        WindowGroup {
            if !loginVM.isAuthenticated {
                LoginView(viewModel: loginVM)
                    .environmentObject(profileVM)
            } else {
                ProfileView(viewModel: profileVM)
                    .environmentObject(loginVM)
            }
        }
    }
}
