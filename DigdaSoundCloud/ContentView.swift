//
//  ContentView.swift
//  DigdaSoundCloud
//
//  Created by jose Yun on 2023/05/06.
//

import SwiftUI
import AVKit

let WIDTH: CGFloat = 327 // edit please

struct InfoView: View {
    
    var body: some View {
        HStack(spacing: 22){
            VStack(alignment: .leading, spacing: 5){
                Text("이것은제목입니")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("이것은가수입니다")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.8)
            }
            Spacer()
            Image(systemName: "ellipsis.circle.fill").foregroundColor(.white).font(.system(size: 30))
        }.frame(width: WIDTH)
    }
}


struct IconView: View {
    
    var body: some View {
        HStack{
            Image(systemName: "heart").foregroundColor(.white).font(.system(size: 18)).fontWeight(.heavy)
            Spacer()
            Image(systemName: "text.bubble").foregroundColor(.white).font(.system(size: 18)).fontWeight(.heavy)
            Spacer()
            Image(systemName: "square.and.arrow.up").foregroundColor(.white).font(.system(size: 18)).fontWeight(.heavy)
            Spacer()
            Image(systemName: "list.bullet").foregroundColor(.white).font(.system(size: 18)).fontWeight(.heavy)
        }.frame(width: WIDTH)
    }
}


struct CommentView: View {
    
    var body: some View {
        HStack(spacing: 15){
            Circle()
                .foregroundColor(Color(red:65/255, green:65/255, blue:65/255))
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(red:65/255, green:65/255, blue:65/255))
        }
        .frame(height: 40)
    }
}

struct shape: Shape {
    var size: Double
    let width = 8.0
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: width, y: 0), controlPoint1: CGPoint(x: 0, y: -width), controlPoint2: CGPoint(x: width, y: -width))
        path.addLine(to: CGPoint(x: width, y: size))
        path.addCurve(to: CGPoint(x: 0, y: size), controlPoint1: CGPoint(x: width, y: size + width), controlPoint2: CGPoint(x: 0, y: size + width))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        return Path(path.cgPath)
    }
}

struct PlayBarView: View {
    @ObservedObject var musicModel: MusicModel
    
    let barCount = 26
    let arr: [Double] = [8.0, 16.0, 24.0, 32.0, 40.0]
    
    @State var variation = 0.0
    @State var time: Int = 0
    
    @State var shapeSize: [Double] = []
    @State var lastRemaining: Float = 0.0
    
    init(musicModel: MusicModel) {
        self.musicModel = musicModel
        self.variation = variation
        self.time = time
        self._shapeSize = State(initialValue: (0..<self.barCount).map { _ in self.arr[Int.random(in: 0...4)] })
    }
    
    
    var body: some View {
        GeometryReader { geo in
            HStack(){
                ForEach(0..<barCount, id: \.self) { i in
                    shape(size: shapeSize[i])
                        .fill(i == time ? LinearGradient(
                            gradient: .init(colors: [.orange, .gray]),
                            startPoint: UnitPoint(x:variation*2-0.5, y:0.5),
                            endPoint: UnitPoint(x:variation*2+0.5, y:0.5)
                        ) : (i < time ? LinearGradient(
                            gradient: .init(colors: [.orange, .orange]),
                            startPoint: .top,
                            endPoint: .bottom
                        ) : LinearGradient(
                            gradient: .init(colors: [.gray, .gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )))
                        .offset(x:0, y:(40-20-shapeSize[i])/2)
                }
            }
            .onAppear{
                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                    time = Int(musicModel.calculateProgress(curTime: musicModel.curTime) * Float(barCount))
                    let remaining = (musicModel.calculateProgress(curTime: musicModel.curTime) * Float(barCount)).truncatingRemainder(dividingBy:1)
                    withAnimation(.linear(duration: 0.01)){
                        if lastRemaining < remaining{
                            variation = Double(remaining)
                        }
                    }
                    if lastRemaining > remaining {
                        variation = 0.0
                        lastRemaining = 0.0
                    }
                    lastRemaining = remaining
                }
            }
            .onTapGesture (coordinateSpace: .local) { location in
                let curPer = min(max(location.x / geo.size.width,0),1)
                print("Tapped at \(location.x / geo.size.width)\n \(curPer * musicModel.duration)")
                musicModel.seek(time: curPer * musicModel.duration)
            }
        }
    }
}

struct PlayView: View {
    
    @StateObject var musicModel: MusicModel
    var body: some View {
        VStack(spacing: 25){
                CommentView()
                PlayBarView(musicModel: musicModel)
                HStack{
                    Text("0:00").font(.system(size: 12))
                    Spacer()
                    Text("-1:30").font(.system(size: 12))
                }.foregroundColor(.white)
            }.frame(width: WIDTH)
    }
}

struct AlbumView: View {
    
    @ObservedObject var musicModel: MusicModel
    var body: some View {
        
            Image("albumCover").resizable()
                .frame(width: 327, height: 327)
                .overlay{
                    Rectangle()
                        .stroke(.white, lineWidth: 1)
                }.shadow(color: .white, radius: 4, y: 2)
            .onTapGesture {
                withAnimation(.linear(duration: 0.2)){
                    musicModel.pause()
                }
            }.onAppear(perform: {
                withAnimation(.linear) {
                    musicModel.play()
                }
            })
    
    }
}

struct AlbumBackgroundView: View{
    var body: some View {
            Image("albumCover").resizable().scaledToFill().blur(radius: 10, opaque: true)
                .overlay{
                    LinearGradient(colors: [Color.black.opacity(0.2), Color.black.opacity(0.05)], startPoint: .top, endPoint: .bottom)
                }
    }
}

struct ContentView: View {
    @ObservedObject var musicModel: MusicModel
    
    // should be true
    @State var play: Bool = false
    
    var body: some View {
        ZStack{
            AlbumBackgroundView().ignoresSafeArea()
            VStack(spacing: 25){
                InfoView()
                Spacer()
                if musicModel.playing {
                    AlbumView(musicModel: musicModel)
                } else {
                    PauseView(musicModel: musicModel)
                }
                PlayView(musicModel: musicModel)
                Spacer()
                IconView()
            }.padding([.horizontal], 20)
            .padding([.top], 47)
            .padding([.bottom], 34)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(musicModel: MusicModel(sound: "mercury"))
    }
}

struct PauseView: View {
    
    @ObservedObject var musicModel: MusicModel
    var body: some View {
        
        HStack{
            
            Image(systemName: "backward.fill")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.heavy)
            
            Spacer()
 
            Image(systemName: "play.circle.fill")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.heavy)
                .onTapGesture {
                        musicModel.playing.toggle()
                }
            
            Spacer()
            
            Image(systemName: "forward.fill")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.heavy)
            
            
        }.frame(width: WIDTH + 20, height: WIDTH)

    }
}
