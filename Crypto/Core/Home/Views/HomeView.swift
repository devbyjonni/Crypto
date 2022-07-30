//
//  HomeView.swift
//  Crypto
//
//  Created by Jonni Akesson on 2022-07-30.
//

import SwiftUI

struct HomeView: View {

    @State private var showPortfilio: Bool = false

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                homeHeader
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfilio ? "plus" : "info")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfilio)
                )
            Spacer()
            Text("Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfilio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfilio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
}
