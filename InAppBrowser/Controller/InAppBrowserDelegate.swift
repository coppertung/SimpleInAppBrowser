import Foundation
import Alamofire

protocol InAppBrowserDelegate {
    
    /**
     *
     * The base function which load the webview in the in-app browser.
     * This function handles get method and post method only by default.
     *
     * - Parameter browser: Current InAppBrowserView.
     * - Parameter url: URL string.
     * - Parameter container: Container view.
     * - Parameter httpMethod: HTTP Method, stored as Alamofire.HTTPMethod. Support Get (.get) and Post (.post) Method only by defualt.
     * - Parameter params: Parameters of the http request.
     * - Parameter enableJavaScript: Does the webview enable javascript being invoked?
     *
    */
    func loadWebView(_ browser: InAppBrowserView, url: String, container: UIView, httpMethod: HTTPMethod, params: [String: AnyObject]?, enableJavaScript: Bool) -> WKWebView?
    // func loadWebView(_ browser: InAppBrowserView, url: String, container: UIView, httpMethod: HTTPMethod, params: [String: AnyObject]?) -> UIWebView?
    /**
     *
     * Return whether is the progress bar of in-app browser is shown or not.
     * False will be returned by default.
     *
     */
    func isProgressBarShown() -> Bool
    /**
     *
     * Return whether is the navigation bar of in-app browser is shown or not.
     * True will be returned by default.
     *
     */
    func isNavigationBarShown() -> Bool
    /**
     *
     * Callback function that will be invoked when the in-app browser is dismissed.
     * This will be an empty function by default.
     *
     * - Parameter browser: Current InAppBrowserView.
     *
    */
    func onDestory(_ browser: InAppBrowserView)
    
}

extension InAppBrowserDelegate {
    
    /*
    func loadWebView(_ browser: InAppBrowserView, url: String, container: UIView, httpMethod: HTTPMethod, params: [String: AnyObject]? = nil) -> UIWebView? {
        
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: container.frame.size.width, height: container.frame.size.height))
        var urlString = url
        
        switch httpMethod {
        case .get:
            if params != nil {
                urlString += "?"
                for (key, value) in params! {
                    urlString += "\(key)=\(value)"
                    urlString += "&"
                }
                urlString.remove(at: urlString.lastIndex(of: "&")!)
            }
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "GET"
            webView.loadRequest(request)
        case .post:
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            if params != nil, let postData = try? JSONSerialization.data(withJSONObject: params!, options: []) {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = postData
            }
            webView.loadRequest(request)
        default:
            // not supporting other methods, can be extend later
            return nil
        }
        
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.bounces = false
        
        webView.delegate = self
        
        container.addSubview(webView)
        return webView
        
    }
    */
    
    func loadWebView(_ browser: InAppBrowserView, url: String, container: UIView, httpMethod: HTTPMethod, params: [String: AnyObject]?, enableJavaScript: Bool = true) -> WKWebView? {
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = enableJavaScript
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: container.frame.size.width, height: container.frame.size.height), configuration: configuration)
        
        var urlString = url
        
        switch httpMethod {
        case .get:
            if params != nil {
                urlString += "?"
                for (key, value) in params! {
                    urlString += "\(key)=\(value)"
                    urlString += "&"
                }
                urlString.remove(at: urlString.lastIndex(of: "&")!)
            }
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "GET"
            webView.load(request)
        case .post:
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            if params != nil, let postData = try? JSONSerialization.data(withJSONObject: params!, options: []) {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = postData
            }
            webView.load(request)
        default:
            return nil
        }
        
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.bounces = false
        
        container.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        return webView
        
    }
    
    func isProgressBarShown() -> Bool {
        
        return false
        
    }
    
    func isNavigationBarShown() -> Bool {
        
        return true
        
    }
    
    func onDestory(_ browser: InAppBrowserView) { }
    
}
