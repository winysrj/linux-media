Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58427 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaINLKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Sep 2014 07:10:50 -0400
Received: by mail-pd0-f170.google.com with SMTP id fp1so4384084pdb.1
        for <linux-media@vger.kernel.org>; Sun, 14 Sep 2014 04:10:50 -0700 (PDT)
Date: Sun, 14 Sep 2014 21:10:41 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch] ensure correct install of modules from drivers/{misc,staging}
Message-ID: <20140914111039.GA36126@shambles.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On an ubuntu system the code builds ok but not all modules run properly;
the issue I noticed was the cx23885 module gave these errors when loaded:

[   20.395552] cx23885: disagrees about version of symbol altera_init
[   20.395560] cx23885: Unknown symbol altera_init (err -22)

The cause was that there were two altera-stapl modules in the /lib tree

% find .-type f -name "altera_stapl.ko"
 ./kernel/drivers/misc/altera-stapl/altera-stapl.ko
 ./kernel/drivers/linux/drivers/misc/altera-stapl/altera-stapl.ko

I traced that back to make_makefile.pl; it was not using the right
directory names for any drivers in drivers/misc or drivers/staging.
For example before the patch this line was being generated:

 n=0;for i in altera-stapl.ko;do if [ -f "$i" ]; then if [ $n -eq 0 ]; then echo -n "    ../linux/drivers/misc/altera-stapl/: "; install -d /lib/modules/3.13.0-35-generic/kernel/drivers/media/../linux/drivers/misc/altera-stapl; fi; n=$(($n+1)); if [  $n -eq 4 ]; then echo; echo -n "              "; n=1; fi; echo -n "$i "; install -m 644 -c $i /lib/modules/3.13.0-35-generic/kernel/drivers/media/../linux/drivers/misc/altera-stapl; fi; done; if [  $n -ne 0 ]; then echo; strip --strip-debug /lib/modules/3.13.0-35-generic/kernel/drivers/media/../linux/drivers/misc/altera-stapl/*.ko; fi;


after applying this patch the same line is:

 n=0;for i in altera-stapl.ko;do if [ -f "$i" ]; then if [ $n -eq 0 ]; then echo -n "    ../misc/altera-stapl/: "; install -d /lib/modules/3.13.0-35-generic/kernel/drivers/media/../misc/altera-stapl; fi; n=$(($n+1)); if [  $n -eq 4 ]; then echo; echo -n "          "; n=1; fi; echo -n "$i "; install -m 644 -c $i /lib/modules/3.13.0-35-generic/kernel/drivers/media/../misc/altera-stapl; fi; done; if [  $n -ne 0 ]; then echo; strip --strip-debug /lib/modules/3.13.0-35-generic/kernel/drivers/media/../misc/altera-stapl/*.ko; fi;

This also affects drivers in staging.

The patch is below.

Test system
% cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=14.04
DISTRIB_CODENAME=trusty
DISTRIB_DESCRIPTION="Ubuntu 14.04.1 LTS"
% uname -a
Linux ubuntu 3.13.0-25-generic #62-Ubuntu SMP Fri Aug 15 01:58:01 UTC 2014 i686 i686 i686 GNU/Linux

Vince

[patch] ensure correct install of modules from drivers/{misc,staging}

v4l/scripts/make_mediafile.pl uses the %instdir hash to collate a list
of directories in media_build/linux which contain Makefiles; it uses
this data when constructing a dependency for the Makefile.media target.
It also uses this hash to collate all the individual module names and
generate code which installs the individual modules.
But it gets the installation directory wrong in the case of modules
outside the linux/drivers/media tree.

To fix, do the collation of source locations and conversion into install
locations as separate steps.

signed-off-by: vincent.mcintyre@gmail.com

diff --git a/v4l/scripts/make_makefile.pl b/v4l/scripts/make_makefile.pl
index 134f717..6b9ae55 100755
--- a/v4l/scripts/make_makefile.pl
+++ b/v4l/scripts/make_makefile.pl
@@ -2,7 +2,9 @@
 use FileHandle;
 use File::Find;
 
-my %instdir = ();
+my %srcdir  = (); # keys are directory paths (relative to v4l dir),
+                  # values are hashes with module file names as their keys
+my %instdir = (); # derived from %srcdir
 
 # Take a Makefile line of the form:
 # obj-XXXXX = some_directory/ some_module.o
@@ -12,6 +14,7 @@ my %instdir = ();
 # to install.  Prints the edited line to OUT.
 # Arguments: directory Makefile is in, the objects, original line(s) from
 # Makefile (with newlines intact).
+# Side effects: collates lists of files to install into %srcdir hash
 sub check_line($$$)
 {
 	my $dir = shift;
@@ -29,11 +32,9 @@ sub check_line($$$)
 			next;
 		}
 
-		# It's a file, add it to list of files to install
+		# It's a file, add it to the list of files
 		s/\.o$/.ko/;
-		my $idir = $dir;
-		$idir =~ s|^../linux/drivers/media/?||;
-		$instdir{$idir}{$_} = 1;
+		$srcdir{$dir}{$_} = 1;
 		$count++;
 	}
 	# Removing any tailling whitespace, just to be neat
@@ -184,7 +185,7 @@ sub removeubuntu($)
 	my $dest = "/lib/modules/\$(KERNELRELEASE)/$udir";
 	my $filelist;
 
-	while ( my ($dir, $files) = each(%instdir) ) {
+	while ( my ($dir, $files) = each(%srcdir) ) {
 		$filelist .= ' '. join(' ', keys %$files);
 	}
 	while ( my ($dir, $files) = each(%obsolete) ) {
@@ -232,6 +233,15 @@ removeubuntu("/updates/dkms");
 
 print OUT "\t\@echo \"Installing kernel modules under \$(DESTDIR)\$(KDIR26)/:\"\n";
 
+# change source dirs (relative to v4l dir)
+# into install dirs  (relative to DESTDIR/KDIR26)
+while (my ($dir, $files) = each %srcdir) {
+	my $idir = $dir;
+	$idir =~ s|\.\./linux/drivers/|../|;
+	$idir =~ s|\.\./media/?||;
+	$instdir{$idir} = $files;
+}
+
 while (my ($dir, $files) = each %instdir) {
 	print OUT "\t\@n=0;for i in ", join(' ', keys %$files), ";do ";
 	print OUT "if [ -f \"\$\$i\" ]; then ";
@@ -269,7 +279,7 @@ while ( my ($dir, $files) = each(%instdir) ) {
 	print OUT " rm \$(DESTDIR)\$(KDIR26)/$dir/\$\$i.gz; fi; done; echo;\n\n";
 }
 
-my $mediadeps = join(" \\\n", map("\t../linux/drivers/media/$_/Makefile", keys %instdir));
+my $mediadeps = join(" \\\n", map("\t$_/Makefile", keys %srcdir ));
 $mediadeps =~ s,\.\./linux/drivers/media/\.\.,..,g;
 
 # Print dependencies of Makefile.media
