Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:38374 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZK2UGK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 15:06:10 -0500
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, alan@redhat.com,
	roel.kluin@gmail.com, linux-media@vger.kernel.org,
	Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] cpia2: use __stringify macro.
Date: Sun, 29 Nov 2009 15:05:58 -0500
Message-Id: <1259525158-16517-1-git-send-email-tfransosi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/media/video/cpia2/cpia2_v4l.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 0b4a8f3..6c5fcd8 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -38,17 +38,12 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/videodev.h>
+#include <linux/stringify.h>
 #include <media/v4l2-ioctl.h>
 
 #include "cpia2.h"
 #include "cpia2dev.h"
 
-
-//#define _CPIA2_DEBUG_
-
-#define MAKE_STRING_1(x)	#x
-#define MAKE_STRING(x)	MAKE_STRING_1(x)
-
 static int video_nr = -1;
 module_param(video_nr, int, 0);
 MODULE_PARM_DESC(video_nr,"video device to register (0=/dev/video0, etc)");
@@ -60,26 +55,26 @@ MODULE_PARM_DESC(buffer_size, "Size for each frame buffer in bytes (default 68k)
 static int num_buffers = 3;
 module_param(num_buffers, int, 0);
 MODULE_PARM_DESC(num_buffers, "Number of frame buffers (1-"
-		 MAKE_STRING(VIDEO_MAX_FRAME) ", default 3)");
+		 __stringify(VIDEO_MAX_FRAME) ", default 3)");
 
 static int alternate = DEFAULT_ALT;
 module_param(alternate, int, 0);
-MODULE_PARM_DESC(alternate, "USB Alternate (" MAKE_STRING(USBIF_ISO_1) "-"
-		 MAKE_STRING(USBIF_ISO_6) ", default "
-		 MAKE_STRING(DEFAULT_ALT) ")");
+MODULE_PARM_DESC(alternate, "USB Alternate (" __stringify(USBIF_ISO_1) "-"
+		 __stringify(USBIF_ISO_6) ", default "
+		 __stringify(DEFAULT_ALT) ")");
 
 static int flicker_freq = 60;
 module_param(flicker_freq, int, 0);
-MODULE_PARM_DESC(flicker_freq, "Flicker frequency (" MAKE_STRING(50) "or"
-		 MAKE_STRING(60) ", default "
-		 MAKE_STRING(60) ")");
+MODULE_PARM_DESC(flicker_freq, "Flicker frequency (" __stringify(50) "or"
+		 __stringify(60) ", default "
+		 __stringify(60) ")");
 
 static int flicker_mode = NEVER_FLICKER;
 module_param(flicker_mode, int, 0);
 MODULE_PARM_DESC(flicker_mode,
-		 "Flicker supression (" MAKE_STRING(NEVER_FLICKER) "or"
-		 MAKE_STRING(ANTI_FLICKER_ON) ", default "
-		 MAKE_STRING(NEVER_FLICKER) ")");
+		 "Flicker supression (" __stringify(NEVER_FLICKER) "or"
+		 __stringify(ANTI_FLICKER_ON) ", default "
+		 __stringify(NEVER_FLICKER) ")");
 
 MODULE_AUTHOR("Steve Miller (STMicroelectronics) <steve.miller@st.com>");
 MODULE_DESCRIPTION("V4L-driver for STMicroelectronics CPiA2 based cameras");
-- 
1.6.6.rc0.61.g41d5b

