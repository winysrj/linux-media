Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47628 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbaFZBHT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:19 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so2326023pde.34
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:19 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 05/28] gpu: ipu-v3: Add units required for video capture
Date: Wed, 25 Jun 2014 18:05:32 -0700
Message-Id: <1403744755-24944-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the following new IPU units:

- Camera Sensor Interface (csi)
- Image Converter (ic)

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/Makefile     |    3 +-
 drivers/gpu/ipu-v3/ipu-common.c |   63 ++-
 drivers/gpu/ipu-v3/ipu-csi.c    |  701 +++++++++++++++++++++++++++++++++
 drivers/gpu/ipu-v3/ipu-ic.c     |  812 +++++++++++++++++++++++++++++++++++++++
 drivers/gpu/ipu-v3/ipu-prv.h    |   12 +
 include/video/imx-ipu-v3.h      |  113 +++++-
 6 files changed, 1688 insertions(+), 16 deletions(-)
 create mode 100644 drivers/gpu/ipu-v3/ipu-csi.c
 create mode 100644 drivers/gpu/ipu-v3/ipu-ic.c

diff --git a/drivers/gpu/ipu-v3/Makefile b/drivers/gpu/ipu-v3/Makefile
index 1887972b..830804f 100644
--- a/drivers/gpu/ipu-v3/Makefile
+++ b/drivers/gpu/ipu-v3/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_IMX_IPUV3_CORE) += imx-ipu-v3.o
 
-imx-ipu-v3-objs := ipu-common.o ipu-dc.o ipu-di.o ipu-dp.o ipu-dmfc.o ipu-smfc.o
+imx-ipu-v3-objs := ipu-common.o ipu-csi.o ipu-dc.o ipu-di.o ipu-dp.o \
+		ipu-dmfc.o ipu-ic.o ipu-smfc.o
diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 1155eb9..0ac2103 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -667,18 +667,6 @@ int ipu_module_disable(struct ipu_soc *ipu, u32 mask)
 }
 EXPORT_SYMBOL_GPL(ipu_module_disable);
 
-int ipu_csi_enable(struct ipu_soc *ipu, int csi)
-{
-	return ipu_module_enable(ipu, csi ? IPU_CONF_CSI1_EN : IPU_CONF_CSI0_EN);
-}
-EXPORT_SYMBOL_GPL(ipu_csi_enable);
-
-int ipu_csi_disable(struct ipu_soc *ipu, int csi)
-{
-	return ipu_module_disable(ipu, csi ? IPU_CONF_CSI1_EN : IPU_CONF_CSI0_EN);
-}
-EXPORT_SYMBOL_GPL(ipu_csi_disable);
-
 int ipu_smfc_enable(struct ipu_soc *ipu)
 {
 	return ipu_module_enable(ipu, IPU_CONF_SMFC_EN);
@@ -889,6 +877,9 @@ struct ipu_devtype {
 	unsigned long cpmem_ofs;
 	unsigned long srm_ofs;
 	unsigned long tpm_ofs;
+	unsigned long csi0_ofs;
+	unsigned long csi1_ofs;
+	unsigned long ic_ofs;
 	unsigned long disp0_ofs;
 	unsigned long disp1_ofs;
 	unsigned long dc_tmpl_ofs;
@@ -902,6 +893,9 @@ static struct ipu_devtype ipu_type_imx51 = {
 	.cpmem_ofs = 0x1f000000,
 	.srm_ofs = 0x1f040000,
 	.tpm_ofs = 0x1f060000,
+	.csi0_ofs = 0x1f030000,
+	.csi1_ofs = 0x1f038000,
+	.ic_ofs = 0x1f020000,
 	.disp0_ofs = 0x1e040000,
 	.disp1_ofs = 0x1e048000,
 	.dc_tmpl_ofs = 0x1f080000,
@@ -915,6 +909,9 @@ static struct ipu_devtype ipu_type_imx53 = {
 	.cpmem_ofs = 0x07000000,
 	.srm_ofs = 0x07040000,
 	.tpm_ofs = 0x07060000,
+	.csi0_ofs = 0x07030000,
+	.csi1_ofs = 0x07038000,
+	.ic_ofs = 0x07020000,
 	.disp0_ofs = 0x06040000,
 	.disp1_ofs = 0x06048000,
 	.dc_tmpl_ofs = 0x07080000,
@@ -928,6 +925,9 @@ static struct ipu_devtype ipu_type_imx6q = {
 	.cpmem_ofs = 0x00300000,
 	.srm_ofs = 0x00340000,
 	.tpm_ofs = 0x00360000,
+	.csi0_ofs = 0x00230000,
+	.csi1_ofs = 0x00238000,
+	.ic_ofs = 0x00220000,
 	.disp0_ofs = 0x00240000,
 	.disp1_ofs = 0x00248000,
 	.dc_tmpl_ofs = 0x00380000,
@@ -952,8 +952,30 @@ static int ipu_submodules_init(struct ipu_soc *ipu,
 	struct device *dev = &pdev->dev;
 	const struct ipu_devtype *devtype = ipu->devtype;
 
+	ret = ipu_csi_init(ipu, dev, 0, ipu_base + devtype->csi0_ofs,
+			   IPU_CONF_CSI0_EN, ipu_clk);
+	if (ret) {
+		unit = "csi0";
+		goto err_csi_0;
+	}
+
+	ret = ipu_csi_init(ipu, dev, 1, ipu_base + devtype->csi1_ofs,
+			   IPU_CONF_CSI1_EN, ipu_clk);
+	if (ret) {
+		unit = "csi1";
+		goto err_csi_1;
+	}
+
+	ret = ipu_ic_init(ipu, dev,
+			  ipu_base + devtype->ic_ofs,
+			  ipu_base + devtype->tpm_ofs);
+	if (ret) {
+		unit = "ic";
+		goto err_ic;
+	}
+
 	ret = ipu_di_init(ipu, dev, 0, ipu_base + devtype->disp0_ofs,
-			IPU_CONF_DI0_EN, ipu_clk);
+			  IPU_CONF_DI0_EN, ipu_clk);
 	if (ret) {
 		unit = "di0";
 		goto err_di_0;
@@ -1006,6 +1028,12 @@ err_dc:
 err_di_1:
 	ipu_di_exit(ipu, 0);
 err_di_0:
+	ipu_ic_exit(ipu);
+err_ic:
+	ipu_csi_exit(ipu, 1);
+err_csi_1:
+	ipu_csi_exit(ipu, 0);
+err_csi_0:
 	dev_err(&pdev->dev, "init %s failed with %d\n", unit, ret);
 	return ret;
 }
@@ -1082,6 +1110,9 @@ static void ipu_submodules_exit(struct ipu_soc *ipu)
 	ipu_dc_exit(ipu);
 	ipu_di_exit(ipu, 1);
 	ipu_di_exit(ipu, 0);
+	ipu_ic_exit(ipu);
+	ipu_csi_exit(ipu, 1);
+	ipu_csi_exit(ipu, 0);
 }
 
 static int platform_remove_devices_fn(struct device *dev, void *unused)
@@ -1302,6 +1333,12 @@ static int ipu_probe(struct platform_device *pdev)
 			ipu_base + devtype->cm_ofs + IPU_CM_IDMAC_REG_OFS);
 	dev_dbg(&pdev->dev, "cpmem:    0x%08lx\n",
 			ipu_base + devtype->cpmem_ofs);
+	dev_dbg(&pdev->dev, "csi0:    0x%08lx\n",
+			ipu_base + devtype->csi0_ofs);
+	dev_dbg(&pdev->dev, "csi1:    0x%08lx\n",
+			ipu_base + devtype->csi1_ofs);
+	dev_dbg(&pdev->dev, "ic:      0x%08lx\n",
+			ipu_base + devtype->ic_ofs);
 	dev_dbg(&pdev->dev, "disp0:    0x%08lx\n",
 			ipu_base + devtype->disp0_ofs);
 	dev_dbg(&pdev->dev, "disp1:    0x%08lx\n",
diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
new file mode 100644
index 0000000..3ca3e7c
--- /dev/null
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -0,0 +1,701 @@
+/*
+ * Copyright (C) 2012-2014 Mentor Graphics Inc.
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
+#include <linux/videodev2.h>
+#include <uapi/linux/v4l2-mediabus.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+
+#include "ipu-prv.h"
+
+struct ipu_csi {
+	void __iomem *base;
+	int id;
+	u32 module;
+	struct clk *clk_ipu;    /* IPU bus clock */
+	spinlock_t lock;
+	bool inuse;
+	struct ipu_soc *ipu;
+};
+
+/* CSI Register Offsets */
+#define CSI_SENS_CONF           0x0000
+#define CSI_SENS_FRM_SIZE       0x0004
+#define CSI_ACT_FRM_SIZE        0x0008
+#define CSI_OUT_FRM_CTRL        0x000C
+#define CSI_TST_CTRL            0x0010
+#define CSI_CCIR_CODE_1         0x0014
+#define CSI_CCIR_CODE_2         0x0018
+#define CSI_CCIR_CODE_3         0x001C
+#define CSI_MIPI_DI             0x0020
+#define CSI_SKIP                0x0024
+#define CSI_CPD_CTRL            0x0028
+#define CSI_CPD_RC(n)           (0x002C + ((n)*4))
+#define CSI_CPD_RS(n)           (0x004C + ((n)*4))
+#define CSI_CPD_GRC(n)          (0x005C + ((n)*4))
+#define CSI_CPD_GRS(n)          (0x007C + ((n)*4))
+#define CSI_CPD_GBC(n)          (0x008C + ((n)*4))
+#define CSI_CPD_GBS(n)          (0x00AC + ((n)*4))
+#define CSI_CPD_BC(n)           (0x00BC + ((n)*4))
+#define CSI_CPD_BS(n)           (0x00DC + ((n)*4))
+#define CSI_CPD_OFFSET1         0x00EC
+#define CSI_CPD_OFFSET2         0x00F0
+
+/* CSI Register Fields */
+#define CSI_SENS_CONF_DATA_FMT_SHIFT       8
+#define CSI_SENS_CONF_DATA_FMT_MASK        0x00000700
+#define CSI_SENS_CONF_DATA_FMT_RGB_YUV444  0L
+#define CSI_SENS_CONF_DATA_FMT_YUV422_YUYV 1L
+#define CSI_SENS_CONF_DATA_FMT_YUV422_UYVY 2L
+#define CSI_SENS_CONF_DATA_FMT_BAYER       3L
+#define CSI_SENS_CONF_DATA_FMT_RGB565      4L
+#define CSI_SENS_CONF_DATA_FMT_RGB555      5L
+#define CSI_SENS_CONF_DATA_FMT_RGB444      6L
+#define CSI_SENS_CONF_DATA_FMT_JPEG        7L
+
+#define CSI_SENS_CONF_VSYNC_POL_SHIFT      0
+#define CSI_SENS_CONF_HSYNC_POL_SHIFT      1
+#define CSI_SENS_CONF_DATA_POL_SHIFT       2
+#define CSI_SENS_CONF_PIX_CLK_POL_SHIFT    3
+#define CSI_SENS_CONF_SENS_PRTCL_MASK      0x00000070L
+#define CSI_SENS_CONF_SENS_PRTCL_SHIFT     4
+#define CSI_SENS_CONF_PACK_TIGHT_SHIFT     7
+#define CSI_SENS_CONF_DATA_WIDTH_SHIFT     11
+#define CSI_SENS_CONF_EXT_VSYNC_SHIFT      15
+#define CSI_SENS_CONF_DIVRATIO_SHIFT       16
+
+#define CSI_SENS_CONF_DIVRATIO_MASK        0x00FF0000L
+#define CSI_SENS_CONF_DATA_DEST_SHIFT      24
+#define CSI_SENS_CONF_DATA_DEST_MASK       0x07000000L
+#define CSI_SENS_CONF_JPEG8_EN_SHIFT       27
+#define CSI_SENS_CONF_JPEG_EN_SHIFT        28
+#define CSI_SENS_CONF_FORCE_EOF_SHIFT      29
+#define CSI_SENS_CONF_DATA_EN_POL_SHIFT    31
+
+#define CSI_DATA_DEST_IC                   2L
+#define CSI_DATA_DEST_IDMAC                4L
+
+#define CSI_CCIR_ERR_DET_EN                0x01000000L
+#define CSI_HORI_DOWNSIZE_EN               0x80000000L
+#define CSI_VERT_DOWNSIZE_EN               0x40000000L
+#define CSI_TEST_GEN_MODE_EN               0x01000000L
+
+#define CSI_HSC_MASK                       0x1FFF0000
+#define CSI_HSC_SHIFT                      16
+#define CSI_VSC_MASK                       0x00000FFF
+#define CSI_VSC_SHIFT                      0
+
+#define CSI_TEST_GEN_R_MASK                0x000000FFL
+#define CSI_TEST_GEN_R_SHIFT               0
+#define CSI_TEST_GEN_G_MASK                0x0000FF00L
+#define CSI_TEST_GEN_G_SHIFT               8
+#define CSI_TEST_GEN_B_MASK                0x00FF0000L
+#define CSI_TEST_GEN_B_SHIFT               16
+
+#define CSI_MAX_RATIO_SKIP_SMFC_MASK       0x00000007L
+#define CSI_MAX_RATIO_SKIP_SMFC_SHIFT      0
+#define CSI_SKIP_SMFC_MASK                 0x000000F8L
+#define CSI_SKIP_SMFC_SHIFT                3
+#define CSI_ID_2_SKIP_MASK                 0x00000300L
+#define CSI_ID_2_SKIP_SHIFT                8
+
+#define CSI_COLOR_FIRST_ROW_MASK           0x00000002L
+#define CSI_COLOR_FIRST_COMP_MASK          0x00000001L
+
+/* MIPI CSI-2 data types */
+#define MIPI_DT_YUV420		0x18 /* YYY.../UYVY.... */
+#define MIPI_DT_YUV420_LEGACY	0x1a /* UYY.../VYY...   */
+#define MIPI_DT_YUV422		0x1e /* UYVY...		*/
+#define MIPI_DT_RGB444		0x20
+#define MIPI_DT_RGB555		0x21
+#define MIPI_DT_RGB565		0x22
+#define MIPI_DT_RGB666		0x23
+#define MIPI_DT_RGB888		0x24
+#define MIPI_DT_RAW6		0x28
+#define MIPI_DT_RAW7		0x29
+#define MIPI_DT_RAW8		0x2a
+#define MIPI_DT_RAW10		0x2b
+#define MIPI_DT_RAW12		0x2c
+#define MIPI_DT_RAW14		0x2d
+
+
+static inline u32 ipu_csi_read(struct ipu_csi *csi, unsigned offset)
+{
+	return readl(csi->base + offset);
+}
+
+static inline void ipu_csi_write(struct ipu_csi *csi, u32 value,
+				 unsigned offset)
+{
+	writel(value, csi->base + offset);
+}
+
+/*
+ * Enable error detection and correction for CCIR interlaced mode.
+ */
+static inline void ipu_csi_ccir_err_detection_enable(struct ipu_csi *csi)
+{
+	u32 temp;
+
+	temp = ipu_csi_read(csi, CSI_CCIR_CODE_1);
+	temp |= CSI_CCIR_ERR_DET_EN;
+	ipu_csi_write(csi, temp, CSI_CCIR_CODE_1);
+
+}
+
+/*
+ * Disable error detection and correction for CCIR interlaced mode.
+ */
+static inline void ipu_csi_ccir_err_detection_disable(struct ipu_csi *csi)
+{
+	u32 temp;
+
+	temp = ipu_csi_read(csi, CSI_CCIR_CODE_1);
+	temp &= ~CSI_CCIR_ERR_DET_EN;
+	ipu_csi_write(csi, temp, CSI_CCIR_CODE_1);
+
+}
+
+static inline void ipu_csi_set_horizontal_downsize(struct ipu_csi *csi,
+						   bool enable)
+{
+	u32 temp;
+
+	temp = ipu_csi_read(csi, CSI_OUT_FRM_CTRL);
+	if (enable)
+		temp |= CSI_HORI_DOWNSIZE_EN;
+	else
+		temp &= ~CSI_HORI_DOWNSIZE_EN;
+	ipu_csi_write(csi, temp, CSI_OUT_FRM_CTRL);
+}
+
+static inline void ipu_csi_set_vertical_downsize(struct ipu_csi *csi,
+						 bool enable)
+{
+	u32 temp;
+
+	temp = ipu_csi_read(csi, CSI_OUT_FRM_CTRL);
+	if (enable)
+		temp |= CSI_VERT_DOWNSIZE_EN;
+	else
+		temp &= ~CSI_VERT_DOWNSIZE_EN;
+	ipu_csi_write(csi, temp, CSI_OUT_FRM_CTRL);
+}
+
+/*
+ * Set mclk division ratio for generating test mode mclk. Only used
+ * for test generator.
+ */
+static int ipu_csi_set_testgen_mclk(struct ipu_csi *csi, u32 pixel_clk,
+				    u32 ipu_clk)
+{
+	u32 temp;
+	u32 div_ratio;
+
+	div_ratio = (ipu_clk / pixel_clk) - 1;
+
+	if (div_ratio > 0xFF || div_ratio < 0) {
+		dev_err(csi->ipu->dev,
+			"value of pixel_clk extends normal range\n");
+		return -EINVAL;
+	}
+
+	temp = ipu_csi_read(csi, CSI_SENS_CONF);
+	temp &= ~CSI_SENS_CONF_DIVRATIO_MASK;
+	ipu_csi_write(csi, temp | (div_ratio << CSI_SENS_CONF_DIVRATIO_SHIFT),
+		      CSI_SENS_CONF);
+
+	return 0;
+}
+
+int ipu_csi_init_interface(struct ipu_csi *csi, u16 width, u16 height,
+			   struct ipu_csi_signal_cfg *cfg)
+{
+	unsigned long flags;
+	u32 data = 0;
+	u32 ipu_clk;
+
+	/* Set the CSI_SENS_CONF register remaining fields */
+	data |= cfg->data_width << CSI_SENS_CONF_DATA_WIDTH_SHIFT |
+		cfg->data_fmt << CSI_SENS_CONF_DATA_FMT_SHIFT |
+		cfg->data_pol << CSI_SENS_CONF_DATA_POL_SHIFT |
+		cfg->vsync_pol << CSI_SENS_CONF_VSYNC_POL_SHIFT |
+		cfg->hsync_pol << CSI_SENS_CONF_HSYNC_POL_SHIFT |
+		cfg->pixclk_pol << CSI_SENS_CONF_PIX_CLK_POL_SHIFT |
+		cfg->ext_vsync << CSI_SENS_CONF_EXT_VSYNC_SHIFT |
+		cfg->clk_mode << CSI_SENS_CONF_SENS_PRTCL_SHIFT |
+		cfg->pack_tight << CSI_SENS_CONF_PACK_TIGHT_SHIFT |
+		cfg->force_eof << CSI_SENS_CONF_FORCE_EOF_SHIFT |
+		cfg->data_en_pol << CSI_SENS_CONF_DATA_EN_POL_SHIFT;
+
+	ipu_clk = clk_get_rate(csi->clk_ipu);
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	ipu_csi_write(csi, data, CSI_SENS_CONF);
+
+	/* Setup sensor frame size */
+	ipu_csi_write(csi, (width - 1) | (height - 1) << 16, CSI_SENS_FRM_SIZE);
+
+	/* Set CCIR registers */
+
+	switch (cfg->clk_mode) {
+	case IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE:
+		ipu_csi_write(csi, 0x40030, CSI_CCIR_CODE_1);
+		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+		break;
+	case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
+		if (width == 720 && height == 625) {
+			/*
+			 * PAL case
+			 *
+			 * Field0BlankEnd = 0x6, Field0BlankStart = 0x2,
+			 * Field0ActiveEnd = 0x4, Field0ActiveStart = 0
+			 * Field1BlankEnd = 0x7, Field1BlankStart = 0x3,
+			 * Field1ActiveEnd = 0x5, Field1ActiveStart = 0x1
+			 */
+			ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_1);
+			ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
+			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+
+		} else if (width == 720 && height == 525) {
+			/*
+			 * NTSC case
+			 *
+			 * Field0BlankEnd = 0x7, Field0BlankStart = 0x3,
+			 * Field0ActiveEnd = 0x5, Field0ActiveStart = 0x1
+			 * Field1BlankEnd = 0x6, Field1BlankStart = 0x2,
+			 * Field1ActiveEnd = 0x4, Field1ActiveStart = 0
+			 */
+			ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_1);
+			ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
+			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+		} else {
+			dev_err(csi->ipu->dev,
+				"Unsupported CCIR656 interlaced video mode\n");
+			spin_unlock_irqrestore(&csi->lock, flags);
+			return -EINVAL;
+		}
+
+		ipu_csi_ccir_err_detection_enable(csi);
+		break;
+	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
+	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
+	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
+	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
+		ipu_csi_write(csi, 0x40030, CSI_CCIR_CODE_1);
+		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+		ipu_csi_ccir_err_detection_enable(csi);
+		break;
+	case IPU_CSI_CLK_MODE_GATED_CLK:
+	case IPU_CSI_CLK_MODE_NONGATED_CLK:
+		ipu_csi_ccir_err_detection_disable(csi);
+		break;
+	}
+
+	dev_dbg(csi->ipu->dev, "CSI_SENS_CONF = 0x%08X\n",
+		ipu_csi_read(csi, CSI_SENS_CONF));
+	dev_dbg(csi->ipu->dev, "CSI_ACT_FRM_SIZE = 0x%08X\n",
+		ipu_csi_read(csi, CSI_ACT_FRM_SIZE));
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_init_interface);
+
+/*
+ * Find the CSI data format and data width codes for the given V4L2 media
+ * bus pixel format code.
+ */
+int ipu_csi_mbus_fmt_to_sig_cfg(struct ipu_csi_signal_cfg *cfg, u32 mbus_code)
+{
+	switch (mbus_code) {
+	case V4L2_MBUS_FMT_BGR565_2X8_BE:
+	case V4L2_MBUS_FMT_BGR565_2X8_LE:
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB565;
+		cfg->mipi_dt = MIPI_DT_RGB565;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE:
+	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB444;
+		cfg->mipi_dt = MIPI_DT_RGB444;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
+	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB555;
+		cfg->mipi_dt = MIPI_DT_RGB555;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_UYVY;
+		cfg->mipi_dt = MIPI_DT_YUV422;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_YUYV;
+		cfg->mipi_dt = MIPI_DT_YUV422;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_UYVY;
+		cfg->mipi_dt = MIPI_DT_YUV422;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
+		break;
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_YUYV;
+		cfg->mipi_dt = MIPI_DT_YUV422;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
+		break;
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case V4L2_MBUS_FMT_SGBRG8_1X8:
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
+	case V4L2_MBUS_FMT_SRGGB8_1X8:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
+		cfg->mipi_dt = MIPI_DT_RAW8;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE:
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
+		cfg->mipi_dt = MIPI_DT_RAW10;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case V4L2_MBUS_FMT_SGBRG10_1X10:
+	case V4L2_MBUS_FMT_SGRBG10_1X10:
+	case V4L2_MBUS_FMT_SRGGB10_1X10:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
+		cfg->mipi_dt = MIPI_DT_RAW10;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_10;
+		break;
+	case V4L2_MBUS_FMT_SBGGR12_1X12:
+	case V4L2_MBUS_FMT_SGBRG12_1X12:
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case V4L2_MBUS_FMT_SRGGB12_1X12:
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
+		cfg->mipi_dt = MIPI_DT_RAW12;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_12;
+		break;
+	case V4L2_MBUS_FMT_JPEG_1X8:
+		/* TODO */
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_JPEG;
+		cfg->mipi_dt = MIPI_DT_RAW8;
+		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_mbus_fmt_to_sig_cfg);
+
+bool ipu_csi_is_interlaced(struct ipu_csi *csi)
+{
+	unsigned long flags;
+	u32 sensor_protocol;
+
+	spin_lock_irqsave(&csi->lock, flags);
+	sensor_protocol =
+		(ipu_csi_read(csi, CSI_SENS_CONF) &
+		 CSI_SENS_CONF_SENS_PRTCL_MASK) >>
+		CSI_SENS_CONF_SENS_PRTCL_SHIFT;
+	spin_unlock_irqrestore(&csi->lock, flags);
+
+	switch (sensor_protocol) {
+	case IPU_CSI_CLK_MODE_GATED_CLK:
+	case IPU_CSI_CLK_MODE_NONGATED_CLK:
+	case IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE:
+	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
+	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
+		return false;
+		break;
+	case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
+	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
+	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
+		return true;
+		break;
+	default:
+		dev_err(csi->ipu->dev,
+			"CSI %d sensor protocol unsupported\n", csi->id);
+		return false;
+	}
+}
+EXPORT_SYMBOL_GPL(ipu_csi_is_interlaced);
+
+void ipu_csi_get_window(struct ipu_csi *csi, struct v4l2_rect *w)
+{
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	reg = ipu_csi_read(csi, CSI_ACT_FRM_SIZE);
+	w->width = (reg & 0xFFFF) + 1;
+	w->height = (reg >> 16 & 0xFFFF) + 1;
+
+	reg = ipu_csi_read(csi, CSI_OUT_FRM_CTRL);
+	w->left = (reg & CSI_HSC_MASK) >> CSI_HSC_SHIFT;
+	w->top = (reg & CSI_VSC_MASK) >> CSI_VSC_SHIFT;
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_csi_get_window);
+
+void ipu_csi_set_window(struct ipu_csi *csi, struct v4l2_rect *w)
+{
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	ipu_csi_write(csi, (w->width - 1) | ((w->height - 1) << 16),
+		      CSI_ACT_FRM_SIZE);
+
+	reg = ipu_csi_read(csi, CSI_OUT_FRM_CTRL);
+	reg &= ~(CSI_HSC_MASK | CSI_VSC_MASK);
+	reg |= ((w->top << CSI_VSC_SHIFT) | (w->left << CSI_HSC_SHIFT));
+	ipu_csi_write(csi, reg, CSI_OUT_FRM_CTRL);
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_csi_set_window);
+
+void ipu_csi_set_test_generator(struct ipu_csi *csi, bool active,
+				u32 r_value, u32 g_value, u32 b_value,
+				u32 pix_clk)
+{
+	unsigned long flags;
+	u32 ipu_clk = clk_get_rate(csi->clk_ipu);
+	u32 temp;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	temp = ipu_csi_read(csi, CSI_TST_CTRL);
+
+	if (active == false) {
+		temp &= ~CSI_TEST_GEN_MODE_EN;
+		ipu_csi_write(csi, temp, CSI_TST_CTRL);
+	} else {
+		/* Set sensb_mclk div_ratio*/
+		ipu_csi_set_testgen_mclk(csi, pix_clk, ipu_clk);
+
+		temp &= ~(CSI_TEST_GEN_R_MASK | CSI_TEST_GEN_G_MASK |
+			  CSI_TEST_GEN_B_MASK);
+		temp |= CSI_TEST_GEN_MODE_EN;
+		temp |= (r_value << CSI_TEST_GEN_R_SHIFT) |
+			(g_value << CSI_TEST_GEN_G_SHIFT) |
+			(b_value << CSI_TEST_GEN_B_SHIFT);
+		ipu_csi_write(csi, temp, CSI_TST_CTRL);
+	}
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_csi_set_test_generator);
+
+int ipu_csi_set_mipi_datatype(struct ipu_csi *csi, u32 vc,
+			      struct ipu_csi_signal_cfg *cfg)
+{
+	unsigned long flags;
+	u32 temp;
+
+	if (vc > 3)
+		return -EINVAL;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	temp = ipu_csi_read(csi, CSI_MIPI_DI);
+	temp &= ~(0xff << (vc * 8));
+	temp |= (cfg->mipi_dt << (vc * 8));
+	ipu_csi_write(csi, temp, CSI_MIPI_DI);
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_set_mipi_datatype);
+
+int ipu_csi_set_skip_smfc(struct ipu_csi *csi, u32 skip,
+			  u32 max_ratio, u32 id)
+{
+	unsigned long flags;
+	u32 temp;
+
+	if (max_ratio > 5 || id > 3)
+		return -EINVAL;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	temp = ipu_csi_read(csi, CSI_SKIP);
+	temp &= ~(CSI_MAX_RATIO_SKIP_SMFC_MASK | CSI_ID_2_SKIP_MASK |
+		  CSI_SKIP_SMFC_MASK);
+	temp |= (max_ratio << CSI_MAX_RATIO_SKIP_SMFC_SHIFT) |
+		(id << CSI_ID_2_SKIP_SHIFT) |
+		(skip << CSI_SKIP_SMFC_SHIFT);
+	ipu_csi_write(csi, temp, CSI_SKIP);
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_set_skip_smfc);
+
+int ipu_csi_set_dest(struct ipu_csi *csi, bool ic)
+{
+	unsigned long flags;
+	u32 csi_sens_conf, csi_dest;
+
+	csi_dest = ic ? CSI_DATA_DEST_IC : CSI_DATA_DEST_IDMAC;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	csi_sens_conf = ipu_csi_read(csi, CSI_SENS_CONF);
+	csi_sens_conf &= ~CSI_SENS_CONF_DATA_DEST_MASK;
+	csi_sens_conf |= (csi_dest << CSI_SENS_CONF_DATA_DEST_SHIFT);
+	ipu_csi_write(csi, csi_sens_conf, CSI_SENS_CONF);
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_set_dest);
+
+int ipu_csi_enable(struct ipu_csi *csi)
+{
+	ipu_module_enable(csi->ipu, csi->module);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_enable);
+
+int ipu_csi_disable(struct ipu_csi *csi)
+{
+	ipu_module_disable(csi->ipu, csi->module);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_disable);
+
+struct ipu_csi *ipu_csi_get(struct ipu_soc *ipu, int id)
+{
+	unsigned long flags;
+	struct ipu_csi *csi, *ret;
+
+	if (id > 1)
+		return ERR_PTR(-EINVAL);
+
+	csi = ipu->csi_priv[id];
+	ret = csi;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	if (csi->inuse) {
+		ret = ERR_PTR(-EBUSY);
+		goto unlock;
+	}
+
+	csi->inuse = true;
+unlock:
+	spin_unlock_irqrestore(&csi->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipu_csi_get);
+
+void ipu_csi_put(struct ipu_csi *csi)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&csi->lock, flags);
+	csi->inuse = false;
+	spin_unlock_irqrestore(&csi->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_csi_put);
+
+int ipu_csi_init(struct ipu_soc *ipu, struct device *dev, int id,
+		 unsigned long base, u32 module, struct clk *clk_ipu)
+{
+	struct ipu_csi *csi;
+
+	if (id > 1)
+		return -ENODEV;
+
+	csi = devm_kzalloc(dev, sizeof(*csi), GFP_KERNEL);
+	if (!csi)
+		return -ENOMEM;
+
+	ipu->csi_priv[id] = csi;
+
+	spin_lock_init(&csi->lock);
+	csi->module = module;
+	csi->id = id;
+	csi->clk_ipu = clk_ipu;
+	csi->base = devm_ioremap(dev, base, PAGE_SIZE);
+	if (!csi->base)
+		return -ENOMEM;
+
+	dev_dbg(dev, "CSI%d base: 0x%08lx remapped to %p\n",
+		id, base, csi->base);
+	csi->ipu = ipu;
+
+	return 0;
+}
+
+void ipu_csi_exit(struct ipu_soc *ipu, int id)
+{
+}
+
+void ipu_csi_dump(struct ipu_csi *csi)
+{
+	dev_dbg(csi->ipu->dev, "CSI_SENS_CONF:     %08x\n",
+		ipu_csi_read(csi, CSI_SENS_CONF));
+	dev_dbg(csi->ipu->dev, "CSI_SENS_FRM_SIZE: %08x\n",
+		ipu_csi_read(csi, CSI_SENS_FRM_SIZE));
+	dev_dbg(csi->ipu->dev, "CSI_ACT_FRM_SIZE:  %08x\n",
+		ipu_csi_read(csi, CSI_ACT_FRM_SIZE));
+	dev_dbg(csi->ipu->dev, "CSI_OUT_FRM_CTRL:  %08x\n",
+		ipu_csi_read(csi, CSI_OUT_FRM_CTRL));
+	dev_dbg(csi->ipu->dev, "CSI_TST_CTRL:      %08x\n",
+		ipu_csi_read(csi, CSI_TST_CTRL));
+	dev_dbg(csi->ipu->dev, "CSI_CCIR_CODE_1:   %08x\n",
+		ipu_csi_read(csi, CSI_CCIR_CODE_1));
+	dev_dbg(csi->ipu->dev, "CSI_CCIR_CODE_2:   %08x\n",
+		ipu_csi_read(csi, CSI_CCIR_CODE_2));
+	dev_dbg(csi->ipu->dev, "CSI_CCIR_CODE_3:   %08x\n",
+		ipu_csi_read(csi, CSI_CCIR_CODE_3));
+	dev_dbg(csi->ipu->dev, "CSI_MIPI_DI:       %08x\n",
+		ipu_csi_read(csi, CSI_MIPI_DI));
+	dev_dbg(csi->ipu->dev, "CSI_SKIP:          %08x\n",
+		ipu_csi_read(csi, CSI_SKIP));
+}
+EXPORT_SYMBOL_GPL(ipu_csi_dump);
diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
new file mode 100644
index 0000000..2d305a2
--- /dev/null
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -0,0 +1,812 @@
+/*
+ * Copyright (C) 2012-2014 Mentor Graphics Inc.
+ * Copyright 2005-2012 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/spinlock.h>
+#include <linux/bitrev.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include "ipu-prv.h"
+
+/* IC Register Offsets */
+#define IC_CONF                 0x0000
+#define IC_PRP_ENC_RSC          0x0004
+#define IC_PRP_VF_RSC           0x0008
+#define IC_PP_RSC               0x000C
+#define IC_CMBP_1               0x0010
+#define IC_CMBP_2               0x0014
+#define IC_IDMAC_1              0x0018
+#define IC_IDMAC_2              0x001C
+#define IC_IDMAC_3              0x0020
+#define IC_IDMAC_4              0x0024
+
+/* IC Register Fields */
+#define IC_CONF_PRPENC_EN       (1 << 0)
+#define IC_CONF_PRPENC_CSC1     (1 << 1)
+#define IC_CONF_PRPENC_ROT_EN   (1 << 2)
+#define IC_CONF_PRPVF_EN        (1 << 8)
+#define IC_CONF_PRPVF_CSC1      (1 << 9)
+#define IC_CONF_PRPVF_CSC2      (1 << 10)
+#define IC_CONF_PRPVF_CMB       (1 << 11)
+#define IC_CONF_PRPVF_ROT_EN    (1 << 12)
+#define IC_CONF_PP_EN           (1 << 16)
+#define IC_CONF_PP_CSC1         (1 << 17)
+#define IC_CONF_PP_CSC2         (1 << 18)
+#define IC_CONF_PP_CMB          (1 << 19)
+#define IC_CONF_PP_ROT_EN       (1 << 20)
+#define IC_CONF_IC_GLB_LOC_A    (1 << 28)
+#define IC_CONF_KEY_COLOR_EN    (1 << 29)
+#define IC_CONF_RWS_EN          (1 << 30)
+#define IC_CONF_CSI_MEM_WR_EN   (1 << 31)
+
+#define IC_IDMAC_1_CB0_BURST_16         (1 << 0)
+#define IC_IDMAC_1_CB1_BURST_16         (1 << 1)
+#define IC_IDMAC_1_CB2_BURST_16         (1 << 2)
+#define IC_IDMAC_1_CB3_BURST_16         (1 << 3)
+#define IC_IDMAC_1_CB4_BURST_16         (1 << 4)
+#define IC_IDMAC_1_CB5_BURST_16         (1 << 5)
+#define IC_IDMAC_1_CB6_BURST_16         (1 << 6)
+#define IC_IDMAC_1_CB7_BURST_16         (1 << 7)
+#define IC_IDMAC_1_PRPENC_ROT_MASK      (0x7 << 11)
+#define IC_IDMAC_1_PRPENC_ROT_OFFSET    11
+#define IC_IDMAC_1_PRPVF_ROT_MASK       (0x7 << 14)
+#define IC_IDMAC_1_PRPVF_ROT_OFFSET     14
+#define IC_IDMAC_1_PP_ROT_MASK          (0x7 << 17)
+#define IC_IDMAC_1_PP_ROT_OFFSET        17
+#define IC_IDMAC_1_PP_FLIP_RS           (1 << 22)
+#define IC_IDMAC_1_PRPVF_FLIP_RS        (1 << 21)
+#define IC_IDMAC_1_PRPENC_FLIP_RS       (1 << 20)
+
+#define IC_IDMAC_2_PRPENC_HEIGHT_MASK   (0x3ff << 0)
+#define IC_IDMAC_2_PRPENC_HEIGHT_OFFSET 0
+#define IC_IDMAC_2_PRPVF_HEIGHT_MASK    (0x3ff << 10)
+#define IC_IDMAC_2_PRPVF_HEIGHT_OFFSET  10
+#define IC_IDMAC_2_PP_HEIGHT_MASK       (0x3ff << 20)
+#define IC_IDMAC_2_PP_HEIGHT_OFFSET     20
+
+#define IC_IDMAC_3_PRPENC_WIDTH_MASK    (0x3ff << 0)
+#define IC_IDMAC_3_PRPENC_WIDTH_OFFSET  0
+#define IC_IDMAC_3_PRPVF_WIDTH_MASK     (0x3ff << 10)
+#define IC_IDMAC_3_PRPVF_WIDTH_OFFSET   10
+#define IC_IDMAC_3_PP_WIDTH_MASK        (0x3ff << 20)
+#define IC_IDMAC_3_PP_WIDTH_OFFSET      20
+
+struct ic_task_regoffs {
+	u32 rsc;
+	u32 tpmem_csc[2];
+};
+
+struct ic_task_bitfields {
+	u32 ic_conf_en;
+	u32 ic_conf_rot_en;
+	u32 ic_conf_cmb_en;
+	u32 ic_conf_csc1_en;
+	u32 ic_conf_csc2_en;
+	u32 ic_cmb_galpha_bit;
+};
+
+static const struct ic_task_regoffs ic_task_reg[IC_NUM_TASKS] = {
+	[IC_TASK_ENCODER] = {
+		.rsc = IC_PRP_ENC_RSC,
+		.tpmem_csc = {0x2008, 0},
+	},
+	[IC_TASK_VIEWFINDER] = {
+		.rsc = IC_PRP_VF_RSC,
+		.tpmem_csc = {0x4028, 0x4040},
+	},
+	[IC_TASK_POST_PROCESSOR] = {
+		.rsc = IC_PP_RSC,
+		.tpmem_csc = {0x6060, 0x6078},
+	},
+};
+
+static const struct ic_task_bitfields ic_task_bit[IC_NUM_TASKS] = {
+	[IC_TASK_ENCODER] = {
+		.ic_conf_en = IC_CONF_PRPENC_EN,
+		.ic_conf_rot_en = IC_CONF_PRPENC_ROT_EN,
+		.ic_conf_cmb_en = 0,    /* NA */
+		.ic_conf_csc1_en = IC_CONF_PRPENC_CSC1,
+		.ic_conf_csc2_en = 0,   /* NA */
+		.ic_cmb_galpha_bit = 0, /* NA */
+	},
+	[IC_TASK_VIEWFINDER] = {
+		.ic_conf_en = IC_CONF_PRPVF_EN,
+		.ic_conf_rot_en = IC_CONF_PRPVF_ROT_EN,
+		.ic_conf_cmb_en = IC_CONF_PRPVF_CMB,
+		.ic_conf_csc1_en = IC_CONF_PRPVF_CSC1,
+		.ic_conf_csc2_en = IC_CONF_PRPVF_CSC2,
+		.ic_cmb_galpha_bit = 0,
+	},
+	[IC_TASK_POST_PROCESSOR] = {
+		.ic_conf_en = IC_CONF_PP_EN,
+		.ic_conf_rot_en = IC_CONF_PP_ROT_EN,
+		.ic_conf_cmb_en = IC_CONF_PP_CMB,
+		.ic_conf_csc1_en = IC_CONF_PP_CSC1,
+		.ic_conf_csc2_en = IC_CONF_PP_CSC2,
+		.ic_cmb_galpha_bit = 8,
+	},
+};
+
+struct ipu_ic_priv;
+
+struct ipu_ic {
+	enum ipu_ic_task task;
+	const struct ic_task_regoffs *reg;
+	const struct ic_task_bitfields *bit;
+
+	enum ipu_color_space in_cs, g_in_cs;
+	enum ipu_color_space out_cs;
+	bool graphics;
+	bool rotation;
+	bool in_use;
+
+	struct ipu_ic_priv *priv;
+};
+
+struct ipu_ic_priv {
+	void __iomem *base;
+	void __iomem *tpmem_base;
+	spinlock_t lock;
+	struct ipu_soc *ipu;
+	int use_count;
+	struct ipu_ic task[IC_NUM_TASKS];
+};
+
+static inline u32 ipu_ic_read(struct ipu_ic *ic, unsigned offset)
+{
+	return readl(ic->priv->base + offset);
+}
+
+static inline void ipu_ic_write(struct ipu_ic *ic, u32 value,
+				unsigned offset)
+{
+	writel(value, ic->priv->base + offset);
+}
+
+static void init_csc_rgb2ycbcr(u32 __iomem *base)
+{
+	/*
+	 * Y = R *  .299 + G *  .587 + B *  .114;
+	 * U = R * -.169 + G * -.332 + B *  .500 + 128.;
+	 * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
+	 */
+	const u32 coeff[4][3] = {
+		{0x004D, 0x0096, 0x001D},
+		{0x01D5, 0x01AB, 0x0080},
+		{0x0080, 0x0195, 0x01EB},
+		{0x0000, 0x0200, 0x0200},	/* A0, A1, A2 */
+	};
+	u32 param;
+
+	param = (coeff[3][0] << 27) | (coeff[0][0] << 18) |
+		(coeff[1][1] << 9) | coeff[2][2];
+	writel(param, base++);
+
+	/* scale = 1, sat = 0 */
+	param = (coeff[3][0] >> 5) | (1UL << 8);
+	writel(param, base++);
+
+	param = (coeff[3][1] << 27) | (coeff[0][1] << 18) |
+		(coeff[1][0] << 9) | coeff[2][0];
+	writel(param, base++);
+
+	param = (coeff[3][1] >> 5);
+	writel(param, base++);
+
+	param = (coeff[3][2] << 27) | (coeff[0][2] << 18) |
+		(coeff[1][2] << 9) | coeff[2][1];
+	writel(param, base++);
+
+	param = (coeff[3][2] >> 5);
+	writel(param, base++);
+}
+
+static void init_csc_rgb2rgb(u32 __iomem *base)
+{
+	/* transparent RGB->RGB matrix for graphics combining */
+	const u32 coeff[4][3] = {
+		{0x0080, 0x0000, 0x0000},
+		{0x0000, 0x0080, 0x0000},
+		{0x0000, 0x0000, 0x0080},
+		{0x0000, 0x0000, 0x0000},	/* A0, A1, A2 */
+	};
+	u32 param;
+
+	param = (coeff[3][0] << 27) | (coeff[0][0] << 18) |
+		(coeff[1][1] << 9) | coeff[2][2];
+	writel(param, base++);
+
+	/* scale = 2, sat = 0 */
+	param = (coeff[3][0] >> 5) | (2UL << 8);
+	writel(param, base++);
+
+	param = (coeff[3][1] << 27) | (coeff[0][1] << 18) |
+		(coeff[1][0] << 9) | coeff[2][0];
+	writel(param, base++);
+
+	param = (coeff[3][1] >> 5);
+	writel(param, base++);
+
+	param = (coeff[3][2] << 27) | (coeff[0][2] << 18) |
+		(coeff[1][2] << 9) | coeff[2][1];
+	writel(param, base++);
+
+	param = (coeff[3][2] >> 5);
+	writel(param, base++);
+}
+
+static void init_csc_ycbcr2rgb(u32 __iomem *base)
+{
+	/*
+	 * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
+	 * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
+	 * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
+	 */
+	const u32 coeff[4][3] = {
+		{149, 0, 204},
+		{149, 462, 408},
+		{149, 255, 0},
+		{8192 - 446, 266, 8192 - 554},	/* A0, A1, A2 */
+	};
+	u32 param;
+
+	param = (coeff[3][0] << 27) | (coeff[0][0] << 18) |
+		(coeff[1][1] << 9) | coeff[2][2];
+	writel(param, base++);
+
+	/* scale = 2, sat = 0 */
+	param = (coeff[3][0] >> 5) | (2L << (40 - 32));
+	writel(param, base++);
+
+	param = (coeff[3][1] << 27) | (coeff[0][1] << 18) |
+		(coeff[1][0] << 9) | coeff[2][0];
+	writel(param, base++);
+
+	param = (coeff[3][1] >> 5);
+	writel(param, base++);
+
+	param = (coeff[3][2] << 27) | (coeff[0][2] << 18) |
+		(coeff[1][2] << 9) | coeff[2][1];
+	writel(param, base++);
+
+	param = (coeff[3][2] >> 5);
+	writel(param, base++);
+}
+
+static int init_csc(struct ipu_ic *ic,
+		    enum ipu_color_space inf,
+		    enum ipu_color_space outf,
+		    int csc_index)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	u32 __iomem *base;
+
+	base = (u32 __iomem *)
+		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
+
+	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
+		init_csc_ycbcr2rgb(base);
+	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
+		init_csc_rgb2ycbcr(base);
+	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
+		init_csc_rgb2rgb(base);
+	else {
+		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int calc_resize_coeffs(struct ipu_ic *ic,
+			      u32 in_size, u32 out_size,
+			      u32 *resize_coeff,
+			      u32 *downsize_coeff)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	struct ipu_soc *ipu = priv->ipu;
+	u32 temp_size, temp_downsize;
+
+	/*
+	 * Input size cannot be more than 4096, and output size cannot
+	 * be more than 1024
+	 */
+	if (in_size > 4096) {
+		dev_err(ipu->dev, "Unsupported resize (in_size > 4096)\n");
+		return -EINVAL;
+	}
+	if (out_size > 1024) {
+		dev_err(ipu->dev, "Unsupported resize (out_size > 1024)\n");
+		return -EINVAL;
+	}
+
+	/* Cannot downsize more than 8:1 */
+	if ((out_size << 3) < in_size) {
+		dev_err(ipu->dev, "Unsupported downsize\n");
+		return -EINVAL;
+	}
+
+	/* Compute downsizing coefficient */
+	temp_downsize = 0;
+	temp_size = in_size;
+	while (((temp_size > 1024) || (temp_size >= out_size * 2)) &&
+	       (temp_downsize < 2)) {
+		temp_size >>= 1;
+		temp_downsize++;
+	}
+	*downsize_coeff = temp_downsize;
+
+	/*
+	 * compute resizing coefficient using the following equation:
+	 * resize_coeff = M * (SI - 1) / (SO - 1)
+	 * where M = 2^13, SI = input size, SO = output size
+	 */
+	*resize_coeff = (8192L * (temp_size - 1)) / (out_size - 1);
+	if (*resize_coeff >= 16384L) {
+		dev_err(ipu->dev, "Warning! Overflow on resize coeff.\n");
+		*resize_coeff = 0x3FFF;
+	}
+
+	return 0;
+}
+
+void ipu_ic_task_enable(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	unsigned long flags;
+	u32 ic_conf;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ic_conf = ipu_ic_read(ic, IC_CONF);
+
+	ic_conf |= ic->bit->ic_conf_en;
+
+	if (ic->rotation)
+		ic_conf |= ic->bit->ic_conf_rot_en;
+
+	if (ic->in_cs != ic->out_cs)
+		ic_conf |= ic->bit->ic_conf_csc1_en;
+
+	if (ic->graphics) {
+		ic_conf |= ic->bit->ic_conf_cmb_en;
+		ic_conf |= ic->bit->ic_conf_csc1_en;
+
+		if (ic->g_in_cs != ic->out_cs)
+			ic_conf |= ic->bit->ic_conf_csc2_en;
+	}
+
+	ipu_ic_write(ic, ic_conf, IC_CONF);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_ic_task_enable);
+
+void ipu_ic_task_disable(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	unsigned long flags;
+	u32 ic_conf;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ic_conf = ipu_ic_read(ic, IC_CONF);
+
+	ic_conf &= ~(ic->bit->ic_conf_en |
+		     ic->bit->ic_conf_csc1_en |
+		     ic->bit->ic_conf_rot_en);
+	if (ic->bit->ic_conf_csc2_en)
+		ic_conf &= ~ic->bit->ic_conf_csc2_en;
+	if (ic->bit->ic_conf_cmb_en)
+		ic_conf &= ~ic->bit->ic_conf_cmb_en;
+
+	ipu_ic_write(ic, ic_conf, IC_CONF);
+
+	ic->rotation = ic->graphics = false;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_ic_task_disable);
+
+int ipu_ic_task_graphics_init(struct ipu_ic *ic,
+			      enum ipu_color_space in_g_cs,
+			      bool galpha_en, u32 galpha,
+			      bool colorkey_en, u32 colorkey)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	unsigned long flags;
+	u32 reg, ic_conf;
+	int ret = 0;
+
+	if (ic->task == IC_TASK_ENCODER)
+		return -EINVAL;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ic_conf = ipu_ic_read(ic, IC_CONF);
+
+	if (!(ic_conf & ic->bit->ic_conf_csc1_en)) {
+		/* need transparent CSC1 conversion */
+		ret = init_csc(ic, IPUV3_COLORSPACE_RGB,
+			       IPUV3_COLORSPACE_RGB, 0);
+		if (ret)
+			goto unlock;
+	}
+
+	ic->g_in_cs = in_g_cs;
+
+	if (ic->g_in_cs != ic->out_cs) {
+		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, 1);
+		if (ret)
+			goto unlock;
+	}
+
+	if (galpha_en) {
+		ic_conf |= IC_CONF_IC_GLB_LOC_A;
+		reg = ipu_ic_read(ic, IC_CMBP_1);
+		reg &= ~(0xff << ic->bit->ic_cmb_galpha_bit);
+		reg |= (galpha << ic->bit->ic_cmb_galpha_bit);
+		ipu_ic_write(ic, reg, IC_CMBP_1);
+	} else
+		ic_conf &= ~IC_CONF_IC_GLB_LOC_A;
+
+	if (colorkey_en) {
+		ic_conf |= IC_CONF_KEY_COLOR_EN;
+		ipu_ic_write(ic, colorkey, IC_CMBP_2);
+	} else
+		ic_conf &= ~IC_CONF_KEY_COLOR_EN;
+
+	ipu_ic_write(ic, ic_conf, IC_CONF);
+
+	ic->graphics = true;
+unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipu_ic_task_graphics_init);
+
+int ipu_ic_task_init(struct ipu_ic *ic,
+		     int in_width, int in_height,
+		     int out_width, int out_height,
+		     enum ipu_color_space in_cs,
+		     enum ipu_color_space out_cs)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	u32 reg, downsize_coeff, resize_coeff;
+	unsigned long flags;
+	int ret = 0;
+
+	/* Setup vertical resizing */
+	ret = calc_resize_coeffs(ic, in_height, out_height,
+				 &resize_coeff, &downsize_coeff);
+	if (ret)
+		return ret;
+
+	reg = (downsize_coeff << 30) | (resize_coeff << 16);
+
+	/* Setup horizontal resizing */
+	ret = calc_resize_coeffs(ic, in_width, out_width,
+				 &resize_coeff, &downsize_coeff);
+	if (ret)
+		return ret;
+
+	reg |= (downsize_coeff << 14) | resize_coeff;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ipu_ic_write(ic, reg, ic->reg->rsc);
+
+	/* Setup color space conversion */
+	ic->in_cs = in_cs;
+	ic->out_cs = out_cs;
+
+	if (ic->in_cs != ic->out_cs) {
+		ret = init_csc(ic, ic->in_cs, ic->out_cs, 0);
+		if (ret)
+			goto unlock;
+	}
+
+unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipu_ic_task_init);
+
+int ipu_ic_task_idma_init(struct ipu_ic *ic, struct ipuv3_channel *channel,
+			  u32 width, u32 height, int burst_size,
+			  enum ipu_rotate_mode rot)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	struct ipu_soc *ipu = priv->ipu;
+	u32 ic_idmac_1, ic_idmac_2, ic_idmac_3;
+	u32 temp_rot = bitrev8(rot) >> 5;
+	bool need_hor_flip = false;
+	unsigned long flags;
+	int ret = 0;
+
+	if ((burst_size != 8) && (burst_size != 16)) {
+		dev_err(ipu->dev, "Illegal burst length for IC\n");
+		return -EINVAL;
+	}
+
+	width--;
+	height--;
+
+	if (temp_rot & 0x2)	/* Need horizontal flip */
+		need_hor_flip = true;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ic_idmac_1 = ipu_ic_read(ic, IC_IDMAC_1);
+	ic_idmac_2 = ipu_ic_read(ic, IC_IDMAC_2);
+	ic_idmac_3 = ipu_ic_read(ic, IC_IDMAC_3);
+
+	switch (channel->num) {
+	case IPUV3_CHANNEL_IC_PP_MEM:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB2_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB2_BURST_16;
+
+		if (need_hor_flip)
+			ic_idmac_1 |= IC_IDMAC_1_PP_FLIP_RS;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_PP_FLIP_RS;
+
+		ic_idmac_2 &= ~IC_IDMAC_2_PP_HEIGHT_MASK;
+		ic_idmac_2 |= height << IC_IDMAC_2_PP_HEIGHT_OFFSET;
+
+		ic_idmac_3 &= ~IC_IDMAC_3_PP_WIDTH_MASK;
+		ic_idmac_3 |= width << IC_IDMAC_3_PP_WIDTH_OFFSET;
+		break;
+	case IPUV3_CHANNEL_MEM_IC_PP:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB5_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB5_BURST_16;
+		break;
+	case IPUV3_CHANNEL_MEM_ROT_PP:
+		ic_idmac_1 &= ~IC_IDMAC_1_PP_ROT_MASK;
+		ic_idmac_1 |= temp_rot << IC_IDMAC_1_PP_ROT_OFFSET;
+		break;
+	case IPUV3_CHANNEL_MEM_IC_PRP_VF:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB6_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB6_BURST_16;
+		break;
+	case IPUV3_CHANNEL_IC_PRP_ENC_MEM:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB0_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB0_BURST_16;
+
+		if (need_hor_flip)
+			ic_idmac_1 |= IC_IDMAC_1_PRPENC_FLIP_RS;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_PRPENC_FLIP_RS;
+
+		ic_idmac_2 &= ~IC_IDMAC_2_PRPENC_HEIGHT_MASK;
+		ic_idmac_2 |= height << IC_IDMAC_2_PRPENC_HEIGHT_OFFSET;
+
+		ic_idmac_3 &= ~IC_IDMAC_3_PRPENC_WIDTH_MASK;
+		ic_idmac_3 |= width << IC_IDMAC_3_PRPENC_WIDTH_OFFSET;
+		break;
+	case IPUV3_CHANNEL_MEM_ROT_ENC:
+		ic_idmac_1 &= ~IC_IDMAC_1_PRPENC_ROT_MASK;
+		ic_idmac_1 |= temp_rot << IC_IDMAC_1_PRPENC_ROT_OFFSET;
+		break;
+	case IPUV3_CHANNEL_IC_PRP_VF_MEM:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB1_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB1_BURST_16;
+
+		if (need_hor_flip)
+			ic_idmac_1 |= IC_IDMAC_1_PRPVF_FLIP_RS;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_PRPVF_FLIP_RS;
+
+		ic_idmac_2 &= ~IC_IDMAC_2_PRPVF_HEIGHT_MASK;
+		ic_idmac_2 |= height << IC_IDMAC_2_PRPVF_HEIGHT_OFFSET;
+
+		ic_idmac_3 &= ~IC_IDMAC_3_PRPVF_WIDTH_MASK;
+		ic_idmac_3 |= width << IC_IDMAC_3_PRPVF_WIDTH_OFFSET;
+		break;
+	case IPUV3_CHANNEL_MEM_ROT_VF:
+		ic_idmac_1 &= ~IC_IDMAC_1_PRPVF_ROT_MASK;
+		ic_idmac_1 |= temp_rot << IC_IDMAC_1_PRPVF_ROT_OFFSET;
+		break;
+	case IPUV3_CHANNEL_G_MEM_IC_PRP_VF:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB3_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB3_BURST_16;
+		break;
+	case IPUV3_CHANNEL_G_MEM_IC_PP:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB4_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB4_BURST_16;
+		break;
+	case IPUV3_CHANNEL_VDI_MEM_IC_VF:
+		if (burst_size == 16)
+			ic_idmac_1 |= IC_IDMAC_1_CB7_BURST_16;
+		else
+			ic_idmac_1 &= ~IC_IDMAC_1_CB7_BURST_16;
+		break;
+	default:
+		goto unlock;
+	}
+
+	ipu_ic_write(ic, ic_idmac_1, IC_IDMAC_1);
+	ipu_ic_write(ic, ic_idmac_2, IC_IDMAC_2);
+	ipu_ic_write(ic, ic_idmac_3, IC_IDMAC_3);
+
+	if (rot >= IPU_ROTATE_90_RIGHT)
+		ic->rotation = true;
+
+unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipu_ic_task_idma_init);
+
+int ipu_ic_enable(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	unsigned long flags;
+	u32 module = IPU_CONF_IC_EN;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (ic->rotation)
+		module |= IPU_CONF_ROT_EN;
+
+	if (!priv->use_count)
+		ipu_module_enable(priv->ipu, module);
+
+	priv->use_count++;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_ic_enable);
+
+int ipu_ic_disable(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	unsigned long flags;
+	u32 module = IPU_CONF_IC_EN | IPU_CONF_ROT_EN;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	priv->use_count--;
+
+	if (!priv->use_count)
+		ipu_module_disable(priv->ipu, module);
+
+	if (priv->use_count < 0)
+		priv->use_count = 0;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_ic_disable);
+
+struct ipu_ic *ipu_ic_get(struct ipu_soc *ipu, enum ipu_ic_task task)
+{
+	struct ipu_ic_priv *priv = ipu->ic_priv;
+	unsigned long flags;
+	struct ipu_ic *ic, *ret;
+
+	if (task >= IC_NUM_TASKS)
+		return ERR_PTR(-EINVAL);
+
+	ic = &priv->task[task];
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (ic->in_use) {
+		ret = ERR_PTR(-EBUSY);
+		goto unlock;
+	}
+
+	ic->in_use = true;
+	ret = ic;
+
+unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ipu_ic_get);
+
+void ipu_ic_put(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ic->in_use = false;
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_ic_put);
+
+int ipu_ic_init(struct ipu_soc *ipu, struct device *dev,
+		unsigned long base, unsigned long tpmem_base)
+{
+	struct ipu_ic_priv *priv;
+	int i;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ipu->ic_priv = priv;
+
+	spin_lock_init(&priv->lock);
+	priv->base = devm_ioremap(dev, base, PAGE_SIZE);
+	if (!priv->base)
+		return -ENOMEM;
+	priv->tpmem_base = devm_ioremap(dev, tpmem_base, SZ_64K);
+	if (!priv->tpmem_base)
+		return -ENOMEM;
+
+	dev_dbg(dev, "IC base: 0x%08lx remapped to %p\n", base, priv->base);
+
+	priv->ipu = ipu;
+
+	for (i = 0; i < IC_NUM_TASKS; i++) {
+		priv->task[i].task = i;
+		priv->task[i].priv = priv;
+		priv->task[i].reg = &ic_task_reg[i];
+		priv->task[i].bit = &ic_task_bit[i];
+	}
+
+	return 0;
+}
+
+void ipu_ic_exit(struct ipu_soc *ipu)
+{
+}
+
+void ipu_ic_dump(struct ipu_ic *ic)
+{
+	struct ipu_ic_priv *priv = ic->priv;
+	struct ipu_soc *ipu = priv->ipu;
+
+	dev_dbg(ipu->dev, "IC_CONF = \t0x%08X\n",
+		ipu_ic_read(ic, IC_CONF));
+	dev_dbg(ipu->dev, "IC_PRP_ENC_RSC = \t0x%08X\n",
+		ipu_ic_read(ic, IC_PRP_ENC_RSC));
+	dev_dbg(ipu->dev, "IC_PRP_VF_RSC = \t0x%08X\n",
+		ipu_ic_read(ic, IC_PRP_VF_RSC));
+	dev_dbg(ipu->dev, "IC_PP_RSC = \t0x%08X\n",
+		ipu_ic_read(ic, IC_PP_RSC));
+	dev_dbg(ipu->dev, "IC_CMBP_1 = \t0x%08X\n",
+		ipu_ic_read(ic, IC_CMBP_1));
+	dev_dbg(ipu->dev, "IC_CMBP_2 = \t0x%08X\n",
+		ipu_ic_read(ic, IC_CMBP_2));
+	dev_dbg(ipu->dev, "IC_IDMAC_1 = \t0x%08X\n",
+		ipu_ic_read(ic, IC_IDMAC_1));
+	dev_dbg(ipu->dev, "IC_IDMAC_2 = \t0x%08X\n",
+		ipu_ic_read(ic, IC_IDMAC_2));
+	dev_dbg(ipu->dev, "IC_IDMAC_3 = \t0x%08X\n",
+		ipu_ic_read(ic, IC_IDMAC_3));
+	dev_dbg(ipu->dev, "IC_IDMAC_4 = \t0x%08X\n",
+		ipu_ic_read(ic, IC_IDMAC_4));
+}
+EXPORT_SYMBOL_GPL(ipu_ic_dump);
diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
index 7d8d95b..8e0bc1d 100644
--- a/drivers/gpu/ipu-v3/ipu-prv.h
+++ b/drivers/gpu/ipu-v3/ipu-prv.h
@@ -156,9 +156,11 @@ struct ipuv3_channel {
 	struct ipu_soc *ipu;
 };
 
+struct ipu_csi;
 struct ipu_dc_priv;
 struct ipu_dmfc_priv;
 struct ipu_di;
+struct ipu_ic_priv;
 struct ipu_smfc_priv;
 
 struct ipu_devtype;
@@ -189,6 +191,8 @@ struct ipu_soc {
 	struct ipu_dp_priv	*dp_priv;
 	struct ipu_dmfc_priv	*dmfc_priv;
 	struct ipu_di		*di_priv[2];
+	struct ipu_csi		*csi_priv[2];
+	struct ipu_ic_priv	*ic_priv;
 	struct ipu_smfc_priv	*smfc_priv;
 };
 
@@ -200,6 +204,14 @@ int ipu_module_disable(struct ipu_soc *ipu, u32 mask);
 bool ipu_idmac_channel_busy(struct ipu_soc *ipu, unsigned int chno);
 int ipu_wait_interrupt(struct ipu_soc *ipu, int irq, int ms);
 
+int ipu_csi_init(struct ipu_soc *ipu, struct device *dev, int id,
+		 unsigned long base, u32 module, struct clk *clk_ipu);
+void ipu_csi_exit(struct ipu_soc *ipu, int id);
+
+int ipu_ic_init(struct ipu_soc *ipu, struct device *dev,
+		unsigned long base, unsigned long tpmem_base);
+void ipu_ic_exit(struct ipu_soc *ipu);
+
 int ipu_di_init(struct ipu_soc *ipu, struct device *dev, int id,
 		unsigned long base, u32 module, struct clk *ipu_clk);
 void ipu_di_exit(struct ipu_soc *ipu, int id);
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 52fa277..580a88c 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -61,6 +61,65 @@ struct ipu_di_signal_cfg {
 	u8 vsync_pin;
 };
 
+/*
+ * Bitfield of CSI signal polarities and modes.
+ */
+struct ipu_csi_signal_cfg {
+	unsigned data_width:4;
+	unsigned clk_mode:3;
+	unsigned ext_vsync:1;
+	unsigned vsync_pol:1;
+	unsigned hsync_pol:1;
+	unsigned pixclk_pol:1;
+	unsigned data_pol:1;
+	unsigned sens_clksrc:1;
+	unsigned pack_tight:1;
+	unsigned force_eof:1;
+	unsigned data_en_pol:1;
+
+	unsigned data_fmt;
+	unsigned mipi_dt;
+};
+
+/*
+ * Enumeration of CSI data bus widths.
+ */
+enum ipu_csi_data_width {
+	IPU_CSI_DATA_WIDTH_4   = 0,
+	IPU_CSI_DATA_WIDTH_8   = 1,
+	IPU_CSI_DATA_WIDTH_10  = 3,
+	IPU_CSI_DATA_WIDTH_12  = 5,
+	IPU_CSI_DATA_WIDTH_16  = 9,
+};
+
+/*
+ * Enumeration of CSI clock modes.
+ */
+enum ipu_csi_clk_mode {
+	IPU_CSI_CLK_MODE_GATED_CLK,
+	IPU_CSI_CLK_MODE_NONGATED_CLK,
+	IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE,
+	IPU_CSI_CLK_MODE_CCIR656_INTERLACED,
+	IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR,
+	IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR,
+	IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR,
+	IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR,
+};
+
+/*
+ * Enumeration of IPU rotation modes
+ */
+enum ipu_rotate_mode {
+	IPU_ROTATE_NONE = 0,
+	IPU_ROTATE_VERT_FLIP,
+	IPU_ROTATE_HORIZ_FLIP,
+	IPU_ROTATE_180,
+	IPU_ROTATE_90_RIGHT,
+	IPU_ROTATE_90_RIGHT_VFLIP,
+	IPU_ROTATE_90_RIGHT_HFLIP,
+	IPU_ROTATE_90_LEFT,
+};
+
 enum ipu_color_space {
 	IPUV3_COLORSPACE_RGB,
 	IPUV3_COLORSPACE_YUV,
@@ -176,8 +235,58 @@ int ipu_dp_set_global_alpha(struct ipu_dp *dp, bool enable, u8 alpha,
 /*
  * IPU CMOS Sensor Interface (csi) functions
  */
-int ipu_csi_enable(struct ipu_soc *ipu, int csi);
-int ipu_csi_disable(struct ipu_soc *ipu, int csi);
+struct ipu_csi;
+int ipu_csi_mbus_fmt_to_sig_cfg(struct ipu_csi_signal_cfg *cfg,
+				u32 mbus_code);
+int ipu_csi_init_interface(struct ipu_csi *csi, u16 width, u16 height,
+			   struct ipu_csi_signal_cfg *cfg);
+bool ipu_csi_is_interlaced(struct ipu_csi *csi);
+void ipu_csi_get_window(struct ipu_csi *csi, struct v4l2_rect *w);
+void ipu_csi_set_window(struct ipu_csi *csi, struct v4l2_rect *w);
+void ipu_csi_set_test_generator(struct ipu_csi *csi, bool active,
+				u32 r_value, u32 g_value, u32 b_value,
+				u32 pix_clk);
+int ipu_csi_set_mipi_datatype(struct ipu_csi *csi, u32 vc,
+			      struct ipu_csi_signal_cfg *cfg);
+int ipu_csi_set_skip_smfc(struct ipu_csi *csi, u32 skip,
+			  u32 max_ratio, u32 id);
+int ipu_csi_set_dest(struct ipu_csi *csi, bool ic);
+int ipu_csi_enable(struct ipu_csi *csi);
+int ipu_csi_disable(struct ipu_csi *csi);
+struct ipu_csi *ipu_csi_get(struct ipu_soc *ipu, int id);
+void ipu_csi_put(struct ipu_csi *csi);
+void ipu_csi_dump(struct ipu_csi *csi);
+
+/*
+ * IPU Image Converter (ic) functions
+ */
+enum ipu_ic_task {
+	IC_TASK_ENCODER,
+	IC_TASK_VIEWFINDER,
+	IC_TASK_POST_PROCESSOR,
+	IC_NUM_TASKS,
+};
+
+struct ipu_ic;
+int ipu_ic_task_init(struct ipu_ic *ic,
+		     int in_width, int in_height,
+		     int out_width, int out_height,
+		     enum ipu_color_space in_cs,
+		     enum ipu_color_space out_cs);
+int ipu_ic_task_graphics_init(struct ipu_ic *ic,
+			      enum ipu_color_space in_g_cs,
+			      bool galpha_en, u32 galpha,
+			      bool colorkey_en, u32 colorkey);
+void ipu_ic_task_enable(struct ipu_ic *ic);
+void ipu_ic_task_disable(struct ipu_ic *ic);
+int ipu_ic_task_idma_init(struct ipu_ic *ic, struct ipuv3_channel *channel,
+			  u32 width, u32 height, int burst_size,
+			  enum ipu_rotate_mode rot);
+int ipu_ic_enable(struct ipu_ic *ic);
+int ipu_ic_disable(struct ipu_ic *ic);
+struct ipu_ic *ipu_ic_get(struct ipu_soc *ipu, enum ipu_ic_task task);
+void ipu_ic_put(struct ipu_ic *ic);
+void ipu_ic_dump(struct ipu_ic *ic);
 
 /*
  * IPU Sensor Multiple FIFO Controller (SMFC) functions
-- 
1.7.9.5

