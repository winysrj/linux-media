Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1JaQZy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:54 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444413eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:53 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 12/17] staging: as102: Remove non-linux headers inclusion
Date: Mon, 31 Oct 2011 17:24:50 +0100
Message-Id: <1320078295-3379-13-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Piotr Chmura <chmooreck@poczta.onet.pl>

Remove inclusion of Windows and other not linux related headers.

[snjw23@gmail.com: edited changelog, folded long line in Makefile]
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/Makefile           |    5 +++--
 drivers/staging/media/as102/as10x_cmd.c        |   22 ----------------------
 drivers/staging/media/as102/as10x_cmd_cfg.c    |   22 ----------------------
 drivers/staging/media/as102/as10x_cmd_stream.c |   22 +---------------------
 4 files changed, 4 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/media/as102/Makefile b/drivers/staging/media/as102/Makefile
index c2334c6..e7dbb6f 100644
--- a/drivers/staging/media/as102/Makefile
+++ b/drivers/staging/media/as102/Makefile
@@ -1,5 +1,6 @@
-dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o as102_fe.o as102_usb_drv.o as10x_cmd_cfg.o
+dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
+		as102_fe.o as102_usb_drv.o as10x_cmd_cfg.o
 
 obj-$(CONFIG_DVB_AS102) += dvb-as102.o
 
-EXTRA_CFLAGS += -DLINUX -DCONFIG_AS102_USB -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -DCONFIG_AS102_USB -Idrivers/media/dvb/dvb-core
diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index 222e703..77aae39 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -18,30 +18,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#if defined(LINUX) && defined(__KERNEL__) /* linux kernel implementation */
 #include <linux/kernel.h>
 #include "as102_drv.h"
-#elif defined(WIN32)
-   #if defined(__BUILDMACHINE__) && (__BUILDMACHINE__ == WinDDK)
-      /* win32 ddk implementation */
-      #include "wdm.h"
-      #include "Device.h"
-      #include "endian_mgmt.h" /* FIXME */
-   #else /* win32 sdk implementation */
-      #include <windows.h>
-      #include "types.h"
-      #include "util.h"
-      #include "as10x_handle.h"
-      #include "endian_mgmt.h"
-   #endif
-#else /* all other cases */
-   #include <string.h>
-   #include "types.h"
-   #include "util.h"
-   #include "as10x_handle.h"
-   #include "endian_mgmt.h" /* FIXME */
-#endif /* __KERNEL__ */
-
 #include "as10x_types.h"
 #include "as10x_cmd.h"
 
diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
index 0635797..dca2cbf 100644
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ b/drivers/staging/media/as102/as10x_cmd_cfg.c
@@ -17,30 +17,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#if defined(LINUX) && defined(__KERNEL__) /* linux kernel implementation */
 #include <linux/kernel.h>
 #include "as102_drv.h"
-#elif defined(WIN32)
-   #if defined(__BUILDMACHINE__) && (__BUILDMACHINE__ == WinDDK)
-      /* win32 ddk implementation */
-      #include "wdm.h"
-      #include "Device.h"
-      #include "endian_mgmt.h" /* FIXME */
-   #else /* win32 sdk implementation */
-      #include <windows.h>
-      #include "types.h"
-      #include "util.h"
-      #include "as10x_handle.h"
-      #include "endian_mgmt.h"
-   #endif
-#else /* all other cases */
-   #include <string.h>
-   #include "types.h"
-   #include "util.h"
-   #include "as10x_handle.h"
-   #include "endian_mgmt.h" /* FIXME */
-#endif /* __KERNEL__ */
-
 #include "as10x_types.h"
 #include "as10x_cmd.h"
 
diff --git a/drivers/staging/media/as102/as10x_cmd_stream.c b/drivers/staging/media/as102/as10x_cmd_stream.c
index b5e6254..e8c668c 100644
--- a/drivers/staging/media/as102/as10x_cmd_stream.c
+++ b/drivers/staging/media/as102/as10x_cmd_stream.c
@@ -16,29 +16,9 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-#if defined(LINUX) && defined(__KERNEL__) /* linux kernel implementation */
+
 #include <linux/kernel.h>
 #include "as102_drv.h"
-#elif defined(WIN32)
-    #if defined(DDK) /* win32 ddk implementation */
-	#include "wdm.h"
-	#include "Device.h"
-	#include "endian_mgmt.h" /* FIXME */
-    #else /* win32 sdk implementation */
-	#include <windows.h>
-	#include "types.h"
-	#include "util.h"
-	#include "as10x_handle.h"
-	#include "endian_mgmt.h"
-    #endif
-#else /* all other cases */
-    #include <string.h>
-    #include "types.h"
-    #include "util.h"
-    #include "as10x_handle.h"
-    #include "endian_mgmt.h" /* FIXME */
-#endif /* __KERNEL__ */
-
 #include "as10x_cmd.h"
 
 
-- 
1.7.4.1

