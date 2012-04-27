Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:34237 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2D0HHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 03:07:32 -0400
Received: by dadz8 with SMTP id z8so613001dad.10
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 00:07:32 -0700 (PDT)
Date: Fri, 27 Apr 2012 15:07:36 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>,
 <201204152353103757288@gmail.com>,
 <201204201601166255937@gmail.com>,
 <4F9130BB.8060107@iki.fi>,
 <201204211045557968605@gmail.com>,
 <4F958640.9010404@iki.fi>,
 <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>,
 <201204262103053283195@gmail.com>,
 <4F994CA8.8060200@redhat.com>
Subject: [PATCH 5/6 v2] dvbsky, remote control key map
Message-ID: <201204271507344377386@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/rc/keymaps/Makefile    |    1 +
 drivers/media/rc/keymaps/rc-dvbsky.c |   77 ++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-dvbsky.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 49ce266..e6a882b 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-dm1105-nec.o \
 			rc-dntv-live-dvb-t.o \
 			rc-dntv-live-dvbt-pro.o \
+			rc-dvbsky.o \
 			rc-em-terratec.o \
 			rc-encore-enltv2.o \
 			rc-encore-enltv.o \
diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
new file mode 100644
index 0000000..25a531c
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-dvbsky.c
@@ -0,0 +1,77 @@
+/* rc-dvbsky.c - Keytable for Dvbsky Remote Controllers
+ *
+ *
+ *
+ *   Copyright (C) 2011 Max nibble<nibble.max@gmail.com>
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
+MODULE_AUTHOR("Max nibble <nibble.max@gmail.com>");
-- 
1.7.9.5

