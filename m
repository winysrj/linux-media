Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:29257 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbbIGNpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2015 09:45:12 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv9 06/15] rc: Add HDMI CEC protocol handling
Date: Mon,  7 Sep 2015 15:44:35 +0200
Message-Id: <345aeebe5561f8f6540f477ae160c5cbf1b0f6d5.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kamil Debski <kamil@wypas.org>

Add handling of remote control events coming from the HDMI CEC bus.
This patch includes a new keymap that maps values found in the CEC
messages to the keys pressed and released. Also, a new protocol has
been added to the core.

Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/rc/keymaps/Makefile |   1 +
 drivers/media/rc/keymaps/rc-cec.c | 174 ++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-main.c        |   1 +
 include/media/rc-core.h           |   1 +
 include/media/rc-map.h            |   5 +-
 5 files changed, 181 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index fbbd3bb..9cffcc6 100644
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
index 0000000..193cdca
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-cec.c
@@ -0,0 +1,174 @@
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
+	{ 0x00, KEY_OK },
+	{ 0x01, KEY_UP },
+	{ 0x02, KEY_DOWN },
+	{ 0x03, KEY_LEFT },
+	{ 0x04, KEY_RIGHT },
+	{ 0x05, KEY_RIGHT_UP },
+	{ 0x06, KEY_RIGHT_DOWN },
+	{ 0x07, KEY_LEFT_UP },
+	{ 0x08, KEY_LEFT_DOWN },
+	{ 0x09, KEY_ROOT_MENU }, /* CEC Spec: Device Root Menu - see Note 2 */
+	/* Note 2: This is the initial display that a device shows. It is
+	 * device-dependent and can be, for example, a contents menu, setup
+	 * menu, favorite menu or other menu. The actual menu displayed
+	 * may also depend on the device's current state. */
+	{ 0x0a, KEY_SETUP },
+	{ 0x0b, KEY_MENU }, /* CEC Spec: Contents Menu */
+	{ 0x0c, KEY_FAVORITES }, /* CEC Spec: Favorite Menu */
+	{ 0x0d, KEY_EXIT },
+	/* 0x0e-0x0f: Reserved */
+	{ 0x10, KEY_MEDIA_TOP_MENU },
+	{ 0x11, KEY_CONTEXT_MENU },
+	/* 0x12-0x1c: Reserved */
+	{ 0x1d, KEY_DIGITS }, /* CEC Spec: select/toggle a Number Entry Mode */
+	{ 0x1e, KEY_NUMERIC_11 },
+	{ 0x1f, KEY_NUMERIC_12 },
+	/* 0x20-0x29: Keys 0 to 9 */
+	{ 0x20, KEY_NUMERIC_0 },
+	{ 0x21, KEY_NUMERIC_1 },
+	{ 0x22, KEY_NUMERIC_2 },
+	{ 0x23, KEY_NUMERIC_3 },
+	{ 0x24, KEY_NUMERIC_4 },
+	{ 0x25, KEY_NUMERIC_5 },
+	{ 0x26, KEY_NUMERIC_6 },
+	{ 0x27, KEY_NUMERIC_7 },
+	{ 0x28, KEY_NUMERIC_8 },
+	{ 0x29, KEY_NUMERIC_9 },
+	{ 0x2a, KEY_DOT },
+	{ 0x2b, KEY_ENTER },
+	{ 0x2c, KEY_CLEAR },
+	/* 0x2d-0x2e: Reserved */
+	{ 0x2f, KEY_NEXT_FAVORITE }, /* CEC Spec: Next Favorite */
+	{ 0x30, KEY_CHANNELUP },
+	{ 0x31, KEY_CHANNELDOWN },
+	{ 0x32, KEY_PREVIOUS }, /* CEC Spec: Previous Channel */
+	{ 0x33, KEY_SOUND }, /* CEC Spec: Sound Select */
+	{ 0x34, KEY_VIDEO }, /* 0x34: CEC Spec: Input Select */
+	{ 0x35, KEY_INFO }, /* CEC Spec: Display Information */
+	{ 0x36, KEY_HELP },
+	{ 0x37, KEY_PAGEUP },
+	{ 0x38, KEY_PAGEDOWN },
+	/* 0x39-0x3f: Reserved */
+	{ 0x40, KEY_POWER },
+	{ 0x41, KEY_VOLUMEUP },
+	{ 0x42, KEY_VOLUMEDOWN },
+	{ 0x43, KEY_MUTE },
+	{ 0x44, KEY_PLAYCD },
+	{ 0x45, KEY_STOPCD },
+	{ 0x46, KEY_PAUSECD },
+	{ 0x47, KEY_RECORD },
+	{ 0x48, KEY_REWIND },
+	{ 0x49, KEY_FASTFORWARD },
+	{ 0x4a, KEY_EJECTCD }, /* CEC Spec: Eject */
+	{ 0x4b, KEY_FORWARD },
+	{ 0x4c, KEY_BACK },
+	{ 0x4d, KEY_STOP_RECORD }, /* CEC Spec: Stop-Record */
+	{ 0x4e, KEY_PAUSE_RECORD }, /* CEC Spec: Pause-Record */
+	/* 0x4f: Reserved */
+	{ 0x50, KEY_ANGLE },
+	{ 0x51, KEY_TV2 },
+	{ 0x52, KEY_VOD }, /* CEC Spec: Video on Demand */
+	{ 0x53, KEY_EPG },
+	{ 0x54, KEY_TIME }, /* CEC Spec: Timer */
+	{ 0x55, KEY_CONFIG },
+	/* The following codes are hard to implement at this moment, as they
+	 * carry an additional additional argument. Most likely changes to RC
+	 * framework are necessary.
+	 * For now they are interpreted by the CEC framework as non keycodes
+	 * and are passed as messages enabling user application to parse them.
+	 * */
+	/* 0x56: CEC Spec: Select Broadcast Type */
+	/* 0x57: CEC Spec: Select Sound presentation */
+	{ 0x58, KEY_AUDIO_DESC }, /* CEC 2.0 and up */
+	{ 0x59, KEY_WWW }, /* CEC 2.0 and up */
+	{ 0x5a, KEY_3D_MODE }, /* CEC 2.0 and up */
+	/* 0x5b-0x5f: Reserved */
+	{ 0x60, KEY_PLAYCD }, /* CEC Spec: Play Function */
+	{ 0x6005, KEY_FASTFORWARD },
+	{ 0x6006, KEY_FASTFORWARD },
+	{ 0x6007, KEY_FASTFORWARD },
+	{ 0x6015, KEY_SLOW },
+	{ 0x6016, KEY_SLOW },
+	{ 0x6017, KEY_SLOW },
+	{ 0x6009, KEY_FASTREVERSE },
+	{ 0x600a, KEY_FASTREVERSE },
+	{ 0x600b, KEY_FASTREVERSE },
+	{ 0x6019, KEY_SLOWREVERSE },
+	{ 0x601a, KEY_SLOWREVERSE },
+	{ 0x601b, KEY_SLOWREVERSE },
+	{ 0x6020, KEY_REWIND },
+	{ 0x6024, KEY_PLAYCD },
+	{ 0x6025, KEY_PAUSECD },
+	{ 0x61, KEY_PLAYPAUSE }, /* CEC Spec: Pause-Play Function */
+	{ 0x62, KEY_RECORD }, /* Spec: Record Function */
+	{ 0x63, KEY_PAUSE_RECORD }, /* CEC Spec: Pause-Record Function */
+	{ 0x64, KEY_STOPCD }, /* CEC Spec: Stop Function */
+	{ 0x65, KEY_MUTE }, /* CEC Spec: Mute Function */
+	{ 0x66, KEY_UNMUTE }, /* CEC Spec: Restore the volume */
+	/* The following codes are hard to implement at this moment, as they
+	 * carry an additional additional argument. Most likely changes to RC
+	 * framework are necessary.
+	 * For now they are interpreted by the CEC framework as non keycodes
+	 * and are passed as messages enabling user application to parse them.
+	 * */
+	/* 0x67: CEC Spec: Tune Function */
+	/* 0x68: CEC Spec: Seleect Media Function */
+	/* 0x69: CEC Spec: Select A/V Input Function */
+	/* 0x6a: CEC Spec: Select Audio Input Function */
+	{ 0x6b, KEY_POWER }, /* CEC Spec: Power Toggle Function */
+	{ 0x6c, KEY_SLEEP }, /* CEC Spec: Power Off Function */
+	{ 0x6d, KEY_WAKEUP }, /* CEC Spec: Power On Function */
+	/* 0x6e-0x70: Reserved */
+	{ 0x71, KEY_BLUE }, /* CEC Spec: F1 (Blue) */
+	{ 0x72, KEY_RED }, /* CEC Spec: F2 (Red) */
+	{ 0x73, KEY_GREEN }, /* CEC Spec: F3 (Green) */
+	{ 0x74, KEY_YELLOW }, /* CEC Spec: F4 (Yellow) */
+	{ 0x75, KEY_F5 },
+	{ 0x76, KEY_DATA }, /* CEC Spec: Data - see Note 3 */
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
index d08cedb..b5949bc 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -801,6 +801,7 @@ static struct {
 	{ RC_BIT_SHARP,		"sharp"		},
 	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
 	{ RC_BIT_XMP,		"xmp"		},
+	{ RC_BIT_CEC,		"cec"		},
 };
 
 /**
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 63eb521..155671b 100644
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
index 7c4bbc4..d9f87d5 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -31,6 +31,7 @@ enum rc_type {
 	RC_TYPE_RC6_MCE		= 16,	/* MCE (Philips RC6-6A-32 subtype) protocol */
 	RC_TYPE_SHARP		= 17,	/* Sharp protocol */
 	RC_TYPE_XMP		= 18,	/* XMP protocol */
+	RC_TYPE_CEC		= 19,	/* CEC protocol */
 };
 
 #define RC_BIT_NONE		0
@@ -53,6 +54,7 @@ enum rc_type {
 #define RC_BIT_RC6_MCE		(1 << RC_TYPE_RC6_MCE)
 #define RC_BIT_SHARP		(1 << RC_TYPE_SHARP)
 #define RC_BIT_XMP		(1 << RC_TYPE_XMP)
+#define RC_BIT_CEC		(1 << RC_TYPE_CEC)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
@@ -61,7 +63,7 @@ enum rc_type {
 			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
-			 RC_BIT_XMP)
+			 RC_BIT_XMP | RC_BIT_CEC)
 
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
@@ -123,6 +125,7 @@ void rc_map_init(void);
 #define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
 #define RC_MAP_BEHOLD                    "rc-behold"
 #define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
+#define RC_MAP_CEC                       "rc-cec"
 #define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
 #define RC_MAP_CINERGY                   "rc-cinergy"
 #define RC_MAP_DELOCK_61959              "rc-delock-61959"
-- 
2.1.4

