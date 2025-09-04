//
//  KeychainHelper.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import Foundation
import Security

final class KeychainHelper {
    static let standard = KeychainHelper()
    
    func save(_ value: String, service: String, account: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecValueData as String   : data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data,
              let string = String(data: data, encoding: .utf8)
        else { return nil }
        return string
    }
}
