Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34116 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbcDXVKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id n3so20027442wmn.1
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:14 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Subject: [RFC PATCH 01/24] V4L fixes
Date: Mon, 25 Apr 2016 00:08:01 +0300
Message-Id: <1461532104-24032-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>

Squashed from the following upstream commits:

V4L: Create control class for sensor mode
V4L: add ad5820 focus specific custom controls
V4L: add V4L2_CID_TEST_PATTERN
V4L: Add V4L2_CID_MODE_OPSYSCLOCK for reading output system clock

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 include/uapi/linux/v4l2-controls.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index b6a357a..23011cc 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -62,6 +62,7 @@
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
 #define V4L2_CTRL_CLASS_RF_TUNER	0x00a20000	/* RF tuner controls */
 #define V4L2_CTRL_CLASS_DETECT		0x00a30000	/* Detection controls */
+#define V4L2_CTRL_CLASS_MODE		0x00a40000	/* Sensor mode information */
 
 /* User-class control IDs */
 
@@ -974,4 +975,20 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+/* SMIA-type sensor information */
+#define V4L2_CID_MODE_CLASS_BASE		(V4L2_CTRL_CLASS_MODE | 0x900)
+#define V4L2_CID_MODE_CLASS			(V4L2_CTRL_CLASS_MODE | 1)
+#define V4L2_CID_MODE_FRAME_WIDTH		(V4L2_CID_MODE_CLASS_BASE+1)
+#define V4L2_CID_MODE_FRAME_HEIGHT		(V4L2_CID_MODE_CLASS_BASE+2)
+#define V4L2_CID_MODE_VISIBLE_WIDTH		(V4L2_CID_MODE_CLASS_BASE+3)
+#define V4L2_CID_MODE_VISIBLE_HEIGHT		(V4L2_CID_MODE_CLASS_BASE+4)
+#define V4L2_CID_MODE_PIXELCLOCK		(V4L2_CID_MODE_CLASS_BASE+5)
+#define V4L2_CID_MODE_SENSITIVITY		(V4L2_CID_MODE_CLASS_BASE+6)
+#define V4L2_CID_MODE_OPSYSCLOCK		(V4L2_CID_MODE_CLASS_BASE+7)
+
+/* Control IDs specific to the AD5820 driver as defined by V4L2 */
+#define V4L2_CID_FOCUS_AD5820_BASE 		(V4L2_CTRL_CLASS_CAMERA | 0x10af)
+#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_FOCUS_AD5820_BASE+0)
+#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_FOCUS_AD5820_BASE+1)
+
 #endif
-- 
1.9.1

