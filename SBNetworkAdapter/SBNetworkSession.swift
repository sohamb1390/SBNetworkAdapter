//
//  SBNetworkSession.swift
//  SBNetworkAdapter
//
//  Created by Soham Bhattacharjee on 06/04/18.
//  Copyright © 2018 Soham Bhattacharjee. All rights reserved.
//

import Foundation

internal class SBNetworkSession: NSObject, URLSessionDelegate {
    static let shared = SBNetworkSession()
    var session: URLSession?
    
    private override init() {
        super.init()
        self.session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential,URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
    }
}
