Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:55485 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2BNQYp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 11:24:45 -0500
Message-Id: <E1RxKtt-00011X-Ik@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 08 Feb 2012 13:46:54 +0100
Subject: [git:v4l-dvb/for_v3.4] [media] davinci: vpif: remove machine specific header file includes
To: linuxtv-commits@linuxtv.org
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] davinci: vpif: remove machine specific header file includes
Author:  Manjunath Hadli <manjunath.hadli@ti.com>
Date:    Fri Dec 23 03:28:44 2011 -0300

remove unnecessary inclusion of machine specific header files mach/dm646x.h,
mach/hardware.h from vpif.h  and aslo mach/dm646x.h from vpif_display.c
driver which comes in the way of platform code consolidation.
Add linux/i2c.h header file in vpif_types.h which is required for
building.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LMML <linux-media@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/davinci/vpif.h         |    2 --
 drivers/media/video/davinci/vpif_display.c |    2 --
 include/media/davinci/vpif_types.h         |    2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=db38951cce88eae36909143291545a59db4efa59

diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 25036cb..8bcac65 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -18,8 +18,6 @@
 
 #include <linux/io.h>
 #include <linux/videodev2.h>
-#include <mach/hardware.h>
-#include <mach/dm646x.h>
 #include <media/davinci/vpif_types.h>
 
 /* Maximum channel allowed */
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 286f029..7fa34b4 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -39,8 +39,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
 
-#include <mach/dm646x.h>
-
 #include "vpif_display.h"
 #include "vpif.h"
 
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 9929b05..bd8217c 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -17,6 +17,8 @@
 #ifndef _VPIF_TYPES_H
 #define _VPIF_TYPES_H
 
+#include <linux/i2c.h>
+
 #define VPIF_CAPTURE_MAX_CHANNELS	2
 
 enum vpif_if_type {
