Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46422 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3DLSAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 14:00:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] rc: add rc-reddo
Date: Fri, 12 Apr 2013 20:59:02 +0300
Message-Id: <1365789544-18819-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is very similar than rc-msi-digivox-iii but new keytable is needed
as there is one existing scancode mapped to different button. Also that
one has less buttons.

NEC extended protocol with address 0x61d6.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/rc/keymaps/Makefile   |  1 +
 drivers/media/rc/keymaps/rc-reddo.c | 86 +++++++++++++++++++++++++++++++++++++
 include/media/rc-map.h              |  1 +
 3 files changed, 88 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-reddo.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 7786619..04baac4 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-hauppauge.o \
 			rc-rc6-mce.o \
 			rc-real-audio-220-32-keys.o \
+			rc-reddo.o \
 			rc-snapstream-firefly.o \
 			rc-streamzap.o \
 			rc-tbs-nec.o \
diff --git a/drivers/media/rc/keymaps/rc-reddo.c b/drivers/media/rc/keymaps/rc-reddo.c
new file mode 100644
index 0000000..b80b336
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-reddo.c
@@ -0,0 +1,86 @@
+/*
+ * MSI DIGIVOX mini III remote controller keytable
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+/*
+ * Derived from MSI DIGIVOX mini III remote (rc-msi-digivox-iii.c)
+ *
+ * Differences between these remotes are:
+ *
+ * 1) scancode 0x61d601 is mapped to different button:
+ *    MSI DIGIVOX mini III   "Source" = KEY_VIDEO
+ *    Reddo                     "EPG" = KEY_EPG
+ *
+ * 2) Reddo remote has less buttons. Missing buttons are: colored buttons,
+ *    navigation buttons and main power button.
+ */
+
+static struct rc_map_table reddo[] = {
+	{ 0x61d601, KEY_EPG },             /* EPG */
+	{ 0x61d602, KEY_3 },
+	{ 0x61d604, KEY_1 },
+	{ 0x61d605, KEY_5 },
+	{ 0x61d606, KEY_6 },
+	{ 0x61d607, KEY_CHANNELDOWN },     /* CH- */
+	{ 0x61d608, KEY_2 },
+	{ 0x61d609, KEY_CHANNELUP },       /* CH+ */
+	{ 0x61d60a, KEY_9 },
+	{ 0x61d60b, KEY_ZOOM },            /* Zoom */
+	{ 0x61d60c, KEY_7 },
+	{ 0x61d60d, KEY_8 },
+	{ 0x61d60e, KEY_VOLUMEUP },        /* Vol+ */
+	{ 0x61d60f, KEY_4 },
+	{ 0x61d610, KEY_ESC },             /* [back up arrow] */
+	{ 0x61d611, KEY_0 },
+	{ 0x61d612, KEY_OK },              /* [enter arrow] */
+	{ 0x61d613, KEY_VOLUMEDOWN },      /* Vol- */
+	{ 0x61d614, KEY_RECORD },          /* Rec */
+	{ 0x61d615, KEY_STOP },            /* Stop */
+	{ 0x61d616, KEY_PLAY },            /* Play */
+	{ 0x61d617, KEY_MUTE },            /* Mute */
+	{ 0x61d643, KEY_POWER2 },          /* [red power button] */
+};
+
+static struct rc_map_list reddo_map = {
+	.map = {
+		.scan    = reddo,
+		.size    = ARRAY_SIZE(reddo),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_REDDO,
+	}
+};
+
+static int __init init_rc_map_reddo(void)
+{
+	return rc_map_register(&reddo_map);
+}
+
+static void __exit exit_rc_map_reddo(void)
+{
+	rc_map_unregister(&reddo_map);
+}
+
+module_init(init_rc_map_reddo)
+module_exit(exit_rc_map_reddo)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index f74ee6f..5d5d3a3 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -172,6 +172,7 @@ void rc_map_init(void);
 #define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
+#define RC_MAP_REDDO                     "rc-reddo"
 #define RC_MAP_SNAPSTREAM_FIREFLY        "rc-snapstream-firefly"
 #define RC_MAP_STREAMZAP                 "rc-streamzap"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
-- 
1.7.11.7

