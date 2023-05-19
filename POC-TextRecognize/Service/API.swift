//
//  API.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 11/05/23.
//

import Foundation

struct Router {
    private init() {}
    static let rootURL = "https://api.pokemontcg.io/v2/cards?q=name:"
}

struct API {
    // Local
    static func getPokemons() -> PokemonCardsName {
        let filePath = Bundle.main.url(forResource: "output", withExtension: "txt")
        var tempCardsName = Set<String>()
        do {
            let myString = try String(contentsOf: filePath!)
            let components = myString.components(separatedBy: ", ")
            for name in components {
                tempCardsName.insert(name)
            }
            dump(tempCardsName.count)
        } catch {
            print(error)
        }
        return PokemonCardsName(names: Array(tempCardsName))
    }
    // Requisicao Web
    static func searchCard(_ cardName: String) async throws -> [Card] {
        var urlRequest = URLRequest(url: URL(string: "\(Router.rootURL)\(cardName)")!)
        urlRequest.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let cardDecoded = try JSONDecoder().decode(CardsData.self, from: data)
        return cardDecoded.data
    }

}
