Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49630 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAVQFP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 11:05:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIL00GPY60PY220@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jan 2015 01:05:13 +0900 (KST)
Content-transfer-encoding: 8BIT
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org
Subject: =?UTF-8?q?=5BRFC=20v2=202/7=5D=20media=3A=20rc=3A=20Add=20cec=20protocol=20handling?=
Date: Thu, 22 Jan 2015 17:04:34 +0100
Message-id: <1421942679-23609-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add cec protocol handling the RC framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/rc/keymaps/Makefile |    1 +
 drivers/media/rc/keymaps/rc-cec.c |  133 +++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-main.c        |    1 +
 include/media/rc-core.h           |    1 +
 include/media/rc-map.h            |    5 +-
 5 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index abf6079..56f10d6 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-behold.o \
 			rc-behold-columbus.o \
 			rc-budget-ci-old.o \
+			rc-cec.o \
 			rc-cinergy-1400.o \
 			rc-cinergy.o \
 			rc-delock-61959.o \
diff --git a/drivers/media/rc/keymaps/rc-cec.c b/drivers/media/rc/keymaps/rc-cec.c
new file mode 100644
index 0000000..f2826c5
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-cec.c
@@ -0,0 +1,133 @@
+/* Keytable for the CEC remote control
+ *
+ * Copyright (c) 2015 by Kamil Debski
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+/* CEC Spec "High-Definition Multimedia Interface Specification" can be obtained
+ * here: http://xtreamerdev.googlecode.com/files/CEC_Specs.pdf
+ * The list of control codes is listed in Table 27: User Control Codes p. 95 */
+
+static struct rc_map_table cec[] = {
+	{ 0x00, KEY_SELECT }, /* XXX CEC Spec: Select, should it be KEY_SELECT or KEY_OK? */
+	{ 0x01, KEY_UP },
+	{ 0x02, KEY_DOWN },
+	{ 0x03, KEY_LEFT },
+	{ 0x04, KEY_RIGHT },
+	/* XXX 0x05-0x08 CEC Spec: Right-Up, Right-Down, Left-Up, Left-Down */
+	{ 0x09, KEY_CONTEXT_MENU }, /* CEC Spec: Root Menu - see Note 2 */
+	/* Note 2: This is the initial display that a device shows. It is
+	 * device-dependent and can be, for example, a contents menu, setup
+	 * menu, favorite menu or other menu. The actual menu displayed
+	 * may also depend on the device’s current state. */
+	{ 0x0a, KEY_SETUP },
+	{ 0x0b, KEY_MENU }, /* CEC Spec: Contents Menu */
+	{ 0x0c, KEY_FAVORITES }, /* CEC Spec: Favorite Menu */
+	{ 0x0d, KEY_EXIT },
+	/* 0x0e-0x1f: Reserved */
+	/* 0x20-0x29: Keys 0 to 9 */
+	{ 0x20, KEY_0 },
+	{ 0x21, KEY_1 },
+	{ 0x22, KEY_2 },
+	{ 0x23, KEY_3 },
+	{ 0x24, KEY_4 },
+	{ 0x25, KEY_5 },
+	{ 0x26, KEY_6 },
+	{ 0x27, KEY_7 },
+	{ 0x28, KEY_8 },
+	{ 0x29, KEY_9 },
+	{ 0x2a, KEY_DOT },
+	{ 0x2b, KEY_ENTER },
+	{ 0x2c, KEY_CLEAR },
+	/* 0x2d-0x2e: Reserved */
+	/* XXX 0x2f: CEC Spec: Next Favorite */
+	{ 0x30, KEY_CHANNELUP },
+	{ 0x31, KEY_CHANNELDOWN },
+	{ 0x32, KEY_PREVIOUS }, /* CEC Spec: Previous Channel */
+	{ 0x33, KEY_SOUND }, /* CEC Spec: Sound Select */
+	/* XXX 0x34: CEC Spec: Input Select */
+	{ 0x35, KEY_INFO }, /* CEC Spec: Display Information */
+	{ 0x36, KEY_HELP },
+	{ 0x37, KEY_PAGEUP },
+	{ 0x38, KEY_PAGEDOWN },
+	/* 0x39-0x3f: Reserved */
+	{ 0x40, KEY_POWER },
+	{ 0x41, KEY_VOLUMEUP },
+	{ 0x42, KEY_VOLUMEDOWN },
+	{ 0x43, KEY_MUTE },
+	{ 0x44, KEY_PLAY },
+	{ 0x45, KEY_STOP }, /* XXX CEC Spec: Stop, what about KEY_STOPCD? */
+	{ 0x46, KEY_PAUSE },/* XXX CEC Spec: Pause, what about KEY_PAUSECD? */
+	{ 0x47, KEY_RECORD },
+	{ 0x48, KEY_REWIND },
+	{ 0x49, KEY_FASTFORWARD },
+	{ 0x4a, KEY_EJECTCD }, /* CEC Spec: Eject */
+	{ 0x4b, KEY_FORWARD },
+	{ 0x4c, }, /* XXX */
+	{ 0x4d, KEY_STOP }, /* XXX CEC Spec: Stop-Record, what about KEY_STOPCD? */
+	{ 0x4e, KEY_PAUSE }, /* XXX CEC Spec: Pause-Record, what about KEY_PAUSECD? */
+	/* 0x4f: Reserved */
+	{ 0x50, KEY_ANGLE },
+	{ 0x51, KEY_SUBTITLE }, /* XXX CEC Spec: Sub picture, should it be KEY_SUBTITLE or something else? */
+	{ 0x52, KEY_VIDEO }, /* XXX CEC Spec: Video on Demand / input.h: AL Movie Browser, maybe KEY_DIRECTORY? */
+	{ 0x53, KEY_EPG },
+	{ 0x54, KEY_TIME }, /* XXX CEC Spec: Timer */
+	{ 0x55, KEY_CONFIG },
+	/* 0x56-0x5f: Reserved */
+	{ 0x60, KEY_PLAY }, /* XXX CEC Spec: Play Function */
+	{ 0x61, KEY_PLAYPAUSE }, /* XXX CEC Spec: Pause-Play Function */
+	{ 0x62, KEY_RECORD }, /* XXX CEC Spec: Record Function */
+	{ 0x63, KEY_PAUSE }, /* XXX CEC Spec: Pause-Record Function */
+	{ 0x64, KEY_STOP }, /* XXX CEC Spec: Stop Function */
+	{ 0x65, KEY_MUTE }, /* XXX CEC Spec: Mute Function */
+	/* 0x66: CEC Spec: Restore Volume Function */
+	{ 0x67, KEY_TUNER }, /* XXX CEC Spec: Tune Function */
+	{ 0x68, KEY_MEDIA }, /* CEC Spec: Select Media Function */
+	{ 0x69, KEY_SWITCHVIDEOMODE} /* XXX CEC Spec: Select A/V Input Function */,
+	{ 0x6a, KEY_AUDIO} /* CEC Spec: Select Audio Input Function */,
+	{ 0x6b, KEY_POWER} /* CEC Spec: Power Toggle Function */,
+	{ 0x6c, KEY_SLEEP} /* XXX CEC Spec: Power Off Function */,
+	{ 0x6d, KEY_WAKEUP} /* XXX CEC Spec: Power On Function */,
+	/* 0x6e-0x70: Reserved */
+	{ 0x71, KEY_BLUE }, /* XXX CEC Spec: F1 (Blue) */
+	{ 0x72, KEY_RED }, /* XXX CEC Spec: F2 (Red) */
+	{ 0x73, KEY_GREEN }, /* XXX CEC Spec: F3 (Green) */
+	{ 0x74, KEY_YELLOW }, /* XXX CEC Spec: F4 (Yellow) */
+	{ 0x75, KEY_F5 },
+	{ 0x76, KEY_CONNECT }, /* XXX CEC Spec: Data - see Note 3 */
+	/* Note 3: This is used, for example, to enter or leave a digital TV
+	 * data broadcast application. */
+	/* 0x77-0xff: Reserved */
+};
+
+static struct rc_map_list cec_map = {
+	.map = {
+		.scan		= cec,
+		.size		= ARRAY_SIZE(cec),
+		.rc_type	= RC_TYPE_CEC,
+		.name		= RC_MAP_CEC,
+	}
+};
+
+static int __init init_rc_map_cec(void)
+{
+	return rc_map_register(&cec_map);
+}
+
+static void __exit exit_rc_map_cec(void)
+{
+	rc_map_unregister(&cec_map);
+}
+
+module_init(init_rc_map_cec);
+module_exit(exit_rc_map_cec);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kamil Debski");
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f8c5e47..37d1ce0 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -801,6 +801,7 @@ static struct {
 	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
 	{ RC_BIT_LIRC,		"lirc"		},
 	{ RC_BIT_XMP,		"xmp"		},
+	{ RC_BIT_CEC,		"cec"		},
 };
 
 /**
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 2c7fbca..7c9d15d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -32,6 +32,7 @@ do {								\
 enum rc_driver_type {
 	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
 	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
+	RC_DRIVER_CEC,
 };
 
 /**
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e7a1514..2058a89 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -32,6 +32,7 @@ enum rc_type {
 	RC_TYPE_RC6_MCE		= 17,	/* MCE (Philips RC6-6A-32 subtype) protocol */
 	RC_TYPE_SHARP		= 18,	/* Sharp protocol */
 	RC_TYPE_XMP		= 19,	/* XMP protocol */
+	RC_TYPE_CEC		= 20,	/* CEC protocol */
 };
 
 #define RC_BIT_NONE		0
@@ -55,6 +56,7 @@ enum rc_type {
 #define RC_BIT_RC6_MCE		(1 << RC_TYPE_RC6_MCE)
 #define RC_BIT_SHARP		(1 << RC_TYPE_SHARP)
 #define RC_BIT_XMP		(1 << RC_TYPE_XMP)
+#define RC_BIT_CEC		(1 << RC_TYPE_CEC)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_LIRC | \
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
@@ -63,7 +65,7 @@ enum rc_type {
 			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
-			 RC_BIT_XMP)
+			 RC_BIT_XMP | RC_BIT_CEC)
 
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
@@ -125,6 +127,7 @@ void rc_map_init(void);
 #define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
 #define RC_MAP_BEHOLD                    "rc-behold"
 #define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
+#define RC_MAP_CEC                       "rc-cec"
 #define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
 #define RC_MAP_CINERGY                   "rc-cinergy"
 #define RC_MAP_DELOCK_61959              "rc-delock-61959"
-- 
1.7.9.5

