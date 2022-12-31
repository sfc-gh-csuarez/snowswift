//
//  File.swift
//  
//
//  Created by Carlos Suarez on 12/30/22.
//

import Foundation
import Crypto
import Security



func base64Url(desde base64:String) -> String{
    let base64url = base64
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
    return base64url
}



func signer_old(data:Data, secret:String) -> String{
   let keyData = secret.data(using: .utf8)!
   let key = SymmetricKey(data: keyData)
   let signedString =  HMAC<SHA256>.authenticationCode(for: data, using: key)
   let signed = Data(signedString).base64EncodedData()
    return  base64Url(desde: signed.base64EncodedString())
    
    
}


func signer(a:String, secret:String) -> String{
       //base64 header.payload
       let part1 = a.data(using: .utf8)!
       //key
       let keyData = secret.data(using: .utf8)!
       let key = SymmetricKey(data: keyData)
       //sign
       let signed = HMAC<SHA256>.authenticationCode(for: part1, using: key)
       let a = Data(signed)
       return base64Url(desde:a.base64EncodedString())
}



func RS256Signer(a:String, secret:String)  -> String {
    
    //base64 header.payload
    let headerPayload = a.data(using: .utf8)!
    //key secet was decoded using openSSL - openssl pkcs8 -nocrypt -in rsa_key.p8 -outform der -out key.der
    
    //let privateKeyData = Data(base64Encoded: secret)!

    let privateKeyData = Data.init(base64Encoded: secret)!
    
    let Seckey = SecKeyCreateWithData(privateKeyData as NSData, [
        kSecAttrKeyType: kSecAttrKeyTypeRSA,
        kSecAttrKeyClass: kSecAttrKeyClassPrivate,
    ] as NSDictionary, nil)
    //sign SecKeyAlgorithm.rsaSignatureMessagePKCS1v15SHA256
    var error: Unmanaged<CFError>?
    guard let signedData = SecKeyCreateSignature(Seckey!, SecKeyAlgorithm.rsaSignatureMessagePKCS1v15SHA256, headerPayload as CFData, &error) as Data? else{
        print(error.debugDescription)
        return "NONE"
    }
        
    return   base64Url(desde: signedData.base64EncodedString())
    
}






private func sanitize(key: String) -> String {
    let headerRange = key.range(of: "-----BEGIN PUBLIC KEY-----")
    let footerRange = key.range(of: "-----END PUBLIC KEY-----")
    
    var sanitizedKey = key
    
    if let headerRange = headerRange, let footerRange = footerRange {
      let keyRange = Range<String.Index>(uncheckedBounds: (lower: headerRange.upperBound, upper: footerRange.lowerBound))
      sanitizedKey = String(key[keyRange])
    }
    
    return sanitizedKey
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: "\n")
      .joined()
  }












func joinValues(part1:String, part2:String)->String {
    return part1 + "." + part2
}



func convetidorB64URL<T:Codable>(_ a:T) -> String{
    
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        do{
            let j = try encoder.encode(a.self)
            return  base64Url(desde:j.base64EncodedString())
        }catch {
            fatalError("Encode Failed")
        }
}





func tiempoExpiration() -> Int{
    return Int(Date().timeIntervalSince1970 + 5*60)
}


func tiempoIssued() -> Int{
    return Int(Date().timeIntervalSince1970)
}


//https://stackoverflow.com/questions/43052657/encode-using-urlcomponents-in-swift
func encodeURL(host:URL, endpoint:String, params:[String:String]) -> URL?{
    var authUrl = URLComponents(url:host, resolvingAgainstBaseURL: true)!
    authUrl.scheme = "https"
    authUrl.path = endpoint
    var cs = CharacterSet.urlQueryAllowed
    cs.remove("+")
    cs.remove("=")
    authUrl.percentEncodedQuery =
    params.compactMap{
        
        if $0 == "redirect_uri"{
            return $0 + "=" + $1.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        } else{
            return $0 + "=" + $1.addingPercentEncoding(withAllowedCharacters: cs)!
        }
        
    }.joined(separator: "&")
    return authUrl.url
}




func buildURL(host:String, endpoint:String, params:[String:String]) -> URL?{
    var tokenUrl = URLComponents(url: URL(string: host)!, resolvingAgainstBaseURL: true)!
    tokenUrl.scheme = "https"
    tokenUrl.host = host
    tokenUrl.path = endpoint
    var cs = CharacterSet.urlQueryAllowed
    cs.remove(":")
    cs.remove("/")
    cs.remove("_")
    tokenUrl.percentEncodedQuery = params.compactMap{
        return $0 + "=" + $1.addingPercentEncoding(withAllowedCharacters: cs)!
    }.joined(separator: "&")
    return tokenUrl.url
}



func SingleBase64(_ str:String) -> String{
    let encodedPayload = str.data(using: .utf8)!.base64EncodedString()
    return encodedPayload
}


func encodeStr(_ str:String) -> String {
    var cs = CharacterSet.urlQueryAllowed
    cs.remove("+")
    cs.remove("=")
    cs.remove(":")
    cs.remove("/")
    return str.addingPercentEncoding(withAllowedCharacters: cs)!
}




func clientIdFromURL(url:String) -> String{
let prefix = "https://"
    if url.hasPrefix(prefix){
        let p1 = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: false)?.host
        print(p1!)
        return p1!
        
    }
    return "none"
}


