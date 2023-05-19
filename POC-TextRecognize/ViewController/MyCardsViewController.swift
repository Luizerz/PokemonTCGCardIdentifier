//
//  MyCardsViewController.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 15/05/23.
//

import UIKit
import SwiftUI
import Combine

class ViewModel: ObservableObject {

    @Published var data: [Card] = []
    @Published var adddedCards: [Card] = []

}

class MyCardsViewController: UIViewController {

//    private var viewModel: ViewModel = ViewModel()
    private var viewModel: ViewModel = ViewModel()
    private var cancellable: AnyCancellable?

    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "example1")
        return imageView
    }()

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        dump(viewModel.adddedCards)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = viewModel.$adddedCards.sink { [weak self] state in
            print(state)
            self?.setImageWeb(state.first?.images.large)
        }
        //        navigationController?.navigationBar.prefersLargeTitles = true
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        self.navigationItem.setRightBarButtonItems([add], animated: true)
        self.navigationController?.isToolbarHidden = false
        view.addSubview(cardImageView)
        setImageViewConstraints()
    }

    private func setImageWeb(_ link: String?) {
        let url = link
        if link != nil {
            cardImageView.sd_setImage(with: URL(string: url!)!)
        }
        else {

        }
    }

    @objc func addTapped() {
        let stb = UIStoryboard(name: "Main", bundle: .main)
        let destiny = stb.instantiateViewController(identifier: "ImageBoard") { coder in
            ImageImportViewController(coder: coder, viewModel: self.viewModel)
        }
        show(destiny, sender: nil)
        print(viewModel.adddedCards)

    }

    func setImageViewConstraints() {
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            cardImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            cardImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

}
