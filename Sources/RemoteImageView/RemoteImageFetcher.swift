import SwiftUI

public class RemoteImageFetcher: ObservableObject {
  @Published var imageData = Data()
  let url: URL
  
  public init(from url: URL) {
    self.url = url
  }
  
  public func fetch() {
    URLSession.shared.dataTask(with: self.url){(data, _, _) in
      guard let data = data else { return }
      DispatchQueue.main.async {
        self.imageData = data
      }
    }
    .resume()
  }
  
  public func getImageData() -> Data {
    return self.imageData
  }
  
  public func getUrl() -> URL {
    return self.url
  }
  
  public func purge() {
    self.imageData = Data()
  }
}
