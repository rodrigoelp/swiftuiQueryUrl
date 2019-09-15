//
//  AppState.swift
//  swiftUIQuery
//
//  Created by Rod Landaeta on 15/9/19.
//  Copyright © 2019 Rod Landaeta. All rights reserved.
//

import Foundation
import Combine

// This object will be instantiated in the SceneDelegate and passed as an environment object.
class AppState: ObservableObject {
    // The following is the cancellable you need to keep a reference to
    // if you want the subscription to provide a stream of values.
    private var cancellable: AnyCancellable? = nil

    // A few of the auto publishers...
    // One to receive the text stream in (query)
    // and one as the output.
    @Published var query = ""
    @Published var result = ""

    init() {
        cancellable = $query
            // first, we wait until the user has stopped typing... (unless they are slow at typing).
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map({
                // once it has triggered, let's clean some of the input,
                // we don't want too many useless spaces
                // and whatever we generate, needs to be escaped to prevent
                // malformed queries.
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            })
            .filter({ $0 != ""})
            // and prevent it from firing all the time if the input hasn't really changed.
            .removeDuplicates()
            // with the input ready, we just post the request...
            .map({ URL(string: "https://postman-echo.com/get?myParameter=\($0)")! })
            // as we are about to turn the URL into an actual request,
            // let's prepare the Publisher from not being able to generate errors.
            // To understand we might generate errors.
            .setFailureType(to: Error.self)
            .flatMap({ url -> AnyPublisher<String, Error> in
                URLSession
                    .shared
                    .dataTaskPublisher(for: url)
                    .mapError({ $0 as Error })
                    .map({ $0.data })
                     // turning my data into a string, as I will be displaying strings... I could do this later if I wanted.
                    .map({ String(bytes: $0, encoding: .utf8)! })
                    .eraseToAnyPublisher()
            })
            .catch({ error in
                // as I will be assigning this new stream to an attribute
                // that will publish values, I have to handle error that
                // may have been generated along the way. In this case, I am just ignoring any error.
                Just("There was an error... you should check it out \n\(String(describing: error))")
            })
            // pushing the new published values into the result auto publisher.
            .assign(to: \AppState.result, on: self)
    }

    deinit {
        // disposing of any subscription or query in progress...
        cancellable?.cancel()
        cancellable = nil
    }
}
