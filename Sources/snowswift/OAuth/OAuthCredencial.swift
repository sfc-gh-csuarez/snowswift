//
//  File.swift
//  
//
//  Created by Carlos Suarez on 12/30/22.
//

import Foundation

public class OauthCredencial:NSObject {
    
    override init() {
        super.init()
     }
     public var serviceUrl: URL?
     public var redirectUri: URL?
     public var clientId: String?
     public var secret: String?
     public var credName: String?
     public var id: UUID?
     public var responseType: String?
     public var token: Token?

}

extension OauthCredencial : Identifiable {}
