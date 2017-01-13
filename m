Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36529 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdAMOWW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 09:22:22 -0500
Received: by mail-wm0-f66.google.com with SMTP id r126so12028045wmr.3
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2017 06:22:21 -0800 (PST)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] media: rc/keymaps: add a keytable for the GeekBox remote control
Date: Fri, 13 Jan 2017 15:22:12 +0100
Message-Id: <20170113142212.13317-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GeekBox ships with a 12 button remote control which seems to use the
NEC protocol. The button keycodes were captured with the "ir-keytable"
tool (ir-keytable -p $PROTOCOL -t; human_button_pusher).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/rc/keymaps/Makefile     |  1 +
 drivers/media/rc/keymaps/rc-geekbox.c | 55 +++++++++++++++++++++++++++++++++++
 include/media/rc-map.h                |  1 +
 3 files changed, 57 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-geekbox.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index d7b13fae1267..4578b3454c0b 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-flyvideo.o \
 			rc-fusionhdtv-mce.o \
 			rc-gadmei-rm008z.o \
+			rc-geekbox.o \
 			rc-genius-tvgo-a11mce.o \
 			rc-gotview7135.o \
 			rc-imon-mce.o \
diff --git a/drivers/media/rc/keymaps/rc-geekbox.c b/drivers/media/rc/keymaps/rc-geekbox.c
new file mode 100644
index 000000000000..affc4c481888
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-geekbox.c
@@ -0,0 +1,55 @@
+/*
+ * Keytable for the GeekBox remote controller
+ *
+ * Copyright (C) 2017 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
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
+static struct rc_map_table geekbox[] = {
+	{ 0x01, KEY_BACK },
+	{ 0x02, KEY_DOWN },
+	{ 0x03, KEY_UP },
+	{ 0x07, KEY_OK },
+	{ 0x0b, KEY_VOLUMEUP },
+	{ 0x0e, KEY_LEFT },
+	{ 0x13, KEY_MENU },
+	{ 0x14, KEY_POWER },
+	{ 0x1a, KEY_RIGHT },
+	{ 0x48, KEY_HOME },
+	{ 0x58, KEY_VOLUMEDOWN },
+	{ 0x5c, KEY_SCREEN },
+};
+
+static struct rc_map_list geekbox_map = {
+	.map = {
+		.scan    = geekbox,
+		.size    = ARRAY_SIZE(geekbox),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_GEEKBOX,
+	}
+};
+
+static int __init init_rc_map_geekbox(void)
+{
+	return rc_map_register(&geekbox_map);
+}
+
+static void __exit exit_rc_map_geekbox(void)
+{
+	rc_map_unregister(&geekbox_map);
+}
+
+module_init(init_rc_map_geekbox)
+module_exit(exit_rc_map_geekbox)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e1cc14cba391..3db3b63be279 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -219,6 +219,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_FLYVIDEO                  "rc-flyvideo"
 #define RC_MAP_FUSIONHDTV_MCE            "rc-fusionhdtv-mce"
 #define RC_MAP_GADMEI_RM008Z             "rc-gadmei-rm008z"
+#define RC_MAP_GEEKBOX                   "rc-geekbox"
 #define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
 #define RC_MAP_GOTVIEW7135               "rc-gotview7135"
 #define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge"
-- 
2.11.0

