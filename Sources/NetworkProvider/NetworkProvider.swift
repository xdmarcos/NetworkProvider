//
//  NetworkProvider.swift
//
//  Created by xdmgzdev on 26/12/2019.
//

import Foundation

private func DLog(_ message: String, function: String = #function) {

    #if DEBUG
        print("\(function): \(message)")
    #endif
}

public enum Result<T> {

    case success(T)
    case failure(Error)
    case empty
}

public class NetworkProvider<T: NetworkService> {

    public var urlSession = URLSession.shared

    public init() { }

    public func request(service: T, completion: @escaping (Result<Data>) -> Void) {

        call(service.urlRequest, completion: completion)
    }

    public func request<U>(service: T, decodeType: U.Type, completion: @escaping (Result<U>) -> Void) where U: Decodable {

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
            case .empty:

                completion(.empty)
            }
        }
    }
}

extension NetworkProvider {

    private func call(_ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data>) -> Void) {

        DLog("Request: \(request)")
        DLog("Request Method: \(request.httpMethod ?? "")")
        DLog("Request Header: \(request.allHTTPHeaderFields ?? [:])")

        let task = urlSession.dataTask(with: request) { (data, response, error) in

            DLog("Response: \(response ?? URLResponse())")

            if let error = error {

                deliverQueue.async {

                    completion(.failure(error))
                }
            } else if let data = data {

                deliverQueue.async {

                    completion(.success(data))
                }
            } else {

                deliverQueue.async {

                    completion(.empty)
                }
            }
        }

        task.resume()
    }
}
