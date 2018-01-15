Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54237 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933007AbeAOJ61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 04:58:27 -0500
From: Sean Young <sean@mess.org>
To: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 4/5] media: rc: add keymap for Dign Remote
Date: Mon, 15 Jan 2018 09:58:23 +0000
Message-Id: <20e9397303a264c7a46a79b81ef1fd2401e08481.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the remote which comes with the Ahanix D.Vine 5 HTPC case.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/Makefile  |  1 +
 drivers/media/rc/keymaps/rc-dign.c | 70 ++++++++++++++++++++++++++++++++++++++
 include/media/rc-map.h             |  1 +
 3 files changed, 72 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-dign.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 50b319355edf..5a7aebe12285 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-dib0700-rc5.o \
 			rc-digitalnow-tinytwin.o \
 			rc-digittrade.o \
+			rc-dign.o \
 			rc-dm1105-nec.o \
 			rc-dntv-live-dvb-t.o \
 			rc-dntv-live-dvbt-pro.o \
diff --git a/drivers/media/rc/keymaps/rc-dign.c b/drivers/media/rc/keymaps/rc-dign.c
new file mode 100644
index 000000000000..a70bb5f89278
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-dign.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Keymap for Dign Remote for Ahanix D.Vine 5 Case
+//
+// Copyright (C) 2018 by Sean Young <sean@mess.org>
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table dign[] = {
+	{ 0x8000, KEY_POWER },
+	{ 0x8002, KEY_EJECTCD },
+	{ 0x8008, KEY_1 },
+	{ 0x8009, KEY_2 },
+	{ 0x800a, KEY_3 },
+	{ 0x8010, KEY_4 },
+	{ 0x8011, KEY_5 },
+	{ 0x8012, KEY_6 },
+	{ 0x8018, KEY_7 },
+	{ 0x8019, KEY_8 },
+	{ 0x801a, KEY_9 },
+
+	{ 0x8040, KEY_ENTER }, /* Start/Windows */
+	{ 0x8041, KEY_0 },
+	{ 0x8006, KEY_MENU },
+
+	{ 0x800f, KEY_VOLUMEDOWN },
+	{ 0x800e, KEY_VOLUMEUP },
+
+	{ 0x8005, KEY_ESC },
+	{ 0x8007, KEY_CLOSE },
+	{ 0x800b, KEY_UP },
+	{ 0x8003, KEY_LEFT },
+	{ 0x801b, KEY_RIGHT },
+	{ 0x8043, KEY_DOWN },
+	{ 0x8013, KEY_ENTER },
+
+	{ 0x800c, KEY_PREVIOUSSONG },
+	{ 0x8001, KEY_NEXTSONG },
+
+	{ 0x800d, KEY_MUTE },
+	{ 0x8004, KEY_FRAMEFORWARD }, /* Step */
+	{ 0x8049, KEY_PLAYPAUSE },
+	{ 0x8048, KEY_STOP },
+};
+
+static struct rc_map_list dign_map = {
+	.map = {
+		.scan     = dign,
+		.size     = ARRAY_SIZE(dign),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_DIGN,
+	}
+};
+
+static int __init init_rc_map_dign(void)
+{
+	return rc_map_register(&dign_map);
+}
+
+static void __exit exit_rc_map_dign(void)
+{
+	rc_map_unregister(&dign_map);
+}
+
+module_init(init_rc_map_dign)
+module_exit(exit_rc_map_dign)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7046734b3895..1c0016af45a1 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -185,6 +185,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_DIB0700_RC5_TABLE         "rc-dib0700-rc5"
 #define RC_MAP_DIGITALNOW_TINYTWIN       "rc-digitalnow-tinytwin"
 #define RC_MAP_DIGITTRADE                "rc-digittrade"
+#define RC_MAP_DIGN			 "rc-dign"
 #define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
 #define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
 #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
-- 
2.14.3
