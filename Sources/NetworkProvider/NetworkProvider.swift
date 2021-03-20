//
//  NetworkProvider.swift
//
//  Created by xdmgzdev on 26/12/2019.
//

import Foundation

private func DLog(_ message: String, line: Int = #line, function: String = #function) {
  #if DEBUG
  print("🚀 - NetworkProvider, at: \(function), line: \(line): \(message)")
  #endif
}

public protocol NetworkProviderProtocol {
  associatedtype Service: NetworkService

  func request(service: Service, completion: @escaping (Result<Data, Error>) -> Void)
}

public class NetworkProvider<T: NetworkService>: NetworkProviderProtocol {
  public var urlSession = URLSession.shared

  public init() {}

  public func request(
    service: T,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    perform(service.urlRequest, completion: completion)
  }
}

extension NetworkProvider {
  private func perform(
    _ request: URLRequest,
    deliverQueue: DispatchQueue = DispatchQueue.main,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    // Logging
    logRequest(request)

    let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
      guard let self = self else {
        DLog("❌ ATTENTION: NetworkProvider was deallocated! ❌")
        return
      }

      // Logging
      self.logResponse(response)

      if let error = error {
        deliverQueue.async {
          completion(.failure(error))
        }
      } else {
        deliverQueue.async {
          completion(.success(data ?? Data()))
        }
      }
    }

    task.resume()
  }

  private func logRequest(_ request: URLRequest) {
    DLog("❕ Request: \(request) ❕")
    DLog("❕ Request Method: \(request.httpMethod ?? "")❕")
    let httpBody = request.httpBody ?? Data()
    let httpBodyString = String(data: httpBody, encoding: .utf8) ?? ""
    DLog("❕ Request Body: \(httpBodyString)❕")
    DLog("❕ Request Header: \(request.allHTTPHeaderFields ?? [:])❕")
  }

  private func logResponse(_ response: URLResponse?) {
    guard let response = response else {
      DLog("❌ The response does not exist (nil) ❌")
      return
    }

    DLog("✅ Response: \(response) ✅")
  }
}
