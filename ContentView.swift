import SwiftUI

// MARK: - ContentView with Tabs
struct ContentView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false // Dark mode state

    var body: some View {
        TabView {
            ProfileView(mainViewModel: mainViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }

            //SoundsView()
            ObstacleCarView()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller.fill")
                }

            SettingsView(mainViewModel: mainViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // Apply dark mode globally
    }
}

// MARK: - Profile View (unchanged)
struct ProfileView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var isLoading = false
    @State private var currentPage = 0

    let images = ["ast", "BMW", "bug", "c7", "Challenger", "Charger", "Lambo", "mustang", "mk4", "por", "rolls", "Track", "Truck", "MC"]

    let carFacts: [String: String] = [
        "ast": "The Aston Martin is known for its luxury and association with James Bond films.",
        "BMW": "BMW stands for Bayerische Motoren Werke and is known for its performance and innovation.",
        "bug": "The Bugatti Veyron was once the fastest production car in the world.",
        "c7": "The Corvette C7 was the first to feature a fully aluminum frame as standard.",
        "Challenger": "The Dodge Challenger is a modern muscle car inspired by the 1970s classic.",
        "Charger": "The Dodge Charger offers a blend of muscle car performance with four-door practicality.",
        "Lambo": "Lamborghinis are famous for their exotic looks and V12 engines.",
        "mustang": "The Ford Mustang is an iconic American muscle car, launched in 1964.",
        "mk4": "The Toyota Supra MK4 gained fame from the Fast & Furious franchise.",
        "por": "Porsche 911 has one of the most iconic and enduring designs in car history.",
        "rolls": "Rolls-Royce cars are known for unmatched luxury and hand-crafted interiors.",
        "Track": "Track-focused cars are designed for maximum performance on race circuits.",
        "Truck": "Pickup trucks are among the best-selling vehicles in the U.S. due to their utility.",
        "MC": "The Mercedes-AMG cars combine luxury with high-performance engineering."
    ]

    let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()

            VStack(spacing: 1) {
                // Logo
                Image("E") // Replace with your logo asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .clipShape(Circle())

                Image("hglogotrans")
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { size, _ in
                        size * 0.6
                    }
                    .clipShape(Capsule())
                    .padding()

                Text("Carsamedia")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)

                // Car Fact
                Text(carFacts[images[currentPage], default: "Amazing car on display!"])
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                // Image slideshow
                TabView(selection: $currentPage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 220)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentPage = (currentPage + 1) % images.count
                    }
                }

                if isLoading {
                    ProgressView()
                        .padding(.vertical, 30)
                }

                Button {
                    mainViewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

//// MARK: - Sounds placeholder
//struct SoundsView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "speaker.wave.3.fill")
//                .font(.system(size: 80))
//                .padding()
//            Text("Sounds")
//                .font(.largeTitle)
//                .bold()
//        }
//    }
//}

// MARK: - Settings View with working dark mode toggle
struct SettingsView: View {
    @ObservedObject var mainViewModel: MainViewModel

    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var pushNotifications = true
    @State private var emailNotifications = false

    var body: some View {
        NavigationView {
            Form {
                // Account Section
                Section(header: Text("Account")) {
                    NavigationLink(destination: EditProfileView()) {
                        Label("Edit Profile", systemImage: "person.crop.circle")
                    }
                    NavigationLink(destination: ChangePasswordView()) {
                        Label("Change Password", systemImage: "lock.rotation")
                    }
                    Button(role: .destructive) {
                        mainViewModel.signOut()
                    } label: {
                        Label("Sign Out", systemImage: "arrow.right.square")
                    }
                }

                // Notifications Section
                Section(header: Text("Notifications")) {
                    Toggle("Push Notifications", isOn: $pushNotifications)
                    Toggle("Email Notifications", isOn: $emailNotifications)
                }

                // Appearance Section
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

                // About Section
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutAppView()) {
                        Label("About This App", systemImage: "info.circle")
                    }
                    NavigationLink(destination: TermsAndPrivacyView()) {
                        Label("Terms & Privacy", systemImage: "doc.text")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Placeholder Views for Settings Navigation
struct EditProfileView: View {
    var body: some View {
        Text("Edit Profile Screen")
            .font(.title)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChangePasswordView: View {
    var body: some View {
        Text("Change Password Screen")
            .font(.title)
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutAppView: View {
    var body: some View {
        Text("This app shows amazing cars and facts.")
            .padding()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsAndPrivacyView: View {
    var body: some View {
        Text("Terms and Privacy details go here.")
            .padding()
            .navigationTitle("Terms & Privacy")
            .navigationBarTitleDisplayMode(.inline)
    }
}


//codeforobstaclecar
struct ObstacleCar: Identifiable {
    let id = UUID()
    var lane: Int
    var positionY: CGFloat
}

struct ObstacleCarView: View {
    let lanes = 3
    let laneWidth = UIScreen.main.bounds.width / 3
    
    @State private var carLane = 1 // start center lane (0,1,2)
    @State private var obstacles: [ObstacleCar] = []
    @State private var isGameOver = false
    @State private var score = 0
    @State private var timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    // Sizes
    let carWidth: CGFloat = 60
    let carHeight: CGFloat = 100
    
    var body: some View {
        ZStack {
            // Road background
            LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.black]),
                startPoint: .top,
                endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Lane lines
            ForEach(1..<lanes) { laneIndex in
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 4, height: UIScreen.main.bounds.height)
                    .position(x: CGFloat(laneIndex) * laneWidth, y: UIScreen.main.bounds.height / 2)
            }
            
            VStack {
                // Score
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                SoundView()
                Spacer()
                
                ZStack {
                    // Player car
                    Image("sportscar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: carWidth, height: carHeight)
                        .position(x: laneCenterX(for: carLane), y: UIScreen.main.bounds.height - carHeight - 250)

                    
                    // Obstacles
                    ForEach(obstacles) { obstacle in
                        Image("enemycar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: carWidth, height: carHeight)
                            .position(x: laneCenterX(for: obstacle.lane), y: obstacle.positionY)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button("◀️") {
                        if carLane > 0 {
                            carLane -= 1
                        }
                    }
                    .font(.largeTitle)
                    .padding()
                    
                    Button("▶️") {
                        if carLane < lanes - 1 {
                            carLane += 1
                        }
                    }
                    .font(.largeTitle)
                    .padding()
                }
            }
            
            if isGameOver {
                VStack {
                    Text("💥 Game Over!")
                        .font(.largeTitle)
                        .padding()
                    
                    Button("Restart") {
                        restartGame()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding()
            }
        }
        .onAppear(perform: setupObstacles)
        .onReceive(timer) { _ in
            guard !isGameOver else { return }
            moveObstacles()
        }
    }
    
    func laneCenterX(for lane: Int) -> CGFloat {
        // Center x position of a lane
        return laneWidth * CGFloat(lane) + laneWidth / 2
    }
    
    func setupObstacles() {
        obstacles = []
        for _ in 0..<3 { // start with 3 cars in different lanes randomly
            let lane = Int.random(in: 0..<lanes)
            let posY = CGFloat.random(in: -600 ... -100)
            obstacles.append(ObstacleCar(lane: lane, positionY: posY))
        }
    }
    
    func moveObstacles() {
        let baseSpeed: CGFloat = 6
        let speed = baseSpeed + CGFloat(score) * 0.3 // speed increases with score
        
        // Player car's actual y position accounting for offset
        let playerY = UIScreen.main.bounds.height - carHeight - 100
        
        for i in obstacles.indices {
            obstacles[i].positionY += speed
            
            // Precise collision detection
            if obstacles[i].lane == carLane {
                let playerTop = playerY - carHeight / 2
                let playerBottom = playerY + carHeight / 2
                let obstacleTop = obstacles[i].positionY - carHeight / 2
                let obstacleBottom = obstacles[i].positionY + carHeight / 2
                
                let verticalOverlap = !(playerBottom < obstacleTop || playerTop > obstacleBottom)
                
                if verticalOverlap {
                    isGameOver = true
                    timer.upstream.connect().cancel()
                }
            }
            
            // Reset obstacle if it passed bottom
            if obstacles[i].positionY > UIScreen.main.bounds.height + carHeight {
                obstacles[i].positionY = CGFloat.random(in: -600 ... -100)
                obstacles[i].lane = Int.random(in: 0..<lanes)
                score += 1
            }
        }
    }
    
    func restartGame() {
        carLane = 1
        score = 0
        isGameOver = false
        setupObstacles()
        timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    }
}
//Sounds

import SwiftUI
import AVKit

class SoundManager: ObservableObject {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func togglePlay() {
        if let player = player, player.isPlaying {
            player.stop()
            self.player = nil
        } else {
            guard let url = Bundle.main.url(forResource: "carsounds", withExtension: "mp3") else {
                print("Sound file not found")
                return
            }
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
}

struct SoundView: View {
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            Button(action: {
                SoundManager.instance.togglePlay()
                isPlaying = SoundManager.instance.isPlaying
            }) {
                Text(isPlaying ? "Stop Sound" : "Play Sound")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
            .padding()
        }
    }
}

// For preview/testing
struct SoundView_Previews: PreviewProvider {
    static var previews: some View {
        SoundView()
    }
}

// MARK: - Preview
#Preview {
    ContentView(mainViewModel: MainViewModel())
}

