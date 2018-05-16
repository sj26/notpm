# Not-quite NPM

Just enough NPM to `npm install` quickly, without the Internet.

The [NPM registry](https://www.npmjs.com) was originally a great big [couchdb](http://couchdb.apache.org) database, with package tarballs embedded as binary attachments, and [a couchdb app](https://github.com/npm/npm-registry-couchapp) sitting in front to provide some smarts. It's possible to [replicate the whole registry into a new database](https://github.com/npm/npm-fullfat-registry), but this is very slow and difficult to setup and maintain. Instead, this project implements just enough registry to mirror packages and serve them to [npm](https://docs.npmjs.com) and [yarn](https://yarnpkg.com/en/docs/cli/) clients for installation.

## Updating the mirror

You'll need [aria2c](https://aria2.github.io) installed — it lets us download http packages really quickly and with concurrency. The mirror process also currently rewrites the download URLs to a fixed URL base, but this will be fixed in the application soon.

Try:

```
bin/mirror --all
```

This will write status into `tmp/sequence` and can be cancelled and resumed gracefully.

You can also mirror specific packages:

```
bin/mirror PACKAGE...
```

And if you want to mirror all runtime dependencies, too:

```
bin/mirror --deps PACKAGE...
```

This downloads the couchdb documents into `db/[name].json` with rewritten URLs, and tarballs into `db/[name]/[name]-[version].tgz`

## Running

The application is built with [Ruby](http://ruby-lang.org) and [Sinatra](http://sinatrarb.com) (yes, I know, but it was written for a [Railscamp](http://rails.camp) and can be run, after [bundling](http://bundler.io), with `rackup` or your favourite [Rack](https://rack.github.io) server (we're using [Passenger](https://www.phusionpassenger.com) at camp):

```
# Install dependencies
bundle

# Run the http server, http://localhost:3000 by default
rackup
```

Then you can install packages by pointing at the registry:

```
npm install --registry=http://localhost:3000
```

```
yarn install --registry=http://localhost:3000
```

It really just serves the json files from `http://.../[name]` and the tarballs from `http://.../[name]/-/[name]-[version].tgz` by using sendfile. You could probably also create a clever nginx setup which does the same thing directly from a directory.
