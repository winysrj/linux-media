Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48381 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaAQOAT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 13/15] media: rc: img-ir: add Sony decoder module
Date: Fri, 17 Jan 2014 13:58:58 +0000
Message-ID: <1389967140-20704-14-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the Sony infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
v2:
- Update to new scancode interface (32-bit NEC).
- Update to new filtering interface (generic struct rc_scancode_filter).
- Remove modularity and dynamic registration/unregistration, adding Sony
  directly to the list of decoders in img-ir-hw.c.
---
 drivers/media/rc/img-ir/Kconfig       |   7 ++
 drivers/media/rc/img-ir/Makefile      |   1 +
 drivers/media/rc/img-ir/img-ir-hw.c   |   4 +
 drivers/media/rc/img-ir/img-ir-sony.c | 145 ++++++++++++++++++++++++++++++++++
 4 files changed, 157 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-sony.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 96006fbf..ab36577 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -38,3 +38,10 @@ config IR_IMG_JVC
 	help
 	   Say Y here to enable support for the JVC protocol in the ImgTec
 	   infrared decoder block.
+
+config IR_IMG_SONY
+	bool "Sony protocol support"
+	depends on IR_IMG_HW
+	help
+	   Say Y here to enable support for the Sony protocol in the ImgTec
+	   infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index c5f8f06..978c0c6 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -3,6 +3,7 @@ img-ir-$(CONFIG_IR_IMG_RAW)	+= img-ir-raw.o
 img-ir-$(CONFIG_IR_IMG_HW)	+= img-ir-hw.o
 img-ir-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
 img-ir-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
+img-ir-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index fc8a58b..17fb527 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -22,6 +22,7 @@ static DEFINE_SPINLOCK(img_ir_decoders_lock);
 
 extern struct img_ir_decoder img_ir_nec;
 extern struct img_ir_decoder img_ir_jvc;
+extern struct img_ir_decoder img_ir_sony;
 
 static bool img_ir_decoders_preprocessed;
 static struct img_ir_decoder *img_ir_decoders[] = {
@@ -31,6 +32,9 @@ static struct img_ir_decoder *img_ir_decoders[] = {
 #ifdef CONFIG_IR_IMG_JVC
 	&img_ir_jvc,
 #endif
+#ifdef CONFIG_IR_IMG_SONY
+	&img_ir_sony,
+#endif
 	NULL
 };
 
diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img-ir/img-ir-sony.c
new file mode 100644
index 0000000..993409a
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-sony.c
@@ -0,0 +1,145 @@
+/*
+ * ImgTec IR Decoder setup for Sony (SIRC) protocol.
+ *
+ * Copyright 2012-2014 Imagination Technologies Ltd.
+ */
+
+#include "img-ir-hw.h"
+
+/* Convert Sony data to a scancode */
+static int img_ir_sony_scancode(int len, u64 raw, int *scancode, u64 protocols)
+{
+	unsigned int dev, subdev, func;
+
+	switch (len) {
+	case 12:
+		if (!(protocols & RC_BIT_SONY12))
+			return -EINVAL;
+		func   = raw & 0x7f;	/* first 7 bits */
+		raw    >>= 7;
+		dev    = raw & 0x1f;	/* next 5 bits */
+		subdev = 0;
+		break;
+	case 15:
+		if (!(protocols & RC_BIT_SONY15))
+			return -EINVAL;
+		func   = raw & 0x7f;	/* first 7 bits */
+		raw    >>= 7;
+		dev    = raw & 0xff;	/* next 8 bits */
+		subdev = 0;
+		break;
+	case 20:
+		if (!(protocols & RC_BIT_SONY20))
+			return -EINVAL;
+		func   = raw & 0x7f;	/* first 7 bits */
+		raw    >>= 7;
+		dev    = raw & 0x1f;	/* next 5 bits */
+		raw    >>= 5;
+		subdev = raw & 0xff;	/* next 8 bits */
+		break;
+	default:
+		return -EINVAL;
+	}
+	*scancode = dev << 16 | subdev << 8 | func;
+	return IMG_IR_SCANCODE;
+}
+
+/* Convert NEC scancode to NEC data filter */
+static int img_ir_sony_filter(const struct rc_scancode_filter *in,
+			      struct img_ir_filter *out, u64 protocols)
+{
+	unsigned int dev, subdev, func;
+	unsigned int dev_m, subdev_m, func_m;
+	unsigned int len = 0;
+
+	dev      = (in->data >> 16) & 0xff;
+	dev_m    = (in->mask >> 16) & 0xff;
+	subdev   = (in->data >> 8)  & 0xff;
+	subdev_m = (in->mask >> 8)  & 0xff;
+	func     = (in->data >> 0)  & 0x7f;
+	func_m   = (in->mask >> 0)  & 0x7f;
+
+	if (subdev & subdev_m) {
+		/* can't encode subdev and higher device bits */
+		if (dev & dev_m & 0xe0)
+			return -EINVAL;
+		/* subdevice (extended) bits only in 20 bit encoding */
+		if (!(protocols & RC_BIT_SONY20))
+			return -EINVAL;
+		len = 20;
+		dev_m &= 0x1f;
+	} else if (dev & dev_m & 0xe0) {
+		/* upper device bits only in 15 bit encoding */
+		if (!(protocols & RC_BIT_SONY15))
+			return -EINVAL;
+		len = 15;
+		subdev_m = 0;
+	} else {
+		/*
+		 * The hardware mask cannot distinguish high device bits and low
+		 * extended bits, so logically AND those bits of the masks
+		 * together.
+		 */
+		subdev_m &= (dev_m >> 5) | 0xf8;
+		dev_m &= 0x1f;
+	}
+
+	/* ensure there aren't any bits straying between fields */
+	dev &= dev_m;
+	subdev &= subdev_m;
+
+	/* write the hardware filter */
+	out->data = func          |
+		    dev      << 7 |
+		    subdev   << 15;
+	out->mask = func_m        |
+		    dev_m    << 7 |
+		    subdev_m << 15;
+
+	if (len) {
+		out->minlen = len;
+		out->maxlen = len;
+	}
+	return 0;
+}
+
+/*
+ * Sony SIRC decoder
+ * See also http://www.sbprojects.com/knowledge/ir/sirc.php
+ *          http://picprojects.org.uk/projects/sirc/sonysirc.pdf
+ */
+struct img_ir_decoder img_ir_sony = {
+	.type = RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
+	.control = {
+		.decoden = 1,
+		.code_type = IMG_IR_CODETYPE_PULSELEN,
+	},
+	/* main timings */
+	.unit = 600000, /* 600 us */
+	.timings = {
+		/* leader symbol */
+		.ldr = {
+			.pulse = { 4	/* 2.4 ms */ },
+			.space = { 1	/* 600 us */ },
+		},
+		/* 0 symbol */
+		.s00 = {
+			.pulse = { 1	/* 600 us */ },
+			.space = { 1	/* 600 us */ },
+		},
+		/* 1 symbol */
+		.s01 = {
+			.pulse = { 2	/* 1.2 ms */ },
+			.space = { 1	/* 600 us */ },
+		},
+		/* free time */
+		.ft = {
+			.minlen = 12,
+			.maxlen = 20,
+			.ft_min = 10,	/* 6 ms */
+		},
+	},
+	/* scancode logic */
+	.scancode = img_ir_sony_scancode,
+	.filter = img_ir_sony_filter,
+};
-- 
1.8.3.2


