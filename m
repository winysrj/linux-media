Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:34612 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751430Ab1GYSeB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 14:34:01 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: [Patch] media_build: Add support for kernel 3.x, remove support for kernel 2.4
Date: Mon, 25 Jul 2011 20:30:58 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107252030.58897@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>

diff -r 7830053e4245 v4l/Makefile
--- a/v4l/Makefile	Mon Jul 18 22:25:39 2011 +0200
+++ b/v4l/Makefile	Mon Jul 25 20:05:51 2011 +0200
@@ -135,21 +135,11 @@
 EXTRA_CFLAGS += -include $(obj)/compat.h
 
 #################################################
-# Kernel 2.4/2.6 specific rules
+# Kernel 2.6/3.x specific rules
 
 ifneq ($(KERNELRELEASE),)
-
-ifeq ($(VERSION).$(PATCHLEVEL),2.6)
  export-objs	:=
  list-multi	:=
-else
-include $(obj)/Makefile.kern24
-
- multi-m	:= $(filter $(list-multi), $(obj-m))
- int-m		:= $(sort $(foreach m, $(multi-m), $($(basename $(m))-objs)))
- export-objs	:= $(filter $(int-m) $(obj-m),$(export-objs))
-endif
-
 endif
 
 #################################################
@@ -171,19 +161,15 @@
 HOSTCC:=$(CC)
 CC += -I$(obj)
 
-ifeq ($(VERSION).$(PATCHLEVEL),2.6)
- CPPFLAGS := -I$(SUBDIRS)/../linux/include $(CPPFLAGS) -I$(SUBDIRS)/
+CPPFLAGS := -I$(SUBDIRS)/../linux/include $(CPPFLAGS) -I$(SUBDIRS)/
 
- # Needed for kernel 2.6.24 or up
- KBUILD_CPPFLAGS := -I$(SUBDIRS)/../linux/include $(KBUILD_CPPFLAGS) -I$(SUBDIRS)/
+# Needed for kernel 2.6.24 or up
+KBUILD_CPPFLAGS := -I$(SUBDIRS)/../linux/include $(KBUILD_CPPFLAGS) -I$(SUBDIRS)/
 
- # Needed for kernel 2.6.29 or up
- LINUXINCLUDE    := -I$(SUBDIRS)/../linux/include $(LINUXINCLUDE) -I$(SUBDIRS)/
+# Needed for kernel 2.6.29 or up
+LINUXINCLUDE    := -I$(SUBDIRS)/../linux/include $(LINUXINCLUDE) -I$(SUBDIRS)/
 
- MYCFLAGS :=
-else
- MYCFLAGS := CFLAGS="-I../linux/include -D__KERNEL__ -I$(KDIR)/include -DEXPORT_SYMTAB"
-endif
+MYCFLAGS :=
 
 
 #################################################

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
