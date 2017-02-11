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
    attr_reader :team_id
    attr_reader :identity

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
      @team_id = hash[:team_id]
      @identity = hash[:identity]
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
      validate_development_team(options[:team_id])
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

    def validate_development_team(id)
      return if id.nil?

      return true if id =~ /([a-zA-Z]|[0-9]){10}/

      message = ['Development team has a wrong format.
        Expected 10 digits, something like A1B2C3D4E5'].join(' ')
      raise OptionError, message
    end
  end
end
