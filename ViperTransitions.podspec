#
# Be sure to run `pod lib lint ViperTransitions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ViperTransitions"
  s.version          = "0.0.1"
  s.summary          = "ViperTransitions a set of classes designed to work with viper transitions."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = "ViperTransitions include classes to work with transitions in viper module."

  s.homepage         = "https://github.com/Tayphoon/ViperTransitions"
  s.license          = 'MIT'
  s.author           = { "Tayphoon" => "tayphoon.company@gmail.com" }
  s.source           = { :git => "https://github.com/Tayphoon/ViperTransitions.git", :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.requires_arc = true

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'ViperTransitions/**/*.{h,swift}'

    core.frameworks = 'UIKit'
  end

end
