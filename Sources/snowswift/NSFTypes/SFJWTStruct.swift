//
//  File.swift
//  
//
//  Created by Carlos Suarez on 12/30/22.
//

import Foundation


struct JWTHeaderCert:SFHeader,SFEncodable64,Codable {
    var alg: String
    var typ: String
    
    init(alg:String, typ:String) {
        self.alg = alg
        self.typ = typ
    }
    
    func encode64Url() -> String {
         return convetidorB64URL(self)
    }
}

struct Payload:SFPayload, SFEncodable64, Codable{
    var aud: String
    var iat: Int = tiempoIssued()
    var exp: Int = tiempoExpiration()
    var iss: String
    var scp: [String]
    
    func encode64Url() -> String {
        return convetidorB64URL(self)
    }
}


struct JWTPayloadCert:SFPayloadCert, SFEncodable64,Codable{
    var sub: String
    var iat: Int
    var exp: Int
    var iss: String
    
    func encode64Url() -> String {
        return convetidorB64URL(self)
    }
}



struct Signature:SFSignature{
    var header: String
    var payload: String

    func sign(secret: String) -> String {
        let preSign = self.header + "." + self.payload
       return signer(a: preSign, secret: secret)
    }
}


struct JWTSignatureCert:SFSignature{
    var header: String
    var payload: String

    func sign(secret: String) -> String {
        let preSign = self.header + "." + self.payload
        return  RS256Signer(a: preSign, secret: secret)

    }

}
