import Foundation

protocol InAppBrowserNavigationBarDelegate {
    
    /**
     *
     * Set up the title of the navigation bar.
     * Empty String will be set as default.
     *
     * - Parameter label: The title label.
     *
    */
    func titleLabel(_ label: UILabel)
    /**
     *
     * Set up the top-left button.
     *
     * - Parameter button: The top-left button
     *
     */
    func topLeftButton(_ button: UIButton)
    /**
     *
     * Set up the top-right button.
     * The button will be hidden as default.
     *
     * - Parameter button: The top-right button
     *
    */
    func topRightButton(_ button: UIButton)
    /**
     *
     * Set up the size of the right-top button.
     * 40.0 will be returned as default.
     *
     * - Parameter button: The top-right button
     *
     */
    func topRightButtonSize(_ button: UIButton) -> CGFloat
    /**
     *
     * Callback function that will be invoked when the top-left button is being clicked.
     * Dismiss function will be called by default.
     *
     * - Parameter browser: Current InAppBrowserView.
     * - Parameter sender: Top-left button.
     *
     */
    func onClickedTopLeftButton(_ browser: InAppBrowserView, sender: UIButton)
    /**
     *
     * Callback function that will be invoked when the top-right button is being clicked.
     * This will be an empty function by default.
     *
     * - Parameter browser: Current InAppBrowserView.
     * - Parameter sender: Top-right button.
     *
     */
    func onClickedTopRightButton(_ browser: InAppBrowserView, sender: UIButton)
    
}

extension InAppBrowserNavigationBarDelegate {
    
    func titleLabel(_ label: UILabel) {
        
        label.text = ""
        
    }
    
    func topLeftButton(_ button: UIButton) {
        
        button.setImage(UIImage(named: "btn_back"), for: .normal)
        button.contentMode = .scaleAspectFit
        
    }
    
    func topRightButton(_ button: UIButton) {
        
        button.isHidden = true
        
    }
    
    func topRightButtonSize(_ button: UIButton) -> CGFloat {
        
        return 40.0
        
    }
    
    func onClickedTopLeftButton(_ browser: InAppBrowserView, sender: UIButton) {
        
        browser.dismiss()
        
    }

    func onClickedTopRightButton(_ browser: InAppBrowserView, sender: UIButton) { }

}
