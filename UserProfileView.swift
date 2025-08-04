import Foundation
import SwiftUI
import UIKit

//Profile Manager
class ProfileImageManager {
    static let shared = ProfileImageManager()
    private init() {}

    private let filename = "profile.jpg"

    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }

    func save(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }

    func load() -> UIImage? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

}


//Image picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

//UserProfileView
struct UserProfileView: View {
    
    @ObservedObject var mainViewModel: MainViewModel
    
    //variables
       @State private var profileImage: UIImage? = nil
       @State private var showingImagePicker = false
       @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // Large Welcome Text at the top
                Text("Welcome \(mainViewModel.username)")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 0)
                    .multilineTextAlignment(.center)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Capsule())
                
                // Larger Profile Icon under the Welcome
//                Image(systemName: "person.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//                    .foregroundColor(.black)
//                    .padding(.bottom, -1)
//                    .background(Color.white.opacity(0.7))
//                    .clipShape(Circle())
                
//                // User details
//                Text(mainViewModel.authUserData?.uid ?? "@null")
//                    .padding(.top, 10)
//                    .font(.system(size: 25,))
//                    .foregroundStyle(.white.opacity(0.7))

                
        // Subtext
                Text("Logged in with \(mainViewModel.databaseUser?.username ?? "@null")")
                    .padding(.top, 0)
                    .font(.system(size: 20,))
                    .foregroundStyle(.white.opacity(0.7))

                //before picking image
                                   if let image = profileImage {
                                       Image(uiImage: image)
                                           .resizable()
                                           .scaledToFill()
                                           .frame(width: 150, height: 150)
                                           .clipShape(Circle())
                                           .shadow(radius: 4)
                                   } else {
                                       Circle()
                                           .fill(Color.gray.opacity(0.3))
                                           .frame(width: 150, height: 150)
                                           .overlay(
                                               Image(systemName: "person.fill")
                                                   .font(.system(size: 100))
                                           )
                                   }

                                   Button("Change Picture") {
                                       showingImagePicker = true
                                   }
                                   .padding()
                                   .foregroundColor(.white)
                                   .background(Color.black)
                                   .cornerRadius(10)
                                   .padding(.top, 20)
                                   .padding(.bottom, 20)
                // Get Started button with arrow
                NavigationLink {
                    ContentView(mainViewModel: mainViewModel)
                } label: {
                    HStack {
                        Text("Get Started")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .clipShape(Capsule())
                    
                }
                .padding(.top, 30)

                Spacer()
            } //End of VStack
            
            .padding()
            .sheet(isPresented: $showingImagePicker, onDismiss: {
                               if let selected = selectedImage {
                                   ProfileImageManager.shared.save(image: selected)
                                   profileImage = selected
                               }
                           }) {
                               ImagePicker(image: $selectedImage)

                           }
        }
        .onAppear {
            mainViewModel.fetchCurrentUserEmail()
            mainViewModel.fetchUserData()
        }
    }
}

#Preview {
    UserProfileView(mainViewModel: MainViewModel())
}

