module Analytical
  module Modules
    class GoSquared
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: GoSquared -->
         <script type="text/javascript">
              var GoSquared={};
              GoSquared.acct = "#{options[:key]}";
              (function(w){
                  function gs(){
                      w._gstc_lt=+(new Date); var d=document;
                      var g = d.createElement("script"); g.type = "text/javascript"; g.async = true; g.src = "//d1l6p2sc9645hc.cloudfront.net/tracker.js";
                      var s = d.getElementsByTagName("script")[0]; s.parentNode.insertBefore(g, s);
                  }
                  w.addEventListener?w.addEventListener("load",gs,false):w.attachEvent("onload",gs);
              })(window);
          </script> 
          HTML
          js
        end
      end
    end
  end
end
