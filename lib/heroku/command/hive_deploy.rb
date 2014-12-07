require_relative '../../../vendor/bundle/bundler/setup'
require 'okyakusan'
require 'tmpdir'
require 'json'
require 'uri'
require 'net/http'

class Heroku::Command::HiveDeploy < Heroku::Command::BaseWithApp
  def index
    git_uri = args.shift
    raise Heroku::Command::CommandFailed, "No git uri supplied.\nSpecify which git uri to package using as an argument" unless git_uri
    git_version = nil
    output_stream_url = nil

    Okyakusan.start do |client|
      get_url, put_url = create_source(client)

      Dir.mktmpdir do |dir|
        tar_file = "#{dir}/build.tgz"

        display "Preparing build.tgz from #{git_uri}"
        git_version = prepare_tar(dir, git_uri)
        display "Uploading source code to #{put_url}"
        upload_code(tar_file, put_url)
      end

      resp = client.post("/apps/#{app}/builds", version: "edge", data: {
        source_blob: {
          url: get_url,
          version: git_version
        }
      })
      output_stream_url = JSON.parse(resp.body)["output_stream_url"]
    end

    stream_content(output_stream_url)
  end

  private
  def prepare_tar(tmpdir, uri)
    git_version = nil

    Dir.chdir(tmpdir) do
      dir = "build"

      `git clone #{uri} #{dir}`

      Dir.chdir(dir) do
        git_version = `git rev-parse HEAD`.chomp
        `bundle install`
        `tar czfv ../build.tgz *`
      end

      `cp build.tgz /tmp`
    end

    git_version
  end

  def create_source(client)
    resp = client.post("/apps/#{app}/sources")
    resp_hash = JSON.parse(resp.body)["source_blob"]

    [resp_hash["get_url"], resp_hash["put_url"]]
  end

  def upload_code(tar_file, put_url)
    `curl "#{put_url}" -X PUT -H 'Content-Type:' --data-binary @#{tar_file}`
  end

  def stream_content(url, io = $stdout)
    uri = URI(url)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri

      http.request request do |response|
        response.read_body do |chunk|
          io.write chunk
        end
      end
    end
  end
end
