Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp210.webpack.hosteurope.de ([80.237.132.217]:44954 "EHLO
	wp210.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932491AbbFFURx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:17:53 -0400
From: =?UTF-8?q?Jan=20Kl=C3=B6tzke?= <jan@kloetzke.net>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: abraham.manu@gmail.com
Subject: [PATCH 1/5] [media] rc/keymaps: add RC keytable for TechniSat TS35
Date: Sat,  6 Jun 2015 21:58:09 +0200
Message-Id: <1433620693-6235-2-git-send-email-jan@kloetzke.net>
In-Reply-To: <1433620693-6235-1-git-send-email-jan@kloetzke.net>
References: <1433620693-6235-1-git-send-email-jan@kloetzke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TS35 remote is distributed with TechniSat CableStar HD2 cards (mantis
chipset). The exact protocol type is unknown, making this rc map probably only
usable by mantis cards.

Signed-off-by: Jan Klötzke <jan@kloetzke.net>
---
 drivers/media/rc/keymaps/Makefile            |  1 +
 drivers/media/rc/keymaps/rc-technisat-ts35.c | 76 ++++++++++++++++++++++++++++
 include/media/rc-map.h                       |  1 +
 3 files changed, 78 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-technisat-ts35.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index abf6079..07c4b98 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -84,6 +84,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-snapstream-firefly.o \
 			rc-streamzap.o \
 			rc-tbs-nec.o \
+			rc-technisat-ts35.o \
 			rc-technisat-usb2.o \
 			rc-terratec-cinergy-xs.o \
 			rc-terratec-slim.o \
diff --git a/drivers/media/rc/keymaps/rc-technisat-ts35.c b/drivers/media/rc/keymaps/rc-technisat-ts35.c
new file mode 100644
index 0000000..3328cbe
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-technisat-ts35.c
@@ -0,0 +1,76 @@
+/* rc-technisat-ts35.c - Keytable for TechniSat TS35 remote
+ *
+ * Copyright (c) 2013 by Jan Klötzke <jan@kloetzke.net>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table technisat_ts35[] = {
+	{0x32, KEY_MUTE},
+	{0x07, KEY_MEDIA},
+	{0x1c, KEY_AB},
+	{0x33, KEY_POWER},
+
+	{0x3e, KEY_1},
+	{0x3d, KEY_2},
+	{0x3c, KEY_3},
+	{0x3b, KEY_4},
+	{0x3a, KEY_5},
+	{0x39, KEY_6},
+	{0x38, KEY_7},
+	{0x37, KEY_8},
+	{0x36, KEY_9},
+	{0x3f, KEY_0},
+	{0x35, KEY_DIGITS},
+	{0x2c, KEY_TV},
+
+	{0x20, KEY_INFO},
+	{0x2d, KEY_MENU},
+	{0x1f, KEY_UP},
+	{0x1e, KEY_DOWN},
+	{0x2e, KEY_LEFT},
+	{0x2f, KEY_RIGHT},
+	{0x28, KEY_OK},
+	{0x10, KEY_EPG},
+	{0x1d, KEY_BACK},
+
+	{0x14, KEY_RED},
+	{0x13, KEY_GREEN},
+	{0x12, KEY_YELLOW},
+	{0x11, KEY_BLUE},
+
+	{0x09, KEY_SELECT},
+	{0x03, KEY_TEXT},
+	{0x16, KEY_STOP},
+	{0x30, KEY_HELP},
+};
+
+static struct rc_map_list technisat_ts35_map = {
+	.map = {
+		.scan    = technisat_ts35,
+		.size    = ARRAY_SIZE(technisat_ts35),
+		.rc_type = RC_TYPE_UNKNOWN,
+		.name    = RC_MAP_TECHNISAT_TS35,
+	}
+};
+
+static int __init init_rc_map(void)
+{
+	return rc_map_register(&technisat_ts35_map);
+}
+
+static void __exit exit_rc_map(void)
+{
+	rc_map_unregister(&technisat_ts35_map);
+}
+
+module_init(init_rc_map)
+module_exit(exit_rc_map)
+
+MODULE_LICENSE("GPL");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e7a1514..aa56264 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -194,6 +194,7 @@ void rc_map_init(void);
 #define RC_MAP_SNAPSTREAM_FIREFLY        "rc-snapstream-firefly"
 #define RC_MAP_STREAMZAP                 "rc-streamzap"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
+#define RC_MAP_TECHNISAT_TS35            "rc-technisat-ts35"
 #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
 #define RC_MAP_TERRATEC_SLIM             "rc-terratec-slim"
-- 
2.1.4

