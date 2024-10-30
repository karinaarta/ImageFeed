//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by karine pankova on 21.10.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    let auth2Service = OAuth2Service()
    let tokenStorage = OAuth2TokenStorage()
}
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        auth2Service.fetchOAuthToken(code: code, completion: {result in
            switch result{
            case.success(let responceBody):
                self.tokenStorage.token = responceBody.accessToken
            case.failure(let error):
                print (error.localizedDescription)
            }
        })
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }

}
