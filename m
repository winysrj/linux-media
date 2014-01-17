Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48381 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaAQOAU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 15/15] media: rc: img-ir: add Sanyo decoder module
Date: Fri, 17 Jan 2014 13:59:00 +0000
Message-ID: <1389967140-20704-16-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the Sanyo infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
v2:
- Update to new scancode interface (32-bit NEC).
- Update to new filtering interface (generic struct rc_scancode_filter).
- Remove modularity and dynamic registration/unregistration, adding
  Sanyo directly to the list of decoders in img-ir-hw.c.
---
 drivers/media/rc/img-ir/Kconfig        |   7 ++
 drivers/media/rc/img-ir/Makefile       |   1 +
 drivers/media/rc/img-ir/img-ir-hw.c    |   4 ++
 drivers/media/rc/img-ir/img-ir-sanyo.c | 122 +++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-sanyo.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 48627f9..03ba9fc 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -52,3 +52,10 @@ config IR_IMG_SHARP
 	help
 	   Say Y here to enable support for the Sharp protocol in the ImgTec
 	   infrared decoder block.
+
+config IR_IMG_SANYO
+	bool "Sanyo protocol support"
+	depends on IR_IMG_HW
+	help
+	   Say Y here to enable support for the Sanyo protocol (used by Sanyo,
+	   Aiwa, Chinon remotes) in the ImgTec infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 792a3c4..92a459d 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -5,6 +5,7 @@ img-ir-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
 img-ir-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
 img-ir-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
 img-ir-$(CONFIG_IR_IMG_SHARP)	+= img-ir-sharp.o
+img-ir-$(CONFIG_IR_IMG_SANYO)	+= img-ir-sanyo.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index fc84b75..0e71426 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -24,6 +24,7 @@ extern struct img_ir_decoder img_ir_nec;
 extern struct img_ir_decoder img_ir_jvc;
 extern struct img_ir_decoder img_ir_sony;
 extern struct img_ir_decoder img_ir_sharp;
+extern struct img_ir_decoder img_ir_sanyo;
 
 static bool img_ir_decoders_preprocessed;
 static struct img_ir_decoder *img_ir_decoders[] = {
@@ -39,6 +40,9 @@ static struct img_ir_decoder *img_ir_decoders[] = {
 #ifdef CONFIG_IR_IMG_SHARP
 	&img_ir_sharp,
 #endif
+#ifdef CONFIG_IR_IMG_SANYO
+	&img_ir_sanyo,
+#endif
 	NULL
 };
 
diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/img-ir/img-ir-sanyo.c
new file mode 100644
index 0000000..c2c763e
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
@@ -0,0 +1,122 @@
+/*
+ * ImgTec IR Decoder setup for Sanyo protocol.
+ *
+ * Copyright 2012-2014 Imagination Technologies Ltd.
+ *
+ * From ir-sanyo-decoder.c:
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
+#include "img-ir-hw.h"
+
+/* Convert Sanyo data to a scancode */
+static int img_ir_sanyo_scancode(int len, u64 raw, int *scancode, u64 protocols)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+	/* a repeat code has no data */
+	if (!len)
+		return IMG_IR_REPEATCODE;
+	if (len != 42)
+		return -EINVAL;
+	addr     = (raw >>  0) & 0x1fff;
+	addr_inv = (raw >> 13) & 0x1fff;
+	data     = (raw >> 26) & 0xff;
+	data_inv = (raw >> 34) & 0xff;
+	/* Validate data */
+	if ((data_inv ^ data) != 0xff)
+		return -EINVAL;
+	/* Validate address */
+	if ((addr_inv ^ addr) != 0x1fff)
+		return -EINVAL;
+
+	/* Normal Sanyo */
+	*scancode = addr << 8 | data;
+	return IMG_IR_SCANCODE;
+}
+
+/* Convert Sanyo scancode to Sanyo data filter */
+static int img_ir_sanyo_filter(const struct rc_scancode_filter *in,
+			       struct img_ir_filter *out, u64 protocols)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+	unsigned int addr_m, data_m;
+
+	data = in->data & 0xff;
+	data_m = in->mask & 0xff;
+	data_inv = data ^ 0xff;
+
+	if (in->data & 0xff700000)
+		return -EINVAL;
+
+	addr       = (in->data >> 8) & 0x1fff;
+	addr_m     = (in->mask >> 8) & 0x1fff;
+	addr_inv   = addr ^ 0x1fff;
+
+	out->data = (u64)data_inv << 34 |
+		    (u64)data     << 26 |
+			 addr_inv << 13 |
+			 addr;
+	out->mask = (u64)data_m << 34 |
+		    (u64)data_m << 26 |
+			 addr_m << 13 |
+			 addr_m;
+	return 0;
+}
+
+/* Sanyo decoder */
+struct img_ir_decoder img_ir_sanyo = {
+	.type = RC_BIT_SANYO,
+	.control = {
+		.decoden = 1,
+		.code_type = IMG_IR_CODETYPE_PULSEDIST,
+	},
+	/* main timings */
+	.unit = 562500, /* 562.5 us */
+	.timings = {
+		/* leader symbol */
+		.ldr = {
+			.pulse = { 16	/* 9ms */ },
+			.space = { 8	/* 4.5ms */ },
+		},
+		/* 0 symbol */
+		.s00 = {
+			.pulse = { 1	/* 562.5 us */ },
+			.space = { 1	/* 562.5 us */ },
+		},
+		/* 1 symbol */
+		.s01 = {
+			.pulse = { 1	/* 562.5 us */ },
+			.space = { 3	/* 1687.5 us */ },
+		},
+		/* free time */
+		.ft = {
+			.minlen = 42,
+			.maxlen = 42,
+			.ft_min = 10,	/* 5.625 ms */
+		},
+	},
+	/* repeat codes */
+	.repeat = 108,			/* 108 ms */
+	.rtimings = {
+		/* leader symbol */
+		.ldr = {
+			.space = { 4	/* 2.25 ms */ },
+		},
+		/* free time */
+		.ft = {
+			.minlen = 0,	/* repeat code has no data */
+			.maxlen = 0,
+		},
+	},
+	/* scancode logic */
+	.scancode = img_ir_sanyo_scancode,
+	.filter = img_ir_sanyo_filter,
+};
-- 
1.8.3.2


