//
//  File.swift
//  
//
//  Created by Carlos Suarez on 12/30/22.
//

import Foundation

public class Token:NSObject {
    
    override init() {
        super.init()
    }
    
    public var accessToken: String?
    public var refreshToken: String?
    public var tokenType: String?
    public var username: String?
    public var scope: String?
    public var expiresIn: Int16 = 0
    public var refreshTokenExpires: Int16 = 0
    public var idpInitiated: Bool = false
    public var id: UUID?
    public var name: String?
    public var credencial: OauthCredencial?
    
}


extension Token : Identifiable {}
