Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab0E1UD0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 16:03:26 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4SK3P5E002184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 28 May 2010 16:03:25 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o4SK3PnF005281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 28 May 2010 16:03:25 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o4SK3O2f007411
	for <linux-media@vger.kernel.org>; Fri, 28 May 2010 16:03:24 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o4SK3Omv007409
	for linux-media@vger.kernel.org; Fri, 28 May 2010 16:03:24 -0400
Date: Fri, 28 May 2010 16:03:24 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] IR: add RC6 keymap for Windows Media Center Ed. remotes
Message-ID: <20100528200324.GA7397@redhat.com>
References: <20100528200218.GA7313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528200218.GA7313@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the RC6 keymap for the Windows Media Center Edition remotes
that come bundled with MCE/eHome Infrared Remote transceivers. Tested
with 3 different variants of the remote, but its possible there are
still some additional keys missing, but its simple enough to add them
in later...

This patch also adds an IR_TYPE_ALL convenience macro to make life
easier for receivers that support all IR protocols.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/media/IR/keymaps/Makefile     |    1 +
 drivers/media/IR/keymaps/rc-rc6-mce.c |  106 +++++++++++++++++++++++++++++++++
 include/media/rc-map.h                |    4 +
 3 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index ec25258..08e5a10 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-pv951.o \
 			rc-rc5-hauppauge-new.o \
 			rc-rc5-tv.o \
+			rc-rc6-mce.o \
 			rc-real-audio-220-32-keys.o \
 			rc-tbs-nec.o \
 			rc-terratec-cinergy-xs.o \
diff --git a/drivers/media/IR/keymaps/rc-rc6-mce.c b/drivers/media/IR/keymaps/rc-rc6-mce.c
new file mode 100644
index 0000000..0df1875
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-rc6-mce.c
@@ -0,0 +1,106 @@
+/* rc-rc6-mce.c - Keytable for Windows Media Center RC-6 remotes for use
+ * with the Media Center Edition eHome Infrared Transceiver.
+ *
+ * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+/* mce-mode imon mce remote key table */
+static struct ir_scancode rc6_mce[] = {
+	{ 0x800f0415, KEY_REWIND },
+	{ 0x800f0414, KEY_FASTFORWARD },
+	{ 0x800f041b, KEY_PREVIOUS },
+	{ 0x800f041a, KEY_NEXT },
+
+	{ 0x800f0416, KEY_PLAY },
+	{ 0x800f0418, KEY_PAUSE },
+	{ 0x800f0419, KEY_STOP },
+	{ 0x800f0417, KEY_RECORD },
+
+	{ 0x800f041e, KEY_UP },
+	{ 0x800f041f, KEY_DOWN },
+	{ 0x800f0420, KEY_LEFT },
+	{ 0x800f0421, KEY_RIGHT },
+
+	{ 0x800f040b, KEY_ENTER },
+	{ 0x800f0422, KEY_OK },
+	{ 0x800f0423, KEY_EXIT },
+	{ 0x800f040a, KEY_DELETE },
+
+	{ 0x800f040e, KEY_MUTE },
+	{ 0x800f0410, KEY_VOLUMEUP },
+	{ 0x800f0411, KEY_VOLUMEDOWN },
+	{ 0x800f0412, KEY_CHANNELUP },
+	{ 0x800f0413, KEY_CHANNELDOWN },
+
+	{ 0x800f0401, KEY_NUMERIC_1 },
+	{ 0x800f0402, KEY_NUMERIC_2 },
+	{ 0x800f0403, KEY_NUMERIC_3 },
+	{ 0x800f0404, KEY_NUMERIC_4 },
+	{ 0x800f0405, KEY_NUMERIC_5 },
+	{ 0x800f0406, KEY_NUMERIC_6 },
+	{ 0x800f0407, KEY_NUMERIC_7 },
+	{ 0x800f0408, KEY_NUMERIC_8 },
+	{ 0x800f0409, KEY_NUMERIC_9 },
+	{ 0x800f0400, KEY_NUMERIC_0 },
+
+	{ 0x800f041d, KEY_NUMERIC_STAR },
+	{ 0x800f041c, KEY_NUMERIC_POUND },
+
+	{ 0x800f0446, KEY_TV },
+	{ 0x800f0447, KEY_AUDIO }, /* My Music */
+	{ 0x800f0448, KEY_PVR }, /* RecordedTV */
+	{ 0x800f0449, KEY_CAMERA },
+	{ 0x800f044a, KEY_VIDEO },
+	{ 0x800f0424, KEY_DVD },
+	{ 0x800f0425, KEY_TUNER }, /* LiveTV */
+	{ 0x800f0450, KEY_RADIO },
+
+	{ 0x800f044c, KEY_LANGUAGE },
+	{ 0x800f0427, KEY_ZOOM }, /* Aspect */
+
+	{ 0x800f045b, KEY_RED },
+	{ 0x800f045c, KEY_GREEN },
+	{ 0x800f045d, KEY_YELLOW },
+	{ 0x800f045e, KEY_BLUE },
+
+	{ 0x800f040f, KEY_INFO },
+	{ 0x800f0426, KEY_EPG }, /* Guide */
+	{ 0x800f045a, KEY_SUBTITLE }, /* Caption/Teletext */
+	{ 0x800f044d, KEY_TITLE },
+
+	{ 0x800f040c, KEY_POWER },
+	{ 0x800f040d, KEY_PROG1 }, /* Windows MCE button */
+
+};
+
+static struct rc_keymap rc6_mce_map = {
+	.map = {
+		.scan    = rc6_mce,
+		.size    = ARRAY_SIZE(rc6_mce),
+		.ir_type = IR_TYPE_RC6,
+		.name    = RC_MAP_RC6_MCE,
+	}
+};
+
+static int __init init_rc_map_rc6_mce(void)
+{
+	return ir_register_map(&rc6_mce_map);
+}
+
+static void __exit exit_rc_map_rc6_mce(void)
+{
+	ir_unregister_map(&rc6_mce_map);
+}
+
+module_init(init_rc_map_rc6_mce)
+module_exit(exit_rc_map_rc6_mce)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 5833966..9a82f10 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -19,6 +19,9 @@
 #define IR_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
 #define IR_TYPE_OTHER	(1u << 31)
 
+#define IR_TYPE_ALL (IR_TYPE_RC5 | IR_TYPE_NEC  | IR_TYPE_RC6 | \
+		     IR_TYPE_JVC | IR_TYPE_SONY | IR_TYPE_OTHER)
+
 struct ir_scancode {
 	u32	scancode;
 	u32	keycode;
@@ -106,6 +109,7 @@ void rc_map_init(void);
 #define RC_MAP_PV951                     "rc-pv951"
 #define RC_MAP_RC5_HAUPPAUGE_NEW         "rc-rc5-hauppauge-new"
 #define RC_MAP_RC5_TV                    "rc-rc5-tv"
+#define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"


-- 
Jarod Wilson
jarod@redhat.com

