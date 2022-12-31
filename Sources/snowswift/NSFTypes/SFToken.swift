//
//  File.swift
//  
//
//  Created by Carlos Suarez on 12/30/22.
//

import Foundation

struct AToken:Codable{
    var access_token:String
    var refresh_token:String
    var token_type:String
    var username:String
    var scope:String
    var expires_in:Int
    var refresh_token_expires_in:Int
    var idpInitiated:Bool
}


struct RToken:Codable{
    var access_token:String
    var token_type:String
    var expires_in:Int
    var idpInitiated:Bool
}


typealias ATokenResponse = Result<AToken, Error>
typealias RTokenResponse = Result<RToken, Error>
