#
# Be sure to run `pod lib lint Nimbbl_SDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Nimbbl_SDK'
  s.version          = '1.0.0'
  s.summary          = 'This is the updated version of nimbbl sdk.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "This version is compatiblw with XCode 14.2, iOS 11.0 and Swift 5"

  s.homepage         = 'https://github.com/BushraLogicLoop/Nimbbl_SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BushraLogicLoop' => 'bushra@logicloop.io' }
  s.source           = { :git => 'https://github.com/BushraLogicLoop/Nimbbl_SDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'Nimbbl_SDK/Classes/**/*'
  
   s.resource_bundles = {
     'Nimbbl_SDK' => ['Nimbbl_SDK/Assets/*.png','Nimbbl_SDK/Assets/*.jpeg']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Analytics'
  s.dependency 'MBProgressHUD'
  s.dependency 'DropDown'
end
