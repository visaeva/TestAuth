//
//  HomeViewController.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import UIKit

class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "GIFTS"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let promoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    private let promoLabel: UILabel = {
        let label = UILabel()
        label.text = "UPCOMING\nHOLIDAYS SOON"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let promoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flowers")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let callToActionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Call to action", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 23
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let showAllLabel: UILabel = {
        let label = UILabel()
        label.text = "Show all"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let viewAllCategoriesButton: UIButton = {
        let button = UIButton()
        button.setTitle("View all categories", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 23
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let filtersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let productsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupData()
    }
    
    private func setupNavigationBar() {
        let deliverButton = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        config.title = "Deliver to 🇺🇸 USD"
        config.image = UIImage(named: "down")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .black
        
        deliverButton.configuration = config
        deliverButton.addTarget(self, action: #selector(deliverTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: deliverButton)
        navigationItem.rightBarButtonItem = barButton
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(searchBar)
        contentView.addSubview(promoCollectionView)
        contentView.addSubview(categoriesStackView)
        contentView.addSubview(showAllLabel)
        contentView.addSubview(bottomContainerView)
        bottomContainerView.addSubview(viewAllCategoriesButton)
        bottomContainerView.addSubview(filtersStackView)
        bottomContainerView.addSubview(productsStackView)
        contentView.addSubview(promoCollectionView)
        
        promoCollectionView.dataSource = self
        promoCollectionView.delegate = self
        promoCollectionView.register(PromoCell.self, forCellWithReuseIdentifier: "PromoCell")
    }
    
    private func setupData() {
        for category in viewModel.categories {
            let categoryView = createCategoryView(title: category.title, imageName: category.imageName)
            categoriesStackView.addArrangedSubview(categoryView)
        }
        let filters = ["Giftboxes", "For Her", "Popular"]
        for filter in filters {
            let filterButton = createFilterButton(title: filter)
            filtersStackView.addArrangedSubview(filterButton)
        }
        for product in viewModel.products {
            let productView = createProductView(imageName: product.imageName)
            productsStackView.addArrangedSubview(productView)
        }
    }
    
    private func createCategoryView(title: String, imageName: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        return containerView
    }
    
    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(named: "down")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .black
        config.background.backgroundColor = UIColor(named: "filterColor")
        config.background.cornerRadius = 23
        config.titleAlignment = .center
        config.buttonSize = .medium
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func createProductView(imageName: String) -> UIView {
        let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        let heartButton = UIButton()
        heartButton.setTitle("♡", for: .normal)
        heartButton.setTitleColor(.white, for: .normal)
        heartButton.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        heartButton.layer.cornerRadius = 20
        heartButton.titleLabel?.font = .systemFont(ofSize: 18)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(heartButton)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            heartButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            heartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            heartButton.widthAnchor.constraint(equalToConstant: 40),
            heartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return containerView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            searchBar.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            searchBar.widthAnchor.constraint(equalToConstant: 110),
            searchBar.heightAnchor.constraint(equalToConstant: 42),
            
            promoCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            promoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            promoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            promoCollectionView.heightAnchor.constraint(equalToConstant: 160),
            
            categoriesStackView.topAnchor.constraint(equalTo: promoCollectionView.bottomAnchor, constant: 24),
            categoriesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoriesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            
            showAllLabel.centerYAnchor.constraint(equalTo: categoriesStackView.centerYAnchor),
            showAllLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            showAllLabel.leadingAnchor.constraint(equalTo: categoriesStackView.trailingAnchor, constant: 8),
            
            bottomContainerView.topAnchor.constraint(equalTo:  categoriesStackView.bottomAnchor, constant: 24),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            viewAllCategoriesButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            viewAllCategoriesButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
            viewAllCategoriesButton.widthAnchor.constraint(equalToConstant: 180),
            viewAllCategoriesButton.heightAnchor.constraint(equalToConstant: 40),
            
            filtersStackView.topAnchor.constraint(equalTo: viewAllCategoriesButton.bottomAnchor, constant: 24),
            filtersStackView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            filtersStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16),
            filtersStackView.heightAnchor.constraint(equalToConstant: 32),
            
            productsStackView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor, constant: 16),
            productsStackView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            productsStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16),
            productsStackView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -20)
        ])
    }
    
    
    @objc private func deliverTapped() {
        print("Deliver button tapped")
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCell", for: indexPath) as! PromoCell
        cell.promoLabel.text = "UPCOMING\nHOLIDAYS SOON"
        cell.promoImageView.image = UIImage(named: "flowers")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 160)
    }
}
