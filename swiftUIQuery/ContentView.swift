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
        VStack(alignment: .leading, spacing: 8) {
            Text("I know!")
                .font(.title)

            Text("This is the most beautiful user interface you have ever seen.")
                .font(.system(size: 20))
                .lineLimit(3)

            TextField("Write down anything here.", text: $state.query)

            Text("Here is the result:")
                .font(.subheadline)

            Text(state.result)
                .lineLimit(10)

        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
