mruby Code Search
===========

Source code search engine for mruby &amp; libraries 

- mrbgems
- ngx_mruby
- mobiruby
- etc..

## Deploy

### Install gem

```
$ cd /path/to
$ git clone https://github.com/ongaeshi/mruby-code-search.git
$ cd /path/to/mruby-code-search
$ bundle install --path vendor/bundle
```

### Initialize Milkode Database

```
$ cd /path/to/mruby-code-search
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
$ cd /path/to/mruby-code-search
$ ./tools/cron_task
```

Register crontab.

```
$ crontab -e
PATH=/usr/local/bin:/bin:/usr/bin:/sbin    # Set your environment

0	5	*	*	*	cd /path/to/mruby-code-search; ./tools/cron_task
```

With simple logging.

```
$ crontab -e
PATH=/usr/local/bin:/bin:/usr/bin:/sbin    # Set your environment

0	5	*	*	*	cd /path/to/mruby-code-search; ./tools/cron_task >>./log/mruby-code-search.log 2>>./log/mruby-code-search-error.log
```


## Add The Source Code That You Want To Search

1. Fork [ongaeshi/mruby-code-search](https://github.com/ongaeshi/mruby-code-search/tree/master).
2. Add a repository URL that you want to search to [mruby-code-search/PACKAGE_LIST](https://github.com/ongaeshi/mruby-code-search/blob/master/PACKAGE_LIST) in alphabetical order.
3. Send us a pull request.


