Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0AFC04EBF
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 20:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D4592082B
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 20:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D4592082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=free.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbeLDU2D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 15:28:03 -0500
Received: from lns-bzn-25-82-254-177-192.adsl.proxad.net ([82.254.177.192]:56151
        "EHLO maze.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725855AbeLDU2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 15:28:03 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2018 15:28:01 EST
Received: from over.fork.zz (over.fork.zz [192.168.0.155])
        by maze.fork.zz (8.15.2/8.15.2) with ESMTPS id wB4KKfFK001182
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Dec 2018 21:20:41 +0100
Received: from over.fork.zz (localhost [127.0.0.1])
        by over.fork.zz (8.15.2/8.15.2) with ESMTPS id wB4KKf2u024331
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 4 Dec 2018 21:20:41 +0100
Received: (from patrick@localhost)
        by over.fork.zz (8.15.2/8.15.2/Submit) id wB4KKfxA024330;
        Tue, 4 Dec 2018 21:20:41 +0100
From:   patrick9876@free.fr
To:     linux-media@vger.kernel.org
Cc:     Patrick LERDA <patrick9876@free.fr>
Subject: [PATCH] Add ir-rcmm-driver
Date:   Tue,  4 Dec 2018 21:20:25 +0100
Message-Id: <20181204202025.24279-2-patrick9876@free.fr>
X-Mailer: git-send-email 2.19.2
Reply-To: patrick9876@free.fr
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Patrick LERDA <patrick9876@free.fr>

---
 drivers/media/rc/Kconfig           |  10 ++
 drivers/media/rc/Makefile          |   1 +
 drivers/media/rc/ir-rcmm-decoder.c | 185 +++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h    |   5 +
 drivers/media/rc/rc-main.c         |   3 +
 include/media/rc-map.h             |   6 +-
 include/uapi/linux/lirc.h          |   1 +
 tools/include/uapi/linux/lirc.h    |   1 +
 8 files changed, 210 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/rc/ir-rcmm-decoder.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 1021c08a9ba4..b7e08324b874 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -133,6 +133,16 @@ config IR_IMON_DECODER
 	   remote control and you would like to use it with a raw IR
 	   receiver, or if you wish to use an encoder to transmit this IR.
 
+config IR_RCMM_DECODER
+	tristate "Enable IR raw decoder for the RC-MM protocol"
+	depends on RC_CORE
+	select BITREVERSE
+	default y
+
+	---help---
+	   Enable this option if you have IR with RC-MM protocol, and
+	   if the IR is decoded in software
+
 endif #RC_DECODERS
 
 menuconfig RC_DEVICES
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index e0340d043fe8..fc4058013234 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
 obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
 obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
 obj-$(CONFIG_IR_IMON_DECODER) += ir-imon-decoder.o
+obj-$(CONFIG_IR_RCMM_DECODER) += ir-rcmm-decoder.o
 
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_RC_ATI_REMOTE) += ati_remote.o
diff --git a/drivers/media/rc/ir-rcmm-decoder.c b/drivers/media/rc/ir-rcmm-decoder.c
new file mode 100644
index 000000000000..b05063f0a552
--- /dev/null
+++ b/drivers/media/rc/ir-rcmm-decoder.c
@@ -0,0 +1,185 @@
+/* ir-rcmm-decoder.c - A decoder for the RCMM IR protocol
+ *
+ * Copyright (C) 2016 by Patrick Lerda
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "rc-core-priv.h"
+#include <linux/module.h>
+#include <linux/version.h>
+
+
+#define RCMM_UNIT		166667	/* nanosecs */
+#define RCMM_0_NBITS		64
+#define RCMM_PREFIX_PULSE	416666  /* 166666.666666666*2.5 */
+#define RCMM_PULSE_0            277777  /* 166666.666666666*(1+2/3) */
+#define RCMM_PULSE_1            444444  /* 166666.666666666*(2+2/3) */
+#define RCMM_PULSE_2            611111  /* 166666.666666666*(3+2/3) */
+#define RCMM_PULSE_3            777778  /* 166666.666666666*(4+2/3) */
+#define RCMM_MODE_MASK          0x0000
+
+enum rcmm_state {
+	STATE_INACTIVE,
+	STATE_LOW,
+	STATE_BUMP,
+	STATE_VALUE,
+	STATE_FINISHED,
+};
+
+static bool rcmm_mode(struct rcmm_dec *data)
+{
+        return !((0x000c0000 & data->bits) == 0x000c0000);
+}
+
+/**
+ * ir_rcmm_decode() - Decode one RCMM pulse or space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_rcmm_decode(struct rc_dev *dev, struct ir_raw_event ev)
+{
+	struct rcmm_dec *data = &dev->raw->rcmm;
+	u32 scancode;
+	u8 toggle;
+
+	if (!(dev->enabled_protocols & RC_PROTO_RCMM))
+		return 0;
+
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	if (ev.duration > RCMM_PULSE_3 + RCMM_UNIT)
+		goto out;
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		/* Note: larger margin on first pulse since each RCMM_UNIT
+		   is quite short and some hardware takes some time to
+		   adjust to the signal */
+		if (!eq_margin(ev.duration, RCMM_PREFIX_PULSE, RCMM_UNIT/2))
+			break;
+
+		data->state = STATE_LOW;
+		data->count = 0;
+		data->bits  = 0;
+		return 0;
+
+	case STATE_LOW:
+		if (ev.pulse)
+			break;
+
+		/* Note: larger margin on first pulse since each RCMM_UNIT
+		   is quite short and some hardware takes some time to
+		   adjust to the signal */
+		if (!eq_margin(ev.duration, RCMM_PULSE_0, RCMM_UNIT/2))
+			break;
+
+		data->state = STATE_BUMP;
+		return 0;
+
+	case STATE_BUMP:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, RCMM_UNIT, RCMM_UNIT / 2))
+			break;
+
+		data->state = STATE_VALUE;
+		return 0;
+
+	case STATE_VALUE:
+		if (ev.pulse)
+			break;
+	        {
+			int value;
+
+			if (eq_margin(ev.duration, RCMM_PULSE_0, RCMM_UNIT / 2)) {
+				value = 0;
+			} else if (eq_margin(ev.duration, RCMM_PULSE_1, RCMM_UNIT / 2))	{
+				value = 1;
+			} else if (eq_margin(ev.duration, RCMM_PULSE_2, RCMM_UNIT / 2))	{
+				value = 2;
+			} else if (eq_margin(ev.duration, RCMM_PULSE_3, RCMM_UNIT / 2))	{
+				value = 3;
+			} else
+				break;
+
+			data->bits <<= 2;
+			data->bits |= value;
+		}
+
+		data->count+=2;
+
+		if (data->count < 32) {
+			data->state = STATE_BUMP;
+		} else {
+			data->state = STATE_FINISHED;
+		}
+
+		return 0;
+
+	case STATE_FINISHED:
+	        if (!ev.pulse) break;
+
+		if (!eq_margin(ev.duration, RCMM_UNIT, RCMM_UNIT / 2))
+			break;
+
+		if (rcmm_mode(data)) {
+			toggle = !!(0x8000 & data->bits);
+			scancode = data->bits & ~0x8000;
+		} else {
+			toggle = 0;
+			scancode = data->bits;
+		}
+
+		rc_keydown(dev, RC_PROTO_RCMM, scancode, toggle);
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+out:
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+static struct ir_raw_handler rcmm_handler = {
+	.protocols	= RC_PROTO_RCMM,
+	.decode		= ir_rcmm_decode,
+};
+
+static int __init ir_rcmm_decode_init(void)
+{
+	ir_raw_handler_register(&rcmm_handler);
+
+	printk(KERN_INFO "IR RCMM protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_rcmm_decode_exit(void)
+{
+	ir_raw_handler_unregister(&rcmm_handler);
+}
+
+module_init(ir_rcmm_decode_init);
+module_exit(ir_rcmm_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick LERDA");
+MODULE_DESCRIPTION("RCMM IR protocol decoder");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c2cbe7f6266c..c63d4ad007cc 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -131,6 +131,11 @@ struct ir_raw_event_ctrl {
 		unsigned int bits;
 		bool stick_keyboard;
 	} imon;
+	struct rcmm_dec {
+		int state;
+		unsigned count;
+		u64 bits;
+	} rcmm;
 };
 
 /* Mutex for locking raw IR processing and handler change */
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 552bbe82a160..ad1dee921f5b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -70,6 +70,8 @@ static const struct {
 	[RC_PROTO_CEC] = { .name = "cec", .repeat_period = 0 },
 	[RC_PROTO_IMON] = { .name = "imon",
 		.scancode_bits = 0x7fffffff, .repeat_period = 114 },
+	[RC_PROTO_RCMM] = { .name = "rcmm",
+		.scancode_bits = 0xffffffff, .repeat_period = 114 },
 };
 
 /* Used to keep track of known keymaps */
@@ -1004,6 +1006,7 @@ static const struct {
 	{ RC_PROTO_BIT_XMP,	"xmp",		"ir-xmp-decoder"	},
 	{ RC_PROTO_BIT_CEC,	"cec",		NULL			},
 	{ RC_PROTO_BIT_IMON,	"imon",		"ir-imon-decoder"	},
+	{ RC_PROTO_BIT_RCMM,	"rcmm",		"ir-rcmm-decoder"	},
 };
 
 /**
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index bfa3017cecba..28e8e7692b38 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -37,6 +37,7 @@
 #define RC_PROTO_BIT_XMP		BIT_ULL(RC_PROTO_XMP)
 #define RC_PROTO_BIT_CEC		BIT_ULL(RC_PROTO_CEC)
 #define RC_PROTO_BIT_IMON		BIT_ULL(RC_PROTO_IMON)
+#define RC_PROTO_BIT_RCMM		BIT_ULL(RC_PROTO_RCMM)
 
 #define RC_PROTO_BIT_ALL \
 			(RC_PROTO_BIT_UNKNOWN | RC_PROTO_BIT_OTHER | \
@@ -51,7 +52,7 @@
 			 RC_PROTO_BIT_RC6_6A_24 | RC_PROTO_BIT_RC6_6A_32 | \
 			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
 			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_CEC | \
-			 RC_PROTO_BIT_IMON)
+			 RC_PROTO_BIT_IMON | RC_PROTO_BIT_RCMM)
 /* All rc protocols for which we have decoders */
 #define RC_PROTO_BIT_ALL_IR_DECODER \
 			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
@@ -64,7 +65,8 @@
 			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
 			 RC_PROTO_BIT_RC6_6A_24 |  RC_PROTO_BIT_RC6_6A_32 | \
 			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
-			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_IMON)
+			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_IMON | \
+			 RC_PROTO_RCMM)
 
 #define RC_PROTO_BIT_ALL_IR_ENCODER \
 			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 6b319581882f..2bc7915ff33a 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -218,6 +218,7 @@ enum rc_proto {
 	RC_PROTO_XMP		= 21,
 	RC_PROTO_CEC		= 22,
 	RC_PROTO_IMON		= 23,
+	RC_PROTO_RCMM		= 24,
 };
 
 #endif
diff --git a/tools/include/uapi/linux/lirc.h b/tools/include/uapi/linux/lirc.h
index f189931042a7..c03e9562e349 100644
--- a/tools/include/uapi/linux/lirc.h
+++ b/tools/include/uapi/linux/lirc.h
@@ -212,6 +212,7 @@ enum rc_proto {
 	RC_PROTO_XMP		= 21,
 	RC_PROTO_CEC		= 22,
 	RC_PROTO_IMON		= 23,
+	RC_PROTO_RCMM		= 24,
 };
 
 #endif
-- 
2.19.2

