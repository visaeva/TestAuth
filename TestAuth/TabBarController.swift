//
//  TabBarController.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black // цвет для выбранного таба
               tabBar.unselectedItemTintColor = UIColor(named: "tabColor")
        
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Gifts", image: UIImage(named: "tab1"), tag: 0)

        let tab2Nav = UINavigationController(rootViewController: EmptyViewController(title: "Gifts"))
        tab2Nav.tabBarItem = UITabBarItem(title: "Gifts", image: UIImage(named: "tab2"), tag: 1)

        let tab3Nav = UINavigationController(rootViewController: EmptyViewController(title: "Events"))
        tab3Nav.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "tab3"), tag: 2)

        let tab4Nav = UINavigationController(rootViewController: EmptyViewController(title: "Cart"))
        tab4Nav.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(named: "tab4"), tag: 3)

        let tab5Nav = UINavigationController(rootViewController: EmptyViewController(title: "Profile"))
        tab5Nav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "tab5"), tag: 4)

        viewControllers = [homeNav, tab2Nav, tab3Nav, tab4Nav, tab5Nav]
    }
}
