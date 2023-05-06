//
//  ContentView.swift
//  DigdaSoundCloud
//
//  Created by jose Yun on 2023/05/06.
//

import SwiftUI

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
        }.frame(height: 40)
    }
}

//TODO: JUN! 재생 상태에 따라 파동인지 바 형태인지 바꿔주시면 됩니다!
struct PlayBarView: View {
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 332, height: 4)
                .foregroundColor(.white)
        }
    }
}

struct PlayView: View {
    
    var body: some View {
        VStack(spacing: 25){
                CommentView()
                PlayBarView()
                HStack{
                    Text("0:00").font(.system(size: 12))
                    Spacer()
                    Text("-1:30").font(.system(size: 12))
                }.foregroundColor(.white)
            }.frame(width: WIDTH)
    }
}

struct AlbumView: View {
    var body: some View {
        
        Image("albumCover").resizable()
            .frame(width: 327, height: 327)
            .overlay{
                Rectangle()
                    .stroke(.white, lineWidth: 1)
            }.shadow(color: .white, radius: 4, y: 2)
            
        
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
    var body: some View {
        ZStack{
            AlbumBackgroundView().ignoresSafeArea()
            VStack(spacing: 25){
                InfoView()
                Spacer()
                AlbumView()

                PlayView()
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
        ContentView()
    }
}
