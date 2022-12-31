//
//  File.swift
//  Procolos for define Snowflake Auth and Cert values
//
//  Created by Carlos Suarez on 12/30/22.
//

import Foundation

public protocol SFHeader:Encodable{
     var alg:String { get }
     var typ:String { get }
    
}

public protocol SFPayload:Encodable{
    var aud:String { get }
    var iat:Int { get }
    var exp:Int { get }
    var iss:String { get }
    var scp:[String] {get}
}


public protocol SFPayloadCert:Encodable{
    var sub:String { get }
    var iat:Int { get }
    var exp:Int { get }
    var iss:String { get }
}


public protocol SFSignature{
    var header:String {get}
    var payload:String {get}
    func sign(secret:String) -> String
}


public protocol SFAssertion{
    var key:String {get}
    var secret:String {get}
    func buildJot() -> String
}


public protocol AuthResponse:Codable{
    var code:String {get}
    var scope:[String] {get}
    
}


public protocol SFEncodable64{
    func encode64Url() -> String
}

