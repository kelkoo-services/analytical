require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Mixpanel" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:js_url_key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abc'
      a.tracking_command_location.should == :body_prepend
    end
    it 'should set the options' do
      a = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abc'
      a.options.should == {:js_url_key=>'abc', :parent=>@parent}
    end
  end
  describe '#identify' do
    it 'should return a js string' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id', {:email=>'test@test.com'}).should == "mixpanel.name_tag('id');"
    end
    it 'should return a js string with name if included' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id', {:email=>'test@test.com', :name => "user_name"}).should == "mixpanel.name_tag('id');"
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :key=>'abcdef'
      @api.track('pagename', {:some=>'data'}).should == "mixpanel.track(\"pagename\", {\"some\":\"data\"}, function(){});"
    end
    it 'should return the tracking javascript with a callback' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :key=>'abcdef'
      @api.track('pagename', {:some=>'data', :callback=>'fubar'}).should == "mixpanel.track(\"pagename\", {\"some\":\"data\"}, fubar);"
    end
  end
  describe '#event' do
    it 'should return a js string' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.event('An event happened', { :item => 43 }).should == "mixpanel.track(\"An event happened\", {\"item\":43});"
    end
  end
  describe '#init_javascript' do
    let(:options) {{:key => ""}}
    it 'should return the init javascript' do
      js = <<-HTML
        <!-- Analytical Init: Mixpanel -->
        <script type="text/javascript">
        (function(c,a){var b,d,h,e;b=c.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===c.location.protocol?"https:":"http:")+'//api.mixpanel.com/site_media/js/api/mixpanel.2.js';d=c.getElementsByTagName("script")[0];d.parentNode.insertBefore(b,d);a._i=[];a.init=function(b,c,f){function d(a,b){var c=b.split(".");2==c.length&&(a=a[c[0]],b=c[1]);a[b]=function(){a.push([b].concat(Array.prototype.slice.call(arguments,0)))}}var g=a;"undefined"!==typeof f?g=
a[f]=[]:f="mixpanel";g.people=g.people||[];h="disable track track_pageview track_links track_forms register register_once unregister identify name_tag set_config people.set people.increment".split(" ");for(e=0;e<h.length;e++)d(g,h[e]);a._i.push([b,c,f])};a.__SV=1.1;window.mixpanel=a})(document,window.mixpanel||[]);
mixpanel.init("#{options[:key]}");
        </script>
      HTML

      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_append).should == ''
      @api.init_javascript(:body_append).should == ''
      @api.init_javascript(:body_prepend).gsub(/\\s+/, "").gsub(" ", '').should == js.gsub(/\\s+/, '').gsub(" ", '')
    end
  end
end
