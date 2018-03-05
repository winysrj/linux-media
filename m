Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50425 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751400AbeCEPeD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 10:34:03 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] media: rc: add keymap for iMON RSC remote
Date: Mon,  5 Mar 2018 15:34:01 +0000
Message-Id: <20180305153402.24141-2-sean@mess.org>
In-Reply-To: <20180305153402.24141-1-sean@mess.org>
References: <20180305153402.24141-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note that the stick on the remote is not supported yet.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/Makefile      |  1 +
 drivers/media/rc/keymaps/rc-imon-rsc.c | 81 ++++++++++++++++++++++++++++++++++
 include/media/rc-map.h                 |  1 +
 3 files changed, 83 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-imon-rsc.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 50b319355edf..d6b913a3032d 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-hisi-tv-demo.o \
 			rc-imon-mce.o \
 			rc-imon-pad.o \
+			rc-imon-rsc.o \
 			rc-iodata-bctv7e.o \
 			rc-it913x-v1.o \
 			rc-it913x-v2.o \
diff --git a/drivers/media/rc/keymaps/rc-imon-rsc.c b/drivers/media/rc/keymaps/rc-imon-rsc.c
new file mode 100644
index 000000000000..83e4564aaa22
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-imon-rsc.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+//
+// Note that this remote has a stick which its own IR protocol,
+// with 16 directions. This is not supported yet.
+//
+static struct rc_map_table imon_rsc[] = {
+	{ 0x801010, KEY_EXIT },
+	{ 0x80102f, KEY_POWER },
+	{ 0x80104a, KEY_SCREENSAVER },	/* Screensaver */
+	{ 0x801049, KEY_TIME },		/* Timer */
+	{ 0x801054, KEY_NUMERIC_1 },
+	{ 0x801055, KEY_NUMERIC_2 },
+	{ 0x801056, KEY_NUMERIC_3 },
+	{ 0x801057, KEY_NUMERIC_4 },
+	{ 0x801058, KEY_NUMERIC_5 },
+	{ 0x801059, KEY_NUMERIC_6 },
+	{ 0x80105a, KEY_NUMERIC_7 },
+	{ 0x80105b, KEY_NUMERIC_8 },
+	{ 0x80105c, KEY_NUMERIC_9 },
+	{ 0x801081, KEY_SCREEN },	/* Desktop */
+	{ 0x80105d, KEY_NUMERIC_0 },
+	{ 0x801082, KEY_MAX },
+	{ 0x801048, KEY_ESC },
+	{ 0x80104b, KEY_MEDIA },	/* Windows key */
+	{ 0x801083, KEY_MENU },
+	{ 0x801045, KEY_APPSELECT },	/* app launcher */
+	{ 0x801084, KEY_STOP },
+	{ 0x801046, KEY_CYCLEWINDOWS },
+	{ 0x801085, KEY_BACKSPACE },
+	{ 0x801086, KEY_KEYBOARD },
+	{ 0x801087, KEY_SPACE },
+	{ 0x80101e, KEY_RESERVED },	/* shift tab */
+	{ 0x801098, BTN_0 },
+	{ 0x80101f, KEY_TAB },
+	{ 0x80101b, BTN_LEFT },
+	{ 0x80101d, BTN_RIGHT },
+	{ 0x801016, BTN_MIDDLE },	/* drag and drop */
+	{ 0x801088, KEY_MUTE },
+	{ 0x80105e, KEY_VOLUMEDOWN },
+	{ 0x80105f, KEY_VOLUMEUP },
+	{ 0x80104c, KEY_PLAY },
+	{ 0x80104d, KEY_PAUSE },
+	{ 0x80104f, KEY_EJECTCD },
+	{ 0x801050, KEY_PREVIOUS },
+	{ 0x801051, KEY_NEXT },
+	{ 0x80104e, KEY_STOP },
+	{ 0x801052, KEY_REWIND },
+	{ 0x801053, KEY_FASTFORWARD },
+	{ 0x801089, KEY_ZOOM }		/* full screen */
+};
+
+static struct rc_map_list imon_rsc_map = {
+	.map = {
+		.scan     = imon_rsc,
+		.size     = ARRAY_SIZE(imon_rsc),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_IMON_RSC,
+	}
+};
+
+static int __init init_rc_map_imon_rsc(void)
+{
+	return rc_map_register(&imon_rsc_map);
+}
+
+static void __exit exit_rc_map_imon_rsc(void)
+{
+	rc_map_unregister(&imon_rsc_map);
+}
+
+module_init(init_rc_map_imon_rsc)
+module_exit(exit_rc_map_imon_rsc)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7046734b3895..7fc84991bd12 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -211,6 +211,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_HISI_TV_DEMO              "rc-hisi-tv-demo"
 #define RC_MAP_IMON_MCE                  "rc-imon-mce"
 #define RC_MAP_IMON_PAD                  "rc-imon-pad"
+#define RC_MAP_IMON_RSC                  "rc-imon-rsc"
 #define RC_MAP_IODATA_BCTV7E             "rc-iodata-bctv7e"
 #define RC_MAP_IT913X_V1                 "rc-it913x-v1"
 #define RC_MAP_IT913X_V2                 "rc-it913x-v2"
-- 
2.14.3
