Pod::Spec.new do |s|
#1.
s.name  = "SBNetworkAdapter"
#2.
s.version   = "1.0.0"
#3.
s.summary   = "A Network Adapter Framework which eases your API call paradigm"
#4.
s.license   = "MIT"
#5.
s.author    = "Soham Bhattacharjee"
#6.
s.platform  = :ios, "10.0"
#7.
s.source    = { :git => "https://github.com/sohamb1390/SBNetworkAdapter.git", :tag => "1.0.0" }
#8.
s.source_files  = "SBNetworkAdapter", "SBNetworkAdapter/**/*.{h,m,swift}"
end
