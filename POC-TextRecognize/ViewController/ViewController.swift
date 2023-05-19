//
//  ViewController.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 11/05/23.
//

import UIKit
import Vision

class ViewController: UIViewController {

    private var buttonCounter = 1
    private let nextPokemonButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("NEXT", for: .normal)
        return button
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "TO AQUIIIIIII"
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "example1")
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = .red
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(nextPokemonButton)
        nextPokemonButton.addTarget(self, action: #selector(nextPokemon), for: .touchUpInside)
        setContraints()
        recognizeText(image: imageView.image)
    }

    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("Could not get cgImage")
        }

        // Handler

        let handler = VNImageRequestHandler(cgImage: cgImage)

        // Request

        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    self?.label.text = "\(String(describing: error))"
                }
                return
            }
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")

            DispatchQueue.main.async {
                let tempText = text.split(separator: ",")
                let finalText = "\(tempText[0]), \(tempText[1]), \(tempText[2])"
                print("\(tempText[0]), \(tempText[1]), \(tempText[2])")
                self?.label.text = finalText
            }
        }

        // Process Request

        do {
            try handler.perform([request])
        } catch {

        }
    }

    // Constraints
    private func setContraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextPokemonButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            nextPokemonButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextPokemonButton.widthAnchor.constraint(equalToConstant: 200),
            nextPokemonButton.heightAnchor.constraint(equalToConstant: 60)
        ])

    }

    @objc func nextPokemon() {
        buttonCounter += 1
        if buttonCounter > 4 {
            buttonCounter = 1
        }
        imageView.image = UIImage(named: "example\(buttonCounter)")
        recognizeText(image: imageView.image)
    }

}

