Return-path: <mchehab@pedra>
Received: from blu0-omc2-s30.blu0.hotmail.com ([65.55.111.105]:17648 "EHLO
	blu0-omc2-s30.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635Ab1FKI4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 04:56:18 -0400
Message-ID: <BLU0-SMTP649F33D5A9FCF7358F6807D8670@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] [media] Add Keytable for tbs_dtb08 remote controller
Date: Sat, 11 Jun 2011 05:56:02 -0300
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/rc/keymaps/Makefile       |    1 +
 drivers/media/rc/keymaps/rc-tbs-dtb08.c |   77 +++++++++++++++++++++++++++++++
 include/media/rc-map.h                  |    1 +
 3 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-tbs-dtb08.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index b57fc83..670febd 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-rc6-mce.o \
 			rc-real-audio-220-32-keys.o \
 			rc-streamzap.o \
+			rc-tbs-dtb08.o \
 			rc-tbs-nec.o \
 			rc-technisat-usb2.o \
 			rc-terratec-cinergy-xs.o \
diff --git a/drivers/media/rc/keymaps/rc-tbs-dtb08.c b/drivers/media/rc/keymaps/rc-tbs-dtb08.c
new file mode 100644
index 0000000..bd2562a
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-tbs-dtb08.c
@@ -0,0 +1,77 @@
+/*
+ *  TBS-Tech ISDB-T Full Seg DTB08 remote controller keytable
+ *
+ *  Copyright (C) 2011 Manoel Pinheiro <pinusdtv@pdtv.cjb.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <media/rc-map.h>
+
+static struct rc_map_table tbs_dtb08[] = {
+	{ 0x10, KEY_POWER },		/* power */
+	{ 0x06, KEY_MUTE },		/* mute */
+	{ 0x4c, KEY_1 },
+	{ 0x04, KEY_2 },
+	{ 0x00, KEY_3 },
+	{ 0x1e, KEY_4 },
+	{ 0x0e, KEY_5 },
+	{ 0x1a, KEY_6 },
+	{ 0x14, KEY_7 },
+	{ 0x0f, KEY_8 },
+	{ 0x0c, KEY_9 },
+	{ 0x1c, KEY_0 },
+	{ 0x40, KEY_CHANNELUP },	/* ch+ */
+	{ 0x0a, KEY_CHANNELDOWN },	/* ch- */
+	{ 0x19, KEY_VOLUMEUP },		/* vol+ */
+	{ 0x17, KEY_VOLUMEDOWN },	/* vol- */
+	{ 0x11, KEY_OK },		/* ok */
+	{ 0x09, KEY_SHUFFLE },		/* scrn shot */
+	{ 0x1f, KEY_UP },
+	{ 0x1b, KEY_LEFT },
+	{ 0x15, KEY_RIGHT },
+	{ 0x16, KEY_DOWN },
+	{ 0x4d, KEY_FAVORITES },	/* fav */
+	{ 0x01, KEY_ZOOM },
+	{ 0x03, KEY_EPG },
+	{ 0x1d, KEY_PLAY },
+	{ 0x0d, KEY_STOP },
+	/* { 0x12, FIXME:  }, */	/* recall */
+};
+
+static struct rc_map_list tbs_dtb08_map = {
+	.map = {
+		.scan    = tbs_dtb08,
+		.size    = ARRAY_SIZE(tbs_dtb08),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_TBS_DTB08,
+	}
+};
+
+static int __init init_rc_map_tbs_dtb08(void)
+{
+	return rc_map_register(&tbs_dtb08_map);
+}
+
+static void __exit exit_rc_map_tbs_dtb08(void)
+{
+	rc_map_unregister(&tbs_dtb08_map);
+}
+
+module_init(init_rc_map_tbs_dtb08)
+module_exit(exit_rc_map_tbs_dtb08)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Manoel Pinheiro <pinusdtv@pdtv.cjb.net>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 4e1409e..9a8159a 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -130,6 +130,7 @@ void rc_map_init(void);
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_STREAMZAP                 "rc-streamzap"
+#define RC_MAP_TBS_DTB08                 "rc-tbs-dtb08"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
 #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
-- 
1.7.3.4

