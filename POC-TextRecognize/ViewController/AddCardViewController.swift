//
//  AddCardViewController.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 16/05/23.
//

import UIKit
import SwiftUI



class AddCardViewController: UIViewController {

    private let cardNameToSearch: String
    private var viewModel: ViewModel

    private lazy var hostingController = UIHostingController(rootView: PopUpView(viewModel: viewModel))

    init(cardNameToSearch: String, viewModel: ViewModel) {
        self.cardNameToSearch = cardNameToSearch
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        Task {
            let cards = try await API.searchCard(cardNameToSearch)
            self.viewModel.data = cards
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        dump(cardNameToSearch)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        setSwiftUIViewContrarints()
    }

    private func setSwiftUIViewContrarints() {
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
