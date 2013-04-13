Return-path: <linux-media-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.49.41]:50068 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3DMPJM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 11:09:12 -0400
From: Jakob Haufe <sur5r@sur5r.net>
To: linux-media@vger.kernel.org
Cc: Jakob Haufe <sur5r@sur5r.net>
Subject: [PATCH 1/2] rc: Add rc-delock-61959
Date: Sat, 13 Apr 2013 17:03:36 +0200
Message-Id: <1365865417-22853-2-git-send-email-sur5r@sur5r.net>
In-Reply-To: <1365865417-22853-1-git-send-email-sur5r@sur5r.net>
References: <1365865417-22853-1-git-send-email-sur5r@sur5r.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the keytable for the remote that comes with the Delock 61959.

NEC protocol with address 0x866b.

Signed-off-by: Jakob Haufe <sur5r@sur5r.net>
---
 drivers/media/rc/keymaps/Makefile          |    1 +
 drivers/media/rc/keymaps/rc-delock-61959.c |   83 ++++++++++++++++++++++++++++
 include/media/rc-map.h                     |    1 +
 3 files changed, 85 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-delock-61959.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 7786619..e2b7ddb 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-budget-ci-old.o \
 			rc-cinergy-1400.o \
 			rc-cinergy.o \
+			rc-delock-61959.o \
 			rc-dib0700-nec.o \
 			rc-dib0700-rc5.o \
 			rc-digitalnow-tinytwin.o \
diff --git a/drivers/media/rc/keymaps/rc-delock-61959.c b/drivers/media/rc/keymaps/rc-delock-61959.c
new file mode 100644
index 0000000..01bed86
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-delock-61959.c
@@ -0,0 +1,83 @@
+/* rc-delock-61959.c - Keytable for Delock
+ *
+ * Copyright (c) 2013 by Jakob Haufe <sur5r@sur5r.net>
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
+/*
+ * Keytable for remote provided with Delock 61959
+ */
+static struct rc_map_table delock_61959[] = {
+	{ 0x866b16, KEY_POWER2 },	/* Power */
+	{ 0x866b0c, KEY_POWER },	/* Shut Down */
+
+	{ 0x866b00, KEY_1},
+	{ 0x866b01, KEY_2},
+	{ 0x866b02, KEY_3},
+	{ 0x866b03, KEY_4},
+	{ 0x866b04, KEY_5},
+	{ 0x866b05, KEY_6},
+	{ 0x866b06, KEY_7},
+	{ 0x866b07, KEY_8},
+	{ 0x866b08, KEY_9},
+	{ 0x866b14, KEY_0},
+
+	{ 0x866b0a, KEY_ZOOM},		/* Full Screen */
+	{ 0x866b10, KEY_CAMERA},	/* Photo */
+	{ 0x866b0e, KEY_CHANNEL},	/* circular arrow / Recall */
+	{ 0x866b13, KEY_ESC},           /* Back */
+
+	{ 0x866b20, KEY_UP},
+	{ 0x866b21, KEY_DOWN},
+	{ 0x866b42, KEY_LEFT},
+	{ 0x866b43, KEY_RIGHT},
+	{ 0x866b0b, KEY_OK},
+
+	{ 0x866b11, KEY_CHANNELUP},
+	{ 0x866b1b, KEY_CHANNELDOWN},
+
+	{ 0x866b12, KEY_VOLUMEUP},
+	{ 0x866b48, KEY_VOLUMEDOWN},
+	{ 0x866b44, KEY_MUTE},
+
+	{ 0x866b1a, KEY_RECORD},
+	{ 0x866b41, KEY_PLAY},
+	{ 0x866b40, KEY_STOP},
+	{ 0x866b19, KEY_PAUSE},
+	{ 0x866b1c, KEY_FASTFORWARD},	/* >> / FWD */
+	{ 0x866b1e, KEY_REWIND},	/* << / REW */
+
+};
+
+static struct rc_map_list delock_61959_map = {
+	.map = {
+		.scan    = delock_61959,
+		.size    = ARRAY_SIZE(delock_61959),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_DELOCK_61959,
+	}
+};
+
+static int __init init_rc_map_delock_61959(void)
+{
+	return rc_map_register(&delock_61959_map);
+}
+
+static void __exit exit_rc_map_delock_61959(void)
+{
+	rc_map_unregister(&delock_61959_map);
+}
+
+module_init(init_rc_map_delock_61959)
+module_exit(exit_rc_map_delock_61959)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jakob Haufe <sur5r@sur5r.net>");
+MODULE_DESCRIPTION("Delock 61959 remote keytable");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index f74ee6f..46326ab 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -111,6 +111,7 @@ void rc_map_init(void);
 #define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
 #define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
 #define RC_MAP_CINERGY                   "rc-cinergy"
+#define RC_MAP_DELOCK_61959              "rc-delock-61959"
 #define RC_MAP_DIB0700_NEC_TABLE         "rc-dib0700-nec"
 #define RC_MAP_DIB0700_RC5_TABLE         "rc-dib0700-rc5"
 #define RC_MAP_DIGITALNOW_TINYTWIN       "rc-digitalnow-tinytwin"
-- 
1.7.10.4

