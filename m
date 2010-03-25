Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab0CYVYg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Mar 2010 17:24:36 -0400
Message-ID: <4BABD48F.30403@redhat.com>
Date: Thu, 25 Mar 2010 18:24:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Douglas Landgraf <dougsland@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH -hg] Add a tool to compare -git and -hg trees
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds diffrev.h, to allow comparing the differences between the git
and mercurial trees.

I used an old version of this script for quite a long time, in order to
compare the -hg and -git trees, and be sure that the sync between them
didn't lost anything. Douglas is currently using it to be sure that both
trees are in sync, when he merges from upstream.

It basically calls the gentree.pl script, to generate a version of the
tree without any compat code, and applies a few patches with some known
differences, generally in the files maintained on other subsystems.

It also contains blacklist.txt with files that shouldn't be considered
as missing files.

This version is smart enough to work with 0, 1 or 2 parameters. For it
to work with 0 parameters, the GIT_TREE and HG_TREE environment vars
should exist.

When called with one parameter, it assumes that the diff is to be done
between the current tree and another one. So, in order to do a diff
between the current dir and a git tree as ~/v4l-dvb-git, all that is needed
is to call:

./v4l/scripts/diffrev.sh ~/v4l-dvb-git

As output, it produces 4 files, at /tmp:

/tmp/diff - differences between the two git trees
/tmp/diff2 - differences, excluding the ones caused by whitespacing
somente - files that are only on one of the trees
somente2 - files that are only on one of the trees, excluding the ones
at the blacklist.

As described on Part III, chapter 2, item (d), codes at -hg tree with
just #if 0 or #if 1 are dropped, when sending to git. This is one of
the procedures that were agreed since 2005, when we've moved from cvs
to git. This procedure helped to remove a huge number of lines with
dead code.

As I think we need to review and remove the code that are there for a
long time without anyone touched it, I've added a flag at the gentree.pl
to preserve all those #if 0/#if 1 code by default.

In order to work with the old way (e. g., removing the dead code from
the compare), a new option were added to both gentree.pl and diffrev.sh:
	--strip_dead_code

As all code on v4l-dvb tree, except otherwise said, the scripts are GPLv2
only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/v4l/scripts/diffrev.sh b/v4l/scripts/diffrev.sh
new file mode 100755
--- /dev/null
+++ b/v4l/scripts/diffrev.sh
@@ -0,0 +1,121 @@
+#/bin/bash
+
+# Set default tree locations, if you want, at the shell ENV
+#GIT_TREE=$HOME/v4l-dvb
+#HG_TREE=$HOME/v4l-dvb-hg
+
+# Should be adjusted to the environment
+TMP_TREE=/tmp/oldtree
+KERNVER_FILE=./v4l/scripts/etc/kern_version
+FIXPATCHES=./v4l/scripts/etc/fixdiffs/*
+BLACKLIST=./v4l/scripts/etc/blacklist.txt
+GENTREE=./v4l/scripts/gentree.pl
+
+if [ "$1" == "--strip-dead-code" ]; then
+	GENTREE_ARGS="$1"
+	shift
+fi
+
+if [ "$2" != "" ]; then
+	#
+	# Two arguments were given. One tree should be hg and the other git
+	#
+	if [ -e $1/.hg/hgrc ]; then
+		HG_TREE=$1
+		GIT_TREE=$2
+	else
+		HG_TREE=$2
+		GIT_TREE=$1
+	fi
+else
+	#
+	# If just one argument is selected, and it is called from one tree
+	#    use the other argument for the other tree type
+	#    otherwise, use default plus the given tree name
+	#
+	if [ "$1" != "" ]; then
+		if [ -e $1/.hg/hgrc ]; then
+			HG_TREE=$1
+			if [ -e .git/config ]; then
+				GIT_TREE=.
+			fi
+		elif [ -e $1/.git/config ]; then
+			GIT_TREE=$1
+			if [ -e .hg/hgrc ]; then
+				HG_TREE=.
+			fi
+		fi
+	fi
+fi
+
+if [ "$GIT_TREE" == "" ]; then
+	echo "No git tree were provided."
+	ERROR=1
+fi
+
+if [ "$HG_TREE" == "" ]; then
+	echo "No mercurial tree were provided."
+	ERROR=1
+fi
+
+if [ "$ERROR" !=  "" ]; then
+	echo "Usage: $0 [--strip-dead-code] <tree1> [<tree2>]"
+	exit -1
+fi
+
+if [ ! -e "$GIT_TREE/.git/config" ]; then
+	echo "$GIT_TREE is not a git tree. Should specify a git tree to compare with the $HG_TREE mercurial tree"
+	exit -1
+fi
+
+if [ ! -e "$HG_TREE/.hg/hgrc" ]; then
+	echo "$HG_TREE is not a mercurial tree. Should specify -hg tree to compare with the $GIT_TREE git tree"
+	exit -1
+fi
+
+echo "comparing $HG_TREE -hg tree with $GIT_TREE -git tree."
+
+
+run() {
+	echo $@
+	$@
+}
+
+echo removing oldtree..
+run rm -rf $TMP_TREE
+echo creating an oldtree..
+run $GENTREE $GENTREE_ARGS `cat $KERNVER_FILE` $HG_TREE/linux $TMP_TREE >/dev/null
+
+echo applying the fix patches
+for i in $FIXPATCHES; do
+	echo $i
+	run patch --no-backup-if-mismatch -R -d $TMP_TREE -p2 -i $i -s
+	diffstat -p1 $i
+done
+
+echo removing rej/orig from $GIT_TREE
+run find $GIT_TREE -name '*.rej' -exec rm '{}' \;
+run find $GIT_TREE -name '*.orig' -exec rm '{}' \;
+
+echo removing rej/orig from oldtree
+run find $TMP_TREE -name '*.rej' -exec rm '{}' \;
+run find $TMP_TREE -name '*.orig' -exec rm '{}' \;
+
+echo generating "/tmp/diff"
+diff -upr $TMP_TREE $GIT_TREE|grep -v ^Somente |grep -v ^Only>/tmp/diff
+echo "generating /tmp/diff2 (loose diff0)"
+diff -uprBw $TMP_TREE $GIT_TREE|grep -v Somente |grep -v ^Only>/tmp/diff2
+echo generating /tmp/somente2 for a complete oldtree-only files
+diff -upr $TMP_TREE $GIT_TREE|grep ^Somente|grep "drivers/media" |grep -vr ".o$" |grep -v ".mod.c"|grep -v ".o.cmd" |grep -v modules.order >/tmp/somente2
+diff -upr $TMP_TREE $GIT_TREE|grep ^Only|grep "drivers/media" |grep -vr ".o$" |grep -v ".mod.c"|grep -v ".o.cmd" |grep -v modules.order >>/tmp/somente2
+
+echo generating /tmp/somente for oldtree-only files
+cp /tmp/somente2 /tmp/s$$
+for i in `cat $BLACKLIST`; do
+	cat /tmp/s$$ | grep -v "Somente.* $i" >/tmp/s2$$
+	mv /tmp/s2$$ /tmp/s$$
+done
+mv /tmp/s$$ /tmp/somente
+echo
+echo diffstat -p1 /tmp/diff
+diffstat -p1 /tmp/diff
diff --git a/v4l/scripts/etc/blacklist.txt b/v4l/scripts/etc/blacklist.txt
new file mode 100644
--- /dev/null
+++ b/v4l/scripts/etc/blacklist.txt
@@ -0,0 +1,14 @@
+\.orig
+\.rej
+\.cvsignore
+bt87x.c
+i2c-compat.h
+at76c651[.][ch]
+tda80xx[.][ch]
+tvmixer.c
+aci.[ch]
+btaudio.c
+dvb-ttusb-dspbootcode.h
+cpia2patch.h
+dabfirmware.h
+^firmware/
diff --git a/v4l/scripts/etc/fixdiffs/98.patch b/v4l/scripts/etc/fixdiffs/98.patch
new file mode 100644
--- /dev/null
+++ b/v4l/scripts/etc/fixdiffs/98.patch
@@ -0,0 +1,18 @@
+
+diff -upr oldtree/drivers/media/dvb/dvb-core/dvb_net.c /home/v4l/tokernel/wrk/linux-next/drivers/media/dvb/dvb-core/dvb_net.c
+--- next/drivers/media/dvb/dvb-core/dvb_net.c	2010-01-15 19:05:35.000000000 -0200
++++ ../oldtree/drivers/media/dvb/dvb-core/dvb_net.c	2010-01-15 19:11:43.000000000 -0200
+@@ -949,11 +949,8 @@ static int dvb_net_filter_sec_set(struct
+ 	(*secfilter)->filter_mask[10] = mac_mask[1];
+ 	(*secfilter)->filter_mask[11]=mac_mask[0];
+ 
++	dprintk("%s: filter mac=%pM\n", dev->name, mac);
++	dprintk("%s: filter mask=%pM\n", dev->name, mac_mask);
+-	dprintk("%s: filter mac=%02x %02x %02x %02x %02x %02x\n",
+-	       dev->name, mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+-	dprintk("%s: filter mask=%02x %02x %02x %02x %02x %02x\n",
+-	       dev->name, mac_mask[0], mac_mask[1], mac_mask[2],
+-	       mac_mask[3], mac_mask[4], mac_mask[5]);
+ 
+ 	return 0;
+ }
diff --git a/v4l/scripts/etc/fixdiffs/99.patch b/v4l/scripts/etc/fixdiffs/99.patch
new file mode 100644
--- /dev/null
+++ b/v4l/scripts/etc/fixdiffs/99.patch
@@ -0,0 +1,24 @@
+Whitespace cleanup
+
+--- git/sound/pci/bt87x.c	2007-10-16 23:42:25.000000000 -0200
++++ ../oldtree/sound/pci/bt87x.c	2007-10-17 12:46:18.000000000 -0200
+@@ -122,8 +122,8 @@ MODULE_PARM_DESC(load_all, "Allow to loa
+ /* RISC instruction bits */
+ #define RISC_BYTES_ENABLE	(0xf << 12)	/* byte enable bits */
+ #define RISC_RESYNC		(  1 << 15)	/* disable FDSR errors */
+-#define RISC_SET_STATUS_SHIFT	        16	/* set status bits */
+-#define RISC_RESET_STATUS_SHIFT	        20	/* clear status bits */
++#define RISC_SET_STATUS_SHIFT		16	/* set status bits */
++#define RISC_RESET_STATUS_SHIFT		20	/* clear status bits */
+ #define RISC_IRQ		(  1 << 24)	/* interrupt */
+ #define RISC_EOL		(  1 << 26)	/* end of line */
+ #define RISC_SOL		(  1 << 27)	/* start of line */
+@@ -226,7 +226,7 @@ static inline void snd_bt87x_writel(stru
+ }
+ 
+ static int snd_bt87x_create_risc(struct snd_bt87x *chip, struct snd_pcm_substream *substream,
+-			       	 unsigned int periods, unsigned int period_bytes)
++				 unsigned int periods, unsigned int period_bytes)
+ {
+ 	struct snd_sg_buf *sgbuf = snd_pcm_substream_sgbuf(substream);
+ 	unsigned int i, offset;
diff --git a/v4l/scripts/etc/kern_version b/v4l/scripts/etc/kern_version
new file mode 100644
--- /dev/null
+++ b/v4l/scripts/etc/kern_version
@@ -0,0 +1,1 @@
+2.6.33
diff --git a/v4l/scripts/gentree.pl b/v4l/scripts/gentree.pl
old mode 100644
new mode 100755
--- a/v4l/scripts/gentree.pl
+++ b/v4l/scripts/gentree.pl
@@ -40,8 +40,10 @@ use Fcntl ':mode';
 use Getopt::Long;
 
 my $DEBUG = 0;
+my $dead_code = 0;
 
-GetOptions( "--debug" => \$DEBUG );
+GetOptions( "--debug" => \$DEBUG,
+	    "--strip-dead-code" => \$dead_code );
 
 my $VERSION = shift;
 my $SRC = shift;
@@ -130,6 +132,13 @@ sub filter_source ($$) {
 			$line =~ s/\Q$2\E//;
 			$level++;
 		}
+		# preserve #if 0/#if 1, if $dead_code = 0
+		elsif (!$dead_code && $line =~ m@^\s*#\s*if\s*([01])[^\d]@) {
+			$state{$level} = "ifother";
+			$if{$level} = 1;
+			dbgline "#if $1", @dbgargs;
+			$level++;
+		}
 		# handle all ifdef/ifndef lines
 		elsif ($line =~ /^\s*#\s*if(n?)def\s*(\w+)/o) {
 			if (exists $defs{$2}) {
