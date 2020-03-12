import SwiftUI

public struct RemoteImageView<Content: View>: View {
  @ObservedObject var imageFetcher: RemoteImageFetcher
  var content: (_ image: Image) -> Content
  let placeholder: Image
  
  @State var previousURL: URL? = nil
  @State var imageData = Data()
  
  public init(placeholder: Image,
              imageFetcher: RemoteImageFetcher,
              content: @escaping (_ image: Image) -> Content ) {
    self.placeholder = placeholder
    self.imageFetcher = imageFetcher
    self.content = content
  }
  
  public var body: some View {
    DispatchQueue.main.async {
      if self.previousURL != self.imageFetcher.getUrl() {
        self.previousURL = self.imageFetcher.getUrl()
      }
      if !self.imageFetcher.getImageData().isEmpty {
        self.imageData = self.imageFetcher.getImageData()
      }
    }
    var image: Image? = nil
    if let uiImage = UIImage(data: self.imageData) {
      image = Image(uiImage: uiImage)
    }
    
    return ZStack {
      if image != nil {
        self.content(image!)
      }
      else {
        self.content(placeholder)
      }
    }
    .onAppear(perform: self.loadImage)
  }
  
  private func loadImage() {
    self.imageFetcher.fetch()
  }
}
