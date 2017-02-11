require 'spec_helper'

Options = XCProvisioner::Options
describe Options do
  describe '#new' do
    context 'given no parameters' do
      it 'should raise an error' do
        expect { Options.new }.to raise_error(ArgumentError)
      end
    end

    context 'if project parameter not passed' do
      it 'should raise an error' do
        expect { Options.new({}) }.to raise_error(/No .xcodeproj specified/)
      end
    end

    context 'if project is not a .xcodeproj file' do
      it 'should raise an error' do
        options = { project: 'Bla.xcworkspace' }
        expect do
          Options.new(options)
        end.to raise_error(/Invalid project file type/)
      end
    end

    context "if project file doesn't exist" do
      it 'should raise an error' do
        options = { project: 'Bla.xcodeproj' }
        expected_err = "Specified project file (Bla.xcodeproj) doesn't exist"
        expect do
          Options.new(options)
        end.to raise_error(expected_err)
      end
    end

    context 'when passed a correct project file' do
      before :each do
        path = File.dirname(__FILE__)
        project = File.join(path, 'fixtures', 'Test.xcodeproj')
        @options = { project: project }
      end

      context 'if no provisioning profile specified' do
        it 'should raise an error' do
          expect do
            Options.new(@options)
          end.to raise_error(/No provisioning profile specifier/)
        end
      end

      context 'if specifier is passed' do
        it 'should return a new instance' do
          @options[:specifier] = 'Test'
          expect(Options.new(@options)).not_to be_nil
        end
      end

      context 'if specified an empty string as target' do
        it 'should raise an error' do
          expect do
            @options[:specifier] = 'Test'
            @options[:target] = ''

            Options.new(@options)
          end.to raise_error(/Invalid target name/)
        end
      end

      context 'if specified an empty string as configuration' do
        it 'should raise an error' do
          expect do
            @options[:specifier] = 'Test'
            @options[:configuration] = ''

            Options.new(@options)
          end.to raise_error(/Invalid configuration name/)
        end
      end

      context 'if specified an empty string as development team' do
        it 'should raise an error' do
          expect do
            @options[:specifier] = 'Test'
            @options[:team_id] = ''

            Options.new(@options)
          end.to raise_error(/Development team has a wrong format./)
        end
      end

      context 'if specified development team in a wrong format' do
        it 'should raise an error' do
          expect do
            @options[:specifier] = 'Test'
            @options[:team_id] = 'Wrong format'

            Options.new(@options)
          end.to raise_error(/Development team has a wrong format./)
        end
      end

      context 'if specified all options correctly' do
        it 'returns a new instance' do
          @options[:specifier] = 'Test'
          @options[:configuration] = 'Release'
          @options[:target] = 'Test'
          @options[:team_id] = 'ABC45DRI2DD'
          @options[:identity] = 'iPhone Developer'

          expect(Options.new(@options)).not_to be_nil
        end
      end
    end
  end
end
