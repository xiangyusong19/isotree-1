require "mkmf-rice"

# TODO add -D_ENABLE_CEREAL
$CXXFLAGS += " -std=c++11 -D_USE_MERSENNE_TWISTER"

apple_clang = RbConfig::CONFIG["CC_VERSION_MESSAGE"] =~ /apple clang/i

# check omp first
if have_library("omp") || have_library("gomp")
  $CXXFLAGS += " -Xclang" if apple_clang
  $CXXFLAGS += " -fopenmp"
end

ext = File.expand_path(".", __dir__)
isotree = File.expand_path("../../vendor/isotree/src", __dir__)

exclude = %w(Rwrapper.cpp RcppExports.cpp)
$srcs = Dir["{#{ext},#{isotree}}/*.{cc,cpp}"].reject { |f| exclude.include?(File.basename(f)) }
$INCFLAGS << " -I#{isotree}"
$VPATH << isotree

create_makefile("isotree/ext")
