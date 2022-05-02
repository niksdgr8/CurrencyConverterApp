//
//  NetworkManger.swift
//  CurrencyConverterApp
//
//  Created by Nikhil Gupta on 30/04/22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL(String)
    case invalidResponse(String)
    case decodingError(String)
    case genericError(String)
    case internetError(String)
    
}

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    private var baseURL: URL {
            return URL(string: infoForKey("BaseUrl")!)!
    }

    public func infoForKey(_ key: String) -> String? {
            return (Bundle.main.infoDictionary?[key] as? String)?
                .replacingOccurrences(of: "\\", with: "")
     }
    
    public func getDataResponse(urlString: String, queryItems: [String: String]? = nil, completionBlock: @escaping (Result<[String: Any], Error>) -> Void) {
        let URL = baseURL.appendingPathComponent(urlString)
        var urlComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = self.getQueryItems(queryItemDictionary: queryItems)
        guard let fullURL = urlComponents?.url else {
            completionBlock(.failure(NetworkError.invalidURL(NSLocalizedString("INVALID_URL_ERROR", comment: "Invalid URL error"))))
            return
        }
        
           let task = URLSession.shared.dataTask(with: fullURL) { data, response, error in
               guard error == nil else {
                   completionBlock(.failure(NetworkError.internetError(NSLocalizedString("NETWORK_ERROR_MESSAGE", comment: "Network error"))))
                   return
               }
               
               guard let responseData = data else {
                   completionBlock(.failure(NetworkError.genericError(NSLocalizedString("GENERIC_ERROR_MESSAGE", comment: "Generic error"))))
                   return
               }

               guard let json = (try? JSONSerialization.jsonObject(with: responseData, options: [])) as? [String: AnyObject] else {
                   completionBlock(.failure(NetworkError.decodingError(NSLocalizedString("JSON_DECODING_ERROR_MESSAGE", comment: "Decoding error"))))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse,
                   200 ..< 300 ~= httpResponse.statusCode else {
                       completionBlock(.failure(NetworkError.genericError(NSLocalizedString("GENERIC_ERROR_MESSAGE", comment: "Generic error"))))
                       return
               }
               
               if let status = json["success"] as? Bool, !status, let errorJson = json["error"] as? [String: Any], let errorMessage = errorJson["info"], let errorString = errorMessage as? String {
                   
                   completionBlock(.failure(NetworkError.invalidResponse(errorString)))
               } else {
                   completionBlock(.success(json))
               }
               
           }
           task.resume()
       }
    
    
    private func getQueryItems(queryItemDictionary: [String: String]?) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: StringConstants.accessKey, value: self.infoForKey("APIKey")!))
        guard let itemDictionary = queryItemDictionary else {
            return items
        }
        for key in itemDictionary.keys {
            items.append(URLQueryItem(name: key, value: itemDictionary[key]))
        }
        
        return items
    }
    
}
