require "bundler/setup"
require "rack/sendfile"

$: << File.join(__dir__, "lib")
require "notpm"

use Rack::Sendfile
run Notpm::Web
