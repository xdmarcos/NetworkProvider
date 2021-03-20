//
//  NetworkProvider.swift
//
//  Created by xdmgzdev on 26/12/2019.
//

import Foundation

public protocol NetworkProviderProtocol {
  associatedtype Service: NetworkService

  func request<T: Decodable>(
    service: Service,
    deliverQueue: DispatchQueue,
    completion: @escaping (Result<T, Swift.Error>) -> Void
  )
}
