# encoding: utf-8
require 'spec_helper'
require 'dragonfly/mongo_data_store'
require 'dragonfly/spec/data_store_examples'
require 'mongo'

describe Dragonfly::MongoDataStore do

  let(:app) { Dragonfly.app }
  let(:content) { Dragonfly::Content.new(app, "Pernumbucano") }
  let(:new_content) { Dragonfly::Content.new(app) }

  before(:each) do
    @data_store = Dragonfly::MongoDataStore.new :database => 'dragonfly_test'
  end

  describe "configuring the app" do
    it "can be configured with a symbol" do
      app.configure do
        datastore :mongo
      end
      app.datastore.should be_a(Dragonfly::MongoDataStore)
    end
  end

  it_should_behave_like 'data_store'

  describe "connecting to a replica set" do
    it "should initiate a replica set connection if hosts is set" do
      @data_store.hosts = ['1.2.3.4:27017', '1.2.3.4:27017']
      @data_store.connection_opts = {:name => 'testingset'}
      Mongo::ReplSetConnection.should_receive(:new).with(['1.2.3.4:27017', '1.2.3.4:27017'], :name => 'testingset')
      @data_store.connection
    end
  end

  describe "authenticating" do
    it "should not attempt to authenticate if a username is not given" do
      @data_store.db.should_not_receive(:authenticate)
      @data_store.write(content)
    end

    it "should attempt to authenticate once if a username is given" do
      @data_store.username = 'terry'
      @data_store.password = 'butcher'
      @data_store.db.should_receive(:authenticate).exactly(:once).with('terry','butcher').and_return(true)
      uid = @data_store.write(content)
      @data_store.read(uid)
    end
  end

  describe "sharing already configured stuff" do
    before(:each) do
      @connection = Mongo::Connection.new
    end

    it "should allow sharing the connection" do
      data_store = Dragonfly::MongoDataStore.new :connection => @connection
      @connection.should_receive(:db).and_return(db=double)
      data_store.db.should == db
    end

    it "should allow sharing the db" do
      db = @connection.db('dragonfly_test_yo')
      data_store = Dragonfly::MongoDataStore.new :db => db
      data_store.grid.instance_eval{@db}.should == db # so wrong
    end
  end

  describe "content type" do
    it "should serve straight from mongo with the correct content type (taken from ext)" do
      content.name = 'text.txt'
      uid = @data_store.write(content)
      response = @data_store.grid.get(BSON::ObjectId(uid))
      response.content_type.should == 'text/plain'
      response.read.should == content.data
    end
  end

  describe "already stored stuff" do
    it "still works" do
      uid = @data_store.grid.put("DOOBS", :metadata => {'some' => 'meta'}).to_s
      new_content.update(*@data_store.read(uid))
      new_content.data.should == "DOOBS"
      new_content.meta['some'].should == 'meta'
    end

    it "still works when meta was stored as a marshal dumped hash (but stringifies keys)" do
      uid = @data_store.grid.put("DOOBS", :metadata => Dragonfly::Serializer.marshal_b64_encode(:some => 'stuff')).to_s
      c, meta = @data_store.read(uid)
      meta['some'].should == 'stuff'
    end
  end

end

