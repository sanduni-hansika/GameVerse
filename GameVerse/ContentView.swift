import SwiftUI
import Combine

struct ContentView: View {

    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var gameOver = false
    @AppStorage("tapFrenzyHighScore")
    private var highScore = 0

    @State private var buttonX: CGFloat = 200
    @State private var buttonY: CGFloat = 400

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    var buttonSize: CGFloat {
        let baseSize: CGFloat = 100
        let shrink = CGFloat(10 - timeRemaining) * 6
        return max(45, baseSize - shrink)
    }

    var body: some View {

        GeometryReader { geo in

            ZStack {

                
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.05, green: 0.05, blue: 0.12),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if !gameOver {

                    VStack {

                        
                        Text("TAP FRENZY")
                            .font(.system(size: 34, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        
                        HStack(spacing: 20) {

                            VStack {
                                Text("SCORE")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Text("\(score)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.cyan)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(20)

                            VStack {
                                Text("TIME")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Text("\(timeRemaining)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(20)
                        }
                        .padding()

                        Spacer()

                        
                        Button(action: {

                            score += 1

                            withAnimation(.easeInOut(duration: 0.25)) {
                                moveButton(screenSize: geo.size)
                            }

                        }) {

                            ZStack {

                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )

                                Circle()
                                    .stroke(Color.white.opacity(0.8), lineWidth: 4)

                                Text("TAP")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .frame(width: buttonSize, height: buttonSize)
                            .shadow(color: .blue.opacity(0.8),
                                    radius: 15)
                        }
                        .position(x: buttonX, y: buttonY)

                        Spacer()
                    }

                } else {

                    
                    VStack(spacing: 25) {

                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.purple)

                        Text("GAME OVER")
                            .font(.system(size: 34, weight: .heavy))
                            .foregroundColor(.white)

                        Text("Final Score")
                            .foregroundColor(.gray)

                        Text("\(score)")
                            .font(.system(size: 55, weight: .bold))
                            .foregroundColor(.cyan)

                        VStack(spacing: 10) {

                            Text("High Score")
                                .foregroundColor(.gray)

                            Text("\(highScore)")
                                .font(.title)
                                .bold()
                                .foregroundColor(.yellow)
                        }

                        Button(action: {
                            restartGame(screenSize: geo.size)
                        }) {

                            Text("PLAY AGAIN")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 220)
                                .background(
                                    LinearGradient(
                                        colors: [.green, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .onAppear {
                moveButton(screenSize: geo.size)
            }
            .onReceive(timer) { _ in

                if gameOver { return }

                if timeRemaining > 0 {

                    timeRemaining -= 1

                    
                    withAnimation(.spring()) {
                        moveButton(screenSize: geo.size)
                    }

                } else {

                    gameOver = true
                    updateHighScore()
                }
            }
        }
    }

    

    func moveButton(screenSize: CGSize) {

        let margin = buttonSize / 2 + 20

        buttonX = CGFloat.random(
            in: margin...(screenSize.width - margin)
        )

        buttonY = CGFloat.random(
            in: 180...(screenSize.height - 120)
        )
    }

    

    func restartGame(screenSize: CGSize) {

        updateHighScore()

        score = 0
        timeRemaining = 10
        gameOver = false

        moveButton(screenSize: screenSize)
    }

    

    func updateHighScore() {

        if score > highScore {
            highScore = score
        }
    }
}

#Preview {
    ContentView()
}
