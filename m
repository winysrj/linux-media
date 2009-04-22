Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:44218 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZDVNrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 09:47:05 -0400
Received: from ozzy.localnet (dhpc-2-02.sissa.it [147.122.2.182])
	by smtp.sissa.it (Postfix) with ESMTP id 243BA1B48093
	for <linux-media@vger.kernel.org>; Wed, 22 Apr 2009 15:27:50 +0200 (CEST)
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH] Make firmware before install
Date: Wed, 22 Apr 2009 15:28:11 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904221528.13225.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Presently with the usual:

make && sudo make install

firmware is not built during make, but in the second step with root privileges,
which should be avoided.
This patch adds firmware dependency to the default make target.
Moreover, one more file (ihex2fw) should be deleted by firmware clean.

Priority: normal

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>

---
diff -r 2a6d95947fa1 -r bf39a52e7f49 v4l/Makefile
--- a/v4l/Makefile	Sun Apr 19 20:21:03 2009 +0000
+++ b/v4l/Makefile	Wed Apr 22 15:18:13 2009 +0200
@@ -39,7 +39,7 @@
 #################################################
 # default compilation rule
 
-default:: config-compat.h Makefile.media links oss
+default:: config-compat.h Makefile.media links oss firmware
 	@echo Kernel build directory is $(OUTDIR)
 	$(MAKE) -C $(OUTDIR) SUBDIRS=$(PWD) $(MYCFLAGS) modules
 	./scripts/rmmod.pl check
diff -r 2a6d95947fa1 -r bf39a52e7f49 v4l/firmware/Makefile
--- a/v4l/firmware/Makefile	Sun Apr 19 20:21:03 2009 +0000
+++ b/v4l/firmware/Makefile	Wed Apr 22 15:18:13 2009 +0200
@@ -7,6 +7,7 @@
 default: $(TARGETS)
 
 clean:
+	-rm -f ihex2fw
 	-rm -f $(TARGETS)
 
 distclean: clean

