Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934098Ab1CXUEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 16:04:33 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2OK4VkF023020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 16:04:31 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2] rc: add tivo/nero liquidtv keymap
Date: Thu, 24 Mar 2011 16:04:24 -0400
Message-Id: <1300997065-4085-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/keymaps/Makefile  |    1 +
 drivers/media/rc/keymaps/rc-tivo.c |   98 ++++++++++++++++++++++++++++++++++++
 include/media/rc-map.h             |    1 +
 3 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-tivo.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 85cac7d..b57fc83 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-terratec-slim.o \
 			rc-terratec-slim-2.o \
 			rc-tevii-nec.o \
+			rc-tivo.o \
 			rc-total-media-in-hand.o \
 			rc-trekstor.o \
 			rc-tt-1500.o \
diff --git a/drivers/media/rc/keymaps/rc-tivo.c b/drivers/media/rc/keymaps/rc-tivo.c
new file mode 100644
index 0000000..98ad085
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-tivo.c
@@ -0,0 +1,98 @@
+/* rc-tivo.c - Keytable for TiVo remotes
+ *
+ * Copyright (c) 2011 by Jarod Wilson <jarod@redhat.com>
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
+ * Initial mapping is for the TiVo remote included in the Nero LiquidTV bundle,
+ * which also ships with a TiVo-branded IR transceiver, supported by the mceusb
+ * driver. Note that the remote uses an NEC-ish protocol, but instead of having
+ * a command/not_command pair, it has a vendor ID of 0xa10c, but some keys, the
+ * NEC extended checksums do pass, so the table presently has the intended
+ * values and the checksum-passed versions for those keys.
+ */
+static struct rc_map_table tivo[] = {
+	{ 0xa10c900f, KEY_MEDIA },	/* TiVo Button */
+	{ 0xa10c0807, KEY_POWER2 },	/* TV Power */
+	{ 0xa10c8807, KEY_TV },		/* Live TV/Swap */
+	{ 0xa10c2c03, KEY_VIDEO_NEXT },	/* TV Input */
+	{ 0xa10cc807, KEY_INFO },
+	{ 0xa10cfa05, KEY_CYCLEWINDOWS }, /* Window */
+	{ 0x0085305f, KEY_CYCLEWINDOWS },
+	{ 0xa10c6c03, KEY_EPG },	/* Guide */
+
+	{ 0xa10c2807, KEY_UP },
+	{ 0xa10c6807, KEY_DOWN },
+	{ 0xa10ce807, KEY_LEFT },
+	{ 0xa10ca807, KEY_RIGHT },
+
+	{ 0xa10c1807, KEY_SCROLLDOWN },	/* Red Thumbs Down */
+	{ 0xa10c9807, KEY_SELECT },
+	{ 0xa10c5807, KEY_SCROLLUP },	/* Green Thumbs Up */
+
+	{ 0xa10c3807, KEY_VOLUMEUP },
+	{ 0xa10cb807, KEY_VOLUMEDOWN },
+	{ 0xa10cd807, KEY_MUTE },
+	{ 0xa10c040b, KEY_RECORD },
+	{ 0xa10c7807, KEY_CHANNELUP },
+	{ 0xa10cf807, KEY_CHANNELDOWN },
+	{ 0x0085301f, KEY_CHANNELDOWN },
+
+	{ 0xa10c840b, KEY_PLAY },
+	{ 0xa10cc40b, KEY_PAUSE },
+	{ 0xa10ca40b, KEY_SLOW },
+	{ 0xa10c440b, KEY_REWIND },
+	{ 0xa10c240b, KEY_FASTFORWARD },
+	{ 0xa10c640b, KEY_PREVIOUS },
+	{ 0xa10ce40b, KEY_NEXT },	/* ->| */
+
+	{ 0xa10c220d, KEY_ZOOM },	/* Aspect */
+	{ 0xa10c120d, KEY_STOP },
+	{ 0xa10c520d, KEY_DVD },	/* DVD Menu */
+
+	{ 0xa10c140b, KEY_NUMERIC_1 },
+	{ 0xa10c940b, KEY_NUMERIC_2 },
+	{ 0xa10c540b, KEY_NUMERIC_3 },
+	{ 0xa10cd40b, KEY_NUMERIC_4 },
+	{ 0xa10c340b, KEY_NUMERIC_5 },
+	{ 0xa10cb40b, KEY_NUMERIC_6 },
+	{ 0xa10c740b, KEY_NUMERIC_7 },
+	{ 0xa10cf40b, KEY_NUMERIC_8 },
+	{ 0x0085302f, KEY_NUMERIC_8 },
+	{ 0xa10c0c03, KEY_NUMERIC_9 },
+	{ 0xa10c8c03, KEY_NUMERIC_0 },
+	{ 0xa10ccc03, KEY_ENTER },
+	{ 0xa10c4c03, KEY_CLEAR },
+};
+
+static struct rc_map_list tivo_map = {
+	.map = {
+		.scan    = tivo,
+		.size    = ARRAY_SIZE(tivo),
+		.rc_type = RC_TYPE_NEC,
+		.name    = RC_MAP_TIVO,
+	}
+};
+
+static int __init init_rc_map_tivo(void)
+{
+	return rc_map_register(&tivo_map);
+}
+
+static void __exit exit_rc_map_tivo(void)
+{
+	rc_map_unregister(&tivo_map);
+}
+
+module_init(init_rc_map_tivo)
+module_exit(exit_rc_map_tivo)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 9184751..4e1409e 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -136,6 +136,7 @@ void rc_map_init(void);
 #define RC_MAP_TERRATEC_SLIM             "rc-terratec-slim"
 #define RC_MAP_TERRATEC_SLIM_2           "rc-terratec-slim-2"
 #define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
+#define RC_MAP_TIVO                      "rc-tivo"
 #define RC_MAP_TOTAL_MEDIA_IN_HAND       "rc-total-media-in-hand"
 #define RC_MAP_TREKSTOR                  "rc-trekstor"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
-- 
1.7.1

