Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:5270 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583Ab1JEJda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 05:33:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC PATCH] media_build: two fixes + one unresolved issue
Date: Wed, 5 Oct 2011 11:23:39 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110051123.39783.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

While doing a compatibility build I found three issues. I've got patches for two,
but one issue is still unresolved.

The first is this small patch to get rid of this warning when doing 'make install':

make -C firmware install
make[2]: Entering directory `/home/hve/work/media_build/v4l/firmware'
Installing firmwares at /lib/firmware: vicam/firmware.fw dabusb/firmware.fw dabusb/bitstream.bin ttusb-budget/dspbootcode.bin 
cpia2/stv0672_vp4.bin av7110/bootcode.bin *.fw* cp: target `/lib/firmware/v4l-pvrusb2-29xxx-01.fw' is not a directory
make[2]: [install] Error 1 (ignored)

The fix is simply to remove '*.fw*' since it doesn't match any files.

diff --git a/v4l/firmware/Makefile b/v4l/firmware/Makefile
index fb53ef2..bcbc784 100644
--- a/v4l/firmware/Makefile
+++ b/v4l/firmware/Makefile
@@ -22,7 +22,7 @@ distclean: clean
 install: default
 	@echo -n "Installing firmwares at $(FW_DIR): "
 	-@for i in $(DIRS); do if [ ! -d $(FW_DIR)/$$i ]; then mkdir -p $(FW_DIR)/$$i; fi; done
-	-@for i in $(TARGETS) *.fw*; do echo -n "$$i "; cp $$i $(FW_DIR)/$$i; done
+	-@for i in $(TARGETS); do echo -n "$$i "; cp $$i $(FW_DIR)/$$i; done
 	@echo
 
 rminstall:

I think this fix is fine, unless this is something you want to have for the future.

The other is a kernel naming issue: my aptosid distro (debian based) running
kernel v3.0.0 uses a different naming convention:

$ uname -r
3.0-4.slh.6-aptosid-amd64

So the sublevel is not shown.

This patch makes the sublevel optional (and assumes it to be 0 if absent):

diff --git a/linux/patches_for_kernel.pl b/linux/patches_for_kernel.pl
index c19b216..33348d9 100755
--- a/linux/patches_for_kernel.pl
+++ b/linux/patches_for_kernel.pl
@@ -13,8 +13,11 @@ my $file = "../backports/backports.txt";
 open IN, $file or die "can't find $file\n";
 
 sub kernel_version($) {
-	$_[0] =~ m/^(\d+)\.(\d+)\.(\d+)/;
-	return ($1*65536 + $2*256 + $3);
+	my $sublevel;
+
+	$_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
+	$sublevel = $3 == "" ? 0 : $3;
+	return ($1*65536 + $2*256 + $sublevel);
 }
 
 my $kernel = kernel_version($version);
diff --git a/v4l/Makefile b/v4l/Makefile
index ab07a7a..311924e 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -248,7 +248,7 @@ ifneq ($(VER),)
 	@echo $(VER)|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) { printf 
("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",$$1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version
 else
 	@echo No version yet, using `uname -r`
-	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) { printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.
%s.%s%s\n",$$1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version
+	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) { printf 
("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$1,$$2,$$3==""?"0":$$3,$$_); };' > $(obj)/.version
 endif
 endif
 
The last issue I have is that the media.ko module isn't installed when I run
'make install'. I tried to fix it, but I got lost in the Makefile/perl magic :-)

Let me know if you are OK with these two patches, and if you can fix the last
issue (or give me some hints on how to fix it), then that would be great!

Regards,

	Hans
