# Dragonfly::MongoDataStore

Mongo data store for use with the (http://github.com/markevans/dragonfly)[Dragonfly] gem.

## Gemfile

    gem 'dragonfly-mongo_data_store'

## Usage

In your dragonfly config block (with default options):

    Dragonfly.app.configure

      # ...

      datastore :mongo

      # ...

    end

Or with options:

    datastore :mongo, host: 'my.host', database: 'my_database'

### Available options

      host              # e.g. 'my.domain'
      hosts             # for replica sets, e.g. ['n1.mydb.net:27017', 'n2.mydb.net:27017']
      connection_opts   # hash that passes through to Mongo::Connection or Mongo::ReplSetConnection
      port              # e.g. 27017
      database          # defaults to 'dragonfly'
      username
      password
      connection        # use this if you already have a Mongo::Connection object
      db                # use this if you already have a Mongo::DB object
