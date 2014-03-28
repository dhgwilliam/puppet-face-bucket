require 'puppet'
require 'puppet/face'

Puppet::Face.define(:bucket, '0.2.0') do
  summary "Interact with the filebucket"
  copyright "David Gwilliam", 2014
  license "Apache 2"

  action :list do
    summary "List all the files in the filebucket"

    option '--date' do
      summary "Sort by date instead of filename"
      default_to { false }
    end

    option '--reverse' do
      summary "Reverse sort order"
      default_to { false }
    end

    when_invoked do |options|
      list = Bucket.scan_file.map {|p| BucketFile.new(:path => p)}

      display_list = if options[:date] and options[:reverse]
        list.sort {|f, g| g.date <=> f.date}
      elsif options[:date] and !options[:reverse]
        list.sort_by {|f| f.date}
      elsif !options[:date] and options[:reverse]
        list.sort {|f, g| g.path <=> f.path}
      else
        list.sort_by {|f| f.path}
      end

      display_list.each do |file|
        puts file.display_list
      end
      nil
    end
  end

  action :view do
    summary "Display the contents of a file (by md5)"
    arguments "<md5>"

    when_invoked do |md5, options|
      exec("less #{BucketFile.new(:md5 => md5).absolute_path}/contents") if md5
    end

  end

  action :copy do
    summary "Copy the contents of a BucketFile to another location"
    arguments "<md5> <dest>"

    when_invoked do |md5, dest, options|
      exec("cp #{BucketFile.new(:md5 => md5).absolute_path}/contents #{dest}")
    end
  end

  action :grep do
    summary "Search the files in the filebucket"
    arguments "<search terms>"

    when_invoked do |*terms|
      break if terms[0..-2].empty?
      terms = Regexp.new(terms[0..-2].join(" "))
      Bucket.scan_file.map {|f|
        file = BucketFile.new(:path => f)
        if file.match_path?(:match => terms)
          file.display_path_match(:match => terms)
        elsif file.match_contents(:match => terms)
          "#{file.display_list}:\n\t#{file.match_contents(:match => terms)}"
        end
      }.select {|f| f}
    end
  end
end


class BucketFile
  def initialize(args)
    if args[:md5]
      @md5      = args[:md5]
      @abs_path = absolute_path
    elsif args[:path]
      @abs_path = args[:path]
      @md5      = md5
    end
    @date     = date
    @path     = path
  end

  def md5
    @md5 || absolute_path.slice(/[a-f0-9]{32}/)
  end

  #TODO this is extremely slow
  def absolute_path
    @abs_path || Bucket.scan_file.select {|f| f.match(/#{md5}/)}.first
  end

  def contents_path
    "#{absolute_path}/contents"
  end

  def contents
    File.read(contents_path)
  end

  def match_contents(args)
    matches = contents.scan(/^.*#{args[:match]}.*$/)
    matches.join("\n\t").chomp unless matches.empty?
  end

  def md5_dir
    m = md5
    "#{m[0]}/#{m[1]}/#{m[2]}/#{m[3]}/#{m[4]}/#{m[5]}/#{m[6]}/#{m[7]}"
  end

  def basename
    @basename || path.map{|p|File.basename(p)}.uniq
  end

  def path
    @path || File.read("#{absolute_path}/paths").split("\n").map{|path|path.chomp}
  end

  def match_path?(args)
    path_match(args).inject(false) {|truth, match| match ? true : truth }
  end

  def path_match(args)
    path.map {|p| p.match(/^.*#{args[:match]}.*$/)}.select {|m| m}
  end

  def date
    @date || File.mtime(absolute_path + "/contents")
  end

  def human_date
    date.strftime('%F %H:%M')
  end

  def display_list
    if path.empty?
      "#{md5}\t#{human_date}\tNo path"
    else
      path.map { |p| "#{md5}\t#{human_date}\t#{p}" }.join("\n")
    end
  end

  def display_short
    "#{md5}\t#{human_date}\t#{basename.join(", ")}"
  end

  def display_path_match(args)
    path_match(args).map{ |match|
      "#{md5}\t#{human_date}\t#{match}"}.join("\n")
  end

  def self.bucket
    Bucket.path
  end
end

class Bucket
  def self.path
    [ Puppet[:bucketdir], Puppet[:clientbucketdir] ]
  end

  def self.scan_md5
    Bucket.path.map {|path|
      Dir.glob("#{path}/**/*").select {|p| File.file?(p) }.
        map {|f| f.slice(/[a-f0-9]{32}/)}.uniq
    }.flatten
  end

  def self.scan_file
    Bucket.path.map {|path|
      Dir.glob("#{path}/**/*/").select {|p| File.directory?(p) and p.match(/[a-f0-9]{32}/) }
    }.flatten.map{|p| p.chop if p.end_with?('/')}
  end
end
