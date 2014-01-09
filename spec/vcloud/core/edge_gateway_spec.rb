require 'spec_helper'

module Vcloud
  module Core
    describe EdgeGateway do

      before(:each) do
        @edgegw_id = '12345678-1234-1234-1234-000000111454'
        @mock_fog_interface = StubFogInterface.new
        Vcloud::Fog::ServiceInterface.stub(:new).and_return(@mock_fog_interface)
      end

      context "Class public interface" do
        it { EdgeGateway.should respond_to(:get_ids_by_name) }
        it { EdgeGateway.should respond_to(:get_by_name) }
      end

      context "Instance public interface" do
        subject { EdgeGateway.new(@edgegw_id) }
        it { should respond_to(:id) }
        it { should respond_to(:name) }
        it { should respond_to(:href) }
      end

      context "#initialize" do

        it "should be constructable from just an id reference" do
          obj = EdgeGateway.new(@edgegw_id)
          expect(obj.class).to be(Vcloud::Core::EdgeGateway)
        end

        it "should store the id specified" do
          obj = EdgeGateway.new(@edgegw_id)
          expect(obj.id) == @edgegw_id
        end

        it "should raise error if id is not in correct format" do
          bogus_id = '123123-bogus-id-123445'
          expect{ EdgeGateway.new(bogus_id) }.to raise_error("EdgeGateway id : #{bogus_id} is not in correct format" )
        end

      end

      context "#get_by_name" do

        it "should return a EdgeGateway object if name exists" do
          q_results = [
            { :name => 'edgegw-test-1', :href => "/#{@edgegw_id}" }
          ]
          mock_query = double(:query, :get_all_results => q_results)
          Vcloud::Query.should_receive(:new).with('edgeGateway', :filter => "name==edgegw-test-1").and_return(mock_query)
          @obj = EdgeGateway.get_by_name('edgegw-test-1')
          expect(@obj.class).to be(Vcloud::Core::EdgeGateway)
        end

        it "should return an object with the correct id if name exists" do
          q_results = [
            { :name => 'edgegw-test-1', :href => "/#{@edgegw_id}" }
          ]
          mock_query = double(:query, :get_all_results => q_results)
          Vcloud::Query.should_receive(:new).with('edgeGateway', :filter => "name==edgegw-test-1").and_return(mock_query)
          @obj = EdgeGateway.get_by_name('edgegw-test-1')
          expect(@obj.id) == @edgegw_id
        end

        it "should raise an error if no edgegw with that name exists" do
          q_results = [ ]
          mock_query = double(:query, :get_all_results => q_results)
          Vcloud::Query.should_receive(:new).with('edgeGateway', :filter => "name==edgegw-test-1").and_return(mock_query)
          expect{ EdgeGateway.get_by_name('edgegw-test-1') }.to raise_exception(RuntimeError, "edgeGateway edgegw-test-1 not found")
        end

      end

    end

  end

end
