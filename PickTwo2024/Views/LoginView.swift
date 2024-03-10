//
//  ContentView.swift
//  PickTwo2024
//
//  Created by Brett Walton on 2/11/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var viewModel: ViewModel = .shared
    @State private var usernameEditing: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.username.isEmpty || usernameEditing {
                Text("Welcome to \nPick Two 2024")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                TextField("Enter your name...", text: $viewModel.username)
                .onTapGesture {
                    usernameEditing = true
                }
                .onSubmit {
                    if viewModel.username.count >= 4 {
                        usernameEditing = false
                    } else {
                        //TODO: Handle invalid Username
                        print("Too Short")
                    }
                }
                .multilineTextAlignment(.center)
                
            } else {
                Text("Welcome back to the \nPick Two 2024, \(viewModel.username)!")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Please Login with your Apple ID")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                Button("Reset", action: {
                    UserDefaults.standard.removeObject(forKey: "Username")
                    viewModel.username = ""
                })
                SignInWithAppleButton(.signIn) { request in
                    viewModel.currentNonce = viewModel.randomNonceString()
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = viewModel.sha256(viewModel.currentNonce)
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            
                            guard let appleIDToken = appleIDCredential.identityToken else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            
                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                return
                            }
                            
                            viewModel.loginWithFirebase(idTokenString: idTokenString)
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 60, height: 80)
                
            }
            Spacer()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginView().viewModel)
}
