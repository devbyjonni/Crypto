//
//  CoinDataService.swift
//  Crypto
//
//  Created by Jonni Akesson on 2022-07-31.
//

import Foundation
import Combine

class CoinDataService {

    @Published var allCoins: [CoinModel] = []

    private var coinSubscrition: AnyCancellable?

    init() {
        getcoins()
    }

    private func getcoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }

        coinSubscrition = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let restponse = output.response as? HTTPURLResponse,
                      restponse.statusCode >= 200 && restponse.statusCode < 300 else {
                    throw URLError(.badServerResponse)

                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnCoins in
                self?.allCoins = returnCoins
                self?.coinSubscrition?.cancel()
            }
    }
}
