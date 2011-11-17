Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48189 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755101Ab1KQCS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 21:18:59 -0500
Message-ID: <4EC46E9F.3060508@xenotime.net>
Date: Wed, 16 Nov 2011 18:17:03 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: [PATCH] media/staging: fix allyesconfig build error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix x86 allyesconfig builds.  Builds fail due to a non-static variable
named 'debug' in drivers/staging/media/as102/.

arch/x86/built-in.o:arch/x86/kernel/entry_32.S:1296: first defined here
ld: Warning: size of symbol `debug' changed from 90 in arch/x86/built-in.o to 4 in drivers/built-in.o

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
---
 drivers/staging/media/as102/as102_drv.c |    4 ++--
 drivers/staging/media/as102/as102_drv.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

Thou shalt have no non-static identifiers that are named 'debug'.


--- lnx-32-rc2.orig/drivers/staging/media/as102/as102_drv.c
+++ lnx-32-rc2/drivers/staging/media/as102/as102_drv.c
@@ -32,8 +32,8 @@
 #include "as102_fw.h"
 #include "dvbdev.h"
 
-int debug;
-module_param_named(debug, debug, int, 0644);
+int as102_debug;
+module_param_named(debug, as102_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default: off)");
 
 int dual_tuner;
--- lnx-32-rc2.orig/drivers/staging/media/as102/as102_drv.h
+++ lnx-32-rc2/drivers/staging/media/as102/as102_drv.h
@@ -37,7 +37,8 @@ extern struct spi_driver as102_spi_drive
 #define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
 #define DRIVER_NAME "as10x_usb"
 
-extern int debug;
+extern int as102_debug;
+#define debug	as102_debug
 
 #define dprintk(debug, args...) \
 	do { if (debug) {	\
