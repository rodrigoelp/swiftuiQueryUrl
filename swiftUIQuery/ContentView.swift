//
//  ContentView.swift
//  swiftUIQuery
//
//  Created by Rod Landaeta on 15/9/19.
//  Copyright © 2019 Rod Landaeta. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 8) {
            Text("I know... \nthis is the most beautiful user interface you have ever seen.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            TextField("Write down anything here.", text: $state.query)
            Text("Here is the result:")
                .font(.subheadline)
            Text(state.result)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
