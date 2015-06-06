Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp210.webpack.hosteurope.de ([80.237.132.217]:44936 "EHLO
	wp210.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932211AbbFFURr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:17:47 -0400
From: =?UTF-8?q?Jan=20Kl=C3=B6tzke?= <jan@kloetzke.net>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: abraham.manu@gmail.com
Subject: [PATCH 4/5] [media] rc/keymaps: add keytable for Twinhan DTV CAB CI
Date: Sat,  6 Jun 2015 21:58:12 +0200
Message-Id: <1433620693-6235-5-git-send-email-jan@kloetzke.net>
In-Reply-To: <1433620693-6235-1-git-send-email-jan@kloetzke.net>
References: <1433620693-6235-1-git-send-email-jan@kloetzke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RC map was taken from Christoph Pinkl's patch
(http://patchwork.linuxtv.org/patch/7217/). It is used solely by the respective
mantis based card because the encoding is not known.

Signed-off-by: Jan Klötzke <jan@kloetzke.net>
---
 drivers/media/rc/keymaps/Makefile                |  1 +
 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c | 98 ++++++++++++++++++++++++
 include/media/rc-map.h                           |  1 +
 3 files changed, 100 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index f0c02c8..fbbd3bb 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-total-media-in-hand-02.o \
 			rc-trekstor.o \
 			rc-tt-1500.o \
+			rc-twinhan-dtv-cab-ci.o \
 			rc-twinhan1027.o \
 			rc-videomate-m1f.o \
 			rc-videomate-s350.o \
diff --git a/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
new file mode 100644
index 0000000..202500c
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
@@ -0,0 +1,98 @@
+/* keytable for Twinhan DTV CAB CI Remote Controller
+ *
+ * Copyright (c) 2010 by Igor M. Liplianin <liplianin@me.by>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table twinhan_dtv_cab_ci[] = {
+	{ 0x29, KEY_POWER},
+	{ 0x28, KEY_FAVORITES},
+	{ 0x30, KEY_TEXT},
+	{ 0x17, KEY_INFO},              /* Preview */
+	{ 0x23, KEY_EPG},
+	{ 0x3b, KEY_F22},               /* Record List */
+
+	{ 0x3c, KEY_1},
+	{ 0x3e, KEY_2},
+	{ 0x39, KEY_3},
+	{ 0x36, KEY_4},
+	{ 0x22, KEY_5},
+	{ 0x20, KEY_6},
+	{ 0x32, KEY_7},
+	{ 0x26, KEY_8},
+	{ 0x24, KEY_9},
+	{ 0x2a, KEY_0},
+
+	{ 0x33, KEY_CANCEL},
+	{ 0x2c, KEY_BACK},
+	{ 0x15, KEY_CLEAR},
+	{ 0x3f, KEY_TAB},
+	{ 0x10, KEY_ENTER},
+	{ 0x14, KEY_UP},
+	{ 0x0d, KEY_RIGHT},
+	{ 0x0e, KEY_DOWN},
+	{ 0x11, KEY_LEFT},
+
+	{ 0x21, KEY_VOLUMEUP},
+	{ 0x35, KEY_VOLUMEDOWN},
+	{ 0x3d, KEY_CHANNELDOWN},
+	{ 0x3a, KEY_CHANNELUP},
+	{ 0x2e, KEY_RECORD},
+	{ 0x2b, KEY_PLAY},
+	{ 0x13, KEY_PAUSE},
+	{ 0x25, KEY_STOP},
+
+	{ 0x1f, KEY_REWIND},
+	{ 0x2d, KEY_FASTFORWARD},
+	{ 0x1e, KEY_PREVIOUS},          /* Replay |< */
+	{ 0x1d, KEY_NEXT},              /* Skip   >| */
+
+	{ 0x0b, KEY_CAMERA},            /* Capture */
+	{ 0x0f, KEY_LANGUAGE},          /* SAP */
+	{ 0x18, KEY_MODE},              /* PIP */
+	{ 0x12, KEY_ZOOM},              /* Full screen */
+	{ 0x1c, KEY_SUBTITLE},
+	{ 0x2f, KEY_MUTE},
+	{ 0x16, KEY_F20},               /* L/R */
+	{ 0x38, KEY_F21},               /* Hibernate */
+
+	{ 0x37, KEY_SWITCHVIDEOMODE},   /* A/V */
+	{ 0x31, KEY_AGAIN},             /* Recall */
+	{ 0x1a, KEY_KPPLUS},            /* Zoom+ */
+	{ 0x19, KEY_KPMINUS},           /* Zoom- */
+	{ 0x27, KEY_RED},
+	{ 0x0C, KEY_GREEN},
+	{ 0x01, KEY_YELLOW},
+	{ 0x00, KEY_BLUE},
+};
+
+static struct rc_map_list twinhan_dtv_cab_ci_map = {
+	.map = {
+		.scan    = twinhan_dtv_cab_ci,
+		.size    = ARRAY_SIZE(twinhan_dtv_cab_ci),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_TWINHAN_DTV_CAB_CI,
+	}
+};
+
+static int __init init_rc_map_twinhan_dtv_cab_ci(void)
+{
+	return rc_map_register(&twinhan_dtv_cab_ci_map);
+}
+
+static void __exit exit_rc_map_twinhan_dtv_cab_ci(void)
+{
+	rc_map_unregister(&twinhan_dtv_cab_ci_map);
+}
+
+module_init(init_rc_map_twinhan_dtv_cab_ci);
+module_exit(exit_rc_map_twinhan_dtv_cab_ci);
+
+MODULE_LICENSE("GPL");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 50ed644..27763d5 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -207,6 +207,7 @@ void rc_map_init(void);
 #define RC_MAP_TOTAL_MEDIA_IN_HAND_02    "rc-total-media-in-hand-02"
 #define RC_MAP_TREKSTOR                  "rc-trekstor"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
+#define RC_MAP_TWINHAN_DTV_CAB_CI        "rc-twinhan-dtv-cab-ci"
 #define RC_MAP_TWINHAN_VP1027_DVBS       "rc-twinhan1027"
 #define RC_MAP_VIDEOMATE_K100            "rc-videomate-k100"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
-- 
2.1.4

