//
//  MusicModel.swift
//  DigdaSoundCloud
//
//  Created by jose Yun on 2023/05/06.
//

import Foundation
import AVFoundation

//TODO: COMMON TASK! 공유할 데이터모델 함께 만들어보아요!
class MusicModel: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer
    @Published var playing: Bool
    
    init(sound: String){
        let url = Bundle.main.url(forResource: sound, withExtension: "mp3")!
        self.audioPlayer = try! AVAudioPlayer(contentsOf: url)
        self.playing = false
    }
    
    func play(){
        audioPlayer.play()
        playing = true
    }
    
    func pause() {
        audioPlayer.pause()
        playing = false
    }
    
    
    var duration: Double {
        return audioPlayer.currentTime
    }
    
    func calculateProgress(duration: Double) -> Float {
        return Float(duration / audioPlayer.duration)
    }
    
    func seek(time: TimeInterval) {
        audioPlayer.play(atTime: time)
    }
    
    private func convertFloatToCMTime(_ percentage: Float) -> CMTime {
        return CMTime(seconds: duration * Double(percentage), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
    
    
    
}
