Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28078 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaBRI5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 03:57:55 -0500
Date: Tue, 18 Feb 2014 11:56:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] stv090x: remove indent levels
Message-ID: <20140218085651.GL26722@mwanda>
References: <20140206092800.GB31780@elgon.mountain>
 <CAHFNz9LMU0X2YsqniY+6VOS_mM-jUfAvP2sF5MFNdwWWwEVgsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <CAHFNz9LMU0X2YsqniY+6VOS_mM-jUfAvP2sF5MFNdwWWwEVgsw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 09:25:36AM +0530, Manu Abraham wrote:
> Hi Dan,
> 
> On Thu, Feb 6, 2014 at 2:58 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > 1) We can flip the "if (!lock)" check to "if (lock) return lock;" and
> >    then remove a big chunk of indenting.
> > 2) There is a redundant "if (!lock)" which we can remove since we
> >    already know that lock is zero.  This removes another indent level.
> 
> 
> The stv090x driver is a mature, but slightly complex driver supporting
> quite some
> different configurations. Is it that some bug you are trying to fix in there ?
> I wouldn't prefer unnecessary code churn in such a driver for
> something as simple
> as gain in an indentation level.

I thought the cleanup was jusitification enough, but the real reason I
wrote this patch is that testing:

	if (!lock) {
		if (!lock) {

sets off a static checker warning.  That kind of code is puzzling and if
we don't clean it up then it wastes a lot of reviewer time.

Also when you're reviewing these patches please consider that the
original code might be buggy and not simply messy.  Perhaps something
other than "if (!lock) {" was intended?  When I review static checker
warnings I am looking for bugs and I don't even list cleanup patches
like this one in my status reports to my employer.  Fixing these is just
something I do which saves time in the long run.

Btw, I help maintain staging so I review these kinds of patches all the
time.   I use a script to review these kinds of changes.  It strips out
the whitespace changes and leaves the interesting bits of the patch.
I have attached it.

cat email.patch | rename_rev.pl

regards,
dan carpenter


--qcHopEYAB45HaUaB
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="rename_rev.pl"

#!/usr/bin/perl

# This is a tool to help review variable rename patches. The goal is
# to strip out the automatic sed renames and the white space changes
# and leaves the interesting code changes.
#
# Example 1: A patch renames openInfo to open_info:
#     cat diff | rename_review.pl openInfo open_info
#
# Example 2: A patch swaps the first two arguments to some_func():
#     cat diff | rename_review.pl \
#                    -e 's/some_func\((.*?),(.*?),/some_func\($2, $1,/'
#
# Example 3: A patch removes the xkcd_ prefix from some but not all the
# variables.  Instead of trying to figure out which variables were renamed
# just remove the prefix from them all:
#     cat diff | rename_review.pl -ea 's/xkcd_//g'
#
# Example 4: A patch renames 20 CamelCase variables.  To review this let's
# just ignore all case changes and all '_' chars.
#     cat diff | rename_review -ea 'tr/[A-Z]/[a-z]/' -ea 's/_//g'
#
# The other arguments are:
# -nc removes comments
# -ns removes '\' chars if they are at the end of the line.

use strict;
use File::Temp qw/ :mktemp  /;

sub usage() {
    print "usage: cat diff | $0 old new old new old new...\n";
    print "   or: cat diff | $0 -e 's/old/new/g'\n";
    print " -e : execute on old lines\n";
    print " -ea: execute on all lines\n";
    print " -nc: no comments\n";
    print " -nb: no unneeded braces\n";
    print " -ns: no slashes at the end of a line\n";
    exit(1);
}
my @subs;
my @cmds;
my $strip_comments;
my $strip_braces;
my $strip_slashes;

sub filter($) {
    my $_ = shift();
    my $old = 0;
    if ($_ =~ /^-/) {
        $old = 1;
    }
    # remove the first char
    s/^[ +-]//;
    if ($strip_comments) {
        s/\/\*.*?\*\///g;
        s/\/\/.*//;
    }
    foreach my $cmd (@cmds) {
        if ($old || $cmd->[0] =~ /^-ea$/) {
		eval $cmd->[1];
	}
    }
    foreach my $sub (@subs) {
	if ($old) {
		s/$sub->[0]/$sub->[1]/g;
	}
    }
    return $_;
}

while (my $param1 = shift()) {
    if ($param1 =~ /^-nc$/) {
        $strip_comments = 1;
        next;
    }
    if ($param1 =~ /^-nb$/) {
        $strip_braces = 1;
        next;
    }
    if ($param1 =~ /^-ns$/) {
        $strip_slashes = 1;
        next;
    }
    my $param2 = shift();
    if ($param2 =~ /^$/) {
	usage();
    }
    if ($param1 =~ /^-e(a|)$/) {
        push @cmds, [$param1, $param2];
	next;
    }
    push @subs, [$param1, $param2];
}

my ($oldfh, $oldfile) = mkstemp("/tmp/oldXXXXX");
my ($newfh, $newfile) = mkstemp("/tmp/newXXXXX");

while (<>) {
    if ($_ =~ /^(---|\+\+\+)/) {
	next;
    }
    my $output = filter($_);
    if ($_ =~ /^-/) {
	print $oldfh $output;
	next;
    }
    if ($_ =~ /^\+/) {
	print $newfh $output;
	next;
    }
    print $oldfh $output;
    print $newfh $output;
}

my $hunk;
my $old_txt;
my $new_txt;

open diff, "diff -uw $oldfile $newfile |";
while (<diff>) {
    if ($_ =~ /^(---|\+\+\+)/) {
	next;
    }

    if ($_ =~ /^@/) {
        if ($strip_comments) {
            $old_txt =~ s/\/\*.*?\*\///g;
            $new_txt =~ s/\/\*.*?\*\///g;
        }
        if ($strip_braces) {
            $old_txt =~ s/{([^;{]*?);}/$1;/g;
            $new_txt =~ s/{([^;{]*?);}/$1;/g;
	    # this is a hack because i don't know how to replace nested
	    # unneeded curly braces.
            $old_txt =~ s/{([^;{]*?);}/$1;/g;
            $new_txt =~ s/{([^;{]*?);}/$1;/g;
	}

       if ($old_txt ne $new_txt) {
 	    print $hunk;
	    print $_;
	}
	$hunk = "";
	$old_txt = "";
	$new_txt = "";
	next;
    }

    $hunk = $hunk . $_;

    if ($strip_slashes) {
	s/\\$//;
    }

    if ($_ =~ /^-/) {
	s/-//;
	s/[ \t\n]//g;
	$old_txt = $old_txt . $_;
	next;
    }
    if ($_ =~ /^\+/) {
	s/\+//;
	s/[ \t\n]//g;
	$new_txt = $new_txt . $_;
	next;
    }
    if ($_ =~ /^ /) {
	s/^ //;
	s/[ \t\n]//g;
	$old_txt = $old_txt . $_;
	$new_txt = $new_txt . $_;
    }
}
if ($old_txt ne $new_txt) {
    if ($strip_comments) {
        $old_txt =~ s/\/\*.*?\*\///g;
        $new_txt =~ s/\/\*.*?\*\///g;
    }
    if ($strip_braces) {
        $old_txt =~ s/{([^;{]*?);}/$1;/g;
        $new_txt =~ s/{([^;{]*?);}/$1;/g;
        $old_txt =~ s/{([^;{]*?);}/$1;/g;
        $new_txt =~ s/{([^;{]*?);}/$1;/g;
    }

    print $hunk;
}

unlink($oldfile);
unlink($newfile);

--qcHopEYAB45HaUaB--
