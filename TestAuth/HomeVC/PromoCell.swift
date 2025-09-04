//
//  PromoCell.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import UIKit

class PromoCell: UICollectionViewCell {
    static let identifier = "PromoCell"
    
    let promoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let callToActionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Call to action", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 23
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let promoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "promoColor")
        contentView.layer.cornerRadius = 16
        contentView.addSubview(promoLabel)
        contentView.addSubview(callToActionButton)
        contentView.addSubview(promoImageView)
        
        NSLayoutConstraint.activate([
            promoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            promoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            promoLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            callToActionButton.topAnchor.constraint(equalTo: promoLabel.bottomAnchor, constant: 16),
            callToActionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            callToActionButton.widthAnchor.constraint(equalToConstant: 140),
            callToActionButton.heightAnchor.constraint(equalToConstant: 40),
            
            promoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            promoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            promoImageView.widthAnchor.constraint(equalToConstant: 120),
            promoImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

