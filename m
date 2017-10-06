Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([216.205.24.107]:36721 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752154AbdJFMit (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 08:38:49 -0400
Subject: [PATCH v8 2/3] media: rc: Add tango keymap
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
To: Sean Young <sean@mess.org>
CC: linux-media <linux-media@vger.kernel.org>,
        Mans Rullgard <mans@mansr.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
References: <3d911a4a-1945-08a7-ae19-0cd0dc6aaacd@sigmadesigns.com>
Message-ID: <bb8c72bf-90a4-d995-0ad5-85e2480ae6ec@sigmadesigns.com>
Date: Fri, 6 Oct 2017 14:33:41 +0200
MIME-Version: 1.0
In-Reply-To: <3d911a4a-1945-08a7-ae19-0cd0dc6aaacd@sigmadesigns.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a keymap for the Sigma Designs Vantage (dev board) remote control.

Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
---
Changes between v7 and v8
* Add legalese boiler plate
* Define RC_PROTO_NECX
* Move RC_MAP_TANGO to alphabetical order
---
 drivers/media/rc/keymaps/Makefile   |  1 +
 drivers/media/rc/keymaps/rc-tango.c | 92 +++++++++++++++++++++++++++++++++++++
 include/media/rc-map.h              |  1 +
 3 files changed, 94 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-tango.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index af6496d709fb..3c1e31321e21 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-reddo.o \
 			rc-snapstream-firefly.o \
 			rc-streamzap.o \
+			rc-tango.o \
 			rc-tbs-nec.o \
 			rc-technisat-ts35.o \
 			rc-technisat-usb2.o \
diff --git a/drivers/media/rc/keymaps/rc-tango.c b/drivers/media/rc/keymaps/rc-tango.c
new file mode 100644
index 000000000000..1c6e8875d46f
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-tango.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright (C) 2017 Sigma Designs
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <media/rc-map.h>
+
+static struct rc_map_table tango_table[] = {
+	{ 0x4cb4a, KEY_POWER },
+	{ 0x4cb48, KEY_FILE },
+	{ 0x4cb0f, KEY_SETUP },
+	{ 0x4cb4d, KEY_SUSPEND },
+	{ 0x4cb4e, KEY_VOLUMEUP },
+	{ 0x4cb44, KEY_EJECTCD },
+	{ 0x4cb13, KEY_TV },
+	{ 0x4cb51, KEY_MUTE },
+	{ 0x4cb52, KEY_VOLUMEDOWN },
+
+	{ 0x4cb41, KEY_1 },
+	{ 0x4cb03, KEY_2 },
+	{ 0x4cb42, KEY_3 },
+	{ 0x4cb45, KEY_4 },
+	{ 0x4cb07, KEY_5 },
+	{ 0x4cb46, KEY_6 },
+	{ 0x4cb55, KEY_7 },
+	{ 0x4cb17, KEY_8 },
+	{ 0x4cb56, KEY_9 },
+	{ 0x4cb1b, KEY_0 },
+	{ 0x4cb59, KEY_DELETE },
+	{ 0x4cb5a, KEY_CAPSLOCK },
+
+	{ 0x4cb47, KEY_BACK },
+	{ 0x4cb05, KEY_SWITCHVIDEOMODE },
+	{ 0x4cb06, KEY_UP },
+	{ 0x4cb43, KEY_LEFT },
+	{ 0x4cb01, KEY_RIGHT },
+	{ 0x4cb0a, KEY_DOWN },
+	{ 0x4cb02, KEY_ENTER },
+	{ 0x4cb4b, KEY_INFO },
+	{ 0x4cb09, KEY_HOME },
+
+	{ 0x4cb53, KEY_MENU },
+	{ 0x4cb12, KEY_PREVIOUS },
+	{ 0x4cb50, KEY_PLAY },
+	{ 0x4cb11, KEY_NEXT },
+	{ 0x4cb4f, KEY_TITLE },
+	{ 0x4cb0e, KEY_REWIND },
+	{ 0x4cb4c, KEY_STOP },
+	{ 0x4cb0d, KEY_FORWARD },
+	{ 0x4cb57, KEY_MEDIA_REPEAT },
+	{ 0x4cb16, KEY_ANGLE },
+	{ 0x4cb54, KEY_PAUSE },
+	{ 0x4cb15, KEY_SLOW },
+	{ 0x4cb5b, KEY_TIME },
+	{ 0x4cb1a, KEY_AUDIO },
+	{ 0x4cb58, KEY_SUBTITLE },
+	{ 0x4cb19, KEY_ZOOM },
+
+	{ 0x4cb5f, KEY_RED },
+	{ 0x4cb1e, KEY_GREEN },
+	{ 0x4cb5c, KEY_YELLOW },
+	{ 0x4cb1d, KEY_BLUE },
+};
+
+static struct rc_map_list tango_map = {
+	.map = {
+		.scan = tango_table,
+		.size = ARRAY_SIZE(tango_table),
+		.rc_proto = RC_PROTO_NECX,
+		.name = RC_MAP_TANGO,
+	}
+};
+
+static int __init init_rc_map_tango(void)
+{
+	return rc_map_register(&tango_map);
+}
+
+static void __exit exit_rc_map_tango(void)
+{
+	rc_map_unregister(&tango_map);
+}
+
+module_init(init_rc_map_tango)
+module_exit(exit_rc_map_tango)
+
+MODULE_AUTHOR("Sigma Designs");
+MODULE_LICENSE("GPL");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 2a160e6e823c..b4ddcb62c993 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -300,6 +300,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_REDDO                     "rc-reddo"
 #define RC_MAP_SNAPSTREAM_FIREFLY        "rc-snapstream-firefly"
 #define RC_MAP_STREAMZAP                 "rc-streamzap"
+#define RC_MAP_TANGO                     "rc-tango"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
 #define RC_MAP_TECHNISAT_TS35            "rc-technisat-ts35"
 #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
-- 
2.14.2
