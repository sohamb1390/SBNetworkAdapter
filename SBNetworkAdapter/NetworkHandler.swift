//
//  NetworkHandler.swift
//  SBNetworkAdapter
//
//  Created by Soham Bhattacharjee on 06/04/18.
//  Copyright © 2018 Soham Bhattacharjee. All rights reserved.
//

import Foundation

open class NetworkHandler: NSObject {
    
    // MARK: - Variables
    var url: URL
    var parameterData: Data?
    var headerParameter: [String: String]
    var timeOutInterval: Double
    var shouldUseCache: Bool
    var httpMethod: HTTPMethodEnum
    
    // MARK: - Initialisation
    /**
     Initilizer of NetworkHandler class
     - parameters:
        - url: A valid URL instance
        - parameterData: A Data instance which will be wrapped in httpBody while sending the API Request. (optional)
        - headerParameter: A Dictionary which contains the header parameter information.
        - shouldUseCache: A Boolean variable which indicates whether to user cache or not while sending the API request.
        - timeOutInterval: A Double variable which indicates the time after which the request should be cancelled/invalidated if some network issue appears.
        - method: An HTTPMethodEnum type variable which indicates the protocol, the request should follow. The value of this variable could be any of the following: post, get, patch, put, delete, options, head
     - returns:
     NULL
     */
    public init(withURL url: URL,
                parameterBody parameterData: Data?,
                header headerParameter: [String: String],
                cachePolicy shouldUseCache: Bool = false,
                interval timeOutInterval: Double = 10.0,
                httpMethod method: HTTPMethodEnum = .post) {
        
        // Initialise all the properties
        self.url = url
        self.parameterData = parameterData
        self.headerParameter = headerParameter
        self.timeOutInterval = timeOutInterval
        self.shouldUseCache = shouldUseCache
        self.httpMethod = method
        
        super.init()
    }
    
    // MARK: - Public Methods
    /**
     Public intreface to hit the designated API
     - parameters:
        - onCompletion: Returns a callback with all the API response i.e (_ responseData: Data?, _ urlResponse: URLResponse?, _ error: Error?)
     
     - returns:
     NULL
     */
    public func triggerAPI(onCompletion: @escaping GenericCallBack) {
        
        // Create attribute tupple
        let attributes = (url: self.url, shouldUseCache: self.shouldUseCache, timeOutInterval: self.timeOutInterval, headerParameters: self.headerParameter, data: self.parameterData, httpMethod: self.httpMethod)
        
        // Create Session
        let session = SBNetworkSession.shared.session
        
        // Invoke API with all the details listed in attributes tupple
        invokeAPIWith(attributes: attributes, session: session) { (data, response, error) in
            onCompletion(data, response, error)
        }
        
    }
    
    /**
     Provides an URLRequest based on given attributes
     - parameters:
        - attributes: a tupple containing various parameters
     
     - Important:
     Some of the parameters in the tupple are non-optional which means you they expect a value during runtime else it will throw an error during compilation.
     - returns:
     An instance of URLRequest
     */
    public func getRequest(attributes:
        (url: URL, shouldUseCache: Bool, timeOutInterval: TimeInterval, headerParameters: [String: String], data: Data?, httpMethod: HTTPMethodEnum)) -> URLRequest {
        
        // Create Request
        let request = getURLRequestFrom(attributes: attributes)
        
        return request
    }
    
    // MARK: - Private Methods
    /**
     A private method which hits the API and returns the API response
     - parameters:
     
        - attributes: A tupple containing various parameters
        - session: An instance of URLSession.
        - onCompletion: Returns a callback with all the API response i.e (_ responseData: Data?, _ urlResponse: URLResponse?, _ error: Error?)
     
     - Important:
     Some of the parameters in the tupple are non-optional which means you they expect a value during runtime else it will throw an error during compilation.
     - returns:
     NULL
     */
    private func invokeAPIWith(attributes:
        (url: URL, shouldUseCache: Bool, timeOutInterval: TimeInterval, headerParameters: [String: String], data: Data?, httpMethod: HTTPMethodEnum), session: URLSession?, onCompletion: @escaping GenericCallBack) {
        
        // Create Request
        let request = getURLRequestFrom(attributes: attributes)
        
        // Start Task
        session?.dataTask(with: request) { (responseData: Data?, urlResponse: URLResponse?, error: Error?) in
            onCompletion(responseData, urlResponse, error)
            }.resume()
    }
    
    /**
     A private method which creates & returns an instance of URLRequest based on the arguments.
     - parameters:
        - attributes: a tupple containing various parameters
     
     - Important:
     Some of the parameters in the tupple are non-optional which means you they expect a value during runtime else it will throw an error during compilation.
     - returns:
     An instance of URLRequest
     */
    private func getURLRequestFrom(attributes:
        (url: URL, shouldUseCache: Bool, timeOutInterval: TimeInterval, headerParameters: [String: String], data: Data?, httpMethod: HTTPMethodEnum)) -> URLRequest {
        
        var urlRequest = URLRequest(url: attributes.url,
                                    cachePolicy: (attributes.shouldUseCache ? URLRequest.CachePolicy.useProtocolCachePolicy : URLRequest.CachePolicy.reloadIgnoringCacheData),
                                    timeoutInterval: attributes.timeOutInterval)
        
        urlRequest.allowsCellularAccess = true
        
        // Setup Header Parameters
        for key in attributes.headerParameters.keys {
            let value = attributes.headerParameters[key]
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Setup Http Method
        urlRequest.httpMethod = attributes.httpMethod.description
        
        // Append data
        if let data = attributes.data {
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
}
