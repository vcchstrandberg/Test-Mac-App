import SwiftUI

@main
struct PasswordGeneratorApp: App {
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup("Lösenordsgenerator") {
            ContentView()
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .help) {
                Button("Lösenordsgenerator Hjälp") {
                    openWindow(id: "hjalp")
                }
            }
        }

        Window("Hjälp", id: "hjalp") {
            HelpView()
        }
        .windowResizability(.contentSize)
    }
}
