import SwiftUI

struct HomeView: View {

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [.black, .purple.opacity(0.8), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {

                    Spacer()

                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 90))
                        .foregroundColor(.cyan)

                    Text("GameVerse")
                        .font(.system(size: 45, weight: .heavy))
                        .foregroundColor(.white)

                    Text("Choose Your Challenge")
                        .foregroundColor(.gray)

                    Spacer()

                    NavigationLink {
                        ContentView()
                    } label: {

                        GameButton(
                            title: "Tap Frenzy",
                            color1: .blue,
                            color2: .purple
                        )
                    }

                    NavigationLink {
                        LightItUpView()
                    } label: {

                        GameButton(
                            title: "Light It Up",
                            color1: .green,
                            color2: .cyan
                        )
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct GameButton: View {

    let title: String
    let color1: Color
    let color2: Color

    var body: some View {

        Text(title)
            .font(.title2)
            .bold()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [color1, color2],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}
