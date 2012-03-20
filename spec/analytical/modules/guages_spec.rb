require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Gauges" do
  let(:gauges_module) { Analytical::Modules::Gauges.new({ :key => '1234abc' }) }

  describe "on initialize" do
    it "should set the command_location" do
      gauges_module.tracking_command_location.should == :head_append
    end

    it 'should set the options' do
      gauges_module.options.should == {:key=>'1234abc'}
    end
  end

  describe '#init_javascript' do
    it 'should return the init javascript' do
      gauges_module.init_javascript(:head_prepend).should == ''
      gauges_module.init_javascript(:head_append).should =~ /1234abc/
      gauges_module.init_javascript(:head_append).should =~ /secure.gaug.es\/track.js/
      gauges_module.init_javascript(:body_prepend).should == ''
      gauges_module.init_javascript(:body_append).should == ''
    end
  end
end
