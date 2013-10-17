# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'launchy'
require 'optparse'
require 'milkode/cdweb/lib/database'

module Milkode
  class CLI_Cdweb
    def self.execute(stdout, argv)
      options = {
        :environment => ENV['RACK_ENV'] || "development",
        :pid         => nil,
        :Port        => 9292,
        :Host        => "0.0.0.0",
        :AccessLog   => [],
        :config      => "config.ru",
        # ----------------------------
        :server      => "thin",
        :LaunchBrowser => true,
        :DbDir => select_dbdir,
      }

      opts = OptionParser.new("#{File.basename($0)}")
      opts.on('--db DB_DIR', 'Database dir (default : current_dir)') {|v| options[:DbDir] = v }
      opts.on("-o", "--host HOST", "listen on HOST (default: 0.0.0.0)") {|host| options[:Host] = host }
      opts.on('-p', '--port PORT', 'use PORT (default: 9292)') {|v| options[:Port] = v }
      opts.on("-s", "--server SERVER", "serve using SERVER (default : thin)") {|s| options[:server] = s }
      opts.on('-n', '--no-browser', 'No launch browser.') {|v| options[:LaunchBrowser] = false }
      opts.on('--customize', 'Create customize file.') {|v| options[:customize] = true }

      # --hostが'-h'を上書きするので、'-h'を再定義してあげる
      opts.on_tail("-h", "-?", "--help", "Show this message") do
        puts opts
        exit
      end
      
      opts.parse!(argv)
      
      # 実行！！
      execute_with_options(options)
    end
    
    def self.execute_with_options(stdout, options)
      dbdir = File.expand_path(options[:DbDir])
      
      unless options[:customize]
        # 使用するデータベースの位置設定
        Database.setup(dbdir)

        # サーバースクリプトのある場所へ移動
        FileUtils.cd(File.dirname(__FILE__))

        # Rackサーバー生成
        rack_server = Rack::Server.new(options)

        # 起動URL生成
        launch_url = create_launch_url(options)

        # URL設定
        ENV['MILKODE_RELATIVE_URL'] = File.join('/', options[:url]) if options[:url]

        # 起動
        rack_server.start do
          # この時点でoptions[:Host]やoptions[:Port]などの値が壊れてしまっているため事前にURLを生成している
          Launchy.open(launch_url) if launch_url
        end
      else
        create_customize_file(dbdir)
      end
    end

    def self.create_launch_url(options)
      if (options[:LaunchBrowser])
        host = options[:Host] || options[:BindAddress] # options[:BindAddress] for WEBrick

        base = "http://#{host}:#{options[:Port]}"

        if options[:url]
          File.join(base, options[:url])
        else
          "http://#{host}:#{options[:Port]}"
        end
      else
        nil
      end
    end

    def self.select_dbdir
      # if (Dbdir.dbdir?('.') || !Dbdir.dbdir?(Dbdir.default_dir))
      if Dbdir.dbdir?('.')
        '.'
      else
        Dbdir.default_dir
      end
    end

    def self.create_customize_file(dbdir)
      fname = File.join(dbdir, "milkweb.yaml")
      
      if File.exist? fname
        puts "Already exist '#{fname}'"
      else
        puts <<EOF
Create '#{fname}'.
  Please customize yaml parameter.
EOF

        File.open(fname, "w") do |f|
          f.write <<EOF
---
:home_title  : "Milkode"
:home_icon   : "/images/MilkodeIcon135.png"

:header_title: "Milkode"
:header_icon : "/images/MilkodeIcon135.png"

:display_about_milkode: true
EOF
        end
      end
    end
  end
end
