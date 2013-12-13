Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53942 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab3LMPO7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:14:59 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 11/11] media: rc: img-ir: add Sanyo decoder module
Date: Fri, 13 Dec 2013 15:12:59 +0000
Message-ID: <1386947579-26703-12-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the Sanyo infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/Kconfig        |   7 ++
 drivers/media/rc/img-ir/Makefile       |   1 +
 drivers/media/rc/img-ir/img-ir-sanyo.c | 139 +++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-sanyo.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 24e0966a3220..8c035b7c34e8 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -52,3 +52,10 @@ config IR_IMG_SHARP
 	help
 	   Say Y or M here to enable support for the Sharp protocol in the
 	   ImgTec infrared decoder block.
+
+config IR_IMG_SANYO
+	tristate "Sanyo protocol support"
+	depends on IR_IMG && IR_IMG_HW
+	help
+	   Say Y or M here to enable support for the Sanyo protocol (used by
+	   Sanyo, Aiwa, Chinon remotes) in the ImgTec infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 3c3ab4f1a9f1..4f1e4305870d 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
 obj-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
 obj-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
 obj-$(CONFIG_IR_IMG_SHARP)	+= img-ir-sharp.o
+obj-$(CONFIG_IR_IMG_SANYO)	+= img-ir-sanyo.o
diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/img-ir/img-ir-sanyo.c
new file mode 100644
index 000000000000..bfd44b4fd468
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
@@ -0,0 +1,139 @@
+/*
+ * ImgTec IR Decoder setup for Sanyo protocol.
+ *
+ * Copyright 2012-2013 Imagination Technologies Ltd.
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
+#include <linux/module.h>
+
+#include "img-ir-hw.h"
+
+/* Convert Sanyo data to a scancode */
+static int img_ir_sanyo_scancode(int len, u64 raw, u64 protocols)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+	/* a repeat code has no data */
+	if (!len)
+		return IMG_IR_REPEATCODE;
+	if (len != 42)
+		return IMG_IR_ERR_INVALID;
+	addr     = (raw >>  0) & 0x1fff;
+	addr_inv = (raw >> 13) & 0x1fff;
+	data     = (raw >> 26) & 0xff;
+	data_inv = (raw >> 34) & 0xff;
+	/* Validate data */
+	if ((data_inv ^ data) != 0xff)
+		return IMG_IR_ERR_INVALID;
+	/* Validate address */
+	if ((addr_inv ^ addr) != 0x1fff)
+		return IMG_IR_ERR_INVALID;
+
+	/* Normal Sanyo */
+	return addr << 8 | data;
+}
+
+/* Convert Sanyo scancode to Sanyo data filter */
+static int img_ir_sanyo_filter(const struct img_ir_sc_filter *in,
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
+static struct img_ir_decoder img_ir_sanyo = {
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
+
+static int __init img_ir_sanyo_init(void)
+{
+	return img_ir_register_decoder(&img_ir_sanyo);
+}
+module_init(img_ir_sanyo_init);
+
+static void __exit img_ir_sanyo_exit(void)
+{
+	img_ir_unregister_decoder(&img_ir_sanyo);
+}
+module_exit(img_ir_sanyo_exit);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("ImgTec IR Sanyo protocol support");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2


