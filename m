Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab1H2PH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 11:07:29 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p7TF7QX3003497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 10:07:28 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
Subject: [PATCH v2 1/8] davinci: vpfe: add dm3xx IPIPEIF hardware support module
Date: Mon, 29 Aug 2011 20:37:12 +0530
Message-ID: <1314630439-1122-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add support for dm3xx IPIPEIF hardware setup. This is the
lowest software layer for the dm3x vpfe driver which directly
accesses hardware. Add support for features like default
pixel correction, dark frame substraction  and hardware setup.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
---
 drivers/media/video/davinci/dm3xx_ipipeif.c |  317 +++++++++++++++++++++++++++
 drivers/media/video/davinci/dm3xx_ipipeif.h |  258 ++++++++++++++++++++++
 include/linux/dm3xx_ipipeif.h               |   64 ++++++
 3 files changed, 639 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
 create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.h
 create mode 100644 include/linux/dm3xx_ipipeif.h

diff --git a/drivers/media/video/davinci/dm3xx_ipipeif.c b/drivers/media/video/davinci/dm3xx_ipipeif.c
new file mode 100644
index 0000000..ebc8895
--- /dev/null
+++ b/drivers/media/video/davinci/dm3xx_ipipeif.c
@@ -0,0 +1,317 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*
+* ipipe module to hold common functionality across DM355 and DM365
+*/
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/v4l2-mediabus.h>
+#include <media/davinci/vpfe.h>
+#include "dm3xx_ipipeif.h"
+
+static void *__iomem ipipeif_base_addr;
+
+static inline u32 regr_if(u32 offset)
+{
+	return readl(ipipeif_base_addr + offset);
+}
+
+static inline void regw_if(u32 val, u32 offset)
+{
+	writel(val, ipipeif_base_addr + offset);
+}
+
+void ipipeif_set_enable(char en, unsigned int mode)
+{
+	regw_if(1, IPIPEIF_ENABLE);
+}
+
+u32 ipipeif_get_enable(void)
+{
+	return regr_if(IPIPEIF_ENABLE);
+}
+
+int ipipeif_set_address(struct ipipeif *params, unsigned int address)
+{
+	u32 val;
+
+	if (params->source == 0)
+		return -EINVAL;
+
+	val = (params->adofs >> 5) & IPIPEIF_ADOFS_LSB_MASK;
+	regw_if(val, IPIPEIF_ADOFS);
+
+	/* lower sixteen bit */
+	val = (address >> IPIPEIF_ADDRL_SHIFT) & IPIPEIF_ADDRL_MASK;
+	regw_if(val, IPIPEIF_ADDRL);
+
+	/* upper next seven bit */
+	val = (address >> IPIPEIF_ADDRU_SHIFT) & IPIPEIF_ADDRU_MASK;
+	regw_if(val, IPIPEIF_ADDRU);
+
+	return 0;
+}
+
+static void ipipeif_config_dpc(struct ipipeif_dpc *dpc)
+{
+	u32 val;
+
+	/* Intialize val*/
+	val = 0;
+
+	if (dpc->en) {
+		val = (dpc->en & 1) << IPIPEIF_DPC2_EN_SHIFT;
+		val |= dpc->thr & IPIPEIF_DPC2_THR_MASK;
+	}
+
+	regw_if(val, IPIPEIF_DPC2);
+}
+
+#define RD_DATA_15_2	0x7
+/* This function sets up IPIPEIF and is called from
+ * ipipe_hw_setup()
+ */
+int ipipeif_hw_setup(struct ipipeif *params, int device_type)
+{
+	enum v4l2_mbus_pixelcode isif_port_if;
+	unsigned int val;
+
+	if (params == NULL)
+		return -EINVAL;
+
+	/* Enable clock to IPIPEIF and IPIPE */
+	if (device_type == DM365)
+		vpss_enable_clock(VPSS_IPIPEIF_CLOCK, 1);
+
+	/* Combine all the fields to make CFG1 register of IPIPEIF */
+	val = params->mode << ONESHOT_SHIFT;
+	val |= params->source << INPSRC_SHIFT;
+	val |= params->clock_select << CLKSEL_SHIFT;
+	val |= params->avg_filter << AVGFILT_SHIFT;
+	val |= params->decimation << DECIM_SHIFT;
+
+	if (device_type == DM355) {
+		val |= params->var.if_base.ialaw << IALAW_SHIFT;
+		val |= params->var.if_base.pack_mode << PACK8IN_SHIFT;
+		val |= params->var.if_base.clk_div << CLKDIV_SHIFT;
+		val |= params->var.if_base.data_shift << DATASFT_SHIFT;
+	} else {
+		/* DM365 IPIPE 5.1 */
+		val |= params->var.if_5_1.pack_mode << PACK8IN_SHIFT;
+		val |= params->var.if_5_1.source1 << INPSRC1_SHIFT;
+		if (params->source != IPIPEIF_SDRAM_YUV)
+			val |= params->var.if_5_1.data_shift << DATASFT_SHIFT;
+		else
+			val &= ~(RD_DATA_15_2 << DATASFT_SHIFT);
+	}
+	regw_if(val, IPIPEIF_CFG1);
+
+	switch (params->source) {
+	case IPIPEIF_CCDC:
+		regw_if(params->gain, IPIPEIF_GAIN);
+		break;
+	case IPIPEIF_SDRAM_RAW:
+	case IPIPEIF_CCDC_DARKFM:
+		regw_if(params->gain, IPIPEIF_GAIN);
+		/* fall through */
+	case IPIPEIF_SDRAM_YUV:
+		val |= params->var.if_5_1.data_shift << DATASFT_SHIFT;
+		regw_if(params->glob_hor_size, IPIPEIF_PPLN);
+		regw_if(params->glob_ver_size, IPIPEIF_LPFR);
+		regw_if(params->hnum, IPIPEIF_HNUM);
+		regw_if(params->vnum, IPIPEIF_VNUM);
+		break;
+	default:
+		/* Do nothing */
+		return -EINVAL;
+	}
+
+	/*check if decimation is enable or not */
+	if (params->decimation)
+		regw_if(params->rsz, IPIPEIF_RSZ);
+
+	if (device_type != DM365)
+		return 0;
+
+	/* Setup sync alignment and initial rsz position */
+	val = params->var.if_5_1.align_sync & 1;
+	val <<= IPIPEIF_INIRSZ_ALNSYNC_SHIFT;
+	val |= params->var.if_5_1.rsz_start & IPIPEIF_INIRSZ_MASK;
+	regw_if(val, IPIPEIF_INIRSZ);
+
+	/* Enable DPCM decompression */
+	switch (params->source) {
+	case IPIPEIF_SDRAM_RAW:
+		val = 0;
+		if (params->var.if_5_1.dpcm.en) {
+			val = params->var.if_5_1.dpcm.en & 1;
+			val |= (params->var.if_5_1.dpcm.type & 1) <<
+				IPIPEIF_DPCM_BITS_SHIFT;
+			val |= (params->var.if_5_1.dpcm.pred & 1) <<
+				IPIPEIF_DPCM_PRED_SHIFT;
+		}
+		regw_if(val, IPIPEIF_DPCM);
+
+		/* set DPC */
+		ipipeif_config_dpc(&params->var.if_5_1.dpc);
+
+		regw_if(params->var.if_5_1.clip, IPIPEIF_OCLIP);
+		/* fall through for SDRAM YUV mode */
+		isif_port_if = params->var.if_5_1.isif_port.if_type;
+		/* configure CFG2 */
+		val = regr_if(IPIPEIF_CFG2);
+		switch (isif_port_if) {
+		case V4L2_MBUS_FMT_YUYV8_1X16:
+			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			regw_if(val, IPIPEIF_CFG2);
+			break;
+		default:
+			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			RESETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			regw_if(val, IPIPEIF_CFG2);
+			break;
+		}
+		break;
+	case IPIPEIF_SDRAM_YUV:
+		/* Set clock divider */
+		if (params->clock_select == IPIPEIF_SDRAM_CLK) {
+			val = regr_if(IPIPEIF_CLKDIV);
+			val |= (params->var.if_5_1.clk_div.m - 1) <<
+				IPIPEIF_CLKDIV_M_SHIFT;
+			val |= (params->var.if_5_1.clk_div.n - 1);
+			regw_if(val, IPIPEIF_CLKDIV);
+		}
+		break;
+	case IPIPEIF_CCDC:
+	case IPIPEIF_CCDC_DARKFM:
+		/* set DPC */
+		ipipeif_config_dpc(&params->var.if_5_1.dpc);
+
+		/* Set DF gain & threshold control */
+		val = 0;
+		if (params->var.if_5_1.df_gain_en) {
+			val = params->var.if_5_1.df_gain_thr &
+				IPIPEIF_DF_GAIN_THR_MASK;
+			regw_if(val, IPIPEIF_DFSGTH);
+			val = (params->var.if_5_1.df_gain_en & 1) <<
+				IPIPEIF_DF_GAIN_EN_SHIFT;
+			val |= params->var.if_5_1.df_gain &
+				IPIPEIF_DF_GAIN_MASK;
+		}
+		regw_if(val, IPIPEIF_DFSGVL);
+		isif_port_if = params->var.if_5_1.isif_port.if_type;
+
+		/* configure CFG2 */
+		val = params->var.if_5_1.isif_port.hdpol <<
+			IPIPEIF_CFG2_HDPOL_SHIFT;
+		val |= params->var.if_5_1.isif_port.vdpol <<
+			IPIPEIF_CFG2_VDPOL_SHIFT;
+
+		switch (isif_port_if) {
+		case V4L2_MBUS_FMT_YUYV8_1X16:
+		case V4L2_MBUS_FMT_YUYV10_1X20:
+			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			break;
+		case V4L2_MBUS_FMT_YUYV8_2X8:
+		case V4L2_MBUS_FMT_Y8_1X8:
+		case V4L2_MBUS_FMT_YUYV10_2X10:
+			SETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			val |= params->var.if_5_1.pix_order <<
+				IPIPEIF_CFG2_YUV8P_SHIFT;
+			break;
+		default:
+			/* Bayer */
+			regw_if(params->var.if_5_1.clip,
+				IPIPEIF_OCLIP);
+			RESETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+		}
+		regw_if(val, IPIPEIF_CFG2);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __devinit dm3xx_ipipeif_probe(struct platform_device *pdev)
+{
+	static resource_size_t  res_len;
+	struct resource *res;
+	int status;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+
+	res_len = res->end - res->start + 1;
+
+	res = request_mem_region(res->start, res_len, res->name);
+	if (!res)
+		return -EBUSY;
+
+	ipipeif_base_addr = ioremap_nocache(res->start, res_len);
+	if (!ipipeif_base_addr) {
+		status = -EBUSY;
+		goto fail;
+	}
+	return 0;
+
+fail:
+	release_mem_region(res->start, res_len);
+
+	return status;
+}
+
+static int dm3xx_ipipeif_remove(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	iounmap(ipipeif_base_addr);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res)
+		release_mem_region(res->start, res->end - res->start + 1);
+	return 0;
+}
+
+static struct platform_driver dm3xx_ipipeif_driver = {
+	.driver = {
+		.name   = "dm3xx_ipipeif",
+		.owner = THIS_MODULE,
+	},
+	.remove = __devexit_p(dm3xx_ipipeif_remove),
+	.probe = dm3xx_ipipeif_probe,
+};
+
+static int dm3xx_ipipeif_init(void)
+{
+	return platform_driver_register(&dm3xx_ipipeif_driver);
+}
+
+static void dm3xx_ipipeif_exit(void)
+{
+	platform_driver_unregister(&dm3xx_ipipeif_driver);
+}
+
+module_init(dm3xx_ipipeif_init);
+module_exit(dm3xx_ipipeif_exit);
+
+MODULE_LICENSE("GPL2");
diff --git a/drivers/media/video/davinci/dm3xx_ipipeif.h b/drivers/media/video/davinci/dm3xx_ipipeif.h
new file mode 100644
index 0000000..f3289f0
--- /dev/null
+++ b/drivers/media/video/davinci/dm3xx_ipipeif.h
@@ -0,0 +1,258 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#ifndef _DM3XX_IPIPEIF_H
+#define _DM3XX_IPIPEIF_H
+
+#ifdef __KERNEL__
+#include <linux/kernel.h>
+#include <linux/dm3xx_ipipeif.h>
+#include <mach/hardware.h>
+#include <linux/io.h>
+#include "vpss.h"
+
+/* Used to shift input image data based on the data lines connected
+ * to parallel port
+ */
+/* IPIPE base specific types */
+enum ipipeif_data_shift {
+	IPIPEIF_BITS15_2,
+	IPIPEIF_BITS14_1,
+	IPIPEIF_BITS13_0,
+	IPIPEIF_BITS12_0,
+	IPIPEIF_BITS11_0,
+	IPIPEIF_BITS10_0,
+	IPIPEIF_BITS9_0
+};
+
+enum ipipeif_clkdiv {
+	IPIPEIF_DIVIDE_HALF,
+	IPIPEIF_DIVIDE_THIRD,
+	IPIPEIF_DIVIDE_FOURTH,
+	IPIPEIF_DIVIDE_FIFTH,
+	IPIPEIF_DIVIDE_SIXTH,
+	IPIPEIF_DIVIDE_EIGHTH,
+	IPIPEIF_DIVIDE_SIXTEENTH,
+	IPIPEIF_DIVIDE_THIRTY
+};
+
+enum ipipeif_clock {
+	IPIPEIF_PIXCEL_CLK,
+	IPIPEIF_SDRAM_CLK
+};
+
+enum ipipeif_pack_mode  {
+	IPIPEIF_PACK_16_BIT,
+	IPIPEIF_PACK_8_BIT
+};
+
+enum ipipe_oper_mode {
+	IPIPEIF_CONTINUOUS,
+	IPIPEIF_ONE_SHOT
+};
+
+enum ipipeif_5_1_pack_mode  {
+	IPIPEIF_5_1_PACK_16_BIT,
+	IPIPEIF_5_1_PACK_8_BIT,
+	IPIPEIF_5_1_PACK_8_BIT_A_LAW,
+	IPIPEIF_5_1_PACK_12_BIT
+};
+
+enum  ipipeif_avg_filter {
+	IPIPEIF_AVG_OFF,
+	IPIPEIF_AVG_ON
+};
+
+enum  ipipeif_input_source {
+	IPIPEIF_CCDC,
+	IPIPEIF_SDRAM_RAW,
+	IPIPEIF_CCDC_DARKFM,
+	IPIPEIF_SDRAM_YUV
+};
+
+enum ipipeif_ialaw {
+	IPIPEIF_ALAW_OFF,
+	IPIPEIF_ALAW_ON
+};
+
+struct ipipeif_base {
+	enum ipipeif_ialaw ialaw;
+	enum ipipeif_pack_mode pack_mode;
+	enum ipipeif_data_shift data_shift;
+	enum ipipeif_clkdiv clk_div;
+};
+
+enum  ipipeif_input_src1 {
+	IPIPEIF_SRC1_PARALLEL_PORT,
+	IPIPEIF_SRC1_SDRAM_RAW,
+	IPIPEIF_SRC1_ISIF_DARKFM,
+	IPIPEIF_SRC1_SDRAM_YUV
+};
+
+enum ipipeif_dpcm_type {
+	IPIPEIF_DPCM_8BIT_10BIT,
+	IPIPEIF_DPCM_8BIT_12BIT
+};
+
+struct ipipeif_dpcm_decomp {
+	unsigned char en;
+	enum ipipeif_dpcm_type type;
+	enum ipipeif_dpcm_pred pred;
+};
+
+enum ipipeif_dfs_dir {
+	IPIPEIF_PORT_MINUS_SDRAM,
+	IPIPEIF_SDRAM_MINUS_PORT
+};
+
+struct ipipeif_5_1 {
+	enum ipipeif_5_1_pack_mode pack_mode;
+	enum ipipeif_5_1_data_shift data_shift;
+	enum ipipeif_input_src1 source1;
+	struct ipipeif_5_1_clkdiv clk_div;
+	/* Defect pixel correction */
+	struct ipipeif_dpc dpc;
+	/* DPCM decompression */
+	struct ipipeif_dpcm_decomp dpcm;
+	/* ISIF port pixel order */
+	enum ipipeif_pixel_order pix_order;
+	/* interface parameters from isif */
+	struct vpfe_hw_if_param isif_port;
+	/* clipped to this value */
+	unsigned short clip;
+	/* Align HSync and VSync to rsz_start */
+	unsigned char align_sync;
+	/* resizer start position */
+	unsigned int rsz_start;
+	/* DF gain enable */
+	unsigned char df_gain_en;
+	/* DF gain value */
+	unsigned short df_gain;
+	/* DF gain threshold value */
+	unsigned short df_gain_thr;
+};
+
+/* ipipeif structures common to DM350 and DM365 used by ipipeif API */
+struct ipipeif {
+	enum ipipe_oper_mode mode;
+	enum ipipeif_input_source source;
+	enum ipipeif_clock clock_select;
+	unsigned int glob_hor_size;
+	unsigned int glob_ver_size;
+	unsigned int hnum;
+	unsigned int vnum;
+	unsigned int adofs;
+	unsigned char rsz;
+	enum ipipeif_decimation decimation;
+	enum ipipeif_avg_filter avg_filter;
+	unsigned short gain;
+	/* IPIPE 5.1 */
+	union var_part {
+		struct ipipeif_base if_base;
+		struct ipipeif_5_1  if_5_1;
+	} var;
+};
+
+/* IPIPEIF Register Offsets from the base address */
+#define IPIPEIF_ENABLE			(0x00)
+#define IPIPEIF_CFG1			(0x04)
+#define IPIPEIF_PPLN			(0x08)
+#define IPIPEIF_LPFR			(0x0c)
+#define IPIPEIF_HNUM			(0x10)
+#define IPIPEIF_VNUM			(0x14)
+#define IPIPEIF_ADDRU			(0x18)
+#define IPIPEIF_ADDRL			(0x1c)
+#define IPIPEIF_ADOFS			(0x20)
+#define IPIPEIF_RSZ			(0x24)
+#define IPIPEIF_GAIN			(0x28)
+
+/* Below registers are available only on IPIPE 5.1 */
+#define IPIPEIF_DPCM			(0x2c)
+#define IPIPEIF_CFG2			(0x30)
+#define IPIPEIF_INIRSZ			(0x34)
+#define IPIPEIF_OCLIP			(0x38)
+#define IPIPEIF_DTUDF			(0x3c)
+#define IPIPEIF_CLKDIV			(0x40)
+#define IPIPEIF_DPC1			(0x44)
+#define IPIPEIF_DPC2			(0x48)
+#define IPIPEIF_DFSGVL			(0x4c)
+#define IPIPEIF_DFSGTH			(0x50)
+#define IPIPEIF_RSZ3A			(0x54)
+#define IPIPEIF_INIRSZ3A		(0x58)
+#define IPIPEIF_RSZ_MIN			(16)
+#define IPIPEIF_RSZ_MAX			(112)
+#define IPIPEIF_RSZ_CONST		(16)
+#define SETBIT(reg, bit)   (reg = ((reg) | ((0x00000001)<<(bit))))
+#define RESETBIT(reg, bit) (reg = ((reg) & (~(0x00000001<<(bit)))))
+
+#define IPIPEIF_ADOFS_LSB_MASK		(0x1ff)
+#define IPIPEIF_ADOFS_LSB_SHIFT		(5)
+#define IPIPEIF_ADOFS_MSB_MASK		(0x200)
+#define IPIPEIF_ADDRU_MASK		(0x7ff)
+#define IPIPEIF_ADDRL_SHIFT		(5)
+#define IPIPEIF_ADDRL_MASK		(0xffff)
+#define IPIPEIF_ADDRU_SHIFT		(21)
+#define IPIPEIF_ADDRMSB_SHIFT		(31)
+#define IPIPEIF_ADDRMSB_LEFT_SHIFT	(10)
+
+/* CFG1 Masks and shifts */
+#define ONESHOT_SHIFT			(0)
+#define DECIM_SHIFT			(1)
+#define INPSRC_SHIFT			(2)
+#define CLKDIV_SHIFT			(4)
+#define AVGFILT_SHIFT			(7)
+#define PACK8IN_SHIFT			(8)
+#define IALAW_SHIFT			(9)
+#define CLKSEL_SHIFT			(10)
+#define DATASFT_SHIFT			(11)
+#define INPSRC1_SHIFT			(14)
+
+/* DPC2 */
+#define IPIPEIF_DPC2_EN_SHIFT		(12)
+#define IPIPEIF_DPC2_THR_MASK		(0xfff)
+/* Applicable for IPIPE 5.1 */
+#define IPIPEIF_DF_GAIN_EN_SHIFT	(10)
+#define IPIPEIF_DF_GAIN_MASK		(0x3ff)
+#define IPIPEIF_DF_GAIN_THR_MASK	(0xfff)
+/* DPCM */
+#define IPIPEIF_DPCM_BITS_SHIFT		(2)
+#define IPIPEIF_DPCM_PRED_SHIFT		(1)
+/* CFG2 */
+#define IPIPEIF_CFG2_HDPOL_SHIFT	(1)
+#define IPIPEIF_CFG2_VDPOL_SHIFT	(2)
+#define IPIPEIF_CFG2_YUV8_SHIFT		(6)
+#define	IPIPEIF_CFG2_YUV16_SHIFT	(3)
+#define	IPIPEIF_CFG2_YUV8P_SHIFT	(7)
+
+/* INIRSZ */
+#define IPIPEIF_INIRSZ_ALNSYNC_SHIFT	(13)
+#define IPIPEIF_INIRSZ_MASK		(0x1fff)
+
+/* CLKDIV */
+#define IPIPEIF_CLKDIV_M_SHIFT		8
+
+int ipipeif_set_address(struct ipipeif *if_params, unsigned int address);
+void ipipeif_set_enable(char en, unsigned int mode);
+int ipipeif_hw_setup(struct ipipeif *if_params, int device_type);
+u32 ipipeif_get_enable(void);
+
+#define DM355	0
+#define DM365	1
+
+#endif
+
+#endif
diff --git a/include/linux/dm3xx_ipipeif.h b/include/linux/dm3xx_ipipeif.h
new file mode 100644
index 0000000..a63ead5
--- /dev/null
+++ b/include/linux/dm3xx_ipipeif.h
@@ -0,0 +1,64 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#ifndef _DM3XX_IPIPEIF_INCLUDE_H
+#define _DM3XX_IPIPEIF_INCLUDE_H
+
+#include <media/davinci/vpfe.h>
+
+/* IPIPE 5.1 interface types */
+/* dpcm predicator for IPIPE 5.1 */
+enum ipipeif_dpcm_pred {
+	IPIPEIF_DPCM_SIMPLE_PRED,
+	IPIPEIF_DPCM_ADV_PRED
+};
+
+/* clockdiv for IPIPE 5.1 */
+struct ipipeif_5_1_clkdiv {
+	unsigned char m;
+	unsigned char n;
+};
+
+/* data shift for IPIPE 5.1 */
+enum ipipeif_5_1_data_shift {
+	IPIPEIF_5_1_BITS11_0,
+	IPIPEIF_5_1_BITS10_0,
+	IPIPEIF_5_1_BITS9_0,
+	IPIPEIF_5_1_BITS8_0,
+	IPIPEIF_5_1_BITS7_0,
+	IPIPEIF_5_1_BITS15_4,
+};
+
+enum ipipeif_decimation {
+	IPIPEIF_DECIMATION_OFF,
+	IPIPEIF_DECIMATION_ON
+};
+
+/* DPC at the if for IPIPE 5.1 */
+struct ipipeif_dpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* threshold */
+	unsigned short thr;
+};
+
+enum	ipipeif_pixel_order {
+	IPIPEIF_CBCR_Y,
+	IPIPEIF_Y_CBCR
+};
+
+#endif
-- 
1.6.2.4

