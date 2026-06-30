import SwiftUI
import Combine

struct LightItUpView: View {

    @State private var cards: [GameCard] =
        Array(repeating: GameCard(), count: 3)

    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var gameOver = false

    @State private var litIndices: [Int] = []

    @AppStorage("lightItUpHighScore")
    private var highScore = 0

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var level: Int {

        switch timeRemaining {

        case 46...60:
            return 1

        case 31...45:
            return 2

        case 16...30:
            return 3

        default:
            return 4
        }
    }

    var cardCount: Int {

        switch level {

        case 1:
            return 3

        case 2:
            return 4

        case 3:
            return 6

        default:
            return 9
        }
    }

    var columns: [GridItem] {

        let count: Int

        switch level {

        case 1:
            count = 3

        case 2:
            count = 4

        case 3:
            count = 3

        default:
            count = 3
        }

        return Array(
            repeating: GridItem(.flexible()),
            count: count
        )
    }

    var body: some View {

        ZStack {

            backgroundColor

            if !gameOver {

                VStack {

                    Text("Light It Up")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    HStack {

                        Text("Score: \(score)")
                            .foregroundColor(.white)

                        Spacer()

                        Text("Time: \(timeRemaining)")
                            .foregroundColor(.white)
                    }
                    .padding()

                    Text("Level \(level)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(levelColor)

                    LazyVGrid(columns: columns, spacing: 15) {

                        ForEach(cards.indices, id: \.self) { index in

                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .fill(
                                cards[index].isLit
                                ? levelColor
                                : Color.white.opacity(0.15)
                            )
                            .frame(height: 90)
                            .scaleEffect(
                                cards[index].isLit ? 1.1 : 1
                            )
                            .shadow(
                                color: cards[index].isLit
                                ? levelColor
                                : .clear,
                                radius: 10
                            )
                            .onTapGesture {

                                if cards[index].isLit {

                                    score += 1
                                    cards[index].isLit = false

                                } else {

                                    score = max(0, score - 1)
                                }
                            }
                        }
                    }
                    .padding()

                    Spacer()
                }

            } else {

                VStack(spacing: 20) {

                    Text("Game Over")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Score: \(score)")
                        .foregroundColor(.white)

                    Text("High Score: \(highScore)")
                        .foregroundColor(.yellow)

                    Button("Play Again") {

                        restartGame()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
        .onAppear {

            updateLevel()
            lightRandomCards()
        }
        .onReceive(timer) { _ in

            guard !gameOver else { return }

            if timeRemaining > 0 {

                timeRemaining -= 1

                updateLevel()
                lightRandomCards()

            } else {

                gameOver = true

                if score > highScore {
                    highScore = score
                }
            }
        }
    }

    var backgroundColor: some View {

        LinearGradient(
            colors: [
                .black,
                levelColor.opacity(0.4),
                .black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var levelColor: Color {

        switch level {

        case 1:
            return .green

        case 2:
            return .blue

        case 3:
            return .orange

        default:
            return .red
        }
    }

    func updateLevel() {

        cards = Array(
            repeating: GameCard(),
            count: cardCount
        )
    }

    func lightRandomCards() {

        for i in cards.indices {
            cards[i].isLit = false
        }

        let lights = level == 4 ? 2 : 1

        for _ in 0..<lights {

            let random = Int.random(
                in: 0..<cards.count
            )

            cards[random].isLit = true
        }
    }

    func restartGame() {

        score = 0
        timeRemaining = 60
        gameOver = false

        updateLevel()
        lightRandomCards()
    }
}
