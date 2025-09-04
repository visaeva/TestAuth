//
//  HomeViewModel.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import Foundation

class HomeViewModel {
    let categories: [Category] = [
        Category(title: "New Popular\nArrivals", imageName: "category1"),
        Category(title: "Mixed Flowers", imageName: "category2"),
        Category(title: "Thank you", imageName: "category3")
    ]
    
    let products: [Product] = [
        Product(imageName: "product1"),
        Product(imageName: "product2")
    ]
    
    let promos: [Promo] = [
        Promo(title: "UPCOMING\nHOLIDAYS SOON", imageName: "flowers"),
        Promo(title: "UPCOMING\nHOLIDAYS SOON", imageName: "flowers"),
        Promo(title: "UPCOMING\nHOLIDAYS SOON", imageName: "flowers")
    ]
}
