Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:45046 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755574AbdCGOns (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 09:43:48 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH 2/4] media: platform: dwc: Support for DW CSI-2 Host
Date: Tue,  7 Mar 2017 14:37:49 +0000
Message-Id: <6a45f8d24993bc6ab02f8bd76ef1db421ab32d9c.1488885081.git.roliveir@synopsys.com>
In-Reply-To: <cover.1488885081.git.roliveir@synopsys.com>
References: <cover.1488885081.git.roliveir@synopsys.com>
In-Reply-To: <cover.1488885081.git.roliveir@synopsys.com>
References: <cover.1488885081.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the Synopsys DesignWare CSI-2 Host

Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
---
 MAINTAINERS                              |   7 +
 drivers/media/platform/Kconfig           |   1 +
 drivers/media/platform/Makefile          |   2 +
 drivers/media/platform/dwc/Kconfig       |   5 +
 drivers/media/platform/dwc/Makefile      |   1 +
 drivers/media/platform/dwc/dw_mipi_csi.c | 653 +++++++++++++++++++++++++++++++
 drivers/media/platform/dwc/dw_mipi_csi.h | 181 +++++++++
 include/media/dwc/csi_host_platform.h    |  97 +++++
 8 files changed, 947 insertions(+)
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile
 create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.c
 create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.h
 create mode 100644 include/media/dwc/csi_host_platform.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5badfd33e51f..19673dad43b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11061,6 +11061,13 @@ S:	Maintained
 F:	drivers/staging/media/st-cec/
 F:	Documentation/devicetree/bindings/media/stih-cec.txt
 
+SYNOPSYS DESIGNWARE CSI-2 HOST VIDEO PLATFORM
+M:	Ramiro Oliveira <roliveir@synopsys.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/platform/dwc/
+
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
 M:	Ursula Braun <ubraun@linux.vnet.ibm.com>
 L:	linux-s390@vger.kernel.org
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 53f6f12bff0d..4b6e00da763f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -120,6 +120,7 @@ source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 source "drivers/media/platform/rcar-vin/Kconfig"
 source "drivers/media/platform/atmel/Kconfig"
+source "drivers/media/platform/dwc/Kconfig"
 
 config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 8959f6e6692a..95eae2772c1f 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -64,6 +64,8 @@ obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
 
 obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
 
+obj-$(CONFIG_CSI_VIDEO_PLATFORM)	+= dwc/
+
 ccflags-y += -I$(srctree)/drivers/media/i2c
 
 obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
new file mode 100644
index 000000000000..2cd13d23f897
--- /dev/null
+++ b/drivers/media/platform/dwc/Kconfig
@@ -0,0 +1,5 @@
+config DWC_MIPI_CSI2_HOST
+	tristate "SNPS DWC MIPI CSI2 Host"
+	select GENERIC_PHY
+	help
+	  This is a V4L2 driver for Synopsys Designware MIPI CSI-2 Host.
diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
new file mode 100644
index 000000000000..5eb076a55123
--- /dev/null
+++ b/drivers/media/platform/dwc/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DWC_MIPI_CSI2_HOST)	+= dw_mipi_csi.o
diff --git a/drivers/media/platform/dwc/dw_mipi_csi.c b/drivers/media/platform/dwc/dw_mipi_csi.c
new file mode 100644
index 000000000000..6905def40a07
--- /dev/null
+++ b/drivers/media/platform/dwc/dw_mipi_csi.c
@@ -0,0 +1,653 @@
+/*
+ * DWC MIPI CSI-2 Host device driver
+ *
+ * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
+ * Author: Ramiro Oliveira <ramiro.oliveira@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include "dw_mipi_csi.h"
+
+/**
+ * @short Video formats supported by the MIPI CSI-2
+ */
+static const struct mipi_fmt dw_mipi_csi_formats[] = {
+	{
+		/* RAW 8 */
+		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
+		.depth = 8,
+	},
+	{
+		/* RAW 10 */
+		.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
+		.depth = 10,
+	},
+	{
+		/* RGB 565 */
+		.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
+		.depth = 16,
+	},
+	{
+		/* BGR 565 */
+		.code = MEDIA_BUS_FMT_RGB565_2X8_LE,
+		.depth = 16,
+	},
+	{
+		/* RGB 888 */
+		.code = MEDIA_BUS_FMT_RGB888_2X12_LE,
+		.depth = 24,
+	},
+	{
+		/* BGR 888 */
+		.code = MEDIA_BUS_FMT_RGB888_2X12_BE,
+		.depth = 24,
+	},
+};
+
+static struct mipi_csi_dev *sd_to_mipi_csi_dev(struct v4l2_subdev *sdev)
+{
+	return container_of(sdev, struct mipi_csi_dev, sd);
+}
+
+static void dw_mipi_csi_write(struct mipi_csi_dev *dev,
+		  unsigned int address, unsigned int data)
+{
+	iowrite32(data, dev->base_address + address);
+}
+
+static u32 dw_mipi_csi_read(struct mipi_csi_dev *dev, unsigned long address)
+{
+	return ioread32(dev->base_address + address);
+}
+
+static void dw_mipi_csi_write_part(struct mipi_csi_dev *dev,
+		       unsigned long address, unsigned long data,
+		       unsigned char shift, unsigned char width)
+{
+	u32 mask = (1 << width) - 1;
+	u32 temp = dw_mipi_csi_read(dev, address);
+
+	temp &= ~(mask << shift);
+	temp |= (data & mask) << shift;
+	dw_mipi_csi_write(dev, address, temp);
+}
+
+static const struct mipi_fmt *
+find_dw_mipi_csi_format(struct v4l2_mbus_framefmt *mf)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(dw_mipi_csi_formats); i++)
+		if (mf->code == dw_mipi_csi_formats[i].code)
+			return &dw_mipi_csi_formats[i];
+	return NULL;
+}
+
+static void dw_mipi_csi_reset(struct mipi_csi_dev *dev)
+{
+	dw_mipi_csi_write(dev, R_CSI2_CTRL_RESETN, 0);
+	dw_mipi_csi_write(dev, R_CSI2_CTRL_RESETN, 1);
+}
+
+static int dw_mipi_csi_mask_irq_power_off(struct mipi_csi_dev *dev)
+{
+	/* set only one lane (lane 0) as active (ON) */
+	dw_mipi_csi_write(dev, R_CSI2_N_LANES, 0);
+
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY_FATAL, 0);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT_FATAL, 0);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_FRAME_FATAL, 0);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY, 0);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT, 0);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_LINE, 0);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_IPI, 0);
+
+	dw_mipi_csi_write(dev, R_CSI2_CTRL_RESETN, 0);
+
+	return 0;
+
+}
+
+static int dw_mipi_csi_hw_stdby(struct mipi_csi_dev *dev)
+{
+	/* set only one lane (lane 0) as active (ON) */
+	dw_mipi_csi_reset(dev);
+
+	dw_mipi_csi_write(dev, R_CSI2_N_LANES, 0);
+
+	phy_init(dev->phy);
+
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY_FATAL, 0xFFFFFFFF);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT_FATAL, 0xFFFFFFFF);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_FRAME_FATAL, 0xFFFFFFFF);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PHY, 0xFFFFFFFF);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_PKT, 0xFFFFFFFF);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_LINE, 0xFFFFFFFF);
+	dw_mipi_csi_write(dev, R_CSI2_MASK_INT_IPI, 0xFFFFFFFF);
+
+	return 0;
+
+}
+
+static void dw_mipi_csi_set_ipi_fmt(struct mipi_csi_dev *csi_dev)
+{
+	struct device *dev = &csi_dev->pdev->dev;
+
+	switch (csi_dev->fmt->code) {
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RGB565);
+		dev_dbg(dev, "DT: RGB 565");
+		break;
+
+	case MEDIA_BUS_FMT_RGB888_2X12_LE:
+	case MEDIA_BUS_FMT_RGB888_2X12_BE:
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RGB888);
+		dev_dbg(dev, "DT: RGB 888");
+		break;
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RAW10);
+		dev_dbg(dev, "DT: RAW 10");
+		break;
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RAW8);
+		dev_dbg(dev, "DT: RAW 8");
+		break;
+	default:
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_DATA_TYPE, CSI_2_RGB565);
+		dev_dbg(dev, "Error");
+		break;
+	}
+}
+
+static void __dw_mipi_csi_fill_timings(struct mipi_csi_dev *dev,
+			   const struct v4l2_bt_timings *bt)
+{
+
+	if (bt == NULL)
+		return;
+
+	dev->hw.hsa = bt->hsync;
+	dev->hw.hbp = bt->hbackporch;
+	dev->hw.hsd = bt->hsync;
+	dev->hw.htotal = bt->height + bt->vfrontporch +
+	    bt->vsync + bt->vbackporch;
+	dev->hw.vsa = bt->vsync;
+	dev->hw.vbp = bt->vbackporch;
+	dev->hw.vfp = bt->vfrontporch;
+	dev->hw.vactive = bt->height;
+}
+
+static void dw_mipi_csi_start(struct mipi_csi_dev *csi_dev)
+{
+	const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[0].bt;
+	struct device *dev = &csi_dev->pdev->dev;
+
+	__dw_mipi_csi_fill_timings(csi_dev, bt);
+
+	dw_mipi_csi_write(csi_dev, R_CSI2_N_LANES, (csi_dev->hw.num_lanes - 1));
+	dev_dbg(dev, "N Lanes: %d\n", csi_dev->hw.num_lanes);
+
+	/*IPI Related Configuration */
+	if ((csi_dev->hw.output_type == IPI_OUT)
+	    || (csi_dev->hw.output_type == BOTH_OUT)) {
+
+		dw_mipi_csi_write_part(csi_dev, R_CSI2_IPI_MODE,
+					csi_dev->hw.ipi_mode, 0, 1);
+		dev_dbg(dev, "IPI MODE: %d\n", csi_dev->hw.ipi_mode);
+
+		dw_mipi_csi_write_part(csi_dev, R_CSI2_IPI_MODE,
+				       csi_dev->hw.ipi_color_mode, 8, 1);
+		dev_dbg(dev, "Color Mode: %d\n", csi_dev->hw.ipi_color_mode);
+
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VCID,
+					csi_dev->hw.virtual_ch);
+		dev_dbg(dev, "Virtual Channel: %d\n", csi_dev->hw.virtual_ch);
+
+		dw_mipi_csi_write_part(csi_dev, R_CSI2_IPI_MEM_FLUSH,
+				       csi_dev->hw.ipi_auto_flush, 8, 1);
+		dev_dbg(dev, "Auto-flush: %d\n", csi_dev->hw.ipi_auto_flush);
+
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HSA_TIME,
+					csi_dev->hw.hsa);
+		dev_dbg(dev, "HSA: %d\n", csi_dev->hw.hsa);
+
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HBP_TIME,
+					csi_dev->hw.hbp);
+		dev_dbg(dev, "HBP: %d\n", csi_dev->hw.hbp);
+
+		dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HSD_TIME,
+					csi_dev->hw.hsd);
+		dev_dbg(dev, "HSD: %d\n", csi_dev->hw.hsd);
+
+		if (csi_dev->hw.ipi_mode == AUTO_TIMING) {
+			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_HLINE_TIME,
+					  csi_dev->hw.htotal);
+			dev_dbg(dev, "H total: %d\n", csi_dev->hw.htotal);
+
+			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VSA_LINES,
+					  csi_dev->hw.vsa);
+			dev_dbg(dev, "VSA: %d\n", csi_dev->hw.vsa);
+
+			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VBP_LINES,
+					  csi_dev->hw.vbp);
+			dev_dbg(dev, "VBP: %d\n", csi_dev->hw.vbp);
+
+			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VFP_LINES,
+					  csi_dev->hw.vfp);
+			dev_dbg(dev, "VFP: %d\n", csi_dev->hw.vfp);
+
+			dw_mipi_csi_write(csi_dev, R_CSI2_IPI_VACTIVE_LINES,
+					  csi_dev->hw.vactive);
+			dev_dbg(dev, "V Active: %d\n", csi_dev->hw.vactive);
+		}
+	}
+
+	phy_power_on(csi_dev->phy);
+}
+
+static int dw_mipi_csi_enum_mbus_code(struct v4l2_subdev *sd,
+					struct v4l2_subdev_pad_config *cfg,
+					struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(dw_mipi_csi_formats))
+		return -EINVAL;
+
+	code->code = dw_mipi_csi_formats[code->index].code;
+	return 0;
+}
+
+static struct mipi_fmt const *
+dw_mipi_csi_try_format(struct v4l2_mbus_framefmt *mf)
+{
+	struct mipi_fmt const *fmt;
+
+	fmt = find_dw_mipi_csi_format(mf);
+	if (fmt == NULL)
+		fmt = &dw_mipi_csi_formats[0];
+
+	mf->code = fmt->code;
+	return fmt;
+}
+
+static struct v4l2_mbus_framefmt *
+__dw_mipi_csi_get_format(struct mipi_csi_dev *dev,
+			 struct v4l2_subdev_pad_config *cfg,
+			 enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return cfg ? v4l2_subdev_get_try_format(&dev->sd, cfg,
+							0) : NULL;
+
+	return &dev->format;
+}
+
+static int
+dw_mipi_csi_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
+		    struct v4l2_subdev_format *fmt)
+{
+	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
+	struct mipi_fmt const *dev_fmt;
+	struct v4l2_mbus_framefmt *mf;
+	unsigned int i = 0;
+	const struct v4l2_bt_timings *bt_r = &v4l2_dv_timings_presets[0].bt;
+
+	mf = __dw_mipi_csi_get_format(dev, cfg, fmt->which);
+
+	dev_fmt = dw_mipi_csi_try_format(&fmt->format);
+	if (dev_fmt) {
+		*mf = fmt->format;
+		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			dev->fmt = dev_fmt;
+		dw_mipi_csi_set_ipi_fmt(dev);
+	}
+	while (v4l2_dv_timings_presets[i].bt.width) {
+		const struct v4l2_bt_timings *bt =
+		    &v4l2_dv_timings_presets[i].bt;
+		if (mf->width == bt->width && mf->height == bt->width) {
+			__dw_mipi_csi_fill_timings(dev, bt);
+			return 0;
+		}
+		i++;
+	}
+
+	__dw_mipi_csi_fill_timings(dev, bt_r);
+	return 0;
+
+}
+
+static int
+dw_mipi_csi_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
+		    struct v4l2_subdev_format *fmt)
+{
+	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = __dw_mipi_csi_get_format(dev, cfg, fmt->which);
+	if (!mf)
+		return -EINVAL;
+
+	mutex_lock(&dev->lock);
+	fmt->format = *mf;
+	mutex_unlock(&dev->lock);
+	return 0;
+}
+
+static int
+dw_mipi_csi_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
+
+	if (on) {
+		dw_mipi_csi_hw_stdby(dev);
+		dw_mipi_csi_start(dev);
+	} else {
+		dw_mipi_csi_mask_irq_power_off(dev);
+	}
+
+	return 0;
+}
+
+static int
+dw_mipi_csi_init_cfg(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *format =
+	    v4l2_subdev_get_try_format(sd, cfg, 0);
+
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+	format->code = dw_mipi_csi_formats[0].code;
+	format->width = MIN_WIDTH;
+	format->height = MIN_HEIGHT;
+	format->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops dw_mipi_csi_core_ops = {
+	.s_power = dw_mipi_csi_s_power,
+};
+
+static struct v4l2_subdev_pad_ops dw_mipi_csi_pad_ops = {
+	.init_cfg = dw_mipi_csi_init_cfg,
+	.enum_mbus_code = dw_mipi_csi_enum_mbus_code,
+	.get_fmt = dw_mipi_csi_get_fmt,
+	.set_fmt = dw_mipi_csi_set_fmt,
+};
+
+static struct v4l2_subdev_ops dw_mipi_csi_subdev_ops = {
+	.core = &dw_mipi_csi_core_ops,
+	.pad = &dw_mipi_csi_pad_ops,
+};
+
+static irqreturn_t
+dw_mipi_csi_irq1(int irq, void *dev_id)
+{
+	struct mipi_csi_dev *csi_dev = dev_id;
+	u32 global_int_status, i_sts;
+	unsigned long flags;
+	struct device *dev = &csi_dev->pdev->dev;
+
+	global_int_status = dw_mipi_csi_read(csi_dev, R_CSI2_INTERRUPT);
+	spin_lock_irqsave(&csi_dev->slock, flags);
+
+	if (global_int_status & CSI2_INT_PHY_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PHY_FATAL);
+		dev_dbg_ratelimited(dev, "CSI INT PHY FATAL: %08X\n", i_sts);
+	}
+
+	if (global_int_status & CSI2_INT_PKT_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PKT_FATAL);
+		dev_dbg_ratelimited(dev, "CSI INT PKT FATAL: %08X\n", i_sts);
+	}
+
+	if (global_int_status & CSI2_INT_FRAME_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_FRAME_FATAL);
+		dev_dbg_ratelimited(dev, "CSI INT FRAME FATAL: %08X\n", i_sts);
+	}
+
+	if (global_int_status & CSI2_INT_PHY) {
+		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PHY);
+		dev_dbg_ratelimited(dev, "CSI INT PHY: %08X\n", i_sts);
+	}
+
+	if (global_int_status & CSI2_INT_PKT) {
+		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_PKT);
+		dev_dbg_ratelimited(dev, "CSI INT PKT: %08X\n", i_sts);
+	}
+
+	if (global_int_status & CSI2_INT_LINE) {
+		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_LINE);
+		dev_dbg_ratelimited(dev, "CSI INT LINE: %08X\n", i_sts);
+	}
+
+	if (global_int_status & CSI2_INT_IPI) {
+		i_sts = dw_mipi_csi_read(csi_dev, R_CSI2_INT_IPI);
+		dev_dbg_ratelimited(dev, "CSI INT IPI: %08X\n", i_sts);
+	}
+	spin_unlock_irqrestore(&csi_dev->slock, flags);
+	return IRQ_HANDLED;
+}
+
+static int
+dw_mipi_csi_parse_dt(struct platform_device *pdev, struct mipi_csi_dev *dev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct v4l2_of_endpoint endpoint;
+	int ret = 0;
+
+	ret = of_property_read_u32(node, "output-type", &dev->hw.output_type);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read output-type\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "ipi-mode", &dev->hw.ipi_mode);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read ipi-mode\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "ipi-auto-flush",
+				 &dev->hw.ipi_auto_flush);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read ipi-auto-flush\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "ipi-color-mode",
+				 &dev->hw.ipi_color_mode);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read ipi-color-mode\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "virtual-channel",
+				&dev->hw.virtual_ch);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read virtual-channel\n");
+		return ret;
+	}
+
+	node = of_graph_get_next_endpoint(node, NULL);
+	if (!node) {
+		dev_err(&pdev->dev, "No port node at %s\n",
+				pdev->dev.of_node->full_name);
+		return -EINVAL;
+	}
+	/* Get port node and validate MIPI-CSI channel id. */
+	ret = v4l2_of_parse_endpoint(node, &endpoint);
+	if (ret)
+		goto err;
+
+	dev->index = endpoint.base.port - 1;
+	if (dev->index >= CSI_MAX_ENTITIES) {
+		ret = -ENXIO;
+		goto err;
+	}
+
+	dev->hw.num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
+
+err:
+	of_node_put(node);
+	return ret;
+}
+
+static const struct of_device_id dw_mipi_csi_of_match[];
+
+/**
+ * @short Initialization routine - Entry point of the driver
+ * @param[in] pdev pointer to the platform device structure
+ * @return 0 on success and a negative number on failure
+ * Refer to Linux errors.
+ */
+static int mipi_csi_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id;
+	struct device *dev = &pdev->dev;
+	struct resource *res = NULL;
+	struct mipi_csi_dev *mipi_csi;
+	int ret = -ENOMEM;
+
+	mipi_csi = devm_kzalloc(dev, sizeof(*mipi_csi), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	mutex_init(&mipi_csi->lock);
+	spin_lock_init(&mipi_csi->slock);
+	mipi_csi->pdev = pdev;
+
+	of_id = of_match_node(dw_mipi_csi_of_match, dev->of_node);
+	if (WARN_ON(of_id == NULL))
+		return -EINVAL;
+
+	ret = dw_mipi_csi_parse_dt(pdev, mipi_csi);
+	if (ret < 0)
+		return ret;
+
+	mipi_csi->phy = devm_of_phy_get(dev, dev->of_node, NULL);
+	if (IS_ERR(mipi_csi->phy)) {
+		dev_err(dev, "No DPHY available\n");
+		return PTR_ERR(mipi_csi->phy);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mipi_csi->base_address = devm_ioremap_resource(dev, res);
+
+	if (IS_ERR(mipi_csi->base_address)) {
+		dev_err(dev, "Base address not set.\n");
+		return PTR_ERR(mipi_csi->base_address);
+	}
+
+	mipi_csi->ctrl_irq_number = platform_get_irq(pdev, 0);
+	if (mipi_csi->ctrl_irq_number <= 0) {
+		dev_err(dev, "IRQ number not set.\n");
+		return mipi_csi->ctrl_irq_number;
+	}
+
+	ret = devm_request_irq(dev, mipi_csi->ctrl_irq_number,
+			       dw_mipi_csi_irq1, IRQF_SHARED,
+			       dev_name(dev), mipi_csi);
+	if (ret) {
+		dev_err(dev, "IRQ failed\n");
+		goto end;
+	}
+
+	mipi_csi->rst = devm_reset_control_get_optional_shared(dev, NULL);
+	if (IS_ERR(mipi_csi->rst))
+		mipi_csi->rst = NULL;
+
+	v4l2_subdev_init(&mipi_csi->sd, &dw_mipi_csi_subdev_ops);
+	mipi_csi->sd.owner = THIS_MODULE;
+	snprintf(mipi_csi->sd.name, sizeof(mipi_csi->sd.name), "%s.%d",
+		 CSI_DEVICE_NAME, mipi_csi->index);
+	mipi_csi->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	mipi_csi->fmt = &dw_mipi_csi_formats[0];
+
+	mipi_csi->format.code = dw_mipi_csi_formats[0].code;
+	mipi_csi->format.width = MIN_WIDTH;
+	mipi_csi->format.height = MIN_HEIGHT;
+
+	mipi_csi->sd.entity.function = MEDIA_ENT_F_IO_V4L;
+	mipi_csi->pads[CSI_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	mipi_csi->pads[CSI_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_pads_init(&mipi_csi->sd.entity,
+				     CSI_PADS_NUM, mipi_csi->pads);
+
+	if (ret < 0) {
+		dev_err(dev, "Media Entity init failed\n");
+		goto entity_cleanup;
+	}
+
+	/* This allows to retrieve the platform device id by the host driver */
+	v4l2_set_subdevdata(&mipi_csi->sd, pdev);
+
+	/* .. and a pointer to the subdev. */
+	platform_set_drvdata(pdev, &mipi_csi->sd);
+
+	if (mipi_csi->rst)
+		reset_control_deassert(mipi_csi->rst);
+
+	dw_mipi_csi_mask_irq_power_off(mipi_csi);
+	dev_info(dev, "DW MIPI CSI-2 Host registered successfully\n");
+	return 0;
+
+entity_cleanup:
+	media_entity_cleanup(&mipi_csi->sd.entity);
+end:
+	return ret;
+}
+
+/**
+ * @short Exit routine - Exit point of the driver
+ * @param[in] pdev pointer to the platform device structure
+ * @return 0 on success and a negative number on failure
+ * Refer to Linux errors.
+ */
+static int mipi_csi_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *mipi_csi = sd_to_mipi_csi_dev(sd);
+
+	dev_dbg(&pdev->dev, "Removing MIPI CSI-2 module\n");
+
+	if (mipi_csi->rst)
+		reset_control_assert(mipi_csi->rst);
+
+	media_entity_cleanup(&mipi_csi->sd.entity);
+
+	return 0;
+}
+
+/**
+ * @short of_device_id structure
+ */
+static const struct of_device_id dw_mipi_csi_of_match[] = {
+	{
+	 .compatible = "snps,dw-mipi-csi"},
+	{ /* sentinel */ },
+};
+
+MODULE_DEVICE_TABLE(of, dw_mipi_csi_of_match);
+
+/**
+ * @short Platform driver structure
+ */
+static struct platform_driver __refdata dw_mipi_csi_pdrv = {
+	.remove = mipi_csi_remove,
+	.probe = mipi_csi_probe,
+	.driver = {
+		   .name = CSI_DEVICE_NAME,
+		   .owner = THIS_MODULE,
+		   .of_match_table = dw_mipi_csi_of_match,
+		   },
+};
+
+module_platform_driver(dw_mipi_csi_pdrv);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
+MODULE_DESCRIPTION("Synopsys DW MIPI CSI-2 Host driver");
diff --git a/drivers/media/platform/dwc/dw_mipi_csi.h b/drivers/media/platform/dwc/dw_mipi_csi.h
new file mode 100644
index 000000000000..6af51ee11284
--- /dev/null
+++ b/drivers/media/platform/dwc/dw_mipi_csi.h
@@ -0,0 +1,181 @@
+/*
+ * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef DW_MIPI_CSI_H_
+#define DW_MIPI_CSI_H_
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_irq.h>
+#include <linux/of_graph.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/ratelimit.h>
+#include <linux/reset.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/wait.h>
+#include <media/dwc/csi_host_platform.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dv-timings.h>
+#include <media/v4l2-of.h>
+
+#define CSI_DEVICE_NAME	"dw-mipi-csi"
+
+/** @short DWC MIPI CSI-2 register addresses*/
+enum register_addresses {
+	R_CSI2_VERSION = 0x00,
+	R_CSI2_N_LANES = 0x04,
+	R_CSI2_CTRL_RESETN = 0x08,
+	R_CSI2_INTERRUPT = 0x0C,
+	R_CSI2_DATA_IDS_1 = 0x10,
+	R_CSI2_DATA_IDS_2 = 0x14,
+	R_CSI2_IPI_MODE = 0x80,
+	R_CSI2_IPI_VCID = 0x84,
+	R_CSI2_IPI_DATA_TYPE = 0x88,
+	R_CSI2_IPI_MEM_FLUSH = 0x8C,
+	R_CSI2_IPI_HSA_TIME = 0x90,
+	R_CSI2_IPI_HBP_TIME = 0x94,
+	R_CSI2_IPI_HSD_TIME = 0x98,
+	R_CSI2_IPI_HLINE_TIME = 0x9C,
+	R_CSI2_IPI_VSA_LINES = 0xB0,
+	R_CSI2_IPI_VBP_LINES = 0xB4,
+	R_CSI2_IPI_VFP_LINES = 0xB8,
+	R_CSI2_IPI_VACTIVE_LINES = 0xBC,
+	R_CSI2_INT_PHY_FATAL = 0xe0,
+	R_CSI2_MASK_INT_PHY_FATAL = 0xe4,
+	R_CSI2_FORCE_INT_PHY_FATAL = 0xe8,
+	R_CSI2_INT_PKT_FATAL = 0xf0,
+	R_CSI2_MASK_INT_PKT_FATAL = 0xf4,
+	R_CSI2_FORCE_INT_PKT_FATAL = 0xf8,
+	R_CSI2_INT_FRAME_FATAL = 0x100,
+	R_CSI2_MASK_INT_FRAME_FATAL = 0x104,
+	R_CSI2_FORCE_INT_FRAME_FATAL = 0x108,
+	R_CSI2_INT_PHY = 0x110,
+	R_CSI2_MASK_INT_PHY = 0x114,
+	R_CSI2_FORCE_INT_PHY = 0x118,
+	R_CSI2_INT_PKT = 0x120,
+	R_CSI2_MASK_INT_PKT = 0x124,
+	R_CSI2_FORCE_INT_PKT = 0x128,
+	R_CSI2_INT_LINE = 0x130,
+	R_CSI2_MASK_INT_LINE = 0x134,
+	R_CSI2_FORCE_INT_LINE = 0x138,
+	R_CSI2_INT_IPI = 0x140,
+	R_CSI2_MASK_INT_IPI = 0x144,
+	R_CSI2_FORCE_INT_IPI = 0x148
+};
+
+/** @short IPI Data Types */
+enum data_type {
+	CSI_2_YUV420_8 = 0x18,
+	CSI_2_YUV420_10 = 0x19,
+	CSI_2_YUV420_8_LEG = 0x1A,
+	CSI_2_YUV420_8_SHIFT = 0x1C,
+	CSI_2_YUV420_10_SHIFT = 0x1D,
+	CSI_2_YUV422_8 = 0x1E,
+	CSI_2_YUV422_10 = 0x1F,
+	CSI_2_RGB444 = 0x20,
+	CSI_2_RGB555 = 0x21,
+	CSI_2_RGB565 = 0x22,
+	CSI_2_RGB666 = 0x23,
+	CSI_2_RGB888 = 0x24,
+	CSI_2_RAW6 = 0x28,
+	CSI_2_RAW7 = 0x29,
+	CSI_2_RAW8 = 0x2A,
+	CSI_2_RAW10 = 0x2B,
+	CSI_2_RAW12 = 0x2C,
+	CSI_2_RAW14 = 0x2D,
+};
+
+/** @short Interrupt Masks */
+enum interrupt_type {
+	CSI2_INT_PHY_FATAL = 1 << 0,
+	CSI2_INT_PKT_FATAL = 1 << 1,
+	CSI2_INT_FRAME_FATAL = 1 << 2,
+	CSI2_INT_PHY = 1 << 16,
+	CSI2_INT_PKT = 1 << 17,
+	CSI2_INT_LINE = 1 << 18,
+	CSI2_INT_IPI = 1 << 19,
+
+};
+
+/** @short DWC MIPI CSI-2 output types*/
+enum output_type {
+	IPI_OUT = 0,
+	IDI_OUT = 1,
+	BOTH_OUT = 2
+};
+
+/** @short IPI output types*/
+enum ipi_output_type {
+	CAMERA_TIMING = 0,
+	AUTO_TIMING = 1
+};
+
+/**
+ * @short Format template
+ */
+struct mipi_fmt {
+	u32 code;
+	u8 depth;
+};
+
+struct csi_hw {
+
+	uint32_t num_lanes;
+	uint32_t output_type;
+
+	/*IPI Info */
+	uint32_t ipi_mode;
+	uint32_t ipi_color_mode;
+	uint32_t ipi_auto_flush;
+	uint32_t virtual_ch;
+
+	uint32_t hsa;
+	uint32_t hbp;
+	uint32_t hsd;
+	uint32_t htotal;
+
+	uint32_t vsa;
+	uint32_t vbp;
+	uint32_t vfp;
+	uint32_t vactive;
+};
+
+/**
+ * @short Structure to embed device driver information
+ */
+struct mipi_csi_dev {
+	struct v4l2_subdev sd;
+	struct video_device vdev;
+
+	struct mutex lock;
+	spinlock_t slock;
+	struct media_pad pads[CSI_PADS_NUM];
+	struct platform_device *pdev;
+	u8 index;
+
+	/** Store current format */
+	const struct mipi_fmt *fmt;
+	struct v4l2_mbus_framefmt format;
+
+	/** Device Tree Information */
+	void __iomem *base_address;
+	uint32_t ctrl_irq_number;
+
+	struct csi_hw hw;
+	struct phy *phy;
+	struct reset_control *rst;
+};
+
+#endif				/* DW_MIPI_CSI */
diff --git a/include/media/dwc/csi_host_platform.h b/include/media/dwc/csi_host_platform.h
new file mode 100644
index 000000000000..1d4d308a4b7c
--- /dev/null
+++ b/include/media/dwc/csi_host_platform.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (C) 2016 Synopsys, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SNPS_CSI_VIDEO_PLAT_INCLUDES_H_
+#define SNPS_CSI_VIDEO_PLAT_INCLUDES_H_
+
+#include <media/media-entity.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-mediabus.h>
+#include <media/v4l2-subdev.h>
+
+/*
+ * The subdevices' group IDs.
+ */
+
+#define MAX_WIDTH	3280
+#define MAX_HEIGHT	1852
+
+#define MIN_WIDTH	640
+#define MIN_HEIGHT	480
+
+#define GRP_ID_SENSOR		(10)
+#define GRP_ID_CSI		(20)
+#define GRP_ID_VIDEODEV		(30)
+
+#define CSI_MAX_ENTITIES	1
+#define PLAT_MAX_SENSORS	1
+
+enum video_dev_pads {
+	VIDEO_DEV_SD_PAD_SINK_CSI = 0,
+	VIDEO_DEV_SD_PAD_SOURCE_DMA = 1,
+	VIDEO_DEV_SD_PADS_NUM = 2,
+};
+
+enum mipi_csi_pads {
+	CSI_PAD_SINK = 0,
+	CSI_PAD_SOURCE = 1,
+	CSI_PADS_NUM = 2,
+};
+
+struct plat_csi_source_info {
+	u16 flags;
+	u16 mux_id;
+};
+
+struct plat_csi_fmt {
+	char *name;
+	u32 mbus_code;
+	u32 fourcc;
+	u8 depth;
+};
+
+struct plat_csi_media_pipeline;
+
+/*
+ * Media pipeline operations to be called from within a video node,  i.e. the
+ * last entity within the pipeline. Implemented by related media device driver.
+ */
+struct plat_csi_media_pipeline_ops {
+	int (*prepare)(struct plat_csi_media_pipeline *p,
+			struct media_entity *me);
+	int (*unprepare)(struct plat_csi_media_pipeline *p);
+	int (*open)(struct plat_csi_media_pipeline *p,
+			struct media_entity *me, bool resume);
+	int (*close)(struct plat_csi_media_pipeline *p);
+	int (*set_stream)(struct plat_csi_media_pipeline *p, bool state);
+	int (*set_format)(struct plat_csi_media_pipeline *p,
+			struct v4l2_subdev_format *fmt);
+};
+
+struct plat_csi_video_entity {
+	struct video_device vdev;
+	struct plat_csi_media_pipeline *pipe;
+};
+
+struct plat_csi_media_pipeline {
+	struct media_pipeline mp;
+	const struct plat_csi_media_pipeline_ops *ops;
+};
+
+static inline struct plat_csi_video_entity *
+vdev_to_plat_csi_video_entity(struct video_device *vdev)
+{
+	return container_of(vdev, struct plat_csi_video_entity, vdev);
+}
+
+#define plat_csi_pipeline_call(ent, op, args...)\
+	(!(ent) ? -ENOENT : (((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
+	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))	  \
+
+
+#endif				/* SNPS_CSI_VIDEO_PLAT_INCLUDES_H_ */
-- 
2.11.0
