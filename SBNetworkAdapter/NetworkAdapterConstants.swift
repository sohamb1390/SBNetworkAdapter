//
//  NetworkAdapterConstants.swift
//  SBNetworkAdapter
//
//  Created by Soham Bhattacharjee on 06/04/18.
//  Copyright © 2018 Soham Bhattacharjee. All rights reserved.
//

import Foundation

public typealias GenericCallBack = (_ responseData: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void

public enum HTTPMethodEnum: CustomStringConvertible {
    case get
    case post
    case patch
    case put
    case delete
    case options
    case head
    
    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .options:
            return "OPTIONS"
        case .head:
            return "HEAD"
        }
    }
}
