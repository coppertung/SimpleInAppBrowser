import Foundation

protocol InAppBrowserProgressBarDelegate {
    
    func onLoadProgress(_ browser: InAppBrowserView, progress: CGFloat)
    
}

extension InAppBrowserProgressBarDelegate {
    
    func onLoadProgress(_ browser: InAppBrowserView, progress: CGFloat) { }
    
}
