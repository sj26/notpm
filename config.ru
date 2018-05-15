require "bundler/setup"
require "sinatra/base"

class Notpm < Sinatra::Base
  # npm's "Referer: install <package>" header triggers JsonCsrf
  set :protection, except: [:json_csrf]

  get "/" do
    send_file "public/index.html"
  end

  get "/:id" do |id|
    path = File.join("db", "#{id}.json")
    if File.exist? path
      send_file path
    else
      not_found
    end
  end

  get "/:id/-/:filename" do |id, filename|
    path = File.join("db", id, filename)
    if File.exist? path
      send_file path
    else
      not_found
    end
  end
end

run Notpm
