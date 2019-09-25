//
//  TabNavigationController.swift
//  TabbedNavigation
//
//  Created by Ryan Bigger on 8/27/17.
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

    lazy var tabsView = UIStackView()
    var tabButtons = [UIButton]()

    // MARK: - View Controllers
    // This is the initial view controller when app launches
    var firstViewController: FirstViewController?

    private lazy var secondViewController: AnotherViewController = {
        let controller = AnotherViewController()
        controller.name = "Second View"
        return controller
    }()

    private lazy var thirdViewController: AnotherViewController = {
        let controller = AnotherViewController()
        controller.name = "Third View"
        return controller
    }()

    private lazy var fourthViewController: AnotherViewController = {
        let controller = AnotherViewController()
        controller.name = "Fourth View"
        return controller
    }()

    private lazy var fifthViewController: AnotherViewController = {
        let controller = AnotherViewController()
        controller.name = "Fifth View"
        return controller
    }()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setup()
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

        tabsView.frame = navigationBar.frame
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
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.setTitleColor(UIColor.lightGray.withAlphaComponent(0.3), for: .highlighted)
        button.setTitleColor(UIColor(red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // MARK: - Tab Actions
    @objc func tappedFirstButton() {
        if viewControllers.first == firstViewController {
            return
        }
        setCurrentTabButton(.first)
        switchRootViewController(firstViewController!)
    }

    @objc func tappedSecondButton() {
        if viewControllers.first == secondViewController {
            return
        }
        setCurrentTabButton(.second)
        switchRootViewController(secondViewController)
    }

    @objc func tappedThirdButton() {
        if viewControllers.first == thirdViewController {
            return
        }
        setCurrentTabButton(.third)
        switchRootViewController(thirdViewController)
    }

    @objc func tappedFourthButton() {
        if viewControllers.first == fourthViewController {
            return
        }
        setCurrentTabButton(.fourth)
        switchRootViewController(fourthViewController)
    }

    @objc func tappedFifthButton() {
        if viewControllers.first ==  fifthViewController {
            return
        }
        setCurrentTabButton(.fifth)
        switchRootViewController(fifthViewController)
    }

    // MARK: - Animations
    func animateTabsIn() {
        var frame = self.tabsView.frame
        if self.viewControllers.count == 2 && frame.origin.x < 0 {
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
        if tabsView.isHidden {
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.tabsView.alpha = 0
            self.tabsView.frame = CGRect(x: -60,
                                         y: 0,
                                         width: UIScreen.main.bounds.size.width,
                                         height: self.navigationBar.frame.size.height)
        }, completion: { (_) in
            self.tabsView.isHidden = true
        })
    }

    // MARK: - Navigation
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        animateTabsOut()
    }

    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        animateTabsIn()
        return super.popViewController(animated: animated)
    }

    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        animateTabsIn()
        return super.popToViewController(viewController, animated: animated)
    }

    func switchRootViewController(_ viewController: UIViewController) {
        viewController.title = ""
        viewControllers = [viewController]
        navigationBar.bringSubviewToFront(tabsView)
    }

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        transitionCoordinator?.notifyWhenInteractionChanges({ (transitionContext) in
            if transitionContext.isCancelled == true {
                self.tabsView.isHidden = true
                self.tabsView.alpha = 0
                self.tabsView.frame = CGRect(x: -60,
                                             y: 0,
                                             width: UIScreen.main.bounds.size.width,
                                             height: self.navigationBar.frame.size.height)
            }
        })
    }

}
