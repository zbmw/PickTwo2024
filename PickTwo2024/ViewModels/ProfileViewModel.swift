//
//  ProfileViewModel.swift
//  PickTwo2024
//
//  Created by Brett Walton on 3/9/24.
//

import Foundation
import SwiftUI

extension ProfileView {
    final class ViewModel: ObservableObject {
        static let shared: ViewModel = .init()
        
        @EnvironmentObject var loginVM: LoginView.ViewModel
        var username: String? {
            get {
                let value = UserDefaults.standard.string(forKey: "Username")
                return value
            }
        }
    
    }
}
