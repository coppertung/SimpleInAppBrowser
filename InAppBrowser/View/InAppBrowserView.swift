import UIKit
import Alamofire

class InAppBrowserView: UIView, InAppBrowserDelegate, InAppBrowserNavigationBarDelegate {

    // MARK: Properties
    
    // Views
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var progressBGView: UIView!
    
    // Navigation Bar
    @IBOutlet weak var labelNavigationBarTitle: UILabel!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topRightButtonSize: NSLayoutConstraint!
    
    // Progress View
    @IBOutlet weak var progressView: UIProgressView!
    
    // private var webView: UIWebView!
    private var webView: WKWebView!
    
    /**
     *
     * This property is used to control background color of all views.
     *
    */
    var themeColor: UIColor? {
        didSet {
            self.backgroundColor = themeColor
            self.mainView.backgroundColor = themeColor
            self.navigationBarView.backgroundColor = themeColor
            self.progressView.backgroundColor = themeColor
        }
    }
    
    var delegate: InAppBrowserDelegate? {
        didSet {
            self.isNavigationBarShown = delegate?.isNavigationBarShown() ?? self.isNavigationBarShown()
            self.isProgressBarShown = delegate?.isNavigationBarShown() ?? self.isProgressBarShown()
        }
    }
    var navigationBarDelegate: InAppBrowserNavigationBarDelegate? {
        didSet {
            updateNavigationBarContent()
        }
    }
    /**
     *
     * This is the WKUIDelegate of the webview.
     *
    */
    var wkUIDelegate: WKUIDelegate {
        get {
            return self.webView.uiDelegate ?? self
        }
        set {
            self.webView.uiDelegate = newValue
        }
    }
    /**
     *
     * This is the WKNavigationDelegate of the webview.
     *
     */
    var wkNavigationDelegate: WKNavigationDelegate {
        get {
            return self.webView.navigationDelegate ?? self
        }
        set {
            self.webView.navigationDelegate = newValue
        }
    }
    
    var url: String!
    var httpMethod: HTTPMethod = .get
    var params: [String: AnyObject]? = nil
    
    var isNavigationBarShown: Bool = true {
        didSet {
            updateNavigationBar()
        }
    }
    var isProgressBarShown: Bool = false {
        didSet {
            updateProgressBar()
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    /**
     *
     * To create the view of in-app browser.
     *
    */
    class func Create() -> InAppBrowserView {
        
        let nib = UINib(nibName: "InAppBrowser", bundle: nil)
        let target = nib.instantiate(withOwner: nil, options: nil).first as! InAppBrowserView
        return target
        
    }
    
    // MARK: Functions
    
    /**
     *
     * To show the in-app browser.
     *
     * - Parameter superview: The superview that the in-app browser shown at.
     *
    */
    func show(at superview: UIView? = nil) {
        
        if superview == nil {
            if let window = UIApplication.shared.keyWindow {
                window.addSubview(self)
                self.frame = window.frame
            }
        }
        else {
            superview!.addSubview(self)
            self.frame = superview!.frame
        }
        self.isNavigationBarShown = (delegate ?? self).isNavigationBarShown()
        self.isProgressBarShown = (delegate ?? self).isProgressBarShown()
        self.layoutIfNeeded()
        
    }
    
    /**
     *
     * To load the webview.
     *
     * - Parameter url: URL String.
     * - Parameter httpMethod: HTTP Method, stored as Alamofire.HTTPMethod. Support Get (.get) and Post (.post) Method only by defualt. Noted that relative delegate function (InAppBrowserDelegate.loadWebView) should be extended if other methods are needed.
     * - Parameter params: Parameters of the http request.
     * - Parameter enableJavaScript: Does the webview enable javascript being invoked? Default will be true.
     *
     */
    func load(_ url: String, httpMethod: HTTPMethod, params: [String: AnyObject]? = nil, enableJavaScript: Bool = true) {
        
        self.url = url
        self.httpMethod = httpMethod
        self.params = params
        
        // test get method only
        /*
        self.url = "http://google.com/"
        self.httpMethod = .get
        self.params = nil
        */
        // test post method only
        /*
        self.url = AppInfoManager.ChatUrl
        self.httpMethod = .post
        self.params = ["username": UserManager.currentUser?.username ?? "",
                       "ticket": UserManager.currentUser?.token ?? "",
            "room_label": "DePK10".lowercased()] as [String: AnyObject]
        */
        
        self.webView = (delegate ?? self).loadWebView(self, url: self.url, container: self.mainView, httpMethod: self.httpMethod, params: self.params, enableJavaScript: enableJavaScript)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.webView.uiDelegate = self.wkUIDelegate
        
    }
    
    /**
     *
     * Reload the webview.
     *
    */
    func reload() {
        
        self.webView.reload()
        
    }
    
    /**
     *
     * Dismiss the in-app browser.
     *
    */
    func dismiss() {
        
        self.removeFromSuperview()
        (delegate ?? self).onDestory(self)
        
    }
    
    // MARK: Private Functions
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webView.estimatedProgress)
            self.progressView.isHidden = self.progressView.progress >= 1
        }
        
    }
    
    func updateProgressBar() {
        
        self.progressBGView.isHidden = !self.isProgressBarShown
        
        self.layoutIfNeeded()
        if self.webView != nil {
            self.webView.frame = self.mainView.frame
        }
        
    }
    
    func updateNavigationBar() {
        
        self.navigationBarView.isHidden = !self.isNavigationBarShown
        
        if self.isNavigationBarShown {
            updateNavigationBarContent()
        }
        
        self.layoutIfNeeded()
        if self.webView != nil {
            self.webView.frame = self.mainView.frame
        }
        
    }
    
    func updateNavigationBarContent() {
        
        (navigationBarDelegate ?? self).titleLabel(self.labelNavigationBarTitle)
        (navigationBarDelegate ?? self).topLeftButton(self.topLeftButton)
        (navigationBarDelegate ?? self).topRightButton(self.topRightButton)
        self.topRightButtonSize.constant = (navigationBarDelegate ?? self).topRightButtonSize(self.topRightButton)
        self.layoutIfNeeded()
        
    }
    
    // MARK: Actions
    
    @IBAction func onPressedBackButton(_ sender: UIButton) {
        
        (navigationBarDelegate ?? self).onClickedTopLeftButton(self, sender: sender )
        
    }

    @IBAction func onPressedTopRightButton(_ sender: UIButton) {
        
        (navigationBarDelegate ?? self).onClickedTopRightButton(self, sender: sender)
        
    }
    
}

extension InAppBrowserView: WKUIDelegate, WKNavigationDelegate {
    
    // this handles target=_blank links by opening them in the same view
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
        
    }
    
}
