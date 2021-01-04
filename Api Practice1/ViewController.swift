//
//  ViewController.swift
//  Api Practice1
//
//  Created by 황현지 on 2021/01/03.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //11
    var loans = [Loan]()

    //3 접속하려는 원래 주소 상수화
    let originalAddress = "https://api.kivaws.org/v1/loans/newest.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2
        getData()
        // Do any additional setup after loading the view.
    }
    
    //1번 함수 넣기. viewDidLoad후 실행되는 함수
    func getData() {
        //4
        let loanUrl = URL(string: originalAddress)
        
        //5 다시 형변환 시켜주기 - url 형태와 urlrequest형태(보통) 둘다 가능/ 데이터를 받아올때 urlrequest타입으로 받아오면 됨
        let request = URLRequest(url: loanUrl!)
        
        //6 네트워킹 completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>) 성공했을때 / 응답에대한 결과 / 실패했을때
        URLSession.shared.dataTask(with: request) { [self] (data, response, err) in
            print("res", response)
            if err != nil {
                return print("err", err?.localizedDescription) //에러가 나면 어떤 에러인지 서버에서 메세지를 줌, 그것에 대해 응답을 뿌려줌
            } else {
                //7-1
//                self.parseJsonData(origindata: data!)
//
                //10-1
                self.loans = self.parseJsonData(origindata: data!)
                
                //11. 테이블뷰에 데이터넣기
                //11-3. 테이블뷰 새로고침
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
                
                
            }
        }.resume()
    }
    //7번 전체 데이터 json데이터 파싱 / 입력값이 있을 때 알고리즘에 의해 결과값이 나온다. //12 [Loan]
    func parseJsonData(origindata: Data) -> [Loan] {
        //8 데이터를 담을 파일을 만들어준다. 파일 형식은 swift 
        //9 담을공간을 다시 한 번 선언해준다. 괄호가 많으면 인식이 안되므로 self 사용
        self.loans = [Loan]()
        
        //10 do가 1순위, 1순위 과정중 에러가 발생되면 catch로 감
        do { //json파싱 하는 법. jsonSerialization, decode, encode
           let jsonResult = try JSONSerialization.jsonObject(with: origindata, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            //loans만 추출
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            print(jsonLoans)
            
            //loans를 반복문으로 돌려 각각의 데이터만 저장
            for jsonLoan in jsonLoans {
                
                var loan = Loan()
                
                loan.name = jsonLoan["name"] as! String
                loan.use = jsonLoan["use"] as! String
                loan.amount = jsonLoan["loan_amount"] as! Int
                //키값은 String Value값은 Anyobject
                let location = jsonLoan["location"] as! [String: AnyObject]
                loan.location = location["country"] as! String
                
                //loans.append(<#T##newElement: Loan##Loan#>)
                loans.append(loan)
            }
            
        } catch{
            print(error)
        }
        return loans
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //11-1
        return loans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Cell1
        
        //11-2
        cell1.titleLabel.text = loans[indexPath.row].name
        cell1.locationLabel.text = loans[indexPath.row].location
        cell1.descriptionLabel.text = loans[indexPath.row].use
        cell1.priceLabel.text = "$\(loans[indexPath.row].amount)"
        
        return cell1
    }
    
    
}

