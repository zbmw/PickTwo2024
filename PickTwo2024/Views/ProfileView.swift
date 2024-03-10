//
//  MainView.swift
//  PickTwo2024
//
//  Created by Brett Walton on 3/9/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ViewModel = .shared
    var body: some View {
        Text("Hello, \(viewModel.username ?? "Yaba")")
    }
}

#Preview {
    ProfileView()
        .environmentObject(ProfileView().viewModel)
}
