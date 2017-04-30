Pod::Spec.new do |s|
  s.name             = 'Spotlight'
  s.version          = '1.0.1'
  s.summary          = 'Vertical Feed (inspired by Instagram)'
  s.homepage         = 'https://github.com/efremidze/Spotlight'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'efremidze' => 'efremidzel@hotmail.com' }
  s.source           = { :git => 'https://github.com/efremidze/Spotlight.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/*.swift'
end
