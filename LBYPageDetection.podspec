Pod::Spec.new do |s|
  s.name            = 'LBYPageDetection'  
  s.version         = '1.0.0'
  s.summary         = 'LBYPageDetection'
  s.homepage        = 'https://github.com/709213219/LBYPageDetection'
  s.license         = 'MIT'
  s.author          = { 'billlin' => 'bill1in@163.com' }
  s.source          = { :git => 'https://github.com/709213219/LBYPageDetection.git', :tag => '1.0.0' }
  s.source_files    = 'LBYPageDetection/LBYPageDetection'
  s.requires_arc    = true
  s.platform        = :ios
  s.ios.deployment_target = '8.0'
end