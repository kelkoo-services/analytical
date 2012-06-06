module Analytical
  module Modules
    class Mixpanel
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Mixpanel -->
          <script type="text/javascript">
              (function(d,c){var a,b,g,e;a=d.createElement("script");a.type="text/javascript";
              a.async=!0;a.src=("https:"===d.location.protocol?"https:":"http:")+
              '//api.mixpanel.com/site_media/js/api/mixpanel.2.js';b=d.getElementsByTagName("script")[0];
              b.parentNode.insertBefore(a,b);c._i=[];c.init=function(a,d,f){var b=c;
              "undefined"!==typeof f?b=c[f]=[]:f="mixpanel";g=['disable','track','track_pageview',
              'track_links','track_forms','register','register_once','unregister','identify',
              'name_tag','set_config'];
              for(e=0;e<g.length;e++)(function(a){b[a]=function(){b.push([a].concat(
              Array.prototype.slice.call(arguments,0)))}})(g[e]);c._i.push([a,d,f])};window.mixpanel=c}
              )(document,[]);
              mixpanel.init("#{options[:key]}");
          </script>
          HTML
          js
        end
      end

      def track(event, properties = {})
        callback = properties.delete(:callback) || "function(){}"
        %(mixpanel.track("#{event}", #{properties.to_json}, #{callback});)
      end

      # Used to set "Super Properties" - http://mixpanel.com/api/docs/guides/super-properties
      def set(properties)
        "mixpanel.register(#{properties.to_json});"
      end

      def identify(id, *args)
        opts = args.first || {}
        name = opts.is_a?(Hash) ? opts[:name] : ""
        name_str = name.blank? ? "" : " mixpanel.name_tag('#{name}');"
        %(mixpanel.identify('#{id}');#{name_str})
      end

      def event(name, attributes = {})
        %(mixpanel.track("#{name}", #{attributes.to_json});)
      end

    end
  end
end
