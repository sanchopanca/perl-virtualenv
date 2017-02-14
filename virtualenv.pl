#!/usr/bin/env perl

use strict;
use warnings;

use Config;
use File::Path qw(make_path);
use File::Basename qw(dirname);
use File::Spec::Functions qw(file_name_is_absolute);
use Cwd qw(abs_path);

my $perl = $Config{perlpath};
my $venv_name = shift || 'venv';
my $venv_directory = shift || '.venv';

if (!file_name_is_absolute($venv_directory)) {
    $venv_directory = abs_path . "/$venv_directory";
}

if (! -d "$venv_directory/bin") {
    make_path "$venv_directory/bin" or die "Unable to create directory '$venv_directory/bin'.\n"
}

print "perl: $perl\n";
print "venv: $venv_directory\n";

sub spit {
    open my $fd, '>', shift;
    print $fd shift;
    close $fd;
}

spit "$venv_directory/bin/perl", <<EOS;
#!/bin/sh
exec $perl -Mlocal::lib="$venv_directory" "\$@"
EOS
chmod 0755, "$venv_directory/bin/perl";

my $cpanm = dirname($perl) . "/cpanm";
spit "$venv_directory/bin/cpanm", <<EOS;
#!/bin/sh
exec $cpanm --local-lib="$venv_directory" "\$@"
EOS
chmod 0755, "$venv_directory/bin/cpanm";

spit "$venv_directory/bin/activate", <<EOS;
eval \$($perl -Mlocal::lib="$venv_directory")

export _PV_OLD_PS1=\$PS1
export PS1="($venv_name)\$PS1"

deactivate() {
	. $venv_directory/bin/deactivate
}
EOS

spit "$venv_directory/bin/deactivate", <<EOS;
eval \$($perl -Mlocal::lib="--deactivate-all,$venv_directory")

if [ -n "\$_PV_OLD_PS1" ]; then
    export PS1=\$_PV_OLD_PS1
    unset _PV_OLD_PS1
    unset deactivate
fi
EOS
