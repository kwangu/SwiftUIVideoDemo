//
//  VideoPlayerSection.swift
//  VideoDemo
//
//  Created by 강관구 on 2022/02/22.
//

import Foundation
import SwiftUI
import UIKit
import AVKit

struct VideoPlayerSection: UIViewControllerRepresentable {
    
    var player: AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayerSection>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VideoPlayerSection.UIViewControllerType, context: UIViewControllerRepresentableContext<VideoPlayerSection>) {
        
    }
}
