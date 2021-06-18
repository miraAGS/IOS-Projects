import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageBox: UIImageView!

    struct JSONTest: Codable {
        let date: String
        let time: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataURL = URL(string: "http://date.jsontest.com")!
        let imageURL = URL(string: "https://www.gravatar.com/avatar/72ee941866428104d637775dad09f5e0")!
        //let dataURL = URL(string: "http://worldclockapi.com/api/json/utc/now")!
        //let ipURL = URL(string: "http://ip.jsontest.com")!
        //let md5URL = URL(string: "http://md5.jsontest.com/?text=example_text")!

        loadJSON(inURL: dataURL)
        loadImage(inURL: imageURL)
        
    }

    func loadJSON(inURL: URL) {
//      var request = URLRequest(url: URL(string: "http://127.0.0.1:5000/entry")!)
//      request.httpMethod = "GET"
//      URLSession.shared.dataTask(with: request...

        URLSession.shared.dataTask(with: inURL) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                //Decode data
                let JSONData = try JSONDecoder().decode(JSONTest.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.dateLabel.text = JSONData.date
                    self.timeLabel.text = JSONData.time
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }

    func loadImage(inURL: URL) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: inURL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imageBox.image = UIImage(data: data!)
            }
        }
        
//        Alamofire.request(.GET, "http://127.0.0.1:5000/entry", parameters: ["user": "email"])
//            .response { request, response, data, error in
//                print(request)
//                print(response)
//                print(error)
//        }
    }
}

