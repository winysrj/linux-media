Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48384 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaAQOAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:18 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 12/15] media: rc: img-ir: add JVC decoder module
Date: Fri, 17 Jan 2014 13:58:57 +0000
Message-ID: <1389967140-20704-13-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the JVC infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
v2:
- Update to new scancode interface (32-bit NEC).
- Update to new filtering interface (generic struct rc_scancode_filter).
- Remove modularity and dynamic registration/unregistration, adding JVC
  directly to the list of decoders in img-ir-hw.c.
---
 drivers/media/rc/img-ir/Kconfig      |  7 +++
 drivers/media/rc/img-ir/Makefile     |  1 +
 drivers/media/rc/img-ir/img-ir-hw.c  |  4 ++
 drivers/media/rc/img-ir/img-ir-jvc.c | 92 ++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-jvc.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 28498a2..96006fbf 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -31,3 +31,10 @@ config IR_IMG_NEC
 	help
 	   Say Y here to enable support for the NEC, extended NEC, and 32-bit
 	   NEC protocols in the ImgTec infrared decoder block.
+
+config IR_IMG_JVC
+	bool "JVC protocol support"
+	depends on IR_IMG_HW
+	help
+	   Say Y here to enable support for the JVC protocol in the ImgTec
+	   infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index c409197..c5f8f06 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -2,6 +2,7 @@ img-ir-y			:= img-ir-core.o
 img-ir-$(CONFIG_IR_IMG_RAW)	+= img-ir-raw.o
 img-ir-$(CONFIG_IR_IMG_HW)	+= img-ir-hw.o
 img-ir-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
+img-ir-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 79ec495..fc8a58b 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -21,12 +21,16 @@
 static DEFINE_SPINLOCK(img_ir_decoders_lock);
 
 extern struct img_ir_decoder img_ir_nec;
+extern struct img_ir_decoder img_ir_jvc;
 
 static bool img_ir_decoders_preprocessed;
 static struct img_ir_decoder *img_ir_decoders[] = {
 #ifdef CONFIG_IR_IMG_NEC
 	&img_ir_nec,
 #endif
+#ifdef CONFIG_IR_IMG_JVC
+	&img_ir_jvc,
+#endif
 	NULL
 };
 
diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
new file mode 100644
index 0000000..ae55867
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -0,0 +1,92 @@
+/*
+ * ImgTec IR Decoder setup for JVC protocol.
+ *
+ * Copyright 2012-2014 Imagination Technologies Ltd.
+ */
+
+#include "img-ir-hw.h"
+
+/* Convert JVC data to a scancode */
+static int img_ir_jvc_scancode(int len, u64 raw, int *scancode, u64 protocols)
+{
+	unsigned int cust, data;
+
+	if (len != 16)
+		return -EINVAL;
+
+	cust = (raw >> 0) & 0xff;
+	data = (raw >> 8) & 0xff;
+
+	*scancode = cust << 8 | data;
+	return IMG_IR_SCANCODE;
+}
+
+/* Convert JVC scancode to JVC data filter */
+static int img_ir_jvc_filter(const struct rc_scancode_filter *in,
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
+struct img_ir_decoder img_ir_jvc = {
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
-- 
1.8.3.2


