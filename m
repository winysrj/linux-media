Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53939 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3LMPO6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:14:58 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 07/11] media: rc: img-ir: add JVC decoder module
Date: Fri, 13 Dec 2013 15:12:55 +0000
Message-ID: <1386947579-26703-8-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the JVC infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/Kconfig      |   7 +++
 drivers/media/rc/img-ir/Makefile     |   1 +
 drivers/media/rc/img-ir/img-ir-jvc.c | 109 +++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-jvc.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 44d00227c6c4..b7774a30509f 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -31,3 +31,10 @@ config IR_IMG_NEC
 	help
 	   Say Y or M here to enable support for the NEC and extended NEC
 	   protocols in the ImgTec infrared decoder block.
+
+config IR_IMG_JVC
+	tristate "JVC protocol support"
+	depends on IR_IMG && IR_IMG_HW
+	help
+	   Say Y or M here to enable support for the JVC protocol in the ImgTec
+	   infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index f3052878f092..1d9643801f02 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -5,3 +5,4 @@ img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
 obj-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
+obj-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
new file mode 100644
index 000000000000..a6f383afd2b3
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -0,0 +1,109 @@
+/*
+ * ImgTec IR Decoder setup for JVC protocol.
+ *
+ * Copyright 2012-2013 Imagination Technologies Ltd.
+ */
+
+#include <linux/module.h>
+
+#include "img-ir-hw.h"
+
+/* Convert JVC data to a scancode */
+static int img_ir_jvc_scancode(int len, u64 raw, u64 protocols)
+{
+	unsigned int cust, data;
+
+	if (len != 16)
+		return IMG_IR_ERR_INVALID;
+
+	cust = (raw >> 0) & 0xff;
+	data = (raw >> 8) & 0xff;
+
+	return cust << 8 | data;
+}
+
+/* Convert JVC scancode to JVC data filter */
+static int img_ir_jvc_filter(const struct img_ir_sc_filter *in,
+			     struct img_ir_filter *out, u64 protocols)
+{
+	unsigned int cust, data;
+	unsigned int cust_m, data_m;
+
+	cust   = (in->data >> 8) & 0xff;
+	cust_m = (in->mask >> 8) & 0xff;
+	data   = (in->data >> 0) & 0xff;
+	data_m = (in->mask >> 0) & 0xff;
+
+	out->data = cust   | data << 8;
+	out->mask = cust_m | data_m << 8;
+
+	return 0;
+}
+
+/*
+ * JVC decoder
+ * See also http://www.sbprojects.com/knowledge/ir/jvc.php
+ *          http://support.jvc.com/consumer/support/documents/RemoteCodes.pdf
+ */
+static struct img_ir_decoder img_ir_jvc = {
+	.type = RC_BIT_JVC,
+	.control = {
+		.decoden = 1,
+		.code_type = IMG_IR_CODETYPE_PULSEDIST,
+		.decodend2 = 1,
+	},
+	/* main timings */
+	.unit = 527500, /* 527.5 us */
+	.timings = {
+		/* leader symbol */
+		.ldr = {
+			.pulse = { 16	/* 8.44 ms */ },
+			.space = { 8	/* 4.22 ms */ },
+		},
+		/* 0 symbol */
+		.s00 = {
+			.pulse = { 1	/* 527.5 us +-60 us */ },
+			.space = { 1	/* 527.5 us */ },
+		},
+		/* 1 symbol */
+		.s01 = {
+			.pulse = { 1	/* 527.5 us +-60 us */ },
+			.space = { 3	/* 1.5825 ms +-40 us */ },
+		},
+		/* 0 symbol (no leader) */
+		.s00 = {
+			.pulse = { 1	/* 527.5 us +-60 us */ },
+			.space = { 1	/* 527.5 us */ },
+		},
+		/* 1 symbol (no leader) */
+		.s01 = {
+			.pulse = { 1	/* 527.5 us +-60 us */ },
+			.space = { 3	/* 1.5825 ms +-40 us */ },
+		},
+		/* free time */
+		.ft = {
+			.minlen = 16,
+			.maxlen = 16,
+			.ft_min = 10,	/* 5.275 ms */
+		},
+	},
+	/* scancode logic */
+	.scancode = img_ir_jvc_scancode,
+	.filter = img_ir_jvc_filter,
+};
+
+static int __init img_ir_jvc_init(void)
+{
+	return img_ir_register_decoder(&img_ir_jvc);
+}
+module_init(img_ir_jvc_init);
+
+static void __exit img_ir_jvc_exit(void)
+{
+	img_ir_unregister_decoder(&img_ir_jvc);
+}
+module_exit(img_ir_jvc_exit);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("ImgTec IR JVC protocol support");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2


