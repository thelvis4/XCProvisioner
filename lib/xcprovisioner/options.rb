module XCProvisioner
  # Raised when options passed by the user are wrong.
  class OptionError < StandardError
  end

  # The options Runner will operate with
  class Options
    attr_reader :project
    attr_reader :specifier
    attr_reader :target
    attr_reader :configuration

    # Initialize a new Options instance
    # Params:
    # - hash: a hash of options containing :project, :specifier
    # :target and :configuration are optional
    def initialize(hash)
      validate_options(hash)

      @project = File.expand_path(hash[:project].to_s)
      @specifier = hash[:specifier]
      @target = hash[:target]
      @configuration = hash[:configuration]
    end

    private

    def validate_options(options)
      if options.nil?
        raise ArgumentError, "#{self.class} should be initialized with options"
      end

      validate_project(options[:project])
      validate_specifier(options[:specifier])
      validate_target(options[:target])
      validate_configuration(options[:configuration])
    end

    # rubocop:disable Metrics/MethodLength
    def validate_project(project)
      raise OptionError, 'No .xcodeproj specified' if project.nil?

      file_extension = File.extname(project)
      unless file_extension == '.xcodeproj'
        error = 'Invalid project file type. Expected a .xcodeproj file'
        raise OptionError, error
      end

      path = File.expand_path(project.to_s)
      unless File.exist?(path) # rubocop:disable GuardClause
        error = "Specified project file (#{project}) doesn't exist"
        raise OptionError, error
      end
    end

    def validate_specifier(specifier)
      raise OptionError, 'No provisioning profile specifier' if specifier.nil?
    end

    def validate_target(target)
      return if target.nil? # nil is fine because target option is optional

      raise OptionError, 'Invalid target name' if target.empty?
    end

    def validate_configuration(configuration)
      # nil is fine because configuration option is optional
      return if configuration.nil?

      raise OptionError, 'Invalid configuration name' if configuration.empty?
    end
  end
end
