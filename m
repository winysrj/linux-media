Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D70C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 08:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1279020855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 08:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfAQI6a (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 03:58:30 -0500
Received: from lns-bzn-25-82-254-177-192.adsl.proxad.net ([82.254.177.192]:52657
        "EHLO maze.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727021AbfAQI6a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 03:58:30 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2019 03:58:28 EST
Received: from over.fork.zz (over.fork.zz [192.168.0.155])
        by maze.fork.zz (8.15.2/8.15.2) with ESMTPS id x0H8oQAu017997
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jan 2019 09:50:28 +0100
Received: from over.fork.zz (localhost [127.0.0.1])
        by over.fork.zz (8.15.2/8.15.2) with ESMTPS id x0H8oPUQ008243
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 17 Jan 2019 09:50:25 +0100
Received: (from patrick@localhost)
        by over.fork.zz (8.15.2/8.15.2/Submit) id x0H8oOrf008242;
        Thu, 17 Jan 2019 09:50:24 +0100
From:   repojohnray <repojohnray@github.github.io>
To:     linux-media@vger.kernel.org
Cc:     Patrick Lerda <patrick9876@free.fr>, sean@mess.org,
        linux-media-owner@vger.kernel.org
Subject: [PATCH v6] media: rc: rcmm decoder
Date:   Thu, 17 Jan 2019 09:50:13 +0100
Message-Id: <a64d59e42d0ec99340e98791aa25c20cc5ec8e49.1547714764.git.patrick9876@free.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190109112503.bnvbu4zz67y7xvdp@gofer.mess.org>
References: <c44581638d2525bc383a75413259f708@free.fr> <cover.1544231670.git.patrick9876@free.fr> <20181205002933.20870-1-patrick9876@free.fr> <20181205002933.20870-2-patrick9876@free.fr> <3a057647b40d9246aca4f64ee771594c32922974.1544175403.git.patrick9876@free.fr> <20181207101231.of7c3j67pcz7cetp@gofer.mess.org> <28f4bc366ebdb585a5b74a25dd1ee8a525e99884.1544231670.git.patrick9876@free.fr> <20190109112503.bnvbu4zz67y7xvdp@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Patrick Lerda <patrick9876@free.fr>

media: add support for RCMM infrared remote controls.

Signed-off-by: Patrick Lerda <patrick9876@free.fr>
---
 MAINTAINERS                        |   5 +
 drivers/media/rc/Kconfig           |  13 ++
 drivers/media/rc/Makefile          |   1 +
 drivers/media/rc/ir-rcmm-decoder.c | 257 +++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h    |   5 +
 drivers/media/rc/rc-main.c         |   9 +
 include/media/rc-map.h             |  14 +-
 include/uapi/linux/lirc.h          |   6 +
 tools/include/uapi/linux/lirc.h    |   6 +
 9 files changed, 313 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/rc/ir-rcmm-decoder.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 17ad1d7b5510..65a08454e99c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16496,6 +16496,11 @@ M:	David Härdeman <david@hardeman.nu>
 S:	Maintained
 F:	drivers/media/rc/winbond-cir.c
 
+RCMM REMOTE CONTROLS DECODER
+M:	Patrick Lerda <patrick9876@free.fr>
+S:	Maintained
+F:	drivers/media/rc/ir-rcmm-decoder.c
+
 WINSYSTEMS EBC-C384 WATCHDOG DRIVER
 M:	William Breathitt Gray <vilhelm.gray@gmail.com>
 L:	linux-watchdog@vger.kernel.org
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 8a216068a35a..2c468fa0299f 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -133,6 +133,19 @@ config IR_IMON_DECODER
 	   remote control and you would like to use it with a raw IR
 	   receiver, or if you wish to use an encoder to transmit this IR.
 
+config IR_RCMM_DECODER
+	tristate "Enable IR raw decoder for the RC-MM protocol"
+	depends on RC_CORE
+	help
+	   Enable this option when you have IR with RC-MM protocol, and
+	   you need the software decoder. The driver supports 32,
+	   24 and 12 bits RC-MM variants. You can enable or disable the
+	   different modes using the following RC protocol keywords:
+	   'rcmm-32', 'rcmm-24' and 'rcmm-12'.
+
+	   To compile this driver as a module, choose M here: the module
+	   will be called ir-rcmm-decoder.
+
 endif #RC_DECODERS
 
 menuconfig RC_DEVICES
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 92c163816849..48d23433b3c0 100644
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
index 000000000000..cdb85e392527
--- /dev/null
+++ b/drivers/media/rc/ir-rcmm-decoder.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0+
+// ir-rcmm-decoder.c - A decoder for the RCMM IR protocol
+//
+// Copyright (C) 2018 by Patrick Lerda <patrick9876@free.fr>
+
+#include "rc-core-priv.h"
+#include <linux/module.h>
+#include <linux/version.h>
+
+#define RCMM_UNIT		166667	/* nanosecs */
+#define RCMM_PREFIX_PULSE	416666  /* 166666.666666666*2.5 */
+#define RCMM_PULSE_0            277777  /* 166666.666666666*(1+2/3) */
+#define RCMM_PULSE_1            444444  /* 166666.666666666*(2+2/3) */
+#define RCMM_PULSE_2            611111  /* 166666.666666666*(3+2/3) */
+#define RCMM_PULSE_3            777778  /* 166666.666666666*(4+2/3) */
+
+enum rcmm_state {
+	STATE_INACTIVE,
+	STATE_LOW,
+	STATE_BUMP,
+	STATE_VALUE,
+	STATE_FINISHED,
+};
+
+static bool rcmm_mode(const struct rcmm_dec *data)
+{
+	return !((0x000c0000 & data->bits) == 0x000c0000);
+}
+
+static int rcmm_miscmode(struct rc_dev *dev, struct rcmm_dec *data)
+{
+	switch (data->count) {
+	case 24:
+		if (dev->enabled_protocols & RC_PROTO_BIT_RCMM24) {
+			rc_keydown(dev, RC_PROTO_RCMM24, data->bits, 0);
+			data->state = STATE_INACTIVE;
+			return 0;
+		}
+		return -1;
+
+	case 12:
+		if (dev->enabled_protocols & RC_PROTO_BIT_RCMM12) {
+			rc_keydown(dev, RC_PROTO_RCMM12, data->bits, 0);
+			data->state = STATE_INACTIVE;
+			return 0;
+		}
+		return -1;
+	}
+
+	return -1;
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
+	int value;
+
+	if (!(dev->enabled_protocols & (RC_PROTO_BIT_RCMM32 |
+							RC_PROTO_BIT_RCMM24 |
+							RC_PROTO_BIT_RCMM12)))
+		return 0;
+
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	switch (data->state) {
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		if (!eq_margin(ev.duration, RCMM_PREFIX_PULSE, RCMM_UNIT / 2))
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
+		if (!eq_margin(ev.duration, RCMM_PULSE_0, RCMM_UNIT / 2))
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
+
+		if (eq_margin(ev.duration, RCMM_PULSE_0, RCMM_UNIT / 2))
+			value = 0;
+		else if (eq_margin(ev.duration, RCMM_PULSE_1, RCMM_UNIT / 2))
+			value = 1;
+		else if (eq_margin(ev.duration, RCMM_PULSE_2, RCMM_UNIT / 2))
+			value = 2;
+		else if (eq_margin(ev.duration, RCMM_PULSE_3, RCMM_UNIT / 2))
+			value = 3;
+		else
+			value = -1;
+
+		if (value == -1) {
+			if (!rcmm_miscmode(dev, data))
+				return 0;
+			break;
+		}
+
+		data->bits <<= 2;
+		data->bits |= value;
+
+		data->count += 2;
+
+		if (data->count < 32)
+			data->state = STATE_BUMP;
+		else
+			data->state = STATE_FINISHED;
+
+		return 0;
+
+	case STATE_FINISHED:
+		if (!ev.pulse)
+			break;
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
+		if (dev->enabled_protocols & RC_PROTO_BIT_RCMM32) {
+			rc_keydown(dev, RC_PROTO_RCMM32, scancode, toggle);
+			data->state = STATE_INACTIVE;
+			return 0;
+		}
+
+		break;
+	}
+
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+static const int rcmmspace[] = {
+	RCMM_PULSE_0,
+	RCMM_PULSE_1,
+	RCMM_PULSE_2,
+	RCMM_PULSE_3,
+};
+
+static int ir_rcmm_rawencoder(struct ir_raw_event **ev, unsigned int max,
+			      unsigned int n, u32 data)
+{
+	int i;
+	int ret;
+
+	ret = ir_raw_gen_pulse_space(ev, &max, RCMM_PREFIX_PULSE, RCMM_PULSE_0);
+	if (ret)
+		return ret;
+
+	for (i = n - 2; i >= 0; i -= 2) {
+		const unsigned int space = rcmmspace[(data >> i) & 3];
+
+		ret = ir_raw_gen_pulse_space(ev, &max, RCMM_UNIT, space);
+		if (ret)
+			return ret;
+	}
+
+	ret = ir_raw_gen_pulse_space(ev, &max, RCMM_UNIT, RCMM_PULSE_3 * 2);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+static int ir_rcmm_encode(enum rc_proto protocol, u32 scancode,
+			  struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int ret;
+
+	switch (protocol) {
+	case RC_PROTO_RCMM32:
+		ret = ir_rcmm_rawencoder(&e, max, 32, scancode);
+		break;
+	case RC_PROTO_RCMM24:
+		ret = ir_rcmm_rawencoder(&e, max, 24, scancode);
+		break;
+	case RC_PROTO_RCMM12:
+		ret = ir_rcmm_rawencoder(&e, max, 12, scancode);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
+static struct ir_raw_handler rcmm_handler = {
+	.protocols	= RC_PROTO_BIT_RCMM32 |
+			  RC_PROTO_BIT_RCMM24 |
+			  RC_PROTO_BIT_RCMM12,
+	.decode		= ir_rcmm_decode,
+	.encode         = ir_rcmm_encode,
+	.carrier        = 36000,
+};
+
+static int __init ir_rcmm_decode_init(void)
+{
+	ir_raw_handler_register(&rcmm_handler);
+
+	pr_info("IR RCMM protocol handler initialized\n");
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
+MODULE_AUTHOR("Patrick Lerda");
+MODULE_DESCRIPTION("RCMM IR protocol decoder");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c2cbe7f6266c..9f21b3e8b377 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -131,6 +131,11 @@ struct ir_raw_event_ctrl {
 		unsigned int bits;
 		bool stick_keyboard;
 	} imon;
+	struct rcmm_dec {
+		int state;
+		unsigned int count;
+		u32 bits;
+	} rcmm;
 };
 
 /* Mutex for locking raw IR processing and handler change */
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 66a174979b3c..971c041120e2 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -70,6 +70,12 @@ static const struct {
 	[RC_PROTO_CEC] = { .name = "cec", .repeat_period = 0 },
 	[RC_PROTO_IMON] = { .name = "imon",
 		.scancode_bits = 0x7fffffff, .repeat_period = 114 },
+	[RC_PROTO_RCMM32] = { .name = "rcmm-32",
+		.scancode_bits = 0xffffffff, .repeat_period = 114 },
+	[RC_PROTO_RCMM24] = { .name = "rcmm-24",
+		.scancode_bits = 0x00ffffff, .repeat_period = 114 },
+	[RC_PROTO_RCMM12] = { .name = "rcmm-12",
+		.scancode_bits = 0x00000fff, .repeat_period = 114 },
 };
 
 /* Used to keep track of known keymaps */
@@ -1006,6 +1012,9 @@ static const struct {
 	{ RC_PROTO_BIT_XMP,	"xmp",		"ir-xmp-decoder"	},
 	{ RC_PROTO_BIT_CEC,	"cec",		NULL			},
 	{ RC_PROTO_BIT_IMON,	"imon",		"ir-imon-decoder"	},
+	{ RC_PROTO_BIT_RCMM32,	"rcmm-32",	"ir-rcmm-decoder"	},
+	{ RC_PROTO_BIT_RCMM24,	"rcmm-24",	"ir-rcmm-decoder"	},
+	{ RC_PROTO_BIT_RCMM12,	"rcmm-12",	"ir-rcmm-decoder"	},
 };
 
 /**
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index d621acadfbf3..27631659b8ac 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -37,6 +37,9 @@
 #define RC_PROTO_BIT_XMP		BIT_ULL(RC_PROTO_XMP)
 #define RC_PROTO_BIT_CEC		BIT_ULL(RC_PROTO_CEC)
 #define RC_PROTO_BIT_IMON		BIT_ULL(RC_PROTO_IMON)
+#define RC_PROTO_BIT_RCMM32		BIT_ULL(RC_PROTO_RCMM32)
+#define RC_PROTO_BIT_RCMM24		BIT_ULL(RC_PROTO_RCMM24)
+#define RC_PROTO_BIT_RCMM12		BIT_ULL(RC_PROTO_RCMM12)
 
 #define RC_PROTO_BIT_ALL \
 			(RC_PROTO_BIT_UNKNOWN | RC_PROTO_BIT_OTHER | \
@@ -51,7 +54,8 @@
 			 RC_PROTO_BIT_RC6_6A_24 | RC_PROTO_BIT_RC6_6A_32 | \
 			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
 			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_CEC | \
-			 RC_PROTO_BIT_IMON)
+			 RC_PROTO_BIT_IMON | RC_PROTO_BIT_RCMM32 | \
+			 RC_PROTO_BIT_RCMM24 | RC_PROTO_BIT_RCMM12)
 /* All rc protocols for which we have decoders */
 #define RC_PROTO_BIT_ALL_IR_DECODER \
 			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
@@ -64,7 +68,9 @@
 			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
 			 RC_PROTO_BIT_RC6_6A_24 |  RC_PROTO_BIT_RC6_6A_32 | \
 			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
-			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_IMON)
+			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_IMON | \
+			 RC_PROTO_BIT_RCMM32 | RC_PROTO_BIT_RCMM24 | \
+			 RC_PROTO_BIT_RCMM12)
 
 #define RC_PROTO_BIT_ALL_IR_ENCODER \
 			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
@@ -77,7 +83,9 @@
 			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
 			 RC_PROTO_BIT_RC6_6A_24 | \
 			 RC_PROTO_BIT_RC6_6A_32 | RC_PROTO_BIT_RC6_MCE | \
-			 RC_PROTO_BIT_SHARP | RC_PROTO_BIT_IMON)
+			 RC_PROTO_BIT_SHARP | RC_PROTO_BIT_IMON | \
+			 RC_PROTO_BIT_RCMM32 | RC_PROTO_BIT_RCMM24 | \
+			 RC_PROTO_BIT_RCMM12)
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 6b319581882f..bd0d54880e6b 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -192,6 +192,9 @@ struct lirc_scancode {
  * @RC_PROTO_XMP: XMP protocol
  * @RC_PROTO_CEC: CEC protocol
  * @RC_PROTO_IMON: iMon Pad protocol
+ * @RC_PROTO_RCMM32: RC-MM protocol 32 bits
+ * @RC_PROTO_RCMM24: RC-MM protocol 24 bits
+ * @RC_PROTO_RCMM12: RC-MM protocol 12 bits
  */
 enum rc_proto {
 	RC_PROTO_UNKNOWN	= 0,
@@ -218,6 +221,9 @@ enum rc_proto {
 	RC_PROTO_XMP		= 21,
 	RC_PROTO_CEC		= 22,
 	RC_PROTO_IMON		= 23,
+	RC_PROTO_RCMM32		= 24,
+	RC_PROTO_RCMM24		= 25,
+	RC_PROTO_RCMM12		= 26,
 };
 
 #endif
diff --git a/tools/include/uapi/linux/lirc.h b/tools/include/uapi/linux/lirc.h
index f189931042a7..e6ac4f4d66c1 100644
--- a/tools/include/uapi/linux/lirc.h
+++ b/tools/include/uapi/linux/lirc.h
@@ -186,6 +186,9 @@ struct lirc_scancode {
  * @RC_PROTO_XMP: XMP protocol
  * @RC_PROTO_CEC: CEC protocol
  * @RC_PROTO_IMON: iMon Pad protocol
+ * @RC_PROTO_RCMM32: RC-MM protocol 32 bits
+ * @RC_PROTO_RCMM24: RC-MM protocol 24 bits
+ * @RC_PROTO_RCMM12: RC-MM protocol 12 bits
  */
 enum rc_proto {
 	RC_PROTO_UNKNOWN	= 0,
@@ -212,6 +215,9 @@ enum rc_proto {
 	RC_PROTO_XMP		= 21,
 	RC_PROTO_CEC		= 22,
 	RC_PROTO_IMON		= 23,
+	RC_PROTO_RCMM32		= 24,
+	RC_PROTO_RCMM24		= 25,
+	RC_PROTO_RCMM12		= 26,
 };
 
 #endif
-- 
2.20.1

