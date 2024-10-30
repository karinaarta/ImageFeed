//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by karine pankova on 29.10.2024.
//


import Foundation

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let authTokenKey = "accesToken"

    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: authTokenKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: authTokenKey)
                    
            }
        }
    }



