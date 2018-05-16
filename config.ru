require "bundler/setup"
require "sinatra/base"

class Notpm < Sinatra::Base
  # npm's "Referer: install <package>" header triggers JsonCsrf
  set :protection, except: [:json_csrf]

  get "/:id" do |id|
    path = File.join("db", "package", "#{id}.json")
    if File.exist? path
      send_file path
    else
      not_found
    end
  end

  get "/:id/-/:filename" do |id, filename|
    path = File.join("db", "dist", id, filename)
    if File.exist? path
      send_file path
    else
      not_found
    end
  end
end

run Notpm
