require "sinatra/base"
require "mustermann"

module Notpm
  class Web < Sinatra::Base
    # npm's "Referer: install <package>" header triggers JsonCsrf
    set :protection, except: [:json_csrf]

    get "/:name" do |name|
      send_file "db/package/#{name}.json"
    end

    get "/@:scope/:name" do |scope, name|
      send_file "db/package/@#{scope}/#{name}.json"
    end

    get "/:name/-/:filename" do |name, filename|
      send_file "db/dist/#{name}/#{filename}"
    end

    get "/@:scope/:name/-/:filename" do |scope, name, filename|
      send_file "db/dist/@#{scope}/#{name}/#{filename}"
    end
  end
end
