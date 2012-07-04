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
          (function(c,a){var b,d,h,e;b=c.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===c.location.protocol?"https:":"http:")+'//api.mixpanel.com/site_media/js/api/mixpanel.2.js';d=c.getElementsByTagName("script")[0];d.parentNode.insertBefore(b,d);a._i=[];a.init=function(b,c,f){function d(a,b){var c=b.split(".");2==c.length&&(a=a[c[0]],b=c[1]);a[b]=function(){a.push([b].concat(Array.prototype.slice.call(arguments,0)))}}var g=a;"undefined"!==typeof f?g=
a[f]=[]:f="mixpanel";g.people=g.people||[];h="disable track track_pageview track_links track_forms register register_once unregister identify name_tag set_config people.set people.increment".split(" ");for(e=0;e<h.length;e++)d(g,h[e]);a._i.push([b,c,f])};a.__SV=1.1;window.mixpanel=a})(document,window.mixpanel||[]);
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
        %(mixpanel.name_tag('#{id}');)
      end

      def event(name, attributes = {})
        %(mixpanel.track("#{name}", #{attributes.to_json});)
      end

      def people(email, attributes = {})
        values = {"$email" => email}.merge(attributes).to_json
        %(mixpanel.people.set(#{values});)
      end

    end
  end
end
