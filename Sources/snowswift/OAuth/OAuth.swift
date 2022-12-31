//
//  File.swift
//  
//
//  Created by Carlos Suarez on 12/30/22.
//

import Foundation

func getToken(endpoint:String, code:String, credencial:OauthCredencial) async -> Result<AToken,Error> {
  
    let tokenUrl = URL(string: credencial.serviceUrl!.absoluteString + endpoint)!
    
    var postRequest = URLRequest(url:tokenUrl)
    var response:Result<AToken,Error>
    let decoder = JSONDecoder()
    
    
    let clientSecret =  SingleBase64(credencial.clientId! + ":" + credencial.secret!)
    
    postRequest.addValue("Basic " + clientSecret, forHTTPHeaderField: "Authorization")
    postRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let bodi = "grant_type=authorization_code&redirect_uri=" + encodeStr(credencial.redirectUri!.absoluteString) + "&code=" + code
    
    let postData = bodi.data(using: .utf8)
    postRequest.httpMethod = "POST"
    postRequest.httpBody = postData
    
    do{
        let (data, _) = try await URLSession.shared.data(for: postRequest, delegate: nil)
        //let datos = String(data: data, encoding: .utf8)!
        //print(datos)
        let json = try decoder.decode(AToken.self, from: data)
        response = .success(json)
    }catch(let err) {
        print("Error getToken")
        response = .failure(err)
    }
    
    return response
}



func refreshToken(endPoint:String, refreshTokenFromDB:String, credencial:OauthCredencial) async -> RTokenResponse{
    let tokenUrl = URL(string: credencial.serviceUrl!.absoluteString + endPoint)!
    
    var postRequest = URLRequest(url:tokenUrl)
    var response:RTokenResponse
    let decoder = JSONDecoder()
    
    
    let clientSecret =  SingleBase64(credencial.clientId! + ":" + credencial.secret!)
    
    postRequest.addValue("Basic " + clientSecret, forHTTPHeaderField: "Authorization")
    postRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let bodi = "grant_type=refresh_token&refresh_token=" + encodeStr(refreshTokenFromDB)
    let postData = bodi.data(using: .utf8)
    postRequest.httpMethod = "POST"
    postRequest.httpBody = postData
    
    do{
        let (data, _) = try await URLSession.shared.data(for: postRequest, delegate: nil)
        
        //let datos = String(data: data, encoding: .utf8)!
        //print(datos)
        
        let json = try decoder.decode(RToken.self, from: data)
        response = .success(json)
    }catch(let err) {
        print("Error getToken")
        response = .failure(err)
    }
    return response
}
