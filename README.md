mrubysearch
===========

Source code search engine for mruby &amp; libraries (mrbgems, ngx_mruby, mobiruby, etc)

## Deploy

Install gem

```
$ cd /var/www/html
$ git clone https://github.com/ongaeshi/mrubysearch.git
$ cd /var/www/html/mrubysearch
$ bundle install --path vendor/bundle
```

Initialize Milkode database

```
$ bundle exec milk add --from-file PACKAGE_LIST
```

Check it your browser (local)

```
$ bundle exec milk web    # http://localhost:9292
```

After, set to suit your environment.

Apache configuration: [y-ken/milkode-web](https://github.com/y-ken/milkode-web)

## Cron

Test.

```
$ cd /path/to/mrubysearch
$ MRUBYSEARCH_ROOT=/path/to/mrubysearch ./tools/cron_task
```

Register crontab.

```
$ crontab -e
0	5	*	*	*	MRUBYSEARCH_ROOT=/path/to/mrubysearch /path/to/mrubysearch/tools/cron_task
```

## Add The Source Code That You Want To Search

1. Fork [ongaeshi/mrubysearch](https://github.com/ongaeshi/mrubysearch/tree/master)

2. Add repository URL that you want to search to [mrubysearch/PACKAGE_LIST](https://github.com/ongaeshi/mrubysearch/blob/master/PACKAGE_LIST) (Please alphabetical order)

3. Pull request


