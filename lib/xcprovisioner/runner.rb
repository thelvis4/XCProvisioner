require 'xcodeproj'

module XCProvisioner
  # Does the actual work of setting the Provisioning Profile specifier to
  # a Xcode project.
  class Runner
    attr_reader :options

    # Initialize a new Runner instance
    # Params:
    # - options: an instance of Options
    def initialize(options)
      unless options.is_a?(Options)
        raise ArgumentError, 'Expected an instance of type Options'
      end

      @options = options
    end

    def run
      targets.each do |target|
        switch_to_manual_signing(target)
        target.build_configuration_list.build_configurations.each do |config|
          next unless should_set_for_configuration?(config)

          show_updating_message(target, config)
          set_provisioning_profile_specifier(config, options.specifier)
        end
      end

      project.save
    end

    private

    def project
      @project ||= Xcodeproj::Project.open(options.project) # lazy evaluation
    end

    def targets
      # lazy evaluation
      @target ||= compute_targets
    end

    def compute_targets
      return project.targets if target_name.nil?
      matched = project.targets.find { |t| t.name == target_name }

      if matched.nil?
        raise StandardError, "No target matching '#{target_name}' name"
      end

      [matched] # return as array
    end

    def should_set_for_configuration?(configuration)
      return true if options.configuration.nil?

      configuration.name == options.configuration
    end

    def set_provisioning_profile_specifier(configuration, specifier)
      specifier_key = 'PROVISIONING_PROFILE_SPECIFIER'
      configuration.build_settings[specifier_key] = specifier
    end

    def switch_to_manual_signing(target)
      target_id = target.uuid
      attributes = project.root_object.attributes['TargetAttributes']
      target_attributes = attributes[target_id]
      target_attributes['ProvisioningStyle'] = 'Manual'
    end

    def target_name
      options.target
    end

    def show_updating_message(target, configuration)
      message = [
        "Updating Provisioning Profile Specifier '#{options.specifier}'",
        "for target '#{target.name}' and configuration '#{configuration.name}'"
      ].join(' ')
      puts message
    end
  end
end
