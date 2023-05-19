//
//  PopUpView.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 17/05/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PopUpView: View {

    @ObservedObject var viewModel: ViewModel

    private let colors: [Color] = [.red, .blue, .black, .green, .purple, .indigo, .yellow]

    private let adaptativeColumns = [
        GridItem(.adaptive(minimum: 453.75))
    ]
    @State var itemSize: CGSize = CGSize(width: 300, height: 453.75)
    @State private var selectedItem: String?
    @State private var value: Int = 1

    var body: some View {

        GeometryReader { proxy in
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(viewModel.data, id: \.self.id) { item in
                            ItemView(item: item, isSelected: selectedItem == item.id)
                                .onTapGesture {
                                    selectedItem = item.id
                                    //                                    print(selectedItem, item.id)
                                }
                            var _ = print(item.images.large)

                        }
                    }
                    .frame(height: 500)
                    .padding(.vertical)
                    //                    .padding()
                    //                    .fixedSize(horizontal: false, vertical: true)
                    //                    .background(.red)
                }

                HStack {
                    Spacer()
                    Stepper(
                        "Card Amout: \(value)",
                        value: $value,
                        in: 1...100,
                        step: 1
                    )
                    Spacer()
                }


                Button {
                    viewModel.adddedCards = [viewModel.data[0], viewModel.data[1]]
                } label: {
                    Text("Add Card")
                }

                Spacer()
            }
            .ignoresSafeArea()
        }
    }
}

//struct PopUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopUpView(data: [Card(id: "1", name: "Charizard", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png"))])
//    }
//}


struct ItemView: View {
    let item: Card
    var isSelected: Bool

    var body: some View {
        //        AsyncImageHack(url: URL(string: item.images.large), content: { phase in
        //            if let image = phase.image {
        //                image
        //                    .resizable()
        //                    .scaledToFit()
        //                    .border(isSelected ? .green : .clear, width: isSelected ? 3 : 0)
        //            } else if phase.error != nil {
        //                Text("error")
        //            } else {
        //                ProgressView()
        //            }
        //        })
        WebImage(url: URL(string: item.images.large))
            .resizable()
            .indicator(.progress)
            .frame(width: isSelected ? 350 : 300, height: isSelected ? 500 : 453.75)
            .scaledToFit()
    }
}


struct AsyncImageHack<Content> : View where Content : View {

    let url: URL?
    @ViewBuilder let content: (AsyncImagePhase) -> Content

    @State private var currentUrl: URL?

    var body: some View {
        AsyncImage(url: currentUrl, content: content)
            .onAppear {
                if currentUrl == nil {
                    DispatchQueue.main.async {
                        currentUrl = url
                    }
                }
            }
    }
}


//    var data: [Card] =     [Card(id: "111", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")), Card(id: "12", name: "mock2", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "1211", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "2", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "3", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "4", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "5", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "6", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "7", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "8", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png")),
//                            Card(id: "9", name: "mock", evolvesFrom: nil, images: CardImages(small: "", large: "https://images.pokemontcg.io/gym2/2_hires.png"))]
