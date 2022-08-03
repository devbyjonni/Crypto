//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Jonni Akesson on 2022-07-31.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "title", value: "value", percentageChange: 0),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value", percentageChange: -7)
    ]

    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""

    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.addSubscribers()
    }

    func addSubscribers() {
        // updates all coins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterCoins)
            .sink { [weak self] returnedCoind in
                self?.allCoins = returnedCoind
            }
            .store(in: &cancellables)
    }

    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }

        let lowerCaseText = text.lowercased()

        return coins.filter { coin in
            return coin.name.lowercased().contains(lowerCaseText) ||
            coin.symbol.lowercased().contains(lowerCaseText) ||
            coin.id.lowercased().contains(lowerCaseText)
        }
    }
}
