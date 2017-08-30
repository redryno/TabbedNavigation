//
//  TabNavigationController.swift
//  TabbedNavigation
//
//  Created by Ryan Bigger on 12/1/16.
//  Copyright © 2017 Ryan Bigger. All rights reserved.
//

import UIKit

class TabNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    enum TabBarButtonIndex: Int {
        case first = 0
        case second
        case third
        case fourth
        case fifth
    }
    
    var tabsView: UIStackView!
    var tabButtons = [UIButton]()
    
    // MARK: - View Controllers
    
    // This is the initial view controller when app launches
    var firstViewController: FirstViewController?
    
    private lazy var secondViewController: SecondViewController? = {
        return self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as! SecondViewController
    }()
    
    private lazy var thirdViewController: ThirdViewController? = {
        return self.storyboard?.instantiateViewController(withIdentifier: "ThirdView") as! ThirdViewController
    }()
    
    private lazy var fourthViewController: FourthViewController? = {
        return self.storyboard?.instantiateViewController(withIdentifier: "FourthView") as! FourthViewController
    }()
    
    private lazy var fifthViewController: FifthViewController? = {
        return self.storyboard?.instantiateViewController(withIdentifier: "FifthView") as! FifthViewController
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout
    
    func setCurrentTabButton(_ index: TabBarButtonIndex) {
        for object in tabButtons {
            object.isSelected = false
        }
        let button = tabButtons[index.rawValue]
        button.isSelected = true
    }
    
    func setup() {
        firstViewController = viewControllers.first as? FirstViewController
        firstViewController?.title = ""
        
        tabsView = UIStackView(frame: navigationBar.frame)
        tabsView.axis = .horizontal
        tabsView.backgroundColor = UIColor.clear
        tabsView.distribution = .fillEqually
        navigationBar.addSubview(self.tabsView)
        
        let firstButton = tabButton(title: "First")
        firstButton.addTarget(self, action: #selector(tappedFirstButton), for: .touchUpInside)
        tabsView.addArrangedSubview(firstButton)
        tabButtons.append(firstButton)
        
        let secondButton = tabButton(title: "Second")
        secondButton.addTarget(self, action: #selector(tappedSecondButton), for: .touchUpInside)
        tabsView.addArrangedSubview(secondButton)
        tabButtons.append(secondButton)
        
        let thirdButton = tabButton(title: "Third")
        thirdButton.addTarget(self, action: #selector(tappedThirdButton), for: .touchUpInside)
        tabsView.addArrangedSubview(thirdButton)
        tabButtons.append(thirdButton)
        
        let fourthButton = tabButton(title: "Fourth")
        fourthButton.addTarget(self, action: #selector(tappedFourthButton), for: .touchUpInside)
        tabsView.addArrangedSubview(fourthButton)
        tabButtons.append(fourthButton)
        
        let fifthButton = tabButton(title: "Fifth")
        fifthButton.addTarget(self, action: #selector(tappedFifthButton), for: .touchUpInside)
        tabsView.addArrangedSubview(fifthButton)
        tabButtons.append(fifthButton)
        
        setCurrentTabButton(.first)
    }
    
    func tabButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.setTitleColor(UIColor.lightGray.withAlphaComponent(0.3), for: .highlighted)
        button.setTitleColor(UIColor(red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Tab Actions
    
    func tappedFirstButton() {
        if self.viewControllers.first is FirstViewController {
            return
        }
        self.setCurrentTabButton(.first)
        self.switchRootViewController(self.firstViewController!)
    }
    
    func tappedSecondButton() {
        if self.viewControllers.first is SecondViewController {
            return
        }
        self.setCurrentTabButton(.second)
        self.switchRootViewController(self.secondViewController!)
    }
    
    func tappedThirdButton() {
        if self.viewControllers.first is ThirdViewController {
            return
        }
        self.setCurrentTabButton(.third)
        self.switchRootViewController(self.thirdViewController!)
    }
    
    func tappedFourthButton() {
        if self.viewControllers.first is FourthViewController {
            return
        }
        self.setCurrentTabButton(.fourth)
        self.switchRootViewController(self.fourthViewController!)
    }
    
    func tappedFifthButton() {
        if self.viewControllers.first is FifthViewController {
            return
        }
        self.setCurrentTabButton(.fifth)
        self.switchRootViewController(self.fifthViewController!)
    }
    
    // MARK: - Animations
    
    func animateTabsIn() {
        var frame = self.tabsView.frame
        if (self.viewControllers.count == 2 && frame.origin.x < 0) {
            self.tabsView.frame = frame
            frame.origin.x = 0
            self.tabsView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.tabsView.alpha = 1
                self.tabsView.frame = frame
            })
        }
    }
    
    func animateTabsOut() {
        if self.tabsView.isHidden {
            return
        }
        UIView.animate(withDuration: 0.2, animations: { 
            self.tabsView.alpha = 0
            self.tabsView.frame = CGRect(x: -60, y: 0, width: UIScreen.main.bounds.size.width, height: self.navigationBar.frame.size.height)
        }) { (finished) in
            self.tabsView.isHidden = true
        }
    }
    
    // MARK: - Navigation
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        self.animateTabsOut()
    }
    
    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        self.animateTabsIn()
        return super.popViewController(animated: animated)
    }
    
    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        self.animateTabsIn()
        return super.popToViewController(viewController, animated: animated)
    }
    
    func switchRootViewController(_ viewController: UIViewController) {
        viewController.title = ""
        self.viewControllers = [viewController]
        self.navigationBar.bringSubview(toFront: self.tabsView)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.transitionCoordinator?.notifyWhenInteractionChanges({ (transitionContext) in
            if transitionContext.isCancelled == true {
                self.tabsView.isHidden = true
                self.tabsView.alpha = 0
                self.tabsView.frame = CGRect(x: -60, y: 0, width: UIScreen.main.bounds.size.width, height: self.navigationBar.frame.size.height)
            }
        })
    }
    
}
