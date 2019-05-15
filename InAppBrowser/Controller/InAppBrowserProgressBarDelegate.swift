import Foundation

protocol InAppBrowserProgressBarDelegate {
    
    /**
     *
     * Callback function that will be invoked when the progress of loading webview has been updated.
     * This will be an empty function by default.
     *
     * - Parameter browser: Current InAppBrowserView.
     * - Parameter progress: Current progress. (0 ~ 1)
     *
    */
    func onLoadProgress(_ browser: InAppBrowserView, progress: CGFloat)
    
}

extension InAppBrowserProgressBarDelegate {
    
    func onLoadProgress(_ browser: InAppBrowserView, progress: CGFloat) { }
    
}
