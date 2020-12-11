//
//  ViewController.swift
//  Covid19Canada
//
//  Created by Lin Cui on 2020-11-20.
//

import UIKit
import SpriteKit

class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate
{
    
    @IBOutlet weak var chartView: SKView!
    
    @IBOutlet weak var labelProvince: UILabel!
    
    @IBOutlet weak var segmentProvince: UISegmentedControl!
    //picker part
    @IBOutlet weak var pickerDate: UIPickerView!
    
    @IBOutlet weak var lbDaily: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dates.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dates[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(dates.count)
        self.selectedDate = dates[row]
        self.getDailyAndTotal(prov: self.selectedProvince, date: self.selectedDate)
        print("position is \(findPositionForDate(date: selectedDate))")
        
        if let scene = chartView.scene as? ChartScene {
            scene.updateChart(self.values,position:findPositionForDate(date: selectedDate),date:self.selectedDate)
        }
    }
    
    
    
    
    
    var dates : [String] = []
    var values : [Int] = [] //daily value
    var jsData : [[String:Any?]] = []
    var selectedProvince = ""//
    var selectedDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedProvince = "Canada"
        
        if let scene = SKScene(fileNamed: "ChartScene"){
            scene.scaleMode = .aspectFit
            self.chartView.presentScene(scene)
        }
        
        
        
        pickerDate.delegate = self
        pickerDate.dataSource = self
        // Do any additional setup after loading the view.
        
        let urlString = "http://ejd.songho.ca/ios/covid19.json"
        guard let url = URL(string: urlString) else {
            print("[ERROR] Cannot create a URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler:
                                                { (data, response, error) in
                                                    // error checking first
                                                    if let error = error {
                                                        print("[ERROR] " + error.localizedDescription)
                                                        return
                                                    }
                                                    guard let data = data else { // verify data second
                                                        print("[ERROR] Data is nil")
                                                        return
                                                    }
                                                    // parse json as an array of students using JSONSerialization
                                                    self.parseJson(data)
                                                    
                                                    // MUST reload tableView in main thread
                                                    DispatchQueue.main.async
                                                    {
                                                        self.getDates()
                                                        self.pickerDate.reloadAllComponents()
                                                        self.pickerDate.selectRow((self.dates.count-1), inComponent: 0, animated: true)
                                                        self.setValues()
                                                        
                                                        self.selectedDate = self.dates.last!
                                                        self.getDailyAndTotal(prov: "Canada", date: self.selectedDate)
                                                        
                                                        if let scene = self.chartView.scene as? ChartScene {
                                                            scene.updateChart(self.values,position: (self.dates.count-1),date: self.dates.last!)
                                                        }
                                                    }
                                                })
        // MUST call resume() after creating URLSessionDataTask
        task.resume()
    }
    
    @IBAction func changeProvince(_ sender: UISegmentedControl) {
        //call updateChart()

        if segmentProvince.selectedSegmentIndex == 0 {
            selectedProvince = "Canada"
            labelProvince.text = "COVID19:\(selectedProvince)"
            self.setValues()
            self.getDailyAndTotal(prov: self.selectedProvince, date: self.selectedDate)
            if let scene = chartView.scene as? ChartScene {
                scene.updateChart(self.values,position: findPositionForDate(date: selectedDate),date: self.selectedDate)
            }
        }else if segmentProvince.selectedSegmentIndex == 1 {
            selectedProvince = "Ontario"
            labelProvince.text = "COVID19:\(selectedProvince)"
            self.setValues()
            self.getDailyAndTotal(prov: self.selectedProvince, date: self.selectedDate)
            if let scene = chartView.scene as? ChartScene {
                scene.updateChart(self.values,position: findPositionForDate(date: selectedDate),date: self.selectedDate)
            }
        }
        else if segmentProvince.selectedSegmentIndex == 2{
            selectedProvince = "Quebec"
            labelProvince.text = "COVID19:\(selectedProvince)"
            self.setValues()
            self.getDailyAndTotal(prov: self.selectedProvince, date: self.selectedDate)
            if let scene = chartView.scene as? ChartScene {
                scene.updateChart(self.values,position: findPositionForDate(date: selectedDate),date: self.selectedDate)
            }
        }
        else{
            selectedProvince = "British Columbia"
            labelProvince.text = "COVID19:\(selectedProvince)"
            self.setValues()
            self.getDailyAndTotal(prov: self.selectedProvince, date: self.selectedDate)
            if let scene = chartView.scene as? ChartScene {
                scene.updateChart(self.values,position: findPositionForDate(date: selectedDate),date: self.selectedDate)
            }
        }
        
        
    }
    
    func parseJson(_ data: Data)
    {
        // parse json as an array [Any] using JSONSerialization
        do
     {
        let json = try JSONSerialization.jsonObject(with:data,
                                                    options:[]) as? [Any] ?? []
        
        
        if let myJson = json as? [[String:Any?]]{
            jsData = myJson
        }else{
            print("wrong format")
            self.showAlert(message: "wrong format")
        }
     }
        catch
        {
            print("[ERROR] " + error.localizedDescription)
            return
        }
    }
    
    func getDates(){
        var dateSet: Set<String> = [] // create a temp set
        for dict in self.jsData // json is array of dictionaries
        {
            // find date key in the dictionary
            if let date = dict["date"] as? String {
                dateSet.insert(date) // if date is already in the set, it ignores
            }
        }
        self.dates = dateSet.sorted()
    }
    
    func showAlert(title:String = "Error", message:String)
    {
        DispatchQueue.main.async {
            // create alert controller
            let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
            
            // add default button
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
            // show it
            self.present(alert, animated:true, completion:nil)
        }
    }
    
    func setValues(){
        // conversion: String to Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let SecPerDay: Double = 60 * 60 * 24
        let firstDate = formatter.date(from: dates[0]) ?? Date()
        let lastDate = formatter.date(from: dates.last!) ?? Date()
        let sec = lastDate.timeIntervalSince(firstDate)
        let dayCount = Int(sec / SecPerDay + 0.5) + 1
        self.values = [Int](repeating: 0, count: dayCount) // allocate array with size
        
        for i in 0 ..< values.count
        {
            let date = firstDate.addingTimeInterval(Double(i) * SecPerDay)
            let dateStr = formatter.string(from: date)
            // find matching province and date from JSON
            if let index = jsData.firstIndex(where: { $0["prname"] as? String == selectedProvince && $0["date"] as? String == dateStr })
            {
                values[i] = jsData[index]["numtoday"] as? Int ?? 0
            }
            else {
                // not found, set it to 0
                values[i] = 0
            }
        }
        
                if let scene = chartView.scene as? ChartScene {
                    scene.getValues(values: self.values)
                }
    }
    
    func getDailyAndTotal(prov:String,date:String){
        
        if let i = jsData.firstIndex(where: { $0["prname"] as? String == prov && $0["date"] as? String == date }) {
            lbDaily.text = String(jsData[i]["numtoday"] as? Int ?? 0)
            lbTotal.text = String(jsData[i]["numtotal"] as? Int ?? 0) }
        else {
            lbDaily.text = "N/A"
            lbTotal.text = "N/A"
        }
    }
    func findPositionForDate(date:String)->Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let SecPerDay: Double = 60 * 60 * 24
        let firstDate = formatter.date(from: dates[0]) ?? Date()
        let choosedDate = formatter.date(from: date) ?? Date()
        let sec = choosedDate.timeIntervalSince(firstDate)
        let dayCount = Int(sec / SecPerDay + 0.5) + 1
        
        return dayCount-1
    }
}

