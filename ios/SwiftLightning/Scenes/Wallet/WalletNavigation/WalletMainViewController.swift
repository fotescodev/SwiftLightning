//
//  WalletMainViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-20.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WalletMainDisplayLogic: class {
  func displayBalances(viewModel: WalletMain.UpdateBalances.ViewModel)
  func displayBalancesError(viewModel: WalletMain.UpdateBalances.ErrorVM)
}


class WalletMainViewController: UIViewController, WalletMainDisplayLogic
{
  var interactor: WalletMainBusinessLogic?
  var router: (NSObjectProtocol & WalletMainRoutingLogic & WalletMainDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: IBOutlets
  
  @IBOutlet weak var totalBalanceLabel: UILabel!
  @IBOutlet weak var channelBalanceLabel: UILabel!
  
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = WalletMainInteractor()
    let presenter = WalletMainPresenter()
    let router = WalletMainRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateBalances()
  }
  
  
  // MARK: Pay
  
  @IBAction func payTapped(_ sender: SLBarButton) {
    router?.routeToPayMain()
  }
  
  
  // MARK: Receive
  
  @IBAction func receiveTapped(_ sender: SLBarButton) {
    router?.routeToReceiveMain()
  }
  
  
  // MARK: Update Balance - This is Temporary
  
  @IBAction func updateBalanceTapped(_ sender: SLBarButton) {
    updateBalances()
  }
  
  private func updateBalances() {
    let request = WalletMain.UpdateBalances.Request()
    interactor?.updateBalances(request: request)
  }
  
  func displayBalances(viewModel: WalletMain.UpdateBalances.ViewModel) {
    DispatchQueue.main.async {
      self.totalBalanceLabel.text = viewModel.totalBalanceString
      self.channelBalanceLabel.text = viewModel.channelBalanceString
    }
  }
  
  func displayBalancesError(viewModel: WalletMain.UpdateBalances.ErrorVM) {
    let alertDialog = UIAlertController(title: viewModel.errTitle, message: viewModel.errMsg, preferredStyle: .alert).addAction(title: "OK", style: .default)
    
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
    }
  }
  
  // MARK: Open Channel - This is Temporary.
  
  @IBAction func openChannel(_ sender: SLBarButton) {
    let storyboard = UIStoryboard(name: "ChannelOpen", bundle: nil)
    let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChannelOpenViewController") as! ChannelOpenViewController
    navigationController?.pushViewController(destinationVC, animated: true)
  }
  
}