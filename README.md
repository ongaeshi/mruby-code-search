mrubysearch
===========

mruby &amp; mrbgems search engine

## Deploy

[y-ken/milkode-web](https://github.com/y-ken/milkode-web)

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
