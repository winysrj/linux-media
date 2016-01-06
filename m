Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56715 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbcAFXiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 18:38:11 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [Patch v6 3/3] media: ti-vpe: Add CAL v4l2 camera capture driver
Date: Wed, 6 Jan 2016 17:37:26 -0600
Message-ID: <1452123446-5424-4-git-send-email-bparrot@ti.com>
In-Reply-To: <1452123446-5424-1-git-send-email-bparrot@ti.com>
References: <1452123446-5424-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Camera Adaptation Layer (CAL) is a block which consists of a dual
port CSI2/MIPI camera capture engine.
Port #0 can handle CSI2 camera connected to up to 4 data lanes.
Port #1 can handle CSI2 camera connected to up to 2 data lanes.
The driver implements the required API/ioctls to be V4L2 compliant.
Driver supports the following:
    - V4L2 API using DMABUF/MMAP buffer access based on videobuf2 api
    - Asynchronous sensor sub device registration
    - DT support

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig           |   12 +
 drivers/media/platform/Makefile          |    2 +
 drivers/media/platform/ti-vpe/Makefile   |    4 +
 drivers/media/platform/ti-vpe/cal.c      | 1970 ++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/cal_regs.h |  479 ++++++++
 5 files changed, 2467 insertions(+)
 create mode 100644 drivers/media/platform/ti-vpe/cal.c
 create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0c53805dff0e..db052f5a627a 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -120,6 +120,18 @@ source "drivers/media/platform/s5p-tv/Kconfig"
 source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 
+config VIDEO_TI_CAL
+	tristate "TI CAL (Camera Adaptation Layer) driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on SOC_DRA7XX || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	default n
+	---help---
+	  Support for the TI CAL (Camera Adaptation Layer) block
+	  found on DRA72X SoC.
+	  In TI Technical Reference Manual this module is referred as
+	  Camera Interface Subsystem (CAMSS).
+
 endif # V4L_PLATFORM_DRIVERS
 
 menuconfig V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index efa0295af87b..028a7233096b 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -18,6 +18,8 @@ obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
 
 obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
 
+obj-$(CONFIG_VIDEO_TI_CAL)		+= ti-vpe/
+
 obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
 obj-$(CONFIG_VIDEO_CODA) 		+= coda/
 
diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
index be680f839e77..e236059a60ad 100644
--- a/drivers/media/platform/ti-vpe/Makefile
+++ b/drivers/media/platform/ti-vpe/Makefile
@@ -3,3 +3,7 @@ obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
 ti-vpe-y := vpe.o sc.o csc.o vpdma.o
 
 ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
+
+obj-$(CONFIG_VIDEO_TI_CAL) += ti-cal.o
+
+ti-cal-y := cal.o
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
new file mode 100644
index 000000000000..69ec79ba49ee
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -0,0 +1,1970 @@
+/*
+ * TI CAL camera interface driver
+ *
+ * Copyright (c) 2015 Texas Instruments Inc.
+ * Benoit Parrot, <bparrot@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation
+ */
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioctl.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <linux/of_device.h>
+#include <linux/of_graph.h>
+
+#include <media/v4l2-of.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+#include "cal_regs.h"
+
+#define CAL_MODULE_NAME "cal"
+
+#define MAX_WIDTH 1920
+#define MAX_HEIGHT 1200
+
+#define CAL_VERSION "0.1.0"
+
+MODULE_DESCRIPTION("TI CAL driver");
+MODULE_AUTHOR("Benoit Parrot, <bparrot@ti.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(CAL_VERSION);
+
+static unsigned video_nr = -1;
+module_param(video_nr, uint, 0644);
+MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect");
+
+static unsigned debug;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
+/* timeperframe: min/max and default */
+static const struct v4l2_fract
+	tpf_default = {.numerator = 1001,	.denominator = 30000};
+
+#define cal_dbg(level, caldev, fmt, arg...)	\
+		v4l2_dbg(level, debug, &caldev->v4l2_dev, fmt, ##arg)
+#define cal_info(caldev, fmt, arg...)	\
+		v4l2_info(&caldev->v4l2_dev, fmt, ##arg)
+#define cal_err(caldev, fmt, arg...)	\
+		v4l2_err(&caldev->v4l2_dev, fmt, ##arg)
+
+#define ctx_dbg(level, ctx, fmt, arg...)	\
+		v4l2_dbg(level, debug, &ctx->v4l2_dev, fmt, ##arg)
+#define ctx_info(ctx, fmt, arg...)	\
+		v4l2_info(&ctx->v4l2_dev, fmt, ##arg)
+#define ctx_err(ctx, fmt, arg...)	\
+		v4l2_err(&ctx->v4l2_dev, fmt, ##arg)
+
+#define CAL_NUM_INPUT 1
+#define CAL_NUM_CONTEXT 2
+
+#define bytes_per_line(pixel, bpp) (ALIGN(pixel * bpp, 16))
+
+#define reg_read(dev, offset) ioread32(dev->base + offset)
+#define reg_write(dev, offset, val) iowrite32(val, dev->base + offset)
+
+#define reg_read_field(dev, offset, mask) get_field(reg_read(dev, offset), \
+						    mask)
+#define reg_write_field(dev, offset, field, mask) { \
+	u32 val = reg_read(dev, offset); \
+	set_field(&val, field, mask); \
+	reg_write(dev, offset, val); }
+
+/* ------------------------------------------------------------------
+ *	Basic structures
+ * ------------------------------------------------------------------
+ */
+
+struct cal_fmt {
+	u32	fourcc;
+	u32	code;
+	u8	depth;
+};
+
+static struct cal_fmt cal_formats[] = {
+	{
+		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_UYVY,
+		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_YVYU,
+		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_VYUY,
+		.code		= MEDIA_BUS_FMT_VYUY8_2X8,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.code		= MEDIA_BUS_FMT_RGB565_2X8_LE,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
+		.code		= MEDIA_BUS_FMT_RGB565_2X8_BE,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.code		= MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
+		.code		= MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_RGB24, /* rgb */
+		.code		= MEDIA_BUS_FMT_RGB888_2X12_LE,
+		.depth		= 24,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_BGR24, /* bgr */
+		.code		= MEDIA_BUS_FMT_RGB888_2X12_BE,
+		.depth		= 24,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_RGB32, /* argb */
+		.code		= MEDIA_BUS_FMT_ARGB8888_1X32,
+		.depth		= 32,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SBGGR8,
+		.code		= MEDIA_BUS_FMT_SBGGR8_1X8,
+		.depth		= 8,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SGBRG8,
+		.code		= MEDIA_BUS_FMT_SGBRG8_1X8,
+		.depth		= 8,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SGRBG8,
+		.code		= MEDIA_BUS_FMT_SGRBG8_1X8,
+		.depth		= 8,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SRGGB8,
+		.code		= MEDIA_BUS_FMT_SRGGB8_1X8,
+		.depth		= 8,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SBGGR10,
+		.code		= MEDIA_BUS_FMT_SBGGR10_1X10,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SGBRG10,
+		.code		= MEDIA_BUS_FMT_SGBRG10_1X10,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SGRBG10,
+		.code		= MEDIA_BUS_FMT_SGRBG10_1X10,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SRGGB10,
+		.code		= MEDIA_BUS_FMT_SRGGB10_1X10,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SBGGR12,
+		.code		= MEDIA_BUS_FMT_SBGGR12_1X12,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SGBRG12,
+		.code		= MEDIA_BUS_FMT_SGBRG12_1X12,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SGRBG12,
+		.code		= MEDIA_BUS_FMT_SGRBG12_1X12,
+		.depth		= 16,
+	}, {
+		.fourcc		= V4L2_PIX_FMT_SRGGB12,
+		.code		= MEDIA_BUS_FMT_SRGGB12_1X12,
+		.depth		= 16,
+	},
+};
+
+/*  Print Four-character-code (FOURCC) */
+static char *fourcc_to_str(u32 fmt)
+{
+	static char code[5];
+
+	code[0] = (unsigned char)(fmt & 0xff);
+	code[1] = (unsigned char)((fmt >> 8) & 0xff);
+	code[2] = (unsigned char)((fmt >> 16) & 0xff);
+	code[3] = (unsigned char)((fmt >> 24) & 0xff);
+	code[4] = '\0';
+
+	return code;
+}
+
+/* buffer for one video frame */
+struct cal_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer	vb;
+	struct list_head	list;
+	const struct cal_fmt	*fmt;
+};
+
+struct cal_dmaqueue {
+	struct list_head	active;
+
+	/* Counters to control fps rate */
+	int			frame;
+	int			ini_jiffies;
+};
+
+struct cm_data {
+	void __iomem		*base;
+	struct resource		*res;
+
+	unsigned int		camerrx_control;
+
+	struct platform_device *pdev;
+};
+
+struct cc_data {
+	void __iomem		*base;
+	struct resource		*res;
+
+	struct platform_device *pdev;
+};
+
+/*
+ * there is one cal_dev structure in the driver, it is shared by
+ * all instances.
+ */
+struct cal_dev {
+	int			irq;
+	void __iomem		*base;
+	struct resource		*res;
+	struct platform_device	*pdev;
+	struct v4l2_device	v4l2_dev;
+
+	/* Control Module handle */
+	struct cm_data		*cm;
+	/* Camera Core Module handle */
+	struct cc_data		*cc[CAL_NUM_CSI2_PORTS];
+
+	struct cal_ctx		*ctx[CAL_NUM_CONTEXT];
+};
+
+/*
+ * There is one cal_ctx structure for each camera core context.
+ */
+struct cal_ctx {
+	struct v4l2_device	v4l2_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct video_device	vdev;
+	struct v4l2_async_notifier notifier;
+	struct v4l2_subdev	*sensor;
+	struct v4l2_of_endpoint	endpoint;
+
+	struct v4l2_async_subdev asd;
+	struct v4l2_async_subdev *asd_list[1];
+
+	struct v4l2_fh		fh;
+	struct cal_dev		*dev;
+	struct cc_data		*cc;
+
+	/* v4l2_ioctl mutex */
+	struct mutex		mutex;
+	/* v4l2 buffers lock */
+	spinlock_t		slock;
+
+	/* Several counters */
+	unsigned long		jiffies;
+
+	struct vb2_alloc_ctx	*alloc_ctx;
+	struct cal_dmaqueue	vidq;
+
+	/* Input Number */
+	int			input;
+
+	/* video capture */
+	const struct cal_fmt	*fmt;
+	/* Used to store current pixel format */
+	struct v4l2_format		v_fmt;
+	/* Used to store current mbus frame format */
+	struct v4l2_mbus_framefmt	m_fmt;
+
+	/* Current subdev enumerated format */
+	struct cal_fmt		*active_fmt[ARRAY_SIZE(cal_formats)];
+	int			num_active_fmt;
+
+	struct v4l2_fract	timeperframe;
+	unsigned int		sequence;
+	unsigned int		external_rate;
+	struct vb2_queue	vb_vidq;
+	unsigned int		seq_count;
+	unsigned int		csi2_port;
+	unsigned int		virtual_channel;
+
+	/* Pointer pointing to current v4l2_buffer */
+	struct cal_buffer	*cur_frm;
+	/* Pointer pointing to next v4l2_buffer */
+	struct cal_buffer	*next_frm;
+};
+
+static const struct cal_fmt *find_format_by_pix(struct cal_ctx *ctx,
+						u32 pixelformat)
+{
+	const struct cal_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < ctx->num_active_fmt; k++) {
+		fmt = ctx->active_fmt[k];
+		if (fmt->fourcc == pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static const struct cal_fmt *find_format_by_code(struct cal_ctx *ctx,
+						 u32 code)
+{
+	const struct cal_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < ctx->num_active_fmt; k++) {
+		fmt = ctx->active_fmt[k];
+		if (fmt->code == code)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static inline struct cal_ctx *notifier_to_ctx(struct v4l2_async_notifier *n)
+{
+	return container_of(n, struct cal_ctx, notifier);
+}
+
+static inline int get_field(u32 value, u32 mask)
+{
+	return (value & mask) >> __ffs(mask);
+}
+
+static inline void set_field(u32 *valp, u32 field, u32 mask)
+{
+	u32 val = *valp;
+
+	val &= ~mask;
+	val |= (field << __ffs(mask)) & mask;
+	*valp = val;
+}
+
+/*
+ * Control Module block access
+ */
+static struct cm_data *cm_create(struct cal_dev *dev)
+{
+	struct platform_device *pdev = dev->pdev;
+	struct cm_data *cm;
+
+	cm = devm_kzalloc(&pdev->dev, sizeof(*cm), GFP_KERNEL);
+	if (!cm)
+		return ERR_PTR(-ENOMEM);
+
+	cm->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						"camerrx_control");
+	cm->base = devm_ioremap_resource(&pdev->dev, cm->res);
+	if (IS_ERR(cm->base)) {
+		cal_err(dev, "failed to ioremap\n");
+		return cm->base;
+	}
+
+	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
+		cm->res->name, &cm->res->start, &cm->res->end);
+
+	return cm;
+}
+
+static void camerarx_phy_enable(struct cal_ctx *ctx)
+{
+	u32 val;
+
+	if (!ctx->dev->cm->base) {
+		ctx_err(ctx, "cm not mapped\n");
+		return;
+	}
+
+	val = reg_read(ctx->dev->cm, CM_CTRL_CORE_CAMERRX_CONTROL);
+	if (ctx->csi2_port == 1) {
+		set_field(&val, 1, CM_CAMERRX_CTRL_CSI0_CTRLCLKEN_MASK);
+		set_field(&val, 0, CM_CAMERRX_CTRL_CSI0_CAMMODE_MASK);
+		/* enable all lanes by default */
+		set_field(&val, 0xf, CM_CAMERRX_CTRL_CSI0_LANEENABLE_MASK);
+		set_field(&val, 1, CM_CAMERRX_CTRL_CSI0_MODE_MASK);
+	} else if (ctx->csi2_port == 2) {
+		set_field(&val, 1, CM_CAMERRX_CTRL_CSI1_CTRLCLKEN_MASK);
+		set_field(&val, 0, CM_CAMERRX_CTRL_CSI1_CAMMODE_MASK);
+		/* enable all lanes by default */
+		set_field(&val, 0x3, CM_CAMERRX_CTRL_CSI1_LANEENABLE_MASK);
+		set_field(&val, 1, CM_CAMERRX_CTRL_CSI1_MODE_MASK);
+	}
+	reg_write(ctx->dev->cm, CM_CTRL_CORE_CAMERRX_CONTROL, val);
+}
+
+static void camerarx_phy_disable(struct cal_ctx *ctx)
+{
+	u32 val;
+
+	if (!ctx->dev->cm->base) {
+		ctx_err(ctx, "cm not mapped\n");
+		return;
+	}
+
+	val = reg_read(ctx->dev->cm, CM_CTRL_CORE_CAMERRX_CONTROL);
+	if (ctx->csi2_port == 1)
+		set_field(&val, 0x0, CM_CAMERRX_CTRL_CSI0_CTRLCLKEN_MASK);
+	else if (ctx->csi2_port == 2)
+		set_field(&val, 0x0, CM_CAMERRX_CTRL_CSI1_CTRLCLKEN_MASK);
+	reg_write(ctx->dev->cm, CM_CTRL_CORE_CAMERRX_CONTROL, val);
+}
+
+/*
+ * Camera Instance access block
+ */
+static struct cc_data *cc_create(struct cal_dev *dev, unsigned int core)
+{
+	struct platform_device *pdev = dev->pdev;
+	struct cc_data *cc;
+
+	cc = devm_kzalloc(&pdev->dev, sizeof(*cc), GFP_KERNEL);
+	if (!cc)
+		return ERR_PTR(-ENOMEM);
+
+	cc->res = platform_get_resource_byname(pdev,
+					       IORESOURCE_MEM,
+					       (core == 0) ?
+						"cal_rx_core0" :
+						"cal_rx_core1");
+	cc->base = devm_ioremap_resource(&pdev->dev, cc->res);
+	if (IS_ERR(cc->base)) {
+		cal_err(dev, "failed to ioremap\n");
+		return cc->base;
+	}
+
+	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
+		cc->res->name, &cc->res->start, &cc->res->end);
+
+	return cc;
+}
+
+/*
+ * Get Revision and HW info
+ */
+static void cal_get_hwinfo(struct cal_dev *dev)
+{
+	u32 revision = 0;
+	u32 hwinfo = 0;
+
+	revision = reg_read(dev, CAL_HL_REVISION);
+	cal_dbg(3, dev, "CAL_HL_REVISION = 0x%08x (expecting 0x40000200)\n",
+		revision);
+
+	hwinfo = reg_read(dev, CAL_HL_HWINFO);
+	cal_dbg(3, dev, "CAL_HL_HWINFO = 0x%08x (expecting 0xA3C90469)\n",
+		hwinfo);
+}
+
+static inline int cal_runtime_get(struct cal_dev *dev)
+{
+	int r;
+
+	r = pm_runtime_get_sync(&dev->pdev->dev);
+
+	return r;
+}
+
+static inline void cal_runtime_put(struct cal_dev *dev)
+{
+	pm_runtime_put_sync(&dev->pdev->dev);
+}
+
+static void cal_quickdump_regs(struct cal_dev *dev)
+{
+	cal_info(dev, "CAL Registers @ 0x%pa:\n", &dev->res->start);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
+		       dev->base, resource_size(dev->res), false);
+
+	if (dev->ctx[0]) {
+		cal_info(dev, "CSI2 Core 0 Registers @ %pa:\n",
+			 &dev->ctx[0]->cc->res->start);
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
+			       dev->ctx[0]->cc->base,
+			       resource_size(dev->ctx[0]->cc->res),
+			       false);
+	}
+
+	if (dev->ctx[1]) {
+		cal_info(dev, "CSI2 Core 1 Registers @ %pa:\n",
+			 &dev->ctx[1]->cc->res->start);
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
+			       dev->ctx[1]->cc->base,
+			       resource_size(dev->ctx[1]->cc->res),
+			       false);
+	}
+
+	cal_info(dev, "CAMERRX_Control Registers @ %pa:\n",
+		 &dev->cm->res->start);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
+		       dev->cm->base,
+		       resource_size(dev->cm->res), false);
+}
+
+/*
+ * Enable the expected IRQ sources
+ */
+static void enable_irqs(struct cal_ctx *ctx)
+{
+	/* Enable IRQ_WDMA_END 0/1 */
+	reg_write_field(ctx->dev,
+			CAL_HL_IRQENABLE_SET(2),
+			CAL_HL_IRQ_ENABLE,
+			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	/* Enable IRQ_WDMA_START 0/1 */
+	reg_write_field(ctx->dev,
+			CAL_HL_IRQENABLE_SET(3),
+			CAL_HL_IRQ_ENABLE,
+			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
+	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0xFF000000);
+}
+
+static void disable_irqs(struct cal_ctx *ctx)
+{
+	/* Disable IRQ_WDMA_END 0/1 */
+	reg_write_field(ctx->dev,
+			CAL_HL_IRQENABLE_CLR(2),
+			CAL_HL_IRQ_CLEAR,
+			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	/* Disable IRQ_WDMA_START 0/1 */
+	reg_write_field(ctx->dev,
+			CAL_HL_IRQENABLE_CLR(3),
+			CAL_HL_IRQ_CLEAR,
+			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
+	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0);
+}
+
+static void csi2_init(struct cal_ctx *ctx)
+{
+	int i;
+	u32 val;
+
+	val = reg_read(ctx->dev, CAL_CSI2_TIMING(ctx->csi2_port));
+	set_field(&val, CAL_GEN_ENABLE,
+		  CAL_CSI2_TIMING_FORCE_RX_MODE_IO1_MASK);
+	set_field(&val, CAL_GEN_ENABLE,
+		  CAL_CSI2_TIMING_STOP_STATE_X16_IO1_MASK);
+	set_field(&val, CAL_GEN_DISABLE,
+		  CAL_CSI2_TIMING_STOP_STATE_X4_IO1_MASK);
+	set_field(&val, 407, CAL_CSI2_TIMING_STOP_STATE_COUNTER_IO1_MASK);
+	reg_write(ctx->dev, CAL_CSI2_TIMING(ctx->csi2_port), val);
+	ctx_dbg(3, ctx, "CAL_CSI2_TIMING(%d) = 0x%08x\n", ctx->csi2_port,
+		reg_read(ctx->dev, CAL_CSI2_TIMING(ctx->csi2_port)));
+
+	val = reg_read(ctx->dev, CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port));
+	set_field(&val, CAL_CSI2_COMPLEXIO_CFG_RESET_CTRL_OPERATIONAL,
+		  CAL_CSI2_COMPLEXIO_CFG_RESET_CTRL_MASK);
+	set_field(&val, CAL_CSI2_COMPLEXIO_CFG_PWR_CMD_STATE_ON,
+		  CAL_CSI2_COMPLEXIO_CFG_PWR_CMD_MASK);
+	reg_write(ctx->dev, CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port), val);
+	for (i = 0; i < 10; i++) {
+		if (reg_read_field(ctx->dev,
+				   CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port),
+				   CAL_CSI2_COMPLEXIO_CFG_PWR_STATUS_MASK) ==
+		    CAL_CSI2_COMPLEXIO_CFG_PWR_STATUS_STATE_ON)
+			break;
+		usleep_range(1000, 1100);
+	}
+	ctx_dbg(3, ctx, "CAL_CSI2_COMPLEXIO_CFG(%d) = 0x%08x\n", ctx->csi2_port,
+		reg_read(ctx->dev, CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port)));
+
+	val = reg_read(ctx->dev, CAL_CTRL);
+	set_field(&val, CAL_CTRL_BURSTSIZE_BURST128, CAL_CTRL_BURSTSIZE_MASK);
+	set_field(&val, 0xF, CAL_CTRL_TAGCNT_MASK);
+	set_field(&val, CAL_CTRL_POSTED_WRITES_NONPOSTED,
+		  CAL_CTRL_POSTED_WRITES_MASK);
+	set_field(&val, 0xFF, CAL_CTRL_MFLAGL_MASK);
+	set_field(&val, 0xFF, CAL_CTRL_MFLAGH_MASK);
+	reg_write(ctx->dev, CAL_CTRL, val);
+	ctx_dbg(3, ctx, "CAL_CTRL = 0x%08x\n", reg_read(ctx->dev, CAL_CTRL));
+}
+
+static void csi2_lane_config(struct cal_ctx *ctx)
+{
+	u32 val = reg_read(ctx->dev, CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port));
+	u32 lane_mask = CAL_CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK;
+	u32 polarity_mask = CAL_CSI2_COMPLEXIO_CFG_CLOCK_POL_MASK;
+	struct v4l2_of_bus_mipi_csi2 *mipi_csi2 = &ctx->endpoint.bus.mipi_csi2;
+	int lane;
+
+	set_field(&val, mipi_csi2->clock_lane + 1, lane_mask);
+	set_field(&val, mipi_csi2->lane_polarities[0], polarity_mask);
+	for (lane = 0; lane < mipi_csi2->num_data_lanes; lane++) {
+		/*
+		 * Every lane are one nibble apart starting with the
+		 * clock followed by the data lanes so shift masks by 4.
+		 */
+		lane_mask <<= 4;
+		polarity_mask <<= 4;
+		set_field(&val, mipi_csi2->data_lanes[lane] + 1, lane_mask);
+		set_field(&val, mipi_csi2->lane_polarities[lane + 1],
+			  polarity_mask);
+	}
+
+	reg_write(ctx->dev, CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port), val);
+	ctx_dbg(3, ctx, "CAL_CSI2_COMPLEXIO_CFG(%d) = 0x%08x\n",
+		ctx->csi2_port, val);
+}
+
+static void csi2_ppi_enable(struct cal_ctx *ctx)
+{
+	reg_write_field(ctx->dev, CAL_CSI2_PPI_CTRL(ctx->csi2_port),
+			CAL_GEN_ENABLE, CAL_CSI2_PPI_CTRL_IF_EN_MASK);
+}
+
+static void csi2_ppi_disable(struct cal_ctx *ctx)
+{
+	reg_write_field(ctx->dev, CAL_CSI2_PPI_CTRL(ctx->csi2_port),
+			CAL_GEN_DISABLE, CAL_CSI2_PPI_CTRL_IF_EN_MASK);
+}
+
+static void csi2_ctx_config(struct cal_ctx *ctx)
+{
+	u32 val;
+
+	val = reg_read(ctx->dev, CAL_CSI2_CTX0(ctx->csi2_port));
+	set_field(&val, ctx->csi2_port, CAL_CSI2_CTX_CPORT_MASK);
+	/*
+	 * DT type: MIPI CSI-2 Specs
+	 *   0x1: All - DT filter is disabled
+	 *  0x24: RGB888 1 pixel  = 3 bytes
+	 *  0x2B: RAW10  4 pixels = 5 bytes
+	 *  0x2A: RAW8   1 pixel  = 1 byte
+	 *  0x1E: YUV422 2 pixels = 4 bytes
+	 */
+	set_field(&val, 0x1, CAL_CSI2_CTX_DT_MASK);
+	/* Virtual Channel from the CSI2 sensor usually 0! */
+	set_field(&val, ctx->virtual_channel, CAL_CSI2_CTX_VC_MASK);
+	/* NUM_LINES_PER_FRAME => 0 means auto detect */
+	set_field(&val, 0, CAL_CSI2_CTX_LINES_MASK);
+	set_field(&val, CAL_CSI2_CTX_ATT_PIX, CAL_CSI2_CTX_ATT_MASK);
+	set_field(&val, CAL_CSI2_CTX_PACK_MODE_LINE,
+		  CAL_CSI2_CTX_PACK_MODE_MASK);
+	reg_write(ctx->dev, CAL_CSI2_CTX0(ctx->csi2_port), val);
+	ctx_dbg(3, ctx, "CAL_CSI2_CTX0(%d) = 0x%08x\n", ctx->csi2_port,
+		reg_read(ctx->dev, CAL_CSI2_CTX0(ctx->csi2_port)));
+}
+
+static void pix_proc_config(struct cal_ctx *ctx)
+{
+	u32 val;
+
+	val = reg_read(ctx->dev, CAL_PIX_PROC(ctx->csi2_port));
+	set_field(&val, CAL_PIX_PROC_EXTRACT_B8, CAL_PIX_PROC_EXTRACT_MASK);
+	set_field(&val, CAL_PIX_PROC_DPCMD_BYPASS, CAL_PIX_PROC_DPCMD_MASK);
+	set_field(&val, CAL_PIX_PROC_DPCME_BYPASS, CAL_PIX_PROC_DPCME_MASK);
+	set_field(&val, CAL_PIX_PROC_PACK_B8, CAL_PIX_PROC_PACK_MASK);
+	set_field(&val, ctx->csi2_port, CAL_PIX_PROC_CPORT_MASK);
+	set_field(&val, CAL_GEN_ENABLE, CAL_PIX_PROC_EN_MASK);
+	reg_write(ctx->dev, CAL_PIX_PROC(ctx->csi2_port), val);
+	ctx_dbg(3, ctx, "CAL_PIX_PROC(%d) = 0x%08x\n", ctx->csi2_port,
+		reg_read(ctx->dev, CAL_PIX_PROC(ctx->csi2_port)));
+}
+
+static void cal_wr_dma_config(struct cal_ctx *ctx,
+			      unsigned int width)
+{
+	u32 val;
+
+	val = reg_read(ctx->dev, CAL_WR_DMA_CTRL(ctx->csi2_port));
+	set_field(&val, ctx->csi2_port, CAL_WR_DMA_CTRL_CPORT_MASK);
+	set_field(&val, CAL_WR_DMA_CTRL_DTAG_PIX_DAT,
+		  CAL_WR_DMA_CTRL_DTAG_MASK);
+	set_field(&val, CAL_WR_DMA_CTRL_MODE_CONST,
+		  CAL_WR_DMA_CTRL_MODE_MASK);
+	set_field(&val, CAL_WR_DMA_CTRL_PATTERN_LINEAR,
+		  CAL_WR_DMA_CTRL_PATTERN_MASK);
+	set_field(&val, CAL_GEN_ENABLE, CAL_WR_DMA_CTRL_STALL_RD_MASK);
+	reg_write(ctx->dev, CAL_WR_DMA_CTRL(ctx->csi2_port), val);
+	ctx_dbg(3, ctx, "CAL_WR_DMA_CTRL(%d) = 0x%08x\n", ctx->csi2_port,
+		reg_read(ctx->dev, CAL_WR_DMA_CTRL(ctx->csi2_port)));
+
+	/*
+	 * width/16 not sure but giving it a whirl.
+	 * zero does not work right
+	 */
+	reg_write_field(ctx->dev,
+			CAL_WR_DMA_OFST(ctx->csi2_port),
+			(width / 16),
+			CAL_WR_DMA_OFST_MASK);
+	ctx_dbg(3, ctx, "CAL_WR_DMA_OFST(%d) = 0x%08x\n", ctx->csi2_port,
+		reg_read(ctx->dev, CAL_WR_DMA_OFST(ctx->csi2_port)));
+
+	val = reg_read(ctx->dev, CAL_WR_DMA_XSIZE(ctx->csi2_port));
+	/* 64 bit word means no skipping */
+	set_field(&val, 0, CAL_WR_DMA_XSIZE_XSKIP_MASK);
+	/*
+	 * (width*8)/64 this should be size of an entire line
+	 * in 64bit word but 0 means all data until the end
+	 * is detected automagically
+	 */
+	set_field(&val, (width / 8), CAL_WR_DMA_XSIZE_MASK);
+	reg_write(ctx->dev, CAL_WR_DMA_XSIZE(ctx->csi2_port), val);
+	ctx_dbg(3, ctx, "CAL_WR_DMA_XSIZE(%d) = 0x%08x\n", ctx->csi2_port,
+		reg_read(ctx->dev, CAL_WR_DMA_XSIZE(ctx->csi2_port)));
+}
+
+static void cal_wr_dma_addr(struct cal_ctx *ctx, unsigned int dmaaddr)
+{
+	reg_write(ctx->dev, CAL_WR_DMA_ADDR(ctx->csi2_port), dmaaddr);
+}
+
+/*
+ * TCLK values are OK at their reset values
+ */
+#define TCLK_TERM	0
+#define TCLK_MISS	1
+#define TCLK_SETTLE	14
+#define THS_SETTLE	15
+
+static void csi2_phy_config(struct cal_ctx *ctx)
+{
+	unsigned int reg0, reg1;
+	unsigned int ths_term, ths_settle;
+	unsigned int ddrclkperiod_us;
+
+	/*
+	 * THS_TERM: Programmed value = floor(20 ns/DDRClk period) - 2.
+	 */
+	ddrclkperiod_us = ctx->external_rate / 2000000;
+	ddrclkperiod_us = 1000000 / ddrclkperiod_us;
+	ctx_dbg(1, ctx, "ddrclkperiod_us: %d\n", ddrclkperiod_us);
+
+	ths_term = 20000 / ddrclkperiod_us;
+	ths_term = (ths_term >= 2) ? ths_term - 2 : ths_term;
+	ctx_dbg(1, ctx, "ths_term: %d (0x%02x)\n", ths_term, ths_term);
+
+	/*
+	 * THS_SETTLE: Programmed value = floor(176.3 ns/CtrlClk period) - 1.
+	 *	Since CtrlClk is fixed at 96Mhz then we get
+	 *	ths_settle = floor(176.3 / 10.416) - 1 = 15
+	 * If we ever switch to a dynamic clock then this code might be useful
+	 *
+	 * unsigned int ctrlclkperiod_us;
+	 * ctrlclkperiod_us = 96000000 / 1000000;
+	 * ctrlclkperiod_us = 1000000 / ctrlclkperiod_us;
+	 * ctx_dbg(1, ctx, "ctrlclkperiod_us: %d\n", ctrlclkperiod_us);
+
+	 * ths_settle = 176300  / ctrlclkperiod_us;
+	 * ths_settle = (ths_settle > 1) ? ths_settle - 1 : ths_settle;
+	 */
+
+	ths_settle = THS_SETTLE;
+	ctx_dbg(1, ctx, "ths_settle: %d (0x%02x)\n", ths_settle, ths_settle);
+
+	reg0 = reg_read(ctx->cc, CAL_CSI2_PHY_REG0);
+	set_field(&reg0, CAL_CSI2_PHY_REG0_HSCLOCKCONFIG_DISABLE,
+		  CAL_CSI2_PHY_REG0_HSCLOCKCONFIG_MASK);
+	set_field(&reg0, ths_term, CAL_CSI2_PHY_REG0_THS_TERM_MASK);
+	set_field(&reg0, ths_settle, CAL_CSI2_PHY_REG0_THS_SETTLE_MASK);
+
+	ctx_dbg(1, ctx, "CSI2_%d_REG0 = 0x%08x\n", (ctx->csi2_port - 1), reg0);
+	reg_write(ctx->cc, CAL_CSI2_PHY_REG0, reg0);
+
+	reg1 = reg_read(ctx->cc, CAL_CSI2_PHY_REG1);
+	set_field(&reg1, TCLK_TERM, CAL_CSI2_PHY_REG1_TCLK_TERM_MASK);
+	set_field(&reg1, 0xb8, CAL_CSI2_PHY_REG1_DPHY_HS_SYNC_PATTERN_MASK);
+	set_field(&reg1, TCLK_MISS, CAL_CSI2_PHY_REG1_CTRLCLK_DIV_FACTOR_MASK);
+	set_field(&reg1, TCLK_SETTLE, CAL_CSI2_PHY_REG1_TCLK_SETTLE_MASK);
+
+	ctx_dbg(1, ctx, "CSI2_%d_REG1 = 0x%08x\n", (ctx->csi2_port - 1), reg1);
+	reg_write(ctx->cc, CAL_CSI2_PHY_REG1, reg1);
+}
+
+static int cal_get_external_info(struct cal_ctx *ctx)
+{
+	struct v4l2_ctrl *ctrl;
+
+	ctrl = v4l2_ctrl_find(ctx->sensor->ctrl_handler, V4L2_CID_PIXEL_RATE);
+	if (!ctrl) {
+		ctx_err(ctx, "no pixel rate control in subdev: %s\n",
+			ctx->sensor->name);
+		return -EPIPE;
+	}
+
+	ctx->external_rate = v4l2_ctrl_g_ctrl_int64(ctrl);
+	ctx_dbg(3, ctx, "sensor Pixel Rate: %d\n", ctx->external_rate);
+
+	return 0;
+}
+
+static inline void cal_schedule_next_buffer(struct cal_ctx *ctx)
+{
+	struct cal_dmaqueue *dma_q = &ctx->vidq;
+	struct cal_buffer *buf;
+	unsigned long addr;
+
+	buf = list_entry(dma_q->active.next, struct cal_buffer, list);
+	ctx->next_frm = buf;
+	list_del(&buf->list);
+
+	addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
+	cal_wr_dma_addr(ctx, addr);
+}
+
+static inline void cal_process_buffer_complete(struct cal_ctx *ctx)
+{
+	ctx->cur_frm->vb.vb2_buf.timestamp = ktime_get_ns();
+	ctx->cur_frm->vb.field = ctx->m_fmt.field;
+	ctx->cur_frm->vb.sequence = ctx->sequence++;
+
+	vb2_buffer_done(&ctx->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
+	ctx->cur_frm = ctx->next_frm;
+}
+
+#define isvcirqset(irq, vc, ff) (irq & \
+	(CAL_CSI2_VC_IRQENABLE_ ##ff ##_IRQ_##vc ##_MASK))
+
+#define isportirqset(irq, port) (irq & CAL_HL_IRQ_MASK(port))
+
+static irqreturn_t cal_irq(int irq_cal, void *data)
+{
+	struct cal_dev *dev = (struct cal_dev *)data;
+	struct cal_ctx *ctx;
+	struct cal_dmaqueue *dma_q;
+	u32 irqst2, irqst3;
+
+	/* Check which DMA just finished */
+	irqst2 = reg_read(dev, CAL_HL_IRQSTATUS(2));
+	if (irqst2) {
+		/* Clear Interrupt status */
+		reg_write(dev, CAL_HL_IRQSTATUS(2), irqst2);
+
+		/* Need to check both port */
+		if (isportirqset(irqst2, 1)) {
+			ctx = dev->ctx[0];
+
+			if (ctx->cur_frm != ctx->next_frm)
+				cal_process_buffer_complete(ctx);
+		}
+
+		if (isportirqset(irqst2, 2)) {
+			ctx = dev->ctx[1];
+
+			if (ctx->cur_frm != ctx->next_frm)
+				cal_process_buffer_complete(ctx);
+		}
+	}
+
+	/* Check which DMA just started */
+	irqst3 = reg_read(dev, CAL_HL_IRQSTATUS(3));
+	if (irqst3) {
+		/* Clear Interrupt status */
+		reg_write(dev, CAL_HL_IRQSTATUS(3), irqst3);
+
+		/* Need to check both port */
+		if (isportirqset(irqst3, 1)) {
+			ctx = dev->ctx[0];
+			dma_q = &ctx->vidq;
+
+			spin_lock(&ctx->slock);
+			if (!list_empty(&dma_q->active) &&
+			    ctx->cur_frm == ctx->next_frm)
+				cal_schedule_next_buffer(ctx);
+			spin_unlock(&ctx->slock);
+		}
+
+		if (isportirqset(irqst3, 2)) {
+			ctx = dev->ctx[1];
+			dma_q = &ctx->vidq;
+
+			spin_lock(&ctx->slock);
+			if (!list_empty(&dma_q->active) &&
+			    ctx->cur_frm == ctx->next_frm)
+				cal_schedule_next_buffer(ctx);
+			spin_unlock(&ctx->slock);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * video ioctls
+ */
+static int cal_querycap(struct file *file, void *priv,
+			struct v4l2_capability *cap)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+
+	strlcpy(cap->driver, CAL_MODULE_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, CAL_MODULE_NAME, sizeof(cap->card));
+
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "platform:%s", ctx->v4l2_dev.name);
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int cal_enum_fmt_vid_cap(struct file *file, void  *priv,
+				struct v4l2_fmtdesc *f)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+	const struct cal_fmt *fmt = NULL;
+
+	if (f->index >= ctx->num_active_fmt)
+		return -EINVAL;
+
+	fmt = ctx->active_fmt[f->index];
+
+	f->pixelformat = fmt->fourcc;
+	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	return 0;
+}
+
+static int __subdev_get_format(struct cal_ctx *ctx,
+			       struct v4l2_mbus_framefmt *fmt)
+{
+	struct v4l2_subdev_format sd_fmt;
+	struct v4l2_mbus_framefmt *mbus_fmt = &sd_fmt.format;
+	int ret;
+
+	if (!ctx->sensor)
+		return -EINVAL;
+
+	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	sd_fmt.pad = 0;
+
+	ret = v4l2_subdev_call(ctx->sensor, pad, get_fmt, NULL, &sd_fmt);
+	if (ret)
+		return ret;
+
+	*fmt = *mbus_fmt;
+
+	ctx_dbg(1, ctx, "%s %dx%d code:%04X\n", __func__,
+		fmt->width, fmt->height, fmt->code);
+
+	return 0;
+}
+
+static int __subdev_set_format(struct cal_ctx *ctx,
+			       struct v4l2_mbus_framefmt *fmt)
+{
+	struct v4l2_subdev_format sd_fmt;
+	struct v4l2_mbus_framefmt *mbus_fmt = &sd_fmt.format;
+	int ret;
+
+	if (!ctx->sensor)
+		return -EINVAL;
+
+	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	sd_fmt.pad = 0;
+	*mbus_fmt = *fmt;
+
+	ret = v4l2_subdev_call(ctx->sensor, pad, set_fmt, NULL, &sd_fmt);
+	if (ret)
+		return ret;
+
+	ctx_dbg(1, ctx, "%s %dx%d code:%04X\n", __func__,
+		fmt->width, fmt->height, fmt->code);
+
+	return 0;
+}
+
+static int cal_calc_format_size(struct cal_ctx *ctx,
+				const struct cal_fmt *fmt,
+				struct v4l2_format *f)
+{
+	if (!fmt) {
+		ctx_dbg(3, ctx, "No cal_fmt provided!\n");
+		return -EINVAL;
+	}
+
+	v4l_bound_align_image(&f->fmt.pix.width, 48, MAX_WIDTH, 2,
+			      &f->fmt.pix.height, 32, MAX_HEIGHT, 0, 0);
+	f->fmt.pix.bytesperline = bytes_per_line(f->fmt.pix.width,
+						 fmt->depth >> 3);
+	f->fmt.pix.sizeimage = f->fmt.pix.height *
+			       f->fmt.pix.bytesperline;
+
+	ctx_dbg(3, ctx, "%s: fourcc: %s size: %dx%d bpl:%d img_size:%d\n",
+		__func__, fourcc_to_str(f->fmt.pix.pixelformat),
+		f->fmt.pix.width, f->fmt.pix.height,
+		f->fmt.pix.bytesperline, f->fmt.pix.sizeimage);
+
+	return 0;
+}
+
+static int cal_g_fmt_vid_cap(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+
+	*f = ctx->v_fmt;
+
+	return 0;
+}
+
+static int cal_try_fmt_vid_cap(struct file *file, void *priv,
+			       struct v4l2_format *f)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+	const struct cal_fmt *fmt;
+	struct v4l2_subdev_frame_size_enum fse;
+	int ret, found;
+
+	fmt = find_format_by_pix(ctx, f->fmt.pix.pixelformat);
+	if (!fmt) {
+		ctx_dbg(3, ctx, "Fourcc format (0x%08x) not found.\n",
+			f->fmt.pix.pixelformat);
+
+		/* Just get the first one enumerated */
+		fmt = ctx->active_fmt[0];
+		f->fmt.pix.pixelformat = fmt->fourcc;
+	}
+
+	f->fmt.pix.field = ctx->v_fmt.fmt.pix.field;
+
+	/* check for/find a valid width/height */
+	ret = 0;
+	found = false;
+	fse.pad = 0;
+	fse.code = fmt->code;
+	fse.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	for (fse.index = 0; ; fse.index++) {
+		ret = v4l2_subdev_call(ctx->sensor, pad, enum_frame_size,
+				       NULL, &fse);
+		if (ret)
+			break;
+
+		if ((f->fmt.pix.width == fse.max_width) &&
+		    (f->fmt.pix.height == fse.max_height)) {
+			found = true;
+			break;
+		} else if ((f->fmt.pix.width >= fse.min_width) &&
+			 (f->fmt.pix.width <= fse.max_width) &&
+			 (f->fmt.pix.height >= fse.min_height) &&
+			 (f->fmt.pix.height <= fse.max_height)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		/* use existing values as default */
+		f->fmt.pix.width = ctx->v_fmt.fmt.pix.width;
+		f->fmt.pix.height =  ctx->v_fmt.fmt.pix.height;
+	}
+
+	/*
+	 * Use current colorspace for now, it will get
+	 * updated properly during s_fmt
+	 */
+	f->fmt.pix.colorspace = ctx->v_fmt.fmt.pix.colorspace;
+	return cal_calc_format_size(ctx, fmt, f);
+}
+
+static int cal_s_fmt_vid_cap(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+	struct vb2_queue *q = &ctx->vb_vidq;
+	const struct cal_fmt *fmt;
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret;
+
+	if (vb2_is_busy(q)) {
+		ctx_dbg(3, ctx, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	ret = cal_try_fmt_vid_cap(file, priv, f);
+	if (ret < 0)
+		return ret;
+
+	fmt = find_format_by_pix(ctx, f->fmt.pix.pixelformat);
+
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, fmt->code);
+
+	ret = __subdev_set_format(ctx, &mbus_fmt);
+	if (ret)
+		return ret;
+
+	/* Just double check nothing has gone wrong */
+	if (mbus_fmt.code != fmt->code) {
+		ctx_dbg(3, ctx,
+			"%s subdev changed format on us, this should not happen\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	v4l2_fill_pix_format(&ctx->v_fmt.fmt.pix, &mbus_fmt);
+	ctx->v_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ctx->v_fmt.fmt.pix.pixelformat  = fmt->fourcc;
+	cal_calc_format_size(ctx, fmt, &ctx->v_fmt);
+	ctx->fmt = fmt;
+	ctx->m_fmt = mbus_fmt;
+	*f = ctx->v_fmt;
+
+	return 0;
+}
+
+static int cal_enum_framesizes(struct file *file, void *fh,
+			       struct v4l2_frmsizeenum *fsize)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+	const struct cal_fmt *fmt;
+	struct v4l2_subdev_frame_size_enum fse;
+	int ret;
+
+	/* check for valid format */
+	fmt = find_format_by_pix(ctx, fsize->pixel_format);
+	if (!fmt) {
+		ctx_dbg(3, ctx, "Invalid pixel code: %x\n",
+			fsize->pixel_format);
+		return -EINVAL;
+	}
+
+	fse.index = fsize->index;
+	fse.pad = 0;
+	fse.code = fmt->code;
+
+	ret = v4l2_subdev_call(ctx->sensor, pad, enum_frame_size, NULL, &fse);
+	if (ret)
+		return -EINVAL;
+
+	ctx_dbg(1, ctx, "%s: index: %d code: %x W:[%d,%d] H:[%d,%d]\n",
+		__func__, fse.index, fse.code, fse.min_width, fse.max_width,
+		fse.min_height, fse.max_height);
+
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = fse.max_width;
+	fsize->discrete.height = fse.max_height;
+
+	return 0;
+}
+
+static int cal_enum_input(struct file *file, void *priv,
+			  struct v4l2_input *inp)
+{
+	if (inp->index >= CAL_NUM_INPUT)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	sprintf(inp->name, "Camera %u", inp->index);
+	return 0;
+}
+
+static int cal_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+
+	*i = ctx->input;
+	return 0;
+}
+
+static int cal_s_input(struct file *file, void *priv, unsigned int i)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+
+	if (i >= CAL_NUM_INPUT)
+		return -EINVAL;
+
+	ctx->input = i;
+	return 0;
+}
+
+/* timeperframe is arbitrary and continuous */
+static int cal_enum_frameintervals(struct file *file, void *priv,
+				   struct v4l2_frmivalenum *fival)
+{
+	struct cal_ctx *ctx = video_drvdata(file);
+	const struct cal_fmt *fmt;
+	struct v4l2_subdev_frame_size_enum fse;
+	int ret;
+
+	if (fival->index)
+		return -EINVAL;
+
+	fmt = find_format_by_pix(ctx, fival->pixel_format);
+	if (!fmt)
+		return -EINVAL;
+
+	/* check for valid width/height */
+	ret = 0;
+	fse.pad = 0;
+	fse.code = fmt->code;
+	fse.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	for (fse.index = 0; ; fse.index++) {
+		ret = v4l2_subdev_call(ctx->sensor, pad, enum_frame_size,
+				       NULL, &fse);
+		if (ret)
+			return -EINVAL;
+
+		if ((fival->width == fse.max_width) &&
+		    (fival->height == fse.max_height))
+			break;
+		else if ((fival->width >= fse.min_width) &&
+			 (fival->width <= fse.max_width) &&
+			 (fival->height >= fse.min_height) &&
+			 (fival->height <= fse.max_height))
+			break;
+
+		return -EINVAL;
+	}
+
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete.numerator = 1;
+	fival->discrete.denominator = 30;
+
+	return 0;
+}
+
+/*
+ * Videobuf operations
+ */
+static int cal_queue_setup(struct vb2_queue *vq,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct cal_ctx *ctx = vb2_get_drv_priv(vq);
+	unsigned size = ctx->v_fmt.fmt.pix.sizeimage;
+
+	if (vq->num_buffers + *nbuffers < 3)
+		*nbuffers = 3 - vq->num_buffers;
+	alloc_ctxs[0] = ctx->alloc_ctx;
+
+	if (*nplanes) {
+		if (sizes[0] < size)
+			return -EINVAL;
+		size = sizes[0];
+	}
+
+	*nplanes = 1;
+	sizes[0] = size;
+
+	ctx_dbg(3, ctx, "nbuffers=%d, size=%d\n", *nbuffers, sizes[0]);
+
+	return 0;
+}
+
+static int cal_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct cal_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct cal_buffer *buf = container_of(vb, struct cal_buffer,
+					      vb.vb2_buf);
+	unsigned long size;
+
+	if (WARN_ON(!ctx->fmt))
+		return -EINVAL;
+
+	size = ctx->v_fmt.fmt.pix.sizeimage;
+	if (vb2_plane_size(vb, 0) < size) {
+		ctx_err(ctx,
+			"data will not fit into plane (%lu < %lu)\n",
+			vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
+	return 0;
+}
+
+static void cal_buffer_queue(struct vb2_buffer *vb)
+{
+	struct cal_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct cal_buffer *buf = container_of(vb, struct cal_buffer,
+					      vb.vb2_buf);
+	struct cal_dmaqueue *vidq = &ctx->vidq;
+	unsigned long flags = 0;
+
+	/* recheck locking */
+	spin_lock_irqsave(&ctx->slock, flags);
+	list_add_tail(&buf->list, &vidq->active);
+	spin_unlock_irqrestore(&ctx->slock, flags);
+}
+
+static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct cal_ctx *ctx = vb2_get_drv_priv(vq);
+	struct cal_dmaqueue *dma_q = &ctx->vidq;
+	struct cal_buffer *buf, *tmp;
+	unsigned long addr = 0;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	if (list_empty(&dma_q->active)) {
+		spin_unlock_irqrestore(&ctx->slock, flags);
+		ctx_dbg(3, ctx, "buffer queue is empty\n");
+		return -EIO;
+	}
+
+	buf = list_entry(dma_q->active.next, struct cal_buffer, list);
+	ctx->cur_frm = buf;
+	ctx->next_frm = buf;
+	list_del(&buf->list);
+	spin_unlock_irqrestore(&ctx->slock, flags);
+
+	addr = vb2_dma_contig_plane_dma_addr(&ctx->cur_frm->vb.vb2_buf, 0);
+	ctx->sequence = 0;
+
+	ret = cal_get_external_info(ctx);
+	if (ret < 0)
+		goto err;
+
+	cal_runtime_get(ctx->dev);
+
+	enable_irqs(ctx);
+	camerarx_phy_enable(ctx);
+	csi2_init(ctx);
+	csi2_phy_config(ctx);
+	csi2_lane_config(ctx);
+	csi2_ctx_config(ctx);
+	pix_proc_config(ctx);
+	cal_wr_dma_config(ctx, ctx->v_fmt.fmt.pix.bytesperline);
+	cal_wr_dma_addr(ctx, addr);
+	csi2_ppi_enable(ctx);
+
+	if (ctx->sensor) {
+		if (v4l2_subdev_call(ctx->sensor, video, s_stream, 1)) {
+			ctx_err(ctx, "stream on failed in subdev\n");
+			cal_runtime_put(ctx->dev);
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	if (debug >= 4)
+		cal_quickdump_regs(ctx->dev);
+
+	return 0;
+
+err:
+	list_for_each_entry_safe(buf, tmp, &dma_q->active, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	return ret;
+}
+
+static void cal_stop_streaming(struct vb2_queue *vq)
+{
+	struct cal_ctx *ctx = vb2_get_drv_priv(vq);
+	struct cal_dmaqueue *dma_q = &ctx->vidq;
+	struct cal_buffer *buf, *tmp;
+	unsigned long flags;
+
+	if (ctx->sensor) {
+		if (v4l2_subdev_call(ctx->sensor, video, s_stream, 0))
+			ctx_err(ctx, "stream off failed in subdev\n");
+	}
+
+	csi2_ppi_disable(ctx);
+	disable_irqs(ctx);
+
+	/* Release all active buffers */
+	spin_lock_irqsave(&ctx->slock, flags);
+	list_for_each_entry_safe(buf, tmp, &dma_q->active, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	}
+
+	if (ctx->cur_frm == ctx->next_frm) {
+		vb2_buffer_done(&ctx->cur_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	} else {
+		vb2_buffer_done(&ctx->cur_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&ctx->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
+	}
+	ctx->cur_frm = NULL;
+	ctx->next_frm = NULL;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+
+	cal_runtime_put(ctx->dev);
+}
+
+static struct vb2_ops cal_video_qops = {
+	.queue_setup		= cal_queue_setup,
+	.buf_prepare		= cal_buffer_prepare,
+	.buf_queue		= cal_buffer_queue,
+	.start_streaming	= cal_start_streaming,
+	.stop_streaming		= cal_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static const struct v4l2_file_operations cal_fops = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vb2_fop_release,
+	.read           = vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_ioctl_ops cal_ioctl_ops = {
+	.vidioc_querycap      = cal_querycap,
+	.vidioc_enum_fmt_vid_cap  = cal_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap     = cal_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap   = cal_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap     = cal_s_fmt_vid_cap,
+	.vidioc_enum_framesizes   = cal_enum_framesizes,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+	.vidioc_enum_input    = cal_enum_input,
+	.vidioc_g_input       = cal_g_input,
+	.vidioc_s_input       = cal_s_input,
+	.vidioc_enum_frameintervals = cal_enum_frameintervals,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
+	.vidioc_log_status    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static struct video_device cal_videodev = {
+	.name		= CAL_MODULE_NAME,
+	.fops		= &cal_fops,
+	.ioctl_ops	= &cal_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release_empty,
+};
+
+/* -----------------------------------------------------------------
+ *	Initialization and module stuff
+ * ------------------------------------------------------------------
+ */
+static int cal_complete_ctx(struct cal_ctx *ctx);
+
+static int cal_async_bound(struct v4l2_async_notifier *notifier,
+			   struct v4l2_subdev *subdev,
+			   struct v4l2_async_subdev *asd)
+{
+	struct cal_ctx *ctx = notifier_to_ctx(notifier);
+	struct v4l2_subdev_mbus_code_enum mbus_code;
+	int ret = 0;
+	int i, j, k;
+
+	if (ctx->sensor) {
+		ctx_info(ctx, "Rejecting subdev %s (Already set!!)",
+			 subdev->name);
+		return 0;
+	}
+
+	ctx->sensor = subdev;
+	ctx_dbg(1, ctx, "Using sensor %s for capture\n", subdev->name);
+
+	/* Enumerate sub device formats and enable all matching local formats */
+	ctx->num_active_fmt = 0;
+	for (j = 0, i = 0; ret != -EINVAL; ++j) {
+		struct cal_fmt *fmt;
+
+		memset(&mbus_code, 0, sizeof(mbus_code));
+		mbus_code.index = j;
+		ret = v4l2_subdev_call(subdev, pad, enum_mbus_code,
+				       NULL, &mbus_code);
+		if (ret)
+			continue;
+
+		ctx_dbg(2, ctx,
+			"subdev %s: code: %04x idx: %d\n",
+			subdev->name, mbus_code.code, j);
+
+		for (k = 0; k < ARRAY_SIZE(cal_formats); k++) {
+			fmt = &cal_formats[k];
+
+			if (mbus_code.code == fmt->code) {
+				ctx->active_fmt[i] = fmt;
+				ctx_dbg(2, ctx,
+					"matched fourcc: %s: code: %04x idx: %d\n",
+					fourcc_to_str(fmt->fourcc),
+					fmt->code, i);
+				ctx->num_active_fmt = ++i;
+			}
+		}
+	}
+
+	if (i == 0) {
+		ctx_err(ctx, "No suitable format reported by subdev %s\n",
+			subdev->name);
+		return -EINVAL;
+	}
+
+	cal_complete_ctx(ctx);
+
+	return 0;
+}
+
+static int cal_async_complete(struct v4l2_async_notifier *notifier)
+{
+	struct cal_ctx *ctx = notifier_to_ctx(notifier);
+	const struct cal_fmt *fmt;
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret;
+
+	ret = __subdev_get_format(ctx, &mbus_fmt);
+	if (ret)
+		return ret;
+
+	fmt = find_format_by_code(ctx, mbus_fmt.code);
+	if (!fmt) {
+		ctx_dbg(3, ctx, "mbus code format (0x%08x) not found.\n",
+			mbus_fmt.code);
+		return -EINVAL;
+	}
+
+	/* Save current subdev format */
+	v4l2_fill_pix_format(&ctx->v_fmt.fmt.pix, &mbus_fmt);
+	ctx->v_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ctx->v_fmt.fmt.pix.pixelformat  = fmt->fourcc;
+	cal_calc_format_size(ctx, fmt, &ctx->v_fmt);
+	ctx->fmt = fmt;
+	ctx->m_fmt = mbus_fmt;
+
+	return 0;
+}
+
+static int cal_complete_ctx(struct cal_ctx *ctx)
+{
+	struct video_device *vfd;
+	struct vb2_queue *q;
+	int ret;
+
+	ctx->timeperframe = tpf_default;
+	ctx->external_rate = 192000000;
+
+	/* initialize locks */
+	spin_lock_init(&ctx->slock);
+	mutex_init(&ctx->mutex);
+
+	/* initialize queue */
+	q = &ctx->vb_vidq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+	q->drv_priv = ctx;
+	q->buf_struct_size = sizeof(struct cal_buffer);
+	q->ops = &cal_video_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &ctx->mutex;
+	q->min_buffers_needed = 3;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		return ret;
+
+	/* init video dma queues */
+	INIT_LIST_HEAD(&ctx->vidq.active);
+
+	vfd = &ctx->vdev;
+	*vfd = cal_videodev;
+	vfd->v4l2_dev = &ctx->v4l2_dev;
+	vfd->queue = q;
+
+	/*
+	 * Provide a mutex to v4l2 core. It will be used to protect
+	 * all fops and v4l2 ioctls.
+	 */
+	vfd->lock = &ctx->mutex;
+	video_set_drvdata(vfd, ctx);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, video_nr);
+	if (ret < 0)
+		return ret;
+
+	v4l2_info(&ctx->v4l2_dev, "V4L2 device registered as %s\n",
+		  video_device_node_name(vfd));
+
+	ctx->alloc_ctx = vb2_dma_contig_init_ctx(vfd->v4l2_dev->dev);
+	if (IS_ERR(ctx->alloc_ctx)) {
+		ctx_err(ctx, "Failed to alloc vb2 context\n");
+		ret = PTR_ERR(ctx->alloc_ctx);
+		goto vdev_unreg;
+	}
+
+	return 0;
+
+vdev_unreg:
+	video_unregister_device(vfd);
+	return ret;
+}
+
+static struct device_node *
+of_get_next_port(const struct device_node *parent,
+		 struct device_node *prev)
+{
+	struct device_node *port = NULL;
+
+	if (!parent)
+		return NULL;
+
+	if (!prev) {
+		struct device_node *ports;
+		/*
+		 * It's the first call, we have to find a port subnode
+		 * within this node or within an optional 'ports' node.
+		 */
+		ports = of_get_child_by_name(parent, "ports");
+		if (ports)
+			parent = ports;
+
+		port = of_get_child_by_name(parent, "port");
+
+		/* release the 'ports' node */
+		of_node_put(ports);
+	} else {
+		struct device_node *ports;
+
+		ports = of_get_parent(prev);
+		if (!ports)
+			return NULL;
+
+		do {
+			port = of_get_next_child(ports, prev);
+			if (!port) {
+				of_node_put(ports);
+				return NULL;
+			}
+			prev = port;
+		} while (of_node_cmp(port->name, "port") != 0);
+	}
+
+	return port;
+}
+
+static struct device_node *
+of_get_next_endpoint(const struct device_node *parent,
+		     struct device_node *prev)
+{
+	struct device_node *ep = NULL;
+
+	if (!parent)
+		return NULL;
+
+	do {
+		ep = of_get_next_child(parent, prev);
+		if (!ep)
+			return NULL;
+		prev = ep;
+	} while (of_node_cmp(ep->name, "endpoint") != 0);
+
+	return ep;
+}
+
+static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
+{
+	struct platform_device *pdev = ctx->dev->pdev;
+	struct device_node *ep_node, *port, *remote_ep,
+			*sensor_node, *parent;
+	struct v4l2_of_endpoint *endpoint;
+	struct v4l2_async_subdev *asd;
+	u32 regval = 0;
+	int ret, index, found_port = 0, lane;
+
+	parent = pdev->dev.of_node;
+
+	asd = &ctx->asd;
+	endpoint = &ctx->endpoint;
+
+	ep_node = NULL;
+	port = NULL;
+	remote_ep = NULL;
+	sensor_node = NULL;
+	ret = -EINVAL;
+
+	ctx_dbg(3, ctx, "Scanning Port node for csi2 port: %d\n", inst);
+	for (index = 0; index < CAL_NUM_CSI2_PORTS; index++) {
+		port = of_get_next_port(parent, port);
+		if (!port) {
+			ctx_dbg(1, ctx, "No port node found for csi2 port:%d\n",
+				index);
+			goto cleanup_exit;
+		}
+
+		/* Match the slice number with <REG> */
+		of_property_read_u32(port, "reg", &regval);
+		ctx_dbg(3, ctx, "port:%d inst:%d <reg>:%d\n",
+			index, inst, regval);
+		if ((regval == inst) && (index == inst)) {
+			found_port = 1;
+			break;
+		}
+	}
+
+	if (!found_port) {
+		ctx_dbg(1, ctx, "No port node matches csi2 port:%d\n",
+			inst);
+		goto cleanup_exit;
+	}
+
+	ctx_dbg(3, ctx, "Scanning sub-device for csi2 port: %d\n",
+		inst);
+
+	ep_node = of_get_next_endpoint(port, ep_node);
+	if (!ep_node) {
+		ctx_dbg(3, ctx, "can't get next endpoint\n");
+		goto cleanup_exit;
+	}
+
+	sensor_node = of_graph_get_remote_port_parent(ep_node);
+	if (!sensor_node) {
+		ctx_dbg(3, ctx, "can't get remote parent\n");
+		goto cleanup_exit;
+	}
+	asd->match_type = V4L2_ASYNC_MATCH_OF;
+	asd->match.of.node = sensor_node;
+
+	remote_ep = of_parse_phandle(ep_node, "remote-endpoint", 0);
+	if (!remote_ep) {
+		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
+		goto cleanup_exit;
+	}
+	v4l2_of_parse_endpoint(remote_ep, endpoint);
+
+	if (endpoint->bus_type != V4L2_MBUS_CSI2) {
+		ctx_err(ctx, "Port:%d sub-device %s is not a CSI2 device\n",
+			inst, sensor_node->name);
+		goto cleanup_exit;
+	}
+
+	/* Store Virtual Channel number */
+	ctx->virtual_channel = endpoint->base.id;
+
+	ctx_dbg(3, ctx, "Port:%d v4l2-endpoint: CSI2\n", inst);
+	ctx_dbg(3, ctx, "Virtual Channel=%d\n", ctx->virtual_channel);
+	ctx_dbg(3, ctx, "flags=0x%08x\n", endpoint->bus.mipi_csi2.flags);
+	ctx_dbg(3, ctx, "clock_lane=%d\n", endpoint->bus.mipi_csi2.clock_lane);
+	ctx_dbg(3, ctx, "num_data_lanes=%d\n",
+		endpoint->bus.mipi_csi2.num_data_lanes);
+	ctx_dbg(3, ctx, "data_lanes= <\n");
+	for (lane = 0; lane < endpoint->bus.mipi_csi2.num_data_lanes; lane++)
+		ctx_dbg(3, ctx, "\t%d\n",
+			endpoint->bus.mipi_csi2.data_lanes[lane]);
+	ctx_dbg(3, ctx, "\t>\n");
+
+	ctx_dbg(1, ctx, "Port: %d found sub-device %s\n",
+		inst, sensor_node->name);
+
+	ctx->asd_list[0] = asd;
+	ctx->notifier.subdevs = ctx->asd_list;
+	ctx->notifier.num_subdevs = 1;
+	ctx->notifier.bound = cal_async_bound;
+	ctx->notifier.complete = cal_async_complete;
+	ret = v4l2_async_notifier_register(&ctx->v4l2_dev,
+					   &ctx->notifier);
+	if (ret) {
+		ctx_err(ctx, "Error registering async notifier\n");
+		ret = -EINVAL;
+	}
+
+cleanup_exit:
+	if (!remote_ep)
+		of_node_put(remote_ep);
+	if (!sensor_node)
+		of_node_put(sensor_node);
+	if (!ep_node)
+		of_node_put(ep_node);
+	if (!port)
+		of_node_put(port);
+
+	return ret;
+}
+
+static struct cal_ctx *cal_create_instance(struct cal_dev *dev, int inst)
+{
+	struct cal_ctx *ctx;
+	struct v4l2_ctrl_handler *hdl;
+	int ret;
+
+	ctx = devm_kzalloc(&dev->pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return 0;
+
+	/* save the cal_dev * for future ref */
+	ctx->dev = dev;
+
+	snprintf(ctx->v4l2_dev.name, sizeof(ctx->v4l2_dev.name),
+		 "%s-%03d", CAL_MODULE_NAME, inst);
+	ret = v4l2_device_register(&dev->pdev->dev, &ctx->v4l2_dev);
+	if (ret)
+		goto err_exit;
+
+	hdl = &ctx->ctrl_handler;
+	ret = v4l2_ctrl_handler_init(hdl, 11);
+	if (ret) {
+		ctx_err(ctx, "Failed to init ctrl handler\n");
+		goto unreg_dev;
+	}
+	ctx->v4l2_dev.ctrl_handler = hdl;
+
+	/* Make sure Camera Core H/W register area is available */
+	ctx->cc = dev->cc[inst];
+
+	/* Store the instance id */
+	ctx->csi2_port = inst + 1;
+
+	ret = of_cal_create_instance(ctx, inst);
+	if (ret) {
+		ret = -EINVAL;
+		goto free_hdl;
+	}
+	return ctx;
+
+free_hdl:
+	v4l2_ctrl_handler_free(hdl);
+unreg_dev:
+	v4l2_device_unregister(&ctx->v4l2_dev);
+err_exit:
+	return 0;
+}
+
+static int cal_probe(struct platform_device *pdev)
+{
+	struct cal_dev *dev;
+	int ret;
+	int irq;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	/* set pseudo v4l2 device name so we can use v4l2_printk */
+	strlcpy(dev->v4l2_dev.name, CAL_MODULE_NAME,
+		sizeof(dev->v4l2_dev.name));
+
+	/* save pdev pointer */
+	dev->pdev = pdev;
+
+	dev->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						"cal_top");
+	dev->base = devm_ioremap_resource(&pdev->dev, dev->res);
+	if (IS_ERR(dev->base))
+		return PTR_ERR(dev->base);
+
+	cal_dbg(1, dev, "ioresource %s at %pa - %pa\n",
+		dev->res->name, &dev->res->start, &dev->res->end);
+
+	irq = platform_get_irq(pdev, 0);
+	cal_dbg(1, dev, "got irq# %d\n", irq);
+	ret = devm_request_irq(&pdev->dev, irq, cal_irq, 0, CAL_MODULE_NAME,
+			       dev);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, dev);
+
+	dev->cm = cm_create(dev);
+	if (IS_ERR(dev->cm))
+		return PTR_ERR(dev->cm);
+
+	dev->cc[0] = cc_create(dev, 0);
+	if (IS_ERR(dev->cc[0]))
+		return PTR_ERR(dev->cc[0]);
+
+	dev->cc[1] = cc_create(dev, 1);
+	if (IS_ERR(dev->cc[1]))
+		return PTR_ERR(dev->cc[1]);
+
+	dev->ctx[0] = NULL;
+	dev->ctx[1] = NULL;
+
+	dev->ctx[0] = cal_create_instance(dev, 0);
+	dev->ctx[1] = cal_create_instance(dev, 1);
+	if (!dev->ctx[0] && !dev->ctx[1]) {
+		cal_err(dev, "Neither port is configured, no point in staying up\n");
+		return -ENODEV;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+
+	ret = cal_runtime_get(dev);
+	if (ret)
+		goto runtime_disable;
+
+	/* Just check we can actually access the module */
+	cal_get_hwinfo(dev);
+
+	cal_runtime_put(dev);
+
+	return 0;
+
+runtime_disable:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
+}
+
+static int cal_remove(struct platform_device *pdev)
+{
+	struct cal_dev *dev =
+		(struct cal_dev *)platform_get_drvdata(pdev);
+	struct cal_ctx *ctx;
+	int i;
+
+	cal_dbg(1, dev, "Removing %s\n", CAL_MODULE_NAME);
+
+	cal_runtime_get(dev);
+
+	for (i = 0; i < CAL_NUM_CONTEXT; i++) {
+		ctx = dev->ctx[i];
+		if (ctx) {
+			ctx_dbg(1, ctx, "unregistering %s\n",
+				video_device_node_name(&ctx->vdev));
+			camerarx_phy_disable(ctx);
+			v4l2_async_notifier_unregister(&ctx->notifier);
+			vb2_dma_contig_cleanup_ctx(ctx->alloc_ctx);
+			v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+			v4l2_device_unregister(&ctx->v4l2_dev);
+			video_unregister_device(&ctx->vdev);
+		}
+	}
+
+	cal_runtime_put(dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id cal_of_match[] = {
+	{ .compatible = "ti,dra72-cal", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, cal_of_match);
+#endif
+
+static struct platform_driver cal_pdrv = {
+	.probe		= cal_probe,
+	.remove		= cal_remove,
+	.driver		= {
+		.name	= CAL_MODULE_NAME,
+		.of_match_table = of_match_ptr(cal_of_match),
+	},
+};
+
+module_platform_driver(cal_pdrv);
diff --git a/drivers/media/platform/ti-vpe/cal_regs.h b/drivers/media/platform/ti-vpe/cal_regs.h
new file mode 100644
index 000000000000..82b3dcf87128
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/cal_regs.h
@@ -0,0 +1,479 @@
+/*
+ * TI CAL camera interface driver
+ *
+ * Copyright (c) 2015 Texas Instruments Inc.
+ *
+ * Benoit Parrot, <bparrot@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef __TI_CAL_REGS_H
+#define __TI_CAL_REGS_H
+
+#define CAL_NUM_CSI2_PORTS		2
+
+/* CAL register offsets */
+
+#define CAL_HL_REVISION			0x0000
+#define CAL_HL_HWINFO			0x0004
+#define CAL_HL_SYSCONFIG		0x0010
+#define CAL_HL_IRQ_EOI			0x001c
+#define CAL_HL_IRQSTATUS_RAW(m)		(0x20U + ((m-1) * 0x10U))
+#define CAL_HL_IRQSTATUS(m)		(0x24U + ((m-1) * 0x10U))
+#define CAL_HL_IRQENABLE_SET(m)		(0x28U + ((m-1) * 0x10U))
+#define CAL_HL_IRQENABLE_CLR(m)		(0x2cU + ((m-1) * 0x10U))
+#define CAL_PIX_PROC(m)			(0xc0U + ((m-1) * 0x4U))
+#define CAL_CTRL			0x100
+#define CAL_CTRL1			0x104
+#define CAL_LINE_NUMBER_EVT		0x108
+#define CAL_VPORT_CTRL1			0x120
+#define CAL_VPORT_CTRL2			0x124
+#define CAL_BYS_CTRL1			0x130
+#define CAL_BYS_CTRL2			0x134
+#define CAL_RD_DMA_CTRL			0x140
+#define CAL_RD_DMA_PIX_ADDR		0x144
+#define CAL_RD_DMA_PIX_OFST		0x148
+#define CAL_RD_DMA_XSIZE		0x14c
+#define CAL_RD_DMA_YSIZE		0x150
+#define CAL_RD_DMA_INIT_ADDR		0x154
+#define CAL_RD_DMA_INIT_OFST		0x168
+#define CAL_RD_DMA_CTRL2		0x16c
+#define CAL_WR_DMA_CTRL(m)		(0x200U + ((m-1) * 0x10U))
+#define CAL_WR_DMA_ADDR(m)		(0x204U + ((m-1) * 0x10U))
+#define CAL_WR_DMA_OFST(m)		(0x208U + ((m-1) * 0x10U))
+#define CAL_WR_DMA_XSIZE(m)		(0x20cU + ((m-1) * 0x10U))
+#define CAL_CSI2_PPI_CTRL(m)		(0x300U + ((m-1) * 0x80U))
+#define CAL_CSI2_COMPLEXIO_CFG(m)	(0x304U + ((m-1) * 0x80U))
+#define CAL_CSI2_COMPLEXIO_IRQSTATUS(m)	(0x308U + ((m-1) * 0x80U))
+#define CAL_CSI2_SHORT_PACKET(m)	(0x30cU + ((m-1) * 0x80U))
+#define CAL_CSI2_COMPLEXIO_IRQENABLE(m)	(0x310U + ((m-1) * 0x80U))
+#define CAL_CSI2_TIMING(m)		(0x314U + ((m-1) * 0x80U))
+#define CAL_CSI2_VC_IRQENABLE(m)	(0x318U + ((m-1) * 0x80U))
+#define CAL_CSI2_VC_IRQSTATUS(m)	(0x328U + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX0(m)		(0x330U + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX1(m)		(0x334U + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX2(m)		(0x338U + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX3(m)		(0x33cU + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX4(m)		(0x340U + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX5(m)		(0x344U + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX6(m)		(0x348U + ((m-1) * 0x80U))
+#define CAL_CSI2_CTX7(m)		(0x34cU + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS0(m)		(0x350U + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS1(m)		(0x354U + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS2(m)		(0x358U + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS3(m)		(0x35cU + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS4(m)		(0x360U + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS5(m)		(0x364U + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS6(m)		(0x368U + ((m-1) * 0x80U))
+#define CAL_CSI2_STATUS7(m)		(0x36cU + ((m-1) * 0x80U))
+
+/* CAL CSI2 PHY register offsets */
+#define CAL_CSI2_PHY_REG0		0x000
+#define CAL_CSI2_PHY_REG1		0x004
+#define CAL_CSI2_PHY_REG2		0x008
+
+/* CAL Control Module Core Camerrx Control register offsets */
+#define CM_CTRL_CORE_CAMERRX_CONTROL	0x000
+
+/*********************************************************************
+* Generic value used in various field below
+*********************************************************************/
+
+#define CAL_GEN_DISABLE			0
+#define CAL_GEN_ENABLE			1
+#define CAL_GEN_FALSE			0
+#define CAL_GEN_TRUE			1
+
+/*********************************************************************
+* Field Definition Macros
+*********************************************************************/
+
+#define CAL_HL_REVISION_MINOR_MASK		GENMASK(5, 0)
+#define CAL_HL_REVISION_CUSTOM_MASK		GENMASK(7, 6)
+#define CAL_HL_REVISION_MAJOR_MASK		GENMASK(10, 8)
+#define CAL_HL_REVISION_RTL_MASK		GENMASK(15, 11)
+#define CAL_HL_REVISION_FUNC_MASK		GENMASK(27, 16)
+#define CAL_HL_REVISION_SCHEME_MASK		GENMASK(31, 30)
+#define CAL_HL_REVISION_SCHEME_H08			1
+#define CAL_HL_REVISION_SCHEME_LEGACY			0
+
+#define CAL_HL_HWINFO_WFIFO_MASK		GENMASK(3, 0)
+#define CAL_HL_HWINFO_RFIFO_MASK		GENMASK(7, 4)
+#define CAL_HL_HWINFO_PCTX_MASK			GENMASK(12, 8)
+#define CAL_HL_HWINFO_WCTX_MASK			GENMASK(18, 13)
+#define CAL_HL_HWINFO_VFIFO_MASK		GENMASK(22, 19)
+#define CAL_HL_HWINFO_NCPORT_MASK		GENMASK(27, 23)
+#define CAL_HL_HWINFO_NPPI_CTXS0_MASK		GENMASK(29, 28)
+#define CAL_HL_HWINFO_NPPI_CTXS1_MASK		GENMASK(31, 30)
+#define CAL_HL_HWINFO_NPPI_CONTEXTS_ZERO		0
+#define CAL_HL_HWINFO_NPPI_CONTEXTS_FOUR		1
+#define CAL_HL_HWINFO_NPPI_CONTEXTS_EIGHT		2
+#define CAL_HL_HWINFO_NPPI_CONTEXTS_RESERVED		3
+
+#define CAL_HL_SYSCONFIG_SOFTRESET_MASK		BIT_MASK(0)
+#define CAL_HL_SYSCONFIG_SOFTRESET_DONE			0x0
+#define CAL_HL_SYSCONFIG_SOFTRESET_PENDING		0x1
+#define CAL_HL_SYSCONFIG_SOFTRESET_NOACTION		0x0
+#define CAL_HL_SYSCONFIG_SOFTRESET_RESET		0x1
+#define CAL_HL_SYSCONFIG_IDLE_MASK		GENMASK(3, 2)
+#define CAL_HL_SYSCONFIG_IDLEMODE_FORCE			0
+#define CAL_HL_SYSCONFIG_IDLEMODE_NO			1
+#define CAL_HL_SYSCONFIG_IDLEMODE_SMART1		2
+#define CAL_HL_SYSCONFIG_IDLEMODE_SMART2		3
+
+#define CAL_HL_IRQ_EOI_LINE_NUMBER_MASK		BIT_MASK(0)
+#define CAL_HL_IRQ_EOI_LINE_NUMBER_READ0		0
+#define CAL_HL_IRQ_EOI_LINE_NUMBER_EOI0			0
+
+#define CAL_HL_IRQ_MASK(m)			BIT_MASK(m-1)
+#define CAL_HL_IRQ_NOACTION				0x0
+#define CAL_HL_IRQ_ENABLE				0x1
+#define CAL_HL_IRQ_CLEAR				0x1
+#define CAL_HL_IRQ_DISABLED				0x0
+#define CAL_HL_IRQ_ENABLED				0x1
+#define CAL_HL_IRQ_PENDING				0x1
+
+#define CAL_PIX_PROC_EN_MASK			BIT_MASK(0)
+#define CAL_PIX_PROC_EXTRACT_MASK		GENMASK(4, 1)
+#define CAL_PIX_PROC_EXTRACT_B6				0x0
+#define CAL_PIX_PROC_EXTRACT_B7				0x1
+#define CAL_PIX_PROC_EXTRACT_B8				0x2
+#define CAL_PIX_PROC_EXTRACT_B10			0x3
+#define CAL_PIX_PROC_EXTRACT_B10_MIPI			0x4
+#define CAL_PIX_PROC_EXTRACT_B12			0x5
+#define CAL_PIX_PROC_EXTRACT_B12_MIPI			0x6
+#define CAL_PIX_PROC_EXTRACT_B14			0x7
+#define CAL_PIX_PROC_EXTRACT_B14_MIPI			0x8
+#define CAL_PIX_PROC_EXTRACT_B16_BE			0x9
+#define CAL_PIX_PROC_EXTRACT_B16_LE			0xa
+#define CAL_PIX_PROC_DPCMD_MASK			GENMASK(9, 5)
+#define CAL_PIX_PROC_DPCMD_BYPASS			0x0
+#define CAL_PIX_PROC_DPCMD_DPCM_10_8_1			0x2
+#define CAL_PIX_PROC_DPCMD_DPCM_12_8_1			0x8
+#define CAL_PIX_PROC_DPCMD_DPCM_10_7_1			0x4
+#define CAL_PIX_PROC_DPCMD_DPCM_10_7_2			0x5
+#define CAL_PIX_PROC_DPCMD_DPCM_10_6_1			0x6
+#define CAL_PIX_PROC_DPCMD_DPCM_10_6_2			0x7
+#define CAL_PIX_PROC_DPCMD_DPCM_12_7_1			0xa
+#define CAL_PIX_PROC_DPCMD_DPCM_12_6_1			0xc
+#define CAL_PIX_PROC_DPCMD_DPCM_14_10			0xe
+#define CAL_PIX_PROC_DPCMD_DPCM_14_8_1			0x10
+#define CAL_PIX_PROC_DPCMD_DPCM_16_12_1			0x12
+#define CAL_PIX_PROC_DPCMD_DPCM_16_10_1			0x14
+#define CAL_PIX_PROC_DPCMD_DPCM_16_8_1			0x16
+#define CAL_PIX_PROC_DPCME_MASK			GENMASK(15, 11)
+#define CAL_PIX_PROC_DPCME_BYPASS			0x0
+#define CAL_PIX_PROC_DPCME_DPCM_10_8_1			0x2
+#define CAL_PIX_PROC_DPCME_DPCM_12_8_1			0x8
+#define CAL_PIX_PROC_DPCME_DPCM_14_10			0xe
+#define CAL_PIX_PROC_DPCME_DPCM_14_8_1			0x10
+#define CAL_PIX_PROC_DPCME_DPCM_16_12_1			0x12
+#define CAL_PIX_PROC_DPCME_DPCM_16_10_1			0x14
+#define CAL_PIX_PROC_DPCME_DPCM_16_8_1			0x16
+#define CAL_PIX_PROC_PACK_MASK			GENMASK(18, 16)
+#define CAL_PIX_PROC_PACK_B8				0x0
+#define CAL_PIX_PROC_PACK_B10_MIPI			0x2
+#define CAL_PIX_PROC_PACK_B12				0x3
+#define CAL_PIX_PROC_PACK_B12_MIPI			0x4
+#define CAL_PIX_PROC_PACK_B16				0x5
+#define CAL_PIX_PROC_PACK_ARGB				0x6
+#define CAL_PIX_PROC_CPORT_MASK			GENMASK(23, 19)
+
+#define CAL_CTRL_POSTED_WRITES_MASK		BIT_MASK(0)
+#define CAL_CTRL_POSTED_WRITES_NONPOSTED		0
+#define CAL_CTRL_POSTED_WRITES				1
+#define CAL_CTRL_TAGCNT_MASK			GENMASK(4, 1)
+#define CAL_CTRL_BURSTSIZE_MASK			GENMASK(6, 5)
+#define CAL_CTRL_BURSTSIZE_BURST16			0x0
+#define CAL_CTRL_BURSTSIZE_BURST32			0x1
+#define CAL_CTRL_BURSTSIZE_BURST64			0x2
+#define CAL_CTRL_BURSTSIZE_BURST128			0x3
+#define CAL_CTRL_LL_FORCE_STATE_MASK		GENMASK(12, 7)
+#define CAL_CTRL_MFLAGL_MASK			GENMASK(20, 13)
+#define CAL_CTRL_PWRSCPCLK_MASK			BIT_MASK(21)
+#define CAL_CTRL_PWRSCPCLK_AUTO				0
+#define CAL_CTRL_PWRSCPCLK_FORCE			1
+#define CAL_CTRL_RD_DMA_STALL_MASK		BIT_MASK(22)
+#define CAL_CTRL_MFLAGH_MASK			GENMASK(31, 24)
+
+#define CAL_CTRL1_PPI_GROUPING_MASK		GENMASK(1, 0)
+#define CAL_CTRL1_PPI_GROUPING_DISABLED			0
+#define CAL_CTRL1_PPI_GROUPING_RESERVED			1
+#define CAL_CTRL1_PPI_GROUPING_0			2
+#define CAL_CTRL1_PPI_GROUPING_1			3
+#define CAL_CTRL1_INTERLEAVE01_MASK		GENMASK(3, 2)
+#define CAL_CTRL1_INTERLEAVE01_DISABLED			0
+#define CAL_CTRL1_INTERLEAVE01_PIX1			1
+#define CAL_CTRL1_INTERLEAVE01_PIX4			2
+#define CAL_CTRL1_INTERLEAVE01_RESERVED			3
+#define CAL_CTRL1_INTERLEAVE23_MASK		GENMASK(5, 4)
+#define CAL_CTRL1_INTERLEAVE23_DISABLED			0
+#define CAL_CTRL1_INTERLEAVE23_PIX1			1
+#define CAL_CTRL1_INTERLEAVE23_PIX4			2
+#define CAL_CTRL1_INTERLEAVE23_RESERVED			3
+
+#define CAL_LINE_NUMBER_EVT_CPORT_MASK		GENMASK(4, 0)
+#define CAL_LINE_NUMBER_EVT_MASK		GENMASK(29, 16)
+
+#define CAL_VPORT_CTRL1_PCLK_MASK		GENMASK(16, 0)
+#define CAL_VPORT_CTRL1_XBLK_MASK		GENMASK(24, 17)
+#define CAL_VPORT_CTRL1_YBLK_MASK		GENMASK(30, 25)
+#define CAL_VPORT_CTRL1_WIDTH_MASK		BIT_MASK(31)
+#define CAL_VPORT_CTRL1_WIDTH_ONE			0
+#define CAL_VPORT_CTRL1_WIDTH_TWO			1
+
+#define CAL_VPORT_CTRL2_CPORT_MASK		GENMASK(4, 0)
+#define CAL_VPORT_CTRL2_FREERUNNING_MASK	BIT_MASK(15)
+#define CAL_VPORT_CTRL2_FREERUNNING_GATED		0
+#define CAL_VPORT_CTRL2_FREERUNNING_FREE		1
+#define CAL_VPORT_CTRL2_FS_RESETS_MASK		BIT_MASK(16)
+#define CAL_VPORT_CTRL2_FS_RESETS_NO			0
+#define CAL_VPORT_CTRL2_FS_RESETS_YES			1
+#define CAL_VPORT_CTRL2_FSM_RESET_MASK		BIT_MASK(17)
+#define CAL_VPORT_CTRL2_FSM_RESET_NOEFFECT		0
+#define CAL_VPORT_CTRL2_FSM_RESET			1
+#define CAL_VPORT_CTRL2_RDY_THR_MASK		GENMASK(31, 18)
+
+#define CAL_BYS_CTRL1_PCLK_MASK			GENMASK(16, 0)
+#define CAL_BYS_CTRL1_XBLK_MASK			GENMASK(24, 17)
+#define CAL_BYS_CTRL1_YBLK_MASK			GENMASK(30, 25)
+#define CAL_BYS_CTRL1_BYSINEN_MASK		BIT_MASK(31)
+
+#define CAL_BYS_CTRL2_CPORTIN_MASK		GENMASK(4, 0)
+#define CAL_BYS_CTRL2_CPORTOUT_MASK		GENMASK(9, 5)
+#define CAL_BYS_CTRL2_DUPLICATEDDATA_MASK	BIT_MASK(10)
+#define CAL_BYS_CTRL2_DUPLICATEDDATA_NO			0
+#define CAL_BYS_CTRL2_DUPLICATEDDATA_YES		1
+#define CAL_BYS_CTRL2_FREERUNNING_MASK		BIT_MASK(11)
+#define CAL_BYS_CTRL2_FREERUNNING_NO			0
+#define CAL_BYS_CTRL2_FREERUNNING_YES			1
+
+#define CAL_RD_DMA_CTRL_GO_MASK			BIT_MASK(0)
+#define CAL_RD_DMA_CTRL_GO_DIS				0
+#define CAL_RD_DMA_CTRL_GO_EN				1
+#define CAL_RD_DMA_CTRL_GO_IDLE				0
+#define CAL_RD_DMA_CTRL_GO_BUSY				1
+#define CAL_RD_DMA_CTRL_INIT_MASK		BIT_MASK(1)
+#define CAL_RD_DMA_CTRL_BW_LIMITER_MASK		GENMASK(10, 2)
+#define CAL_RD_DMA_CTRL_OCP_TAG_CNT_MASK	GENMASK(14, 11)
+#define CAL_RD_DMA_CTRL_PCLK_MASK		GENMASK(31, 15)
+
+#define CAL_RD_DMA_PIX_ADDR_MASK		GENMASK(31, 3)
+
+#define CAL_RD_DMA_PIX_OFST_MASK		GENMASK(31, 4)
+
+#define CAL_RD_DMA_XSIZE_MASK			GENMASK(31, 19)
+
+#define CAL_RD_DMA_YSIZE_MASK			GENMASK(29, 16)
+
+#define CAL_RD_DMA_INIT_ADDR_MASK		GENMASK(31, 3)
+
+#define CAL_RD_DMA_INIT_OFST_MASK		GENMASK(31, 3)
+
+#define CAL_RD_DMA_CTRL2_CIRC_MODE_MASK		GENMASK(2, 0)
+#define CAL_RD_DMA_CTRL2_CIRC_MODE_DIS			0
+#define CAL_RD_DMA_CTRL2_CIRC_MODE_ONE			1
+#define CAL_RD_DMA_CTRL2_CIRC_MODE_FOUR			2
+#define CAL_RD_DMA_CTRL2_CIRC_MODE_SIXTEEN		3
+#define CAL_RD_DMA_CTRL2_CIRC_MODE_SIXTYFOUR		4
+#define CAL_RD_DMA_CTRL2_CIRC_MODE_RESERVED		5
+#define CAL_RD_DMA_CTRL2_ICM_CSTART_MASK	BIT_MASK(3)
+#define CAL_RD_DMA_CTRL2_PATTERN_MASK		GENMASK(5, 4)
+#define CAL_RD_DMA_CTRL2_PATTERN_LINEAR			0
+#define CAL_RD_DMA_CTRL2_PATTERN_YUV420			1
+#define CAL_RD_DMA_CTRL2_PATTERN_RD2SKIP2		2
+#define CAL_RD_DMA_CTRL2_PATTERN_RD2SKIP4		3
+#define CAL_RD_DMA_CTRL2_BYSOUT_LE_WAIT_MASK	BIT_MASK(6)
+#define CAL_RD_DMA_CTRL2_BYSOUT_LE_WAIT_FREERUNNING	0
+#define CAL_RD_DMA_CTRL2_BYSOUT_LE_WAIT_WAITFORBYSOUT	1
+#define CAL_RD_DMA_CTRL2_CIRC_SIZE_MASK		GENMASK(29, 16)
+
+#define CAL_WR_DMA_CTRL_MODE_MASK		GENMASK(2, 0)
+#define CAL_WR_DMA_CTRL_MODE_DIS			0
+#define CAL_WR_DMA_CTRL_MODE_SHD			1
+#define CAL_WR_DMA_CTRL_MODE_CNT			2
+#define CAL_WR_DMA_CTRL_MODE_CNT_INIT			3
+#define CAL_WR_DMA_CTRL_MODE_CONST			4
+#define CAL_WR_DMA_CTRL_MODE_RESERVED			5
+#define CAL_WR_DMA_CTRL_PATTERN_MASK		GENMASK(4, 3)
+#define CAL_WR_DMA_CTRL_PATTERN_LINEAR			0
+#define CAL_WR_DMA_CTRL_PATTERN_WR2SKIP2		2
+#define CAL_WR_DMA_CTRL_PATTERN_WR2SKIP4		3
+#define CAL_WR_DMA_CTRL_PATTERN_RESERVED		1
+#define CAL_WR_DMA_CTRL_ICM_PSTART_MASK		BIT_MASK(5)
+#define CAL_WR_DMA_CTRL_DTAG_MASK		GENMASK(8, 6)
+#define CAL_WR_DMA_CTRL_DTAG_ATT_HDR			0
+#define CAL_WR_DMA_CTRL_DTAG_ATT_DAT			1
+#define CAL_WR_DMA_CTRL_DTAG				2
+#define CAL_WR_DMA_CTRL_DTAG_PIX_HDR			3
+#define CAL_WR_DMA_CTRL_DTAG_PIX_DAT			4
+#define CAL_WR_DMA_CTRL_DTAG_D5				5
+#define CAL_WR_DMA_CTRL_DTAG_D6				6
+#define CAL_WR_DMA_CTRL_DTAG_D7				7
+#define CAL_WR_DMA_CTRL_CPORT_MASK		GENMASK(13, 9)
+#define CAL_WR_DMA_CTRL_STALL_RD_MASK		BIT_MASK(14)
+#define CAL_WR_DMA_CTRL_YSIZE_MASK		GENMASK(31, 18)
+
+#define CAL_WR_DMA_ADDR_MASK			GENMASK(31, 4)
+
+#define CAL_WR_DMA_OFST_MASK			GENMASK(18, 4)
+#define CAL_WR_DMA_OFST_CIRC_MODE_MASK		GENMASK(23, 22)
+#define CAL_WR_DMA_OFST_CIRC_MODE_ONE			1
+#define CAL_WR_DMA_OFST_CIRC_MODE_FOUR			2
+#define CAL_WR_DMA_OFST_CIRC_MODE_SIXTYFOUR		3
+#define CAL_WR_DMA_OFST_CIRC_MODE_DISABLED		0
+#define CAL_WR_DMA_OFST_CIRC_SIZE_MASK		GENMASK(31, 24)
+
+#define CAL_WR_DMA_XSIZE_XSKIP_MASK		GENMASK(15, 3)
+#define CAL_WR_DMA_XSIZE_MASK			GENMASK(31, 19)
+
+#define CAL_CSI2_PPI_CTRL_IF_EN_MASK		BIT_MASK(0)
+#define CAL_CSI2_PPI_CTRL_ECC_EN_MASK		BIT_MASK(2)
+#define CAL_CSI2_PPI_CTRL_FRAME_MASK		BIT_MASK(3)
+#define CAL_CSI2_PPI_CTRL_FRAME_IMMEDIATE		0
+#define CAL_CSI2_PPI_CTRL_FRAME				1
+
+#define CAL_CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK	GENMASK(2, 0)
+#define CAL_CSI2_COMPLEXIO_CFG_POSITION_5			5
+#define CAL_CSI2_COMPLEXIO_CFG_POSITION_4			4
+#define CAL_CSI2_COMPLEXIO_CFG_POSITION_3			3
+#define CAL_CSI2_COMPLEXIO_CFG_POSITION_2			2
+#define CAL_CSI2_COMPLEXIO_CFG_POSITION_1			1
+#define CAL_CSI2_COMPLEXIO_CFG_POSITION_NOT_USED		0
+#define CAL_CSI2_COMPLEXIO_CFG_CLOCK_POL_MASK		BIT_MASK(3)
+#define CAL_CSI2_COMPLEXIO_CFG_POL_PLUSMINUS			0
+#define CAL_CSI2_COMPLEXIO_CFG_POL_MINUSPLUS			1
+#define CAL_CSI2_COMPLEXIO_CFG_DATA1_POSITION_MASK	GENMASK(6, 4)
+#define CAL_CSI2_COMPLEXIO_CFG_DATA1_POL_MASK		BIT_MASK(7)
+#define CAL_CSI2_COMPLEXIO_CFG_DATA2_POSITION_MASK	GENMASK(10, 8)
+#define CAL_CSI2_COMPLEXIO_CFG_DATA2_POL_MASK		BIT_MASK(11)
+#define CAL_CSI2_COMPLEXIO_CFG_DATA3_POSITION_MASK	GENMASK(14, 12)
+#define CAL_CSI2_COMPLEXIO_CFG_DATA3_POL_MASK		BIT_MASK(15)
+#define CAL_CSI2_COMPLEXIO_CFG_DATA4_POSITION_MASK	GENMASK(18, 16)
+#define CAL_CSI2_COMPLEXIO_CFG_DATA4_POL_MASK		BIT_MASK(19)
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_AUTO_MASK		BIT_MASK(24)
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_STATUS_MASK		GENMASK(26, 25)
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_STATUS_STATE_OFF		0
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_STATUS_STATE_ON		1
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_STATUS_STATE_ULP		2
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_CMD_MASK		GENMASK(28, 27)
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_CMD_STATE_OFF		0
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_CMD_STATE_ON			1
+#define CAL_CSI2_COMPLEXIO_CFG_PWR_CMD_STATE_ULP		2
+#define CAL_CSI2_COMPLEXIO_CFG_RESET_DONE_MASK		BIT_MASK(29)
+#define CAL_CSI2_COMPLEXIO_CFG_RESET_DONE_RESETCOMPLETED	1
+#define CAL_CSI2_COMPLEXIO_CFG_RESET_DONE_RESETONGOING		0
+#define CAL_CSI2_COMPLEXIO_CFG_RESET_CTRL_MASK		BIT_MASK(30)
+#define CAL_CSI2_COMPLEXIO_CFG_RESET_CTRL			0
+#define CAL_CSI2_COMPLEXIO_CFG_RESET_CTRL_OPERATIONAL		1
+
+#define CAL_CSI2_SHORT_PACKET_MASK	GENMASK(23, 0)
+
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTHS1_MASK		BIT_MASK(0)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTHS2_MASK		BIT_MASK(1)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTHS3_MASK		BIT_MASK(2)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTHS4_MASK		BIT_MASK(3)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTHS5_MASK		BIT_MASK(4)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS1_MASK	BIT_MASK(5)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS2_MASK	BIT_MASK(6)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS3_MASK	BIT_MASK(7)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS4_MASK	BIT_MASK(8)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS5_MASK	BIT_MASK(9)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRESC1_MASK		BIT_MASK(10)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRESC2_MASK		BIT_MASK(11)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRESC3_MASK		BIT_MASK(12)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRESC4_MASK		BIT_MASK(13)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRESC5_MASK		BIT_MASK(14)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRCONTROL1_MASK		BIT_MASK(15)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRCONTROL2_MASK		BIT_MASK(16)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRCONTROL3_MASK		BIT_MASK(17)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRCONTROL4_MASK		BIT_MASK(18)
+#define CAL_CSI2_COMPLEXIO_IRQ_ERRCONTROL5_MASK		BIT_MASK(19)
+#define CAL_CSI2_COMPLEXIO_IRQ_STATEULPM1_MASK		BIT_MASK(20)
+#define CAL_CSI2_COMPLEXIO_IRQ_STATEULPM2_MASK		BIT_MASK(21)
+#define CAL_CSI2_COMPLEXIO_IRQ_STATEULPM3_MASK		BIT_MASK(22)
+#define CAL_CSI2_COMPLEXIO_IRQ_STATEULPM4_MASK		BIT_MASK(23)
+#define CAL_CSI2_COMPLEXIO_IRQ_STATEULPM5_MASK		BIT_MASK(24)
+#define CAL_CSI2_COMPLEXIO_IRQ_STATEALLULPMENTER_MASK	BIT_MASK(25)
+#define CAL_CSI2_COMPLEXIO_IRQ_STATEALLULPMEXIT_MASK	BIT_MASK(26)
+#define CAL_CSI2_COMPLEXIO_IRQ_FIFO_OVR_MASK		BIT_MASK(27)
+#define CAL_CSI2_COMPLEXIO_IRQ_SHORT_PACKET_MASK	BIT_MASK(28)
+#define CAL_CSI2_COMPLEXIO_IRQ_ECC_NO_CORRECTION_MASK	BIT_MASK(30)
+
+#define CAL_CSI2_TIMING_STOP_STATE_COUNTER_IO1_MASK	GENMASK(12, 0)
+#define CAL_CSI2_TIMING_STOP_STATE_X4_IO1_MASK		BIT_MASK(13)
+#define CAL_CSI2_TIMING_STOP_STATE_X16_IO1_MASK		BIT_MASK(14)
+#define CAL_CSI2_TIMING_FORCE_RX_MODE_IO1_MASK		BIT_MASK(15)
+
+#define CAL_CSI2_VC_IRQ_FS_IRQ_0_MASK			BIT_MASK(0)
+#define CAL_CSI2_VC_IRQ_FE_IRQ_0_MASK			BIT_MASK(1)
+#define CAL_CSI2_VC_IRQ_LS_IRQ_0_MASK			BIT_MASK(2)
+#define CAL_CSI2_VC_IRQ_LE_IRQ_0_MASK			BIT_MASK(3)
+#define CAL_CSI2_VC_IRQ_CS_IRQ_0_MASK			BIT_MASK(4)
+#define CAL_CSI2_VC_IRQ_ECC_CORRECTION0_IRQ_0_MASK	BIT_MASK(5)
+#define CAL_CSI2_VC_IRQ_FS_IRQ_1_MASK			BIT_MASK(8)
+#define CAL_CSI2_VC_IRQ_FE_IRQ_1_MASK			BIT_MASK(9)
+#define CAL_CSI2_VC_IRQ_LS_IRQ_1_MASK			BIT_MASK(10)
+#define CAL_CSI2_VC_IRQ_LE_IRQ_1_MASK			BIT_MASK(11)
+#define CAL_CSI2_VC_IRQ_CS_IRQ_1_MASK			BIT_MASK(12)
+#define CAL_CSI2_VC_IRQ_ECC_CORRECTION0_IRQ_1_MASK	BIT_MASK(13)
+#define CAL_CSI2_VC_IRQ_FS_IRQ_2_MASK			BIT_MASK(16)
+#define CAL_CSI2_VC_IRQ_FE_IRQ_2_MASK			BIT_MASK(17)
+#define CAL_CSI2_VC_IRQ_LS_IRQ_2_MASK			BIT_MASK(18)
+#define CAL_CSI2_VC_IRQ_LE_IRQ_2_MASK			BIT_MASK(19)
+#define CAL_CSI2_VC_IRQ_CS_IRQ_2_MASK			BIT_MASK(20)
+#define CAL_CSI2_VC_IRQ_ECC_CORRECTION0_IRQ_2_MASK	BIT_MASK(21)
+#define CAL_CSI2_VC_IRQ_FS_IRQ_3_MASK			BIT_MASK(24)
+#define CAL_CSI2_VC_IRQ_FE_IRQ_3_MASK			BIT_MASK(25)
+#define CAL_CSI2_VC_IRQ_LS_IRQ_3_MASK			BIT_MASK(26)
+#define CAL_CSI2_VC_IRQ_LE_IRQ_3_MASK			BIT_MASK(27)
+#define CAL_CSI2_VC_IRQ_CS_IRQ_3_MASK			BIT_MASK(28)
+#define CAL_CSI2_VC_IRQ_ECC_CORRECTION0_IRQ_3_MASK	BIT_MASK(29)
+
+#define CAL_CSI2_CTX_DT_MASK		GENMASK(5, 0)
+#define CAL_CSI2_CTX_VC_MASK		GENMASK(7, 6)
+#define CAL_CSI2_CTX_CPORT_MASK		GENMASK(12, 8)
+#define CAL_CSI2_CTX_ATT_MASK		BIT_MASK(13)
+#define CAL_CSI2_CTX_ATT_PIX			0
+#define CAL_CSI2_CTX_ATT			1
+#define CAL_CSI2_CTX_PACK_MODE_MASK	BIT_MASK(14)
+#define CAL_CSI2_CTX_PACK_MODE_LINE		0
+#define CAL_CSI2_CTX_PACK_MODE_FRAME		1
+#define CAL_CSI2_CTX_LINES_MASK		GENMASK(29, 16)
+
+#define CAL_CSI2_STATUS_FRAME_MASK	GENMASK(15, 0)
+
+#define CAL_CSI2_PHY_REG0_THS_SETTLE_MASK	GENMASK(7, 0)
+#define CAL_CSI2_PHY_REG0_THS_TERM_MASK		GENMASK(15, 8)
+#define CAL_CSI2_PHY_REG0_HSCLOCKCONFIG_MASK	BIT_MASK(24)
+#define CAL_CSI2_PHY_REG0_HSCLOCKCONFIG_DISABLE		1
+#define CAL_CSI2_PHY_REG0_HSCLOCKCONFIG_ENABLE		0
+
+#define CAL_CSI2_PHY_REG1_TCLK_SETTLE_MASK			GENMASK(7, 0)
+#define CAL_CSI2_PHY_REG1_CTRLCLK_DIV_FACTOR_MASK		GENMASK(9, 8)
+#define CAL_CSI2_PHY_REG1_DPHY_HS_SYNC_PATTERN_MASK		GENMASK(17, 10)
+#define CAL_CSI2_PHY_REG1_TCLK_TERM_MASK			GENMASK(24, 18)
+#define CAL_CSI2_PHY_REG1_CLOCK_MISS_DETECTOR_STATUS_MASK	BIT_MASK(25)
+#define CAL_CSI2_PHY_REG1_CLOCK_MISS_DETECTOR_STATUS_ERROR		1
+#define CAL_CSI2_PHY_REG1_CLOCK_MISS_DETECTOR_STATUS_SUCCESS		0
+#define CAL_CSI2_PHY_REG1_RESET_DONE_STATUS_MASK		GENMASK(29, 28)
+
+#define CAL_CSI2_PHY_REG2_CCP2_SYNC_PATTERN_MASK		GENMASK(23, 0)
+#define CAL_CSI2_PHY_REG2_TRIGGER_CMD_RXTRIGESC3_MASK		GENMASK(25, 24)
+#define CAL_CSI2_PHY_REG2_TRIGGER_CMD_RXTRIGESC2_MASK		GENMASK(27, 26)
+#define CAL_CSI2_PHY_REG2_TRIGGER_CMD_RXTRIGESC1_MASK		GENMASK(29, 28)
+#define CAL_CSI2_PHY_REG2_TRIGGER_CMD_RXTRIGESC0_MASK		GENMASK(31, 30)
+
+#define CM_CAMERRX_CTRL_CSI1_CTRLCLKEN_MASK			BIT_MASK(0)
+#define CM_CAMERRX_CTRL_CSI1_CAMMODE_MASK			GENMASK(2, 1)
+#define CM_CAMERRX_CTRL_CSI1_LANEENABLE_MASK			GENMASK(4, 3)
+#define CM_CAMERRX_CTRL_CSI1_MODE_MASK				BIT_MASK(5)
+#define CM_CAMERRX_CTRL_CSI0_CTRLCLKEN_MASK			BIT_MASK(10)
+#define CM_CAMERRX_CTRL_CSI0_CAMMODE_MASK			GENMASK(12, 11)
+#define CM_CAMERRX_CTRL_CSI0_LANEENABLE_MASK			GENMASK(16, 13)
+#define CM_CAMERRX_CTRL_CSI0_MODE_MASK				BIT_MASK(17)
+
+#endif
-- 
1.8.5.1

