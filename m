Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48384 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaAQOAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:17 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 11/15] media: rc: img-ir: add NEC decoder module
Date: Fri, 17 Jan 2014 13:58:56 +0000
Message-ID: <1389967140-20704-12-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
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
v2:
- Update scancode and filter callbacks to handle 32-bit NEC as used by
  Apple and TiVo remotes (the new 32-bit NEC scancode format is used,
  with the correct bit orientation).
- Update to new scancode interface so that 32-bit NEC scancodes can be
  returned reliably.
- Update to new filtering interface (generic struct rc_scancode_filter).
- Make it possible to set the filter to extended NEC even when the high
  bits of the scancode value aren't set, by taking the mask into account
  too. My TV remote happens to use extended NEC with address 0x7f00,
  which unfortunately maps to scancodes 0x007f** which looks like normal
  NEC and couldn't previously be filtered.
- Remove modularity and dynamic registration/unregistration, adding NEC
  directly to the list of decoders in img-ir-hw.c.
---
 drivers/media/rc/img-ir/Kconfig      |   7 ++
 drivers/media/rc/img-ir/Makefile     |   1 +
 drivers/media/rc/img-ir/img-ir-hw.c  |   5 ++
 drivers/media/rc/img-ir/img-ir-nec.c | 148 +++++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-nec.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 60eaba6..28498a2 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -24,3 +24,10 @@ config IR_IMG_HW
 	   signals in hardware. This is more reliable, consumes less processing
 	   power since only a single interrupt is received for each scancode,
 	   and allows an IR scancode to be used as a wake event.
+
+config IR_IMG_NEC
+	bool "NEC protocol support"
+	depends on IR_IMG_HW
+	help
+	   Say Y here to enable support for the NEC, extended NEC, and 32-bit
+	   NEC protocols in the ImgTec infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 4ef86ed..c409197 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -1,6 +1,7 @@
 img-ir-y			:= img-ir-core.o
 img-ir-$(CONFIG_IR_IMG_RAW)	+= img-ir-raw.o
 img-ir-$(CONFIG_IR_IMG_HW)	+= img-ir-hw.o
+img-ir-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index a7c7481..79ec495 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -20,8 +20,13 @@
 /* Decoders lock (only modified to preprocess them) */
 static DEFINE_SPINLOCK(img_ir_decoders_lock);
 
+extern struct img_ir_decoder img_ir_nec;
+
 static bool img_ir_decoders_preprocessed;
 static struct img_ir_decoder *img_ir_decoders[] = {
+#ifdef CONFIG_IR_IMG_NEC
+	&img_ir_nec,
+#endif
 	NULL
 };
 
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
new file mode 100644
index 0000000..e7a731b
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -0,0 +1,148 @@
+/*
+ * ImgTec IR Decoder setup for NEC protocol.
+ *
+ * Copyright 2010-2014 Imagination Technologies Ltd.
+ */
+
+#include "img-ir-hw.h"
+
+/* Convert NEC data to a scancode */
+static int img_ir_nec_scancode(int len, u64 raw, int *scancode, u64 protocols)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+	/* a repeat code has no data */
+	if (!len)
+		return IMG_IR_REPEATCODE;
+	if (len != 32)
+		return -EINVAL;
+	/* raw encoding: ddDDaaAA */
+	addr     = (raw >>  0) & 0xff;
+	addr_inv = (raw >>  8) & 0xff;
+	data     = (raw >> 16) & 0xff;
+	data_inv = (raw >> 24) & 0xff;
+	if ((data_inv ^ data) != 0xff) {
+		/* 32-bit NEC (used by Apple and TiVo remotes) */
+		/* scan encoding: aaAAddDD */
+		*scancode = addr_inv << 24 |
+			    addr     << 16 |
+			    data_inv <<  8 |
+			    data;
+	} else if ((addr_inv ^ addr) != 0xff) {
+		/* Extended NEC */
+		/* scan encoding: AAaaDD */
+		*scancode = addr     << 16 |
+			    addr_inv <<  8 |
+			    data;
+	} else {
+		/* Normal NEC */
+		/* scan encoding: AADD */
+		*scancode = addr << 8 |
+			    data;
+	}
+	return IMG_IR_SCANCODE;
+}
+
+/* Convert NEC scancode to NEC data filter */
+static int img_ir_nec_filter(const struct rc_scancode_filter *in,
+			     struct img_ir_filter *out, u64 protocols)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+	unsigned int addr_m, addr_inv_m, data_m, data_inv_m;
+
+	data       = in->data & 0xff;
+	data_m     = in->mask & 0xff;
+
+	if ((in->data | in->mask) & 0xff000000) {
+		/* 32-bit NEC (used by Apple and TiVo remotes) */
+		/* scan encoding: aaAAddDD */
+		addr_inv   = (in->data >> 24) & 0xff;
+		addr_inv_m = (in->mask >> 24) & 0xff;
+		addr       = (in->data >> 16) & 0xff;
+		addr_m     = (in->mask >> 16) & 0xff;
+		data_inv   = (in->data >>  8) & 0xff;
+		data_inv_m = (in->mask >>  8) & 0xff;
+	} else if ((in->data | in->mask) & 0x00ff0000) {
+		/* Extended NEC */
+		/* scan encoding AAaaDD */
+		addr       = (in->data >> 16) & 0xff;
+		addr_m     = (in->mask >> 16) & 0xff;
+		addr_inv   = (in->data >>  8) & 0xff;
+		addr_inv_m = (in->mask >>  8) & 0xff;
+		data_inv   = data ^ 0xff;
+		data_inv_m = data_m;
+	} else {
+		/* Normal NEC */
+		/* scan encoding: AADD */
+		addr       = (in->data >>  8) & 0xff;
+		addr_m     = (in->mask >>  8) & 0xff;
+		addr_inv   = addr ^ 0xff;
+		addr_inv_m = addr_m;
+		data_inv   = data ^ 0xff;
+		data_inv_m = data_m;
+	}
+
+	/* raw encoding: ddDDaaAA */
+	out->data = data_inv << 24 |
+		    data     << 16 |
+		    addr_inv <<  8 |
+		    addr;
+	out->mask = data_inv_m << 24 |
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
+struct img_ir_decoder img_ir_nec = {
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
-- 
1.8.3.2


