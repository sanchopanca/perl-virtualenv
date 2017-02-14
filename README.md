perl-virtualenv
===============

Virtual Environment for Perl

Usage
-----

### Activate & deactivate

```bash
$ cd /path/to/project
$ /path/to/perl/bin/virtualenv.pl my-project
$ source .venv/bin/activate
(my-project) $ perl -v
(my-project) $ cpanm -v
(my-project) $ deactivate
$ perl -v
```
You can specify path for new perl environment as third argument:

```bash
/path/to/perl/bin/virtualenv.pl my-project /path/where/the/venv/going/to/live
```

### Use it directly

```bash
$ /path/to/project/.venv/bin/perl -v
```
