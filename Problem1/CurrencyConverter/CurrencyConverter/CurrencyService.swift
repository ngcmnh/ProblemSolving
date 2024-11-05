//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by ngminh on 05/11/2024.
//

import Foundation

class CurrencyService {
    
    private let apiUrl = "https://api.exchangerate-api.com/v4/latest/"
    
    func fetchAvailableCurrencies(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: apiUrl + "VND") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let rates = json?["rates"] as? [String: Double] {
                    let currencies = Array(rates.keys)
                    completion(.success(currencies))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func convert(amount: Double, from: String, to: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: apiUrl + from) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let rates = json?["rates"] as? [String: Double],
                   let rate = rates[to] {
                    let convertedAmount = amount * rate
                    completion(.success(convertedAmount))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

