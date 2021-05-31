//
//  DatabaseManager.swift
//  MessengerApp
//
//  Created by Марк Голубев on 31.05.2021.
//

import Foundation
import Firebase

final class DatatbaseManager {
    
    static let shared = DatatbaseManager()
    
    private let database = Database.database().reference()
    
}

// MARK: - Account Managment

extension DatatbaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(true)
                return
            }
            completion(false)
        })
    }
    
    /// Insert new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "email_address": user.emailAddress
        ])
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
//    let profilePictureUrl: String
}
