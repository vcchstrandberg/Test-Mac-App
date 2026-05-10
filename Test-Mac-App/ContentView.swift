import SwiftUI

struct ContentView: View {
    @State private var password = ""
    @State private var wordCount = 4
    @State private var copied = false

    var entropy: Int {
        Int(log2(Double(WordList.words.count)) * Double(wordCount) + log2(100))
    }

    var strength: (label: String, color: Color) {
        switch entropy {
        case ..<40: return ("Acceptabel", .orange)
        case 40..<50: return ("Bra", .yellow)
        case 50..<60: return ("Stark", .green)
        default: return ("Mycket stark", .mint)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Lösenordsgenerator")
                    .font(.largeTitle.bold())
                Text("Säkra lösenfraser byggda av svenska ord")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            GroupBox {
                HStack(alignment: .center, spacing: 12) {
                    Text(password.isEmpty ? "Tryck Generera" : password)
                        .font(.system(.title3, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(password.isEmpty ? .secondary : .primary)
                        .textSelection(.enabled)

                    if !password.isEmpty {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(strength.color)
                                .frame(width: 8, height: 8)
                            Text(strength.label)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 6)
            }

            if !password.isEmpty {
                Text("~\(entropy) bitars entropi")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text(" ").font(.caption)
            }

            HStack(spacing: 16) {
                Text("Ord:")
                    .font(.callout)
                Picker("", selection: $wordCount) {
                    ForEach(3...6, id: \.self) { n in
                        Text("\(n)").tag(n)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
                .onChange(of: wordCount) { _, _ in generate() }
            }

            HStack(spacing: 12) {
                Button(action: generate) {
                    Label("Generera", systemImage: "arrow.clockwise")
                        .frame(minWidth: 110)
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return)

                Button(action: copyPassword) {
                    Label(
                        copied ? "Kopierat!" : "Kopiera",
                        systemImage: copied ? "checkmark" : "doc.on.doc"
                    )
                    .frame(minWidth: 90)
                }
                .buttonStyle(.bordered)
                .disabled(password.isEmpty)
            }
        }
        .padding(28)
        .frame(width: 540)
        .onAppear(perform: generate)
    }

    func generate() {
        let words = (0..<wordCount).map { _ in
            WordList.words.randomElement()!.capitalized
        }
        let number = Int.random(in: 10...99)
        password = (words + ["\(number)"]).joined(separator: "-")
        copied = false
    }

    func copyPassword() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(password, forType: .string)
        copied = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            await MainActor.run { copied = false }
        }
    }
}

#Preview {
    ContentView()
}
