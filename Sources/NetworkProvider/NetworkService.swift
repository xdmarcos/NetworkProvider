//
//  NetworkService.swift
//
//  Created by xdmgzdev on 26/12/2019.
//

import Foundation

public enum HttpHeaderKey {
  static let contentType = "Content-Type"
  static let acceptLanguage = "Accept-Language"
  static let contentLength = "Content-Length"
  static let contentDisposition = "Content-Disposition"
  static let accept = "Accept"
}

public enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case patch = "PATCH"
  case delete = "DELETE"
}

public protocol NetworkService {
  var baseURL: String { get }
  var method: HttpMethod { get }
  var httpBody: Encodable? { get }
  var headers: [String: String]? { get }
  var queryParameters: [URLQueryItem]? { get }
  var path: String { get }
}

public extension NetworkService {
  var urlRequest: URLRequest {
    guard let url = self.url else {
      fatalError("URL could not be built")
    }

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers

    if let httpBody = httpBody {
      request.httpBody = try? httpBody.jsonEncode()
    }

    return request
  }
}

private extension NetworkService {
  var url: URL? {
    var urlComponents = URLComponents(string: baseURL)
    urlComponents?.path = path

    guard let queryParams = queryParameters else {
      return urlComponents?.url
    }

    urlComponents?.queryItems?.append(contentsOf: queryParams)

    return urlComponents?.url
  }
}

private extension Encodable {
  func jsonEncode() throws -> Data? {
    try JSONEncoder().encode(self)
  }
}
