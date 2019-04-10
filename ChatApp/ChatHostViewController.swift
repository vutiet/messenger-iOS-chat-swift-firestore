//
//  ChatHostViewController.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/18/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ChatHostViewController: UIViewController, UITabBarControllerDelegate {

    var homeVC: ATCChatHomeViewController
    let uiConfig: ATCUIGenericConfigurationProtocol
    var viewer: ATCUser

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         threadsDataSource: ATCGenericCollectionViewControllerDataSource,
         viewer: ATCUser) {
        self.uiConfig = uiConfig
        self.viewer = viewer
        self.homeVC = ATCChatHomeViewController.homeVC(uiConfig: uiConfig, threadsDataSource: threadsDataSource, viewer: viewer)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var hostController: ATCHostViewController = { [unowned self] in
        let menuItems: [ATCNavigationItem] = [
            ATCNavigationItem(title: "Home",
                              viewController: homeVC,
                              image: UIImage.localImage("bubbles-icon", template: true),
                              type: .viewController,
                              leftTopView: nil,
                              rightTopView: nil),
        ]
        let menuConfiguration = ATCMenuConfiguration(user: nil,
                                                     cellClass: ATCCircledIconMenuCollectionViewCell.self,
                                                     headerHeight: 0,
                                                     items: menuItems,
                                                     uiConfig: ATCMenuUIConfiguration(itemFont: uiConfig.regularMediumFont,
                                                                                      tintColor: uiConfig.mainTextColor,
                                                                                      itemHeight: 45.0,
                                                                                      backgroundColor: uiConfig.mainThemeBackgroundColor))

        let config = ATCHostConfiguration(menuConfiguration: menuConfiguration,
                                          style: .tabBar,
                                          topNavigationRightView: nil,
                                          topNavigationLeftImage: UIImage.localImage("three-equal-lines-icon", template: true),
                                          topNavigationTintColor: uiConfig.mainThemeForegroundColor,
                                          statusBarStyle: uiConfig.statusBarStyle,
                                          uiConfig: uiConfig)
        return ATCHostViewController(configuration: config)
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewControllerWithView(hostController)
        hostController.view.backgroundColor = uiConfig.mainThemeBackgroundColor
        
        fetchConversations()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return uiConfig.statusBarStyle
    }
    
    private func fetchConversations() {
        NM3FirebaseConversationService.fetchConversations(userId: "dan") { (threads) in
            for thread in threads {
//                print("thread: \(thread.messageId) ----- \(thread.channelId)")
                self.homeVC.threadsVC?.genericDataSource?.addObject(newObject: thread)
            }
            DispatchQueue.main.async {
                self.homeVC.threadsVC?.genericDataSource?.loadFirst()
            }
        }
    }
}
