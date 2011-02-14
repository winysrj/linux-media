Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab1BNMVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 07/10] omap3isp: CCP2/CSI2 receivers
Date: Mon, 14 Feb 2011 13:21:34 +0100
Message-Id: <1297686097-9804-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The OMAP3 ISP CCP2 and CSI2 receivers provide an interface to connect
serial MIPI sensors to the device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: David Cohen <dacohen@gmail.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Antti Koskipaa <akoskipa@gmail.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: RaniSuneela <r-m@ti.com>
Signed-off-by: Atanas Filipov <afilipov@mm-sol.com>
Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
Signed-off-by: Ilkka Myllyperkio <ilkka.myllyperkio@sofica.fi>
Signed-off-by: Pallavi Kulkarni <p-kulkarni@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap3-isp/ispccp2.c   | 1173 +++++++++++++++++++++++++
 drivers/media/video/omap3-isp/ispccp2.h   |   98 +++
 drivers/media/video/omap3-isp/ispcsi2.c   | 1316 +++++++++++++++++++++++++++++
 drivers/media/video/omap3-isp/ispcsi2.h   |  166 ++++
 drivers/media/video/omap3-isp/ispcsiphy.c |  247 ++++++
 drivers/media/video/omap3-isp/ispcsiphy.h |   74 ++
 6 files changed, 3074 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap3-isp/ispccp2.c
 create mode 100644 drivers/media/video/omap3-isp/ispccp2.h
 create mode 100644 drivers/media/video/omap3-isp/ispcsi2.c
 create mode 100644 drivers/media/video/omap3-isp/ispcsi2.h
 create mode 100644 drivers/media/video/omap3-isp/ispcsiphy.c
 create mode 100644 drivers/media/video/omap3-isp/ispcsiphy.h

diff --git a/drivers/media/video/omap3-isp/ispccp2.c b/drivers/media/video/omap3-isp/ispccp2.c
new file mode 100644
index 0000000..0efef2e
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispccp2.c
@@ -0,0 +1,1173 @@
+/*
+ * ispccp2.c
+ *
+ * TI OMAP3 ISP - CCP2 module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2010 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispccp2.h"
+
+/* Number of LCX channels */
+#define CCP2_LCx_CHANS_NUM			3
+/* Max/Min size for CCP2 video port */
+#define ISPCCP2_DAT_START_MIN			0
+#define ISPCCP2_DAT_START_MAX			4095
+#define ISPCCP2_DAT_SIZE_MIN			0
+#define ISPCCP2_DAT_SIZE_MAX			4095
+#define ISPCCP2_VPCLK_FRACDIV			65536
+#define ISPCCP2_LCx_CTRL_FORMAT_RAW8_DPCM10_VP	0x12
+#define ISPCCP2_LCx_CTRL_FORMAT_RAW10_VP	0x16
+/* Max/Min size for CCP2 memory channel */
+#define ISPCCP2_LCM_HSIZE_COUNT_MIN		16
+#define ISPCCP2_LCM_HSIZE_COUNT_MAX		8191
+#define ISPCCP2_LCM_HSIZE_SKIP_MIN		0
+#define ISPCCP2_LCM_HSIZE_SKIP_MAX		8191
+#define ISPCCP2_LCM_VSIZE_MIN			1
+#define ISPCCP2_LCM_VSIZE_MAX			8191
+#define ISPCCP2_LCM_HWORDS_MIN			1
+#define ISPCCP2_LCM_HWORDS_MAX			4095
+#define ISPCCP2_LCM_CTRL_BURST_SIZE_32X		5
+#define ISPCCP2_LCM_CTRL_READ_THROTTLE_FULL	0
+#define ISPCCP2_LCM_CTRL_SRC_DECOMPR_DPCM10	2
+#define ISPCCP2_LCM_CTRL_SRC_FORMAT_RAW8	2
+#define ISPCCP2_LCM_CTRL_SRC_FORMAT_RAW10	3
+#define ISPCCP2_LCM_CTRL_DST_FORMAT_RAW10	3
+#define ISPCCP2_LCM_CTRL_DST_PORT_VP		0
+#define ISPCCP2_LCM_CTRL_DST_PORT_MEM		1
+
+/* Set only the required bits */
+#define BIT_SET(var, shift, mask, val)			\
+	do {						\
+		var = ((var) & ~((mask) << (shift)))	\
+			| ((val) << (shift));		\
+	} while (0)
+
+/*
+ * ccp2_print_status - Print current CCP2 module register values.
+ */
+#define CCP2_PRINT_REGISTER(isp, name)\
+	dev_dbg(isp->dev, "###CCP2 " #name "=0x%08x\n", \
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_##name))
+
+static void ccp2_print_status(struct isp_ccp2_device *ccp2)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+
+	dev_dbg(isp->dev, "-------------CCP2 Register dump-------------\n");
+
+	CCP2_PRINT_REGISTER(isp, SYSCONFIG);
+	CCP2_PRINT_REGISTER(isp, SYSSTATUS);
+	CCP2_PRINT_REGISTER(isp, LC01_IRQENABLE);
+	CCP2_PRINT_REGISTER(isp, LC01_IRQSTATUS);
+	CCP2_PRINT_REGISTER(isp, LC23_IRQENABLE);
+	CCP2_PRINT_REGISTER(isp, LC23_IRQSTATUS);
+	CCP2_PRINT_REGISTER(isp, LCM_IRQENABLE);
+	CCP2_PRINT_REGISTER(isp, LCM_IRQSTATUS);
+	CCP2_PRINT_REGISTER(isp, CTRL);
+	CCP2_PRINT_REGISTER(isp, LCx_CTRL(0));
+	CCP2_PRINT_REGISTER(isp, LCx_CODE(0));
+	CCP2_PRINT_REGISTER(isp, LCx_STAT_START(0));
+	CCP2_PRINT_REGISTER(isp, LCx_STAT_SIZE(0));
+	CCP2_PRINT_REGISTER(isp, LCx_SOF_ADDR(0));
+	CCP2_PRINT_REGISTER(isp, LCx_EOF_ADDR(0));
+	CCP2_PRINT_REGISTER(isp, LCx_DAT_START(0));
+	CCP2_PRINT_REGISTER(isp, LCx_DAT_SIZE(0));
+	CCP2_PRINT_REGISTER(isp, LCx_DAT_PING_ADDR(0));
+	CCP2_PRINT_REGISTER(isp, LCx_DAT_PONG_ADDR(0));
+	CCP2_PRINT_REGISTER(isp, LCx_DAT_OFST(0));
+	CCP2_PRINT_REGISTER(isp, LCM_CTRL);
+	CCP2_PRINT_REGISTER(isp, LCM_VSIZE);
+	CCP2_PRINT_REGISTER(isp, LCM_HSIZE);
+	CCP2_PRINT_REGISTER(isp, LCM_PREFETCH);
+	CCP2_PRINT_REGISTER(isp, LCM_SRC_ADDR);
+	CCP2_PRINT_REGISTER(isp, LCM_SRC_OFST);
+	CCP2_PRINT_REGISTER(isp, LCM_DST_ADDR);
+	CCP2_PRINT_REGISTER(isp, LCM_DST_OFST);
+
+	dev_dbg(isp->dev, "--------------------------------------------\n");
+}
+
+/*
+ * ccp2_reset - Reset the CCP2
+ * @ccp2: pointer to ISP CCP2 device
+ */
+static void ccp2_reset(struct isp_ccp2_device *ccp2)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+	int i = 0;
+
+	/* Reset the CSI1/CCP2B and wait for reset to complete */
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSCONFIG,
+		    ISPCCP2_SYSCONFIG_SOFT_RESET);
+	while (!(isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSSTATUS) &
+		 ISPCCP2_SYSSTATUS_RESET_DONE)) {
+		udelay(10);
+		if (i++ > 10) {  /* try read 10 times */
+			dev_warn(isp->dev,
+				"omap3_isp: timeout waiting for ccp2 reset\n");
+			break;
+		}
+	}
+}
+
+/*
+ * ccp2_pwr_cfg - Configure the power mode settings
+ * @ccp2: pointer to ISP CCP2 device
+ */
+static void ccp2_pwr_cfg(struct isp_ccp2_device *ccp2)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+
+	isp_reg_writel(isp, ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART |
+			((isp->revision == ISP_REVISION_15_0 && isp->autoidle) ?
+			  ISPCCP2_SYSCONFIG_AUTO_IDLE : 0),
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSCONFIG);
+}
+
+/*
+ * ccp2_if_enable - Enable CCP2 interface.
+ * @ccp2: pointer to ISP CCP2 device
+ * @enable: enable/disable flag
+ */
+static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
+	int i;
+
+	/* Enable/Disable all the LCx channels */
+	for (i = 0; i < CCP2_LCx_CHANS_NUM; i++)
+		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(i),
+				ISPCCP2_LCx_CTRL_CHAN_EN,
+				enable ? ISPCCP2_LCx_CTRL_CHAN_EN : 0);
+
+	/* Enable/Disable ccp2 interface in ccp2 mode */
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL,
+			ISPCCP2_CTRL_MODE | ISPCCP2_CTRL_IF_EN,
+			enable ? (ISPCCP2_CTRL_MODE | ISPCCP2_CTRL_IF_EN) : 0);
+
+	/* For frame count propagation */
+	if (pipe->do_propagation) {
+		/* We may want the Frame Start IRQ from LC0 */
+		if (enable)
+			isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2,
+				    ISPCCP2_LC01_IRQENABLE,
+				    ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ);
+		else
+			isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCP2,
+				    ISPCCP2_LC01_IRQENABLE,
+				    ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ);
+	}
+}
+
+/*
+ * ccp2_mem_enable - Enable CCP2 memory interface.
+ * @ccp2: pointer to ISP CCP2 device
+ * @enable: enable/disable flag
+ */
+static void ccp2_mem_enable(struct isp_ccp2_device *ccp2, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+
+	if (enable)
+		ccp2_if_enable(ccp2, 0);
+
+	/* Enable/Disable ccp2 interface in ccp2 mode */
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL,
+			ISPCCP2_CTRL_MODE, enable ? ISPCCP2_CTRL_MODE : 0);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_CTRL,
+			ISPCCP2_LCM_CTRL_CHAN_EN,
+			enable ? ISPCCP2_LCM_CTRL_CHAN_EN : 0);
+}
+
+/*
+ * ccp2_phyif_config - Initialize CCP2 phy interface config
+ * @ccp2: Pointer to ISP CCP2 device
+ * @config: CCP2 platform data
+ *
+ * Configure the CCP2 physical interface module from platform data.
+ *
+ * Returns -EIO if strobe is chosen in CSI1 mode, or 0 on success.
+ */
+static int ccp2_phyif_config(struct isp_ccp2_device *ccp2,
+			     const struct isp_ccp2_platform_data *pdata)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+	u32 val;
+
+	/* CCP2B mode */
+	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL) |
+			    ISPCCP2_CTRL_IO_OUT_SEL | ISPCCP2_CTRL_MODE;
+	/* Data/strobe physical layer */
+	BIT_SET(val, ISPCCP2_CTRL_PHY_SEL_SHIFT, ISPCCP2_CTRL_PHY_SEL_MASK,
+		pdata->phy_layer);
+	BIT_SET(val, ISPCCP2_CTRL_INV_SHIFT, ISPCCP2_CTRL_INV_MASK,
+		pdata->strobe_clk_pol);
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
+
+	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
+	if (!(val & ISPCCP2_CTRL_MODE)) {
+		if (pdata->ccp2_mode)
+			dev_warn(isp->dev, "OMAP3 CCP2 bus not available\n");
+		if (pdata->phy_layer == ISPCCP2_CTRL_PHY_SEL_STROBE)
+			/* Strobe mode requires CCP2 */
+			return -EIO;
+	}
+
+	return 0;
+}
+
+/*
+ * ccp2_vp_config - Initialize CCP2 video port interface.
+ * @ccp2: Pointer to ISP CCP2 device
+ * @vpclk_div: Video port divisor
+ *
+ * Configure the CCP2 video port with the given clock divisor. The valid divisor
+ * values depend on the ISP revision:
+ *
+ * - revision 1.0 and 2.0	1 to 4
+ * - revision 15.0		1 to 65536
+ *
+ * The exact divisor value used might differ from the requested value, as ISP
+ * revision 15.0 represent the divisor by 65536 divided by an integer.
+ */
+static void ccp2_vp_config(struct isp_ccp2_device *ccp2,
+			   unsigned int vpclk_div)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+	u32 val;
+
+	/* ISPCCP2_CTRL Video port */
+	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
+	val |= ISPCCP2_CTRL_VP_ONLY_EN;	/* Disable the memory write port */
+
+	if (isp->revision == ISP_REVISION_15_0) {
+		vpclk_div = clamp_t(unsigned int, vpclk_div, 1, 65536);
+		vpclk_div = min(ISPCCP2_VPCLK_FRACDIV / vpclk_div, 65535U);
+		BIT_SET(val, ISPCCP2_CTRL_VPCLK_DIV_SHIFT,
+			ISPCCP2_CTRL_VPCLK_DIV_MASK, vpclk_div);
+	} else {
+		vpclk_div = clamp_t(unsigned int, vpclk_div, 1, 4);
+		BIT_SET(val, ISPCCP2_CTRL_VP_OUT_CTRL_SHIFT,
+			ISPCCP2_CTRL_VP_OUT_CTRL_MASK, vpclk_div - 1);
+	}
+
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
+}
+
+/*
+ * ccp2_lcx_config - Initialize CCP2 logical channel interface.
+ * @ccp2: Pointer to ISP CCP2 device
+ * @config: Pointer to ISP LCx config structure.
+ *
+ * This will analyze the parameters passed by the interface config
+ * and configure CSI1/CCP2 logical channel
+ *
+ */
+static void ccp2_lcx_config(struct isp_ccp2_device *ccp2,
+			    struct isp_interface_lcx_config *config)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+	u32 val, format;
+
+	switch (config->format) {
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+		format = ISPCCP2_LCx_CTRL_FORMAT_RAW8_DPCM10_VP;
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_1X10:
+	default:
+		format = ISPCCP2_LCx_CTRL_FORMAT_RAW10_VP;	/* RAW10+VP */
+		break;
+	}
+	/* ISPCCP2_LCx_CTRL logical channel #0 */
+	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(0))
+			    | (ISPCCP2_LCx_CTRL_REGION_EN); /* Region */
+
+	if (isp->revision == ISP_REVISION_15_0) {
+		/* CRC */
+		BIT_SET(val, ISPCCP2_LCx_CTRL_CRC_SHIFT_15_0,
+			ISPCCP2_LCx_CTRL_CRC_MASK,
+			config->crc);
+		/* Format = RAW10+VP or RAW8+DPCM10+VP*/
+		BIT_SET(val, ISPCCP2_LCx_CTRL_FORMAT_SHIFT_15_0,
+			ISPCCP2_LCx_CTRL_FORMAT_MASK_15_0, format);
+	} else {
+		BIT_SET(val, ISPCCP2_LCx_CTRL_CRC_SHIFT,
+			ISPCCP2_LCx_CTRL_CRC_MASK,
+			config->crc);
+
+		BIT_SET(val, ISPCCP2_LCx_CTRL_FORMAT_SHIFT,
+			ISPCCP2_LCx_CTRL_FORMAT_MASK, format);
+	}
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(0));
+
+	/* ISPCCP2_DAT_START for logical channel #0 */
+	isp_reg_writel(isp, config->data_start << ISPCCP2_LCx_DAT_SHIFT,
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_DAT_START(0));
+
+	/* ISPCCP2_DAT_SIZE for logical channel #0 */
+	isp_reg_writel(isp, config->data_size << ISPCCP2_LCx_DAT_SHIFT,
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_DAT_SIZE(0));
+
+	/* Enable error IRQs for logical channel #0 */
+	val = ISPCCP2_LC01_IRQSTATUS_LC0_FIFO_OVF_IRQ |
+	      ISPCCP2_LC01_IRQSTATUS_LC0_CRC_IRQ |
+	      ISPCCP2_LC01_IRQSTATUS_LC0_FSP_IRQ |
+	      ISPCCP2_LC01_IRQSTATUS_LC0_FW_IRQ |
+	      ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ |
+	      ISPCCP2_LC01_IRQSTATUS_LC0_FSC_IRQ |
+	      ISPCCP2_LC01_IRQSTATUS_LC0_SSC_IRQ;
+
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LC01_IRQSTATUS);
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LC01_IRQENABLE, val);
+}
+
+/*
+ * ccp2_if_configure - Configure ccp2 with data from sensor
+ * @ccp2: Pointer to ISP CCP2 device
+ *
+ * Return 0 on success or a negative error code
+ */
+static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
+{
+	const struct isp_v4l2_subdevs_group *pdata;
+	struct v4l2_mbus_framefmt *format;
+	struct media_pad *pad;
+	struct v4l2_subdev *sensor;
+	u32 lines = 0;
+	int ret;
+
+	ccp2_pwr_cfg(ccp2);
+
+	pad = media_entity_remote_source(&ccp2->pads[CCP2_PAD_SINK]);
+	sensor = media_entity_to_v4l2_subdev(pad->entity);
+	pdata = sensor->host_priv;
+
+	ret = ccp2_phyif_config(ccp2, &pdata->bus.ccp2);
+	if (ret < 0)
+		return ret;
+
+	ccp2_vp_config(ccp2, pdata->bus.ccp2.vpclk_div + 1);
+
+	v4l2_subdev_call(sensor, sensor, g_skip_top_lines, &lines);
+
+	format = &ccp2->formats[CCP2_PAD_SINK];
+
+	ccp2->if_cfg.data_start = lines;
+	ccp2->if_cfg.crc = pdata->bus.ccp2.crc;
+	ccp2->if_cfg.format = format->code;
+	ccp2->if_cfg.data_size = format->height;
+
+	ccp2_lcx_config(ccp2, &ccp2->if_cfg);
+
+	return 0;
+}
+
+static int ccp2_adjust_bandwidth(struct isp_ccp2_device *ccp2)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
+	struct isp_device *isp = to_isp_device(ccp2);
+	const struct v4l2_mbus_framefmt *ofmt = &ccp2->formats[CCP2_PAD_SOURCE];
+	unsigned long l3_ick = pipe->l3_ick;
+	struct v4l2_fract *timeperframe;
+	unsigned int vpclk_div = 2;
+	unsigned int value;
+	u64 bound;
+	u64 area;
+
+	/* Compute the minimum clock divisor, based on the pipeline maximum
+	 * data rate. This is an absolute lower bound if we don't want SBL
+	 * overflows, so round the value up.
+	 */
+	vpclk_div = max_t(unsigned int, DIV_ROUND_UP(l3_ick, pipe->max_rate),
+			  vpclk_div);
+
+	/* Compute the maximum clock divisor, based on the requested frame rate.
+	 * This is a soft lower bound to achieve a frame rate equal or higher
+	 * than the requested value, so round the value down.
+	 */
+	timeperframe = &pipe->max_timeperframe;
+
+	if (timeperframe->numerator) {
+		area = ofmt->width * ofmt->height;
+		bound = div_u64(area * timeperframe->denominator,
+				timeperframe->numerator);
+		value = min_t(u64, bound, l3_ick);
+		vpclk_div = max_t(unsigned int, l3_ick / value, vpclk_div);
+	}
+
+	dev_dbg(isp->dev, "%s: minimum clock divisor = %u\n", __func__,
+		vpclk_div);
+
+	return vpclk_div;
+}
+
+/*
+ * ccp2_mem_configure - Initialize CCP2 memory input/output interface
+ * @ccp2: Pointer to ISP CCP2 device
+ * @config: Pointer to ISP mem interface config structure
+ *
+ * This will analyze the parameters passed by the interface config
+ * structure, and configure the respective registers for proper
+ * CSI1/CCP2 memory input.
+ */
+static void ccp2_mem_configure(struct isp_ccp2_device *ccp2,
+			       struct isp_interface_mem_config *config)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+	u32 sink_pixcode = ccp2->formats[CCP2_PAD_SINK].code;
+	u32 source_pixcode = ccp2->formats[CCP2_PAD_SOURCE].code;
+	unsigned int dpcm_decompress = 0;
+	u32 val, hwords;
+
+	if (sink_pixcode != source_pixcode &&
+	    sink_pixcode == V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
+		dpcm_decompress = 1;
+
+	ccp2_pwr_cfg(ccp2);
+
+	/* Hsize, Skip */
+	isp_reg_writel(isp, ISPCCP2_LCM_HSIZE_SKIP_MIN |
+		       (config->hsize_count << ISPCCP2_LCM_HSIZE_SHIFT),
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_HSIZE);
+
+	/* Vsize, no. of lines */
+	isp_reg_writel(isp, config->vsize_count << ISPCCP2_LCM_VSIZE_SHIFT,
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_VSIZE);
+
+	if (ccp2->video_in.bpl_padding == 0)
+		config->src_ofst = 0;
+	else
+		config->src_ofst = ccp2->video_in.bpl_value;
+
+	isp_reg_writel(isp, config->src_ofst, OMAP3_ISP_IOMEM_CCP2,
+		       ISPCCP2_LCM_SRC_OFST);
+
+	/* Source and Destination formats */
+	val = ISPCCP2_LCM_CTRL_DST_FORMAT_RAW10 <<
+	      ISPCCP2_LCM_CTRL_DST_FORMAT_SHIFT;
+
+	if (dpcm_decompress) {
+		/* source format is RAW8 */
+		val |= ISPCCP2_LCM_CTRL_SRC_FORMAT_RAW8 <<
+		       ISPCCP2_LCM_CTRL_SRC_FORMAT_SHIFT;
+
+		/* RAW8 + DPCM10 - simple predictor */
+		val |= ISPCCP2_LCM_CTRL_SRC_DPCM_PRED;
+
+		/* enable source DPCM decompression */
+		val |= ISPCCP2_LCM_CTRL_SRC_DECOMPR_DPCM10 <<
+		       ISPCCP2_LCM_CTRL_SRC_DECOMPR_SHIFT;
+	} else {
+		/* source format is RAW10 */
+		val |= ISPCCP2_LCM_CTRL_SRC_FORMAT_RAW10 <<
+		       ISPCCP2_LCM_CTRL_SRC_FORMAT_SHIFT;
+	}
+
+	/* Burst size to 32x64 */
+	val |= ISPCCP2_LCM_CTRL_BURST_SIZE_32X <<
+	       ISPCCP2_LCM_CTRL_BURST_SIZE_SHIFT;
+
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_CTRL);
+
+	/* Prefetch setup */
+	if (dpcm_decompress)
+		hwords = (ISPCCP2_LCM_HSIZE_SKIP_MIN +
+			  config->hsize_count) >> 3;
+	else
+		hwords = (ISPCCP2_LCM_HSIZE_SKIP_MIN +
+			  config->hsize_count) >> 2;
+
+	isp_reg_writel(isp, hwords << ISPCCP2_LCM_PREFETCH_SHIFT,
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_PREFETCH);
+
+	/* Video port */
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL,
+		    ISPCCP2_CTRL_IO_OUT_SEL | ISPCCP2_CTRL_MODE);
+	ccp2_vp_config(ccp2, ccp2_adjust_bandwidth(ccp2));
+
+	/* Clear LCM interrupts */
+	isp_reg_writel(isp, ISPCCP2_LCM_IRQSTATUS_OCPERROR_IRQ |
+		       ISPCCP2_LCM_IRQSTATUS_EOF_IRQ,
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_IRQSTATUS);
+
+	/* Enable LCM interupts */
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_IRQENABLE,
+		    ISPCCP2_LCM_IRQSTATUS_EOF_IRQ |
+		    ISPCCP2_LCM_IRQSTATUS_OCPERROR_IRQ);
+}
+
+/*
+ * ccp2_set_inaddr - Sets memory address of input frame.
+ * @ccp2: Pointer to ISP CCP2 device
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ *
+ * Configures the memory address from which the input frame is to be read.
+ */
+static void ccp2_set_inaddr(struct isp_ccp2_device *ccp2, u32 addr)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+
+	isp_reg_writel(isp, addr, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_SRC_ADDR);
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt handling
+ */
+
+static void ccp2_isr_buffer(struct isp_ccp2_device *ccp2)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
+	struct isp_buffer *buffer;
+
+	buffer = omap3isp_video_buffer_next(&ccp2->video_in, ccp2->error);
+	if (buffer != NULL)
+		ccp2_set_inaddr(ccp2, buffer->isp_addr);
+
+	pipe->state |= ISP_PIPELINE_IDLE_INPUT;
+
+	if (ccp2->state == ISP_PIPELINE_STREAM_SINGLESHOT) {
+		if (isp_pipeline_ready(pipe))
+			omap3isp_pipeline_set_stream(pipe,
+						ISP_PIPELINE_STREAM_SINGLESHOT);
+	}
+
+	ccp2->error = 0;
+}
+
+/*
+ * omap3isp_ccp2_isr - Handle ISP CCP2 interrupts
+ * @ccp2: Pointer to ISP CCP2 device
+ *
+ * This will handle the CCP2 interrupts
+ *
+ * Returns -EIO in case of error, or 0 on success.
+ */
+int omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
+{
+	struct isp_device *isp = to_isp_device(ccp2);
+	int ret = 0;
+	static const u32 ISPCCP2_LC01_ERROR =
+		ISPCCP2_LC01_IRQSTATUS_LC0_FIFO_OVF_IRQ |
+		ISPCCP2_LC01_IRQSTATUS_LC0_CRC_IRQ |
+		ISPCCP2_LC01_IRQSTATUS_LC0_FSP_IRQ |
+		ISPCCP2_LC01_IRQSTATUS_LC0_FW_IRQ |
+		ISPCCP2_LC01_IRQSTATUS_LC0_FSC_IRQ |
+		ISPCCP2_LC01_IRQSTATUS_LC0_SSC_IRQ;
+	u32 lcx_irqstatus, lcm_irqstatus;
+
+	/* First clear the interrupts */
+	lcx_irqstatus = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2,
+				      ISPCCP2_LC01_IRQSTATUS);
+	isp_reg_writel(isp, lcx_irqstatus, OMAP3_ISP_IOMEM_CCP2,
+		       ISPCCP2_LC01_IRQSTATUS);
+
+	lcm_irqstatus = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2,
+				      ISPCCP2_LCM_IRQSTATUS);
+	isp_reg_writel(isp, lcm_irqstatus, OMAP3_ISP_IOMEM_CCP2,
+		       ISPCCP2_LCM_IRQSTATUS);
+	/* Errors */
+	if (lcx_irqstatus & ISPCCP2_LC01_ERROR) {
+		ccp2->error = 1;
+		dev_dbg(isp->dev, "CCP2 err:%x\n", lcx_irqstatus);
+		return -EIO;
+	}
+
+	if (lcm_irqstatus & ISPCCP2_LCM_IRQSTATUS_OCPERROR_IRQ) {
+		ccp2->error = 1;
+		dev_dbg(isp->dev, "CCP2 OCP err:%x\n", lcm_irqstatus);
+		ret = -EIO;
+	}
+
+	if (omap3isp_module_sync_is_stopping(&ccp2->wait, &ccp2->stopping))
+		return 0;
+
+	/* Frame number propagation */
+	if (lcx_irqstatus & ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ) {
+		struct isp_pipeline *pipe =
+			to_isp_pipeline(&ccp2->subdev.entity);
+		if (pipe->do_propagation)
+			atomic_inc(&pipe->frame_number);
+	}
+
+	/* Handle queued buffers on frame end interrupts */
+	if (lcm_irqstatus & ISPCCP2_LCM_IRQSTATUS_EOF_IRQ)
+		ccp2_isr_buffer(ccp2);
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+static const unsigned int ccp2_fmts[] = {
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+};
+
+/*
+ * __ccp2_get_format - helper function for getting ccp2 format
+ * @ccp2  : Pointer to ISP CCP2 device
+ * @fh    : V4L2 subdev file handle
+ * @pad   : pad number
+ * @which : wanted subdev format
+ * return format structure or NULL on error
+ */
+static struct v4l2_mbus_framefmt *
+__ccp2_get_format(struct isp_ccp2_device *ccp2, struct v4l2_subdev_fh *fh,
+		     unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &ccp2->formats[pad];
+}
+
+/*
+ * ccp2_try_format - Handle try format by pad subdev method
+ * @ccp2  : Pointer to ISP CCP2 device
+ * @fh    : V4L2 subdev file handle
+ * @pad   : pad num
+ * @fmt   : pointer to v4l2 mbus format structure
+ * @which : wanted subdev format
+ */
+static void ccp2_try_format(struct isp_ccp2_device *ccp2,
+			       struct v4l2_subdev_fh *fh, unsigned int pad,
+			       struct v4l2_mbus_framefmt *fmt,
+			       enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+
+	switch (pad) {
+	case CCP2_PAD_SINK:
+		if (fmt->code != V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
+			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+		if (ccp2->input == CCP2_INPUT_SENSOR) {
+			fmt->width = clamp_t(u32, fmt->width,
+					     ISPCCP2_DAT_START_MIN,
+					     ISPCCP2_DAT_START_MAX);
+			fmt->height = clamp_t(u32, fmt->height,
+					      ISPCCP2_DAT_SIZE_MIN,
+					      ISPCCP2_DAT_SIZE_MAX);
+		} else if (ccp2->input == CCP2_INPUT_MEMORY) {
+			fmt->width = clamp_t(u32, fmt->width,
+					     ISPCCP2_LCM_HSIZE_COUNT_MIN,
+					     ISPCCP2_LCM_HSIZE_COUNT_MAX);
+			fmt->height = clamp_t(u32, fmt->height,
+					      ISPCCP2_LCM_VSIZE_MIN,
+					      ISPCCP2_LCM_VSIZE_MAX);
+		}
+		break;
+
+	case CCP2_PAD_SOURCE:
+		/* Source format - copy sink format and change pixel code
+		 * to SGRBG10_1X10 as we don't support CCP2 write to memory.
+		 * When CCP2 write to memory feature will be added this
+		 * should be changed properly.
+		 */
+		format = __ccp2_get_format(ccp2, fh, CCP2_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+		fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		break;
+	}
+
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+}
+
+/*
+ * ccp2_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh     : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int ccp2_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	if (code->pad == CCP2_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(ccp2_fmts))
+			return -EINVAL;
+
+		code->code = ccp2_fmts[code->index];
+	} else {
+		if (code->index != 0)
+			return -EINVAL;
+
+		format = __ccp2_get_format(ccp2, fh, CCP2_PAD_SINK,
+					      V4L2_SUBDEV_FORMAT_TRY);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+static int ccp2_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	ccp2_try_format(ccp2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	ccp2_try_format(ccp2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * ccp2_get_format - Handle get format by pads subdev method
+ * @sd    : pointer to v4l2 subdev structure
+ * @fh    : V4L2 subdev file handle
+ * @fmt   : pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on sucess
+ */
+static int ccp2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ccp2_get_format(ccp2, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * ccp2_set_format - Handle set format by pads subdev method
+ * @sd    : pointer to v4l2 subdev structure
+ * @fh    : V4L2 subdev file handle
+ * @fmt   : pointer to v4l2 subdev format structure
+ * returns zero
+ */
+static int ccp2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ccp2_get_format(ccp2, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	ccp2_try_format(ccp2, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == CCP2_PAD_SINK) {
+		format = __ccp2_get_format(ccp2, fh, CCP2_PAD_SOURCE,
+					   fmt->which);
+		*format = fmt->format;
+		ccp2_try_format(ccp2, fh, CCP2_PAD_SOURCE, format, fmt->which);
+	}
+
+	return 0;
+}
+
+/*
+ * ccp2_init_formats - Initialize formats on all pads
+ * @sd: ISP CCP2 V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int ccp2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = CCP2_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	ccp2_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/*
+ * ccp2_s_stream - Enable/Disable streaming on ccp2 subdev
+ * @sd    : pointer to v4l2 subdev structure
+ * @enable: 1 == Enable, 0 == Disable
+ * return zero
+ */
+static int ccp2_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
+	struct isp_device *isp = to_isp_device(ccp2);
+	struct device *dev = to_device(ccp2);
+	int ret;
+
+	if (ccp2->state == ISP_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISP_PIPELINE_STREAM_STOPPED)
+			return 0;
+		atomic_set(&ccp2->stopping, 0);
+		ccp2->error = 0;
+	}
+
+	switch (enable) {
+	case ISP_PIPELINE_STREAM_CONTINUOUS:
+		if (ccp2->phy) {
+			ret = omap3isp_csiphy_acquire(ccp2->phy);
+			if (ret < 0)
+				return ret;
+		}
+
+		ccp2_if_configure(ccp2);
+		ccp2_print_status(ccp2);
+
+		/* Enable CSI1/CCP2 interface */
+		ccp2_if_enable(ccp2, 1);
+		break;
+
+	case ISP_PIPELINE_STREAM_SINGLESHOT:
+		if (ccp2->state != ISP_PIPELINE_STREAM_SINGLESHOT) {
+			struct v4l2_mbus_framefmt *format;
+
+			format = &ccp2->formats[CCP2_PAD_SINK];
+
+			ccp2->mem_cfg.hsize_count = format->width;
+			ccp2->mem_cfg.vsize_count = format->height;
+			ccp2->mem_cfg.src_ofst = 0;
+
+			ccp2_mem_configure(ccp2, &ccp2->mem_cfg);
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CSI1_READ);
+			ccp2_print_status(ccp2);
+		}
+		ccp2_mem_enable(ccp2, 1);
+		break;
+
+	case ISP_PIPELINE_STREAM_STOPPED:
+		if (omap3isp_module_sync_idle(&sd->entity, &ccp2->wait,
+					      &ccp2->stopping))
+			dev_dbg(dev, "%s: module stop timeout.\n", sd->name);
+		if (ccp2->input == CCP2_INPUT_MEMORY) {
+			ccp2_mem_enable(ccp2, 0);
+			omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_CSI1_READ);
+		} else if (ccp2->input == CCP2_INPUT_SENSOR) {
+			/* Disable CSI1/CCP2 interface */
+			ccp2_if_enable(ccp2, 0);
+			if (ccp2->phy)
+				omap3isp_csiphy_release(ccp2->phy);
+		}
+		break;
+	}
+
+	ccp2->state = enable;
+	return 0;
+}
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops ccp2_sd_video_ops = {
+	.s_stream = ccp2_s_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops ccp2_sd_pad_ops = {
+	.enum_mbus_code = ccp2_enum_mbus_code,
+	.enum_frame_size = ccp2_enum_frame_size,
+	.get_fmt = ccp2_get_format,
+	.set_fmt = ccp2_set_format,
+};
+
+/* subdev operations */
+static const struct v4l2_subdev_ops ccp2_sd_ops = {
+	.video = &ccp2_sd_video_ops,
+	.pad = &ccp2_sd_pad_ops,
+};
+
+/* subdev internal operations */
+static const struct v4l2_subdev_internal_ops ccp2_sd_internal_ops = {
+	.open = ccp2_init_formats,
+};
+
+/* --------------------------------------------------------------------------
+ * ISP ccp2 video device node
+ */
+
+/*
+ * ccp2_video_queue - Queue video buffer.
+ * @video : Pointer to isp video structure
+ * @buffer: Pointer to isp_buffer structure
+ * return -EIO or zero on success
+ */
+static int ccp2_video_queue(struct isp_video *video, struct isp_buffer *buffer)
+{
+	struct isp_ccp2_device *ccp2 = &video->isp->isp_ccp2;
+
+	ccp2_set_inaddr(ccp2, buffer->isp_addr);
+	return 0;
+}
+
+static const struct isp_video_operations ccp2_video_ops = {
+	.queue = ccp2_video_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * ccp2_link_setup - Setup ccp2 connections.
+ * @entity : Pointer to media entity structure
+ * @local  : Pointer to local pad array
+ * @remote : Pointer to remote pad array
+ * @flags  : Link flags
+ * return -EINVAL on error or zero on success
+ */
+static int ccp2_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case CCP2_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+		/* read from memory */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ccp2->input == CCP2_INPUT_SENSOR)
+				return -EBUSY;
+			ccp2->input = CCP2_INPUT_MEMORY;
+		} else {
+			if (ccp2->input == CCP2_INPUT_MEMORY)
+				ccp2->input = CCP2_INPUT_NONE;
+		}
+		break;
+
+	case CCP2_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* read from sensor/phy */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ccp2->input == CCP2_INPUT_MEMORY)
+				return -EBUSY;
+			ccp2->input = CCP2_INPUT_SENSOR;
+		} else {
+			if (ccp2->input == CCP2_INPUT_SENSOR)
+				ccp2->input = CCP2_INPUT_NONE;
+		} break;
+
+	case CCP2_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* write to video port/ccdc */
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			ccp2->output = CCP2_OUTPUT_CCDC;
+		else
+			ccp2->output = CCP2_OUTPUT_NONE;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations ccp2_media_ops = {
+	.link_setup = ccp2_link_setup,
+};
+
+/*
+ * ccp2_init_entities - Initialize ccp2 subdev and media entity.
+ * @ccp2: Pointer to ISP CCP2 device
+ * return negative error code or zero on success
+ */
+static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
+{
+	struct v4l2_subdev *sd = &ccp2->subdev;
+	struct media_pad *pads = ccp2->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	ccp2->input = CCP2_INPUT_NONE;
+	ccp2->output = CCP2_OUTPUT_NONE;
+
+	v4l2_subdev_init(sd, &ccp2_sd_ops);
+	sd->internal_ops = &ccp2_sd_internal_ops;
+	strlcpy(sd->name, "OMAP3 ISP CCP2", sizeof(sd->name));
+	sd->grp_id = 1 << 16;   /* group ID for isp subdevs */
+	v4l2_set_subdevdata(sd, ccp2);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[CCP2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[CCP2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+
+	me->ops = &ccp2_media_ops;
+	ret = media_entity_init(me, CCP2_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	ccp2_init_formats(sd, NULL);
+
+	/*
+	 * The CCP2 has weird line alignment requirements, possibly caused by
+	 * DPCM8 decompression. Line length for data read from memory must be a
+	 * multiple of 128 bits (16 bytes) in continuous mode (when no padding
+	 * is present at end of lines). Additionally, if padding is used, the
+	 * padded line length must be a multiple of 32 bytes. To simplify the
+	 * implementation we use a fixed 32 bytes alignment regardless of the
+	 * input format and width. If strict 128 bits alignment support is
+	 * required ispvideo will need to be made aware of this special dual
+	 * alignement requirements.
+	 */
+	ccp2->video_in.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ccp2->video_in.bpl_alignment = 32;
+	ccp2->video_in.bpl_max = 0xffffffe0;
+	ccp2->video_in.isp = to_isp_device(ccp2);
+	ccp2->video_in.ops = &ccp2_video_ops;
+	ccp2->video_in.capture_mem = PAGE_ALIGN(4096 * 4096) * 3;
+
+	ret = omap3isp_video_init(&ccp2->video_in, "CCP2");
+	if (ret < 0)
+		return ret;
+
+	/* Connect the video node to the ccp2 subdev. */
+	ret = media_entity_create_link(&ccp2->video_in.video.entity, 0,
+				       &ccp2->subdev.entity, CCP2_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * omap3isp_ccp2_unregister_entities - Unregister media entities: subdev
+ * @ccp2: Pointer to ISP CCP2 device
+ */
+void omap3isp_ccp2_unregister_entities(struct isp_ccp2_device *ccp2)
+{
+	media_entity_cleanup(&ccp2->subdev.entity);
+
+	v4l2_device_unregister_subdev(&ccp2->subdev);
+	omap3isp_video_unregister(&ccp2->video_in);
+}
+
+/*
+ * omap3isp_ccp2_register_entities - Register the subdev media entity
+ * @ccp2: Pointer to ISP CCP2 device
+ * @vdev: Pointer to v4l device
+ * return negative error code or zero on success
+ */
+
+int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
+				    struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video nodes. */
+	ret = v4l2_device_register_subdev(vdev, &ccp2->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap3isp_video_register(&ccp2->video_in, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap3isp_ccp2_unregister_entities(ccp2);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP ccp2 initialisation and cleanup
+ */
+
+/*
+ * omap3isp_ccp2_cleanup - CCP2 un-initialization
+ * @isp : Pointer to ISP device
+ */
+void omap3isp_ccp2_cleanup(struct isp_device *isp)
+{
+}
+
+/*
+ * omap3isp_ccp2_init - CCP2 initialization.
+ * @isp : Pointer to ISP device
+ * return negative error code or zero on success
+ */
+int omap3isp_ccp2_init(struct isp_device *isp)
+{
+	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
+	int ret;
+
+	init_waitqueue_head(&ccp2->wait);
+
+	/* On the OMAP36xx, the CCP2 uses the CSI PHY1 or PHY2, shared with
+	 * the CSI2c or CSI2a receivers. The PHY then needs to be explicitly
+	 * configured.
+	 *
+	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
+	 */
+	if (isp->revision == ISP_REVISION_15_0)
+		ccp2->phy = &isp->isp_csiphy1;
+
+	ret = ccp2_init_entities(ccp2);
+	if (ret < 0)
+		goto out;
+
+	ccp2_reset(ccp2);
+out:
+	if (ret)
+		omap3isp_ccp2_cleanup(isp);
+
+	return ret;
+}
diff --git a/drivers/media/video/omap3-isp/ispccp2.h b/drivers/media/video/omap3-isp/ispccp2.h
new file mode 100644
index 0000000..5505a86
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispccp2.h
@@ -0,0 +1,98 @@
+/*
+ * ispccp2.h
+ *
+ * TI OMAP3 ISP - CCP2 module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2010 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_CCP2_H
+#define OMAP3_ISP_CCP2_H
+
+#include <linux/videodev2.h>
+
+struct isp_device;
+struct isp_csiphy;
+
+/* Sink and source ccp2 pads */
+#define CCP2_PAD_SINK			0
+#define CCP2_PAD_SOURCE			1
+#define CCP2_PADS_NUM			2
+
+/* CCP2 input media entity */
+enum ccp2_input_entity {
+	CCP2_INPUT_NONE,
+	CCP2_INPUT_SENSOR,
+	CCP2_INPUT_MEMORY,
+};
+
+/* CCP2 output media entity */
+enum ccp2_output_entity {
+	CCP2_OUTPUT_NONE,
+	CCP2_OUTPUT_CCDC,
+	CCP2_OUTPUT_MEMORY,
+};
+
+
+/* Logical channel configuration */
+struct isp_interface_lcx_config {
+	int crc;
+	u32 data_start;
+	u32 data_size;
+	u32 format;
+};
+
+/* Memory channel configuration */
+struct isp_interface_mem_config {
+	u32 dst_port;
+	u32 vsize_count;
+	u32 hsize_count;
+	u32 src_ofst;
+	u32 dst_ofst;
+};
+
+/* CCP2 device */
+struct isp_ccp2_device {
+	struct v4l2_subdev subdev;
+	struct v4l2_mbus_framefmt formats[CCP2_PADS_NUM];
+	struct media_pad pads[CCP2_PADS_NUM];
+
+	enum ccp2_input_entity input;
+	enum ccp2_output_entity output;
+	struct isp_interface_lcx_config if_cfg;
+	struct isp_interface_mem_config mem_cfg;
+	struct isp_video video_in;
+	struct isp_csiphy *phy;
+	unsigned int error;
+	enum isp_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+};
+
+/* Function declarations */
+int omap3isp_ccp2_init(struct isp_device *isp);
+void omap3isp_ccp2_cleanup(struct isp_device *isp);
+int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
+			struct v4l2_device *vdev);
+void omap3isp_ccp2_unregister_entities(struct isp_ccp2_device *ccp2);
+int omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2);
+
+#endif	/* OMAP3_ISP_CCP2_H */
diff --git a/drivers/media/video/omap3-isp/ispcsi2.c b/drivers/media/video/omap3-isp/ispcsi2.c
new file mode 100644
index 0000000..8d1fa4d
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispcsi2.c
@@ -0,0 +1,1316 @@
+/*
+ * ispcsi2.c
+ *
+ * TI OMAP3 ISP - CSI2 module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/delay.h>
+#include <media/v4l2-common.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/mm.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispcsi2.h"
+
+/*
+ * csi2_if_enable - Enable CSI2 Receiver interface.
+ * @enable: enable flag
+ *
+ */
+static void csi2_if_enable(struct isp_device *isp,
+			   struct isp_csi2_device *csi2, u8 enable)
+{
+	struct isp_csi2_ctrl_cfg *currctrl = &csi2->ctrl;
+
+	isp_reg_clr_set(isp, csi2->regs1, ISPCSI2_CTRL, ISPCSI2_CTRL_IF_EN,
+			enable ? ISPCSI2_CTRL_IF_EN : 0);
+
+	currctrl->if_enable = enable;
+}
+
+/*
+ * csi2_recv_config - CSI2 receiver module configuration.
+ * @currctrl: isp_csi2_ctrl_cfg structure
+ *
+ */
+static void csi2_recv_config(struct isp_device *isp,
+			     struct isp_csi2_device *csi2,
+			     struct isp_csi2_ctrl_cfg *currctrl)
+{
+	u32 reg;
+
+	reg = isp_reg_readl(isp, csi2->regs1, ISPCSI2_CTRL);
+
+	if (currctrl->frame_mode)
+		reg |= ISPCSI2_CTRL_FRAME;
+	else
+		reg &= ~ISPCSI2_CTRL_FRAME;
+
+	if (currctrl->vp_clk_enable)
+		reg |= ISPCSI2_CTRL_VP_CLK_EN;
+	else
+		reg &= ~ISPCSI2_CTRL_VP_CLK_EN;
+
+	if (currctrl->vp_only_enable)
+		reg |= ISPCSI2_CTRL_VP_ONLY_EN;
+	else
+		reg &= ~ISPCSI2_CTRL_VP_ONLY_EN;
+
+	reg &= ~ISPCSI2_CTRL_VP_OUT_CTRL_MASK;
+	reg |= currctrl->vp_out_ctrl << ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT;
+
+	if (currctrl->ecc_enable)
+		reg |= ISPCSI2_CTRL_ECC_EN;
+	else
+		reg &= ~ISPCSI2_CTRL_ECC_EN;
+
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_CTRL);
+}
+
+static const unsigned int csi2_input_fmts[] = {
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SRGGB10_1X10,
+	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SGBRG10_1X10,
+	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
+};
+
+/* To set the format on the CSI2 requires a mapping function that takes
+ * the following inputs:
+ * - 2 different formats (at this time)
+ * - 2 destinations (mem, vp+mem) (vp only handled separately)
+ * - 2 decompression options (on, off)
+ * - 2 isp revisions (certain format must be handled differently on OMAP3630)
+ * Output should be CSI2 frame format code
+ * Array indices as follows: [format][dest][decompr][is_3630]
+ * Not all combinations are valid. 0 means invalid.
+ */
+static const u16 __csi2_fmt_map[2][2][2][2] = {
+	/* RAW10 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			{ CSI2_PIX_FMT_RAW10_EXP16, CSI2_PIX_FMT_RAW10_EXP16 },
+			/* DPCM decompression */
+			{ 0, 0 },
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			{ CSI2_PIX_FMT_RAW10_EXP16_VP,
+			  CSI2_PIX_FMT_RAW10_EXP16_VP },
+			/* DPCM decompression */
+			{ 0, 0 },
+		},
+	},
+	/* RAW10 DPCM8 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			{ CSI2_PIX_FMT_RAW8, CSI2_USERDEF_8BIT_DATA1 },
+			/* DPCM decompression */
+			{ CSI2_PIX_FMT_RAW8_DPCM10_EXP16,
+			  CSI2_USERDEF_8BIT_DATA1_DPCM10 },
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			{ CSI2_PIX_FMT_RAW8_VP,
+			  CSI2_PIX_FMT_RAW8_VP },
+			/* DPCM decompression */
+			{ CSI2_PIX_FMT_RAW8_DPCM10_VP,
+			  CSI2_USERDEF_8BIT_DATA1_DPCM10_VP },
+		},
+	},
+};
+
+/*
+ * csi2_ctx_map_format - Map CSI2 sink media bus format to CSI2 format ID
+ * @csi2: ISP CSI2 device
+ *
+ * Returns CSI2 physical format id
+ */
+static u16 csi2_ctx_map_format(struct isp_csi2_device *csi2)
+{
+	const struct v4l2_mbus_framefmt *fmt = &csi2->formats[CSI2_PAD_SINK];
+	int fmtidx, destidx, is_3630;
+
+	switch (fmt->code) {
+	case V4L2_MBUS_FMT_SGRBG10_1X10:
+	case V4L2_MBUS_FMT_SRGGB10_1X10:
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case V4L2_MBUS_FMT_SGBRG10_1X10:
+		fmtidx = 0;
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8:
+		fmtidx = 1;
+		break;
+	default:
+		WARN(1, KERN_ERR "CSI2: pixel format %08x unsupported!\n",
+		     fmt->code);
+		return 0;
+	}
+
+	if (!(csi2->output & CSI2_OUTPUT_CCDC) &&
+	    !(csi2->output & CSI2_OUTPUT_MEMORY)) {
+		/* Neither output enabled is a valid combination */
+		return CSI2_PIX_FMT_OTHERS;
+	}
+
+	/* If we need to skip frames at the beginning of the stream disable the
+	 * video port to avoid sending the skipped frames to the CCDC.
+	 */
+	destidx = csi2->frame_skip ? 0 : !!(csi2->output & CSI2_OUTPUT_CCDC);
+	is_3630 = csi2->isp->revision == ISP_REVISION_15_0;
+
+	return __csi2_fmt_map[fmtidx][destidx][csi2->dpcm_decompress][is_3630];
+}
+
+/*
+ * csi2_set_outaddr - Set memory address to save output image
+ * @csi2: Pointer to ISP CSI2a device.
+ * @addr: ISP MMU Mapped 32-bit memory address aligned on 32 byte boundary.
+ *
+ * Sets the memory address where the output will be saved.
+ *
+ * Returns 0 if successful, or -EINVAL if the address is not in the 32 byte
+ * boundary.
+ */
+static void csi2_set_outaddr(struct isp_csi2_device *csi2, u32 addr)
+{
+	struct isp_device *isp = csi2->isp;
+	struct isp_csi2_ctx_cfg *ctx = &csi2->contexts[0];
+
+	ctx->ping_addr = ctx->pong_addr = addr;
+	isp_reg_writel(isp, ctx->ping_addr,
+		       csi2->regs1, ISPCSI2_CTX_DAT_PING_ADDR(ctx->ctxnum));
+	isp_reg_writel(isp, ctx->pong_addr,
+		       csi2->regs1, ISPCSI2_CTX_DAT_PONG_ADDR(ctx->ctxnum));
+}
+
+/*
+ * is_usr_def_mapping - Checks whether USER_DEF_MAPPING should
+ *			be enabled by CSI2.
+ * @format_id: mapped format id
+ *
+ */
+static inline int is_usr_def_mapping(u32 format_id)
+{
+	return (format_id & 0x40) ? 1 : 0;
+}
+
+/*
+ * csi2_ctx_enable - Enable specified CSI2 context
+ * @ctxnum: Context number, valid between 0 and 7 values.
+ * @enable: enable
+ *
+ */
+static void csi2_ctx_enable(struct isp_device *isp,
+			    struct isp_csi2_device *csi2, u8 ctxnum, u8 enable)
+{
+	struct isp_csi2_ctx_cfg *ctx = &csi2->contexts[ctxnum];
+	unsigned int skip = 0;
+	u32 reg;
+
+	reg = isp_reg_readl(isp, csi2->regs1, ISPCSI2_CTX_CTRL1(ctxnum));
+
+	if (enable) {
+		if (csi2->frame_skip)
+			skip = csi2->frame_skip;
+		else if (csi2->output & CSI2_OUTPUT_MEMORY)
+			skip = 1;
+
+		reg &= ~ISPCSI2_CTX_CTRL1_COUNT_MASK;
+		reg |= ISPCSI2_CTX_CTRL1_COUNT_UNLOCK
+		    |  (skip << ISPCSI2_CTX_CTRL1_COUNT_SHIFT)
+		    |  ISPCSI2_CTX_CTRL1_CTX_EN;
+	} else {
+		reg &= ~ISPCSI2_CTX_CTRL1_CTX_EN;
+	}
+
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_CTX_CTRL1(ctxnum));
+	ctx->enabled = enable;
+}
+
+/*
+ * csi2_ctx_config - CSI2 context configuration.
+ * @ctx: context configuration
+ *
+ */
+static void csi2_ctx_config(struct isp_device *isp,
+			    struct isp_csi2_device *csi2,
+			    struct isp_csi2_ctx_cfg *ctx)
+{
+	u32 reg;
+
+	/* Set up CSI2_CTx_CTRL1 */
+	reg = isp_reg_readl(isp, csi2->regs1, ISPCSI2_CTX_CTRL1(ctx->ctxnum));
+
+	if (ctx->eof_enabled)
+		reg |= ISPCSI2_CTX_CTRL1_EOF_EN;
+	else
+		reg &= ~ISPCSI2_CTX_CTRL1_EOF_EN;
+
+	if (ctx->eol_enabled)
+		reg |= ISPCSI2_CTX_CTRL1_EOL_EN;
+	else
+		reg &= ~ISPCSI2_CTX_CTRL1_EOL_EN;
+
+	if (ctx->checksum_enabled)
+		reg |= ISPCSI2_CTX_CTRL1_CS_EN;
+	else
+		reg &= ~ISPCSI2_CTX_CTRL1_CS_EN;
+
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_CTX_CTRL1(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_CTRL2 */
+	reg = isp_reg_readl(isp, csi2->regs1, ISPCSI2_CTX_CTRL2(ctx->ctxnum));
+
+	reg &= ~(ISPCSI2_CTX_CTRL2_VIRTUAL_ID_MASK);
+	reg |= ctx->virtual_id << ISPCSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT;
+
+	reg &= ~(ISPCSI2_CTX_CTRL2_FORMAT_MASK);
+	reg |= ctx->format_id << ISPCSI2_CTX_CTRL2_FORMAT_SHIFT;
+
+	if (ctx->dpcm_decompress) {
+		if (ctx->dpcm_predictor)
+			reg |= ISPCSI2_CTX_CTRL2_DPCM_PRED;
+		else
+			reg &= ~ISPCSI2_CTX_CTRL2_DPCM_PRED;
+	}
+
+	if (is_usr_def_mapping(ctx->format_id)) {
+		reg &= ~ISPCSI2_CTX_CTRL2_USER_DEF_MAP_MASK;
+		reg |= 2 << ISPCSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT;
+	}
+
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_CTX_CTRL2(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_CTRL3 */
+	reg = isp_reg_readl(isp, csi2->regs1, ISPCSI2_CTX_CTRL3(ctx->ctxnum));
+	reg &= ~(ISPCSI2_CTX_CTRL3_ALPHA_MASK);
+	reg |= (ctx->alpha << ISPCSI2_CTX_CTRL3_ALPHA_SHIFT);
+
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_CTX_CTRL3(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_DAT_OFST */
+	reg = isp_reg_readl(isp, csi2->regs1,
+			    ISPCSI2_CTX_DAT_OFST(ctx->ctxnum));
+	reg &= ~ISPCSI2_CTX_DAT_OFST_OFST_MASK;
+	reg |= ctx->data_offset << ISPCSI2_CTX_DAT_OFST_OFST_SHIFT;
+	isp_reg_writel(isp, reg, csi2->regs1,
+		       ISPCSI2_CTX_DAT_OFST(ctx->ctxnum));
+
+	isp_reg_writel(isp, ctx->ping_addr,
+		       csi2->regs1, ISPCSI2_CTX_DAT_PING_ADDR(ctx->ctxnum));
+
+	isp_reg_writel(isp, ctx->pong_addr,
+		       csi2->regs1, ISPCSI2_CTX_DAT_PONG_ADDR(ctx->ctxnum));
+}
+
+/*
+ * csi2_timing_config - CSI2 timing configuration.
+ * @timing: csi2_timing_cfg structure
+ */
+static void csi2_timing_config(struct isp_device *isp,
+			       struct isp_csi2_device *csi2,
+			       struct isp_csi2_timing_cfg *timing)
+{
+	u32 reg;
+
+	reg = isp_reg_readl(isp, csi2->regs1, ISPCSI2_TIMING);
+
+	if (timing->force_rx_mode)
+		reg |= ISPCSI2_TIMING_FORCE_RX_MODE_IO(timing->ionum);
+	else
+		reg &= ~ISPCSI2_TIMING_FORCE_RX_MODE_IO(timing->ionum);
+
+	if (timing->stop_state_16x)
+		reg |= ISPCSI2_TIMING_STOP_STATE_X16_IO(timing->ionum);
+	else
+		reg &= ~ISPCSI2_TIMING_STOP_STATE_X16_IO(timing->ionum);
+
+	if (timing->stop_state_4x)
+		reg |= ISPCSI2_TIMING_STOP_STATE_X4_IO(timing->ionum);
+	else
+		reg &= ~ISPCSI2_TIMING_STOP_STATE_X4_IO(timing->ionum);
+
+	reg &= ~ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_MASK(timing->ionum);
+	reg |= timing->stop_state_counter <<
+	       ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_SHIFT(timing->ionum);
+
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_TIMING);
+}
+
+/*
+ * csi2_irq_ctx_set - Enables CSI2 Context IRQs.
+ * @enable: Enable/disable CSI2 Context interrupts
+ */
+static void csi2_irq_ctx_set(struct isp_device *isp,
+			     struct isp_csi2_device *csi2, int enable)
+{
+	u32 reg = ISPCSI2_CTX_IRQSTATUS_FE_IRQ;
+	int i;
+
+	if (csi2->use_fs_irq)
+		reg |= ISPCSI2_CTX_IRQSTATUS_FS_IRQ;
+
+	for (i = 0; i < 8; i++) {
+		isp_reg_writel(isp, reg, csi2->regs1,
+			       ISPCSI2_CTX_IRQSTATUS(i));
+		if (enable)
+			isp_reg_set(isp, csi2->regs1, ISPCSI2_CTX_IRQENABLE(i),
+				    reg);
+		else
+			isp_reg_clr(isp, csi2->regs1, ISPCSI2_CTX_IRQENABLE(i),
+				    reg);
+	}
+}
+
+/*
+ * csi2_irq_complexio1_set - Enables CSI2 ComplexIO IRQs.
+ * @enable: Enable/disable CSI2 ComplexIO #1 interrupts
+ */
+static void csi2_irq_complexio1_set(struct isp_device *isp,
+				    struct isp_csi2_device *csi2, int enable)
+{
+	u32 reg;
+	reg = ISPCSI2_PHY_IRQENABLE_STATEALLULPMEXIT |
+		ISPCSI2_PHY_IRQENABLE_STATEALLULPMENTER |
+		ISPCSI2_PHY_IRQENABLE_STATEULPM5 |
+		ISPCSI2_PHY_IRQENABLE_ERRCONTROL5 |
+		ISPCSI2_PHY_IRQENABLE_ERRESC5 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS5 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTHS5 |
+		ISPCSI2_PHY_IRQENABLE_STATEULPM4 |
+		ISPCSI2_PHY_IRQENABLE_ERRCONTROL4 |
+		ISPCSI2_PHY_IRQENABLE_ERRESC4 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS4 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTHS4 |
+		ISPCSI2_PHY_IRQENABLE_STATEULPM3 |
+		ISPCSI2_PHY_IRQENABLE_ERRCONTROL3 |
+		ISPCSI2_PHY_IRQENABLE_ERRESC3 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS3 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTHS3 |
+		ISPCSI2_PHY_IRQENABLE_STATEULPM2 |
+		ISPCSI2_PHY_IRQENABLE_ERRCONTROL2 |
+		ISPCSI2_PHY_IRQENABLE_ERRESC2 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS2 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTHS2 |
+		ISPCSI2_PHY_IRQENABLE_STATEULPM1 |
+		ISPCSI2_PHY_IRQENABLE_ERRCONTROL1 |
+		ISPCSI2_PHY_IRQENABLE_ERRESC1 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS1 |
+		ISPCSI2_PHY_IRQENABLE_ERRSOTHS1;
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_PHY_IRQSTATUS);
+	if (enable)
+		reg |= isp_reg_readl(isp, csi2->regs1, ISPCSI2_PHY_IRQENABLE);
+	else
+		reg = 0;
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_PHY_IRQENABLE);
+}
+
+/*
+ * csi2_irq_status_set - Enables CSI2 Status IRQs.
+ * @enable: Enable/disable CSI2 Status interrupts
+ */
+static void csi2_irq_status_set(struct isp_device *isp,
+				struct isp_csi2_device *csi2, int enable)
+{
+	u32 reg;
+	reg = ISPCSI2_IRQSTATUS_OCP_ERR_IRQ |
+		ISPCSI2_IRQSTATUS_SHORT_PACKET_IRQ |
+		ISPCSI2_IRQSTATUS_ECC_CORRECTION_IRQ |
+		ISPCSI2_IRQSTATUS_ECC_NO_CORRECTION_IRQ |
+		ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ |
+		ISPCSI2_IRQSTATUS_COMPLEXIO1_ERR_IRQ |
+		ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ |
+		ISPCSI2_IRQSTATUS_CONTEXT(0);
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_IRQSTATUS);
+	if (enable)
+		reg |= isp_reg_readl(isp, csi2->regs1, ISPCSI2_IRQENABLE);
+	else
+		reg = 0;
+
+	isp_reg_writel(isp, reg, csi2->regs1, ISPCSI2_IRQENABLE);
+}
+
+/*
+ * omap3isp_csi2_reset - Resets the CSI2 module.
+ *
+ * Must be called with the phy lock held.
+ *
+ * Returns 0 if successful, or -EBUSY if power command didn't respond.
+ */
+int omap3isp_csi2_reset(struct isp_csi2_device *csi2)
+{
+	struct isp_device *isp = csi2->isp;
+	u8 soft_reset_retries = 0;
+	u32 reg;
+	int i;
+
+	if (!csi2->available)
+		return -ENODEV;
+
+	if (csi2->phy->phy_in_use)
+		return -EBUSY;
+
+	isp_reg_set(isp, csi2->regs1, ISPCSI2_SYSCONFIG,
+		    ISPCSI2_SYSCONFIG_SOFT_RESET);
+
+	do {
+		reg = isp_reg_readl(isp, csi2->regs1, ISPCSI2_SYSSTATUS) &
+				    ISPCSI2_SYSSTATUS_RESET_DONE;
+		if (reg == ISPCSI2_SYSSTATUS_RESET_DONE)
+			break;
+		soft_reset_retries++;
+		if (soft_reset_retries < 5)
+			udelay(100);
+	} while (soft_reset_retries < 5);
+
+	if (soft_reset_retries == 5) {
+		printk(KERN_ERR "CSI2: Soft reset try count exceeded!\n");
+		return -EBUSY;
+	}
+
+	if (isp->revision == ISP_REVISION_15_0)
+		isp_reg_set(isp, csi2->regs1, ISPCSI2_PHY_CFG,
+			    ISPCSI2_PHY_CFG_RESET_CTRL);
+
+	i = 100;
+	do {
+		reg = isp_reg_readl(isp, csi2->phy->phy_regs, ISPCSIPHY_REG1)
+		    & ISPCSIPHY_REG1_RESET_DONE_CTRLCLK;
+		if (reg == ISPCSIPHY_REG1_RESET_DONE_CTRLCLK)
+			break;
+		udelay(100);
+	} while (--i > 0);
+
+	if (i == 0) {
+		printk(KERN_ERR
+		       "CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
+		return -EBUSY;
+	}
+
+	if (isp->autoidle)
+		isp_reg_clr_set(isp, csi2->regs1, ISPCSI2_SYSCONFIG,
+				ISPCSI2_SYSCONFIG_MSTANDBY_MODE_MASK |
+				ISPCSI2_SYSCONFIG_AUTO_IDLE,
+				ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SMART |
+				((isp->revision == ISP_REVISION_15_0) ?
+				 ISPCSI2_SYSCONFIG_AUTO_IDLE : 0));
+	else
+		isp_reg_clr_set(isp, csi2->regs1, ISPCSI2_SYSCONFIG,
+				ISPCSI2_SYSCONFIG_MSTANDBY_MODE_MASK |
+				ISPCSI2_SYSCONFIG_AUTO_IDLE,
+				ISPCSI2_SYSCONFIG_MSTANDBY_MODE_NO);
+
+	return 0;
+}
+
+static int csi2_configure(struct isp_csi2_device *csi2)
+{
+	const struct isp_v4l2_subdevs_group *pdata;
+	struct isp_device *isp = csi2->isp;
+	struct isp_csi2_timing_cfg *timing = &csi2->timing[0];
+	struct v4l2_subdev *sensor;
+	struct media_pad *pad;
+
+	/*
+	 * CSI2 fields that can be updated while the context has
+	 * been enabled or the interface has been enabled are not
+	 * updated dynamically currently. So we do not allow to
+	 * reconfigure if either has been enabled
+	 */
+	if (csi2->contexts[0].enabled || csi2->ctrl.if_enable)
+		return -EBUSY;
+
+	pad = media_entity_remote_source(&csi2->pads[CSI2_PAD_SINK]);
+	sensor = media_entity_to_v4l2_subdev(pad->entity);
+	pdata = sensor->host_priv;
+
+	csi2->frame_skip = 0;
+	v4l2_subdev_call(sensor, sensor, g_skip_frames, &csi2->frame_skip);
+
+	csi2->ctrl.vp_out_ctrl = pdata->bus.csi2.vpclk_div;
+	csi2->ctrl.frame_mode = ISP_CSI2_FRAME_IMMEDIATE;
+	csi2->ctrl.ecc_enable = pdata->bus.csi2.crc;
+
+	timing->ionum = 1;
+	timing->force_rx_mode = 1;
+	timing->stop_state_16x = 1;
+	timing->stop_state_4x = 1;
+	timing->stop_state_counter = 0x1FF;
+
+	/*
+	 * The CSI2 receiver can't do any format conversion except DPCM
+	 * decompression, so every set_format call configures both pads
+	 * and enables DPCM decompression as a special case:
+	 */
+	if (csi2->formats[CSI2_PAD_SINK].code !=
+	    csi2->formats[CSI2_PAD_SOURCE].code)
+		csi2->dpcm_decompress = true;
+	else
+		csi2->dpcm_decompress = false;
+
+	csi2->contexts[0].format_id = csi2_ctx_map_format(csi2);
+
+	if (csi2->video_out.bpl_padding == 0)
+		csi2->contexts[0].data_offset = 0;
+	else
+		csi2->contexts[0].data_offset = csi2->video_out.bpl_value;
+
+	/*
+	 * Enable end of frame and end of line signals generation for
+	 * context 0. These signals are generated from CSI2 receiver to
+	 * qualify the last pixel of a frame and the last pixel of a line.
+	 * Without enabling the signals CSI2 receiver writes data to memory
+	 * beyond buffer size and/or data line offset is not handled correctly.
+	 */
+	csi2->contexts[0].eof_enabled = 1;
+	csi2->contexts[0].eol_enabled = 1;
+
+	csi2_irq_complexio1_set(isp, csi2, 1);
+	csi2_irq_ctx_set(isp, csi2, 1);
+	csi2_irq_status_set(isp, csi2, 1);
+
+	/* Set configuration (timings, format and links) */
+	csi2_timing_config(isp, csi2, timing);
+	csi2_recv_config(isp, csi2, &csi2->ctrl);
+	csi2_ctx_config(isp, csi2, &csi2->contexts[0]);
+
+	return 0;
+}
+
+/*
+ * csi2_print_status - Prints CSI2 debug information.
+ */
+#define CSI2_PRINT_REGISTER(isp, regs, name)\
+	dev_dbg(isp->dev, "###CSI2 " #name "=0x%08x\n", \
+		isp_reg_readl(isp, regs, ISPCSI2_##name))
+
+static void csi2_print_status(struct isp_csi2_device *csi2)
+{
+	struct isp_device *isp = csi2->isp;
+
+	if (!csi2->available)
+		return;
+
+	dev_dbg(isp->dev, "-------------CSI2 Register dump-------------\n");
+
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, SYSCONFIG);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, SYSSTATUS);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, IRQENABLE);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, IRQSTATUS);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTRL);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, DBG_H);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, GNQ);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, PHY_CFG);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, PHY_IRQSTATUS);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, SHORT_PACKET);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, PHY_IRQENABLE);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, DBG_P);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, TIMING);
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_CTRL1(0));
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_CTRL2(0));
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_DAT_OFST(0));
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_DAT_PING_ADDR(0));
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_DAT_PONG_ADDR(0));
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_IRQENABLE(0));
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_IRQSTATUS(0));
+	CSI2_PRINT_REGISTER(isp, csi2->regs1, CTX_CTRL3(0));
+
+	dev_dbg(isp->dev, "--------------------------------------------\n");
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt handling
+ */
+
+/*
+ * csi2_isr_buffer - Does buffer handling at end-of-frame
+ * when writing to memory.
+ */
+static void csi2_isr_buffer(struct isp_csi2_device *csi2)
+{
+	struct isp_device *isp = csi2->isp;
+	struct isp_buffer *buffer;
+
+	csi2_ctx_enable(isp, csi2, 0, 0);
+
+	buffer = omap3isp_video_buffer_next(&csi2->video_out, 0);
+
+	/*
+	 * Let video queue operation restart engine if there is an underrun
+	 * condition.
+	 */
+	if (buffer == NULL)
+		return;
+
+	csi2_set_outaddr(csi2, buffer->isp_addr);
+	csi2_ctx_enable(isp, csi2, 0, 1);
+}
+
+static void csi2_isr_ctx(struct isp_csi2_device *csi2,
+			 struct isp_csi2_ctx_cfg *ctx)
+{
+	struct isp_device *isp = csi2->isp;
+	unsigned int n = ctx->ctxnum;
+	u32 status;
+
+	status = isp_reg_readl(isp, csi2->regs1, ISPCSI2_CTX_IRQSTATUS(n));
+	isp_reg_writel(isp, status, csi2->regs1, ISPCSI2_CTX_IRQSTATUS(n));
+
+	/* Propagate frame number */
+	if (status & ISPCSI2_CTX_IRQSTATUS_FS_IRQ) {
+		struct isp_pipeline *pipe =
+				     to_isp_pipeline(&csi2->subdev.entity);
+		if (pipe->do_propagation)
+			atomic_inc(&pipe->frame_number);
+	}
+
+	if (!(status & ISPCSI2_CTX_IRQSTATUS_FE_IRQ))
+		return;
+
+	/* Skip interrupts until we reach the frame skip count. The CSI2 will be
+	 * automatically disabled, as the frame skip count has been programmed
+	 * in the CSI2_CTx_CTRL1::COUNT field, so reenable it.
+	 *
+	 * It would have been nice to rely on the FRAME_NUMBER interrupt instead
+	 * but it turned out that the interrupt is only generated when the CSI2
+	 * writes to memory (the CSI2_CTx_CTRL1::COUNT field is decreased
+	 * correctly and reaches 0 when data is forwarded to the video port only
+	 * but no interrupt arrives). Maybe a CSI2 hardware bug.
+	 */
+	if (csi2->frame_skip) {
+		csi2->frame_skip--;
+		if (csi2->frame_skip == 0) {
+			ctx->format_id = csi2_ctx_map_format(csi2);
+			csi2_ctx_config(isp, csi2, ctx);
+			csi2_ctx_enable(isp, csi2, n, 1);
+		}
+		return;
+	}
+
+	if (csi2->output & CSI2_OUTPUT_MEMORY)
+		csi2_isr_buffer(csi2);
+}
+
+/*
+ * omap3isp_csi2_isr - CSI2 interrupt handling.
+ *
+ * Return -EIO on Transmission error
+ */
+int omap3isp_csi2_isr(struct isp_csi2_device *csi2)
+{
+	u32 csi2_irqstatus, cpxio1_irqstatus;
+	struct isp_device *isp = csi2->isp;
+	int retval = 0;
+
+	if (!csi2->available)
+		return -ENODEV;
+
+	csi2_irqstatus = isp_reg_readl(isp, csi2->regs1, ISPCSI2_IRQSTATUS);
+	isp_reg_writel(isp, csi2_irqstatus, csi2->regs1, ISPCSI2_IRQSTATUS);
+
+	/* Failure Cases */
+	if (csi2_irqstatus & ISPCSI2_IRQSTATUS_COMPLEXIO1_ERR_IRQ) {
+		cpxio1_irqstatus = isp_reg_readl(isp, csi2->regs1,
+						 ISPCSI2_PHY_IRQSTATUS);
+		isp_reg_writel(isp, cpxio1_irqstatus,
+			       csi2->regs1, ISPCSI2_PHY_IRQSTATUS);
+		dev_dbg(isp->dev, "CSI2: ComplexIO Error IRQ "
+			"%x\n", cpxio1_irqstatus);
+		retval = -EIO;
+	}
+
+	if (csi2_irqstatus & (ISPCSI2_IRQSTATUS_OCP_ERR_IRQ |
+			      ISPCSI2_IRQSTATUS_SHORT_PACKET_IRQ |
+			      ISPCSI2_IRQSTATUS_ECC_NO_CORRECTION_IRQ |
+			      ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ |
+			      ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ)) {
+		dev_dbg(isp->dev, "CSI2 Err:"
+			" OCP:%d,"
+			" Short_pack:%d,"
+			" ECC:%d,"
+			" CPXIO2:%d,"
+			" FIFO_OVF:%d,"
+			"\n",
+			(csi2_irqstatus &
+			 ISPCSI2_IRQSTATUS_OCP_ERR_IRQ) ? 1 : 0,
+			(csi2_irqstatus &
+			 ISPCSI2_IRQSTATUS_SHORT_PACKET_IRQ) ? 1 : 0,
+			(csi2_irqstatus &
+			 ISPCSI2_IRQSTATUS_ECC_NO_CORRECTION_IRQ) ? 1 : 0,
+			(csi2_irqstatus &
+			 ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ) ? 1 : 0,
+			(csi2_irqstatus &
+			 ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ) ? 1 : 0);
+		retval = -EIO;
+	}
+
+	if (omap3isp_module_sync_is_stopping(&csi2->wait, &csi2->stopping))
+		return 0;
+
+	/* Successful cases */
+	if (csi2_irqstatus & ISPCSI2_IRQSTATUS_CONTEXT(0))
+		csi2_isr_ctx(csi2, &csi2->contexts[0]);
+
+	if (csi2_irqstatus & ISPCSI2_IRQSTATUS_ECC_CORRECTION_IRQ)
+		dev_dbg(isp->dev, "CSI2: ECC correction done\n");
+
+	return retval;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP video operations
+ */
+
+/*
+ * csi2_queue - Queues the first buffer when using memory output
+ * @video: The video node
+ * @buffer: buffer to queue
+ */
+static int csi2_queue(struct isp_video *video, struct isp_buffer *buffer)
+{
+	struct isp_device *isp = video->isp;
+	struct isp_csi2_device *csi2 = &isp->isp_csi2a;
+
+	csi2_set_outaddr(csi2, buffer->isp_addr);
+
+	/*
+	 * If streaming was enabled before there was a buffer queued
+	 * or underrun happened in the ISR, the hardware was not enabled
+	 * and DMA queue flag ISP_VIDEO_DMAQUEUE_UNDERRUN is still set.
+	 * Enable it now.
+	 */
+	if (csi2->video_out.dmaqueue_flags & ISP_VIDEO_DMAQUEUE_UNDERRUN) {
+		/* Enable / disable context 0 and IRQs */
+		csi2_if_enable(isp, csi2, 1);
+		csi2_ctx_enable(isp, csi2, 0, 1);
+		isp_video_dmaqueue_flags_clr(&csi2->video_out);
+	}
+
+	return 0;
+}
+
+static const struct isp_video_operations csi2_ispvideo_ops = {
+	.queue = csi2_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+static struct v4l2_mbus_framefmt *
+__csi2_get_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &csi2->formats[pad];
+}
+
+static void
+csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		enum v4l2_subdev_format_whence which)
+{
+	enum v4l2_mbus_pixelcode pixelcode;
+	struct v4l2_mbus_framefmt *format;
+	const struct isp_format_info *info;
+	unsigned int i;
+
+	switch (pad) {
+	case CSI2_PAD_SINK:
+		/* Clamp the width and height to valid range (1-8191). */
+		for (i = 0; i < ARRAY_SIZE(csi2_input_fmts); i++) {
+			if (fmt->code == csi2_input_fmts[i])
+				break;
+		}
+
+		/* If not found, use SGRBG10 as default */
+		if (i >= ARRAY_SIZE(csi2_input_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
+		fmt->height = clamp_t(u32, fmt->height, 1, 8191);
+		break;
+
+	case CSI2_PAD_SOURCE:
+		/* Source format same as sink format, except for DPCM
+		 * compression.
+		 */
+		pixelcode = fmt->code;
+		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		/*
+		 * Only Allow DPCM decompression, and check that the
+		 * pattern is preserved
+		 */
+		info = omap3isp_video_format_info(fmt->code);
+		if (info->uncompressed == pixelcode)
+			fmt->code = pixelcode;
+		break;
+	}
+
+	/* RGB, non-interlaced */
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+/*
+ * csi2_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh     : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+	const struct isp_format_info *info;
+
+	if (code->pad == CSI2_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(csi2_input_fmts))
+			return -EINVAL;
+
+		code->code = csi2_input_fmts[code->index];
+	} else {
+		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK,
+					   V4L2_SUBDEV_FORMAT_TRY);
+		switch (code->index) {
+		case 0:
+			/* Passthrough sink pad code */
+			code->code = format->code;
+			break;
+		case 1:
+			/* Uncompressed code */
+			info = omap3isp_video_format_info(format->code);
+			if (info->uncompressed == format->code)
+				return -EINVAL;
+
+			code->code = info->uncompressed;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int csi2_enum_frame_size(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * csi2_get_format - Handle get format by pads subdev method
+ * @sd : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on sucess
+ */
+static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * csi2_set_format - Handle set format by pads subdev method
+ * @sd : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on success
+ */
+static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	csi2_try_format(csi2, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == CSI2_PAD_SINK) {
+		format = __csi2_get_format(csi2, fh, CSI2_PAD_SOURCE,
+					   fmt->which);
+		*format = fmt->format;
+		csi2_try_format(csi2, fh, CSI2_PAD_SOURCE, format, fmt->which);
+	}
+
+	return 0;
+}
+
+/*
+ * csi2_init_formats - Initialize formats on all pads
+ * @sd: ISP CSI2 V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = CSI2_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	csi2_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/*
+ * csi2_set_stream - Enable/Disable streaming on the CSI2 module
+ * @sd: ISP CSI2 V4L2 subdevice
+ * @enable: ISP pipeline stream state
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct isp_device *isp = csi2->isp;
+	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
+	struct isp_video *video_out = &csi2->video_out;
+
+	switch (enable) {
+	case ISP_PIPELINE_STREAM_CONTINUOUS:
+		if (omap3isp_csiphy_acquire(csi2->phy) < 0)
+			return -ENODEV;
+		csi2->use_fs_irq = pipe->do_propagation;
+		if (csi2->output & CSI2_OUTPUT_MEMORY)
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CSI2A_WRITE);
+		csi2_configure(csi2);
+		csi2_print_status(csi2);
+
+		/*
+		 * When outputting to memory with no buffer available, let the
+		 * buffer queue handler start the hardware. A DMA queue flag
+		 * ISP_VIDEO_DMAQUEUE_QUEUED will be set as soon as there is
+		 * a buffer available.
+		 */
+		if (csi2->output & CSI2_OUTPUT_MEMORY &&
+		    !(video_out->dmaqueue_flags & ISP_VIDEO_DMAQUEUE_QUEUED))
+			break;
+		/* Enable context 0 and IRQs */
+		atomic_set(&csi2->stopping, 0);
+		csi2_ctx_enable(isp, csi2, 0, 1);
+		csi2_if_enable(isp, csi2, 1);
+		isp_video_dmaqueue_flags_clr(video_out);
+		break;
+
+	case ISP_PIPELINE_STREAM_STOPPED:
+		if (csi2->state == ISP_PIPELINE_STREAM_STOPPED)
+			return 0;
+		if (omap3isp_module_sync_idle(&sd->entity, &csi2->wait,
+					      &csi2->stopping))
+			dev_dbg(isp->dev, "%s: module stop timeout.\n",
+				sd->name);
+		csi2_ctx_enable(isp, csi2, 0, 0);
+		csi2_if_enable(isp, csi2, 0);
+		csi2_irq_ctx_set(isp, csi2, 0);
+		omap3isp_csiphy_release(csi2->phy);
+		isp_video_dmaqueue_flags_clr(video_out);
+		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_CSI2A_WRITE);
+		break;
+	}
+
+	csi2->state = enable;
+	return 0;
+}
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops csi2_video_ops = {
+	.s_stream = csi2_set_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
+	.enum_mbus_code = csi2_enum_mbus_code,
+	.enum_frame_size = csi2_enum_frame_size,
+	.get_fmt = csi2_get_format,
+	.set_fmt = csi2_set_format,
+};
+
+/* subdev operations */
+static const struct v4l2_subdev_ops csi2_ops = {
+	.video = &csi2_video_ops,
+	.pad = &csi2_pad_ops,
+};
+
+/* subdev internal operations */
+static const struct v4l2_subdev_internal_ops csi2_internal_ops = {
+	.open = csi2_init_formats,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * csi2_link_setup - Setup CSI2 connections.
+ * @entity : Pointer to media entity structure
+ * @local  : Pointer to local pad array
+ * @remote : Pointer to remote pad array
+ * @flags  : Link flags
+ * return -EINVAL or zero on success
+ */
+static int csi2_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct isp_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
+
+	/*
+	 * The ISP core doesn't support pipelines with multiple video outputs.
+	 * Revisit this when it will be implemented, and return -EBUSY for now.
+	 */
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case CSI2_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (csi2->output & ~CSI2_OUTPUT_MEMORY)
+				return -EBUSY;
+			csi2->output |= CSI2_OUTPUT_MEMORY;
+		} else {
+			csi2->output &= ~CSI2_OUTPUT_MEMORY;
+		}
+		break;
+
+	case CSI2_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (csi2->output & ~CSI2_OUTPUT_CCDC)
+				return -EBUSY;
+			csi2->output |= CSI2_OUTPUT_CCDC;
+		} else {
+			csi2->output &= ~CSI2_OUTPUT_CCDC;
+		}
+		break;
+
+	default:
+		/* Link from camera to CSI2 is fixed... */
+		return -EINVAL;
+	}
+
+	ctrl->vp_only_enable =
+		(csi2->output & CSI2_OUTPUT_MEMORY) ? false : true;
+	ctrl->vp_clk_enable = !!(csi2->output & CSI2_OUTPUT_CCDC);
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations csi2_media_ops = {
+	.link_setup = csi2_link_setup,
+};
+
+/*
+ * csi2_init_entities - Initialize subdev and media entity.
+ * @csi2: Pointer to csi2 structure.
+ * return -ENOMEM or zero on success
+ */
+static int csi2_init_entities(struct isp_csi2_device *csi2)
+{
+	struct v4l2_subdev *sd = &csi2->subdev;
+	struct media_pad *pads = csi2->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	v4l2_subdev_init(sd, &csi2_ops);
+	sd->internal_ops = &csi2_internal_ops;
+	strlcpy(sd->name, "OMAP3 ISP CSI2a", sizeof(sd->name));
+
+	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
+	v4l2_set_subdevdata(sd, csi2);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[CSI2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	pads[CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+
+	me->ops = &csi2_media_ops;
+	ret = media_entity_init(me, CSI2_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	csi2_init_formats(sd, NULL);
+
+	/* Video device node */
+	csi2->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	csi2->video_out.ops = &csi2_ispvideo_ops;
+	csi2->video_out.bpl_alignment = 32;
+	csi2->video_out.bpl_zero_padding = 1;
+	csi2->video_out.bpl_max = 0x1ffe0;
+	csi2->video_out.isp = csi2->isp;
+	csi2->video_out.capture_mem = PAGE_ALIGN(4096 * 4096) * 3;
+
+	ret = omap3isp_video_init(&csi2->video_out, "CSI2a");
+	if (ret < 0)
+		return ret;
+
+	/* Connect the CSI2 subdev to the video node. */
+	ret = media_entity_create_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
+				       &csi2->video_out.video.entity, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void omap3isp_csi2_unregister_entities(struct isp_csi2_device *csi2)
+{
+	media_entity_cleanup(&csi2->subdev.entity);
+
+	v4l2_device_unregister_subdev(&csi2->subdev);
+	omap3isp_video_unregister(&csi2->video_out);
+}
+
+int omap3isp_csi2_register_entities(struct isp_csi2_device *csi2,
+				    struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video nodes. */
+	ret = v4l2_device_register_subdev(vdev, &csi2->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap3isp_video_register(&csi2->video_out, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap3isp_csi2_unregister_entities(csi2);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP CSI2 initialisation and cleanup
+ */
+
+/*
+ * omap3isp_csi2_cleanup - Routine for module driver cleanup
+ */
+void omap3isp_csi2_cleanup(struct isp_device *isp)
+{
+}
+
+/*
+ * omap3isp_csi2_init - Routine for module driver init
+ */
+int omap3isp_csi2_init(struct isp_device *isp)
+{
+	struct isp_csi2_device *csi2a = &isp->isp_csi2a;
+	struct isp_csi2_device *csi2c = &isp->isp_csi2c;
+	int ret;
+
+	csi2a->isp = isp;
+	csi2a->available = 1;
+	csi2a->regs1 = OMAP3_ISP_IOMEM_CSI2A_REGS1;
+	csi2a->regs2 = OMAP3_ISP_IOMEM_CSI2A_REGS2;
+	csi2a->phy = &isp->isp_csiphy2;
+	csi2a->state = ISP_PIPELINE_STREAM_STOPPED;
+	init_waitqueue_head(&csi2a->wait);
+
+	ret = csi2_init_entities(csi2a);
+	if (ret < 0)
+		goto fail;
+
+	if (isp->revision == ISP_REVISION_15_0) {
+		csi2c->isp = isp;
+		csi2c->available = 1;
+		csi2c->regs1 = OMAP3_ISP_IOMEM_CSI2C_REGS1;
+		csi2c->regs2 = OMAP3_ISP_IOMEM_CSI2C_REGS2;
+		csi2c->phy = &isp->isp_csiphy1;
+		csi2c->state = ISP_PIPELINE_STREAM_STOPPED;
+		init_waitqueue_head(&csi2c->wait);
+	}
+
+	return 0;
+fail:
+	omap3isp_csi2_cleanup(isp);
+	return ret;
+}
diff --git a/drivers/media/video/omap3-isp/ispcsi2.h b/drivers/media/video/omap3-isp/ispcsi2.h
new file mode 100644
index 0000000..456fb7f
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispcsi2.h
@@ -0,0 +1,166 @@
+/*
+ * ispcsi2.h
+ *
+ * TI OMAP3 ISP - CSI2 module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_CSI2_H
+#define OMAP3_ISP_CSI2_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+struct isp_csiphy;
+
+/* This is not an exhaustive list */
+enum isp_csi2_pix_formats {
+	CSI2_PIX_FMT_OTHERS = 0,
+	CSI2_PIX_FMT_YUV422_8BIT = 0x1e,
+	CSI2_PIX_FMT_YUV422_8BIT_VP = 0x9e,
+	CSI2_PIX_FMT_RAW10_EXP16 = 0xab,
+	CSI2_PIX_FMT_RAW10_EXP16_VP = 0x12f,
+	CSI2_PIX_FMT_RAW8 = 0x2a,
+	CSI2_PIX_FMT_RAW8_DPCM10_EXP16 = 0x2aa,
+	CSI2_PIX_FMT_RAW8_DPCM10_VP = 0x32a,
+	CSI2_PIX_FMT_RAW8_VP = 0x12a,
+	CSI2_USERDEF_8BIT_DATA1_DPCM10_VP = 0x340,
+	CSI2_USERDEF_8BIT_DATA1_DPCM10 = 0x2c0,
+	CSI2_USERDEF_8BIT_DATA1 = 0x40,
+};
+
+enum isp_csi2_irqevents {
+	OCP_ERR_IRQ = 0x4000,
+	SHORT_PACKET_IRQ = 0x2000,
+	ECC_CORRECTION_IRQ = 0x1000,
+	ECC_NO_CORRECTION_IRQ = 0x800,
+	COMPLEXIO2_ERR_IRQ = 0x400,
+	COMPLEXIO1_ERR_IRQ = 0x200,
+	FIFO_OVF_IRQ = 0x100,
+	CONTEXT7 = 0x80,
+	CONTEXT6 = 0x40,
+	CONTEXT5 = 0x20,
+	CONTEXT4 = 0x10,
+	CONTEXT3 = 0x8,
+	CONTEXT2 = 0x4,
+	CONTEXT1 = 0x2,
+	CONTEXT0 = 0x1,
+};
+
+enum isp_csi2_ctx_irqevents {
+	CTX_ECC_CORRECTION = 0x100,
+	CTX_LINE_NUMBER = 0x80,
+	CTX_FRAME_NUMBER = 0x40,
+	CTX_CS = 0x20,
+	CTX_LE = 0x8,
+	CTX_LS = 0x4,
+	CTX_FE = 0x2,
+	CTX_FS = 0x1,
+};
+
+enum isp_csi2_frame_mode {
+	ISP_CSI2_FRAME_IMMEDIATE,
+	ISP_CSI2_FRAME_AFTERFEC,
+};
+
+#define ISP_CSI2_MAX_CTX_NUM	7
+
+struct isp_csi2_ctx_cfg {
+	u8 ctxnum;		/* context number 0 - 7 */
+	u8 dpcm_decompress;
+
+	/* Fields in CSI2_CTx_CTRL2 - locked by CSI2_CTx_CTRL1.CTX_EN */
+	u8 virtual_id;
+	u16 format_id;		/* as in CSI2_CTx_CTRL2[9:0] */
+	u8 dpcm_predictor;	/* 1: simple, 0: advanced */
+
+	/* Fields in CSI2_CTx_CTRL1/3 - Shadowed */
+	u16 alpha;
+	u16 data_offset;
+	u32 ping_addr;
+	u32 pong_addr;
+	u8 eof_enabled;
+	u8 eol_enabled;
+	u8 checksum_enabled;
+	u8 enabled;
+};
+
+struct isp_csi2_timing_cfg {
+	u8 ionum;			/* IO1 or IO2 as in CSI2_TIMING */
+	unsigned force_rx_mode:1;
+	unsigned stop_state_16x:1;
+	unsigned stop_state_4x:1;
+	u16 stop_state_counter;
+};
+
+struct isp_csi2_ctrl_cfg {
+	bool vp_clk_enable;
+	bool vp_only_enable;
+	u8 vp_out_ctrl;
+	enum isp_csi2_frame_mode frame_mode;
+	bool ecc_enable;
+	bool if_enable;
+};
+
+#define CSI2_PAD_SINK		0
+#define CSI2_PAD_SOURCE		1
+#define CSI2_PADS_NUM		2
+
+#define CSI2_OUTPUT_CCDC	(1 << 0)
+#define CSI2_OUTPUT_MEMORY	(1 << 1)
+
+struct isp_csi2_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[CSI2_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[CSI2_PADS_NUM];
+
+	struct isp_video video_out;
+	struct isp_device *isp;
+
+	u8 available;		/* Is the IP present on the silicon? */
+
+	/* mem resources - enums as defined in enum isp_mem_resources */
+	u8 regs1;
+	u8 regs2;
+
+	u32 output; /* output to CCDC, memory or both? */
+	bool dpcm_decompress;
+	unsigned int frame_skip;
+	bool use_fs_irq;
+
+	struct isp_csiphy *phy;
+	struct isp_csi2_ctx_cfg contexts[ISP_CSI2_MAX_CTX_NUM + 1];
+	struct isp_csi2_timing_cfg timing[2];
+	struct isp_csi2_ctrl_cfg ctrl;
+	enum isp_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+};
+
+int omap3isp_csi2_isr(struct isp_csi2_device *csi2);
+int omap3isp_csi2_reset(struct isp_csi2_device *csi2);
+int omap3isp_csi2_init(struct isp_device *isp);
+void omap3isp_csi2_cleanup(struct isp_device *isp);
+void omap3isp_csi2_unregister_entities(struct isp_csi2_device *csi2);
+int omap3isp_csi2_register_entities(struct isp_csi2_device *csi2,
+				    struct v4l2_device *vdev);
+#endif	/* OMAP3_ISP_CSI2_H */
diff --git a/drivers/media/video/omap3-isp/ispcsiphy.c b/drivers/media/video/omap3-isp/ispcsiphy.c
new file mode 100644
index 0000000..5be37ce
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispcsiphy.c
@@ -0,0 +1,247 @@
+/*
+ * ispcsiphy.c
+ *
+ * TI OMAP3 ISP - CSI PHY module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/regulator/consumer.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispcsiphy.h"
+
+/*
+ * csiphy_lanes_config - Configuration of CSIPHY lanes.
+ *
+ * Updates HW configuration.
+ * Called with phy->mutex taken.
+ */
+static void csiphy_lanes_config(struct isp_csiphy *phy)
+{
+	unsigned int i;
+	u32 reg;
+
+	reg = isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
+
+	for (i = 0; i < phy->num_data_lanes; i++) {
+		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
+			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
+		reg |= (phy->lanes.data[i].pol <<
+			ISPCSI2_PHY_CFG_DATA_POL_SHIFT(i + 1));
+		reg |= (phy->lanes.data[i].pos <<
+			ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(i + 1));
+	}
+
+	reg &= ~(ISPCSI2_PHY_CFG_CLOCK_POL_MASK |
+		 ISPCSI2_PHY_CFG_CLOCK_POSITION_MASK);
+	reg |= phy->lanes.clk.pol << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT;
+	reg |= phy->lanes.clk.pos << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT;
+
+	isp_reg_writel(phy->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
+}
+
+/*
+ * csiphy_power_autoswitch_enable
+ * @enable: Sets or clears the autoswitch function enable flag.
+ */
+static void csiphy_power_autoswitch_enable(struct isp_csiphy *phy, bool enable)
+{
+	isp_reg_clr_set(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG,
+			ISPCSI2_PHY_CFG_PWR_AUTO,
+			enable ? ISPCSI2_PHY_CFG_PWR_AUTO : 0);
+}
+
+/*
+ * csiphy_set_power
+ * @power: Power state to be set.
+ *
+ * Returns 0 if successful, or -EBUSY if the retry count is exceeded.
+ */
+static int csiphy_set_power(struct isp_csiphy *phy, u32 power)
+{
+	u32 reg;
+	u8 retry_count;
+
+	isp_reg_clr_set(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG,
+			ISPCSI2_PHY_CFG_PWR_CMD_MASK, power);
+
+	retry_count = 0;
+	do {
+		udelay(50);
+		reg = isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG) &
+				    ISPCSI2_PHY_CFG_PWR_STATUS_MASK;
+
+		if (reg != power >> 2)
+			retry_count++;
+
+	} while ((reg != power >> 2) && (retry_count < 100));
+
+	if (retry_count == 100) {
+		printk(KERN_ERR "CSI2 CIO set power failed!\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/*
+ * csiphy_dphy_config - Configure CSI2 D-PHY parameters.
+ *
+ * Called with phy->mutex taken.
+ */
+static void csiphy_dphy_config(struct isp_csiphy *phy)
+{
+	u32 reg;
+
+	/* Set up ISPCSIPHY_REG0 */
+	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG0);
+
+	reg &= ~(ISPCSIPHY_REG0_THS_TERM_MASK |
+		 ISPCSIPHY_REG0_THS_SETTLE_MASK);
+	reg |= phy->dphy.ths_term << ISPCSIPHY_REG0_THS_TERM_SHIFT;
+	reg |= phy->dphy.ths_settle << ISPCSIPHY_REG0_THS_SETTLE_SHIFT;
+
+	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
+
+	/* Set up ISPCSIPHY_REG1 */
+	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG1);
+
+	reg &= ~(ISPCSIPHY_REG1_TCLK_TERM_MASK |
+		 ISPCSIPHY_REG1_TCLK_MISS_MASK |
+		 ISPCSIPHY_REG1_TCLK_SETTLE_MASK);
+	reg |= phy->dphy.tclk_term << ISPCSIPHY_REG1_TCLK_TERM_SHIFT;
+	reg |= phy->dphy.tclk_miss << ISPCSIPHY_REG1_TCLK_MISS_SHIFT;
+	reg |= phy->dphy.tclk_settle << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT;
+
+	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
+}
+
+static int csiphy_config(struct isp_csiphy *phy,
+			 struct isp_csiphy_dphy_cfg *dphy,
+			 struct isp_csiphy_lanes_cfg *lanes)
+{
+	unsigned int used_lanes = 0;
+	unsigned int i;
+
+	/* Clock and data lanes verification */
+	for (i = 0; i < phy->num_data_lanes; i++) {
+		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
+			return -EINVAL;
+
+		if (used_lanes & (1 << lanes->data[i].pos))
+			return -EINVAL;
+
+		used_lanes |= 1 << lanes->data[i].pos;
+	}
+
+	if (lanes->clk.pol > 1 || lanes->clk.pos > 3)
+		return -EINVAL;
+
+	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
+		return -EINVAL;
+
+	mutex_lock(&phy->mutex);
+	phy->dphy = *dphy;
+	phy->lanes = *lanes;
+	mutex_unlock(&phy->mutex);
+
+	return 0;
+}
+
+int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
+{
+	int rval;
+
+	if (phy->vdd == NULL) {
+		dev_err(phy->isp->dev, "Power regulator for CSI PHY not "
+			"available\n");
+		return -ENODEV;
+	}
+
+	mutex_lock(&phy->mutex);
+
+	rval = regulator_enable(phy->vdd);
+	if (rval < 0)
+		goto done;
+
+	omap3isp_csi2_reset(phy->csi2);
+
+	csiphy_dphy_config(phy);
+	csiphy_lanes_config(phy);
+
+	rval = csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
+	if (rval) {
+		regulator_disable(phy->vdd);
+		goto done;
+	}
+
+	csiphy_power_autoswitch_enable(phy, true);
+	phy->phy_in_use = 1;
+
+done:
+	mutex_unlock(&phy->mutex);
+	return rval;
+}
+
+void omap3isp_csiphy_release(struct isp_csiphy *phy)
+{
+	mutex_lock(&phy->mutex);
+	if (phy->phy_in_use) {
+		csiphy_power_autoswitch_enable(phy, false);
+		csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
+		regulator_disable(phy->vdd);
+		phy->phy_in_use = 0;
+	}
+	mutex_unlock(&phy->mutex);
+}
+
+/*
+ * omap3isp_csiphy_init - Initialize the CSI PHY frontends
+ */
+int omap3isp_csiphy_init(struct isp_device *isp)
+{
+	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
+	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
+
+	isp->platform_cb.csiphy_config = csiphy_config;
+
+	phy2->isp = isp;
+	phy2->csi2 = &isp->isp_csi2a;
+	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
+	phy2->cfg_regs = OMAP3_ISP_IOMEM_CSI2A_REGS1;
+	phy2->phy_regs = OMAP3_ISP_IOMEM_CSIPHY2;
+	mutex_init(&phy2->mutex);
+
+	if (isp->revision == ISP_REVISION_15_0) {
+		phy1->isp = isp;
+		phy1->csi2 = &isp->isp_csi2c;
+		phy1->num_data_lanes = ISP_CSIPHY1_NUM_DATA_LANES;
+		phy1->cfg_regs = OMAP3_ISP_IOMEM_CSI2C_REGS1;
+		phy1->phy_regs = OMAP3_ISP_IOMEM_CSIPHY1;
+		mutex_init(&phy1->mutex);
+	}
+
+	return 0;
+}
diff --git a/drivers/media/video/omap3-isp/ispcsiphy.h b/drivers/media/video/omap3-isp/ispcsiphy.h
new file mode 100644
index 0000000..9596dc6
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispcsiphy.h
@@ -0,0 +1,74 @@
+/*
+ * ispcsiphy.h
+ *
+ * TI OMAP3 ISP - CSI PHY module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_CSI_PHY_H
+#define OMAP3_ISP_CSI_PHY_H
+
+struct isp_csi2_device;
+struct regulator;
+
+struct csiphy_lane {
+	u8 pos;
+	u8 pol;
+};
+
+#define ISP_CSIPHY2_NUM_DATA_LANES	2
+#define ISP_CSIPHY1_NUM_DATA_LANES	1
+
+struct isp_csiphy_lanes_cfg {
+	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
+	struct csiphy_lane clk;
+};
+
+struct isp_csiphy_dphy_cfg {
+	u8 ths_term;
+	u8 ths_settle;
+	u8 tclk_term;
+	unsigned tclk_miss:1;
+	u8 tclk_settle;
+};
+
+struct isp_csiphy {
+	struct isp_device *isp;
+	struct mutex mutex;	/* serialize csiphy configuration */
+	u8 phy_in_use;
+	struct isp_csi2_device *csi2;
+	struct regulator *vdd;
+
+	/* mem resources - enums as defined in enum isp_mem_resources */
+	unsigned int cfg_regs;
+	unsigned int phy_regs;
+
+	u8 num_data_lanes;	/* number of CSI2 Data Lanes supported */
+	struct isp_csiphy_lanes_cfg lanes;
+	struct isp_csiphy_dphy_cfg dphy;
+};
+
+int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
+void omap3isp_csiphy_release(struct isp_csiphy *phy);
+int omap3isp_csiphy_init(struct isp_device *isp);
+
+#endif	/* OMAP3_ISP_CSI_PHY_H */
-- 
1.7.3.4

