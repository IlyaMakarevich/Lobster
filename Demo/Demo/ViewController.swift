//
//  ViewController.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/11/02.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Lobster
import FirebaseRemoteConfig
import SDWebImage

extension ConfigKeys {
    static let titleText = ConfigKey<String>("title_text")
    static let titleColor = ConfigKey<UIColor>("title_color")
    static let boxSize = CodableConfigKey<CGSize>("box_size")
    static let person = CodableConfigKey<Person>("person")
    static let backgroundImageURL = ConfigKey<URL>("background_image_url")
}

struct Person: Codable {
    let name: String
    let age: Int
    let country: String
}

class ViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var personViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var personViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var personNameLabel: UILabel!
    @IBOutlet private weak var personAgeLabel: UILabel!
    @IBOutlet private weak var personCountryLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var fetchButton: UIButton! {
        didSet {
            fetchButton.layer.masksToBounds = true
            fetchButton.layer.cornerRadius = 4.0
            fetchButton.addTarget(self, action: #selector(fetch(_:)), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Lobster.shared.debugMode = true
        Lobster.shared.fetchExpirationDuration = 0.0

        Lobster.shared[.titleText] = "Demo Project"
        Lobster.shared[.titleColor] = .gray
        Lobster.shared[.boxSize] = .zero
        Lobster.shared[.person] = Person(name: "Taro", age: 18, country: "Japan")

        updateUI()

    }

    @objc private func fetch(_ button: UIButton) {
        Lobster.shared.fetch { [weak self] _ in
            self?.updateUI()
        }
    }

    private func updateUI() {
        titleLabel.text = Lobster.shared[.titleText]
        titleLabel.textColor = Lobster.shared[.titleColor]

        let boxSize = Lobster.shared[.boxSize] ?? .zero
        personViewWidthConstraint.constant = boxSize.width
        personViewHeightConstraint.constant = boxSize.width

        if let person = Lobster.shared[.person] {
            personNameLabel.text = "Name : \(person.name)"
            personAgeLabel.text = "Age: \(person.age)"
            personCountryLabel.text = "Country: \(person.country)"
        }

        backgroundImageView.sd_setImage(with: Lobster.shared[.backgroundImageURL], completed: nil)
    }
}

