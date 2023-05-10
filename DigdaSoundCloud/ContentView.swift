//
//  ContentView.swift
//  DigdaSoundCloud
//
//  Created by jose Yun on 2023/05/06.
//

import SwiftUI
import AVKit

let WIDTH: CGFloat = 338 // edit please

struct InfoView: View {
    
    var body: some View {
        HStack(spacing: 22){
            VStack(alignment: .leading, spacing: 5){
                Text("Colin")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Bye Bye Badman")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.8).offset(x:2.5)
            }
            Spacer()
            Image(systemName: "ellipsis.circle.fill").foregroundColor(.white).font(.system(size: 25))
        }.frame(width: WIDTH)
    }
}


struct IconView: View {
    
    var body: some View {
        HStack{
            Image(systemName: "heart").foregroundColor(.white).font(.system(size: 22))
            Spacer()
            Image(systemName: "text.bubble").foregroundColor(.white).font(.system(size: 22))
            Spacer()
            Image(systemName: "square.and.arrow.up").foregroundColor(.white).font(.system(size: 22))
            Spacer()
            Image(systemName: "list.bullet").foregroundColor(.white).font(.system(size: 22))
        }.frame(width: WIDTH)
    }
}


struct CommentView: View {
    @Binding var time: Int
    
    var body: some View {
        HStack(spacing: 15){
            
            if (time >= 20 && time < 24)
            {
                Image("dog").resizable().scaledToFit().mask{
                    Circle()
                    .foregroundColor(Color(red:65/255, green:65/255, blue:65/255))
                }
                    RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(red:65/255, green:65/255, blue:65/255)).opacity(0.7)
                    .frame(width: 130, height: 35)
                    .overlay {
                        Text("Mung loves dat!").foregroundColor(.white).opacity(0.95)
                            
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }
                                
            } else if (time >= 10 && time < 14) {
                
                Image("luime").resizable().scaledToFit().mask{
                    Circle()
                    .foregroundColor(Color(red:65/255, green:65/255, blue:65/255))
                }
                    RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(red:65/255, green:65/255, blue:65/255)).opacity(0.7)
                    .frame(width: 130, height: 35)
                    .overlay {
                        Text("Feelin the vibeee!").foregroundColor(.white).opacity(0.95)
                            
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }
                
                
            } else {
                Color.clear.frame(width: 130, height: 35)
            }
        }
        .frame(height: 40)
    }
}

struct shape: Shape {
    var size: Double
    let width = 4.0
    
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
    
    let barCount = 40
    let arr: [Double] = [8.0, 16.0, 32.0, 40.0, 54.0]
    
    @State var variation = 0.0
    @State var time: Int = 0
    
    @State var initialSize: [Double] = []
    @State var shapeSize: [Double] = []
    @State var lastRemaining: Float = 0.0
    
    init(musicModel: MusicModel) {
        self.musicModel = musicModel
        self.variation = variation
        self.time = time
        self._initialSize = State(initialValue: (0..<self.barCount).map { _ in self.arr[Int.random(in: 0...4)] })
        self._shapeSize = self._initialSize
    }
    
    
    var body: some View {
        VStack(spacing: 30) {
            CommentView(time: $time)
            GeometryReader { geo in
                HStack(){
                    ForEach(0..<barCount, id: \.self) { i in
                        shape(size: shapeSize[i])
                            .fill(i == time ? LinearGradient(
                                gradient: .init(colors: [.orange,.musicBar]),
                                startPoint: UnitPoint(x:variation*4-0.5, y:0.5),
                                endPoint: UnitPoint(x:variation*4+0.5, y:0.5)
                            ) : (i < time ? LinearGradient(
                                gradient: .init(colors: [.orange, .orange]),
                                startPoint: .top,
                                endPoint: .bottom
                            ) : LinearGradient(
                                gradient: .init(colors: [.musicBar, .musicBar]),
                                startPoint: .top,
                                endPoint: .bottom
                            )))
                            .offset(x:0, y:(40-20-shapeSize[i])/2)
                    }
                }
                .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                        
                        if musicModel.playing == false{
                            withAnimation(.spring(response:0.4, dampingFraction: 0.8, blendDuration: 1.0)){
                                self.shapeSize = (0..<self.barCount).map { _ in self.arr[Int.random(in: 0...0)]
                                }
                            }
                        }
                        else {
                            withAnimation(.spring(dampingFraction: 0.6)){
                                self.shapeSize = self.initialSize
                            }
                        }
                        
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
                }.gesture(DragGesture(coordinateSpace: .local)
                    .onChanged { gesture in
                        let curPer = min(max(gesture.location.x / geo.size.width,0),1)
                        musicModel.seek(time: curPer * musicModel.duration)
                    })
                .onTapGesture (coordinateSpace: .local) { location in
                    let curPer = min(max(location.x / geo.size.width,0),1)
                    print("Tapped at \(location.x / geo.size.width)\n \(curPer * musicModel.duration)")
                    musicModel.seek(time: curPer * musicModel.duration)
                }
            }
        }
    }
}

struct PlayView: View {
    
    @StateObject var musicModel: MusicModel
    var body: some View {
        VStack(spacing: 30){
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
                .frame(width: WIDTH, height: WIDTH)
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
            VStack(spacing: 18){
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
                .foregroundColor(.white).opacity(0.7)
                .font(.system(size: 36))
                
            
            Spacer()
 
            Image(systemName: "play.circle.fill")
                .foregroundColor(.white).opacity(0.7)
                .font(.system(size: 56))
                .onTapGesture {
                        musicModel.playing.toggle()
                }
            
            Spacer()
            
            Image(systemName: "forward.fill")
                .foregroundColor(.white).opacity(0.7)
                .font(.system(size: 36))
            
            
        }.frame(width: WIDTH, height: WIDTH)

    }
}

extension Color {
    static let musicBar = Color("musicBar")
}
