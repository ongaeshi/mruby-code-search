mrubysearch
===========

Source code search engine for mruby &amp; libraries (mrbgems, ngx_mruby, mobiruby, etc)

## Deploy

### Install gem

```
$ cd /path/to
$ git clone https://github.com/ongaeshi/mrubysearch.git
$ cd /path/to/mrubysearch
$ bundle install --path vendor/bundle
```

### Initialize Milkode Database

```
$ cd /path/to/mrubysearch
$ bundle exec milk init
```

### Add source codes to Milkode Database

```
$ cd data
$ bundle exec milk add --from-file ../PACKAGE_LIST
```

### Check it in your browser (local)

```
$ bundle exec milk web    # http://localhost:9292
```

### After, set to suit your environment.

- Apache configuration: [y-ken/milkode-web](https://github.com/y-ken/milkode-web)

## Cron

Test.

```
$ cd /path/to/mrubysearch
$ MRUBYSEARCH_ROOT=/path/to/mrubysearch ./tools/cron_task
```

Register crontab.

```
$ crontab -e
PATH=/usr/local/bin:/bin:/usr/bin:/sbin    # Set your environment

0	5	*	*	*	MRUBYSEARCH_ROOT=/path/to/mrubysearch /path/to/mrubysearch/tools/cron_task
```

With simple logging.

```
$ crontab -e
PATH=/usr/local/bin:/bin:/usr/bin:/sbin    # Set your environment

0	5	*	*	*	MRUBYSEARCH_ROOT=/path/to/mrubysearch /path/to/mrubysearch/tools/cron_task  >>/path/to/mrubysearch/log/mrubysearch.log 2>>/path/to/mrubysearch/log/mrubysearch-error.log
```


## Add The Source Code That You Want To Search

1. Fork [ongaeshi/mrubysearch](https://github.com/ongaeshi/mrubysearch/tree/master).
2. Add a repository URL that you want to search to [mrubysearch/PACKAGE_LIST](https://github.com/ongaeshi/mrubysearch/blob/master/PACKAGE_LIST) in alphabetical order.
3. Send us a pull request.


