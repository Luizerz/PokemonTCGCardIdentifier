//
//  CardModel.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 15/05/23.
//

import Foundation

struct CardsData: Decodable {
    let data: [Card]
}

struct Card: Decodable {
    let id,name: String
    let evolvesFrom: String?
    let images: CardImages
}

struct CardImages: Decodable {
    let small, large: String
}

struct CardToAdd {

}
