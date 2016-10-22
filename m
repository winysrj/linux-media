Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756150AbcJVWwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 18:52:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/5] update Documentation/media/v4l-drivers/gspca-cardlist.rst
Date: Sat, 22 Oct 2016 20:51:59 -0200
Message-Id: <cover.1477176498.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gspca cardlist is outdated: several new boards were added and
even a few drivers. 

This series adjust the comments on two drivers and, with the help of
a parser, add the missing entries.

As several of those new entries don't have any description at the
gspca drivers, fill the device names by googling them at the Internet.

The gspca  cardlist was updated using the following script:

<script>
#!/usr/bin/perl -w
use strict;
use File::Find;

my $src = "drivers/media/usb/gspca/";
my $table = 0;
my %data;

my $id;

my $len = 0;

# perl -ne 'printf "%-15s %s:%s\n", $1, $2, $3 if (m;/([^\/]+)\:.*USB_DEVICE.*0x(\S+)\s*\,\s*0x(\S+)\);)'|sort -k2

#
# Read GSPCA cardlist
#

open IN, "Documentation/media/v4l-drivers/gspca-cardlist.rst";
while (<IN>) {
	if (m/^=+\s+=+\s+=+$/) {
		$table++;
		next;
	}
	next if ($table != 2);
	if (m/^(\S+)\s+(\S+)\s+(.*)/) {
		$id = "$1_$2";
		$data{$id}->{driver} = $1;
		$data{$id}->{usb_id} = $2;
		$data{$id}->{name} = $3;
		$data{$id}->{valid} = 0;

		$len = length($3) if (length($3) > $len);
	}
}
close IN;

#
# Check for new entries
#


sub parse_dir {
        my $file = $File::Find::name;

	open IN, $file;

	my $driver = $file;

	$driver =~ s,($src),,;

	$driver =~ s,/.*,,;
	$driver =~ s,\.c$,,;

	while (<IN>) {
		next if (m,/\*.*USB_DEVICE,);
		if (m/USB_DEVICE[^\(]*\(\s*0x(\S+)\s*\,\s*0x(\S+)\)(.*)/) {
			my $n = "$1:$2";
			my $o = $3;
			$id = "${driver}_$n";

			$data{$id}->{valid} = 1;

			next if (defined $data{$id}->{driver});

			$data{$id}->{driver} = $driver;
			$data{$id}->{usb_id} = $n;

			if ($o =~ m,\/\*\s*(.*)\*\/,) {
				$n = $1;
				$n =~ s/\s+//;
				$data{$id}->{name} = $n;
			} else {
				$data{$id}->{name} = "";
			}
		}
	}
	close IN;
}

find({wanted => \&parse_dir, no_chdir => 1}, $src);

#
# Output GSPCA cardlist, ordered by USB ID
#

print "The gspca cards list\n";
print "====================\n\n";
print "The modules for the gspca webcam drivers are:\n\n";
print "- gspca_main: main driver\n";
print "- gspca\\_\\ *driver*: subdriver module with *driver* as follows\n\n";
print "=========	=========	" . "=" x $len . "\n";
print "*driver*	vend:prod	Device\n";
print "=========	=========	" . "=" x $len . "\n";

foreach my $id (sort { $data{$a}->{usb_id} . $data{$a}->{driver} cmp $data{$b}->{usb_id} . $data{$b}->{driver} } keys %data) {
	next if (!$data{$id}->{valid});

	my $s = sprintf "%-15s %s\t%s\n",
		$data{$id}->{driver}, $data{$id}->{usb_id}, $data{$id}->{name};

	# Replace tabs by spaces
	$s =~ s/[ \t]+$//;
        $s =~ s<^ {8}> <\t>;
        $s =~ s<^ {1,7}\t> <\t>;
        $s =~ s< {1,7}\t> <\t>;

	printf $s;
}
print "=========	=========	" . "=" x $len . "\n";
</script>


Mauro Carvalho Chehab (5):
  spca506: rewrite a commented line to avoid wrong parsing
  stv06xx: store device name after the USB_DEVICE line
  gspca-cardlist.rst: sort entries and adjust table margins
  gspca-cardlist.rst: update cardlist from drivers USB IDs
  gspca-cardlist.rst: update camera names

 Documentation/media/v4l-drivers/gspca-cardlist.rst | 843 +++++++++++----------
 drivers/media/usb/gspca/spca506.c                  |   3 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |  18 +-
 3 files changed, 447 insertions(+), 417 deletions(-)

-- 
2.7.4


