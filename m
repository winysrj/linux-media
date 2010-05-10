Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:35748 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0EJSpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 14:45:47 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134: add RM-K6 remote control support for Avermedia M135A
Date: Mon, 10 May 2010 15:43:31 -0300
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005101543.32067.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change adds support for one more remote control type for Avermedia
M135A (model RM-K6), shipped with Positivo machines.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/media/IR/keymaps/Makefile                  |    2 +-
 .../media/IR/keymaps/rc-avermedia-m135a-rm-jx.c    |   90 ------------
 drivers/media/IR/keymaps/rc-avermedia-m135a.c      |  147 ++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-input.c        |    2 +-
 include/media/rc-map.h                             |    2 +-
 5 files changed, 150 insertions(+), 93 deletions(-)
 delete mode 100644 drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-m135a.c

diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 585f75c..aea649f 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-avermedia.o \
 			rc-avermedia-cardbus.o \
 			rc-avermedia-dvbt.o \
-			rc-avermedia-m135a-rm-jx.o \
+			rc-avermedia-m135a.o \
 			rc-avermedia-m733a-rm-k6.o \
 			rc-avertv-303.o \
 			rc-behold.o \
diff --git a/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c b/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
deleted file mode 100644
index 101e7ea..0000000
--- a/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/* avermedia-m135a-rm-jx.h - Keytable for avermedia_m135a_rm_jx Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <media/rc-map.h>
-
-/*
- * Avermedia M135A with IR model RM-JX
- * The same codes exist on both Positivo (BR) and original IR
- * Mauro Carvalho Chehab <mchehab@infradead.org>
- */
-
-static struct ir_scancode avermedia_m135a_rm_jx[] = {
-	{ 0x0200, KEY_POWER2 },
-	{ 0x022e, KEY_DOT },		/* '.' */
-	{ 0x0201, KEY_MODE },		/* TV/FM or SOURCE */
-
-	{ 0x0205, KEY_1 },
-	{ 0x0206, KEY_2 },
-	{ 0x0207, KEY_3 },
-	{ 0x0209, KEY_4 },
-	{ 0x020a, KEY_5 },
-	{ 0x020b, KEY_6 },
-	{ 0x020d, KEY_7 },
-	{ 0x020e, KEY_8 },
-	{ 0x020f, KEY_9 },
-	{ 0x0211, KEY_0 },
-
-	{ 0x0213, KEY_RIGHT },		/* -> or L */
-	{ 0x0212, KEY_LEFT },		/* <- or R */
-
-	{ 0x0217, KEY_SLEEP },		/* Capturar Imagem or Snapshot */
-	{ 0x0210, KEY_SHUFFLE },	/* Amostra or 16 chan prev */
-
-	{ 0x0303, KEY_CHANNELUP },
-	{ 0x0302, KEY_CHANNELDOWN },
-	{ 0x021f, KEY_VOLUMEUP },
-	{ 0x021e, KEY_VOLUMEDOWN },
-	{ 0x020c, KEY_ENTER },		/* Full Screen */
-
-	{ 0x0214, KEY_MUTE },
-	{ 0x0208, KEY_AUDIO },
-
-	{ 0x0203, KEY_TEXT },		/* Teletext */
-	{ 0x0204, KEY_EPG },
-	{ 0x022b, KEY_TV2 },		/* TV2 or PIP */
-
-	{ 0x021d, KEY_RED },
-	{ 0x021c, KEY_YELLOW },
-	{ 0x0301, KEY_GREEN },
-	{ 0x0300, KEY_BLUE },
-
-	{ 0x021a, KEY_PLAYPAUSE },
-	{ 0x0219, KEY_RECORD },
-	{ 0x0218, KEY_PLAY },
-	{ 0x021b, KEY_STOP },
-};
-
-static struct rc_keymap avermedia_m135a_rm_jx_map = {
-	.map = {
-		.scan    = avermedia_m135a_rm_jx,
-		.size    = ARRAY_SIZE(avermedia_m135a_rm_jx),
-		.ir_type = IR_TYPE_NEC,
-		.name    = RC_MAP_AVERMEDIA_M135A_RM_JX,
-	}
-};
-
-static int __init init_rc_map_avermedia_m135a_rm_jx(void)
-{
-	return ir_register_map(&avermedia_m135a_rm_jx_map);
-}
-
-static void __exit exit_rc_map_avermedia_m135a_rm_jx(void)
-{
-	ir_unregister_map(&avermedia_m135a_rm_jx_map);
-}
-
-module_init(init_rc_map_avermedia_m135a_rm_jx)
-module_exit(exit_rc_map_avermedia_m135a_rm_jx)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/IR/keymaps/rc-avermedia-m135a.c b/drivers/media/IR/keymaps/rc-avermedia-m135a.c
new file mode 100644
index 0000000..e4471fb
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-avermedia-m135a.c
@@ -0,0 +1,147 @@
+/* avermedia-m135a.c - Keytable for Avermedia M135A Remote Controllers
+ *
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
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
+ * Avermedia M135A with RM-JX and RM-K6 remote controls
+ *
+ * On Avermedia M135A with IR model RM-JX, the same codes exist on both
+ * Positivo (BR) and original IR, initial version and remote control codes
+ * added by Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ * Positivo also ships Avermedia M135A with model RM-K6, extra control
+ * codes added by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
+ */
+
+static struct ir_scancode avermedia_m135a[] = {
+	/* RM-JX */
+	{ 0x0200, KEY_POWER2 },
+	{ 0x022e, KEY_DOT },		/* '.' */
+	{ 0x0201, KEY_MODE },		/* TV/FM or SOURCE */
+
+	{ 0x0205, KEY_1 },
+	{ 0x0206, KEY_2 },
+	{ 0x0207, KEY_3 },
+	{ 0x0209, KEY_4 },
+	{ 0x020a, KEY_5 },
+	{ 0x020b, KEY_6 },
+	{ 0x020d, KEY_7 },
+	{ 0x020e, KEY_8 },
+	{ 0x020f, KEY_9 },
+	{ 0x0211, KEY_0 },
+
+	{ 0x0213, KEY_RIGHT },		/* -> or L */
+	{ 0x0212, KEY_LEFT },		/* <- or R */
+
+	{ 0x0217, KEY_SLEEP },		/* Capturar Imagem or Snapshot */
+	{ 0x0210, KEY_SHUFFLE },	/* Amostra or 16 chan prev */
+
+	{ 0x0303, KEY_CHANNELUP },
+	{ 0x0302, KEY_CHANNELDOWN },
+	{ 0x021f, KEY_VOLUMEUP },
+	{ 0x021e, KEY_VOLUMEDOWN },
+	{ 0x020c, KEY_ENTER },		/* Full Screen */
+
+	{ 0x0214, KEY_MUTE },
+	{ 0x0208, KEY_AUDIO },
+
+	{ 0x0203, KEY_TEXT },		/* Teletext */
+	{ 0x0204, KEY_EPG },
+	{ 0x022b, KEY_TV2 },		/* TV2 or PIP */
+
+	{ 0x021d, KEY_RED },
+	{ 0x021c, KEY_YELLOW },
+	{ 0x0301, KEY_GREEN },
+	{ 0x0300, KEY_BLUE },
+
+	{ 0x021a, KEY_PLAYPAUSE },
+	{ 0x0219, KEY_RECORD },
+	{ 0x0218, KEY_PLAY },
+	{ 0x021b, KEY_STOP },
+
+	/* RM-K6 */
+	{ 0x0401, KEY_POWER2 },
+	{ 0x0406, KEY_MUTE },
+	{ 0x0408, KEY_MODE },     /* TV/FM */
+
+	{ 0x0409, KEY_1 },
+	{ 0x040a, KEY_2 },
+	{ 0x040b, KEY_3 },
+	{ 0x040c, KEY_4 },
+	{ 0x040d, KEY_5 },
+	{ 0x040e, KEY_6 },
+	{ 0x040f, KEY_7 },
+	{ 0x0410, KEY_8 },
+	{ 0x0411, KEY_9 },
+	{ 0x044c, KEY_DOT },      /* '.' */
+	{ 0x0412, KEY_0 },
+	{ 0x0407, KEY_REFRESH },  /* Refresh/Reload */
+
+	{ 0x0413, KEY_AUDIO },
+	{ 0x0440, KEY_SCREEN },   /* Full Screen toggle */
+	{ 0x0441, KEY_HOME },
+	{ 0x0442, KEY_BACK },
+	{ 0x0447, KEY_UP },
+	{ 0x0448, KEY_DOWN },
+	{ 0x0449, KEY_LEFT },
+	{ 0x044a, KEY_RIGHT },
+	{ 0x044b, KEY_OK },
+	{ 0x0404, KEY_VOLUMEUP },
+	{ 0x0405, KEY_VOLUMEDOWN },
+	{ 0x0402, KEY_CHANNELUP },
+	{ 0x0403, KEY_CHANNELDOWN },
+
+	{ 0x0443, KEY_RED },
+	{ 0x0444, KEY_GREEN },
+	{ 0x0445, KEY_YELLOW },
+	{ 0x0446, KEY_BLUE },
+
+	{ 0x0414, KEY_TEXT },
+	{ 0x0415, KEY_EPG },
+	{ 0x041a, KEY_TV2 },      /* PIP */
+	{ 0x041b, KEY_MHP },      /* Snapshot */
+
+	{ 0x0417, KEY_RECORD },
+	{ 0x0416, KEY_PLAYPAUSE },
+	{ 0x0418, KEY_STOP },
+	{ 0x0419, KEY_PAUSE },
+
+	{ 0x041f, KEY_PREVIOUS },
+	{ 0x041c, KEY_REWIND },
+	{ 0x041d, KEY_FORWARD },
+	{ 0x041e, KEY_NEXT },
+};
+
+static struct rc_keymap avermedia_m135a_map = {
+	.map = {
+		.scan    = avermedia_m135a,
+		.size    = ARRAY_SIZE(avermedia_m135a),
+		.ir_type = IR_TYPE_NEC,
+		.name    = RC_MAP_AVERMEDIA_M135A,
+	}
+};
+
+static int __init init_rc_map_avermedia_m135a(void)
+{
+	return ir_register_map(&avermedia_m135a_map);
+}
+
+static void __exit exit_rc_map_avermedia_m135a(void)
+{
+	ir_unregister_map(&avermedia_m135a_map);
+}
+
+module_init(init_rc_map_avermedia_m135a)
+module_exit(exit_rc_map_avermedia_m135a)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index c44e235..00fa9a9 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -656,7 +656,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		saa_setb(SAA7134_GPIO_GPSTATUS0, 0x4);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M135A:
-		ir_codes     = RC_MAP_AVERMEDIA_M135A_RM_JX;
+		ir_codes     = RC_MAP_AVERMEDIA_M135A;
 		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
 		mask_keyup   = 0x0040000;
 		mask_keycode = 0xffff;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 6f1f9f7..c78e99a 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -55,7 +55,7 @@ void rc_map_init(void);
 #define RC_MAP_AVERMEDIA_A16D            "rc-avermedia-a16d"
 #define RC_MAP_AVERMEDIA_CARDBUS         "rc-avermedia-cardbus"
 #define RC_MAP_AVERMEDIA_DVBT            "rc-avermedia-dvbt"
-#define RC_MAP_AVERMEDIA_M135A_RM_JX     "rc-avermedia-m135a-rm-jx"
+#define RC_MAP_AVERMEDIA_M135A           "rc-avermedia-m135a"
 #define RC_MAP_AVERMEDIA_M733A_RM_K6     "rc-avermedia-m733a-rm-k6"
 #define RC_MAP_AVERMEDIA                 "rc-avermedia"
 #define RC_MAP_AVERTV_303                "rc-avertv-303"
-- 
1.7.1

