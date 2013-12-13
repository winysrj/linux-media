Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53957 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3LMPO6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:14:58 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 06/11] media: rc: img-ir: add NEC decoder module
Date: Fri, 13 Dec 2013 15:12:54 +0000
Message-ID: <1386947579-26703-7-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the NEC and extended NEC infrared
protocols.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/Kconfig      |   7 ++
 drivers/media/rc/img-ir/Makefile     |   1 +
 drivers/media/rc/img-ir/img-ir-nec.c | 149 +++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-nec.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 60eaba6a0843..44d00227c6c4 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -24,3 +24,10 @@ config IR_IMG_HW
 	   signals in hardware. This is more reliable, consumes less processing
 	   power since only a single interrupt is received for each scancode,
 	   and allows an IR scancode to be used as a wake event.
+
+config IR_IMG_NEC
+	tristate "NEC protocol support"
+	depends on IR_IMG && IR_IMG_HW
+	help
+	   Say Y or M here to enable support for the NEC and extended NEC
+	   protocols in the ImgTec infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 4ef86edec873..f3052878f092 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -4,3 +4,4 @@ img-ir-$(CONFIG_IR_IMG_HW)	+= img-ir-hw.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
+obj-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
new file mode 100644
index 000000000000..ba376caafaf2
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -0,0 +1,149 @@
+/*
+ * ImgTec IR Decoder setup for NEC protocol.
+ *
+ * Copyright 2010-2013 Imagination Technologies Ltd.
+ */
+
+#include <linux/module.h>
+
+#include "img-ir-hw.h"
+
+/* Convert NEC data to a scancode */
+static int img_ir_nec_scancode(int len, u64 raw, u64 protocols)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+	int scancode;
+	/* a repeat code has no data */
+	if (!len)
+		return IMG_IR_REPEATCODE;
+	if (len != 32)
+		return IMG_IR_ERR_INVALID;
+	addr     = (raw >>  0) & 0xff;
+	addr_inv = (raw >>  8) & 0xff;
+	data     = (raw >> 16) & 0xff;
+	data_inv = (raw >> 24) & 0xff;
+	/* Validate data */
+	if ((data_inv ^ data) != 0xff)
+		return IMG_IR_ERR_INVALID;
+
+	if ((addr_inv ^ addr) != 0xff) {
+		/* Extended NEC */
+		scancode = addr     << 16 |
+			   addr_inv <<  8 |
+			   data;
+	} else {
+		/* Normal NEC */
+		scancode = addr << 8 |
+			   data;
+	}
+	return scancode;
+}
+
+/* Convert NEC scancode to NEC data filter */
+static int img_ir_nec_filter(const struct img_ir_sc_filter *in,
+			     struct img_ir_filter *out, u64 protocols)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+	unsigned int addr_m, addr_inv_m, data_m;
+
+	data     = in->data & 0xff;
+	data_m   = in->mask & 0xff;
+	data_inv = data ^ 0xff;
+
+	if (in->data & 0xff000000)
+		return -EINVAL;
+
+	if (in->data & 0x00ff0000) {
+		/* Extended NEC */
+		addr       = (in->data >> 16) & 0xff;
+		addr_m     = (in->mask >> 16) & 0xff;
+		addr_inv   = (in->data >>  8) & 0xff;
+		addr_inv_m = (in->mask >>  8) & 0xff;
+	} else {
+		/* Normal NEC */
+		addr       = (in->data >>  8) & 0xff;
+		addr_m     = (in->mask >>  8) & 0xff;
+		addr_inv   = addr ^ 0xff;
+		addr_inv_m = addr_m;
+	}
+
+	out->data = data_inv << 24 |
+		    data     << 16 |
+		    addr_inv <<  8 |
+		    addr;
+	out->mask = data_m     << 24 |
+		    data_m     << 16 |
+		    addr_inv_m <<  8 |
+		    addr_m;
+	return 0;
+}
+
+/*
+ * NEC decoder
+ * See also http://www.sbprojects.com/knowledge/ir/nec.php
+ *        http://wiki.altium.com/display/ADOH/NEC+Infrared+Transmission+Protocol
+ */
+static struct img_ir_decoder img_ir_nec = {
+	.type = RC_BIT_NEC,
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
+			.minlen = 32,
+			.maxlen = 32,
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
+	.scancode = img_ir_nec_scancode,
+	.filter = img_ir_nec_filter,
+};
+
+static int __init img_ir_nec_init(void)
+{
+	return img_ir_register_decoder(&img_ir_nec);
+}
+module_init(img_ir_nec_init);
+
+static void __exit img_ir_nec_exit(void)
+{
+	img_ir_unregister_decoder(&img_ir_nec);
+}
+module_exit(img_ir_nec_exit);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("ImgTec IR NEC protocol support");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2


