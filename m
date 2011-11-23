Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1KWVXx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 16:23:53 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pANLNrx6011297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 16:23:53 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] [media] rc: Add support for decoding Sanyo protocol
Date: Wed, 23 Nov 2011 19:23:39 -0200
Message-Id: <1322083419-27457-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322083419-27457-1-git-send-email-mchehab@redhat.com>
References: <1322083419-27457-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This protocol is found on Sanyo/Aiwa remotes.

Tested with an Aiwa RC-7AS06 remote control.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/Kconfig            |   10 ++
 drivers/media/rc/Makefile           |    1 +
 drivers/media/rc/ir-raw.c           |    1 +
 drivers/media/rc/ir-sanyo-decoder.c |  204 +++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h     |   12 ++
 drivers/media/rc/rc-main.c          |    1 +
 include/media/rc-map.h              |    8 +-
 7 files changed, 234 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/rc/ir-sanyo-decoder.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index aeb7f43..4df4aff 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -87,6 +87,16 @@ config IR_RC5_SZ_DECODER
 	   uses an IR protocol that is almost standard RC-5, but not quite,
 	   as it uses an additional bit).
 
+config IR_SANYO_DECODER
+	tristate "Enable IR raw decoder for the Sanyo protocol"
+	depends on RC_CORE
+	default y
+
+	---help---
+	   Enable this option if you have an infrared remote control which
+	   uses the Sanyo protocol (Sanyo, Aiwa, Chinon remotes),
+	   and you need software decoding support.
+
 config IR_MCE_KBD_DECODER
 	tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 2156e78..fb3dee2 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
 obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
 obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
 obj-$(CONFIG_IR_RC5_SZ_DECODER) += ir-rc5-sz-decoder.o
+obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
 obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
 obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 27808bb..9e841f4 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -355,6 +355,7 @@ static void init_decoders(struct work_struct *work)
 	load_rc6_decode();
 	load_jvc_decode();
 	load_sony_decode();
+	load_sanyo_decode();
 	load_mce_kbd_decode();
 	load_lirc_codec();
 
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
new file mode 100644
index 0000000..1646730
--- /dev/null
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -0,0 +1,204 @@
+/* ir-sanyo-decoder.c - handle SANYO IR Pulse/Space protocol
+ *
+ * Copyright (C) 2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ * This protocol uses the NEC protocol timings. However, data is formatted as:
+ *	13 bits Custom Code
+ *	13 bits NOT(Custom Code)
+ *	8 bits Key data
+ *	8 bits NOT(Key data)
+ *
+ * According with LIRC, this protocol is used on Sanyo, Aiwa and Chinon
+ * Information for this protocol is available at the Sanyo LC7461 datasheet.
+ */
+
+#include <linux/bitrev.h>
+#include "rc-core-priv.h"
+
+#define SANYO_NBITS		(13+13+8+8)
+#define SANYO_UNIT		562500  /* ns */
+#define SANYO_HEADER_PULSE	(16  * SANYO_UNIT)
+#define SANYO_HEADER_SPACE	(8   * SANYO_UNIT)
+#define SANYO_BIT_PULSE		(1   * SANYO_UNIT)
+#define SANYO_BIT_0_SPACE	(1   * SANYO_UNIT)
+#define SANYO_BIT_1_SPACE	(3   * SANYO_UNIT)
+#define SANYO_REPEAT_SPACE	(150 * SANYO_UNIT)
+#define	SANYO_TRAILER_PULSE	(1   * SANYO_UNIT)
+#define	SANYO_TRAILER_SPACE	(10  * SANYO_UNIT)	/* in fact, 42 */
+
+enum sanyo_state {
+	STATE_INACTIVE,
+	STATE_HEADER_SPACE,
+	STATE_BIT_PULSE,
+	STATE_BIT_SPACE,
+	STATE_TRAILER_PULSE,
+	STATE_TRAILER_SPACE,
+};
+
+/**
+ * ir_sanyo_decode() - Decode one SANYO pulse or space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
+{
+	struct sanyo_dec *data = &dev->raw->sanyo;
+	u32 scancode;
+	u8 address, not_address, command, not_command;
+
+	if (!(dev->raw->enabled_protocols & RC_TYPE_SANYO))
+		return 0;
+
+	if (!is_timing_event(ev)) {
+		if (ev.reset) {
+			IR_dprintk(1, "SANYO event reset received. reset to state 0\n");
+			data->state = STATE_INACTIVE;
+		}
+		return 0;
+	}
+
+	IR_dprintk(2, "SANYO decode started at state %d (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		if (eq_margin(ev.duration, SANYO_HEADER_PULSE, SANYO_UNIT / 2)) {
+			data->count = 0;
+			data->state = STATE_HEADER_SPACE;
+			return 0;
+		}
+		break;
+
+
+	case STATE_HEADER_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (eq_margin(ev.duration, SANYO_HEADER_SPACE, SANYO_UNIT / 2)) {
+			data->state = STATE_BIT_PULSE;
+			return 0;
+		}
+
+		break;
+
+	case STATE_BIT_PULSE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SANYO_BIT_PULSE, SANYO_UNIT / 2))
+			break;
+
+		data->state = STATE_BIT_SPACE;
+		return 0;
+
+	case STATE_BIT_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
+			if (!dev->keypressed) {
+				IR_dprintk(1, "SANYO discarding last key repeat: event after key up\n");
+			} else {
+				rc_repeat(dev);
+				IR_dprintk(1, "SANYO repeat last key\n");
+				data->state = STATE_INACTIVE;
+			}
+			return 0;
+		}
+
+		data->bits <<= 1;
+		if (eq_margin(ev.duration, SANYO_BIT_1_SPACE, SANYO_UNIT / 2))
+			data->bits |= 1;
+		else if (!eq_margin(ev.duration, SANYO_BIT_0_SPACE, SANYO_UNIT / 2))
+			break;
+		data->count++;
+
+		if (data->count == SANYO_NBITS)
+			data->state = STATE_TRAILER_PULSE;
+		else
+			data->state = STATE_BIT_PULSE;
+
+		return 0;
+
+	case STATE_TRAILER_PULSE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, SANYO_TRAILER_PULSE, SANYO_UNIT / 2))
+			break;
+
+		data->state = STATE_TRAILER_SPACE;
+		return 0;
+
+	case STATE_TRAILER_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!geq_margin(ev.duration, SANYO_TRAILER_SPACE, SANYO_UNIT / 2))
+			break;
+
+		address     = bitrev16((data->bits >> 29) & 0x1fff) >> 3;
+		not_address = bitrev16((data->bits >> 16) & 0x1fff) >> 3;
+		command	    = bitrev8((data->bits >>  8) & 0xff);
+		not_command = bitrev8((data->bits >>  0) & 0xff);
+
+		if ((command ^ not_command) != 0xff) {
+			IR_dprintk(1, "SANYO checksum error: received 0x%08Lx\n",
+				   data->bits);
+			data->state = STATE_INACTIVE;
+			return 0;
+		}
+
+		scancode = address << 8 | command;
+		IR_dprintk(1, "SANYO scancode: 0x%06x\n", scancode);
+		rc_keydown(dev, scancode, 0);
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	IR_dprintk(1, "SANYO decode failed at count %d state %d (%uus %s)\n",
+		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+static struct ir_raw_handler sanyo_handler = {
+	.protocols	= RC_TYPE_SANYO,
+	.decode		= ir_sanyo_decode,
+};
+
+static int __init ir_sanyo_decode_init(void)
+{
+	ir_raw_handler_register(&sanyo_handler);
+
+	printk(KERN_INFO "IR SANYO protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_sanyo_decode_exit(void)
+{
+	ir_raw_handler_unregister(&sanyo_handler);
+}
+
+module_init(ir_sanyo_decode_init);
+module_exit(ir_sanyo_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
+MODULE_DESCRIPTION("SANYO IR protocol decoder");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c6ca870..b72f858 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -84,6 +84,11 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		unsigned wanted_bits;
 	} rc5_sz;
+	struct sanyo_dec {
+		int state;
+		unsigned count;
+		u64 bits;
+	} sanyo;
 	struct mce_kbd_dec {
 		struct input_dev *idev;
 		struct timer_list rx_timeout;
@@ -193,6 +198,13 @@ static inline void load_jvc_decode(void) { }
 static inline void load_sony_decode(void) { }
 #endif
 
+/* from ir-sanyo-decoder.c */
+#ifdef CONFIG_IR_SANYO_DECODER_MODULE
+#define load_sanyo_decode()	request_module("ir-sanyo-decoder")
+#else
+static inline void load_sanyo_decode(void) { }
+#endif
+
 /* from ir-mce_kbd-decoder.c */
 #ifdef CONFIG_IR_MCE_KBD_DECODER_MODULE
 #define load_mce_kbd_decode()	request_module("ir-mce_kbd-decoder")
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 666d4bb..35e2fcf 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -735,6 +735,7 @@ static struct {
 	{ RC_TYPE_JVC,		"jvc"		},
 	{ RC_TYPE_SONY,		"sony"		},
 	{ RC_TYPE_RC5_SZ,	"rc-5-sz"	},
+	{ RC_TYPE_SANYO,	"sanyo"		},
 	{ RC_TYPE_MCE_KBD,	"mce_kbd"	},
 	{ RC_TYPE_LIRC,		"lirc"		},
 	{ RC_TYPE_OTHER,	"other"		},
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 26a3bd0..183d701 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -18,13 +18,15 @@
 #define RC_TYPE_JVC	(1  << 3)	/* JVC protocol */
 #define RC_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
 #define RC_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
+#define RC_TYPE_SANYO   (1  << 6)	/* Sanyo protocol */
 #define RC_TYPE_MCE_KBD	(1  << 29)	/* RC6-ish MCE keyboard/mouse */
 #define RC_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
 #define RC_TYPE_OTHER	(1u << 31)
 
-#define RC_TYPE_ALL (RC_TYPE_RC5 | RC_TYPE_NEC  | RC_TYPE_RC6  | \
-		     RC_TYPE_JVC | RC_TYPE_SONY | RC_TYPE_LIRC | \
-		     RC_TYPE_RC5_SZ | RC_TYPE_MCE_KBD | RC_TYPE_OTHER)
+#define RC_TYPE_ALL (RC_TYPE_RC5    | RC_TYPE_NEC   | RC_TYPE_RC6     | \
+		     RC_TYPE_JVC    | RC_TYPE_SONY  | RC_TYPE_LIRC    | \
+		     RC_TYPE_RC5_SZ | RC_TYPE_SANYO | RC_TYPE_MCE_KBD | \
+		     RC_TYPE_OTHER)
 
 struct rc_map_table {
 	u32	scancode;
-- 
1.7.7.1

