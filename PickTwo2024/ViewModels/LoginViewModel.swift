//
//  ContentViewModel.swift
//  PickTwo2024
//
//  Created by Brett Walton on 2/11/24.
//

import Foundation
import SwiftUI
import CryptoKit
import FirebaseAuth

extension LoginView {
    final class ViewModel:  ObservableObject {
        static let shared: ViewModel = .init()
        
        @Published var username: String = UserDefaults.standard.string(forKey: "Username") ?? "" {
            didSet {
                UserDefaults.standard.setValue(username, forKey: "Username")
            }
        }
        
        @Published var isAuthenticated = false
        @Published var currentNonce: String = ""
        
        func loginWithFirebase(idTokenString: String) {
            guard !self.currentNonce.isEmpty else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString, rawNonce: currentNonce)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    print(error?.localizedDescription as Any)
                    return
                }
                print("signed in")
                self.isAuthenticated = true
                Task {}
            }
        }
        
        ///MARK: Encoding for Apple Login
        func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            var randomBytes = [UInt8](repeating: 0, count: length)
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
            if errorCode != errSecSuccess {
              fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
              )
            }

            let charset: [Character] =
              Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

            let nonce = randomBytes.map { byte in
              // Pick a random character from the set, wrapping around if needed.
              charset[Int(byte) % charset.count]
            }

            return String(nonce)
          }
        
        func sha256(_ input: String) -> String {
            let inputdata = Data(input.utf8)
            let hasheddata = SHA256.hash(data: inputdata)
            let hashstring = hasheddata.compactMap {
                return String(format: "%02x", $0)
            }.joined()
            
            return hashstring
        }
    }
}
