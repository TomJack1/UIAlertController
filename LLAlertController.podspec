

Pod::Spec.new do |s|
  version        = "0.0.2"
  s.name         = "LLAlertController"
  s.version      = version
  s.summary      = "仿微信 sheetView of LEAlertController."
  s.homepage     = "https://github.com/TomJack1/UIAlertController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "lilei" => "445765368@qq.com" }
  s.authors            = { "lilei" => "445765368@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/TomJack1/UIAlertController.git", :tag => version }
  s.source_files     = 'class/LEAlertController.swift'
  s.requires_arc = true
 end
