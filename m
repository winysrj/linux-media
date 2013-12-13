Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53938 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab3LMPPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:15:00 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 08/11] media: rc: img-ir: add Sony decoder module
Date: Fri, 13 Dec 2013 15:12:56 +0000
Message-ID: <1386947579-26703-9-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an img-ir module for decoding the Sony infrared protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/Kconfig       |   7 ++
 drivers/media/rc/img-ir/Makefile      |   1 +
 drivers/media/rc/img-ir/img-ir-sony.c | 163 ++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-sony.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index b7774a30509f..38505188df0e 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -38,3 +38,10 @@ config IR_IMG_JVC
 	help
 	   Say Y or M here to enable support for the JVC protocol in the ImgTec
 	   infrared decoder block.
+
+config IR_IMG_SONY
+	tristate "Sony protocol support"
+	depends on IR_IMG && IR_IMG_HW
+	help
+	   Say Y or M here to enable support for the Sony protocol in the ImgTec
+	   infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 1d9643801f02..f3e7cc4f32e4 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -6,3 +6,4 @@ img-ir-objs			:= $(img-ir-y)
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
 obj-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
 obj-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
+obj-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img-ir/img-ir-sony.c
new file mode 100644
index 000000000000..964ab242d384
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-sony.c
@@ -0,0 +1,163 @@
+/*
+ * ImgTec IR Decoder setup for Sony (SIRC) protocol.
+ *
+ * Copyright 2012-2013 Imagination Technologies Ltd.
+ */
+
+#include <linux/module.h>
+
+#include "img-ir-hw.h"
+
+/* Convert Sony data to a scancode */
+static int img_ir_sony_scancode(int len, u64 raw, u64 protocols)
+{
+	unsigned int dev, subdev, func;
+
+	switch (len) {
+	case 12:
+		if (!(protocols & RC_BIT_SONY12))
+			goto invalid;
+		func   = raw & 0x7f;	/* first 7 bits */
+		raw    >>= 7;
+		dev    = raw & 0x1f;	/* next 5 bits */
+		subdev = 0;
+		break;
+	case 15:
+		if (!(protocols & RC_BIT_SONY15))
+			goto invalid;
+		func   = raw & 0x7f;	/* first 7 bits */
+		raw    >>= 7;
+		dev    = raw & 0xff;	/* next 8 bits */
+		subdev = 0;
+		break;
+	case 20:
+		if (!(protocols & RC_BIT_SONY20))
+			goto invalid;
+		func   = raw & 0x7f;	/* first 7 bits */
+		raw    >>= 7;
+		dev    = raw & 0x1f;	/* next 5 bits */
+		raw    >>= 5;
+		subdev = raw & 0xff;	/* next 8 bits */
+		break;
+	default:
+invalid:
+		return IMG_IR_ERR_INVALID;
+	}
+	return dev << 16 | subdev << 8 | func;
+}
+
+/* Convert NEC scancode to NEC data filter */
+static int img_ir_sony_filter(const struct img_ir_sc_filter *in,
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
+static struct img_ir_decoder img_ir_sony = {
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
+
+static int __init img_ir_sony_init(void)
+{
+	return img_ir_register_decoder(&img_ir_sony);
+}
+module_init(img_ir_sony_init);
+
+static void __exit img_ir_sony_exit(void)
+{
+	img_ir_unregister_decoder(&img_ir_sony);
+}
+module_exit(img_ir_sony_exit);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("ImgTec IR Sony SIRC protocol support");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2


