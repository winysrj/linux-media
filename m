Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2E1NOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 09:14:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: stefanr@s5r6.in-berlin.de
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] Add a keymap for FireDTV board
Date: Mon, 28 May 2012 10:14:34 -0300
Message-Id: <1338210875-4620-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Table imported from the FireDTV driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/keymaps/Makefile     |    1 +
 drivers/media/rc/keymaps/rc-firedtv.c |  132 +++++++++++++++++++++++++++++++++
 include/media/rc-map.h                |    1 +
 3 files changed, 134 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-firedtv.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index ab84d66..6c32562 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-encore-enltv-fm53.o \
 			rc-evga-indtube.o \
 			rc-eztv.o \
+			rc-firedtv.o \
 			rc-flydvb.o \
 			rc-flyvideo.o \
 			rc-fusionhdtv-mce.o \
diff --git a/drivers/media/rc/keymaps/rc-firedtv.c b/drivers/media/rc/keymaps/rc-firedtv.c
new file mode 100644
index 0000000..dfead50
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-firedtv.c
@@ -0,0 +1,132 @@
+/* rc-firedtv.h - Keytable for FireDTV Remote Controller
+ *
+ * Imported from firedtv-rc.c driver
+ *
+ * Copyright (c) 2012 by Mauro Carvalho Chehab <mchehab@redhat.com>
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
+static struct rc_map_table firedtv[] = {
+	/* Older keycodes, geared towards MythTV */
+	{0x4501, KEY_ESC},
+	{0x4502, KEY_F9},
+	{0x4503, KEY_1},
+	{0x4504, KEY_2},
+	{0x4505, KEY_3},
+	{0x4506, KEY_4},
+	{0x4507, KEY_5},
+	{0x4508, KEY_6},
+	{0x4509, KEY_7},
+	{0x450a, KEY_8},
+	{0x450b, KEY_9},
+	{0x450c, KEY_I},
+	{0x450d, KEY_0},
+	{0x450e, KEY_ENTER},
+	{0x450f, KEY_RED},
+	{0x4510, KEY_UP},
+	{0x4511, KEY_GREEN},
+	{0x4512, KEY_F10},
+	{0x4513, KEY_SPACE},
+	{0x4514, KEY_F11},
+	{0x4515, KEY_YELLOW},
+	{0x4516, KEY_DOWN},
+	{0x4517, KEY_BLUE},
+	{0x4518, KEY_Z},
+	{0x4519, KEY_P},
+	{0x451a, KEY_PAGEDOWN},
+	{0x451b, KEY_LEFT},
+	{0x451c, KEY_W},
+	{0x451d, KEY_RIGHT},
+	{0x451e, KEY_P},
+	{0x451f, KEY_M},
+	{0x4540, KEY_R},
+	{0x4541, KEY_V},
+	{0x4542, KEY_C},
+
+	/* For a remote as sold in 2008 */
+	{0x0300, KEY_POWER},
+	{0x0301, KEY_SLEEP},
+	{0x0302, KEY_STOP},
+	{0x0303, KEY_OK},
+	{0x0304, KEY_RIGHT},
+	{0x0305, KEY_1},
+	{0x0306, KEY_2},
+	{0x0307, KEY_3},
+	{0x0308, KEY_LEFT},
+	{0x0309, KEY_4},
+	{0x030a, KEY_5},
+	{0x030b, KEY_6},
+	{0x030c, KEY_UP},
+	{0x030d, KEY_7},
+	{0x030e, KEY_8},
+	{0x030f, KEY_9},
+	{0x0310, KEY_DOWN},
+	{0x0311, KEY_TITLE},	/* "OSD" - fixme */
+	{0x0312, KEY_0},
+	{0x0313, KEY_F20},	/* "16:9" - fixme */
+	{0x0314, KEY_SCREEN},	/* "FULL" - fixme */
+	{0x0315, KEY_MUTE},
+	{0x0316, KEY_SUBTITLE},
+	{0x0317, KEY_RECORD},
+	{0x0318, KEY_TEXT},
+	{0x0319, KEY_AUDIO},
+	{0x031a, KEY_RED},
+	{0x031b, KEY_PREVIOUS},
+	{0x031c, KEY_REWIND},
+	{0x031d, KEY_PLAYPAUSE},
+	{0x031e, KEY_NEXT},
+	{0x031f, KEY_VOLUMEUP},
+	{0x0340, KEY_CHANNELUP},
+	{0x0341, KEY_F21},	/* "4:3" - fixme */
+	{0x0342, KEY_TV},
+	{0x0343, KEY_DVD},
+	{0x0344, KEY_VCR},
+	{0x0345, KEY_AUX},
+	{0x0346, KEY_GREEN},
+	{0x0347, KEY_YELLOW},
+	{0x0348, KEY_BLUE},
+	{0x0349, KEY_CHANNEL},	/* "CH.LIST" */
+	{0x034a, KEY_VENDOR},	/* "CI" - fixme */
+	{0x034b, KEY_VOLUMEDOWN},
+	{0x034c, KEY_CHANNELDOWN},
+	{0x034d, KEY_LAST},
+	{0x034e, KEY_INFO},
+	{0x034f, KEY_FORWARD},
+	{0x0350, KEY_LIST},
+	{0x0351, KEY_FAVORITES},
+	{0x0352, KEY_MENU},
+	{0x0353, KEY_EPG},
+	{0x0354, KEY_EXIT},
+};
+
+static struct rc_map_list firedtv_map = {
+	.map = {
+		.scan    = firedtv,
+		.size    = ARRAY_SIZE(firedtv),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_FIREDTV,
+	}
+};
+
+static int __init init_rc_map_firedtv(void)
+{
+	return rc_map_register(&firedtv_map);
+}
+
+static void __exit exit_rc_map_firedtv(void)
+{
+	rc_map_unregister(&firedtv_map);
+}
+
+module_init(init_rc_map_firedtv)
+module_exit(exit_rc_map_firedtv)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index cfd5163..adc6f28 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -158,6 +158,7 @@ void rc_map_init(void);
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
+#define RC_MAP_FIREDTV			 "rc-firedtv"
 
 /*
  * Please, do not just append newer Remote Controller names at the end.
-- 
1.7.8

