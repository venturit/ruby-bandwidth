module Bandwidth
  # Bandwidth::TestHelpers provides a way to test bandwidth API in isolation
  # when using with rspec allowing you to test api calls.
  # Do not use Bandwidth::TestHelpers in integration tests.
  # example usage in rspec
  #     @bandwidth = Bandwidth::TestHelpers::StubbedConnection.new ENV['BANDWIDTH_USER_ID'],ENV['BANDWIDTH_TOKEN'],ENV['BANDWIDTH_SECRET'] 
  #     BandwidthInc.should_receive(:connect).any_number_of_times.and_return(@bandwidth)
  # 
  # Example use:
  #  describe Meeting do
  #    include Bandwidth::TestHelpers
  #
  #    before(:each) do
  #      @bandwidth = Bandwidth::TestHelpers::StubbedConnection.new ENV['BANDWIDTH_USER_ID'],ENV['BANDWIDTH_TOKEN'],ENV['BANDWIDTH_SECRET'] 
  #      Bandwidth.stub(:new).and_return(@bandwidth)
  #    end
  #
  #    it "should test something here" do
  #     your test  
  #    end
  #  end
  
  module TestHelpers

    class StubbedConnection < Connection
      def http
        @http ||= StubbedHttp.new @user_id, @token, @secret
      end

      alias :short_http :http

      delegate :stub, to: :http

      class StubbedHttp < HTTP
        def connection
          @connection ||= Faraday.new do |faraday|
            faraday.adapter :test, @stubs
            faraday.basic_auth @token, @secret
          end
        end

        def url path
          path
        end

        def stub
          @stubs ||= Faraday::Adapter::Test::Stubs.new
        end
      end
    end
  end

end
