//
//  NetworkProviderProtocol.swift
//
//  Created by xdmgzdev on 26/12/2019.
//

import Foundation

public protocol NetworkProviderProtocol {
  var service: NetworkService { get }
  func request<T: Decodable>(
    dataType: T.Type,
    deliverQueue: DispatchQueue,
    completion: @escaping (Result<T, Swift.Error>) -> Void
  )
}
