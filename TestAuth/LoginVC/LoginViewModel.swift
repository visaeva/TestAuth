//
//  LoginViewModel.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import CryptoKit

final class LoginViewModel: NSObject {
    var currentNonce: String?
    var onSignInSuccess: (() -> Void)?
    var onSignInError: ((String) -> Void)?
    
    // MARK: - Apple Sign In
    func signInWithApple(presentingVC: UIViewController) {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = presentingVC as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle(presentingVC: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
            if let error = error {
                self?.onSignInError?("Google sign in failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.onSignInError?("Google sign in: missing auth data")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self?.onSignInError?("Firebase sign in error: \(error.localizedDescription)")
                    return
                }
                
                authResult?.user.getIDToken(completion: { [weak self] idToken, error in
                    if let error = error {
                        self?.onSignInError?("Failed to get idToken: \(error.localizedDescription)")
                        return
                    }
                    guard let idToken = idToken else {
                        self?.onSignInError?("idToken is nil")
                        return
                    }
                    
                    NetworkManager.shared.sendIdToken(idToken) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let accessToken):
                                KeychainHelper.standard.save(accessToken, service: "court360", account: "accessToken")
                                self?.onSignInSuccess?()
                            case .failure(let error):
                                self?.onSignInError?("Network error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                )
            }
        }
    }
    
    
    // MARK: - Helpers
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Apple Sign In Delegate
extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            onSignInError?("Apple sign in failed")
            return
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                self?.onSignInError?("Firebase Apple sign in error: \(error.localizedDescription)")
                return
            }
            
            authResult?.user.getIDToken(completion: { [weak self] idToken, error in
                if let error = error {
                    self?.onSignInError?("Failed to get idToken: \(error.localizedDescription)")
                    return
                }
                guard let idToken = idToken else {
                    self?.onSignInError?("idToken is nil")
                    return
                }
                
                NetworkManager.shared.sendIdToken(idToken) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let accessToken):
                            KeychainHelper.standard.save(accessToken, service: "court360", account: "accessToken")
                            self?.onSignInSuccess?()
                        case .failure(let error):
                            self?.onSignInError?("Network error: \(error.localizedDescription)")
                        }
                    }
                }
            }
            )
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onSignInError?("Apple sign in failed: \(error.localizedDescription)")
    }
}
