Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0HACyP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 22:54:15 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o712sEf5007985
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:54:15 -0400
Received: from pedra (vpn-10-93.rdu.redhat.com [10.11.10.93])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o712rkwI027490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:54:12 -0400
Date: Sat, 31 Jul 2010 23:54:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/7] V4L/DVB: Add a keymap file with dib0700 table
Message-ID: <20100731235406.507ec8aa@pedra>
In-Reply-To: <cover.1280630041.git.mchehab@redhat.com>
References: <cover.1280630041.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/IR/keymaps/rc-dib0700-big.c

diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 86d3d1f..85330d1 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-budget-ci-old.o \
 			rc-cinergy-1400.o \
 			rc-cinergy.o \
+			rc-dib0700-big.o \
 			rc-dm1105-nec.o \
 			rc-dntv-live-dvb-t.o \
 			rc-dntv-live-dvbt-pro.o \
diff --git a/drivers/media/IR/keymaps/rc-dib0700-big.c b/drivers/media/IR/keymaps/rc-dib0700-big.c
new file mode 100644
index 0000000..2e83820
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-dib0700-big.c
@@ -0,0 +1,314 @@
+/* rc-dvb0700-big.c - Keytable for devices in dvb0700
+ *
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * TODO: This table is a real mess, as it merges RC codes from several
+ * devices into a big table. It also has both RC-5 and NEC codes inside.
+ * It should be broken into small tables, and the protocols should properly
+ * be indentificated.
+ *
+ * The table were imported from dib0700_devices.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct ir_scancode dib0700_table[] = {
+	/* Key codes for the tiny Pinnacle remote*/
+	{ 0x0700, KEY_MUTE },
+	{ 0x0701, KEY_MENU }, /* Pinnacle logo */
+	{ 0x0739, KEY_POWER },
+	{ 0x0703, KEY_VOLUMEUP },
+	{ 0x0709, KEY_VOLUMEDOWN },
+	{ 0x0706, KEY_CHANNELUP },
+	{ 0x070c, KEY_CHANNELDOWN },
+	{ 0x070f, KEY_1 },
+	{ 0x0715, KEY_2 },
+	{ 0x0710, KEY_3 },
+	{ 0x0718, KEY_4 },
+	{ 0x071b, KEY_5 },
+	{ 0x071e, KEY_6 },
+	{ 0x0711, KEY_7 },
+	{ 0x0721, KEY_8 },
+	{ 0x0712, KEY_9 },
+	{ 0x0727, KEY_0 },
+	{ 0x0724, KEY_SCREEN }, /* 'Square' key */
+	{ 0x072a, KEY_TEXT },   /* 'T' key */
+	{ 0x072d, KEY_REWIND },
+	{ 0x0730, KEY_PLAY },
+	{ 0x0733, KEY_FASTFORWARD },
+	{ 0x0736, KEY_RECORD },
+	{ 0x073c, KEY_STOP },
+	{ 0x073f, KEY_CANCEL }, /* '?' key */
+	/* Key codes for the Terratec Cinergy DT XS Diversity, similar to cinergyT2.c */
+	{ 0xeb01, KEY_POWER },
+	{ 0xeb02, KEY_1 },
+	{ 0xeb03, KEY_2 },
+	{ 0xeb04, KEY_3 },
+	{ 0xeb05, KEY_4 },
+	{ 0xeb06, KEY_5 },
+	{ 0xeb07, KEY_6 },
+	{ 0xeb08, KEY_7 },
+	{ 0xeb09, KEY_8 },
+	{ 0xeb0a, KEY_9 },
+	{ 0xeb0b, KEY_VIDEO },
+	{ 0xeb0c, KEY_0 },
+	{ 0xeb0d, KEY_REFRESH },
+	{ 0xeb0f, KEY_EPG },
+	{ 0xeb10, KEY_UP },
+	{ 0xeb11, KEY_LEFT },
+	{ 0xeb12, KEY_OK },
+	{ 0xeb13, KEY_RIGHT },
+	{ 0xeb14, KEY_DOWN },
+	{ 0xeb16, KEY_INFO },
+	{ 0xeb17, KEY_RED },
+	{ 0xeb18, KEY_GREEN },
+	{ 0xeb19, KEY_YELLOW },
+	{ 0xeb1a, KEY_BLUE },
+	{ 0xeb1b, KEY_CHANNELUP },
+	{ 0xeb1c, KEY_VOLUMEUP },
+	{ 0xeb1d, KEY_MUTE },
+	{ 0xeb1e, KEY_VOLUMEDOWN },
+	{ 0xeb1f, KEY_CHANNELDOWN },
+	{ 0xeb40, KEY_PAUSE },
+	{ 0xeb41, KEY_HOME },
+	{ 0xeb42, KEY_MENU }, /* DVD Menu */
+	{ 0xeb43, KEY_SUBTITLE },
+	{ 0xeb44, KEY_TEXT }, /* Teletext */
+	{ 0xeb45, KEY_DELETE },
+	{ 0xeb46, KEY_TV },
+	{ 0xeb47, KEY_DVD },
+	{ 0xeb48, KEY_STOP },
+	{ 0xeb49, KEY_VIDEO },
+	{ 0xeb4a, KEY_AUDIO }, /* Music */
+	{ 0xeb4b, KEY_SCREEN }, /* Pic */
+	{ 0xeb4c, KEY_PLAY },
+	{ 0xeb4d, KEY_BACK },
+	{ 0xeb4e, KEY_REWIND },
+	{ 0xeb4f, KEY_FASTFORWARD },
+	{ 0xeb54, KEY_PREVIOUS },
+	{ 0xeb58, KEY_RECORD },
+	{ 0xeb5c, KEY_NEXT },
+
+	/* Key codes for the Haupauge WinTV Nova-TD, copied from nova-t-usb2.c (Nova-T USB2) */
+	{ 0x1e00, KEY_0 },
+	{ 0x1e01, KEY_1 },
+	{ 0x1e02, KEY_2 },
+	{ 0x1e03, KEY_3 },
+	{ 0x1e04, KEY_4 },
+	{ 0x1e05, KEY_5 },
+	{ 0x1e06, KEY_6 },
+	{ 0x1e07, KEY_7 },
+	{ 0x1e08, KEY_8 },
+	{ 0x1e09, KEY_9 },
+	{ 0x1e0a, KEY_KPASTERISK },
+	{ 0x1e0b, KEY_RED },
+	{ 0x1e0c, KEY_RADIO },
+	{ 0x1e0d, KEY_MENU },
+	{ 0x1e0e, KEY_GRAVE }, /* # */
+	{ 0x1e0f, KEY_MUTE },
+	{ 0x1e10, KEY_VOLUMEUP },
+	{ 0x1e11, KEY_VOLUMEDOWN },
+	{ 0x1e12, KEY_CHANNEL },
+	{ 0x1e14, KEY_UP },
+	{ 0x1e15, KEY_DOWN },
+	{ 0x1e16, KEY_LEFT },
+	{ 0x1e17, KEY_RIGHT },
+	{ 0x1e18, KEY_VIDEO },
+	{ 0x1e19, KEY_AUDIO },
+	{ 0x1e1a, KEY_MEDIA },
+	{ 0x1e1b, KEY_EPG },
+	{ 0x1e1c, KEY_TV },
+	{ 0x1e1e, KEY_NEXT },
+	{ 0x1e1f, KEY_BACK },
+	{ 0x1e20, KEY_CHANNELUP },
+	{ 0x1e21, KEY_CHANNELDOWN },
+	{ 0x1e24, KEY_LAST }, /* Skip backwards */
+	{ 0x1e25, KEY_OK },
+	{ 0x1e29, KEY_BLUE},
+	{ 0x1e2e, KEY_GREEN },
+	{ 0x1e30, KEY_PAUSE },
+	{ 0x1e32, KEY_REWIND },
+	{ 0x1e34, KEY_FASTFORWARD },
+	{ 0x1e35, KEY_PLAY },
+	{ 0x1e36, KEY_STOP },
+	{ 0x1e37, KEY_RECORD },
+	{ 0x1e38, KEY_YELLOW },
+	{ 0x1e3b, KEY_GOTO },
+	{ 0x1e3d, KEY_POWER },
+
+	/* Key codes for the Leadtek Winfast DTV Dongle */
+	{ 0x0042, KEY_POWER },
+	{ 0x077c, KEY_TUNER },
+	{ 0x0f4e, KEY_PRINT }, /* PREVIEW */
+	{ 0x0840, KEY_SCREEN }, /* full screen toggle*/
+	{ 0x0f71, KEY_DOT }, /* frequency */
+	{ 0x0743, KEY_0 },
+	{ 0x0c41, KEY_1 },
+	{ 0x0443, KEY_2 },
+	{ 0x0b7f, KEY_3 },
+	{ 0x0e41, KEY_4 },
+	{ 0x0643, KEY_5 },
+	{ 0x097f, KEY_6 },
+	{ 0x0d7e, KEY_7 },
+	{ 0x057c, KEY_8 },
+	{ 0x0a40, KEY_9 },
+	{ 0x0e4e, KEY_CLEAR },
+	{ 0x047c, KEY_CHANNEL }, /* show channel number */
+	{ 0x0f41, KEY_LAST }, /* recall */
+	{ 0x0342, KEY_MUTE },
+	{ 0x064c, KEY_RESERVED }, /* PIP button*/
+	{ 0x0172, KEY_SHUFFLE }, /* SNAPSHOT */
+	{ 0x0c4e, KEY_PLAYPAUSE }, /* TIMESHIFT */
+	{ 0x0b70, KEY_RECORD },
+	{ 0x037d, KEY_VOLUMEUP },
+	{ 0x017d, KEY_VOLUMEDOWN },
+	{ 0x0242, KEY_CHANNELUP },
+	{ 0x007d, KEY_CHANNELDOWN },
+
+	/* Key codes for Nova-TD "credit card" remote control. */
+	{ 0x1d00, KEY_0 },
+	{ 0x1d01, KEY_1 },
+	{ 0x1d02, KEY_2 },
+	{ 0x1d03, KEY_3 },
+	{ 0x1d04, KEY_4 },
+	{ 0x1d05, KEY_5 },
+	{ 0x1d06, KEY_6 },
+	{ 0x1d07, KEY_7 },
+	{ 0x1d08, KEY_8 },
+	{ 0x1d09, KEY_9 },
+	{ 0x1d0a, KEY_TEXT },
+	{ 0x1d0d, KEY_MENU },
+	{ 0x1d0f, KEY_MUTE },
+	{ 0x1d10, KEY_VOLUMEUP },
+	{ 0x1d11, KEY_VOLUMEDOWN },
+	{ 0x1d12, KEY_CHANNEL },
+	{ 0x1d14, KEY_UP },
+	{ 0x1d15, KEY_DOWN },
+	{ 0x1d16, KEY_LEFT },
+	{ 0x1d17, KEY_RIGHT },
+	{ 0x1d1c, KEY_TV },
+	{ 0x1d1e, KEY_NEXT },
+	{ 0x1d1f, KEY_BACK },
+	{ 0x1d20, KEY_CHANNELUP },
+	{ 0x1d21, KEY_CHANNELDOWN },
+	{ 0x1d24, KEY_LAST },
+	{ 0x1d25, KEY_OK },
+	{ 0x1d30, KEY_PAUSE },
+	{ 0x1d32, KEY_REWIND },
+	{ 0x1d34, KEY_FASTFORWARD },
+	{ 0x1d35, KEY_PLAY },
+	{ 0x1d36, KEY_STOP },
+	{ 0x1d37, KEY_RECORD },
+	{ 0x1d3b, KEY_GOTO },
+	{ 0x1d3d, KEY_POWER },
+
+	/* Key codes for the Pixelview SBTVD remote (proto NEC) */
+	{ 0x8613, KEY_MUTE },
+	{ 0x8612, KEY_POWER },
+	{ 0x8601, KEY_1 },
+	{ 0x8602, KEY_2 },
+	{ 0x8603, KEY_3 },
+	{ 0x8604, KEY_4 },
+	{ 0x8605, KEY_5 },
+	{ 0x8606, KEY_6 },
+	{ 0x8607, KEY_7 },
+	{ 0x8608, KEY_8 },
+	{ 0x8609, KEY_9 },
+	{ 0x8600, KEY_0 },
+	{ 0x860d, KEY_CHANNELUP },
+	{ 0x8619, KEY_CHANNELDOWN },
+	{ 0x8610, KEY_VOLUMEUP },
+	{ 0x860c, KEY_VOLUMEDOWN },
+
+	{ 0x860a, KEY_CAMERA },
+	{ 0x860b, KEY_ZOOM },
+	{ 0x861b, KEY_BACKSPACE },
+	{ 0x8615, KEY_ENTER },
+
+	{ 0x861d, KEY_UP },
+	{ 0x861e, KEY_DOWN },
+	{ 0x860e, KEY_LEFT },
+	{ 0x860f, KEY_RIGHT },
+
+	{ 0x8618, KEY_RECORD },
+	{ 0x861a, KEY_STOP },
+
+	/* Key codes for the EvolutePC TVWay+ remote (proto NEC) */
+	{ 0x7a00, KEY_MENU },
+	{ 0x7a01, KEY_RECORD },
+	{ 0x7a02, KEY_PLAY },
+	{ 0x7a03, KEY_STOP },
+	{ 0x7a10, KEY_CHANNELUP },
+	{ 0x7a11, KEY_CHANNELDOWN },
+	{ 0x7a12, KEY_VOLUMEUP },
+	{ 0x7a13, KEY_VOLUMEDOWN },
+	{ 0x7a40, KEY_POWER },
+	{ 0x7a41, KEY_MUTE },
+
+	/* Key codes for the Elgato EyeTV Diversity silver remote,
+	   set dvb_usb_dib0700_ir_proto=0 */
+	{ 0x4501, KEY_POWER },
+	{ 0x4502, KEY_MUTE },
+	{ 0x4503, KEY_1 },
+	{ 0x4504, KEY_2 },
+	{ 0x4505, KEY_3 },
+	{ 0x4506, KEY_4 },
+	{ 0x4507, KEY_5 },
+	{ 0x4508, KEY_6 },
+	{ 0x4509, KEY_7 },
+	{ 0x450a, KEY_8 },
+	{ 0x450b, KEY_9 },
+	{ 0x450c, KEY_LAST },
+	{ 0x450d, KEY_0 },
+	{ 0x450e, KEY_ENTER },
+	{ 0x450f, KEY_RED },
+	{ 0x4510, KEY_CHANNELUP },
+	{ 0x4511, KEY_GREEN },
+	{ 0x4512, KEY_VOLUMEDOWN },
+	{ 0x4513, KEY_OK },
+	{ 0x4514, KEY_VOLUMEUP },
+	{ 0x4515, KEY_YELLOW },
+	{ 0x4516, KEY_CHANNELDOWN },
+	{ 0x4517, KEY_BLUE },
+	{ 0x4518, KEY_LEFT }, /* Skip backwards */
+	{ 0x4519, KEY_PLAYPAUSE },
+	{ 0x451a, KEY_RIGHT }, /* Skip forward */
+	{ 0x451b, KEY_REWIND },
+	{ 0x451c, KEY_L }, /* Live */
+	{ 0x451d, KEY_FASTFORWARD },
+	{ 0x451e, KEY_STOP }, /* 'Reveal' for Teletext */
+	{ 0x451f, KEY_MENU }, /* KEY_TEXT for Teletext */
+	{ 0x4540, KEY_RECORD }, /* Font 'Size' for Teletext */
+	{ 0x4541, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
+	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
+};
+
+static struct rc_keymap dib0700_map = {
+	.map = {
+		.scan    = dib0700_table,
+		.size    = ARRAY_SIZE(dib0700_table),
+		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_DIB0700_BIG_TABLE,
+	}
+};
+
+static int __init init_rc_map(void)
+{
+	return ir_register_map(&dib0700_map);
+}
+
+static void __exit exit_rc_map(void)
+{
+	ir_unregister_map(&dib0700_map);
+}
+
+module_init(init_rc_map)
+module_exit(exit_rc_map)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index a329858..adbcccb 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -69,6 +69,9 @@ void rc_map_init(void);
 #define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
 #define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
 #define RC_MAP_CINERGY                   "rc-cinergy"
+/* Temporary table - should be broken into smaller tables */
+#define RC_MAP_DIB0700_BIG_TABLE         "rc-dib0700-big"
+
 #define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
 #define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
 #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
@@ -123,6 +126,7 @@ void rc_map_init(void);
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
+
 /*
  * Please, do not just append newer Remote Controller names at the end.
  * The names should be ordered in alphabetical order
-- 
1.7.1


