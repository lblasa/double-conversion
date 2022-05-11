Pod::Spec.new do |s|
    s.name         = "Flipper-DoubleConversion"
    s.version      = "3.2.1"
    s.summary      = 'Efficient binary-decimal and decimal-binary conversion routines for IEEE doubles'
    s.homepage     = "https://github.com/lblasa/double-conversion/"
    s.source       = { :git => 'https://github.com/lblasa/double-conversion.git', :tag => "flipper-double-conversion-v3.2.1" }
    s.license      = { :type => 'BSD', :file => 'LICENSE' }
    s.authors      = {'Lorenzo Blasa' => 'lorenzo.blasa@gmail.com'}
    s.cocoapods_version = '>= 1.9'
    s.ios.deployment_target = '9.0'
    s.osx.deployment_target = '10.10'
    s.vendored_frameworks = 'Frameworks/double-conversion.xcframework'
  end
