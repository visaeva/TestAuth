//
//  NetworkManager.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    struct BackendResponse: Codable {
        struct Result: Codable {
            let accessToken: String
            struct Me: Codable {
                let id: Int
                let name: String
            }
            let me: Me
        }
        let jsonrpc: String
        let result: Result
        let id: Int
    }
    
    func sendIdToken(_ idToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.court360.ai/rpc/client") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "auth.firebaseLogin",
            "params": ["fbIdToken": idToken],
            "id": 1
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response"])))
                return
            }
            if let raw = String(data: data, encoding: .utf8) {
                print("Raw backend response: \(raw)")
            }
            do {
                let decoded = try JSONDecoder().decode(BackendResponse.self, from: data)
                let accessToken = decoded.result.accessToken
                completion(.success(accessToken))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
