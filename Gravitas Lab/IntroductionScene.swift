import SwiftUI

struct IntroductionScene: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "3D2B56"), Color(hex: "CC5A71")]),
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
            .edgesIgnoringSafeArea(.all)

            HStack {
                VStack(alignment: .leading){
                    Image("icon")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .cornerRadius(15)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                            .font(.system(size: 30))
                        Text("Gravitas Lab")
                            .font(.system(size: 70))
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: SecondScene()){
                    Text("Next →")
                        .font(.system(size: 24))
                }
            }
            .padding(60)
            .padding(.leading, 25)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .foregroundColor(.white)
        }
    }
}

struct SecondScene: View{
    @State private var showMain = false
    
    var body: some View{
        VStack {
            Text("Get ready to explore the realm of physics. Try this!")
                .font(.system(size: 30))
            Button("Start"){
                showMain = true
            }
            .font(.system(size: 24))
            .padding(5)
            .padding(_: 10)
            .foregroundColor(.white)
            .background(Color(hex: "CC5A71"))
            .cornerRadius(10)
            .bold()
        }
        .fullScreenCover(isPresented: $showMain){
            MainScene()
        }
    }
}

#Preview {
    IntroductionScene()
}
