//
//  SecondViewController.swift
//  TabbedNavigation
//
//  Created by Ryan Bigger on 8/27/17.
//  Copyright © 2017 Ryan Bigger. All rights reserved.
//

import UIKit

class AnotherViewController: UIViewController {
    var label = UILabel()
    var name: String? {
        didSet {
            label.text = name
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        drawView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func drawView() {
        label.font = UIFont.systemFont(ofSize: 36)
        label.text = name
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if #available(iOS 13.0, *) {
            label.textColor = .label
            view.backgroundColor = .systemBackground
        } else {
            label.textColor = .black
            view.backgroundColor = .white
        }
    }

}
