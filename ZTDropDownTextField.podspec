Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "ZTDropDownTextField"
s.summary = "ZTDropDownTextField create a dropdown list for your textField."
s.requires_arc = true

# 2
s.version = "0.1.3"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Ziyang Tan" => "ziyang0621@gmail.com" }

# For example,
# s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/ziyang0621/ZTDropDownTextField"

# For example,
# s.homepage = "https://github.com/JRG-Developer/RWPickFlavor"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/ziyang0621/ZTDropDownTextField.git", :tag => "#{s.version}"}

# For example,
# s.source = { :git => "https://github.com/JRG-Developer/RWPickFlavor.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"
s.dependency 'pop', '~> 1.0'

# 8
s.source_files = 'ZTDropDownTextField/ZTDropDownTextField.swift', 'ZTDropDownTextField/ZTDropDownTextField-Bridging-Header.h'

end