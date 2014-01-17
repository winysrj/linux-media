Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48384 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbaAQOAT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 14/15] media: rc: img-ir: add Sharp decoder module
Date: Fri, 17 Jan 2014 13:58:59 +0000
Message-ID: <1389967140-20704-15-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the Sharp infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
v2:
- Update to new scancode interface (32-bit NEC).
- Update to new filtering interface (generic struct rc_scancode_filter).
- Remove modularity and dynamic registration/unregistration, adding
  Sharp directly to the list of decoders in img-ir-hw.c.
- Fix typo in logic 1 pulse width comment.
- Set tolerance to 20%, which seemed to be needed for the cases I have.
---
 drivers/media/rc/img-ir/Kconfig        |  7 +++
 drivers/media/rc/img-ir/Makefile       |  1 +
 drivers/media/rc/img-ir/img-ir-hw.c    |  4 ++
 drivers/media/rc/img-ir/img-ir-sharp.c | 99 ++++++++++++++++++++++++++++++++++
 4 files changed, 111 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-sharp.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index ab36577..48627f9 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -45,3 +45,10 @@ config IR_IMG_SONY
 	help
 	   Say Y here to enable support for the Sony protocol in the ImgTec
 	   infrared decoder block.
+
+config IR_IMG_SHARP
+	bool "Sharp protocol support"
+	depends on IR_IMG_HW
+	help
+	   Say Y here to enable support for the Sharp protocol in the ImgTec
+	   infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 978c0c6..792a3c4 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -4,6 +4,7 @@ img-ir-$(CONFIG_IR_IMG_HW)	+= img-ir-hw.o
 img-ir-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
 img-ir-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
 img-ir-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
+img-ir-$(CONFIG_IR_IMG_SHARP)	+= img-ir-sharp.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 17fb527..fc84b75 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -23,6 +23,7 @@ static DEFINE_SPINLOCK(img_ir_decoders_lock);
 extern struct img_ir_decoder img_ir_nec;
 extern struct img_ir_decoder img_ir_jvc;
 extern struct img_ir_decoder img_ir_sony;
+extern struct img_ir_decoder img_ir_sharp;
 
 static bool img_ir_decoders_preprocessed;
 static struct img_ir_decoder *img_ir_decoders[] = {
@@ -35,6 +36,9 @@ static struct img_ir_decoder *img_ir_decoders[] = {
 #ifdef CONFIG_IR_IMG_SONY
 	&img_ir_sony,
 #endif
+#ifdef CONFIG_IR_IMG_SHARP
+	&img_ir_sharp,
+#endif
 	NULL
 };
 
diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
new file mode 100644
index 0000000..3397cc5
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-sharp.c
@@ -0,0 +1,99 @@
+/*
+ * ImgTec IR Decoder setup for Sharp protocol.
+ *
+ * Copyright 2012-2014 Imagination Technologies Ltd.
+ */
+
+#include "img-ir-hw.h"
+
+/* Convert Sharp data to a scancode */
+static int img_ir_sharp_scancode(int len, u64 raw, int *scancode, u64 protocols)
+{
+	unsigned int addr, cmd, exp, chk;
+
+	if (len != 15)
+		return -EINVAL;
+
+	addr = (raw >>   0) & 0x1f;
+	cmd  = (raw >>   5) & 0xff;
+	exp  = (raw >>  13) &  0x1;
+	chk  = (raw >>  14) &  0x1;
+
+	/* validate data */
+	if (!exp)
+		return -EINVAL;
+	if (chk)
+		/* probably the second half of the message */
+		return -EINVAL;
+
+	*scancode = addr << 8 | cmd;
+	return IMG_IR_SCANCODE;
+}
+
+/* Convert Sharp scancode to Sharp data filter */
+static int img_ir_sharp_filter(const struct rc_scancode_filter *in,
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
+struct img_ir_decoder img_ir_sharp = {
+	.type = RC_BIT_SHARP,
+	.control = {
+		.decoden = 0,
+		.decodend2 = 1,
+		.code_type = IMG_IR_CODETYPE_PULSEDIST,
+		.d1validsel = 1,
+	},
+	/* main timings */
+	.tolerance = 20,	/* 20% */
+	.timings = {
+		/* 0 symbol */
+		.s10 = {
+			.pulse = { 320	/* 320 us */ },
+			.space = { 680	/* 1 ms period */ },
+		},
+		/* 1 symbol */
+		.s11 = {
+			.pulse = { 320	/* 320 us */ },
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
-- 
1.8.3.2


