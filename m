Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:42441 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbdJ1Nih (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 09:38:37 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH 2/5] [media] Add Astrometa T2hybrid keymap module
Date: Sat, 28 Oct 2017 16:38:17 +0300
Message-Id: <20171028133820.18246-2-oleg@kaa.org.ua>
In-Reply-To: <20171028133820.18246-1-oleg@kaa.org.ua>
References: <20171028133820.18246-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the keymap module for Astrometa T2hybrid remote control commands.

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/rc/keymaps/Makefile                |  1 +
 drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c | 70 ++++++++++++++++++++++++
 include/media/rc-map.h                           |  1 +
 3 files changed, 72 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 2945f99907b5..530307c15d84 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-alink-dtu-m.o \
 			rc-anysee.o \
 			rc-apac-viewcomp.o \
+			rc-astrometa-t2hybrid.o \
 			rc-asus-pc39.o \
 			rc-asus-ps3-100.o \
 			rc-ati-tv-wonder-hd-600.o \
diff --git a/drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c b/drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c
new file mode 100644
index 000000000000..c3efece21733
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c
@@ -0,0 +1,70 @@
+/*
+ * Keytable for the Astrometa T2hybrid remote controller
+ *
+ * Copyright (C) 2017 Oleh Kravchenko <oleg@kaa.org.ua>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table t2hybrid[] = {
+	{ 0x4d, KEY_POWER2 },
+	{ 0x54, KEY_VIDEO }, /* Source */
+	{ 0x16, KEY_MUTE },
+
+	{ 0x4c, KEY_RECORD },
+	{ 0x05, KEY_CHANNELUP },
+	{ 0x0c, KEY_TIME}, /* Timeshift */
+
+	{ 0x0a, KEY_VOLUMEDOWN },
+	{ 0x40, KEY_ZOOM }, /* Fullscreen */
+	{ 0x1e, KEY_VOLUMEUP },
+
+	{ 0x12, KEY_0 },
+	{ 0x02, KEY_CHANNELDOWN },
+	{ 0x1c, KEY_AGAIN }, /* Recall */
+
+	{ 0x09, KEY_1 },
+	{ 0x1d, KEY_2 },
+	{ 0x1f, KEY_3 },
+
+	{ 0x0d, KEY_4 },
+	{ 0x19, KEY_5 },
+	{ 0x1b, KEY_6 },
+
+	{ 0x11, KEY_7 },
+	{ 0x15, KEY_8 },
+	{ 0x17, KEY_9 },
+};
+
+static struct rc_map_list t2hybrid_map = {
+	.map = {
+		.scan    = t2hybrid,
+		.size    = ARRAY_SIZE(t2hybrid),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_ASTROMETA_T2HYBRID,
+	}
+};
+
+static int __init init_rc_map_t2hybrid(void)
+{
+	return rc_map_register(&t2hybrid_map);
+}
+
+static void __exit exit_rc_map_t2hybrid(void)
+{
+	rc_map_unregister(&t2hybrid_map);
+}
+
+module_init(init_rc_map_t2hybrid)
+module_exit(exit_rc_map_t2hybrid)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Oleh Kravchenko <oleg@kaa.org.ua>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1a815a572fa1..4e7a5c8f4538 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -202,6 +202,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_ALINK_DTU_M               "rc-alink-dtu-m"
 #define RC_MAP_ANYSEE                    "rc-anysee"
 #define RC_MAP_APAC_VIEWCOMP             "rc-apac-viewcomp"
+#define RC_MAP_ASTROMETA_T2HYBRID        "rc-astrometa-t2hybrid"
 #define RC_MAP_ASUS_PC39                 "rc-asus-pc39"
 #define RC_MAP_ASUS_PS3_100              "rc-asus-ps3-100"
 #define RC_MAP_ATI_TV_WONDER_HD_600      "rc-ati-tv-wonder-hd-600"
-- 
2.13.6
