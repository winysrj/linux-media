Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36369 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbcGFXHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:23 -0400
Received: by mail-pa0-f65.google.com with SMTP id ib6so90343pad.3
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:23 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 01/28] gpu: ipu-v3: Add Video Deinterlacer unit
Date: Wed,  6 Jul 2016 16:06:31 -0700
Message-Id: <1467846418-12913-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the Video Deinterlacer (VDIC) unit.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/Makefile     |   2 +-
 drivers/gpu/ipu-v3/ipu-common.c |  11 ++
 drivers/gpu/ipu-v3/ipu-prv.h    |   6 +
 drivers/gpu/ipu-v3/ipu-vdi.c    | 266 ++++++++++++++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |  27 ++++
 5 files changed, 311 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/ipu-v3/ipu-vdi.c

diff --git a/drivers/gpu/ipu-v3/Makefile b/drivers/gpu/ipu-v3/Makefile
index 107ec23..aeba9dc 100644
--- a/drivers/gpu/ipu-v3/Makefile
+++ b/drivers/gpu/ipu-v3/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_IMX_IPUV3_CORE) += imx-ipu-v3.o
 
 imx-ipu-v3-objs := ipu-common.o ipu-cpmem.o ipu-csi.o ipu-dc.o ipu-di.o \
-		ipu-dp.o ipu-dmfc.o ipu-ic.o ipu-smfc.o
+		ipu-dp.o ipu-dmfc.o ipu-ic.o ipu-smfc.o ipu-vdi.o
diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 99dcacf..30dc115 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -833,6 +833,14 @@ static int ipu_submodules_init(struct ipu_soc *ipu,
 		goto err_ic;
 	}
 
+	ret = ipu_vdi_init(ipu, dev, ipu_base + devtype->vdi_ofs,
+			   IPU_CONF_VDI_EN | IPU_CONF_ISP_EN |
+			   IPU_CONF_IC_INPUT);
+	if (ret) {
+		unit = "vdi";
+		goto err_vdi;
+	}
+
 	ret = ipu_di_init(ipu, dev, 0, ipu_base + devtype->disp0_ofs,
 			  IPU_CONF_DI0_EN, ipu_clk);
 	if (ret) {
@@ -887,6 +895,8 @@ err_dc:
 err_di_1:
 	ipu_di_exit(ipu, 0);
 err_di_0:
+	ipu_vdi_exit(ipu);
+err_vdi:
 	ipu_ic_exit(ipu);
 err_ic:
 	ipu_csi_exit(ipu, 1);
@@ -971,6 +981,7 @@ static void ipu_submodules_exit(struct ipu_soc *ipu)
 	ipu_dc_exit(ipu);
 	ipu_di_exit(ipu, 1);
 	ipu_di_exit(ipu, 0);
+	ipu_vdi_exit(ipu);
 	ipu_ic_exit(ipu);
 	ipu_csi_exit(ipu, 1);
 	ipu_csi_exit(ipu, 0);
diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
index bfb1e8a..845f64c 100644
--- a/drivers/gpu/ipu-v3/ipu-prv.h
+++ b/drivers/gpu/ipu-v3/ipu-prv.h
@@ -138,6 +138,7 @@ struct ipu_dc_priv;
 struct ipu_dmfc_priv;
 struct ipu_di;
 struct ipu_ic_priv;
+struct ipu_vdi;
 struct ipu_smfc_priv;
 
 struct ipu_devtype;
@@ -169,6 +170,7 @@ struct ipu_soc {
 	struct ipu_di		*di_priv[2];
 	struct ipu_csi		*csi_priv[2];
 	struct ipu_ic_priv	*ic_priv;
+	struct ipu_vdi          *vdi_priv;
 	struct ipu_smfc_priv	*smfc_priv;
 };
 
@@ -199,6 +201,10 @@ int ipu_ic_init(struct ipu_soc *ipu, struct device *dev,
 		unsigned long base, unsigned long tpmem_base);
 void ipu_ic_exit(struct ipu_soc *ipu);
 
+int ipu_vdi_init(struct ipu_soc *ipu, struct device *dev,
+		 unsigned long base, u32 module);
+void ipu_vdi_exit(struct ipu_soc *ipu);
+
 int ipu_di_init(struct ipu_soc *ipu, struct device *dev, int id,
 		unsigned long base, u32 module, struct clk *ipu_clk);
 void ipu_di_exit(struct ipu_soc *ipu, int id);
diff --git a/drivers/gpu/ipu-v3/ipu-vdi.c b/drivers/gpu/ipu-v3/ipu-vdi.c
new file mode 100644
index 0000000..1303bcc
--- /dev/null
+++ b/drivers/gpu/ipu-v3/ipu-vdi.c
@@ -0,0 +1,266 @@
+/*
+ * Copyright (C) 2012 Mentor Graphics Inc.
+ * Copyright (C) 2005-2009 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ */
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <uapi/linux/v4l2-mediabus.h>
+
+#include "ipu-prv.h"
+
+struct ipu_vdi {
+	void __iomem *base;
+	u32 module;
+	spinlock_t lock;
+	int use_count;
+	struct ipu_soc *ipu;
+};
+
+
+/* VDI Register Offsets */
+#define VDI_FSIZE 0x0000
+#define VDI_C     0x0004
+
+/* VDI Register Fields */
+#define VDI_C_CH_420             (0 << 1)
+#define VDI_C_CH_422             (1 << 1)
+#define VDI_C_MOT_SEL_MASK       (0x3 << 2)
+#define VDI_C_MOT_SEL_FULL       (2 << 2)
+#define VDI_C_MOT_SEL_LOW        (1 << 2)
+#define VDI_C_MOT_SEL_MED        (0 << 2)
+#define VDI_C_BURST_SIZE1_4      (3 << 4)
+#define VDI_C_BURST_SIZE2_4      (3 << 8)
+#define VDI_C_BURST_SIZE3_4      (3 << 12)
+#define VDI_C_BURST_SIZE_MASK    0xF
+#define VDI_C_BURST_SIZE1_OFFSET 4
+#define VDI_C_BURST_SIZE2_OFFSET 8
+#define VDI_C_BURST_SIZE3_OFFSET 12
+#define VDI_C_VWM1_SET_1         (0 << 16)
+#define VDI_C_VWM1_SET_2         (1 << 16)
+#define VDI_C_VWM1_CLR_2         (1 << 19)
+#define VDI_C_VWM3_SET_1         (0 << 22)
+#define VDI_C_VWM3_SET_2         (1 << 22)
+#define VDI_C_VWM3_CLR_2         (1 << 25)
+#define VDI_C_TOP_FIELD_MAN_1    (1 << 30)
+#define VDI_C_TOP_FIELD_AUTO_1   (1 << 31)
+
+static inline u32 ipu_vdi_read(struct ipu_vdi *vdi, unsigned int offset)
+{
+	return readl(vdi->base + offset);
+}
+
+static inline void ipu_vdi_write(struct ipu_vdi *vdi, u32 value,
+				 unsigned int offset)
+{
+	writel(value, vdi->base + offset);
+}
+
+static void __ipu_vdi_set_top_field_man(struct ipu_vdi *vdi, bool top_field_0)
+{
+	u32 reg;
+
+	reg = ipu_vdi_read(vdi, VDI_C);
+	if (top_field_0)
+		reg &= ~VDI_C_TOP_FIELD_MAN_1;
+	else
+		reg |= VDI_C_TOP_FIELD_MAN_1;
+	ipu_vdi_write(vdi, reg, VDI_C);
+}
+
+static void __ipu_vdi_set_motion(struct ipu_vdi *vdi,
+				 enum ipu_motion_sel motion_sel)
+{
+	u32 reg;
+
+	reg = ipu_vdi_read(vdi, VDI_C);
+
+	reg &= ~VDI_C_MOT_SEL_MASK;
+
+	switch (motion_sel) {
+	case MED_MOTION:
+		reg |= VDI_C_MOT_SEL_MED;
+		break;
+	case HIGH_MOTION:
+		reg |= VDI_C_MOT_SEL_FULL;
+		break;
+	default:
+		reg |= VDI_C_MOT_SEL_LOW;
+		break;
+	}
+
+	ipu_vdi_write(vdi, reg, VDI_C);
+}
+
+void ipu_vdi_setup(struct ipu_vdi *vdi, u32 code, int xres, int yres,
+		   u32 field, enum ipu_motion_sel motion_sel)
+{
+	unsigned long flags;
+	u32 pixel_fmt, reg;
+
+	spin_lock_irqsave(&vdi->lock, flags);
+
+	reg = ((yres - 1) << 16) | (xres - 1);
+	ipu_vdi_write(vdi, reg, VDI_FSIZE);
+
+	/*
+	 * Full motion, only vertical filter is used.
+	 * Burst size is 4 accesses
+	 */
+	if (code == MEDIA_BUS_FMT_UYVY8_2X8 ||
+	    code == MEDIA_BUS_FMT_UYVY8_1X16 ||
+	    code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+	    code == MEDIA_BUS_FMT_YUYV8_1X16)
+		pixel_fmt = VDI_C_CH_422;
+	else
+		pixel_fmt = VDI_C_CH_420;
+
+	reg = ipu_vdi_read(vdi, VDI_C);
+	reg |= pixel_fmt;
+	reg |= VDI_C_BURST_SIZE2_4;
+	reg |= VDI_C_BURST_SIZE1_4 | VDI_C_VWM1_CLR_2;
+	reg |= VDI_C_BURST_SIZE3_4 | VDI_C_VWM3_CLR_2;
+	ipu_vdi_write(vdi, reg, VDI_C);
+
+	if (field == V4L2_FIELD_INTERLACED_TB)
+		__ipu_vdi_set_top_field_man(vdi, false);
+	else if (field == V4L2_FIELD_INTERLACED_BT)
+		__ipu_vdi_set_top_field_man(vdi, true);
+
+	__ipu_vdi_set_motion(vdi, motion_sel);
+
+	spin_unlock_irqrestore(&vdi->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_setup);
+
+void ipu_vdi_unsetup(struct ipu_vdi *vdi)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdi->lock, flags);
+	ipu_vdi_write(vdi, 0, VDI_FSIZE);
+	ipu_vdi_write(vdi, 0, VDI_C);
+	spin_unlock_irqrestore(&vdi->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_unsetup);
+
+void ipu_vdi_toggle_top_field_man(struct ipu_vdi *vdi)
+{
+	unsigned long flags;
+	u32 reg;
+	u32 mask_reg;
+
+	spin_lock_irqsave(&vdi->lock, flags);
+
+	reg = ipu_vdi_read(vdi, VDI_C);
+	mask_reg = reg & VDI_C_TOP_FIELD_MAN_1;
+	if (mask_reg == VDI_C_TOP_FIELD_MAN_1)
+		reg &= ~VDI_C_TOP_FIELD_MAN_1;
+	else
+		reg |= VDI_C_TOP_FIELD_MAN_1;
+
+	ipu_vdi_write(vdi, reg, VDI_C);
+
+	spin_unlock_irqrestore(&vdi->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_toggle_top_field_man);
+
+int ipu_vdi_set_src(struct ipu_vdi *vdi, bool csi)
+{
+	ipu_set_vdi_src_mux(vdi->ipu, csi);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_set_src);
+
+int ipu_vdi_enable(struct ipu_vdi *vdi)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdi->lock, flags);
+
+	if (!vdi->use_count)
+		ipu_module_enable(vdi->ipu, vdi->module);
+
+	vdi->use_count++;
+
+	spin_unlock_irqrestore(&vdi->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_enable);
+
+int ipu_vdi_disable(struct ipu_vdi *vdi)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdi->lock, flags);
+
+	vdi->use_count--;
+
+	if (!vdi->use_count)
+		ipu_module_disable(vdi->ipu, vdi->module);
+
+	if (vdi->use_count < 0)
+		vdi->use_count = 0;
+
+	spin_unlock_irqrestore(&vdi->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_disable);
+
+struct ipu_vdi *ipu_vdi_get(struct ipu_soc *ipu)
+{
+	return ipu->vdi_priv;
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_get);
+
+void ipu_vdi_put(struct ipu_vdi *vdi)
+{
+}
+EXPORT_SYMBOL_GPL(ipu_vdi_put);
+
+int ipu_vdi_init(struct ipu_soc *ipu, struct device *dev,
+		 unsigned long base, u32 module)
+{
+	struct ipu_vdi *vdi;
+
+	vdi = devm_kzalloc(dev, sizeof(*vdi), GFP_KERNEL);
+	if (!vdi)
+		return -ENOMEM;
+
+	ipu->vdi_priv = vdi;
+
+	spin_lock_init(&vdi->lock);
+	vdi->module = module;
+	vdi->base = devm_ioremap(dev, base, PAGE_SIZE);
+	if (!vdi->base)
+		return -ENOMEM;
+
+	dev_dbg(dev, "VDI base: 0x%08lx remapped to %p\n", base, vdi->base);
+	vdi->ipu = ipu;
+
+	return 0;
+}
+
+void ipu_vdi_exit(struct ipu_soc *ipu)
+{
+}
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 3a2a794..22662a1 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -80,6 +80,16 @@ enum ipu_color_space {
 	IPUV3_COLORSPACE_UNKNOWN,
 };
 
+/*
+ * Enumeration of VDI MOTION select
+ */
+enum ipu_motion_sel {
+	MOTION_NONE = 0,
+	LOW_MOTION,
+	MED_MOTION,
+	HIGH_MOTION,
+};
+
 struct ipuv3_channel;
 
 enum ipu_channel_irq {
@@ -320,6 +330,23 @@ void ipu_ic_put(struct ipu_ic *ic);
 void ipu_ic_dump(struct ipu_ic *ic);
 
 /*
+ * IPU Video De-Interlacer (vdi) functions
+ */
+struct ipu_vdi;
+void ipu_vdi_set_top_field_man(struct ipu_vdi *vdi, bool top_field_0);
+void ipu_vdi_set_motion(struct ipu_vdi *vdi, enum ipu_motion_sel motion_sel);
+void ipu_vdi_setup(struct ipu_vdi *vdi,
+		   u32 code, int xres, int yres, u32 field,
+		   enum ipu_motion_sel motion_sel);
+void ipu_vdi_unsetup(struct ipu_vdi *vdi);
+void ipu_vdi_toggle_top_field_man(struct ipu_vdi *vdi);
+int ipu_vdi_set_src(struct ipu_vdi *vdi, bool csi);
+int ipu_vdi_enable(struct ipu_vdi *vdi);
+int ipu_vdi_disable(struct ipu_vdi *vdi);
+struct ipu_vdi *ipu_vdi_get(struct ipu_soc *ipu);
+void ipu_vdi_put(struct ipu_vdi *vdi);
+
+/*
  * IPU Sensor Multiple FIFO Controller (SMFC) functions
  */
 struct ipu_smfc *ipu_smfc_get(struct ipu_soc *ipu, unsigned int chno);
-- 
1.9.1

