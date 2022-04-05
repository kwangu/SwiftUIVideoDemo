//
//  ContentView.swift
//  Shared
//
//  Created by 강관구 on 2022/02/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var videoUrl: URL?
    @State var pickerShow: Bool = false
    @State var player: AVPlayer?
    
    var body: some View {
        VStack {

            if let player = player {
                VideoPlayerSection(player: player)
                    .onAppear {
                        self.player?.play()
                }
                .onTapGesture {
                    if self.player?.timeControlStatus == .playing {
                        self.player?.pause()
                    } else {
                        self.player?.play()
                    }
                }
            } else {
                EmptyView()
            }

            Button(action: {
                pickerShow.toggle()
            }, label: {
                Text("선택")
            })
        }
        .sheet(isPresented: $pickerShow) {
            ImagePicker(image: .constant(nil), videoUrl: $videoUrl, isShown: $pickerShow)
        }
        .onChange(of: videoUrl) { localURL in
            if let localURL = localURL {
                print(localURL)
                self.player = AVPlayer(url: localURL)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
