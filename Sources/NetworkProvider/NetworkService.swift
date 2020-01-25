//
//  NetworkService.swift
//
//  Created by xdmgzdev on 26/12/2019.
//

import Foundation

public typealias Parameters = [String: Any]

public enum HTTPMethod: String {

    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol NetworkService {

    var baseURL: String { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

extension NetworkService {

    public var urlRequest: URLRequest {

        guard let url = self.url else {

            fatalError("URL could not be built")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return request
    }

    private var url: URL? {

        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path

        if method == .get {

            // add query items to url
            guard let parameters = parameters as? [String: String] else {

                fatalError("parameters for GET http method must conform to [String: String]")
            }

            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        return urlComponents?.url
    }
}

