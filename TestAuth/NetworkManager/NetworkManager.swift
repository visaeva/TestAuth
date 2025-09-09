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
        print("Отправляем idToken на бэкенд: \(idToken.prefix(10))...")
        
        guard let url = URL(string: "https://api.court360.ai/rpc/client") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
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
            completion(.failure(NetworkError.invalidRequestBody(error)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.transportError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.emptyResponse))
                return
            }
            
            if let raw = String(data: data, encoding: .utf8) {
                print("Raw backend response: \(raw)")
            }
            
            do {
                let decoded = try JSONDecoder().decode(BackendResponse.self, from: data)
                let accessToken = decoded.result.accessToken
                print("✅AccessToken получен от бэкенда: \(accessToken.prefix(10))...")
                completion(.success(accessToken))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidRequestBody(Error)
    case transportError(Error)
    case invalidResponse
    case serverError(statusCode: Int)
    case emptyResponse
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL"
        case .invalidRequestBody(let error): return "Ошибка формирования запроса: \(error.localizedDescription)"
        case .transportError(let error): return "Сетевая ошибка: \(error.localizedDescription)"
        case .invalidResponse: return "Некорректный ответ от сервера"
        case .serverError(let code): return "Сервер вернул ошибку \(code)"
        case .emptyResponse: return "Сервер вернул пустой ответ"
        case .decodingError(let error): return "Ошибка декодирования ответа: \(error.localizedDescription)"
        }
    }
}
