Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53957 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3LMPO7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:14:59 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 10/11] media: rc: img-ir: add Sharp decoder module
Date: Fri, 13 Dec 2013 15:12:58 +0000
Message-ID: <1386947579-26703-11-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the Sharp infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/Kconfig        |   7 ++
 drivers/media/rc/img-ir/Makefile       |   1 +
 drivers/media/rc/img-ir/img-ir-sharp.c | 115 +++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-sharp.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 38505188df0e..24e0966a3220 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -45,3 +45,10 @@ config IR_IMG_SONY
 	help
 	   Say Y or M here to enable support for the Sony protocol in the ImgTec
 	   infrared decoder block.
+
+config IR_IMG_SHARP
+	tristate "Sharp protocol support"
+	depends on IR_IMG && IR_IMG_HW
+	help
+	   Say Y or M here to enable support for the Sharp protocol in the
+	   ImgTec infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index f3e7cc4f32e4..3c3ab4f1a9f1 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_IR_IMG)		+= img-ir.o
 obj-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
 obj-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
 obj-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
+obj-$(CONFIG_IR_IMG_SHARP)	+= img-ir-sharp.o
diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
new file mode 100644
index 000000000000..4d70abc088b4
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-sharp.c
@@ -0,0 +1,115 @@
+/*
+ * ImgTec IR Decoder setup for Sharp protocol.
+ *
+ * Copyright 2012-2013 Imagination Technologies Ltd.
+ */
+
+#include <linux/module.h>
+
+#include "img-ir-hw.h"
+
+/* Convert Sharp data to a scancode */
+static int img_ir_sharp_scancode(int len, u64 raw, u64 protocols)
+{
+	unsigned int addr, cmd, exp, chk;
+
+	if (len != 15)
+		return IMG_IR_ERR_INVALID;
+
+	addr = (raw >>   0) & 0x1f;
+	cmd  = (raw >>   5) & 0xff;
+	exp  = (raw >>  13) &  0x1;
+	chk  = (raw >>  14) &  0x1;
+
+	/* validate data */
+	if (!exp)
+		return IMG_IR_ERR_INVALID;
+	if (chk)
+		/* probably the second half of the message */
+		return IMG_IR_ERR_INVALID;
+
+	return addr << 8 | cmd;
+}
+
+/* Convert Sharp scancode to Sharp data filter */
+static int img_ir_sharp_filter(const struct img_ir_sc_filter *in,
+			       struct img_ir_filter *out, u64 protocols)
+{
+	unsigned int addr, cmd, exp = 0, chk = 0;
+	unsigned int addr_m, cmd_m, exp_m = 0, chk_m = 0;
+
+	addr   = (in->data >> 8) & 0x1f;
+	addr_m = (in->mask >> 8) & 0x1f;
+	cmd    = (in->data >> 0) & 0xff;
+	cmd_m  = (in->mask >> 0) & 0xff;
+	if (cmd_m) {
+		/* if filtering commands, we can only match the first part */
+		exp   = 1;
+		exp_m = 1;
+		chk   = 0;
+		chk_m = 1;
+	}
+
+	out->data = addr        |
+		    cmd   <<  5 |
+		    exp   << 13 |
+		    chk   << 14;
+	out->mask = addr_m      |
+		    cmd_m <<  5 |
+		    exp_m << 13 |
+		    chk_m << 14;
+
+	return 0;
+}
+
+/*
+ * Sharp decoder
+ * See also http://www.sbprojects.com/knowledge/ir/sharp.php
+ */
+static struct img_ir_decoder img_ir_sharp = {
+	.type = RC_BIT_SHARP,
+	.control = {
+		.decoden = 0,
+		.decodend2 = 1,
+		.code_type = IMG_IR_CODETYPE_PULSEDIST,
+		.d1validsel = 1,
+	},
+	/* main timings */
+	.timings = {
+		/* 0 symbol */
+		.s10 = {
+			.pulse = { 320	/* 320 us */ },
+			.space = { 680	/* 1 ms period */ },
+		},
+		/* 1 symbol */
+		.s11 = {
+			.pulse = { 320	/* 230 us */ },
+			.space = { 1680	/* 2 ms period */ },
+		},
+		/* free time */
+		.ft = {
+			.minlen = 15,
+			.maxlen = 15,
+			.ft_min = 5000,	/* 5 ms */
+		},
+	},
+	/* scancode logic */
+	.scancode = img_ir_sharp_scancode,
+	.filter = img_ir_sharp_filter,
+};
+
+static int __init img_ir_sharp_init(void)
+{
+	return img_ir_register_decoder(&img_ir_sharp);
+}
+module_init(img_ir_sharp_init);
+
+static void __exit img_ir_sharp_exit(void)
+{
+	img_ir_unregister_decoder(&img_ir_sharp);
+}
+module_exit(img_ir_sharp_exit);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("ImgTec IR Sharp protocol support");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2


