Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:21444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab0LQSNE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 13:13:04 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBHID44W028180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 13:13:04 -0500
Received: from pedra (vpn-232-172.phx2.redhat.com [10.3.232.172])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oBHIC0wx009397
	for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 13:13:03 -0500
Date: Fri, 17 Dec 2010 16:11:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] Add a keymap for Pixelview 002-T remote
Message-ID: <20101217161155.7e0ebba2@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/rc/keymaps/rc-pixelview-002t.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 3194d39..148900f 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-pinnacle-pctv-hd.o \
 			rc-pixelview.o \
 			rc-pixelview-mk12.o \
+			rc-pixelview-002t.o \
 			rc-pixelview-new.o \
 			rc-powercolor-real-angel.o \
 			rc-proteus-2309.o \
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
new file mode 100644
index 0000000..e5ab071
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -0,0 +1,77 @@
+/* rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+/*
+ * Keytable for 002-T IR remote provided together with Pixelview
+ * SBTVD Hybrid Remote Controller. Uses NEC extended format.
+ */
+static struct rc_map_table pixelview_002t[] = {
+	{ 0x866b13, KEY_MUTE },
+	{ 0x866b12, KEY_POWER2 },	/* power */
+
+	{ 0x866b01, KEY_1 },
+	{ 0x866b02, KEY_2 },
+	{ 0x866b03, KEY_3 },
+	{ 0x866b04, KEY_4 },
+	{ 0x866b05, KEY_5 },
+	{ 0x866b06, KEY_6 },
+	{ 0x866b07, KEY_7 },
+	{ 0x866b08, KEY_8 },
+	{ 0x866b09, KEY_9 },
+	{ 0x866b00, KEY_0 },
+
+	{ 0x866b0d, KEY_CHANNELUP },
+	{ 0x866b19, KEY_CHANNELDOWN },
+	{ 0x866b10, KEY_VOLUMEUP },	/* vol + */
+	{ 0x866b0c, KEY_VOLUMEDOWN },	/* vol - */
+
+	{ 0x866b0a, KEY_CAMERA },	/* snapshot */
+	{ 0x866b0b, KEY_ZOOM },		/* zoom */
+
+	{ 0x866b1b, KEY_BACKSPACE },
+	{ 0x866b15, KEY_ENTER },
+
+	{ 0x866b1d, KEY_UP },
+	{ 0x866b1e, KEY_DOWN },
+	{ 0x866b0e, KEY_LEFT },
+	{ 0x866b0f, KEY_RIGHT },
+
+	{ 0x866b18, KEY_RECORD },
+	{ 0x866b1a, KEY_STOP },
+};
+
+static struct rc_map_list pixelview_map = {
+	.map = {
+		.scan    = pixelview_002t,
+		.size    = ARRAY_SIZE(pixelview_002t),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_PIXELVIEW_002T,
+	}
+};
+
+static int __init init_rc_map_pixelview(void)
+{
+	return rc_map_register(&pixelview_map);
+}
+
+static void __exit exit_rc_map_pixelview(void)
+{
+	rc_map_unregister(&pixelview_map);
+}
+
+module_init(init_rc_map_pixelview)
+module_exit(exit_rc_map_pixelview)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1a3d51d..5d3a457 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -119,6 +119,7 @@ void rc_map_init(void);
 #define RC_MAP_PINNACLE_PCTV_HD          "rc-pinnacle-pctv-hd"
 #define RC_MAP_PIXELVIEW_NEW             "rc-pixelview-new"
 #define RC_MAP_PIXELVIEW                 "rc-pixelview"
+#define RC_MAP_PIXELVIEW_002T		 "rc-pixelview-002t"
 #define RC_MAP_PIXELVIEW_MK12            "rc-pixelview-mk12"
 #define RC_MAP_POWERCOLOR_REAL_ANGEL     "rc-powercolor-real-angel"
 #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
-- 
1.7.1


