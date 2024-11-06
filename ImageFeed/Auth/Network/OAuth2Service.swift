//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by karine pankova on 26.10.2024.
//
import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private enum NetworkError: Error {
        case codeError
    }
    
   private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        print ("makeouth")
        guard let baseURL = URL(string: "https://unsplash.com") else {
            return nil
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&client_secret=\(Constants.secretKey)"
            + "&redirect_uri=\(Constants.redirectURI)"
            + "&code=\(code)"
            + "&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print("request = \(request)")
        return request
    }
    
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let request = makeOAuthTokenRequest(code: code) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.codeError))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("HTTP Status Code: \(response.statusCode)")
                if !(200...299).contains(response.statusCode) {
                    print("Received unsuccessful HTTP status code.")
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.codeError))
                    }
                    return
                }
            }
            
            // Парсим JSON-ответ
            guard let data = data else {
                print("No data received from server.")
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.codeError))
                }
                return
            }
            
            do {
                // Декодируем JSON в структуру OAuthTokenResponseBody
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tokenResponse.accessToken)) // Передаем успешный результат с токеном
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error)) // Завершаем с ошибкой декодирования
                }
            }
        }
        task.resume() // Запуск задачи
    }
}

