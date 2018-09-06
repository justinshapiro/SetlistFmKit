//
//  MockNetwork.swift
//  SetlistFmKitTests
//
//  Created by Justin Shapiro on 8/29/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

@testable import SetlistFmKit

final class MockNetwork: URLSessionProtocol {
    private var mockFilename: String?
    
    func inject(mock: String) {
        mockFilename = mock
    }
    
    func reset() {
        mockFilename = nil
    }
    
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol {
        guard let mockFile = mockFilename,
            let path = Bundle(for: type(of: self)).path(forResource: mockFile, ofType: "json"),
            let requestUrl = url.url,
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                let response = HTTPURLResponse(url: URL(string: "http://www.setlist.fm")!, statusCode: 500, httpVersion: nil, headerFields: nil)
                completionHandler(nil, response, nil)
                return MockDataTask()
        }
        
        
        let response = HTTPURLResponse(url: requestUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        completionHandler(data, response, nil)
        
        return MockDataTask()
    }
}

private final class MockDataTask: URLSessionDataTaskProtocol {
    func resume() {
        // do nothing, this is to satisify the URLSessionDataTask requirements for mocking
    }
}