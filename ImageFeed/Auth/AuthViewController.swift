//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by karine pankova on 21.10.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == ShowWebViewSegueIdentifier,
             let webViewVC = segue.destination as? WebViewViewController {
              webViewVC.delegate = self
          }
      }

}
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let token):
                    OAuth2TokenStorage.shared.token = token
                    print("Token received and saved: \(token)")
                    self.dismiss(animated: true)
                    self.delegate?.didAuthenticate(self)

                case.failure(let error):
                    print (error.localizedDescription)
                }
            }
        }
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
}
