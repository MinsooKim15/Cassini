//
//  ImageViewController.swift
//  Cassini
//
//  Created by minsoo kim on 2018. 10. 6..
//  Copyright © 2018년 minsoo kim. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL?{
        didSet {
            image = nil
            // 내가 지금 스크린에 있나? 체크 하는 코드
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            //spinning 시작은 이미지를 fetch하는 순간이기 때문에 fetchImage() 함수에 있지만, 정확히 이미지가 나오는 순간 끝나야 해서, image의 set에 있음.
            spinner?.stopAnimating()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if imageView.image == nil{
            fetchImage()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            
            scrollView.delegate = self
            
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return imageView
    }
    
    var imageView = UIImageView()
    
    
    
    private func fetchImage(){
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos:.userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    // url == self?.imageURL에 대해 : 이미지 요청 시기와 이 후의 시기가 한참 지났으니 여전히 이 url을 필요로 하는지 확인 필요.
                    // weak self도 같은 이유, memory cycle이 없지만, 이후에는 더 이상 이 내용이 필요없을 수 있기 때문임.
                    if let imageData = urlContents, url == self?.imageURL{
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        if imageURL  == nil {
//            imageURL = DemoURLs.stanford
//        }
    }
}
