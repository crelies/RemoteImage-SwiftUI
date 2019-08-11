//
//  RemoteImage.swift
//  RemoteImage
//
//  Created by Christian Elies on 11.08.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import SwiftUI

struct RemoteImage<ErrorView: View, ImageView: View, LoadingView: View>: View {
    private let url: URL
    private let errorView: (Error) -> ErrorView
    private let image: (Image) -> ImageView
    private let loadingView: () -> LoadingView
    @ObservedObject private var service: RemoteImageService = RemoteImageService()
    
    var body: some View {
        switch service.state {
            case .error(let error):
                return AnyView(
                    errorView(error)
                )
            case .image(let image):
                return AnyView(
                    self.image(Image(uiImage: image))
                )
            case .loading:
                return AnyView(
                    loadingView().onAppear {
                        self.service.fetchImage(atURL: self.url)
                    }
                )
        }
    }
    
    init(url: URL, @ViewBuilder errorView: @escaping (Error) -> ErrorView, image: @escaping (Image) -> ImageView, @ViewBuilder loadingView: @escaping () -> LoadingView) {
        self.url = url
        self.errorView = errorView
        self.image = image
        self.loadingView = loadingView
    }
}

#if DEBUG
struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://images.unsplash.com/photo-1524419986249-348e8fa6ad4a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80")!
        return RemoteImage(url: url, errorView: { error in
            Text(error.localizedDescription)
        }, image: { image in
            image
        }, loadingView: {
            Text("Loading ...")
        })
    }
}
#endif
