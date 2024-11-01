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
    let auth2Service = OAuth2Service()
    let tokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
}
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        auth2Service.fetchOAuthToken(code: code, completion: {result in
            switch result{
            case.success(let responceBody):
                self.tokenStorage.token = responceBody.accessToken
                self.delegate?.didAuthenticate(self)
            case.failure(let error):
                print (error.localizedDescription)
            }
        })
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
