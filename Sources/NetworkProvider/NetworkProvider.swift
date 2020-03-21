//
//  NetworkProvider.swift
//
//  Created by xdmgzdev on 26/12/2019.
//

import Foundation

private func DLog(_ message: String, function: String = #function) {

    #if DEBUG
        print("🚀 - NetworkProvider: \(function): \(message)")
    #endif
}

public class NetworkProvider<T: NetworkService> {

    public var urlSession = URLSession.shared

    public init() { }

    public func request(service: T, completion: @escaping (Result<Data, Error>) -> Void) {

        call(service.urlRequest, completion: completion)
    }

    public func request<U>(service: T, decodeType: U.Type, completion: @escaping (Result<U, Error>) -> Void) where U: Decodable {

        call(service.urlRequest) { result in

            switch result {

            case .success(let data):

                let decoder = JSONDecoder()
                do {

                    let resp = try decoder.decode(decodeType, from: data)
                    completion(.success(resp))
                } catch {

                    completion(.failure(error))
                }
            case .failure(let error):

                completion(.failure(error))
            }
        }
    }
}

extension NetworkProvider {

    private func call(_ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data, Error>) -> Void) {

        // Logging
        logRequest(request)

        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in

            guard let self = self else { return }
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

        DLog("Request: \(request)")
        DLog("Request Method: \(request.httpMethod ?? "")")
        let httpBody = request.httpBody ?? Data()
        let httpBodyString = String(data: httpBody, encoding: .utf8) ?? ""
        DLog("Request Body: \(httpBodyString)")
        DLog("Request Header: \(request.allHTTPHeaderFields ?? [:])")
    }

    private func logResponse(_ response: URLResponse?) {

        guard let response = response else {

            DLog("The response does not exist (nil)")
            return
        }

        DLog("Response: \(response)")
    }
}
