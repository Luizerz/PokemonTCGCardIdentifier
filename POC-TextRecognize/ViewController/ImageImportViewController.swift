//
//  ImageImportViewController.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 11/05/23.
//

import UIKit
import Vision
import SwiftUI

class ImageImportViewController: UIViewController {

    private var viewModel: ViewModel

    private var pokemonCardName: PokemonCardsName = PokemonCardsName(names: [])
    private var sortedPokemonCardsName: [String] = []
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cardDescription: UILabel!
    public var caller: ((String) -> ())?
    @IBOutlet weak var addToMyCardsButton: UIButton!

    init?(coder: NSCoder, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
        
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonCardName = API.getPokemons()
        sortedPokemonCardsName = pokemonCardName.names.sorted { $0.count > $1.count }
        addToMyCardsButton.isEnabled = false
    }

    @IBAction func addImage(_ sender: Any) {
        callSheetAlert()
    }

    @IBAction func readCard(_ sender: Any) {
        //        recognizeText(image: imgView.image)
        present(AddCardViewController(cardNameToSearch: cardDescription.text!, viewModel: viewModel), animated: true)
    }


}

extension ImageImportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func callSheetAlert() {
        let ac = UIAlertController(title: "Select Image", message: "Select image from?", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (_) in
            print("Camera selected")
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryButton = UIAlertAction(title: "Library", style: .default) { (_) in
            print("Library selected")
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cameraButton)
        ac.addAction(libraryButton)
        ac.addAction(cancelButton)
        self.present(ac, animated: true, completion: nil)
    }

    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {

        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            print("Selected Source not available")
            return
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imgView.image = selectedImage
            imgView.backgroundColor = .clear
            recognizeText(image: imgView.image)

        } else {
            print("Image not found")
        }
        picker.dismiss(animated: true)
    }

    private func recognizeText(image: UIImage?) {

        var results: [String] = []
        guard let cgImage = image?.cgImage else {
            self.cardDescription.text = "No card to scan"
            return
        }

        // Handler

        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)

        // Request

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    self.cardDescription.text = "\(String(describing: error))"
                }
                return
            }

            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")

            DispatchQueue.main.async {
                let tempText = text.components(separatedBy: ", ")
                var finalStr: [String] = []
                for onText in tempText {
                    let text = onText.components(separatedBy: " ")
                    for t in text {
                        finalStr.append(t)
                    }
                }
                //                finalStr.sort { $0.count < $1.count }
                let literalFinalText = "\(finalStr[0]) \(finalStr[1]) \(finalStr[2]) \(finalStr[3])"
                print(literalFinalText)

                for pokemon in self.sortedPokemonCardsName {
                    if literalFinalText.contains(pokemon) {
                        results.append(pokemon)
                        print(results)
                    }
                }

                if !results.isEmpty {
                    if results.count != 1  {
                        results = [results.first!]
                    }
                    self.cardDescription.text = self.arrStringToString(string: results,option: "").capitalized(with: .current)
                    self.addToMyCardsButton.isEnabled = true
                }
                else {
                    self.cardDescription.text = "No card to scan"
                }
            }

            guard let caller = self.caller else {
                return
            }
            caller("Oi")
        }

        // Process Request

        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }

    private func arrStringToString(string: [String], option: String) -> String {
        var result: String = ""
        for word in string {
            result.append("\(word)\(option)")
        }
        return result
    }
}
