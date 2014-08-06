Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36195 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaHFEiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 00:38:54 -0400
Received: by mail-pa0-f54.google.com with SMTP id fa1so2717495pad.27
        for <linux-media@vger.kernel.org>; Tue, 05 Aug 2014 21:38:53 -0700 (PDT)
Date: Wed, 6 Aug 2014 12:38:48 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] support for DVBSky dvb-s2 usb: add dvbsky rc keymaps.
Message-ID: <201408061238440937759@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add dvbsky rc keymaps.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/rc/keymaps/Makefile    |  1 +
 drivers/media/rc/keymaps/rc-dvbsky.c | 78 ++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 0b8c549..abf6079 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-dm1105-nec.o \
 			rc-dntv-live-dvb-t.o \
 			rc-dntv-live-dvbt-pro.o \
+			rc-dvbsky.o \
 			rc-em-terratec.o \
 			rc-encore-enltv2.o \
 			rc-encore-enltv.o \
diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
new file mode 100644
index 0000000..c5115a1
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-dvbsky.c
@@ -0,0 +1,78 @@
+/* rc-dvbsky.c - Keytable for DVBSky Remote Controllers
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ *
+ * Copyright (c) 2010-2012 by Nibble Max <nibble.max@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+/*
+ * This table contains the complete RC5 code, instead of just the data part
+ */
+
+static struct rc_map_table rc5_dvbsky[] = {
+	{ 0x0000, KEY_0 },
+	{ 0x0001, KEY_1 },
+	{ 0x0002, KEY_2 },
+	{ 0x0003, KEY_3 },
+	{ 0x0004, KEY_4 },
+	{ 0x0005, KEY_5 },
+	{ 0x0006, KEY_6 },
+	{ 0x0007, KEY_7 },
+	{ 0x0008, KEY_8 },
+	{ 0x0009, KEY_9 },
+	{ 0x000a, KEY_MUTE },
+	{ 0x000d, KEY_OK },
+	{ 0x000b, KEY_STOP },
+	{ 0x000c, KEY_EXIT },
+	{ 0x000e, KEY_CAMERA }, /*Snap shot*/
+	{ 0x000f, KEY_SUBTITLE }, /*PIP*/
+	{ 0x0010, KEY_VOLUMEUP },
+	{ 0x0011, KEY_VOLUMEDOWN },
+	{ 0x0012, KEY_FAVORITES },
+	{ 0x0013, KEY_LIST }, /*Info*/
+	{ 0x0016, KEY_PAUSE },
+	{ 0x0017, KEY_PLAY },
+	{ 0x001f, KEY_RECORD },
+	{ 0x0020, KEY_CHANNELDOWN },
+	{ 0x0021, KEY_CHANNELUP },
+	{ 0x0025, KEY_POWER2 },
+	{ 0x0026, KEY_REWIND },
+	{ 0x0027, KEY_FASTFORWARD },
+	{ 0x0029, KEY_LAST },
+	{ 0x002b, KEY_MENU },
+	{ 0x002c, KEY_EPG },
+	{ 0x002d, KEY_ZOOM },
+};
+
+static struct rc_map_list rc5_dvbsky_map = {
+	.map = {
+		.scan    = rc5_dvbsky,
+		.size    = ARRAY_SIZE(rc5_dvbsky),
+		.rc_type = RC_TYPE_RC5,
+		.name    = RC_MAP_DVBSKY,
+	}
+};
+
+static int __init init_rc_map_rc5_dvbsky(void)
+{
+	return rc_map_register(&rc5_dvbsky_map);
+}
+
+static void __exit exit_rc_map_rc5_dvbsky(void)
+{
+	rc_map_unregister(&rc5_dvbsky_map);
+}
+
+module_init(init_rc_map_rc5_dvbsky)
+module_exit(exit_rc_map_rc5_dvbsky)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nibble Max <nibble.max@gmail.com>");
  

