Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab1BNMVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 05/10] omap3isp: OMAP3 ISP core
Date: Mon, 14 Feb 2011 13:21:32 +0100
Message-Id: <1297686097-9804-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sakari Ailus <sakari.ailus@iki.fi>

The Image Signal Processor provides the system interface and the
processing capability to connect RAW or YUV image-sensor modules to the
OMAP3.

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
 drivers/media/video/omap3-isp/isp.c    | 2220 ++++++++++++++++++++++++++++++++
 drivers/media/video/omap3-isp/isp.h    |  427 ++++++
 drivers/media/video/omap3-isp/ispreg.h | 1589 +++++++++++++++++++++++
 include/linux/omap3isp.h               |  646 ++++++++++
 4 files changed, 4882 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap3-isp/isp.c
 create mode 100644 drivers/media/video/omap3-isp/isp.h
 create mode 100644 drivers/media/video/omap3-isp/ispreg.h
 create mode 100644 include/linux/omap3isp.h

diff --git a/drivers/media/video/omap3-isp/isp.c b/drivers/media/video/omap3-isp/isp.c
new file mode 100644
index 0000000..1a9963bd
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isp.c
@@ -0,0 +1,2220 @@
+/*
+ * isp.c
+ *
+ * TI OMAP3 ISP - Core
+ *
+ * Copyright (C) 2006-2010 Nokia Corporation
+ * Copyright (C) 2007-2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * Contributors:
+ *	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	Sakari Ailus <sakari.ailus@iki.fi>
+ *	David Cohen <dacohen@gmail.com>
+ *	Stanimir Varbanov <svarbanov@mm-sol.com>
+ *	Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
+ *	Tuukka Toivonen <tuukkat76@gmail.com>
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Antti Koskipaa <akoskipa@gmail.com>
+ *	Ivan T. Ivanov <iivanov@mm-sol.com>
+ *	RaniSuneela <r-m@ti.com>
+ *	Atanas Filipov <afilipov@mm-sol.com>
+ *	Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
+ *	Hiroshi DOYU <hiroshi.doyu@nokia.com>
+ *	Nayden Kanchev <nkanchev@mm-sol.com>
+ *	Phil Carmody <ext-phil.2.carmody@nokia.com>
+ *	Artem Bityutskiy <artem.bityutskiy@nokia.com>
+ *	Dominic Curran <dcurran@ti.com>
+ *	Ilkka Myllyperkio <ilkka.myllyperkio@sofica.fi>
+ *	Pallavi Kulkarni <p-kulkarni@ti.com>
+ *	Vaibhav Hiremath <hvaibhav@ti.com>
+ *	Mohit Jalori <mjalori@ti.com>
+ *	Sameer Venkatraman <sameerv@ti.com>
+ *	Senthilvadivu Guruswamy <svadivu@ti.com>
+ *	Thara Gopinath <thara@ti.com>
+ *	Toni Leinonen <toni.leinonen@nokia.com>
+ *	Troy Laramy <t-laramy@ti.com>
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
+#include <asm/cacheflush.h>
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispccdc.h"
+#include "isppreview.h"
+#include "ispresizer.h"
+#include "ispcsi2.h"
+#include "ispccp2.h"
+#include "isph3a.h"
+#include "isphist.h"
+
+static unsigned int autoidle;
+module_param(autoidle, int, 0444);
+MODULE_PARM_DESC(autoidle, "Enable OMAP3ISP AUTOIDLE support");
+
+static void isp_save_ctx(struct isp_device *isp);
+
+static void isp_restore_ctx(struct isp_device *isp);
+
+static const struct isp_res_mapping isp_res_maps[] = {
+	{
+		.isp_rev = ISP_REVISION_2_0,
+		.map = 1 << OMAP3_ISP_IOMEM_MAIN |
+		       1 << OMAP3_ISP_IOMEM_CCP2 |
+		       1 << OMAP3_ISP_IOMEM_CCDC |
+		       1 << OMAP3_ISP_IOMEM_HIST |
+		       1 << OMAP3_ISP_IOMEM_H3A |
+		       1 << OMAP3_ISP_IOMEM_PREV |
+		       1 << OMAP3_ISP_IOMEM_RESZ |
+		       1 << OMAP3_ISP_IOMEM_SBL |
+		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS1 |
+		       1 << OMAP3_ISP_IOMEM_CSIPHY2,
+	},
+	{
+		.isp_rev = ISP_REVISION_15_0,
+		.map = 1 << OMAP3_ISP_IOMEM_MAIN |
+		       1 << OMAP3_ISP_IOMEM_CCP2 |
+		       1 << OMAP3_ISP_IOMEM_CCDC |
+		       1 << OMAP3_ISP_IOMEM_HIST |
+		       1 << OMAP3_ISP_IOMEM_H3A |
+		       1 << OMAP3_ISP_IOMEM_PREV |
+		       1 << OMAP3_ISP_IOMEM_RESZ |
+		       1 << OMAP3_ISP_IOMEM_SBL |
+		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS1 |
+		       1 << OMAP3_ISP_IOMEM_CSIPHY2 |
+		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS2 |
+		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS1 |
+		       1 << OMAP3_ISP_IOMEM_CSIPHY1 |
+		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2,
+	},
+};
+
+/* Structure for saving/restoring ISP module registers */
+static struct isp_reg isp_reg_list[] = {
+	{OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL, 0},
+	{0, ISP_TOK_TERM, 0}
+};
+
+/*
+ * omap3isp_flush - Post pending L3 bus writes by doing a register readback
+ * @isp: OMAP3 ISP device
+ *
+ * In order to force posting of pending writes, we need to write and
+ * readback the same register, in this case the revision register.
+ *
+ * See this link for reference:
+ *   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg08149.html
+ */
+void omap3isp_flush(struct isp_device *isp)
+{
+	isp_reg_writel(isp, 0, OMAP3_ISP_IOMEM_MAIN, ISP_REVISION);
+	isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_REVISION);
+}
+
+/*
+ * isp_enable_interrupts - Enable ISP interrupts.
+ * @isp: OMAP3 ISP device
+ */
+static void isp_enable_interrupts(struct isp_device *isp)
+{
+	static const u32 irq = IRQ0ENABLE_CSIA_IRQ
+			     | IRQ0ENABLE_CSIB_IRQ
+			     | IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ
+			     | IRQ0ENABLE_CCDC_LSC_DONE_IRQ
+			     | IRQ0ENABLE_CCDC_VD0_IRQ
+			     | IRQ0ENABLE_CCDC_VD1_IRQ
+			     | IRQ0ENABLE_HS_VS_IRQ
+			     | IRQ0ENABLE_HIST_DONE_IRQ
+			     | IRQ0ENABLE_H3A_AWB_DONE_IRQ
+			     | IRQ0ENABLE_H3A_AF_DONE_IRQ
+			     | IRQ0ENABLE_PRV_DONE_IRQ
+			     | IRQ0ENABLE_RSZ_DONE_IRQ;
+
+	isp_reg_writel(isp, irq, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+	isp_reg_writel(isp, irq, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE);
+}
+
+/*
+ * isp_disable_interrupts - Disable ISP interrupts.
+ * @isp: OMAP3 ISP device
+ */
+static void isp_disable_interrupts(struct isp_device *isp)
+{
+	isp_reg_writel(isp, 0, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE);
+}
+
+/**
+ * isp_set_xclk - Configures the specified cam_xclk to the desired frequency.
+ * @isp: OMAP3 ISP device
+ * @xclk: Desired frequency of the clock in Hz. 0 = stable low, 1 is stable high
+ * @xclksel: XCLK to configure (0 = A, 1 = B).
+ *
+ * Configures the specified MCLK divisor in the ISP timing control register
+ * (TCTRL_CTRL) to generate the desired xclk clock value.
+ *
+ * Divisor = cam_mclk_hz / xclk
+ *
+ * Returns the final frequency that is actually being generated
+ **/
+static u32 isp_set_xclk(struct isp_device *isp, u32 xclk, u8 xclksel)
+{
+	u32 divisor;
+	u32 currentxclk;
+	unsigned long mclk_hz;
+
+	if (!omap3isp_get(isp))
+		return 0;
+
+	mclk_hz = clk_get_rate(isp->clock[ISP_CLK_CAM_MCLK]);
+
+	if (xclk >= mclk_hz) {
+		divisor = ISPTCTRL_CTRL_DIV_BYPASS;
+		currentxclk = mclk_hz;
+	} else if (xclk >= 2) {
+		divisor = mclk_hz / xclk;
+		if (divisor >= ISPTCTRL_CTRL_DIV_BYPASS)
+			divisor = ISPTCTRL_CTRL_DIV_BYPASS - 1;
+		currentxclk = mclk_hz / divisor;
+	} else {
+		divisor = xclk;
+		currentxclk = 0;
+	}
+
+	switch (xclksel) {
+	case 0:
+		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
+				ISPTCTRL_CTRL_DIVA_MASK,
+				divisor << ISPTCTRL_CTRL_DIVA_SHIFT);
+		dev_dbg(isp->dev, "isp_set_xclk(): cam_xclka set to %d Hz\n",
+			currentxclk);
+		break;
+	case 1:
+		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
+				ISPTCTRL_CTRL_DIVB_MASK,
+				divisor << ISPTCTRL_CTRL_DIVB_SHIFT);
+		dev_dbg(isp->dev, "isp_set_xclk(): cam_xclkb set to %d Hz\n",
+			currentxclk);
+		break;
+	default:
+		omap3isp_put(isp);
+		dev_dbg(isp->dev, "ISP_ERR: isp_set_xclk(): Invalid requested "
+			"xclk. Must be 0 (A) or 1 (B).\n");
+		return -EINVAL;
+	}
+
+	/* Do we go from stable whatever to clock? */
+	if (divisor >= 2 && isp->xclk_divisor[xclksel] < 2)
+		omap3isp_get(isp);
+	/* Stopping the clock. */
+	else if (divisor < 2 && isp->xclk_divisor[xclksel] >= 2)
+		omap3isp_put(isp);
+
+	isp->xclk_divisor[xclksel] = divisor;
+
+	omap3isp_put(isp);
+
+	return currentxclk;
+}
+
+/*
+ * isp_power_settings - Sysconfig settings, for Power Management.
+ * @isp: OMAP3 ISP device
+ * @idle: Consider idle state.
+ *
+ * Sets the power settings for the ISP, and SBL bus.
+ */
+static void isp_power_settings(struct isp_device *isp, int idle)
+{
+	isp_reg_writel(isp,
+		       ((idle ? ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY :
+				ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY) <<
+			ISP_SYSCONFIG_MIDLEMODE_SHIFT) |
+			((isp->revision == ISP_REVISION_15_0) ?
+			  ISP_SYSCONFIG_AUTOIDLE : 0),
+		       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
+
+	if (isp->autoidle)
+		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
+			       ISP_CTRL);
+}
+
+/*
+ * Configure the bridge and lane shifter. Valid inputs are
+ *
+ * CCDC_INPUT_PARALLEL: Parallel interface
+ * CCDC_INPUT_CSI2A: CSI2a receiver
+ * CCDC_INPUT_CCP2B: CCP2b receiver
+ * CCDC_INPUT_CSI2C: CSI2c receiver
+ *
+ * The bridge and lane shifter are configured according to the selected input
+ * and the ISP platform data.
+ */
+void omap3isp_configure_bridge(struct isp_device *isp,
+			       enum ccdc_input_entity input,
+			       const struct isp_parallel_platform_data *pdata)
+{
+	u32 ispctrl_val;
+
+	ispctrl_val  = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
+	ispctrl_val &= ~ISPCTRL_SHIFT_MASK;
+	ispctrl_val &= ~ISPCTRL_PAR_CLK_POL_INV;
+	ispctrl_val &= ~ISPCTRL_PAR_SER_CLK_SEL_MASK;
+	ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_MASK;
+
+	switch (input) {
+	case CCDC_INPUT_PARALLEL:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
+		ispctrl_val |= pdata->data_lane_shift << ISPCTRL_SHIFT_SHIFT;
+		ispctrl_val |= pdata->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
+		ispctrl_val |= pdata->bridge << ISPCTRL_PAR_BRIDGE_SHIFT;
+		break;
+
+	case CCDC_INPUT_CSI2A:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIA;
+		break;
+
+	case CCDC_INPUT_CCP2B:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIB;
+		break;
+
+	case CCDC_INPUT_CSI2C:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIC;
+		break;
+
+	default:
+		return;
+	}
+
+	ispctrl_val &= ~ISPCTRL_SYNC_DETECT_MASK;
+	ispctrl_val |= ISPCTRL_SYNC_DETECT_VSRISE;
+
+	isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
+}
+
+/**
+ * isp_set_pixel_clock - Configures the ISP pixel clock
+ * @isp: OMAP3 ISP device
+ * @pixelclk: Average pixel clock in Hz
+ *
+ * Set the average pixel clock required by the sensor. The ISP will use the
+ * lowest possible memory bandwidth settings compatible with the clock.
+ **/
+static void isp_set_pixel_clock(struct isp_device *isp, unsigned int pixelclk)
+{
+	isp->isp_ccdc.vpcfg.pixelclk = pixelclk;
+}
+
+void omap3isp_hist_dma_done(struct isp_device *isp)
+{
+	if (omap3isp_ccdc_busy(&isp->isp_ccdc) ||
+	    omap3isp_stat_pcr_busy(&isp->isp_hist)) {
+		/* Histogram cannot be enabled in this frame anymore */
+		atomic_set(&isp->isp_hist.buf_err, 1);
+		dev_dbg(isp->dev, "hist: Out of synchronization with "
+				  "CCDC. Ignoring next buffer.\n");
+	}
+}
+
+static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
+{
+	static const char *name[] = {
+		"CSIA_IRQ",
+		"res1",
+		"res2",
+		"CSIB_LCM_IRQ",
+		"CSIB_IRQ",
+		"res5",
+		"res6",
+		"res7",
+		"CCDC_VD0_IRQ",
+		"CCDC_VD1_IRQ",
+		"CCDC_VD2_IRQ",
+		"CCDC_ERR_IRQ",
+		"H3A_AF_DONE_IRQ",
+		"H3A_AWB_DONE_IRQ",
+		"res14",
+		"res15",
+		"HIST_DONE_IRQ",
+		"CCDC_LSC_DONE",
+		"CCDC_LSC_PREFETCH_COMPLETED",
+		"CCDC_LSC_PREFETCH_ERROR",
+		"PRV_DONE_IRQ",
+		"CBUFF_IRQ",
+		"res22",
+		"res23",
+		"RSZ_DONE_IRQ",
+		"OVF_IRQ",
+		"res26",
+		"res27",
+		"MMU_ERR_IRQ",
+		"OCP_ERR_IRQ",
+		"SEC_ERR_IRQ",
+		"HS_VS_IRQ",
+	};
+	int i;
+
+	dev_dbg(isp->dev, "");
+
+	for (i = 0; i < ARRAY_SIZE(name); i++) {
+		if ((1 << i) & irqstatus)
+			printk(KERN_CONT "%s ", name[i]);
+	}
+	printk(KERN_CONT "\n");
+}
+
+static void isp_isr_sbl(struct isp_device *isp)
+{
+	struct device *dev = isp->dev;
+	u32 sbl_pcr;
+
+	/*
+	 * Handle shared buffer logic overflows for video buffers.
+	 * ISPSBL_PCR_CCDCPRV_2_RSZ_OVF can be safely ignored.
+	 */
+	sbl_pcr = isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_PCR);
+	isp_reg_writel(isp, sbl_pcr, OMAP3_ISP_IOMEM_SBL, ISPSBL_PCR);
+	sbl_pcr &= ~ISPSBL_PCR_CCDCPRV_2_RSZ_OVF;
+
+	if (sbl_pcr)
+		dev_dbg(dev, "SBL overflow (PCR = 0x%08x)\n", sbl_pcr);
+
+	if (sbl_pcr & (ISPSBL_PCR_CCDC_WBL_OVF | ISPSBL_PCR_CSIA_WBL_OVF
+		     | ISPSBL_PCR_CSIB_WBL_OVF)) {
+		isp->isp_ccdc.error = 1;
+		if (isp->isp_ccdc.output & CCDC_OUTPUT_PREVIEW)
+			isp->isp_prev.error = 1;
+		if (isp->isp_ccdc.output & CCDC_OUTPUT_RESIZER)
+			isp->isp_res.error = 1;
+	}
+
+	if (sbl_pcr & ISPSBL_PCR_PRV_WBL_OVF) {
+		isp->isp_prev.error = 1;
+		if (isp->isp_res.input == RESIZER_INPUT_VP &&
+		    !(isp->isp_ccdc.output & CCDC_OUTPUT_RESIZER))
+			isp->isp_res.error = 1;
+	}
+
+	if (sbl_pcr & (ISPSBL_PCR_RSZ1_WBL_OVF
+		       | ISPSBL_PCR_RSZ2_WBL_OVF
+		       | ISPSBL_PCR_RSZ3_WBL_OVF
+		       | ISPSBL_PCR_RSZ4_WBL_OVF))
+		isp->isp_res.error = 1;
+
+	if (sbl_pcr & ISPSBL_PCR_H3A_AF_WBL_OVF)
+		omap3isp_stat_sbl_overflow(&isp->isp_af);
+
+	if (sbl_pcr & ISPSBL_PCR_H3A_AEAWB_WBL_OVF)
+		omap3isp_stat_sbl_overflow(&isp->isp_aewb);
+}
+
+/*
+ * isp_isr - Interrupt Service Routine for Camera ISP module.
+ * @irq: Not used currently.
+ * @_isp: Pointer to the OMAP3 ISP device
+ *
+ * Handles the corresponding callback if plugged in.
+ *
+ * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
+ * IRQ wasn't handled.
+ */
+static irqreturn_t isp_isr(int irq, void *_isp)
+{
+	static const u32 ccdc_events = IRQ0STATUS_CCDC_LSC_PREF_ERR_IRQ |
+				       IRQ0STATUS_CCDC_LSC_DONE_IRQ |
+				       IRQ0STATUS_CCDC_VD0_IRQ |
+				       IRQ0STATUS_CCDC_VD1_IRQ |
+				       IRQ0STATUS_HS_VS_IRQ;
+	struct isp_device *isp = _isp;
+	u32 irqstatus;
+	int ret;
+
+	irqstatus = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+	isp_reg_writel(isp, irqstatus, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+
+	isp_isr_sbl(isp);
+
+	if (irqstatus & IRQ0STATUS_CSIA_IRQ) {
+		ret = omap3isp_csi2_isr(&isp->isp_csi2a);
+		if (ret)
+			isp->isp_ccdc.error = 1;
+	}
+
+	if (irqstatus & IRQ0STATUS_CSIB_IRQ) {
+		ret = omap3isp_ccp2_isr(&isp->isp_ccp2);
+		if (ret)
+			isp->isp_ccdc.error = 1;
+	}
+
+	if (irqstatus & IRQ0STATUS_CCDC_VD0_IRQ) {
+		if (isp->isp_ccdc.output & CCDC_OUTPUT_PREVIEW)
+			omap3isp_preview_isr_frame_sync(&isp->isp_prev);
+		if (isp->isp_ccdc.output & CCDC_OUTPUT_RESIZER)
+			omap3isp_resizer_isr_frame_sync(&isp->isp_res);
+		omap3isp_stat_isr_frame_sync(&isp->isp_aewb);
+		omap3isp_stat_isr_frame_sync(&isp->isp_af);
+		omap3isp_stat_isr_frame_sync(&isp->isp_hist);
+	}
+
+	if (irqstatus & ccdc_events)
+		omap3isp_ccdc_isr(&isp->isp_ccdc, irqstatus & ccdc_events);
+
+	if (irqstatus & IRQ0STATUS_PRV_DONE_IRQ) {
+		if (isp->isp_prev.output & PREVIEW_OUTPUT_RESIZER)
+			omap3isp_resizer_isr_frame_sync(&isp->isp_res);
+		omap3isp_preview_isr(&isp->isp_prev);
+	}
+
+	if (irqstatus & IRQ0STATUS_RSZ_DONE_IRQ)
+		omap3isp_resizer_isr(&isp->isp_res);
+
+	if (irqstatus & IRQ0STATUS_H3A_AWB_DONE_IRQ)
+		omap3isp_stat_isr(&isp->isp_aewb);
+
+	if (irqstatus & IRQ0STATUS_H3A_AF_DONE_IRQ)
+		omap3isp_stat_isr(&isp->isp_af);
+
+	if (irqstatus & IRQ0STATUS_HIST_DONE_IRQ)
+		omap3isp_stat_isr(&isp->isp_hist);
+
+	omap3isp_flush(isp);
+
+#if defined(DEBUG) && defined(ISP_ISR_DEBUG)
+	isp_isr_dbg(isp, irqstatus);
+#endif
+
+	return IRQ_HANDLED;
+}
+
+/* -----------------------------------------------------------------------------
+ * Pipeline power management
+ *
+ * Entities must be powered up when part of a pipeline that contains at least
+ * one open video device node.
+ *
+ * To achieve this use the entity use_count field to track the number of users.
+ * For entities corresponding to video device nodes the use_count field stores
+ * the users count of the node. For entities corresponding to subdevs the
+ * use_count field stores the total number of users of all video device nodes
+ * in the pipeline.
+ *
+ * The omap3isp_pipeline_pm_use() function must be called in the open() and
+ * close() handlers of video device nodes. It increments or decrements the use
+ * count of all subdev entities in the pipeline.
+ *
+ * To react to link management on powered pipelines, the link setup notification
+ * callback updates the use count of all entities in the source and sink sides
+ * of the link.
+ */
+
+/*
+ * isp_pipeline_pm_use_count - Count the number of users of a pipeline
+ * @entity: The entity
+ *
+ * Return the total number of users of all video device nodes in the pipeline.
+ */
+static int isp_pipeline_pm_use_count(struct media_entity *entity)
+{
+	struct media_entity_graph graph;
+	int use = 0;
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
+			use += entity->use_count;
+	}
+
+	return use;
+}
+
+/*
+ * isp_pipeline_pm_power_one - Apply power change to an entity
+ * @entity: The entity
+ * @change: Use count change
+ *
+ * Change the entity use count by @change. If the entity is a subdev update its
+ * power state by calling the core::s_power operation when the use count goes
+ * from 0 to != 0 or from != 0 to 0.
+ *
+ * Return 0 on success or a negative error code on failure.
+ */
+static int isp_pipeline_pm_power_one(struct media_entity *entity, int change)
+{
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV
+	       ? media_entity_to_v4l2_subdev(entity) : NULL;
+
+	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
+		ret = v4l2_subdev_call(subdev, core, s_power, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
+	entity->use_count += change;
+	WARN_ON(entity->use_count < 0);
+
+	if (entity->use_count == 0 && change < 0 && subdev != NULL)
+		v4l2_subdev_call(subdev, core, s_power, 0);
+
+	return 0;
+}
+
+/*
+ * isp_pipeline_pm_power - Apply power change to all entities in a pipeline
+ * @entity: The entity
+ * @change: Use count change
+ *
+ * Walk the pipeline to update the use count and the power state of all non-node
+ * entities.
+ *
+ * Return 0 on success or a negative error code on failure.
+ */
+static int isp_pipeline_pm_power(struct media_entity *entity, int change)
+{
+	struct media_entity_graph graph;
+	struct media_entity *first = entity;
+	int ret = 0;
+
+	if (!change)
+		return 0;
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
+			ret = isp_pipeline_pm_power_one(entity, change);
+
+	if (!ret)
+		return 0;
+
+	media_entity_graph_walk_start(&graph, first);
+
+	while ((first = media_entity_graph_walk_next(&graph))
+	       && first != entity)
+		if (media_entity_type(first) != MEDIA_ENT_T_DEVNODE)
+			isp_pipeline_pm_power_one(first, -change);
+
+	return ret;
+}
+
+/*
+ * omap3isp_pipeline_pm_use - Update the use count of an entity
+ * @entity: The entity
+ * @use: Use (1) or stop using (0) the entity
+ *
+ * Update the use count of all entities in the pipeline and power entities on or
+ * off accordingly.
+ *
+ * Return 0 on success or a negative error code on failure. Powering entities
+ * off is assumed to never fail. No failure can occur when the use parameter is
+ * set to 0.
+ */
+int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
+{
+	int change = use ? 1 : -1;
+	int ret;
+
+	mutex_lock(&entity->parent->graph_mutex);
+
+	/* Apply use count to node. */
+	entity->use_count += change;
+	WARN_ON(entity->use_count < 0);
+
+	/* Apply power change to connected non-nodes. */
+	ret = isp_pipeline_pm_power(entity, change);
+
+	mutex_unlock(&entity->parent->graph_mutex);
+
+	return ret;
+}
+
+/*
+ * isp_pipeline_link_notify - Link management notification callback
+ * @source: Pad at the start of the link
+ * @sink: Pad at the end of the link
+ * @flags: New link flags that will be applied
+ *
+ * React to link management on powered pipelines by updating the use count of
+ * all entities in the source and sink sides of the link. Entities are powered
+ * on or off accordingly.
+ *
+ * Return 0 on success or a negative error code on failure. Powering entities
+ * off is assumed to never fail. This function will not fail for disconnection
+ * events.
+ */
+static int isp_pipeline_link_notify(struct media_pad *source,
+				    struct media_pad *sink, u32 flags)
+{
+	int source_use = isp_pipeline_pm_use_count(source->entity);
+	int sink_use = isp_pipeline_pm_use_count(sink->entity);
+	int ret;
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		/* Powering off entities is assumed to never fail. */
+		isp_pipeline_pm_power(source->entity, -sink_use);
+		isp_pipeline_pm_power(sink->entity, -source_use);
+		return 0;
+	}
+
+	ret = isp_pipeline_pm_power(source->entity, sink_use);
+	if (ret < 0)
+		return ret;
+
+	ret = isp_pipeline_pm_power(sink->entity, source_use);
+	if (ret < 0)
+		isp_pipeline_pm_power(source->entity, -sink_use);
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Pipeline stream management
+ */
+
+/*
+ * isp_pipeline_enable - Enable streaming on a pipeline
+ * @pipe: ISP pipeline
+ * @mode: Stream mode (single shot or continuous)
+ *
+ * Walk the entities chain starting at the pipeline output video node and start
+ * all modules in the chain in the given mode.
+ *
+ * Return 0 if successfull, or the return value of the failed video::s_stream
+ * operation otherwise.
+ */
+static int isp_pipeline_enable(struct isp_pipeline *pipe,
+			       enum isp_pipeline_stream_state mode)
+{
+	struct isp_device *isp = pipe->output->isp;
+	struct media_entity *entity;
+	struct media_pad *pad;
+	struct v4l2_subdev *subdev;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~(ISP_PIPELINE_IDLE_INPUT | ISP_PIPELINE_IDLE_OUTPUT);
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	pipe->do_propagation = false;
+
+	entity = &pipe->output->video.entity;
+	while (1) {
+		pad = &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		entity = pad->entity;
+		subdev = media_entity_to_v4l2_subdev(entity);
+
+		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			break;
+
+		if (subdev == &isp->isp_ccdc.subdev) {
+			v4l2_subdev_call(&isp->isp_aewb.subdev, video,
+					s_stream, mode);
+			v4l2_subdev_call(&isp->isp_af.subdev, video,
+					s_stream, mode);
+			v4l2_subdev_call(&isp->isp_hist.subdev, video,
+					s_stream, mode);
+			pipe->do_propagation = true;
+		}
+	}
+
+	/* Frame number propagation. In continuous streaming mode the number
+	 * is incremented in the frame start ISR. In mem-to-mem mode
+	 * singleshot is used and frame start IRQs are not available.
+	 * Thus we have to increment the number here.
+	 */
+	if (pipe->do_propagation && mode == ISP_PIPELINE_STREAM_SINGLESHOT)
+		atomic_inc(&pipe->frame_number);
+
+	return ret;
+}
+
+static int isp_pipeline_wait_resizer(struct isp_device *isp)
+{
+	return omap3isp_resizer_busy(&isp->isp_res);
+}
+
+static int isp_pipeline_wait_preview(struct isp_device *isp)
+{
+	return omap3isp_preview_busy(&isp->isp_prev);
+}
+
+static int isp_pipeline_wait_ccdc(struct isp_device *isp)
+{
+	return omap3isp_stat_busy(&isp->isp_af)
+	    || omap3isp_stat_busy(&isp->isp_aewb)
+	    || omap3isp_stat_busy(&isp->isp_hist)
+	    || omap3isp_ccdc_busy(&isp->isp_ccdc);
+}
+
+#define ISP_STOP_TIMEOUT	msecs_to_jiffies(1000)
+
+static int isp_pipeline_wait(struct isp_device *isp,
+			     int(*busy)(struct isp_device *isp))
+{
+	unsigned long timeout = jiffies + ISP_STOP_TIMEOUT;
+
+	while (!time_after(jiffies, timeout)) {
+		if (!busy(isp))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * isp_pipeline_disable - Disable streaming on a pipeline
+ * @pipe: ISP pipeline
+ *
+ * Walk the entities chain starting at the pipeline output video node and stop
+ * all modules in the chain. Wait synchronously for the modules to be stopped if
+ * necessary.
+ *
+ * Return 0 if all modules have been properly stopped, or -ETIMEDOUT if a module
+ * can't be stopped (in which case a software reset of the ISP is probably
+ * necessary).
+ */
+static int isp_pipeline_disable(struct isp_pipeline *pipe)
+{
+	struct isp_device *isp = pipe->output->isp;
+	struct media_entity *entity;
+	struct media_pad *pad;
+	struct v4l2_subdev *subdev;
+	int failure = 0;
+	int ret;
+
+	/*
+	 * We need to stop all the modules after CCDC first or they'll
+	 * never stop since they may not get a full frame from CCDC.
+	 */
+	entity = &pipe->output->video.entity;
+	while (1) {
+		pad = &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		entity = pad->entity;
+		subdev = media_entity_to_v4l2_subdev(entity);
+
+		if (subdev == &isp->isp_ccdc.subdev) {
+			v4l2_subdev_call(&isp->isp_aewb.subdev,
+					 video, s_stream, 0);
+			v4l2_subdev_call(&isp->isp_af.subdev,
+					 video, s_stream, 0);
+			v4l2_subdev_call(&isp->isp_hist.subdev,
+					 video, s_stream, 0);
+		}
+
+		v4l2_subdev_call(subdev, video, s_stream, 0);
+
+		if (subdev == &isp->isp_res.subdev)
+			ret = isp_pipeline_wait(isp, isp_pipeline_wait_resizer);
+		else if (subdev == &isp->isp_prev.subdev)
+			ret = isp_pipeline_wait(isp, isp_pipeline_wait_preview);
+		else if (subdev == &isp->isp_ccdc.subdev)
+			ret = isp_pipeline_wait(isp, isp_pipeline_wait_ccdc);
+		else
+			ret = 0;
+
+		if (ret) {
+			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
+			failure = -ETIMEDOUT;
+		}
+	}
+
+	return failure;
+}
+
+/*
+ * omap3isp_pipeline_set_stream - Enable/disable streaming on a pipeline
+ * @pipe: ISP pipeline
+ * @state: Stream state (stopped, single shot or continuous)
+ *
+ * Set the pipeline to the given stream state. Pipelines can be started in
+ * single-shot or continuous mode.
+ *
+ * Return 0 if successfull, or the return value of the failed video::s_stream
+ * operation otherwise.
+ */
+int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
+				 enum isp_pipeline_stream_state state)
+{
+	int ret;
+
+	if (state == ISP_PIPELINE_STREAM_STOPPED)
+		ret = isp_pipeline_disable(pipe);
+	else
+		ret = isp_pipeline_enable(pipe, state);
+	pipe->stream_state = state;
+
+	return ret;
+}
+
+/*
+ * isp_pipeline_resume - Resume streaming on a pipeline
+ * @pipe: ISP pipeline
+ *
+ * Resume video output and input and re-enable pipeline.
+ */
+static void isp_pipeline_resume(struct isp_pipeline *pipe)
+{
+	int singleshot = pipe->stream_state == ISP_PIPELINE_STREAM_SINGLESHOT;
+
+	omap3isp_video_resume(pipe->output, !singleshot);
+	if (singleshot)
+		omap3isp_video_resume(pipe->input, 0);
+	isp_pipeline_enable(pipe, pipe->stream_state);
+}
+
+/*
+ * isp_pipeline_suspend - Suspend streaming on a pipeline
+ * @pipe: ISP pipeline
+ *
+ * Suspend pipeline.
+ */
+static void isp_pipeline_suspend(struct isp_pipeline *pipe)
+{
+	isp_pipeline_disable(pipe);
+}
+
+/*
+ * isp_pipeline_is_last - Verify if entity has an enabled link to the output
+ * 			  video node
+ * @me: ISP module's media entity
+ *
+ * Returns 1 if the entity has an enabled link to the output video node or 0
+ * otherwise. It's true only while pipeline can have no more than one output
+ * node.
+ */
+static int isp_pipeline_is_last(struct media_entity *me)
+{
+	struct isp_pipeline *pipe;
+	struct media_pad *pad;
+
+	if (!me->pipe)
+		return 0;
+	pipe = to_isp_pipeline(me);
+	if (pipe->stream_state == ISP_PIPELINE_STREAM_STOPPED)
+		return 0;
+	pad = media_entity_remote_source(&pipe->output->pad);
+	return pad->entity == me;
+}
+
+/*
+ * isp_suspend_module_pipeline - Suspend pipeline to which belongs the module
+ * @me: ISP module's media entity
+ *
+ * Suspend the whole pipeline if module's entity has an enabled link to the
+ * output video node. It works only while pipeline can have no more than one
+ * output node.
+ */
+static void isp_suspend_module_pipeline(struct media_entity *me)
+{
+	if (isp_pipeline_is_last(me))
+		isp_pipeline_suspend(to_isp_pipeline(me));
+}
+
+/*
+ * isp_resume_module_pipeline - Resume pipeline to which belongs the module
+ * @me: ISP module's media entity
+ *
+ * Resume the whole pipeline if module's entity has an enabled link to the
+ * output video node. It works only while pipeline can have no more than one
+ * output node.
+ */
+static void isp_resume_module_pipeline(struct media_entity *me)
+{
+	if (isp_pipeline_is_last(me))
+		isp_pipeline_resume(to_isp_pipeline(me));
+}
+
+/*
+ * isp_suspend_modules - Suspend ISP submodules.
+ * @isp: OMAP3 ISP device
+ *
+ * Returns 0 if suspend left in idle state all the submodules properly,
+ * or returns 1 if a general Reset is required to suspend the submodules.
+ */
+static int isp_suspend_modules(struct isp_device *isp)
+{
+	unsigned long timeout;
+
+	omap3isp_stat_suspend(&isp->isp_aewb);
+	omap3isp_stat_suspend(&isp->isp_af);
+	omap3isp_stat_suspend(&isp->isp_hist);
+	isp_suspend_module_pipeline(&isp->isp_res.subdev.entity);
+	isp_suspend_module_pipeline(&isp->isp_prev.subdev.entity);
+	isp_suspend_module_pipeline(&isp->isp_ccdc.subdev.entity);
+	isp_suspend_module_pipeline(&isp->isp_csi2a.subdev.entity);
+	isp_suspend_module_pipeline(&isp->isp_ccp2.subdev.entity);
+
+	timeout = jiffies + ISP_STOP_TIMEOUT;
+	while (omap3isp_stat_busy(&isp->isp_af)
+	    || omap3isp_stat_busy(&isp->isp_aewb)
+	    || omap3isp_stat_busy(&isp->isp_hist)
+	    || omap3isp_preview_busy(&isp->isp_prev)
+	    || omap3isp_resizer_busy(&isp->isp_res)
+	    || omap3isp_ccdc_busy(&isp->isp_ccdc)) {
+		if (time_after(jiffies, timeout)) {
+			dev_info(isp->dev, "can't stop modules.\n");
+			return 1;
+		}
+		msleep(1);
+	}
+
+	return 0;
+}
+
+/*
+ * isp_resume_modules - Resume ISP submodules.
+ * @isp: OMAP3 ISP device
+ */
+static void isp_resume_modules(struct isp_device *isp)
+{
+	omap3isp_stat_resume(&isp->isp_aewb);
+	omap3isp_stat_resume(&isp->isp_af);
+	omap3isp_stat_resume(&isp->isp_hist);
+	isp_resume_module_pipeline(&isp->isp_res.subdev.entity);
+	isp_resume_module_pipeline(&isp->isp_prev.subdev.entity);
+	isp_resume_module_pipeline(&isp->isp_ccdc.subdev.entity);
+	isp_resume_module_pipeline(&isp->isp_csi2a.subdev.entity);
+	isp_resume_module_pipeline(&isp->isp_ccp2.subdev.entity);
+}
+
+/*
+ * isp_reset - Reset ISP with a timeout wait for idle.
+ * @isp: OMAP3 ISP device
+ */
+static int isp_reset(struct isp_device *isp)
+{
+	unsigned long timeout = 0;
+
+	isp_reg_writel(isp,
+		       isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG)
+		       | ISP_SYSCONFIG_SOFTRESET,
+		       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
+	while (!(isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN,
+			       ISP_SYSSTATUS) & 0x1)) {
+		if (timeout++ > 10000) {
+			dev_alert(isp->dev, "cannot reset ISP\n");
+			return -ETIMEDOUT;
+		}
+		udelay(1);
+	}
+
+	return 0;
+}
+
+/*
+ * isp_save_context - Saves the values of the ISP module registers.
+ * @isp: OMAP3 ISP device
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ */
+static void
+isp_save_context(struct isp_device *isp, struct isp_reg *reg_list)
+{
+	struct isp_reg *next = reg_list;
+
+	for (; next->reg != ISP_TOK_TERM; next++)
+		next->val = isp_reg_readl(isp, next->mmio_range, next->reg);
+}
+
+/*
+ * isp_restore_context - Restores the values of the ISP module registers.
+ * @isp: OMAP3 ISP device
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ */
+static void
+isp_restore_context(struct isp_device *isp, struct isp_reg *reg_list)
+{
+	struct isp_reg *next = reg_list;
+
+	for (; next->reg != ISP_TOK_TERM; next++)
+		isp_reg_writel(isp, next->val, next->mmio_range, next->reg);
+}
+
+/*
+ * isp_save_ctx - Saves ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ * @isp: OMAP3 ISP device
+ *
+ * Routine for saving the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ */
+static void isp_save_ctx(struct isp_device *isp)
+{
+	isp_save_context(isp, isp_reg_list);
+	if (isp->iommu)
+		iommu_save_ctx(isp->iommu);
+}
+
+/*
+ * isp_restore_ctx - Restores ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ * @isp: OMAP3 ISP device
+ *
+ * Routine for restoring the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ */
+static void isp_restore_ctx(struct isp_device *isp)
+{
+	isp_restore_context(isp, isp_reg_list);
+	if (isp->iommu)
+		iommu_restore_ctx(isp->iommu);
+	omap3isp_ccdc_restore_context(isp);
+	omap3isp_preview_restore_context(isp);
+}
+
+/* -----------------------------------------------------------------------------
+ * SBL resources management
+ */
+#define OMAP3_ISP_SBL_READ	(OMAP3_ISP_SBL_CSI1_READ | \
+				 OMAP3_ISP_SBL_CCDC_LSC_READ | \
+				 OMAP3_ISP_SBL_PREVIEW_READ | \
+				 OMAP3_ISP_SBL_RESIZER_READ)
+#define OMAP3_ISP_SBL_WRITE	(OMAP3_ISP_SBL_CSI1_WRITE | \
+				 OMAP3_ISP_SBL_CSI2A_WRITE | \
+				 OMAP3_ISP_SBL_CSI2C_WRITE | \
+				 OMAP3_ISP_SBL_CCDC_WRITE | \
+				 OMAP3_ISP_SBL_PREVIEW_WRITE)
+
+void omap3isp_sbl_enable(struct isp_device *isp, enum isp_sbl_resource res)
+{
+	u32 sbl = 0;
+
+	isp->sbl_resources |= res;
+
+	if (isp->sbl_resources & OMAP3_ISP_SBL_CSI1_READ)
+		sbl |= ISPCTRL_SBL_SHARED_RPORTA;
+
+	if (isp->sbl_resources & OMAP3_ISP_SBL_CCDC_LSC_READ)
+		sbl |= ISPCTRL_SBL_SHARED_RPORTB;
+
+	if (isp->sbl_resources & OMAP3_ISP_SBL_CSI2C_WRITE)
+		sbl |= ISPCTRL_SBL_SHARED_WPORTC;
+
+	if (isp->sbl_resources & OMAP3_ISP_SBL_RESIZER_WRITE)
+		sbl |= ISPCTRL_SBL_WR0_RAM_EN;
+
+	if (isp->sbl_resources & OMAP3_ISP_SBL_WRITE)
+		sbl |= ISPCTRL_SBL_WR1_RAM_EN;
+
+	if (isp->sbl_resources & OMAP3_ISP_SBL_READ)
+		sbl |= ISPCTRL_SBL_RD_RAM_EN;
+
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, sbl);
+}
+
+void omap3isp_sbl_disable(struct isp_device *isp, enum isp_sbl_resource res)
+{
+	u32 sbl = 0;
+
+	isp->sbl_resources &= ~res;
+
+	if (!(isp->sbl_resources & OMAP3_ISP_SBL_CSI1_READ))
+		sbl |= ISPCTRL_SBL_SHARED_RPORTA;
+
+	if (!(isp->sbl_resources & OMAP3_ISP_SBL_CCDC_LSC_READ))
+		sbl |= ISPCTRL_SBL_SHARED_RPORTB;
+
+	if (!(isp->sbl_resources & OMAP3_ISP_SBL_CSI2C_WRITE))
+		sbl |= ISPCTRL_SBL_SHARED_WPORTC;
+
+	if (!(isp->sbl_resources & OMAP3_ISP_SBL_RESIZER_WRITE))
+		sbl |= ISPCTRL_SBL_WR0_RAM_EN;
+
+	if (!(isp->sbl_resources & OMAP3_ISP_SBL_WRITE))
+		sbl |= ISPCTRL_SBL_WR1_RAM_EN;
+
+	if (!(isp->sbl_resources & OMAP3_ISP_SBL_READ))
+		sbl |= ISPCTRL_SBL_RD_RAM_EN;
+
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, sbl);
+}
+
+/*
+ * isp_module_sync_idle - Helper to sync module with its idle state
+ * @me: ISP submodule's media entity
+ * @wait: ISP submodule's wait queue for streamoff/interrupt synchronization
+ * @stopping: flag which tells module wants to stop
+ *
+ * This function checks if ISP submodule needs to wait for next interrupt. If
+ * yes, makes the caller to sleep while waiting for such event.
+ */
+int omap3isp_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
+			      atomic_t *stopping)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(me);
+
+	if (pipe->stream_state == ISP_PIPELINE_STREAM_STOPPED ||
+	    (pipe->stream_state == ISP_PIPELINE_STREAM_SINGLESHOT &&
+	     !isp_pipeline_ready(pipe)))
+		return 0;
+
+	/*
+	 * atomic_set() doesn't include memory barrier on ARM platform for SMP
+	 * scenario. We'll call it here to avoid race conditions.
+	 */
+	atomic_set(stopping, 1);
+	smp_mb();
+
+	/*
+	 * If module is the last one, it's writing to memory. In this case,
+	 * it's necessary to check if the module is already paused due to
+	 * DMA queue underrun or if it has to wait for next interrupt to be
+	 * idle.
+	 * If it isn't the last one, the function won't sleep but *stopping
+	 * will still be set to warn next submodule caller's interrupt the
+	 * module wants to be idle.
+	 */
+	if (isp_pipeline_is_last(me)) {
+		struct isp_video *video = pipe->output;
+		unsigned long flags;
+		spin_lock_irqsave(&video->queue->irqlock, flags);
+		if (video->dmaqueue_flags & ISP_VIDEO_DMAQUEUE_UNDERRUN) {
+			spin_unlock_irqrestore(&video->queue->irqlock, flags);
+			atomic_set(stopping, 0);
+			smp_mb();
+			return 0;
+		}
+		spin_unlock_irqrestore(&video->queue->irqlock, flags);
+		if (!wait_event_timeout(*wait, !atomic_read(stopping),
+					msecs_to_jiffies(1000))) {
+			atomic_set(stopping, 0);
+			smp_mb();
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * omap3isp_module_sync_is_stopped - Helper to verify if module was stopping
+ * @wait: ISP submodule's wait queue for streamoff/interrupt synchronization
+ * @stopping: flag which tells module wants to stop
+ *
+ * This function checks if ISP submodule was stopping. In case of yes, it
+ * notices the caller by setting stopping to 0 and waking up the wait queue.
+ * Returns 1 if it was stopping or 0 otherwise.
+ */
+int omap3isp_module_sync_is_stopping(wait_queue_head_t *wait,
+				     atomic_t *stopping)
+{
+	if (atomic_cmpxchg(stopping, 1, 0)) {
+		wake_up(wait);
+		return 1;
+	}
+
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * Clock management
+ */
+
+#define ISPCTRL_CLKS_MASK	(ISPCTRL_H3A_CLK_EN | \
+				 ISPCTRL_HIST_CLK_EN | \
+				 ISPCTRL_RSZ_CLK_EN | \
+				 (ISPCTRL_CCDC_CLK_EN | ISPCTRL_CCDC_RAM_EN) | \
+				 (ISPCTRL_PREV_CLK_EN | ISPCTRL_PREV_RAM_EN))
+
+static void __isp_subclk_update(struct isp_device *isp)
+{
+	u32 clk = 0;
+
+	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_H3A)
+		clk |= ISPCTRL_H3A_CLK_EN;
+
+	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_HIST)
+		clk |= ISPCTRL_HIST_CLK_EN;
+
+	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_RESIZER)
+		clk |= ISPCTRL_RSZ_CLK_EN;
+
+	/* NOTE: For CCDC & Preview submodules, we need to affect internal
+	 *       RAM aswell.
+	 */
+	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_CCDC)
+		clk |= ISPCTRL_CCDC_CLK_EN | ISPCTRL_CCDC_RAM_EN;
+
+	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_PREVIEW)
+		clk |= ISPCTRL_PREV_CLK_EN | ISPCTRL_PREV_RAM_EN;
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
+			ISPCTRL_CLKS_MASK, clk);
+}
+
+void omap3isp_subclk_enable(struct isp_device *isp,
+			    enum isp_subclk_resource res)
+{
+	isp->subclk_resources |= res;
+
+	__isp_subclk_update(isp);
+}
+
+void omap3isp_subclk_disable(struct isp_device *isp,
+			     enum isp_subclk_resource res)
+{
+	isp->subclk_resources &= ~res;
+
+	__isp_subclk_update(isp);
+}
+
+/*
+ * isp_enable_clocks - Enable ISP clocks
+ * @isp: OMAP3 ISP device
+ *
+ * Return 0 if successful, or clk_enable return value if any of tthem fails.
+ */
+static int isp_enable_clocks(struct isp_device *isp)
+{
+	int r;
+	unsigned long rate;
+	int divisor;
+
+	/*
+	 * cam_mclk clock chain:
+	 *   dpll4 -> dpll4_m5 -> dpll4_m5x2 -> cam_mclk
+	 *
+	 * In OMAP3630 dpll4_m5x2 != 2 x dpll4_m5 but both are
+	 * set to the same value. Hence the rate set for dpll4_m5
+	 * has to be twice of what is set on OMAP3430 to get
+	 * the required value for cam_mclk
+	 */
+	if (cpu_is_omap3630())
+		divisor = 1;
+	else
+		divisor = 2;
+
+	r = clk_enable(isp->clock[ISP_CLK_CAM_ICK]);
+	if (r) {
+		dev_err(isp->dev, "clk_enable cam_ick failed\n");
+		goto out_clk_enable_ick;
+	}
+	r = clk_set_rate(isp->clock[ISP_CLK_DPLL4_M5_CK],
+			 CM_CAM_MCLK_HZ/divisor);
+	if (r) {
+		dev_err(isp->dev, "clk_set_rate for dpll4_m5_ck failed\n");
+		goto out_clk_enable_mclk;
+	}
+	r = clk_enable(isp->clock[ISP_CLK_CAM_MCLK]);
+	if (r) {
+		dev_err(isp->dev, "clk_enable cam_mclk failed\n");
+		goto out_clk_enable_mclk;
+	}
+	rate = clk_get_rate(isp->clock[ISP_CLK_CAM_MCLK]);
+	if (rate != CM_CAM_MCLK_HZ)
+		dev_warn(isp->dev, "unexpected cam_mclk rate:\n"
+				   " expected : %d\n"
+				   " actual   : %ld\n", CM_CAM_MCLK_HZ, rate);
+	r = clk_enable(isp->clock[ISP_CLK_CSI2_FCK]);
+	if (r) {
+		dev_err(isp->dev, "clk_enable csi2_fck failed\n");
+		goto out_clk_enable_csi2_fclk;
+	}
+	return 0;
+
+out_clk_enable_csi2_fclk:
+	clk_disable(isp->clock[ISP_CLK_CAM_MCLK]);
+out_clk_enable_mclk:
+	clk_disable(isp->clock[ISP_CLK_CAM_ICK]);
+out_clk_enable_ick:
+	return r;
+}
+
+/*
+ * isp_disable_clocks - Disable ISP clocks
+ * @isp: OMAP3 ISP device
+ */
+static void isp_disable_clocks(struct isp_device *isp)
+{
+	clk_disable(isp->clock[ISP_CLK_CAM_ICK]);
+	clk_disable(isp->clock[ISP_CLK_CAM_MCLK]);
+	clk_disable(isp->clock[ISP_CLK_CSI2_FCK]);
+}
+
+static const char *isp_clocks[] = {
+	"cam_ick",
+	"cam_mclk",
+	"dpll4_m5_ck",
+	"csi2_96m_fck",
+	"l3_ick",
+};
+
+static void isp_put_clocks(struct isp_device *isp)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
+		if (isp->clock[i]) {
+			clk_put(isp->clock[i]);
+			isp->clock[i] = NULL;
+		}
+	}
+}
+
+static int isp_get_clocks(struct isp_device *isp)
+{
+	struct clk *clk;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
+		clk = clk_get(isp->dev, isp_clocks[i]);
+		if (IS_ERR(clk)) {
+			dev_err(isp->dev, "clk_get %s failed\n", isp_clocks[i]);
+			isp_put_clocks(isp);
+			return PTR_ERR(clk);
+		}
+
+		isp->clock[i] = clk;
+	}
+
+	return 0;
+}
+
+/*
+ * omap3isp_get - Acquire the ISP resource.
+ *
+ * Initializes the clocks for the first acquire.
+ *
+ * Increment the reference count on the ISP. If the first reference is taken,
+ * enable clocks and power-up all submodules.
+ *
+ * Return a pointer to the ISP device structure, or NULL if an error occured.
+ */
+struct isp_device *omap3isp_get(struct isp_device *isp)
+{
+	struct isp_device *__isp = isp;
+
+	if (isp == NULL)
+		return NULL;
+
+	mutex_lock(&isp->isp_mutex);
+	if (isp->ref_count > 0)
+		goto out;
+
+	if (isp_enable_clocks(isp) < 0) {
+		__isp = NULL;
+		goto out;
+	}
+
+	/* We don't want to restore context before saving it! */
+	if (isp->has_context)
+		isp_restore_ctx(isp);
+	else
+		isp->has_context = 1;
+
+	isp_enable_interrupts(isp);
+
+out:
+	if (__isp != NULL)
+		isp->ref_count++;
+	mutex_unlock(&isp->isp_mutex);
+
+	return __isp;
+}
+
+/*
+ * omap3isp_put - Release the ISP
+ *
+ * Decrement the reference count on the ISP. If the last reference is released,
+ * power-down all submodules, disable clocks and free temporary buffers.
+ */
+void omap3isp_put(struct isp_device *isp)
+{
+	if (isp == NULL)
+		return;
+
+	mutex_lock(&isp->isp_mutex);
+	BUG_ON(isp->ref_count == 0);
+	if (--isp->ref_count == 0) {
+		isp_disable_interrupts(isp);
+		isp_save_ctx(isp);
+		isp_disable_clocks(isp);
+	}
+	mutex_unlock(&isp->isp_mutex);
+}
+
+/* --------------------------------------------------------------------------
+ * Platform device driver
+ */
+
+/*
+ * omap3isp_print_status - Prints the values of the ISP Control Module registers
+ * @isp: OMAP3 ISP device
+ */
+#define ISP_PRINT_REGISTER(isp, name)\
+	dev_dbg(isp->dev, "###ISP " #name "=0x%08x\n", \
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_##name))
+#define SBL_PRINT_REGISTER(isp, name)\
+	dev_dbg(isp->dev, "###SBL " #name "=0x%08x\n", \
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_##name))
+
+void omap3isp_print_status(struct isp_device *isp)
+{
+	dev_dbg(isp->dev, "-------------ISP Register dump--------------\n");
+
+	ISP_PRINT_REGISTER(isp, SYSCONFIG);
+	ISP_PRINT_REGISTER(isp, SYSSTATUS);
+	ISP_PRINT_REGISTER(isp, IRQ0ENABLE);
+	ISP_PRINT_REGISTER(isp, IRQ0STATUS);
+	ISP_PRINT_REGISTER(isp, TCTRL_GRESET_LENGTH);
+	ISP_PRINT_REGISTER(isp, TCTRL_PSTRB_REPLAY);
+	ISP_PRINT_REGISTER(isp, CTRL);
+	ISP_PRINT_REGISTER(isp, TCTRL_CTRL);
+	ISP_PRINT_REGISTER(isp, TCTRL_FRAME);
+	ISP_PRINT_REGISTER(isp, TCTRL_PSTRB_DELAY);
+	ISP_PRINT_REGISTER(isp, TCTRL_STRB_DELAY);
+	ISP_PRINT_REGISTER(isp, TCTRL_SHUT_DELAY);
+	ISP_PRINT_REGISTER(isp, TCTRL_PSTRB_LENGTH);
+	ISP_PRINT_REGISTER(isp, TCTRL_STRB_LENGTH);
+	ISP_PRINT_REGISTER(isp, TCTRL_SHUT_LENGTH);
+
+	SBL_PRINT_REGISTER(isp, PCR);
+	SBL_PRINT_REGISTER(isp, SDR_REQ_EXP);
+
+	dev_dbg(isp->dev, "--------------------------------------------\n");
+}
+
+#ifdef CONFIG_PM
+
+/*
+ * Power management support.
+ *
+ * As the ISP can't properly handle an input video stream interruption on a non
+ * frame boundary, the ISP pipelines need to be stopped before sensors get
+ * suspended. However, as suspending the sensors can require a running clock,
+ * which can be provided by the ISP, the ISP can't be completely suspended
+ * before the sensor.
+ *
+ * To solve this problem power management support is split into prepare/complete
+ * and suspend/resume operations. The pipelines are stopped in prepare() and the
+ * ISP clocks get disabled in suspend(). Similarly, the clocks are reenabled in
+ * resume(), and the the pipelines are restarted in complete().
+ *
+ * TODO: PM dependencies between the ISP and sensors are not modeled explicitly
+ * yet.
+ */
+static int isp_pm_prepare(struct device *dev)
+{
+	struct isp_device *isp = dev_get_drvdata(dev);
+	int reset;
+
+	WARN_ON(mutex_is_locked(&isp->isp_mutex));
+
+	if (isp->ref_count == 0)
+		return 0;
+
+	reset = isp_suspend_modules(isp);
+	isp_disable_interrupts(isp);
+	isp_save_ctx(isp);
+	if (reset)
+		isp_reset(isp);
+
+	return 0;
+}
+
+static int isp_pm_suspend(struct device *dev)
+{
+	struct isp_device *isp = dev_get_drvdata(dev);
+
+	WARN_ON(mutex_is_locked(&isp->isp_mutex));
+
+	if (isp->ref_count)
+		isp_disable_clocks(isp);
+
+	return 0;
+}
+
+static int isp_pm_resume(struct device *dev)
+{
+	struct isp_device *isp = dev_get_drvdata(dev);
+
+	if (isp->ref_count == 0)
+		return 0;
+
+	return isp_enable_clocks(isp);
+}
+
+static void isp_pm_complete(struct device *dev)
+{
+	struct isp_device *isp = dev_get_drvdata(dev);
+
+	if (isp->ref_count == 0)
+		return;
+
+	isp_restore_ctx(isp);
+	isp_enable_interrupts(isp);
+	isp_resume_modules(isp);
+}
+
+#else
+
+#define isp_pm_prepare	NULL
+#define isp_pm_suspend	NULL
+#define isp_pm_resume	NULL
+#define isp_pm_complete	NULL
+
+#endif /* CONFIG_PM */
+
+static void isp_unregister_entities(struct isp_device *isp)
+{
+	omap3isp_csi2_unregister_entities(&isp->isp_csi2a);
+	omap3isp_ccp2_unregister_entities(&isp->isp_ccp2);
+	omap3isp_ccdc_unregister_entities(&isp->isp_ccdc);
+	omap3isp_preview_unregister_entities(&isp->isp_prev);
+	omap3isp_resizer_unregister_entities(&isp->isp_res);
+	omap3isp_stat_unregister_entities(&isp->isp_aewb);
+	omap3isp_stat_unregister_entities(&isp->isp_af);
+	omap3isp_stat_unregister_entities(&isp->isp_hist);
+
+	v4l2_device_unregister(&isp->v4l2_dev);
+	media_device_unregister(&isp->media_dev);
+}
+
+/*
+ * isp_register_subdev_group - Register a group of subdevices
+ * @isp: OMAP3 ISP device
+ * @board_info: I2C subdevs board information array
+ *
+ * Register all I2C subdevices in the board_info array. The array must be
+ * terminated by a NULL entry, and the first entry must be the sensor.
+ *
+ * Return a pointer to the sensor media entity if it has been successfully
+ * registered, or NULL otherwise.
+ */
+static struct v4l2_subdev *
+isp_register_subdev_group(struct isp_device *isp,
+		     struct isp_subdev_i2c_board_info *board_info)
+{
+	struct v4l2_subdev *sensor = NULL;
+	unsigned int first;
+
+	if (board_info->board_info == NULL)
+		return NULL;
+
+	for (first = 1; board_info->board_info; ++board_info, first = 0) {
+		struct v4l2_subdev *subdev;
+		struct i2c_adapter *adapter;
+
+		adapter = i2c_get_adapter(board_info->i2c_adapter_id);
+		if (adapter == NULL) {
+			printk(KERN_ERR "%s: Unable to get I2C adapter %d for "
+				"device %s\n", __func__,
+				board_info->i2c_adapter_id,
+				board_info->board_info->type);
+			continue;
+		}
+
+		subdev = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
+				board_info->board_info, NULL);
+		if (subdev == NULL) {
+			printk(KERN_ERR "%s: Unable to register subdev %s\n",
+				__func__, board_info->board_info->type);
+			continue;
+		}
+
+		if (first)
+			sensor = subdev;
+	}
+
+	return sensor;
+}
+
+static int isp_register_entities(struct isp_device *isp)
+{
+	struct isp_platform_data *pdata = isp->pdata;
+	struct isp_v4l2_subdevs_group *subdevs;
+	int ret;
+
+	isp->media_dev.dev = isp->dev;
+	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
+		sizeof(isp->media_dev.model));
+	isp->media_dev.link_notify = isp_pipeline_link_notify;
+	ret = media_device_register(&isp->media_dev);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: Media device registration failed (%d)\n",
+			__func__, ret);
+		return ret;
+	}
+
+	isp->v4l2_dev.mdev = &isp->media_dev;
+	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: V4L2 device registration failed (%d)\n",
+			__func__, ret);
+		goto done;
+	}
+
+	/* Register internal entities */
+	ret = omap3isp_ccp2_register_entities(&isp->isp_ccp2, &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap3isp_csi2_register_entities(&isp->isp_csi2a, &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap3isp_ccdc_register_entities(&isp->isp_ccdc, &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap3isp_preview_register_entities(&isp->isp_prev,
+						 &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap3isp_resizer_register_entities(&isp->isp_res, &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap3isp_stat_register_entities(&isp->isp_aewb, &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap3isp_stat_register_entities(&isp->isp_af, &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = omap3isp_stat_register_entities(&isp->isp_hist, &isp->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	/* Register external entities */
+	for (subdevs = pdata->subdevs; subdevs->subdevs; ++subdevs) {
+		struct v4l2_subdev *sensor;
+		struct media_entity *input;
+		unsigned int flags;
+		unsigned int pad;
+
+		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
+		if (sensor == NULL)
+			continue;
+
+		sensor->host_priv = subdevs;
+
+		/* Connect the sensor to the correct interface module. Parallel
+		 * sensors are connected directly to the CCDC, while serial
+		 * sensors are connected to the CSI2a, CCP2b or CSI2c receiver
+		 * through CSIPHY1 or CSIPHY2.
+		 */
+		switch (subdevs->interface) {
+		case ISP_INTERFACE_PARALLEL:
+			input = &isp->isp_ccdc.subdev.entity;
+			pad = CCDC_PAD_SINK;
+			flags = 0;
+			break;
+
+		case ISP_INTERFACE_CSI2A_PHY2:
+			input = &isp->isp_csi2a.subdev.entity;
+			pad = CSI2_PAD_SINK;
+			flags = MEDIA_LNK_FL_IMMUTABLE
+			      | MEDIA_LNK_FL_ENABLED;
+			break;
+
+		case ISP_INTERFACE_CCP2B_PHY1:
+		case ISP_INTERFACE_CCP2B_PHY2:
+			input = &isp->isp_ccp2.subdev.entity;
+			pad = CCP2_PAD_SINK;
+			flags = 0;
+			break;
+
+		case ISP_INTERFACE_CSI2C_PHY1:
+			input = &isp->isp_csi2c.subdev.entity;
+			pad = CSI2_PAD_SINK;
+			flags = MEDIA_LNK_FL_IMMUTABLE
+			      | MEDIA_LNK_FL_ENABLED;
+			break;
+
+		default:
+			printk(KERN_ERR "%s: invalid interface type %u\n",
+			       __func__, subdevs->interface);
+			ret = -EINVAL;
+			goto done;
+		}
+
+		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
+					       flags);
+		if (ret < 0)
+			goto done;
+	}
+
+	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
+
+done:
+	if (ret < 0)
+		isp_unregister_entities(isp);
+
+	return ret;
+}
+
+static void isp_cleanup_modules(struct isp_device *isp)
+{
+	omap3isp_h3a_aewb_cleanup(isp);
+	omap3isp_h3a_af_cleanup(isp);
+	omap3isp_hist_cleanup(isp);
+	omap3isp_resizer_cleanup(isp);
+	omap3isp_preview_cleanup(isp);
+	omap3isp_ccdc_cleanup(isp);
+	omap3isp_ccp2_cleanup(isp);
+	omap3isp_csi2_cleanup(isp);
+}
+
+static int isp_initialize_modules(struct isp_device *isp)
+{
+	int ret;
+
+	ret = omap3isp_csiphy_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "CSI PHY initialization failed\n");
+		goto error_csiphy;
+	}
+
+	ret = omap3isp_csi2_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "CSI2 initialization failed\n");
+		goto error_csi2;
+	}
+
+	ret = omap3isp_ccp2_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "CCP2 initialization failed\n");
+		goto error_ccp2;
+	}
+
+	ret = omap3isp_ccdc_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "CCDC initialization failed\n");
+		goto error_ccdc;
+	}
+
+	ret = omap3isp_preview_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "Preview initialization failed\n");
+		goto error_preview;
+	}
+
+	ret = omap3isp_resizer_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "Resizer initialization failed\n");
+		goto error_resizer;
+	}
+
+	ret = omap3isp_hist_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "Histogram initialization failed\n");
+		goto error_hist;
+	}
+
+	ret = omap3isp_h3a_aewb_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "H3A AEWB initialization failed\n");
+		goto error_h3a_aewb;
+	}
+
+	ret = omap3isp_h3a_af_init(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "H3A AF initialization failed\n");
+		goto error_h3a_af;
+	}
+
+	/* Connect the submodules. */
+	ret = media_entity_create_link(
+			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SOURCE,
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
+			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
+			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_aewb.subdev.entity, 0,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_af.subdev.entity, 0,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (ret < 0)
+		goto error_link;
+
+	ret = media_entity_create_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_hist.subdev.entity, 0,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (ret < 0)
+		goto error_link;
+
+	return 0;
+
+error_link:
+	omap3isp_h3a_af_cleanup(isp);
+error_h3a_af:
+	omap3isp_h3a_aewb_cleanup(isp);
+error_h3a_aewb:
+	omap3isp_hist_cleanup(isp);
+error_hist:
+	omap3isp_resizer_cleanup(isp);
+error_resizer:
+	omap3isp_preview_cleanup(isp);
+error_preview:
+	omap3isp_ccdc_cleanup(isp);
+error_ccdc:
+	omap3isp_ccp2_cleanup(isp);
+error_ccp2:
+	omap3isp_csi2_cleanup(isp);
+error_csi2:
+error_csiphy:
+	return ret;
+}
+
+/*
+ * isp_remove - Remove ISP platform device
+ * @pdev: Pointer to ISP platform device
+ *
+ * Always returns 0.
+ */
+static int isp_remove(struct platform_device *pdev)
+{
+	struct isp_device *isp = platform_get_drvdata(pdev);
+	int i;
+
+	isp_unregister_entities(isp);
+	isp_cleanup_modules(isp);
+
+	omap3isp_get(isp);
+	iommu_put(isp->iommu);
+	omap3isp_put(isp);
+
+	free_irq(isp->irq_num, isp);
+	isp_put_clocks(isp);
+
+	for (i = 0; i < OMAP3_ISP_IOMEM_LAST; i++) {
+		if (isp->mmio_base[i]) {
+			iounmap(isp->mmio_base[i]);
+			isp->mmio_base[i] = NULL;
+		}
+
+		if (isp->mmio_base_phys[i]) {
+			release_mem_region(isp->mmio_base_phys[i],
+					   isp->mmio_size[i]);
+			isp->mmio_base_phys[i] = 0;
+		}
+	}
+
+	regulator_put(isp->isp_csiphy1.vdd);
+	regulator_put(isp->isp_csiphy2.vdd);
+	kfree(isp);
+
+	return 0;
+}
+
+static int isp_map_mem_resource(struct platform_device *pdev,
+				struct isp_device *isp,
+				enum isp_mem_resources res)
+{
+	struct resource *mem;
+
+	/* request the mem region for the camera registers */
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, res);
+	if (!mem) {
+		dev_err(isp->dev, "no mem resource?\n");
+		return -ENODEV;
+	}
+
+	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
+		dev_err(isp->dev,
+			"cannot reserve camera register I/O region\n");
+		return -ENODEV;
+	}
+	isp->mmio_base_phys[res] = mem->start;
+	isp->mmio_size[res] = resource_size(mem);
+
+	/* map the region */
+	isp->mmio_base[res] = ioremap_nocache(isp->mmio_base_phys[res],
+					      isp->mmio_size[res]);
+	if (!isp->mmio_base[res]) {
+		dev_err(isp->dev, "cannot map camera register I/O region\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * isp_probe - Probe ISP platform device
+ * @pdev: Pointer to ISP platform device
+ *
+ * Returns 0 if successful,
+ *   -ENOMEM if no memory available,
+ *   -ENODEV if no platform device resources found
+ *     or no space for remapping registers,
+ *   -EINVAL if couldn't install ISR,
+ *   or clk_get return error value.
+ */
+static int isp_probe(struct platform_device *pdev)
+{
+	struct isp_platform_data *pdata = pdev->dev.platform_data;
+	struct isp_device *isp;
+	int ret;
+	int i, m;
+
+	if (pdata == NULL)
+		return -EINVAL;
+
+	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
+	if (!isp) {
+		dev_err(&pdev->dev, "could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	isp->autoidle = autoidle;
+	isp->platform_cb.set_xclk = isp_set_xclk;
+	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
+
+	mutex_init(&isp->isp_mutex);
+	spin_lock_init(&isp->stat_lock);
+
+	isp->dev = &pdev->dev;
+	isp->pdata = pdata;
+	isp->ref_count = 0;
+
+	isp->raw_dmamask = DMA_BIT_MASK(32);
+	isp->dev->dma_mask = &isp->raw_dmamask;
+	isp->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	platform_set_drvdata(pdev, isp);
+
+	/* Regulators */
+	isp->isp_csiphy1.vdd = regulator_get(&pdev->dev, "VDD_CSIPHY1");
+	isp->isp_csiphy2.vdd = regulator_get(&pdev->dev, "VDD_CSIPHY2");
+
+	/* Clocks */
+	ret = isp_map_mem_resource(pdev, isp, OMAP3_ISP_IOMEM_MAIN);
+	if (ret < 0)
+		goto error;
+
+	ret = isp_get_clocks(isp);
+	if (ret < 0)
+		goto error;
+
+	if (omap3isp_get(isp) == NULL)
+		goto error;
+
+	ret = isp_reset(isp);
+	if (ret < 0)
+		goto error_isp;
+
+	/* Memory resources */
+	isp->revision = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_REVISION);
+	dev_info(isp->dev, "Revision %d.%d found\n",
+		 (isp->revision & 0xf0) >> 4, isp->revision & 0x0f);
+
+	for (m = 0; m < ARRAY_SIZE(isp_res_maps); m++)
+		if (isp->revision == isp_res_maps[m].isp_rev)
+			break;
+
+	if (m == ARRAY_SIZE(isp_res_maps)) {
+		dev_err(isp->dev, "No resource map found for ISP rev %d.%d\n",
+			(isp->revision & 0xf0) >> 4, isp->revision & 0xf);
+		ret = -ENODEV;
+		goto error_isp;
+	}
+
+	for (i = 1; i < OMAP3_ISP_IOMEM_LAST; i++) {
+		if (isp_res_maps[m].map & 1 << i) {
+			ret = isp_map_mem_resource(pdev, isp, i);
+			if (ret)
+				goto error_isp;
+		}
+	}
+
+	/* IOMMU */
+	isp->iommu = iommu_get("isp");
+	if (IS_ERR_OR_NULL(isp->iommu)) {
+		isp->iommu = NULL;
+		ret = -ENODEV;
+		goto error_isp;
+	}
+
+	/* Interrupt */
+	isp->irq_num = platform_get_irq(pdev, 0);
+	if (isp->irq_num <= 0) {
+		dev_err(isp->dev, "No IRQ resource\n");
+		ret = -ENODEV;
+		goto error_isp;
+	}
+
+	if (request_irq(isp->irq_num, isp_isr, IRQF_SHARED, "OMAP3 ISP", isp)) {
+		dev_err(isp->dev, "Unable to request IRQ\n");
+		ret = -EINVAL;
+		goto error_isp;
+	}
+
+	/* Entities */
+	ret = isp_initialize_modules(isp);
+	if (ret < 0)
+		goto error_irq;
+
+	ret = isp_register_entities(isp);
+	if (ret < 0)
+		goto error_modules;
+
+	isp_power_settings(isp, 1);
+	omap3isp_put(isp);
+
+	return 0;
+
+error_modules:
+	isp_cleanup_modules(isp);
+error_irq:
+	free_irq(isp->irq_num, isp);
+error_isp:
+	iommu_put(isp->iommu);
+	omap3isp_put(isp);
+error:
+	isp_put_clocks(isp);
+
+	for (i = 0; i < OMAP3_ISP_IOMEM_LAST; i++) {
+		if (isp->mmio_base[i]) {
+			iounmap(isp->mmio_base[i]);
+			isp->mmio_base[i] = NULL;
+		}
+
+		if (isp->mmio_base_phys[i]) {
+			release_mem_region(isp->mmio_base_phys[i],
+					   isp->mmio_size[i]);
+			isp->mmio_base_phys[i] = 0;
+		}
+	}
+	regulator_put(isp->isp_csiphy2.vdd);
+	regulator_put(isp->isp_csiphy1.vdd);
+	platform_set_drvdata(pdev, NULL);
+	kfree(isp);
+
+	return ret;
+}
+
+static const struct dev_pm_ops omap3isp_pm_ops = {
+	.prepare = isp_pm_prepare,
+	.suspend = isp_pm_suspend,
+	.resume = isp_pm_resume,
+	.complete = isp_pm_complete,
+};
+
+static struct platform_device_id omap3isp_id_table[] = {
+	{ "omap3isp", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, omap3isp_id_table);
+
+static struct platform_driver omap3isp_driver = {
+	.probe = isp_probe,
+	.remove = isp_remove,
+	.id_table = omap3isp_id_table,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "omap3isp",
+		.pm	= &omap3isp_pm_ops,
+	},
+};
+
+/*
+ * isp_init - ISP module initialization.
+ */
+static int __init isp_init(void)
+{
+	return platform_driver_register(&omap3isp_driver);
+}
+
+/*
+ * isp_cleanup - ISP module cleanup.
+ */
+static void __exit isp_cleanup(void)
+{
+	platform_driver_unregister(&omap3isp_driver);
+}
+
+module_init(isp_init);
+module_exit(isp_cleanup);
+
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_DESCRIPTION("TI OMAP3 ISP driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/omap3-isp/isp.h b/drivers/media/video/omap3-isp/isp.h
new file mode 100644
index 0000000..b7ace6e
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isp.h
@@ -0,0 +1,427 @@
+/*
+ * isp.h
+ *
+ * TI OMAP3 ISP - Core
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
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
+#ifndef OMAP3_ISP_CORE_H
+#define OMAP3_ISP_CORE_H
+
+#include <media/v4l2-device.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/wait.h>
+#include <plat/iommu.h>
+#include <plat/iovmm.h>
+
+#include "ispstat.h"
+#include "ispccdc.h"
+#include "ispreg.h"
+#include "ispresizer.h"
+#include "isppreview.h"
+#include "ispcsiphy.h"
+#include "ispcsi2.h"
+#include "ispccp2.h"
+
+#define IOMMU_FLAG (IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
+
+#define ISP_TOK_TERM		0xFFFFFFFF	/*
+						 * terminating token for ISP
+						 * modules reg list
+						 */
+#define to_isp_device(ptr_module)				\
+	container_of(ptr_module, struct isp_device, isp_##ptr_module)
+#define to_device(ptr_module)						\
+	(to_isp_device(ptr_module)->dev)
+
+enum isp_mem_resources {
+	OMAP3_ISP_IOMEM_MAIN,
+	OMAP3_ISP_IOMEM_CCP2,
+	OMAP3_ISP_IOMEM_CCDC,
+	OMAP3_ISP_IOMEM_HIST,
+	OMAP3_ISP_IOMEM_H3A,
+	OMAP3_ISP_IOMEM_PREV,
+	OMAP3_ISP_IOMEM_RESZ,
+	OMAP3_ISP_IOMEM_SBL,
+	OMAP3_ISP_IOMEM_CSI2A_REGS1,
+	OMAP3_ISP_IOMEM_CSIPHY2,
+	OMAP3_ISP_IOMEM_CSI2A_REGS2,
+	OMAP3_ISP_IOMEM_CSI2C_REGS1,
+	OMAP3_ISP_IOMEM_CSIPHY1,
+	OMAP3_ISP_IOMEM_CSI2C_REGS2,
+	OMAP3_ISP_IOMEM_LAST
+};
+
+enum isp_sbl_resource {
+	OMAP3_ISP_SBL_CSI1_READ		= 0x1,
+	OMAP3_ISP_SBL_CSI1_WRITE	= 0x2,
+	OMAP3_ISP_SBL_CSI2A_WRITE	= 0x4,
+	OMAP3_ISP_SBL_CSI2C_WRITE	= 0x8,
+	OMAP3_ISP_SBL_CCDC_LSC_READ	= 0x10,
+	OMAP3_ISP_SBL_CCDC_WRITE	= 0x20,
+	OMAP3_ISP_SBL_PREVIEW_READ	= 0x40,
+	OMAP3_ISP_SBL_PREVIEW_WRITE	= 0x80,
+	OMAP3_ISP_SBL_RESIZER_READ	= 0x100,
+	OMAP3_ISP_SBL_RESIZER_WRITE	= 0x200,
+};
+
+enum isp_subclk_resource {
+	OMAP3_ISP_SUBCLK_CCDC		= (1 << 0),
+	OMAP3_ISP_SUBCLK_H3A		= (1 << 1),
+	OMAP3_ISP_SUBCLK_HIST		= (1 << 2),
+	OMAP3_ISP_SUBCLK_PREVIEW	= (1 << 3),
+	OMAP3_ISP_SUBCLK_RESIZER	= (1 << 4),
+};
+
+enum isp_interface_type {
+	ISP_INTERFACE_PARALLEL,
+	ISP_INTERFACE_CSI2A_PHY2,
+	ISP_INTERFACE_CCP2B_PHY1,
+	ISP_INTERFACE_CCP2B_PHY2,
+	ISP_INTERFACE_CSI2C_PHY1,
+};
+
+#define ISP_REVISION_1_0		0x10
+#define ISP_REVISION_2_0		0x20
+#define ISP_REVISION_15_0		0xF0
+
+/*
+ * struct isp_res_mapping - Map ISP io resources to ISP revision.
+ * @isp_rev: ISP_REVISION_x_x
+ * @map: bitmap for enum isp_mem_resources
+ */
+struct isp_res_mapping {
+	u32 isp_rev;
+	u32 map;
+};
+
+/*
+ * struct isp_reg - Structure for ISP register values.
+ * @reg: 32-bit Register address.
+ * @val: 32-bit Register value.
+ */
+struct isp_reg {
+	enum isp_mem_resources mmio_range;
+	u32 reg;
+	u32 val;
+};
+
+/**
+ * struct isp_parallel_platform_data - Parallel interface platform data
+ * @width: Parallel bus width in bits (8, 10, 11 or 12)
+ * @data_lane_shift: Data lane shifter
+ *		0 - CAMEXT[13:0] -> CAM[13:0]
+ *		1 - CAMEXT[13:2] -> CAM[11:0]
+ *		2 - CAMEXT[13:4] -> CAM[9:0]
+ *		3 - CAMEXT[13:6] -> CAM[7:0]
+ * @clk_pol: Pixel clock polarity
+ *		0 - Non Inverted, 1 - Inverted
+ * @bridge: CCDC Bridge input control
+ *		ISPCTRL_PAR_BRIDGE_DISABLE - Disable
+ *		ISPCTRL_PAR_BRIDGE_LENDIAN - Little endian
+ *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
+ */
+struct isp_parallel_platform_data {
+	unsigned int width;
+	unsigned int data_lane_shift:2;
+	unsigned int clk_pol:1;
+	unsigned int bridge:4;
+};
+
+/**
+ * struct isp_ccp2_platform_data - CCP2 interface platform data
+ * @strobe_clk_pol: Strobe/clock polarity
+ *		0 - Non Inverted, 1 - Inverted
+ * @crc: Enable the cyclic redundancy check
+ * @ccp2_mode: Enable CCP2 compatibility mode
+ *		0 - MIPI-CSI1 mode, 1 - CCP2 mode
+ * @phy_layer: Physical layer selection
+ *		ISPCCP2_CTRL_PHY_SEL_CLOCK - Data/clock physical layer
+ *		ISPCCP2_CTRL_PHY_SEL_STROBE - Data/strobe physical layer
+ * @vpclk_div: Video port output clock control
+ */
+struct isp_ccp2_platform_data {
+	unsigned int strobe_clk_pol:1;
+	unsigned int crc:1;
+	unsigned int ccp2_mode:1;
+	unsigned int phy_layer:1;
+	unsigned int vpclk_div:2;
+};
+
+/**
+ * struct isp_csi2_platform_data - CSI2 interface platform data
+ * @crc: Enable the cyclic redundancy check
+ * @vpclk_div: Video port output clock control
+ */
+struct isp_csi2_platform_data {
+	unsigned crc:1;
+	unsigned vpclk_div:2;
+};
+
+struct isp_subdev_i2c_board_info {
+	struct i2c_board_info *board_info;
+	int i2c_adapter_id;
+};
+
+struct isp_v4l2_subdevs_group {
+	struct isp_subdev_i2c_board_info *subdevs;
+	enum isp_interface_type interface;
+	union {
+		struct isp_parallel_platform_data parallel;
+		struct isp_ccp2_platform_data ccp2;
+		struct isp_csi2_platform_data csi2;
+	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
+};
+
+struct isp_platform_data {
+	struct isp_v4l2_subdevs_group *subdevs;
+};
+
+struct isp_platform_callback {
+	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
+	int (*csiphy_config)(struct isp_csiphy *phy,
+			     struct isp_csiphy_dphy_cfg *dphy,
+			     struct isp_csiphy_lanes_cfg *lanes);
+	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
+};
+
+/*
+ * struct isp_device - ISP device structure.
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @revision: Stores current ISP module revision.
+ * @irq_num: Currently used IRQ number.
+ * @mmio_base: Array with kernel base addresses for ioremapped ISP register
+ *             regions.
+ * @mmio_base_phys: Array with physical L4 bus addresses for ISP register
+ *                  regions.
+ * @mmio_size: Array with ISP register regions size in bytes.
+ * @raw_dmamask: Raw DMA mask
+ * @stat_lock: Spinlock for handling statistics
+ * @isp_mutex: Mutex for serializing requests to ISP.
+ * @has_context: Context has been saved at least once and can be restored.
+ * @ref_count: Reference count for handling multiple ISP requests.
+ * @cam_ick: Pointer to camera interface clock structure.
+ * @cam_mclk: Pointer to camera functional clock structure.
+ * @dpll4_m5_ck: Pointer to DPLL4 M5 clock structure.
+ * @csi2_fck: Pointer to camera CSI2 complexIO clock structure.
+ * @l3_ick: Pointer to OMAP3 L3 bus interface clock.
+ * @irq: Currently attached ISP ISR callbacks information structure.
+ * @isp_af: Pointer to current settings for ISP AutoFocus SCM.
+ * @isp_hist: Pointer to current settings for ISP Histogram SCM.
+ * @isp_h3a: Pointer to current settings for ISP Auto Exposure and
+ *           White Balance SCM.
+ * @isp_res: Pointer to current settings for ISP Resizer.
+ * @isp_prev: Pointer to current settings for ISP Preview.
+ * @isp_ccdc: Pointer to current settings for ISP CCDC.
+ * @iommu: Pointer to requested IOMMU instance for ISP.
+ * @platform_cb: ISP driver callback function pointers for platform code
+ *
+ * This structure is used to store the OMAP ISP Information.
+ */
+struct isp_device {
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+	struct device *dev;
+	u32 revision;
+
+	/* platform HW resources */
+	struct isp_platform_data *pdata;
+	unsigned int irq_num;
+
+	void __iomem *mmio_base[OMAP3_ISP_IOMEM_LAST];
+	unsigned long mmio_base_phys[OMAP3_ISP_IOMEM_LAST];
+	resource_size_t mmio_size[OMAP3_ISP_IOMEM_LAST];
+
+	u64 raw_dmamask;
+
+	/* ISP Obj */
+	spinlock_t stat_lock;	/* common lock for statistic drivers */
+	struct mutex isp_mutex;	/* For handling ref_count field */
+	int has_context;
+	int ref_count;
+	unsigned int autoidle;
+	u32 xclk_divisor[2];	/* Two clocks, a and b. */
+#define ISP_CLK_CAM_ICK		0
+#define ISP_CLK_CAM_MCLK	1
+#define ISP_CLK_DPLL4_M5_CK	2
+#define ISP_CLK_CSI2_FCK	3
+#define ISP_CLK_L3_ICK		4
+	struct clk *clock[5];
+
+	/* ISP modules */
+	struct ispstat isp_af;
+	struct ispstat isp_aewb;
+	struct ispstat isp_hist;
+	struct isp_res_device isp_res;
+	struct isp_prev_device isp_prev;
+	struct isp_ccdc_device isp_ccdc;
+	struct isp_csi2_device isp_csi2a;
+	struct isp_csi2_device isp_csi2c;
+	struct isp_ccp2_device isp_ccp2;
+	struct isp_csiphy isp_csiphy1;
+	struct isp_csiphy isp_csiphy2;
+
+	unsigned int sbl_resources;
+	unsigned int subclk_resources;
+
+	struct iommu *iommu;
+
+	struct isp_platform_callback platform_cb;
+};
+
+#define v4l2_dev_to_isp_device(dev) \
+	container_of(dev, struct isp_device, v4l2_dev)
+
+void omap3isp_hist_dma_done(struct isp_device *isp);
+
+void omap3isp_flush(struct isp_device *isp);
+
+int omap3isp_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
+			      atomic_t *stopping);
+
+int omap3isp_module_sync_is_stopping(wait_queue_head_t *wait,
+				     atomic_t *stopping);
+
+int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
+				 enum isp_pipeline_stream_state state);
+void omap3isp_configure_bridge(struct isp_device *isp,
+			       enum ccdc_input_entity input,
+			       const struct isp_parallel_platform_data *pdata);
+
+#define ISP_XCLK_NONE			-1
+#define ISP_XCLK_A			0
+#define ISP_XCLK_B			1
+
+struct isp_device *omap3isp_get(struct isp_device *isp);
+void omap3isp_put(struct isp_device *isp);
+
+void omap3isp_print_status(struct isp_device *isp);
+
+void omap3isp_sbl_enable(struct isp_device *isp, enum isp_sbl_resource res);
+void omap3isp_sbl_disable(struct isp_device *isp, enum isp_sbl_resource res);
+
+void omap3isp_subclk_enable(struct isp_device *isp,
+			    enum isp_subclk_resource res);
+void omap3isp_subclk_disable(struct isp_device *isp,
+			     enum isp_subclk_resource res);
+
+int omap3isp_pipeline_pm_use(struct media_entity *entity, int use);
+
+int omap3isp_register_entities(struct platform_device *pdev,
+			       struct v4l2_device *v4l2_dev);
+void omap3isp_unregister_entities(struct platform_device *pdev);
+
+/*
+ * isp_reg_readl - Read value of an OMAP3 ISP register
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp_mmio_range: Range to which the register offset refers to.
+ * @reg_offset: Register offset to read from.
+ *
+ * Returns an unsigned 32 bit value with the required register contents.
+ */
+static inline
+u32 isp_reg_readl(struct isp_device *isp, enum isp_mem_resources isp_mmio_range,
+		  u32 reg_offset)
+{
+	return __raw_readl(isp->mmio_base[isp_mmio_range] + reg_offset);
+}
+
+/*
+ * isp_reg_writel - Write value to an OMAP3 ISP register
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @reg_value: 32 bit value to write to the register.
+ * @isp_mmio_range: Range to which the register offset refers to.
+ * @reg_offset: Register offset to write into.
+ */
+static inline
+void isp_reg_writel(struct isp_device *isp, u32 reg_value,
+		    enum isp_mem_resources isp_mmio_range, u32 reg_offset)
+{
+	__raw_writel(reg_value, isp->mmio_base[isp_mmio_range] + reg_offset);
+}
+
+/*
+ * isp_reg_and - Clear individual bits in an OMAP3 ISP register
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @mmio_range: Range to which the register offset refers to.
+ * @reg: Register offset to work on.
+ * @clr_bits: 32 bit value which would be cleared in the register.
+ */
+static inline
+void isp_reg_clr(struct isp_device *isp, enum isp_mem_resources mmio_range,
+		 u32 reg, u32 clr_bits)
+{
+	u32 v = isp_reg_readl(isp, mmio_range, reg);
+
+	isp_reg_writel(isp, v & ~clr_bits, mmio_range, reg);
+}
+
+/*
+ * isp_reg_set - Set individual bits in an OMAP3 ISP register
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @mmio_range: Range to which the register offset refers to.
+ * @reg: Register offset to work on.
+ * @set_bits: 32 bit value which would be set in the register.
+ */
+static inline
+void isp_reg_set(struct isp_device *isp, enum isp_mem_resources mmio_range,
+		 u32 reg, u32 set_bits)
+{
+	u32 v = isp_reg_readl(isp, mmio_range, reg);
+
+	isp_reg_writel(isp, v | set_bits, mmio_range, reg);
+}
+
+/*
+ * isp_reg_clr_set - Clear and set invidial bits in an OMAP3 ISP register
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @mmio_range: Range to which the register offset refers to.
+ * @reg: Register offset to work on.
+ * @clr_bits: 32 bit value which would be cleared in the register.
+ * @set_bits: 32 bit value which would be set in the register.
+ *
+ * The clear operation is done first, and then the set operation.
+ */
+static inline
+void isp_reg_clr_set(struct isp_device *isp, enum isp_mem_resources mmio_range,
+		     u32 reg, u32 clr_bits, u32 set_bits)
+{
+	u32 v = isp_reg_readl(isp, mmio_range, reg);
+
+	isp_reg_writel(isp, (v & ~clr_bits) | set_bits, mmio_range, reg);
+}
+
+static inline enum v4l2_buf_type
+isp_pad_buffer_type(const struct v4l2_subdev *subdev, int pad)
+{
+	if (pad >= subdev->entity.num_pads)
+		return 0;
+
+	if (subdev->entity.pads[pad].flags & MEDIA_PAD_FL_SINK)
+		return V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	else
+		return V4L2_BUF_TYPE_VIDEO_CAPTURE;
+}
+
+#endif	/* OMAP3_ISP_CORE_H */
diff --git a/drivers/media/video/omap3-isp/ispreg.h b/drivers/media/video/omap3-isp/ispreg.h
new file mode 100644
index 0000000..69f6af6
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispreg.h
@@ -0,0 +1,1589 @@
+/*
+ * ispreg.h
+ *
+ * TI OMAP3 ISP - Registers definitions
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc
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
+#ifndef OMAP3_ISP_REG_H
+#define OMAP3_ISP_REG_H
+
+#include <plat/omap34xx.h>
+
+
+#define CM_CAM_MCLK_HZ			172800000	/* Hz */
+
+/* ISP Submodules offset */
+
+#define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
+#define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))
+
+#define OMAP3ISP_CCP2_REG_OFFSET	0x0400
+#define OMAP3ISP_CCP2_REG_BASE		(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_CCP2_REG_OFFSET)
+#define OMAP3ISP_CCP2_REG(offset)	(OMAP3ISP_CCP2_REG_BASE + (offset))
+
+#define OMAP3ISP_CCDC_REG_OFFSET	0x0600
+#define OMAP3ISP_CCDC_REG_BASE		(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_CCDC_REG_OFFSET)
+#define OMAP3ISP_CCDC_REG(offset)	(OMAP3ISP_CCDC_REG_BASE + (offset))
+
+#define OMAP3ISP_HIST_REG_OFFSET	0x0A00
+#define OMAP3ISP_HIST_REG_BASE		(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_HIST_REG_OFFSET)
+#define OMAP3ISP_HIST_REG(offset)	(OMAP3ISP_HIST_REG_BASE + (offset))
+
+#define OMAP3ISP_H3A_REG_OFFSET		0x0C00
+#define OMAP3ISP_H3A_REG_BASE		(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_H3A_REG_OFFSET)
+#define OMAP3ISP_H3A_REG(offset)	(OMAP3ISP_H3A_REG_BASE + (offset))
+
+#define OMAP3ISP_PREV_REG_OFFSET	0x0E00
+#define OMAP3ISP_PREV_REG_BASE		(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_PREV_REG_OFFSET)
+#define OMAP3ISP_PREV_REG(offset)	(OMAP3ISP_PREV_REG_BASE + (offset))
+
+#define OMAP3ISP_RESZ_REG_OFFSET	0x1000
+#define OMAP3ISP_RESZ_REG_BASE		(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_RESZ_REG_OFFSET)
+#define OMAP3ISP_RESZ_REG(offset)	(OMAP3ISP_RESZ_REG_BASE + (offset))
+
+#define OMAP3ISP_SBL_REG_OFFSET		0x1200
+#define OMAP3ISP_SBL_REG_BASE		(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_SBL_REG_OFFSET)
+#define OMAP3ISP_SBL_REG(offset)	(OMAP3ISP_SBL_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2A_REGS1_REG_OFFSET	0x1800
+#define OMAP3ISP_CSI2A_REGS1_REG_BASE	(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_CSI2A_REGS1_REG_OFFSET)
+#define OMAP3ISP_CSI2A_REGS1_REG(offset)				\
+				(OMAP3ISP_CSI2A_REGS1_REG_BASE + (offset))
+
+#define OMAP3ISP_CSIPHY2_REG_OFFSET	0x1970
+#define OMAP3ISP_CSIPHY2_REG_BASE	(OMAP3ISP_REG_BASE +	\
+					 OMAP3ISP_CSIPHY2_REG_OFFSET)
+#define OMAP3ISP_CSIPHY2_REG(offset)	(OMAP3ISP_CSIPHY2_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2A_REGS2_REG_OFFSET	0x19C0
+#define OMAP3ISP_CSI2A_REGS2_REG_BASE	(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_CSI2A_REGS2_REG_OFFSET)
+#define OMAP3ISP_CSI2A_REGS2_REG(offset)				\
+				(OMAP3ISP_CSI2A_REGS2_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2C_REGS1_REG_OFFSET	0x1C00
+#define OMAP3ISP_CSI2C_REGS1_REG_BASE	(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_CSI2C_REGS1_REG_OFFSET)
+#define OMAP3ISP_CSI2C_REGS1_REG(offset)				\
+				(OMAP3ISP_CSI2C_REGS1_REG_BASE + (offset))
+
+#define OMAP3ISP_CSIPHY1_REG_OFFSET	0x1D70
+#define OMAP3ISP_CSIPHY1_REG_BASE	(OMAP3ISP_REG_BASE +	\
+					 OMAP3ISP_CSIPHY1_REG_OFFSET)
+#define OMAP3ISP_CSIPHY1_REG(offset)	(OMAP3ISP_CSIPHY1_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2C_REGS2_REG_OFFSET	0x1DC0
+#define OMAP3ISP_CSI2C_REGS2_REG_BASE	(OMAP3ISP_REG_BASE +		\
+					 OMAP3ISP_CSI2C_REGS2_REG_OFFSET)
+#define OMAP3ISP_CSI2C_REGS2_REG(offset)				\
+				(OMAP3ISP_CSI2C_REGS2_REG_BASE + (offset))
+
+/* ISP module register offset */
+
+#define ISP_REVISION			(0x000)
+#define ISP_SYSCONFIG			(0x004)
+#define ISP_SYSSTATUS			(0x008)
+#define ISP_IRQ0ENABLE			(0x00C)
+#define ISP_IRQ0STATUS			(0x010)
+#define ISP_IRQ1ENABLE			(0x014)
+#define ISP_IRQ1STATUS			(0x018)
+#define ISP_TCTRL_GRESET_LENGTH		(0x030)
+#define ISP_TCTRL_PSTRB_REPLAY		(0x034)
+#define ISP_CTRL			(0x040)
+#define ISP_SECURE			(0x044)
+#define ISP_TCTRL_CTRL			(0x050)
+#define ISP_TCTRL_FRAME			(0x054)
+#define ISP_TCTRL_PSTRB_DELAY		(0x058)
+#define ISP_TCTRL_STRB_DELAY		(0x05C)
+#define ISP_TCTRL_SHUT_DELAY		(0x060)
+#define ISP_TCTRL_PSTRB_LENGTH		(0x064)
+#define ISP_TCTRL_STRB_LENGTH		(0x068)
+#define ISP_TCTRL_SHUT_LENGTH		(0x06C)
+#define ISP_PING_PONG_ADDR		(0x070)
+#define ISP_PING_PONG_MEM_RANGE		(0x074)
+#define ISP_PING_PONG_BUF_SIZE		(0x078)
+
+/* CCP2 receiver registers */
+
+#define ISPCCP2_REVISION		(0x000)
+#define ISPCCP2_SYSCONFIG		(0x004)
+#define ISPCCP2_SYSCONFIG_SOFT_RESET	(1 << 1)
+#define ISPCCP2_SYSCONFIG_AUTO_IDLE		0x1
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT	12
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_FORCE	\
+	(0x0 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_NO	\
+	(0x1 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART	\
+	(0x2 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCCP2_SYSSTATUS		(0x008)
+#define ISPCCP2_SYSSTATUS_RESET_DONE	(1 << 0)
+#define ISPCCP2_LC01_IRQENABLE		(0x00C)
+#define ISPCCP2_LC01_IRQSTATUS		(0x010)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ	(1 << 11)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_LE_IRQ	(1 << 10)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_LS_IRQ	(1 << 9)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_FE_IRQ	(1 << 8)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_COUNT_IRQ	(1 << 7)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_FIFO_OVF_IRQ	(1 << 5)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_CRC_IRQ	(1 << 4)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_FSP_IRQ	(1 << 3)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_FW_IRQ	(1 << 2)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_FSC_IRQ	(1 << 1)
+#define ISPCCP2_LC01_IRQSTATUS_LC0_SSC_IRQ	(1 << 0)
+
+#define ISPCCP2_LC23_IRQENABLE		(0x014)
+#define ISPCCP2_LC23_IRQSTATUS		(0x018)
+#define ISPCCP2_LCM_IRQENABLE		(0x02C)
+#define ISPCCP2_LCM_IRQSTATUS_EOF_IRQ		(1 << 0)
+#define ISPCCP2_LCM_IRQSTATUS_OCPERROR_IRQ	(1 << 1)
+#define ISPCCP2_LCM_IRQSTATUS		(0x030)
+#define ISPCCP2_CTRL			(0x040)
+#define ISPCCP2_CTRL_IF_EN		(1 << 0)
+#define ISPCCP2_CTRL_PHY_SEL		(1 << 1)
+#define ISPCCP2_CTRL_PHY_SEL_CLOCK	(0 << 1)
+#define ISPCCP2_CTRL_PHY_SEL_STROBE	(1 << 1)
+#define ISPCCP2_CTRL_PHY_SEL_MASK	0x1
+#define ISPCCP2_CTRL_PHY_SEL_SHIFT	1
+#define ISPCCP2_CTRL_IO_OUT_SEL		(1 << 2)
+#define ISPCCP2_CTRL_MODE		(1 << 4)
+#define ISPCCP2_CTRL_VP_CLK_FORCE_ON	(1 << 9)
+#define ISPCCP2_CTRL_INV		(1 << 10)
+#define ISPCCP2_CTRL_INV_MASK		0x1
+#define ISPCCP2_CTRL_INV_SHIFT		10
+#define ISPCCP2_CTRL_VP_ONLY_EN		(1 << 11)
+#define ISPCCP2_CTRL_VP_CLK_POL		(1 << 12)
+#define ISPCCP2_CTRL_VPCLK_DIV_SHIFT	15
+#define ISPCCP2_CTRL_VPCLK_DIV_MASK	0x1ffff /* [31:15] */
+#define ISPCCP2_CTRL_VP_OUT_CTRL_SHIFT	8 /* 3430 bits */
+#define ISPCCP2_CTRL_VP_OUT_CTRL_MASK	0x3 /* 3430 bits */
+#define ISPCCP2_DBG			(0x044)
+#define ISPCCP2_GNQ			(0x048)
+#define ISPCCP2_LCx_CTRL(x)			((0x050)+0x30*(x))
+#define ISPCCP2_LCx_CTRL_CHAN_EN		(1 << 0)
+#define ISPCCP2_LCx_CTRL_CRC_EN			(1 << 19)
+#define ISPCCP2_LCx_CTRL_CRC_MASK		0x1
+#define ISPCCP2_LCx_CTRL_CRC_SHIFT		2
+#define ISPCCP2_LCx_CTRL_CRC_SHIFT_15_0		19
+#define ISPCCP2_LCx_CTRL_REGION_EN		(1 << 1)
+#define ISPCCP2_LCx_CTRL_REGION_MASK		0x1
+#define ISPCCP2_LCx_CTRL_REGION_SHIFT		1
+#define ISPCCP2_LCx_CTRL_FORMAT_MASK_15_0	0x3f
+#define ISPCCP2_LCx_CTRL_FORMAT_SHIFT_15_0	0x2
+#define ISPCCP2_LCx_CTRL_FORMAT_MASK		0x1f
+#define ISPCCP2_LCx_CTRL_FORMAT_SHIFT		0x3
+#define ISPCCP2_LCx_CODE(x)		((0x054)+0x30*(x))
+#define ISPCCP2_LCx_STAT_START(x)	((0x058)+0x30*(x))
+#define ISPCCP2_LCx_STAT_SIZE(x)	((0x05C)+0x30*(x))
+#define ISPCCP2_LCx_SOF_ADDR(x)		((0x060)+0x30*(x))
+#define ISPCCP2_LCx_EOF_ADDR(x)		((0x064)+0x30*(x))
+#define ISPCCP2_LCx_DAT_START(x)	((0x068)+0x30*(x))
+#define ISPCCP2_LCx_DAT_SIZE(x)		((0x06C)+0x30*(x))
+#define ISPCCP2_LCx_DAT_MASK		0xFFF
+#define ISPCCP2_LCx_DAT_SHIFT		16
+#define ISPCCP2_LCx_DAT_PING_ADDR(x)	((0x070)+0x30*(x))
+#define ISPCCP2_LCx_DAT_PONG_ADDR(x)	((0x074)+0x30*(x))
+#define ISPCCP2_LCx_DAT_OFST(x)		((0x078)+0x30*(x))
+#define ISPCCP2_LCM_CTRL		(0x1D0)
+#define ISPCCP2_LCM_CTRL_CHAN_EN               (1 << 0)
+#define ISPCCP2_LCM_CTRL_DST_PORT              (1 << 2)
+#define ISPCCP2_LCM_CTRL_DST_PORT_SHIFT		2
+#define ISPCCP2_LCM_CTRL_READ_THROTTLE_SHIFT	3
+#define ISPCCP2_LCM_CTRL_READ_THROTTLE_MASK	0x11
+#define ISPCCP2_LCM_CTRL_BURST_SIZE_SHIFT	5
+#define ISPCCP2_LCM_CTRL_BURST_SIZE_MASK	0x7
+#define ISPCCP2_LCM_CTRL_SRC_FORMAT_SHIFT	16
+#define ISPCCP2_LCM_CTRL_SRC_FORMAT_MASK	0x7
+#define ISPCCP2_LCM_CTRL_SRC_DECOMPR_SHIFT	20
+#define ISPCCP2_LCM_CTRL_SRC_DECOMPR_MASK	0x3
+#define ISPCCP2_LCM_CTRL_SRC_DPCM_PRED		(1 << 22)
+#define ISPCCP2_LCM_CTRL_SRC_PACK		(1 << 23)
+#define ISPCCP2_LCM_CTRL_DST_FORMAT_SHIFT	24
+#define ISPCCP2_LCM_CTRL_DST_FORMAT_MASK	0x7
+#define ISPCCP2_LCM_VSIZE		(0x1D4)
+#define ISPCCP2_LCM_VSIZE_SHIFT		16
+#define ISPCCP2_LCM_HSIZE		(0x1D8)
+#define ISPCCP2_LCM_HSIZE_SHIFT		16
+#define ISPCCP2_LCM_PREFETCH		(0x1DC)
+#define ISPCCP2_LCM_PREFETCH_SHIFT	3
+#define ISPCCP2_LCM_SRC_ADDR		(0x1E0)
+#define ISPCCP2_LCM_SRC_OFST		(0x1E4)
+#define ISPCCP2_LCM_DST_ADDR		(0x1E8)
+#define ISPCCP2_LCM_DST_OFST		(0x1EC)
+
+/* CCDC module register offset */
+
+#define ISPCCDC_PID			(0x000)
+#define ISPCCDC_PCR			(0x004)
+#define ISPCCDC_SYN_MODE		(0x008)
+#define ISPCCDC_HD_VD_WID		(0x00C)
+#define ISPCCDC_PIX_LINES		(0x010)
+#define ISPCCDC_HORZ_INFO		(0x014)
+#define ISPCCDC_VERT_START		(0x018)
+#define ISPCCDC_VERT_LINES		(0x01C)
+#define ISPCCDC_CULLING			(0x020)
+#define ISPCCDC_HSIZE_OFF		(0x024)
+#define ISPCCDC_SDOFST			(0x028)
+#define ISPCCDC_SDR_ADDR		(0x02C)
+#define ISPCCDC_CLAMP			(0x030)
+#define ISPCCDC_DCSUB			(0x034)
+#define ISPCCDC_COLPTN			(0x038)
+#define ISPCCDC_BLKCMP			(0x03C)
+#define ISPCCDC_FPC			(0x040)
+#define ISPCCDC_FPC_ADDR		(0x044)
+#define ISPCCDC_VDINT			(0x048)
+#define ISPCCDC_ALAW			(0x04C)
+#define ISPCCDC_REC656IF		(0x050)
+#define ISPCCDC_CFG			(0x054)
+#define ISPCCDC_FMTCFG			(0x058)
+#define ISPCCDC_FMT_HORZ		(0x05C)
+#define ISPCCDC_FMT_VERT		(0x060)
+#define ISPCCDC_FMT_ADDR0		(0x064)
+#define ISPCCDC_FMT_ADDR1		(0x068)
+#define ISPCCDC_FMT_ADDR2		(0x06C)
+#define ISPCCDC_FMT_ADDR3		(0x070)
+#define ISPCCDC_FMT_ADDR4		(0x074)
+#define ISPCCDC_FMT_ADDR5		(0x078)
+#define ISPCCDC_FMT_ADDR6		(0x07C)
+#define ISPCCDC_FMT_ADDR7		(0x080)
+#define ISPCCDC_PRGEVEN0		(0x084)
+#define ISPCCDC_PRGEVEN1		(0x088)
+#define ISPCCDC_PRGODD0			(0x08C)
+#define ISPCCDC_PRGODD1			(0x090)
+#define ISPCCDC_VP_OUT			(0x094)
+
+#define ISPCCDC_LSC_CONFIG		(0x098)
+#define ISPCCDC_LSC_INITIAL		(0x09C)
+#define ISPCCDC_LSC_TABLE_BASE		(0x0A0)
+#define ISPCCDC_LSC_TABLE_OFFSET	(0x0A4)
+
+/* SBL */
+#define ISPSBL_PCR			0x4
+#define ISPSBL_PCR_H3A_AEAWB_WBL_OVF	(1 << 16)
+#define ISPSBL_PCR_H3A_AF_WBL_OVF	(1 << 17)
+#define ISPSBL_PCR_RSZ4_WBL_OVF		(1 << 18)
+#define ISPSBL_PCR_RSZ3_WBL_OVF		(1 << 19)
+#define ISPSBL_PCR_RSZ2_WBL_OVF		(1 << 20)
+#define ISPSBL_PCR_RSZ1_WBL_OVF		(1 << 21)
+#define ISPSBL_PCR_PRV_WBL_OVF		(1 << 22)
+#define ISPSBL_PCR_CCDC_WBL_OVF		(1 << 23)
+#define ISPSBL_PCR_CCDCPRV_2_RSZ_OVF	(1 << 24)
+#define ISPSBL_PCR_CSIA_WBL_OVF		(1 << 25)
+#define ISPSBL_PCR_CSIB_WBL_OVF		(1 << 26)
+#define ISPSBL_CCDC_WR_0		(0x028)
+#define ISPSBL_CCDC_WR_0_DATA_READY	(1 << 21)
+#define ISPSBL_CCDC_WR_1		(0x02C)
+#define ISPSBL_CCDC_WR_2		(0x030)
+#define ISPSBL_CCDC_WR_3		(0x034)
+
+#define ISPSBL_SDR_REQ_EXP		0xF8
+#define ISPSBL_SDR_REQ_HIST_EXP_SHIFT	0
+#define ISPSBL_SDR_REQ_HIST_EXP_MASK	(0x3FF)
+#define ISPSBL_SDR_REQ_RSZ_EXP_SHIFT	10
+#define ISPSBL_SDR_REQ_RSZ_EXP_MASK	(0x3FF << ISPSBL_SDR_REQ_RSZ_EXP_SHIFT)
+#define ISPSBL_SDR_REQ_PRV_EXP_SHIFT	20
+#define ISPSBL_SDR_REQ_PRV_EXP_MASK	(0x3FF << ISPSBL_SDR_REQ_PRV_EXP_SHIFT)
+
+/* Histogram registers */
+#define ISPHIST_PID			(0x000)
+#define ISPHIST_PCR			(0x004)
+#define ISPHIST_CNT			(0x008)
+#define ISPHIST_WB_GAIN			(0x00C)
+#define ISPHIST_R0_HORZ			(0x010)
+#define ISPHIST_R0_VERT			(0x014)
+#define ISPHIST_R1_HORZ			(0x018)
+#define ISPHIST_R1_VERT			(0x01C)
+#define ISPHIST_R2_HORZ			(0x020)
+#define ISPHIST_R2_VERT			(0x024)
+#define ISPHIST_R3_HORZ			(0x028)
+#define ISPHIST_R3_VERT			(0x02C)
+#define ISPHIST_ADDR			(0x030)
+#define ISPHIST_DATA			(0x034)
+#define ISPHIST_RADD			(0x038)
+#define ISPHIST_RADD_OFF		(0x03C)
+#define ISPHIST_H_V_INFO		(0x040)
+
+/* H3A module registers */
+#define ISPH3A_PID			(0x000)
+#define ISPH3A_PCR			(0x004)
+#define ISPH3A_AEWWIN1			(0x04C)
+#define ISPH3A_AEWINSTART		(0x050)
+#define ISPH3A_AEWINBLK			(0x054)
+#define ISPH3A_AEWSUBWIN		(0x058)
+#define ISPH3A_AEWBUFST			(0x05C)
+#define ISPH3A_AFPAX1			(0x008)
+#define ISPH3A_AFPAX2			(0x00C)
+#define ISPH3A_AFPAXSTART		(0x010)
+#define ISPH3A_AFIIRSH			(0x014)
+#define ISPH3A_AFBUFST			(0x018)
+#define ISPH3A_AFCOEF010		(0x01C)
+#define ISPH3A_AFCOEF032		(0x020)
+#define ISPH3A_AFCOEF054		(0x024)
+#define ISPH3A_AFCOEF076		(0x028)
+#define ISPH3A_AFCOEF098		(0x02C)
+#define ISPH3A_AFCOEF0010		(0x030)
+#define ISPH3A_AFCOEF110		(0x034)
+#define ISPH3A_AFCOEF132		(0x038)
+#define ISPH3A_AFCOEF154		(0x03C)
+#define ISPH3A_AFCOEF176		(0x040)
+#define ISPH3A_AFCOEF198		(0x044)
+#define ISPH3A_AFCOEF1010		(0x048)
+
+#define ISPPRV_PCR			(0x004)
+#define ISPPRV_HORZ_INFO		(0x008)
+#define ISPPRV_VERT_INFO		(0x00C)
+#define ISPPRV_RSDR_ADDR		(0x010)
+#define ISPPRV_RADR_OFFSET		(0x014)
+#define ISPPRV_DSDR_ADDR		(0x018)
+#define ISPPRV_DRKF_OFFSET		(0x01C)
+#define ISPPRV_WSDR_ADDR		(0x020)
+#define ISPPRV_WADD_OFFSET		(0x024)
+#define ISPPRV_AVE			(0x028)
+#define ISPPRV_HMED			(0x02C)
+#define ISPPRV_NF			(0x030)
+#define ISPPRV_WB_DGAIN			(0x034)
+#define ISPPRV_WBGAIN			(0x038)
+#define ISPPRV_WBSEL			(0x03C)
+#define ISPPRV_CFA			(0x040)
+#define ISPPRV_BLKADJOFF		(0x044)
+#define ISPPRV_RGB_MAT1			(0x048)
+#define ISPPRV_RGB_MAT2			(0x04C)
+#define ISPPRV_RGB_MAT3			(0x050)
+#define ISPPRV_RGB_MAT4			(0x054)
+#define ISPPRV_RGB_MAT5			(0x058)
+#define ISPPRV_RGB_OFF1			(0x05C)
+#define ISPPRV_RGB_OFF2			(0x060)
+#define ISPPRV_CSC0			(0x064)
+#define ISPPRV_CSC1			(0x068)
+#define ISPPRV_CSC2			(0x06C)
+#define ISPPRV_CSC_OFFSET		(0x070)
+#define ISPPRV_CNT_BRT			(0x074)
+#define ISPPRV_CSUP			(0x078)
+#define ISPPRV_SETUP_YC			(0x07C)
+#define ISPPRV_SET_TBL_ADDR		(0x080)
+#define ISPPRV_SET_TBL_DATA		(0x084)
+#define ISPPRV_CDC_THR0			(0x090)
+#define ISPPRV_CDC_THR1			(ISPPRV_CDC_THR0 + (0x4))
+#define ISPPRV_CDC_THR2			(ISPPRV_CDC_THR0 + (0x4) * 2)
+#define ISPPRV_CDC_THR3			(ISPPRV_CDC_THR0 + (0x4) * 3)
+
+#define ISPPRV_REDGAMMA_TABLE_ADDR	0x0000
+#define ISPPRV_GREENGAMMA_TABLE_ADDR	0x0400
+#define ISPPRV_BLUEGAMMA_TABLE_ADDR	0x0800
+#define ISPPRV_NF_TABLE_ADDR		0x0C00
+#define ISPPRV_YENH_TABLE_ADDR		0x1000
+#define ISPPRV_CFA_TABLE_ADDR		0x1400
+
+#define ISPPRV_MAXOUTPUT_WIDTH		1280
+#define ISPPRV_MAXOUTPUT_WIDTH_ES2	3300
+#define ISPPRV_MAXOUTPUT_WIDTH_3630	4096
+#define ISPRSZ_MIN_OUTPUT		64
+#define ISPRSZ_MAX_OUTPUT		3312
+
+/* Resizer module register offset */
+#define ISPRSZ_PID			(0x000)
+#define ISPRSZ_PCR			(0x004)
+#define ISPRSZ_CNT			(0x008)
+#define ISPRSZ_OUT_SIZE			(0x00C)
+#define ISPRSZ_IN_START			(0x010)
+#define ISPRSZ_IN_SIZE			(0x014)
+#define ISPRSZ_SDR_INADD		(0x018)
+#define ISPRSZ_SDR_INOFF		(0x01C)
+#define ISPRSZ_SDR_OUTADD		(0x020)
+#define ISPRSZ_SDR_OUTOFF		(0x024)
+#define ISPRSZ_HFILT10			(0x028)
+#define ISPRSZ_HFILT32			(0x02C)
+#define ISPRSZ_HFILT54			(0x030)
+#define ISPRSZ_HFILT76			(0x034)
+#define ISPRSZ_HFILT98			(0x038)
+#define ISPRSZ_HFILT1110		(0x03C)
+#define ISPRSZ_HFILT1312		(0x040)
+#define ISPRSZ_HFILT1514		(0x044)
+#define ISPRSZ_HFILT1716		(0x048)
+#define ISPRSZ_HFILT1918		(0x04C)
+#define ISPRSZ_HFILT2120		(0x050)
+#define ISPRSZ_HFILT2322		(0x054)
+#define ISPRSZ_HFILT2524		(0x058)
+#define ISPRSZ_HFILT2726		(0x05C)
+#define ISPRSZ_HFILT2928		(0x060)
+#define ISPRSZ_HFILT3130		(0x064)
+#define ISPRSZ_VFILT10			(0x068)
+#define ISPRSZ_VFILT32			(0x06C)
+#define ISPRSZ_VFILT54			(0x070)
+#define ISPRSZ_VFILT76			(0x074)
+#define ISPRSZ_VFILT98			(0x078)
+#define ISPRSZ_VFILT1110		(0x07C)
+#define ISPRSZ_VFILT1312		(0x080)
+#define ISPRSZ_VFILT1514		(0x084)
+#define ISPRSZ_VFILT1716		(0x088)
+#define ISPRSZ_VFILT1918		(0x08C)
+#define ISPRSZ_VFILT2120		(0x090)
+#define ISPRSZ_VFILT2322		(0x094)
+#define ISPRSZ_VFILT2524		(0x098)
+#define ISPRSZ_VFILT2726		(0x09C)
+#define ISPRSZ_VFILT2928		(0x0A0)
+#define ISPRSZ_VFILT3130		(0x0A4)
+#define ISPRSZ_YENH			(0x0A8)
+
+#define ISP_INT_CLR			0xFF113F11
+#define ISPPRV_PCR_EN			1
+#define ISPPRV_PCR_BUSY			(1 << 1)
+#define ISPPRV_PCR_SOURCE		(1 << 2)
+#define ISPPRV_PCR_ONESHOT		(1 << 3)
+#define ISPPRV_PCR_WIDTH		(1 << 4)
+#define ISPPRV_PCR_INVALAW		(1 << 5)
+#define ISPPRV_PCR_DRKFEN		(1 << 6)
+#define ISPPRV_PCR_DRKFCAP		(1 << 7)
+#define ISPPRV_PCR_HMEDEN		(1 << 8)
+#define ISPPRV_PCR_NFEN			(1 << 9)
+#define ISPPRV_PCR_CFAEN		(1 << 10)
+#define ISPPRV_PCR_CFAFMT_SHIFT		11
+#define ISPPRV_PCR_CFAFMT_MASK		0x7800
+#define ISPPRV_PCR_CFAFMT_BAYER		(0 << 11)
+#define ISPPRV_PCR_CFAFMT_SONYVGA	(1 << 11)
+#define ISPPRV_PCR_CFAFMT_RGBFOVEON	(2 << 11)
+#define ISPPRV_PCR_CFAFMT_DNSPL		(3 << 11)
+#define ISPPRV_PCR_CFAFMT_HONEYCOMB	(4 << 11)
+#define ISPPRV_PCR_CFAFMT_RRGGBBFOVEON	(5 << 11)
+#define ISPPRV_PCR_YNENHEN		(1 << 15)
+#define ISPPRV_PCR_SUPEN		(1 << 16)
+#define ISPPRV_PCR_YCPOS_SHIFT		17
+#define ISPPRV_PCR_YCPOS_YCrYCb		(0 << 17)
+#define ISPPRV_PCR_YCPOS_YCbYCr		(1 << 17)
+#define ISPPRV_PCR_YCPOS_CbYCrY		(2 << 17)
+#define ISPPRV_PCR_YCPOS_CrYCbY		(3 << 17)
+#define ISPPRV_PCR_RSZPORT		(1 << 19)
+#define ISPPRV_PCR_SDRPORT		(1 << 20)
+#define ISPPRV_PCR_SCOMP_EN		(1 << 21)
+#define ISPPRV_PCR_SCOMP_SFT_SHIFT	(22)
+#define ISPPRV_PCR_SCOMP_SFT_MASK	(7 << 22)
+#define ISPPRV_PCR_GAMMA_BYPASS		(1 << 26)
+#define ISPPRV_PCR_DCOREN		(1 << 27)
+#define ISPPRV_PCR_DCCOUP		(1 << 28)
+#define ISPPRV_PCR_DRK_FAIL		(1 << 31)
+
+#define ISPPRV_HORZ_INFO_EPH_SHIFT	0
+#define ISPPRV_HORZ_INFO_EPH_MASK	0x3fff
+#define ISPPRV_HORZ_INFO_SPH_SHIFT	16
+#define ISPPRV_HORZ_INFO_SPH_MASK	0x3fff0
+
+#define ISPPRV_VERT_INFO_ELV_SHIFT	0
+#define ISPPRV_VERT_INFO_ELV_MASK	0x3fff
+#define ISPPRV_VERT_INFO_SLV_SHIFT	16
+#define ISPPRV_VERT_INFO_SLV_MASK	0x3fff0
+
+#define ISPPRV_AVE_EVENDIST_SHIFT	2
+#define ISPPRV_AVE_EVENDIST_1		0x0
+#define ISPPRV_AVE_EVENDIST_2		0x1
+#define ISPPRV_AVE_EVENDIST_3		0x2
+#define ISPPRV_AVE_EVENDIST_4		0x3
+#define ISPPRV_AVE_ODDDIST_SHIFT	4
+#define ISPPRV_AVE_ODDDIST_1		0x0
+#define ISPPRV_AVE_ODDDIST_2		0x1
+#define ISPPRV_AVE_ODDDIST_3		0x2
+#define ISPPRV_AVE_ODDDIST_4		0x3
+
+#define ISPPRV_HMED_THRESHOLD_SHIFT	0
+#define ISPPRV_HMED_EVENDIST		(1 << 8)
+#define ISPPRV_HMED_ODDDIST		(1 << 9)
+
+#define ISPPRV_WBGAIN_COEF0_SHIFT	0
+#define ISPPRV_WBGAIN_COEF1_SHIFT	8
+#define ISPPRV_WBGAIN_COEF2_SHIFT	16
+#define ISPPRV_WBGAIN_COEF3_SHIFT	24
+
+#define ISPPRV_WBSEL_COEF0		0x0
+#define ISPPRV_WBSEL_COEF1		0x1
+#define ISPPRV_WBSEL_COEF2		0x2
+#define ISPPRV_WBSEL_COEF3		0x3
+
+#define ISPPRV_WBSEL_N0_0_SHIFT		0
+#define ISPPRV_WBSEL_N0_1_SHIFT		2
+#define ISPPRV_WBSEL_N0_2_SHIFT		4
+#define ISPPRV_WBSEL_N0_3_SHIFT		6
+#define ISPPRV_WBSEL_N1_0_SHIFT		8
+#define ISPPRV_WBSEL_N1_1_SHIFT		10
+#define ISPPRV_WBSEL_N1_2_SHIFT		12
+#define ISPPRV_WBSEL_N1_3_SHIFT		14
+#define ISPPRV_WBSEL_N2_0_SHIFT		16
+#define ISPPRV_WBSEL_N2_1_SHIFT		18
+#define ISPPRV_WBSEL_N2_2_SHIFT		20
+#define ISPPRV_WBSEL_N2_3_SHIFT		22
+#define ISPPRV_WBSEL_N3_0_SHIFT		24
+#define ISPPRV_WBSEL_N3_1_SHIFT		26
+#define ISPPRV_WBSEL_N3_2_SHIFT		28
+#define ISPPRV_WBSEL_N3_3_SHIFT		30
+
+#define ISPPRV_CFA_GRADTH_HOR_SHIFT	0
+#define ISPPRV_CFA_GRADTH_VER_SHIFT	8
+
+#define ISPPRV_BLKADJOFF_B_SHIFT	0
+#define ISPPRV_BLKADJOFF_G_SHIFT	8
+#define ISPPRV_BLKADJOFF_R_SHIFT	16
+
+#define ISPPRV_RGB_MAT1_MTX_RR_SHIFT	0
+#define ISPPRV_RGB_MAT1_MTX_GR_SHIFT	16
+
+#define ISPPRV_RGB_MAT2_MTX_BR_SHIFT	0
+#define ISPPRV_RGB_MAT2_MTX_RG_SHIFT	16
+
+#define ISPPRV_RGB_MAT3_MTX_GG_SHIFT	0
+#define ISPPRV_RGB_MAT3_MTX_BG_SHIFT	16
+
+#define ISPPRV_RGB_MAT4_MTX_RB_SHIFT	0
+#define ISPPRV_RGB_MAT4_MTX_GB_SHIFT	16
+
+#define ISPPRV_RGB_MAT5_MTX_BB_SHIFT	0
+
+#define ISPPRV_RGB_OFF1_MTX_OFFG_SHIFT	0
+#define ISPPRV_RGB_OFF1_MTX_OFFR_SHIFT	16
+
+#define ISPPRV_RGB_OFF2_MTX_OFFB_SHIFT	0
+
+#define ISPPRV_CSC0_RY_SHIFT		0
+#define ISPPRV_CSC0_GY_SHIFT		10
+#define ISPPRV_CSC0_BY_SHIFT		20
+
+#define ISPPRV_CSC1_RCB_SHIFT		0
+#define ISPPRV_CSC1_GCB_SHIFT		10
+#define ISPPRV_CSC1_BCB_SHIFT		20
+
+#define ISPPRV_CSC2_RCR_SHIFT		0
+#define ISPPRV_CSC2_GCR_SHIFT		10
+#define ISPPRV_CSC2_BCR_SHIFT		20
+
+#define ISPPRV_CSC_OFFSET_CR_SHIFT	0
+#define ISPPRV_CSC_OFFSET_CB_SHIFT	8
+#define ISPPRV_CSC_OFFSET_Y_SHIFT	16
+
+#define ISPPRV_CNT_BRT_BRT_SHIFT	0
+#define ISPPRV_CNT_BRT_CNT_SHIFT	8
+
+#define ISPPRV_CONTRAST_MAX		0x10
+#define ISPPRV_CONTRAST_MIN		0xFF
+#define ISPPRV_BRIGHT_MIN		0x00
+#define ISPPRV_BRIGHT_MAX		0xFF
+
+#define ISPPRV_CSUP_CSUPG_SHIFT		0
+#define ISPPRV_CSUP_THRES_SHIFT		8
+#define ISPPRV_CSUP_HPYF_SHIFT		16
+
+#define ISPPRV_SETUP_YC_MINC_SHIFT	0
+#define ISPPRV_SETUP_YC_MAXC_SHIFT	8
+#define ISPPRV_SETUP_YC_MINY_SHIFT	16
+#define ISPPRV_SETUP_YC_MAXY_SHIFT	24
+#define ISPPRV_YC_MAX			0xFF
+#define ISPPRV_YC_MIN			0x0
+
+/* Define bit fields within selected registers */
+#define ISP_REVISION_SHIFT			0
+
+#define ISP_SYSCONFIG_AUTOIDLE			(1 << 0)
+#define ISP_SYSCONFIG_SOFTRESET			(1 << 1)
+#define ISP_SYSCONFIG_MIDLEMODE_SHIFT		12
+#define ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY	0x0
+#define ISP_SYSCONFIG_MIDLEMODE_NOSTANBY	0x1
+#define ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY	0x2
+
+#define ISP_SYSSTATUS_RESETDONE			0
+
+#define IRQ0ENABLE_CSIA_IRQ			(1 << 0)
+#define IRQ0ENABLE_CSIC_IRQ			(1 << 1)
+#define IRQ0ENABLE_CCP2_LCM_IRQ			(1 << 3)
+#define IRQ0ENABLE_CCP2_LC0_IRQ			(1 << 4)
+#define IRQ0ENABLE_CCP2_LC1_IRQ			(1 << 5)
+#define IRQ0ENABLE_CCP2_LC2_IRQ			(1 << 6)
+#define IRQ0ENABLE_CCP2_LC3_IRQ			(1 << 7)
+#define IRQ0ENABLE_CSIB_IRQ			(IRQ0ENABLE_CCP2_LCM_IRQ | \
+						IRQ0ENABLE_CCP2_LC0_IRQ | \
+						IRQ0ENABLE_CCP2_LC1_IRQ | \
+						IRQ0ENABLE_CCP2_LC2_IRQ | \
+						IRQ0ENABLE_CCP2_LC3_IRQ)
+
+#define IRQ0ENABLE_CCDC_VD0_IRQ			(1 << 8)
+#define IRQ0ENABLE_CCDC_VD1_IRQ			(1 << 9)
+#define IRQ0ENABLE_CCDC_VD2_IRQ			(1 << 10)
+#define IRQ0ENABLE_CCDC_ERR_IRQ			(1 << 11)
+#define IRQ0ENABLE_H3A_AF_DONE_IRQ		(1 << 12)
+#define IRQ0ENABLE_H3A_AWB_DONE_IRQ		(1 << 13)
+#define IRQ0ENABLE_HIST_DONE_IRQ		(1 << 16)
+#define IRQ0ENABLE_CCDC_LSC_DONE_IRQ		(1 << 17)
+#define IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ	(1 << 18)
+#define IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ	(1 << 19)
+#define IRQ0ENABLE_PRV_DONE_IRQ			(1 << 20)
+#define IRQ0ENABLE_RSZ_DONE_IRQ			(1 << 24)
+#define IRQ0ENABLE_OVF_IRQ			(1 << 25)
+#define IRQ0ENABLE_PING_IRQ			(1 << 26)
+#define IRQ0ENABLE_PONG_IRQ			(1 << 27)
+#define IRQ0ENABLE_MMU_ERR_IRQ			(1 << 28)
+#define IRQ0ENABLE_OCP_ERR_IRQ			(1 << 29)
+#define IRQ0ENABLE_SEC_ERR_IRQ			(1 << 30)
+#define IRQ0ENABLE_HS_VS_IRQ			(1 << 31)
+
+#define IRQ0STATUS_CSIA_IRQ			(1 << 0)
+#define IRQ0STATUS_CSI2C_IRQ			(1 << 1)
+#define IRQ0STATUS_CCP2_LCM_IRQ			(1 << 3)
+#define IRQ0STATUS_CCP2_LC0_IRQ			(1 << 4)
+#define IRQ0STATUS_CSIB_IRQ			(IRQ0STATUS_CCP2_LCM_IRQ | \
+						IRQ0STATUS_CCP2_LC0_IRQ)
+
+#define IRQ0STATUS_CSIB_LC1_IRQ			(1 << 5)
+#define IRQ0STATUS_CSIB_LC2_IRQ			(1 << 6)
+#define IRQ0STATUS_CSIB_LC3_IRQ			(1 << 7)
+#define IRQ0STATUS_CCDC_VD0_IRQ			(1 << 8)
+#define IRQ0STATUS_CCDC_VD1_IRQ			(1 << 9)
+#define IRQ0STATUS_CCDC_VD2_IRQ			(1 << 10)
+#define IRQ0STATUS_CCDC_ERR_IRQ			(1 << 11)
+#define IRQ0STATUS_H3A_AF_DONE_IRQ		(1 << 12)
+#define IRQ0STATUS_H3A_AWB_DONE_IRQ		(1 << 13)
+#define IRQ0STATUS_HIST_DONE_IRQ		(1 << 16)
+#define IRQ0STATUS_CCDC_LSC_DONE_IRQ		(1 << 17)
+#define IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ	(1 << 18)
+#define IRQ0STATUS_CCDC_LSC_PREF_ERR_IRQ	(1 << 19)
+#define IRQ0STATUS_PRV_DONE_IRQ			(1 << 20)
+#define IRQ0STATUS_RSZ_DONE_IRQ			(1 << 24)
+#define IRQ0STATUS_OVF_IRQ			(1 << 25)
+#define IRQ0STATUS_PING_IRQ			(1 << 26)
+#define IRQ0STATUS_PONG_IRQ			(1 << 27)
+#define IRQ0STATUS_MMU_ERR_IRQ			(1 << 28)
+#define IRQ0STATUS_OCP_ERR_IRQ			(1 << 29)
+#define IRQ0STATUS_SEC_ERR_IRQ			(1 << 30)
+#define IRQ0STATUS_HS_VS_IRQ			(1 << 31)
+
+#define TCTRL_GRESET_LEN			0
+
+#define TCTRL_PSTRB_REPLAY_DELAY		0
+#define TCTRL_PSTRB_REPLAY_COUNTER_SHIFT	25
+
+#define ISPCTRL_PAR_SER_CLK_SEL_PARALLEL	0x0
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIA		0x1
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIB		0x2
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIC		0x3
+#define ISPCTRL_PAR_SER_CLK_SEL_MASK		0x3
+
+#define ISPCTRL_PAR_BRIDGE_SHIFT		2
+#define ISPCTRL_PAR_BRIDGE_DISABLE		(0x0 << 2)
+#define ISPCTRL_PAR_BRIDGE_LENDIAN		(0x2 << 2)
+#define ISPCTRL_PAR_BRIDGE_BENDIAN		(0x3 << 2)
+#define ISPCTRL_PAR_BRIDGE_MASK			(0x3 << 2)
+
+#define ISPCTRL_PAR_CLK_POL_SHIFT		4
+#define ISPCTRL_PAR_CLK_POL_INV			(1 << 4)
+#define ISPCTRL_PING_PONG_EN			(1 << 5)
+#define ISPCTRL_SHIFT_SHIFT			6
+#define ISPCTRL_SHIFT_0				(0x0 << 6)
+#define ISPCTRL_SHIFT_2				(0x1 << 6)
+#define ISPCTRL_SHIFT_4				(0x2 << 6)
+#define ISPCTRL_SHIFT_MASK			(0x3 << 6)
+
+#define ISPCTRL_CCDC_CLK_EN			(1 << 8)
+#define ISPCTRL_SCMP_CLK_EN			(1 << 9)
+#define ISPCTRL_H3A_CLK_EN			(1 << 10)
+#define ISPCTRL_HIST_CLK_EN			(1 << 11)
+#define ISPCTRL_PREV_CLK_EN			(1 << 12)
+#define ISPCTRL_RSZ_CLK_EN			(1 << 13)
+#define ISPCTRL_SYNC_DETECT_SHIFT		14
+#define ISPCTRL_SYNC_DETECT_HSFALL	(0x0 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_HSRISE	(0x1 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSFALL	(0x2 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSRISE	(0x3 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_MASK	(0x3 << ISPCTRL_SYNC_DETECT_SHIFT)
+
+#define ISPCTRL_CCDC_RAM_EN		(1 << 16)
+#define ISPCTRL_PREV_RAM_EN		(1 << 17)
+#define ISPCTRL_SBL_RD_RAM_EN		(1 << 18)
+#define ISPCTRL_SBL_WR1_RAM_EN		(1 << 19)
+#define ISPCTRL_SBL_WR0_RAM_EN		(1 << 20)
+#define ISPCTRL_SBL_AUTOIDLE		(1 << 21)
+#define ISPCTRL_SBL_SHARED_WPORTC	(1 << 26)
+#define ISPCTRL_SBL_SHARED_RPORTA	(1 << 27)
+#define ISPCTRL_SBL_SHARED_RPORTB	(1 << 28)
+#define ISPCTRL_JPEG_FLUSH		(1 << 30)
+#define ISPCTRL_CCDC_FLUSH		(1 << 31)
+
+#define ISPSECURE_SECUREMODE		0
+
+#define ISPTCTRL_CTRL_DIV_LOW		0x0
+#define ISPTCTRL_CTRL_DIV_HIGH		0x1
+#define ISPTCTRL_CTRL_DIV_BYPASS	0x1F
+
+#define ISPTCTRL_CTRL_DIVA_SHIFT	0
+#define ISPTCTRL_CTRL_DIVA_MASK		(0x1F << ISPTCTRL_CTRL_DIVA_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVB_SHIFT	5
+#define ISPTCTRL_CTRL_DIVB_MASK		(0x1F << ISPTCTRL_CTRL_DIVB_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVC_SHIFT	10
+#define ISPTCTRL_CTRL_DIVC_NOCLOCK	(0x0 << 10)
+
+#define ISPTCTRL_CTRL_SHUTEN		(1 << 21)
+#define ISPTCTRL_CTRL_PSTRBEN		(1 << 22)
+#define ISPTCTRL_CTRL_STRBEN		(1 << 23)
+#define ISPTCTRL_CTRL_SHUTPOL		(1 << 24)
+#define ISPTCTRL_CTRL_STRBPSTRBPOL	(1 << 26)
+
+#define ISPTCTRL_CTRL_INSEL_SHIFT	27
+#define ISPTCTRL_CTRL_INSEL_PARALLEL	(0x0 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIA	(0x1 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIB	(0x2 << 27)
+
+#define ISPTCTRL_CTRL_GRESETEn		(1 << 29)
+#define ISPTCTRL_CTRL_GRESETPOL		(1 << 30)
+#define ISPTCTRL_CTRL_GRESETDIR		(1 << 31)
+
+#define ISPTCTRL_FRAME_SHUT_SHIFT		0
+#define ISPTCTRL_FRAME_PSTRB_SHIFT		6
+#define ISPTCTRL_FRAME_STRB_SHIFT		12
+
+#define ISPCCDC_PID_PREV_SHIFT			0
+#define ISPCCDC_PID_CID_SHIFT			8
+#define ISPCCDC_PID_TID_SHIFT			16
+
+#define ISPCCDC_PCR_EN				1
+#define ISPCCDC_PCR_BUSY			(1 << 1)
+
+#define ISPCCDC_SYN_MODE_VDHDOUT		0x1
+#define ISPCCDC_SYN_MODE_FLDOUT			(1 << 1)
+#define ISPCCDC_SYN_MODE_VDPOL			(1 << 2)
+#define ISPCCDC_SYN_MODE_HDPOL			(1 << 3)
+#define ISPCCDC_SYN_MODE_FLDPOL			(1 << 4)
+#define ISPCCDC_SYN_MODE_EXWEN			(1 << 5)
+#define ISPCCDC_SYN_MODE_DATAPOL		(1 << 6)
+#define ISPCCDC_SYN_MODE_FLDMODE		(1 << 7)
+#define ISPCCDC_SYN_MODE_DATSIZ_MASK		(0x7 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_8_16		(0x0 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_12		(0x4 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_11		(0x5 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_10		(0x6 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_8		(0x7 << 8)
+#define ISPCCDC_SYN_MODE_PACK8			(1 << 11)
+#define ISPCCDC_SYN_MODE_INPMOD_MASK		(3 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_RAW		(0 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR16		(1 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR8		(2 << 12)
+#define ISPCCDC_SYN_MODE_LPF			(1 << 14)
+#define ISPCCDC_SYN_MODE_FLDSTAT		(1 << 15)
+#define ISPCCDC_SYN_MODE_VDHDEN			(1 << 16)
+#define ISPCCDC_SYN_MODE_WEN			(1 << 17)
+#define ISPCCDC_SYN_MODE_VP2SDR			(1 << 18)
+#define ISPCCDC_SYN_MODE_SDR2RSZ		(1 << 19)
+
+#define ISPCCDC_HD_VD_WID_VDW_SHIFT		0
+#define ISPCCDC_HD_VD_WID_HDW_SHIFT		16
+
+#define ISPCCDC_PIX_LINES_HLPRF_SHIFT		0
+#define ISPCCDC_PIX_LINES_PPLN_SHIFT		16
+
+#define ISPCCDC_HORZ_INFO_NPH_SHIFT		0
+#define ISPCCDC_HORZ_INFO_NPH_MASK		0x00007fff
+#define ISPCCDC_HORZ_INFO_SPH_SHIFT		16
+#define ISPCCDC_HORZ_INFO_SPH_MASK		0x7fff0000
+
+#define ISPCCDC_VERT_START_SLV1_SHIFT		0
+#define ISPCCDC_VERT_START_SLV0_SHIFT		16
+#define ISPCCDC_VERT_START_SLV0_MASK		0x7fff0000
+
+#define ISPCCDC_VERT_LINES_NLV_SHIFT		0
+#define ISPCCDC_VERT_LINES_NLV_MASK		0x00007fff
+
+#define ISPCCDC_CULLING_CULV_SHIFT		0
+#define ISPCCDC_CULLING_CULHODD_SHIFT		16
+#define ISPCCDC_CULLING_CULHEVN_SHIFT		24
+
+#define ISPCCDC_HSIZE_OFF_SHIFT			0
+
+#define ISPCCDC_SDOFST_FINV			(1 << 14)
+#define ISPCCDC_SDOFST_FOFST_1L			0
+#define ISPCCDC_SDOFST_FOFST_4L			(3 << 12)
+#define ISPCCDC_SDOFST_LOFST3_SHIFT		0
+#define ISPCCDC_SDOFST_LOFST2_SHIFT		3
+#define ISPCCDC_SDOFST_LOFST1_SHIFT		6
+#define ISPCCDC_SDOFST_LOFST0_SHIFT		9
+#define EVENEVEN				1
+#define ODDEVEN					2
+#define EVENODD					3
+#define ODDODD					4
+
+#define ISPCCDC_CLAMP_OBGAIN_SHIFT		0
+#define ISPCCDC_CLAMP_OBST_SHIFT		10
+#define ISPCCDC_CLAMP_OBSLN_SHIFT		25
+#define ISPCCDC_CLAMP_OBSLEN_SHIFT		28
+#define ISPCCDC_CLAMP_CLAMPEN			(1 << 31)
+
+#define ISPCCDC_COLPTN_R_Ye			0x0
+#define ISPCCDC_COLPTN_Gr_Cy			0x1
+#define ISPCCDC_COLPTN_Gb_G			0x2
+#define ISPCCDC_COLPTN_B_Mg			0x3
+#define ISPCCDC_COLPTN_CP0PLC0_SHIFT		0
+#define ISPCCDC_COLPTN_CP0PLC1_SHIFT		2
+#define ISPCCDC_COLPTN_CP0PLC2_SHIFT		4
+#define ISPCCDC_COLPTN_CP0PLC3_SHIFT		6
+#define ISPCCDC_COLPTN_CP1PLC0_SHIFT		8
+#define ISPCCDC_COLPTN_CP1PLC1_SHIFT		10
+#define ISPCCDC_COLPTN_CP1PLC2_SHIFT		12
+#define ISPCCDC_COLPTN_CP1PLC3_SHIFT		14
+#define ISPCCDC_COLPTN_CP2PLC0_SHIFT		16
+#define ISPCCDC_COLPTN_CP2PLC1_SHIFT		18
+#define ISPCCDC_COLPTN_CP2PLC2_SHIFT		20
+#define ISPCCDC_COLPTN_CP2PLC3_SHIFT		22
+#define ISPCCDC_COLPTN_CP3PLC0_SHIFT		24
+#define ISPCCDC_COLPTN_CP3PLC1_SHIFT		26
+#define ISPCCDC_COLPTN_CP3PLC2_SHIFT		28
+#define ISPCCDC_COLPTN_CP3PLC3_SHIFT		30
+
+#define ISPCCDC_BLKCMP_B_MG_SHIFT		0
+#define ISPCCDC_BLKCMP_GB_G_SHIFT		8
+#define ISPCCDC_BLKCMP_GR_CY_SHIFT		16
+#define ISPCCDC_BLKCMP_R_YE_SHIFT		24
+
+#define ISPCCDC_FPC_FPNUM_SHIFT			0
+#define ISPCCDC_FPC_FPCEN			(1 << 15)
+#define ISPCCDC_FPC_FPERR			(1 << 16)
+
+#define ISPCCDC_VDINT_1_SHIFT			0
+#define ISPCCDC_VDINT_1_MASK			0x00007fff
+#define ISPCCDC_VDINT_0_SHIFT			16
+#define ISPCCDC_VDINT_0_MASK			0x7fff0000
+
+#define ISPCCDC_ALAW_GWDI_12_3			(0x3 << 0)
+#define ISPCCDC_ALAW_GWDI_11_2			(0x4 << 0)
+#define ISPCCDC_ALAW_GWDI_10_1			(0x5 << 0)
+#define ISPCCDC_ALAW_GWDI_9_0			(0x6 << 0)
+#define ISPCCDC_ALAW_CCDTBL			(1 << 3)
+
+#define ISPCCDC_REC656IF_R656ON			1
+#define ISPCCDC_REC656IF_ECCFVH			(1 << 1)
+
+#define ISPCCDC_CFG_BW656			(1 << 5)
+#define ISPCCDC_CFG_FIDMD_SHIFT			6
+#define ISPCCDC_CFG_WENLOG			(1 << 8)
+#define ISPCCDC_CFG_WENLOG_AND			(0 << 8)
+#define ISPCCDC_CFG_WENLOG_OR			(1 << 8)
+#define ISPCCDC_CFG_Y8POS			(1 << 11)
+#define ISPCCDC_CFG_BSWD			(1 << 12)
+#define ISPCCDC_CFG_MSBINVI			(1 << 13)
+#define ISPCCDC_CFG_VDLC			(1 << 15)
+
+#define ISPCCDC_FMTCFG_FMTEN			0x1
+#define ISPCCDC_FMTCFG_LNALT			(1 << 1)
+#define ISPCCDC_FMTCFG_LNUM_SHIFT		2
+#define ISPCCDC_FMTCFG_PLEN_ODD_SHIFT		4
+#define ISPCCDC_FMTCFG_PLEN_EVEN_SHIFT		8
+#define ISPCCDC_FMTCFG_VPIN_MASK		0x00007000
+#define ISPCCDC_FMTCFG_VPIN_12_3		(0x3 << 12)
+#define ISPCCDC_FMTCFG_VPIN_11_2		(0x4 << 12)
+#define ISPCCDC_FMTCFG_VPIN_10_1		(0x5 << 12)
+#define ISPCCDC_FMTCFG_VPIN_9_0			(0x6 << 12)
+#define ISPCCDC_FMTCFG_VPEN			(1 << 15)
+
+#define ISPCCDC_FMTCFG_VPIF_FRQ_MASK		0x003f0000
+#define ISPCCDC_FMTCFG_VPIF_FRQ_SHIFT		16
+#define ISPCCDC_FMTCFG_VPIF_FRQ_BY2		(0x0 << 16)
+#define ISPCCDC_FMTCFG_VPIF_FRQ_BY3		(0x1 << 16)
+#define ISPCCDC_FMTCFG_VPIF_FRQ_BY4		(0x2 << 16)
+#define ISPCCDC_FMTCFG_VPIF_FRQ_BY5		(0x3 << 16)
+#define ISPCCDC_FMTCFG_VPIF_FRQ_BY6		(0x4 << 16)
+
+#define ISPCCDC_FMT_HORZ_FMTLNH_SHIFT		0
+#define ISPCCDC_FMT_HORZ_FMTSPH_SHIFT		16
+
+#define ISPCCDC_FMT_VERT_FMTLNV_SHIFT		0
+#define ISPCCDC_FMT_VERT_FMTSLV_SHIFT		16
+
+#define ISPCCDC_FMT_HORZ_FMTSPH_MASK		0x1fff0000
+#define ISPCCDC_FMT_HORZ_FMTLNH_MASK		0x00001fff
+
+#define ISPCCDC_FMT_VERT_FMTSLV_MASK		0x1fff0000
+#define ISPCCDC_FMT_VERT_FMTLNV_MASK		0x00001fff
+
+#define ISPCCDC_VP_OUT_HORZ_ST_SHIFT		0
+#define ISPCCDC_VP_OUT_HORZ_NUM_SHIFT		4
+#define ISPCCDC_VP_OUT_VERT_NUM_SHIFT		17
+
+#define ISPRSZ_PID_PREV_SHIFT			0
+#define ISPRSZ_PID_CID_SHIFT			8
+#define ISPRSZ_PID_TID_SHIFT			16
+
+#define ISPRSZ_PCR_ENABLE			(1 << 0)
+#define ISPRSZ_PCR_BUSY				(1 << 1)
+#define ISPRSZ_PCR_ONESHOT			(1 << 2)
+
+#define ISPRSZ_CNT_HRSZ_SHIFT			0
+#define ISPRSZ_CNT_HRSZ_MASK			\
+	(0x3FF << ISPRSZ_CNT_HRSZ_SHIFT)
+#define ISPRSZ_CNT_VRSZ_SHIFT			10
+#define ISPRSZ_CNT_VRSZ_MASK			\
+	(0x3FF << ISPRSZ_CNT_VRSZ_SHIFT)
+#define ISPRSZ_CNT_HSTPH_SHIFT			20
+#define ISPRSZ_CNT_HSTPH_MASK			(0x7 << ISPRSZ_CNT_HSTPH_SHIFT)
+#define ISPRSZ_CNT_VSTPH_SHIFT			23
+#define ISPRSZ_CNT_VSTPH_MASK			(0x7 << ISPRSZ_CNT_VSTPH_SHIFT)
+#define ISPRSZ_CNT_YCPOS			(1 << 26)
+#define ISPRSZ_CNT_INPTYP			(1 << 27)
+#define ISPRSZ_CNT_INPSRC			(1 << 28)
+#define ISPRSZ_CNT_CBILIN			(1 << 29)
+
+#define ISPRSZ_OUT_SIZE_HORZ_SHIFT		0
+#define ISPRSZ_OUT_SIZE_HORZ_MASK		\
+	(0xFFF << ISPRSZ_OUT_SIZE_HORZ_SHIFT)
+#define ISPRSZ_OUT_SIZE_VERT_SHIFT		16
+#define ISPRSZ_OUT_SIZE_VERT_MASK		\
+	(0xFFF << ISPRSZ_OUT_SIZE_VERT_SHIFT)
+
+#define ISPRSZ_IN_START_HORZ_ST_SHIFT		0
+#define ISPRSZ_IN_START_HORZ_ST_MASK		\
+	(0x1FFF << ISPRSZ_IN_START_HORZ_ST_SHIFT)
+#define ISPRSZ_IN_START_VERT_ST_SHIFT		16
+#define ISPRSZ_IN_START_VERT_ST_MASK		\
+	(0x1FFF << ISPRSZ_IN_START_VERT_ST_SHIFT)
+
+#define ISPRSZ_IN_SIZE_HORZ_SHIFT		0
+#define ISPRSZ_IN_SIZE_HORZ_MASK		\
+	(0x1FFF << ISPRSZ_IN_SIZE_HORZ_SHIFT)
+#define ISPRSZ_IN_SIZE_VERT_SHIFT		16
+#define ISPRSZ_IN_SIZE_VERT_MASK		\
+	(0x1FFF << ISPRSZ_IN_SIZE_VERT_SHIFT)
+
+#define ISPRSZ_SDR_INADD_ADDR_SHIFT		0
+#define ISPRSZ_SDR_INADD_ADDR_MASK		0xFFFFFFFF
+
+#define ISPRSZ_SDR_INOFF_OFFSET_SHIFT		0
+#define ISPRSZ_SDR_INOFF_OFFSET_MASK		\
+	(0xFFFF << ISPRSZ_SDR_INOFF_OFFSET_SHIFT)
+
+#define ISPRSZ_SDR_OUTADD_ADDR_SHIFT		0
+#define ISPRSZ_SDR_OUTADD_ADDR_MASK		0xFFFFFFFF
+
+
+#define ISPRSZ_SDR_OUTOFF_OFFSET_SHIFT		0
+#define ISPRSZ_SDR_OUTOFF_OFFSET_MASK		\
+	(0xFFFF << ISPRSZ_SDR_OUTOFF_OFFSET_SHIFT)
+
+#define ISPRSZ_HFILT_COEF0_SHIFT		0
+#define ISPRSZ_HFILT_COEF0_MASK			\
+	(0x3FF << ISPRSZ_HFILT_COEF0_SHIFT)
+#define ISPRSZ_HFILT_COEF1_SHIFT		16
+#define ISPRSZ_HFILT_COEF1_MASK			\
+	(0x3FF << ISPRSZ_HFILT_COEF1_SHIFT)
+
+#define ISPRSZ_HFILT32_COEF2_SHIFT		0
+#define ISPRSZ_HFILT32_COEF2_MASK		0x3FF
+#define ISPRSZ_HFILT32_COEF3_SHIFT		16
+#define ISPRSZ_HFILT32_COEF3_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT54_COEF4_SHIFT		0
+#define ISPRSZ_HFILT54_COEF4_MASK		0x3FF
+#define ISPRSZ_HFILT54_COEF5_SHIFT		16
+#define ISPRSZ_HFILT54_COEF5_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT76_COEFF6_SHIFT		0
+#define ISPRSZ_HFILT76_COEFF6_MASK		0x3FF
+#define ISPRSZ_HFILT76_COEFF7_SHIFT		16
+#define ISPRSZ_HFILT76_COEFF7_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT98_COEFF8_SHIFT		0
+#define ISPRSZ_HFILT98_COEFF8_MASK		0x3FF
+#define ISPRSZ_HFILT98_COEFF9_SHIFT		16
+#define ISPRSZ_HFILT98_COEFF9_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1110_COEF10_SHIFT		0
+#define ISPRSZ_HFILT1110_COEF10_MASK		0x3FF
+#define ISPRSZ_HFILT1110_COEF11_SHIFT		16
+#define ISPRSZ_HFILT1110_COEF11_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1312_COEFF12_SHIFT		0
+#define ISPRSZ_HFILT1312_COEFF12_MASK		0x3FF
+#define ISPRSZ_HFILT1312_COEFF13_SHIFT		16
+#define ISPRSZ_HFILT1312_COEFF13_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1514_COEFF14_SHIFT		0
+#define ISPRSZ_HFILT1514_COEFF14_MASK		0x3FF
+#define ISPRSZ_HFILT1514_COEFF15_SHIFT		16
+#define ISPRSZ_HFILT1514_COEFF15_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1716_COEF16_SHIFT		0
+#define ISPRSZ_HFILT1716_COEF16_MASK		0x3FF
+#define ISPRSZ_HFILT1716_COEF17_SHIFT		16
+#define ISPRSZ_HFILT1716_COEF17_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1918_COEF18_SHIFT		0
+#define ISPRSZ_HFILT1918_COEF18_MASK		0x3FF
+#define ISPRSZ_HFILT1918_COEF19_SHIFT		16
+#define ISPRSZ_HFILT1918_COEF19_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2120_COEF20_SHIFT		0
+#define ISPRSZ_HFILT2120_COEF20_MASK		0x3FF
+#define ISPRSZ_HFILT2120_COEF21_SHIFT		16
+#define ISPRSZ_HFILT2120_COEF21_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2322_COEF22_SHIFT		0
+#define ISPRSZ_HFILT2322_COEF22_MASK		0x3FF
+#define ISPRSZ_HFILT2322_COEF23_SHIFT		16
+#define ISPRSZ_HFILT2322_COEF23_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2524_COEF24_SHIFT		0
+#define ISPRSZ_HFILT2524_COEF24_MASK		0x3FF
+#define ISPRSZ_HFILT2524_COEF25_SHIFT		16
+#define ISPRSZ_HFILT2524_COEF25_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2726_COEF26_SHIFT		0
+#define ISPRSZ_HFILT2726_COEF26_MASK		0x3FF
+#define ISPRSZ_HFILT2726_COEF27_SHIFT		16
+#define ISPRSZ_HFILT2726_COEF27_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2928_COEF28_SHIFT		0
+#define ISPRSZ_HFILT2928_COEF28_MASK		0x3FF
+#define ISPRSZ_HFILT2928_COEF29_SHIFT		16
+#define ISPRSZ_HFILT2928_COEF29_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT3130_COEF30_SHIFT		0
+#define ISPRSZ_HFILT3130_COEF30_MASK		0x3FF
+#define ISPRSZ_HFILT3130_COEF31_SHIFT		16
+#define ISPRSZ_HFILT3130_COEF31_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT_COEF0_SHIFT		0
+#define ISPRSZ_VFILT_COEF0_MASK			\
+	(0x3FF << ISPRSZ_VFILT_COEF0_SHIFT)
+#define ISPRSZ_VFILT_COEF1_SHIFT		16
+#define ISPRSZ_VFILT_COEF1_MASK			\
+	(0x3FF << ISPRSZ_VFILT_COEF1_SHIFT)
+
+#define ISPRSZ_VFILT10_COEF0_SHIFT		0
+#define ISPRSZ_VFILT10_COEF0_MASK		0x3FF
+#define ISPRSZ_VFILT10_COEF1_SHIFT		16
+#define ISPRSZ_VFILT10_COEF1_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT32_COEF2_SHIFT		0
+#define ISPRSZ_VFILT32_COEF2_MASK		0x3FF
+#define ISPRSZ_VFILT32_COEF3_SHIFT		16
+#define ISPRSZ_VFILT32_COEF3_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT54_COEF4_SHIFT		0
+#define ISPRSZ_VFILT54_COEF4_MASK		0x3FF
+#define ISPRSZ_VFILT54_COEF5_SHIFT		16
+#define ISPRSZ_VFILT54_COEF5_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT76_COEFF6_SHIFT		0
+#define ISPRSZ_VFILT76_COEFF6_MASK		0x3FF
+#define ISPRSZ_VFILT76_COEFF7_SHIFT		16
+#define ISPRSZ_VFILT76_COEFF7_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT98_COEFF8_SHIFT		0
+#define ISPRSZ_VFILT98_COEFF8_MASK		0x3FF
+#define ISPRSZ_VFILT98_COEFF9_SHIFT		16
+#define ISPRSZ_VFILT98_COEFF9_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1110_COEF10_SHIFT		0
+#define ISPRSZ_VFILT1110_COEF10_MASK		0x3FF
+#define ISPRSZ_VFILT1110_COEF11_SHIFT		16
+#define ISPRSZ_VFILT1110_COEF11_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1312_COEFF12_SHIFT		0
+#define ISPRSZ_VFILT1312_COEFF12_MASK		0x3FF
+#define ISPRSZ_VFILT1312_COEFF13_SHIFT		16
+#define ISPRSZ_VFILT1312_COEFF13_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1514_COEFF14_SHIFT		0
+#define ISPRSZ_VFILT1514_COEFF14_MASK		0x3FF
+#define ISPRSZ_VFILT1514_COEFF15_SHIFT		16
+#define ISPRSZ_VFILT1514_COEFF15_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1716_COEF16_SHIFT		0
+#define ISPRSZ_VFILT1716_COEF16_MASK		0x3FF
+#define ISPRSZ_VFILT1716_COEF17_SHIFT		16
+#define ISPRSZ_VFILT1716_COEF17_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1918_COEF18_SHIFT		0
+#define ISPRSZ_VFILT1918_COEF18_MASK		0x3FF
+#define ISPRSZ_VFILT1918_COEF19_SHIFT		16
+#define ISPRSZ_VFILT1918_COEF19_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2120_COEF20_SHIFT		0
+#define ISPRSZ_VFILT2120_COEF20_MASK		0x3FF
+#define ISPRSZ_VFILT2120_COEF21_SHIFT		16
+#define ISPRSZ_VFILT2120_COEF21_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2322_COEF22_SHIFT		0
+#define ISPRSZ_VFILT2322_COEF22_MASK		0x3FF
+#define ISPRSZ_VFILT2322_COEF23_SHIFT		16
+#define ISPRSZ_VFILT2322_COEF23_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2524_COEF24_SHIFT		0
+#define ISPRSZ_VFILT2524_COEF24_MASK		0x3FF
+#define ISPRSZ_VFILT2524_COEF25_SHIFT		16
+#define ISPRSZ_VFILT2524_COEF25_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2726_COEF26_SHIFT		0
+#define ISPRSZ_VFILT2726_COEF26_MASK		0x3FF
+#define ISPRSZ_VFILT2726_COEF27_SHIFT		16
+#define ISPRSZ_VFILT2726_COEF27_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2928_COEF28_SHIFT		0
+#define ISPRSZ_VFILT2928_COEF28_MASK		0x3FF
+#define ISPRSZ_VFILT2928_COEF29_SHIFT		16
+#define ISPRSZ_VFILT2928_COEF29_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT3130_COEF30_SHIFT		0
+#define ISPRSZ_VFILT3130_COEF30_MASK		0x3FF
+#define ISPRSZ_VFILT3130_COEF31_SHIFT		16
+#define ISPRSZ_VFILT3130_COEF31_MASK		0x3FF0000
+
+#define ISPRSZ_YENH_CORE_SHIFT			0
+#define ISPRSZ_YENH_CORE_MASK			\
+	(0xFF << ISPRSZ_YENH_CORE_SHIFT)
+#define ISPRSZ_YENH_SLOP_SHIFT			8
+#define ISPRSZ_YENH_SLOP_MASK			\
+	(0xF << ISPRSZ_YENH_SLOP_SHIFT)
+#define ISPRSZ_YENH_GAIN_SHIFT			12
+#define ISPRSZ_YENH_GAIN_MASK			\
+	(0xF << ISPRSZ_YENH_GAIN_SHIFT)
+#define ISPRSZ_YENH_ALGO_SHIFT			16
+#define ISPRSZ_YENH_ALGO_MASK			\
+	(0x3 << ISPRSZ_YENH_ALGO_SHIFT)
+
+#define ISPH3A_PCR_AEW_ALAW_EN_SHIFT		1
+#define ISPH3A_PCR_AF_MED_TH_SHIFT		3
+#define ISPH3A_PCR_AF_RGBPOS_SHIFT		11
+#define ISPH3A_PCR_AEW_AVE2LMT_SHIFT		22
+#define ISPH3A_PCR_AEW_AVE2LMT_MASK		0xFFC00000
+#define ISPH3A_PCR_BUSYAF			(1 << 15)
+#define ISPH3A_PCR_BUSYAEAWB			(1 << 18)
+
+#define ISPH3A_AEWWIN1_WINHC_SHIFT		0
+#define ISPH3A_AEWWIN1_WINHC_MASK		0x3F
+#define ISPH3A_AEWWIN1_WINVC_SHIFT		6
+#define ISPH3A_AEWWIN1_WINVC_MASK		0x1FC0
+#define ISPH3A_AEWWIN1_WINW_SHIFT		13
+#define ISPH3A_AEWWIN1_WINW_MASK		0xFE000
+#define ISPH3A_AEWWIN1_WINH_SHIFT		24
+#define ISPH3A_AEWWIN1_WINH_MASK		0x7F000000
+
+#define ISPH3A_AEWINSTART_WINSH_SHIFT		0
+#define ISPH3A_AEWINSTART_WINSH_MASK		0x0FFF
+#define ISPH3A_AEWINSTART_WINSV_SHIFT		16
+#define ISPH3A_AEWINSTART_WINSV_MASK		0x0FFF0000
+
+#define ISPH3A_AEWINBLK_WINH_SHIFT		0
+#define ISPH3A_AEWINBLK_WINH_MASK		0x7F
+#define ISPH3A_AEWINBLK_WINSV_SHIFT		16
+#define ISPH3A_AEWINBLK_WINSV_MASK		0x0FFF0000
+
+#define ISPH3A_AEWSUBWIN_AEWINCH_SHIFT		0
+#define ISPH3A_AEWSUBWIN_AEWINCH_MASK		0x0F
+#define ISPH3A_AEWSUBWIN_AEWINCV_SHIFT		8
+#define ISPH3A_AEWSUBWIN_AEWINCV_MASK		0x0F00
+
+#define ISPHIST_PCR_ENABLE_SHIFT	0
+#define ISPHIST_PCR_ENABLE_MASK		0x01
+#define ISPHIST_PCR_ENABLE		(1 << ISPHIST_PCR_ENABLE_SHIFT)
+#define ISPHIST_PCR_BUSY		0x02
+
+#define ISPHIST_CNT_DATASIZE_SHIFT	8
+#define ISPHIST_CNT_DATASIZE_MASK	0x0100
+#define ISPHIST_CNT_CLEAR_SHIFT		7
+#define ISPHIST_CNT_CLEAR_MASK		0x080
+#define ISPHIST_CNT_CLEAR		(1 << ISPHIST_CNT_CLEAR_SHIFT)
+#define ISPHIST_CNT_CFA_SHIFT		6
+#define ISPHIST_CNT_CFA_MASK		0x040
+#define ISPHIST_CNT_BINS_SHIFT		4
+#define ISPHIST_CNT_BINS_MASK		0x030
+#define ISPHIST_CNT_SOURCE_SHIFT	3
+#define ISPHIST_CNT_SOURCE_MASK		0x08
+#define ISPHIST_CNT_SHIFT_SHIFT		0
+#define ISPHIST_CNT_SHIFT_MASK		0x07
+
+#define ISPHIST_WB_GAIN_WG00_SHIFT	24
+#define ISPHIST_WB_GAIN_WG00_MASK	0xFF000000
+#define ISPHIST_WB_GAIN_WG01_SHIFT	16
+#define ISPHIST_WB_GAIN_WG01_MASK	0xFF0000
+#define ISPHIST_WB_GAIN_WG02_SHIFT	8
+#define ISPHIST_WB_GAIN_WG02_MASK	0xFF00
+#define ISPHIST_WB_GAIN_WG03_SHIFT	0
+#define ISPHIST_WB_GAIN_WG03_MASK	0xFF
+
+#define ISPHIST_REG_START_END_MASK		0x3FFF
+#define ISPHIST_REG_START_SHIFT			16
+#define ISPHIST_REG_END_SHIFT			0
+#define ISPHIST_REG_START_MASK			(ISPHIST_REG_START_END_MASK << \
+						 ISPHIST_REG_START_SHIFT)
+#define ISPHIST_REG_END_MASK			(ISPHIST_REG_START_END_MASK << \
+						 ISPHIST_REG_END_SHIFT)
+
+#define ISPHIST_REG_MASK			(ISPHIST_REG_START_MASK | \
+						 ISPHIST_REG_END_MASK)
+
+#define ISPHIST_ADDR_SHIFT			0
+#define ISPHIST_ADDR_MASK			0x3FF
+
+#define ISPHIST_DATA_SHIFT			0
+#define ISPHIST_DATA_MASK			0xFFFFF
+
+#define ISPHIST_RADD_SHIFT			0
+#define ISPHIST_RADD_MASK			0xFFFFFFFF
+
+#define ISPHIST_RADD_OFF_SHIFT			0
+#define ISPHIST_RADD_OFF_MASK			0xFFFF
+
+#define ISPHIST_HV_INFO_HSIZE_SHIFT		16
+#define ISPHIST_HV_INFO_HSIZE_MASK		0x3FFF0000
+#define ISPHIST_HV_INFO_VSIZE_SHIFT		0
+#define ISPHIST_HV_INFO_VSIZE_MASK		0x3FFF
+
+#define ISPHIST_HV_INFO_MASK			0x3FFF3FFF
+
+#define ISPCCDC_LSC_ENABLE			1
+#define ISPCCDC_LSC_BUSY			(1 << 7)
+#define ISPCCDC_LSC_GAIN_MODE_N_MASK		0x700
+#define ISPCCDC_LSC_GAIN_MODE_N_SHIFT		8
+#define ISPCCDC_LSC_GAIN_MODE_M_MASK		0x3800
+#define ISPCCDC_LSC_GAIN_MODE_M_SHIFT		12
+#define ISPCCDC_LSC_GAIN_FORMAT_MASK		0xE
+#define ISPCCDC_LSC_GAIN_FORMAT_SHIFT		1
+#define ISPCCDC_LSC_AFTER_REFORMATTER_MASK	(1<<6)
+
+#define ISPCCDC_LSC_INITIAL_X_MASK		0x3F
+#define ISPCCDC_LSC_INITIAL_X_SHIFT		0
+#define ISPCCDC_LSC_INITIAL_Y_MASK		0x3F0000
+#define ISPCCDC_LSC_INITIAL_Y_SHIFT		16
+
+/* -----------------------------------------------------------------------------
+ * CSI2 receiver registers (ES2.0)
+ */
+
+#define ISPCSI2_REVISION			(0x000)
+#define ISPCSI2_SYSCONFIG			(0x010)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT	12
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_MASK	\
+	(0x3 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_FORCE	\
+	(0x0 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_NO	\
+	(0x1 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SMART	\
+	(0x2 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_SOFT_RESET		(1 << 1)
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE		(1 << 0)
+
+#define ISPCSI2_SYSSTATUS			(0x014)
+#define ISPCSI2_SYSSTATUS_RESET_DONE		(1 << 0)
+
+#define ISPCSI2_IRQSTATUS			(0x018)
+#define ISPCSI2_IRQSTATUS_OCP_ERR_IRQ		(1 << 14)
+#define ISPCSI2_IRQSTATUS_SHORT_PACKET_IRQ	(1 << 13)
+#define ISPCSI2_IRQSTATUS_ECC_CORRECTION_IRQ	(1 << 12)
+#define ISPCSI2_IRQSTATUS_ECC_NO_CORRECTION_IRQ	(1 << 11)
+#define ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ	(1 << 10)
+#define ISPCSI2_IRQSTATUS_COMPLEXIO1_ERR_IRQ	(1 << 9)
+#define ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ		(1 << 8)
+#define ISPCSI2_IRQSTATUS_CONTEXT(n)		(1 << (n))
+
+#define ISPCSI2_IRQENABLE			(0x01c)
+#define ISPCSI2_CTRL				(0x040)
+#define ISPCSI2_CTRL_VP_CLK_EN			(1 << 15)
+#define ISPCSI2_CTRL_VP_ONLY_EN			(1 << 11)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT		8
+#define ISPCSI2_CTRL_VP_OUT_CTRL_MASK		\
+	(3 << ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_DBG_EN			(1 << 7)
+#define ISPCSI2_CTRL_BURST_SIZE_SHIFT		5
+#define ISPCSI2_CTRL_BURST_SIZE_MASK		\
+	(3 << ISPCSI2_CTRL_BURST_SIZE_SHIFT)
+#define ISPCSI2_CTRL_FRAME			(1 << 3)
+#define ISPCSI2_CTRL_ECC_EN			(1 << 2)
+#define ISPCSI2_CTRL_SECURE			(1 << 1)
+#define ISPCSI2_CTRL_IF_EN			(1 << 0)
+
+#define ISPCSI2_DBG_H				(0x044)
+#define ISPCSI2_GNQ				(0x048)
+#define ISPCSI2_PHY_CFG				(0x050)
+#define ISPCSI2_PHY_CFG_RESET_CTRL		(1 << 30)
+#define ISPCSI2_PHY_CFG_RESET_DONE		(1 << 29)
+#define ISPCSI2_PHY_CFG_PWR_CMD_SHIFT		27
+#define ISPCSI2_PHY_CFG_PWR_CMD_MASK		\
+	(0x3 << ISPCSI2_PHY_CFG_PWR_CMD_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_CMD_OFF		\
+	(0x0 << ISPCSI2_PHY_CFG_PWR_CMD_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_CMD_ON		\
+	(0x1 << ISPCSI2_PHY_CFG_PWR_CMD_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_CMD_ULPW		\
+	(0x2 << ISPCSI2_PHY_CFG_PWR_CMD_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_STATUS_SHIFT	25
+#define ISPCSI2_PHY_CFG_PWR_STATUS_MASK		\
+	(0x3 << ISPCSI2_PHY_CFG_PWR_STATUS_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_STATUS_OFF		\
+	(0x0 << ISPCSI2_PHY_CFG_PWR_STATUS_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_STATUS_ON		\
+	(0x1 << ISPCSI2_PHY_CFG_PWR_STATUS_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_STATUS_ULPW		\
+	(0x2 << ISPCSI2_PHY_CFG_PWR_STATUS_SHIFT)
+#define ISPCSI2_PHY_CFG_PWR_AUTO		(1 << 24)
+
+#define ISPCSI2_PHY_CFG_DATA_POL_SHIFT(n)	(3 + ((n) * 4))
+#define ISPCSI2_PHY_CFG_DATA_POL_MASK(n)	\
+	(0x1 << ISPCSI2_PHY_CFG_DATA_POL_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POL_PN(n)		\
+	(0x0 << ISPCSI2_PHY_CFG_DATA_POL_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POL_NP(n)		\
+	(0x1 << ISPCSI2_PHY_CFG_DATA_POL_SHIFT(n))
+
+#define ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n)	((n) * 4)
+#define ISPCSI2_PHY_CFG_DATA_POSITION_MASK(n)	\
+	(0x7 << ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POSITION_NC(n)	\
+	(0x0 << ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POSITION_1(n)	\
+	(0x1 << ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POSITION_2(n)	\
+	(0x2 << ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POSITION_3(n)	\
+	(0x3 << ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POSITION_4(n)	\
+	(0x4 << ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_PHY_CFG_DATA_POSITION_5(n)	\
+	(0x5 << ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(n))
+
+#define ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT		3
+#define ISPCSI2_PHY_CFG_CLOCK_POL_MASK		\
+	(0x1 << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT)
+#define ISPCSI2_PHY_CFG_CLOCK_POL_PN		\
+	(0x0 << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT)
+#define ISPCSI2_PHY_CFG_CLOCK_POL_NP		\
+	(0x1 << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT)
+
+#define ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT	0
+#define ISPCSI2_PHY_CFG_CLOCK_POSITION_MASK	\
+	(0x7 << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_PHY_CFG_CLOCK_POSITION_1	\
+	(0x1 << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_PHY_CFG_CLOCK_POSITION_2	\
+	(0x2 << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_PHY_CFG_CLOCK_POSITION_3	\
+	(0x3 << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_PHY_CFG_CLOCK_POSITION_4	\
+	(0x4 << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_PHY_CFG_CLOCK_POSITION_5	\
+	(0x5 << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT)
+
+#define ISPCSI2_PHY_IRQSTATUS			(0x054)
+#define ISPCSI2_PHY_IRQSTATUS_STATEALLULPMEXIT	(1 << 26)
+#define ISPCSI2_PHY_IRQSTATUS_STATEALLULPMENTER	(1 << 25)
+#define ISPCSI2_PHY_IRQSTATUS_STATEULPM5	(1 << 24)
+#define ISPCSI2_PHY_IRQSTATUS_STATEULPM4	(1 << 23)
+#define ISPCSI2_PHY_IRQSTATUS_STATEULPM3	(1 << 22)
+#define ISPCSI2_PHY_IRQSTATUS_STATEULPM2	(1 << 21)
+#define ISPCSI2_PHY_IRQSTATUS_STATEULPM1	(1 << 20)
+#define ISPCSI2_PHY_IRQSTATUS_ERRCONTROL5	(1 << 19)
+#define ISPCSI2_PHY_IRQSTATUS_ERRCONTROL4	(1 << 18)
+#define ISPCSI2_PHY_IRQSTATUS_ERRCONTROL3	(1 << 17)
+#define ISPCSI2_PHY_IRQSTATUS_ERRCONTROL2	(1 << 16)
+#define ISPCSI2_PHY_IRQSTATUS_ERRCONTROL1	(1 << 15)
+#define ISPCSI2_PHY_IRQSTATUS_ERRESC5		(1 << 14)
+#define ISPCSI2_PHY_IRQSTATUS_ERRESC4		(1 << 13)
+#define ISPCSI2_PHY_IRQSTATUS_ERRESC3		(1 << 12)
+#define ISPCSI2_PHY_IRQSTATUS_ERRESC2		(1 << 11)
+#define ISPCSI2_PHY_IRQSTATUS_ERRESC1		(1 << 10)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTSYNCHS5	(1 << 9)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTSYNCHS4	(1 << 8)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTSYNCHS3	(1 << 7)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTSYNCHS2	(1 << 6)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTSYNCHS1	(1 << 5)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTHS5		(1 << 4)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTHS4		(1 << 3)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTHS3		(1 << 2)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTHS2		(1 << 1)
+#define ISPCSI2_PHY_IRQSTATUS_ERRSOTHS1		1
+
+#define ISPCSI2_SHORT_PACKET			(0x05c)
+#define ISPCSI2_PHY_IRQENABLE			(0x060)
+#define ISPCSI2_PHY_IRQENABLE_STATEALLULPMEXIT	(1 << 26)
+#define ISPCSI2_PHY_IRQENABLE_STATEALLULPMENTER	(1 << 25)
+#define ISPCSI2_PHY_IRQENABLE_STATEULPM5	(1 << 24)
+#define ISPCSI2_PHY_IRQENABLE_STATEULPM4	(1 << 23)
+#define ISPCSI2_PHY_IRQENABLE_STATEULPM3	(1 << 22)
+#define ISPCSI2_PHY_IRQENABLE_STATEULPM2	(1 << 21)
+#define ISPCSI2_PHY_IRQENABLE_STATEULPM1	(1 << 20)
+#define ISPCSI2_PHY_IRQENABLE_ERRCONTROL5	(1 << 19)
+#define ISPCSI2_PHY_IRQENABLE_ERRCONTROL4	(1 << 18)
+#define ISPCSI2_PHY_IRQENABLE_ERRCONTROL3	(1 << 17)
+#define ISPCSI2_PHY_IRQENABLE_ERRCONTROL2	(1 << 16)
+#define ISPCSI2_PHY_IRQENABLE_ERRCONTROL1	(1 << 15)
+#define ISPCSI2_PHY_IRQENABLE_ERRESC5		(1 << 14)
+#define ISPCSI2_PHY_IRQENABLE_ERRESC4		(1 << 13)
+#define ISPCSI2_PHY_IRQENABLE_ERRESC3		(1 << 12)
+#define ISPCSI2_PHY_IRQENABLE_ERRESC2		(1 << 11)
+#define ISPCSI2_PHY_IRQENABLE_ERRESC1		(1 << 10)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS5	(1 << 9)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS4	(1 << 8)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS3	(1 << 7)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS2	(1 << 6)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTSYNCHS1	(1 << 5)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTHS5		(1 << 4)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTHS4		(1 << 3)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTHS3		(1 << 2)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTHS2		(1 << 1)
+#define ISPCSI2_PHY_IRQENABLE_ERRSOTHS1		(1 << 0)
+
+#define ISPCSI2_DBG_P				(0x068)
+#define ISPCSI2_TIMING				(0x06c)
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO(n)	(1 << ((16 * ((n) - 1)) + 15))
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO(n)	(1 << ((16 * ((n) - 1)) + 14))
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO(n)	(1 << ((16 * ((n) - 1)) + 13))
+#define ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_SHIFT(n)	(16 * ((n) - 1))
+#define ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_MASK(n)	\
+	(0x1fff << ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_SHIFT(n))
+
+#define ISPCSI2_CTX_CTRL1(n)			((0x070) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL1_COUNT_SHIFT		8
+#define ISPCSI2_CTX_CTRL1_COUNT_MASK		\
+	(0xff << ISPCSI2_CTX_CTRL1_COUNT_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOF_EN		(1 << 7)
+#define ISPCSI2_CTX_CTRL1_EOL_EN		(1 << 6)
+#define ISPCSI2_CTX_CTRL1_CS_EN			(1 << 5)
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK		(1 << 4)
+#define ISPCSI2_CTX_CTRL1_PING_PONG		(1 << 3)
+#define ISPCSI2_CTX_CTRL1_CTX_EN		(1 << 0)
+
+#define ISPCSI2_CTX_CTRL2(n)			((0x074) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT	13
+#define ISPCSI2_CTX_CTRL2_USER_DEF_MAP_MASK	\
+	(0x3 << ISPCSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT)
+#define ISPCSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT	11
+#define ISPCSI2_CTX_CTRL2_VIRTUAL_ID_MASK	\
+	(0x3 <<	ISPCSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT)
+#define ISPCSI2_CTX_CTRL2_DPCM_PRED		(1 << 10)
+#define ISPCSI2_CTX_CTRL2_FORMAT_SHIFT		0
+#define ISPCSI2_CTX_CTRL2_FORMAT_MASK		\
+	(0x3ff << ISPCSI2_CTX_CTRL2_FORMAT_SHIFT)
+#define ISPCSI2_CTX_CTRL2_FRAME_SHIFT		16
+#define ISPCSI2_CTX_CTRL2_FRAME_MASK		\
+	(0xffff << ISPCSI2_CTX_CTRL2_FRAME_SHIFT)
+
+#define ISPCSI2_CTX_DAT_OFST(n)			((0x078) + 0x20 * (n))
+#define ISPCSI2_CTX_DAT_OFST_OFST_SHIFT		0
+#define ISPCSI2_CTX_DAT_OFST_OFST_MASK		\
+	(0x1ffe0 << ISPCSI2_CTX_DAT_OFST_OFST_SHIFT)
+
+#define ISPCSI2_CTX_DAT_PING_ADDR(n)		((0x07c) + 0x20 * (n))
+#define ISPCSI2_CTX_DAT_PONG_ADDR(n)		((0x080) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQENABLE(n)		((0x084) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQENABLE_ECC_CORRECTION_IRQ	(1 << 8)
+#define ISPCSI2_CTX_IRQENABLE_LINE_NUMBER_IRQ	(1 << 7)
+#define ISPCSI2_CTX_IRQENABLE_FRAME_NUMBER_IRQ	(1 << 6)
+#define ISPCSI2_CTX_IRQENABLE_CS_IRQ		(1 << 5)
+#define ISPCSI2_CTX_IRQENABLE_LE_IRQ		(1 << 3)
+#define ISPCSI2_CTX_IRQENABLE_LS_IRQ		(1 << 2)
+#define ISPCSI2_CTX_IRQENABLE_FE_IRQ		(1 << 1)
+#define ISPCSI2_CTX_IRQENABLE_FS_IRQ		(1 << 0)
+
+#define ISPCSI2_CTX_IRQSTATUS(n)		((0x088) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQSTATUS_ECC_CORRECTION_IRQ	(1 << 8)
+#define ISPCSI2_CTX_IRQSTATUS_LINE_NUMBER_IRQ	(1 << 7)
+#define ISPCSI2_CTX_IRQSTATUS_FRAME_NUMBER_IRQ	(1 << 6)
+#define ISPCSI2_CTX_IRQSTATUS_CS_IRQ		(1 << 5)
+#define ISPCSI2_CTX_IRQSTATUS_LE_IRQ		(1 << 3)
+#define ISPCSI2_CTX_IRQSTATUS_LS_IRQ		(1 << 2)
+#define ISPCSI2_CTX_IRQSTATUS_FE_IRQ		(1 << 1)
+#define ISPCSI2_CTX_IRQSTATUS_FS_IRQ		(1 << 0)
+
+#define ISPCSI2_CTX_CTRL3(n)			((0x08c) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL3_ALPHA_SHIFT		5
+#define ISPCSI2_CTX_CTRL3_ALPHA_MASK		\
+	(0x3fff << ISPCSI2_CTX_CTRL3_ALPHA_SHIFT)
+
+/* This instance is for OMAP3630 only */
+#define ISPCSI2_CTX_TRANSCODEH(n)		(0x000 + 0x8 * (n))
+#define ISPCSI2_CTX_TRANSCODEH_HCOUNT_SHIFT	16
+#define ISPCSI2_CTX_TRANSCODEH_HCOUNT_MASK	\
+	(0x1fff << ISPCSI2_CTX_TRANSCODEH_HCOUNT_SHIFT)
+#define ISPCSI2_CTX_TRANSCODEH_HSKIP_SHIFT	0
+#define ISPCSI2_CTX_TRANSCODEH_HSKIP_MASK	\
+	(0x1fff << ISPCSI2_CTX_TRANSCODEH_HCOUNT_SHIFT)
+#define ISPCSI2_CTX_TRANSCODEV(n)		(0x004 + 0x8 * (n))
+#define ISPCSI2_CTX_TRANSCODEV_VCOUNT_SHIFT	16
+#define ISPCSI2_CTX_TRANSCODEV_VCOUNT_MASK	\
+	(0x1fff << ISPCSI2_CTX_TRANSCODEV_VCOUNT_SHIFT)
+#define ISPCSI2_CTX_TRANSCODEV_VSKIP_SHIFT	0
+#define ISPCSI2_CTX_TRANSCODEV_VSKIP_MASK	\
+	(0x1fff << ISPCSI2_CTX_TRANSCODEV_VCOUNT_SHIFT)
+
+/* -----------------------------------------------------------------------------
+ * CSI PHY registers
+ */
+
+#define ISPCSIPHY_REG0				(0x000)
+#define ISPCSIPHY_REG0_THS_TERM_SHIFT		8
+#define ISPCSIPHY_REG0_THS_TERM_MASK		\
+	(0xff << ISPCSIPHY_REG0_THS_TERM_SHIFT)
+#define ISPCSIPHY_REG0_THS_SETTLE_SHIFT		0
+#define ISPCSIPHY_REG0_THS_SETTLE_MASK		\
+	(0xff << ISPCSIPHY_REG0_THS_SETTLE_SHIFT)
+
+#define ISPCSIPHY_REG1					(0x004)
+#define ISPCSIPHY_REG1_RESET_DONE_CTRLCLK		(1 << 29)
+/* This field is for OMAP3630 only */
+#define ISPCSIPHY_REG1_CLOCK_MISS_DETECTOR_STATUS	(1 << 25)
+#define ISPCSIPHY_REG1_TCLK_TERM_SHIFT			18
+#define ISPCSIPHY_REG1_TCLK_TERM_MASK			\
+	(0x7f << ISPCSIPHY_REG1_TCLK_TERM_SHIFT)
+#define ISPCSIPHY_REG1_DPHY_HS_SYNC_PATTERN_SHIFT	10
+#define ISPCSIPHY_REG1_DPHY_HS_SYNC_PATTERN_MASK	\
+	(0xff << ISPCSIPHY_REG1_DPHY_HS_SYNC_PATTERN)
+/* This field is for OMAP3430 only */
+#define ISPCSIPHY_REG1_TCLK_MISS_SHIFT			8
+#define ISPCSIPHY_REG1_TCLK_MISS_MASK			\
+	(0x3 << ISPCSIPHY_REG1_TCLK_MISS_SHIFT)
+/* This field is for OMAP3630 only */
+#define ISPCSIPHY_REG1_CTRLCLK_DIV_FACTOR_SHIFT		8
+#define ISPCSIPHY_REG1_CTRLCLK_DIV_FACTOR_MASK		\
+	(0x3 << ISPCSIPHY_REG1_CTRLCLK_DIV_FACTOR_SHIFT)
+#define ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT		0
+#define ISPCSIPHY_REG1_TCLK_SETTLE_MASK			\
+	(0xff << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT)
+
+/* This register is for OMAP3630 only */
+#define ISPCSIPHY_REG2					(0x008)
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC0_SHIFT	30
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC0_MASK	\
+	(0x3 << ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC0_SHIFT)
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC1_SHIFT	28
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC1_MASK	\
+	(0x3 << ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC1_SHIFT)
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC2_SHIFT	26
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC2_MASK	\
+	(0x3 << ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC2_SHIFT)
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC3_SHIFT	24
+#define ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC3_MASK	\
+	(0x3 << ISPCSIPHY_REG2_TRIGGER_CMD_RXTRIGESC3_SHIFT)
+#define ISPCSIPHY_REG2_CCP2_SYNC_PATTERN_SHIFT		0
+#define ISPCSIPHY_REG2_CCP2_SYNC_PATTERN_MASK		\
+	(0x7fffff << ISPCSIPHY_REG2_CCP2_SYNC_PATTERN_SHIFT)
+
+#endif	/* OMAP3_ISP_REG_H */
diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
new file mode 100644
index 0000000..150822b
--- /dev/null
+++ b/include/linux/omap3isp.h
@@ -0,0 +1,646 @@
+/*
+ * omap3isp.h
+ *
+ * TI OMAP3 ISP - User-space API
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
+#ifndef OMAP3_ISP_USER_H
+#define OMAP3_ISP_USER_H
+
+#include <linux/types.h>
+
+/*
+ * Private IOCTLs
+ *
+ * VIDIOC_OMAP3ISP_CCDC_CFG: Set CCDC configuration
+ * VIDIOC_OMAP3ISP_PRV_CFG: Set preview engine configuration
+ * VIDIOC_OMAP3ISP_AEWB_CFG: Set AEWB module configuration
+ * VIDIOC_OMAP3ISP_HIST_CFG: Set histogram module configuration
+ * VIDIOC_OMAP3ISP_AF_CFG: Set auto-focus module configuration
+ * VIDIOC_OMAP3ISP_STAT_REQ: Read statistics (AEWB/AF/histogram) data
+ * VIDIOC_OMAP3ISP_STAT_EN: Enable/disable a statistics module
+ */
+
+#define VIDIOC_OMAP3ISP_CCDC_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct omap3isp_ccdc_update_config)
+#define VIDIOC_OMAP3ISP_PRV_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 2, struct omap3isp_prev_update_config)
+#define VIDIOC_OMAP3ISP_AEWB_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 3, struct omap3isp_h3a_aewb_config)
+#define VIDIOC_OMAP3ISP_HIST_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 4, struct omap3isp_hist_config)
+#define VIDIOC_OMAP3ISP_AF_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct omap3isp_h3a_af_config)
+#define VIDIOC_OMAP3ISP_STAT_REQ \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct omap3isp_stat_data)
+#define VIDIOC_OMAP3ISP_STAT_EN \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 7, unsigned long)
+
+/*
+ * Events
+ *
+ * V4L2_EVENT_OMAP3ISP_AEWB: AEWB statistics data ready
+ * V4L2_EVENT_OMAP3ISP_AF: AF statistics data ready
+ * V4L2_EVENT_OMAP3ISP_HIST: Histogram statistics data ready
+ * V4L2_EVENT_OMAP3ISP_HS_VS: Horizontal/vertical synchronization detected
+ */
+
+#define V4L2_EVENT_OMAP3ISP_CLASS	(V4L2_EVENT_PRIVATE_START | 0x100)
+#define V4L2_EVENT_OMAP3ISP_AEWB	(V4L2_EVENT_OMAP3ISP_CLASS | 0x1)
+#define V4L2_EVENT_OMAP3ISP_AF		(V4L2_EVENT_OMAP3ISP_CLASS | 0x2)
+#define V4L2_EVENT_OMAP3ISP_HIST	(V4L2_EVENT_OMAP3ISP_CLASS | 0x3)
+#define V4L2_EVENT_OMAP3ISP_HS_VS	(V4L2_EVENT_OMAP3ISP_CLASS | 0x4)
+
+struct omap3isp_stat_event_status {
+	__u32 frame_number;
+	__u16 config_counter;
+	__u8 buf_err;
+};
+
+/* AE/AWB related structures and flags*/
+
+/* H3A Range Constants */
+#define OMAP3ISP_AEWB_MAX_SATURATION_LIM	1023
+#define OMAP3ISP_AEWB_MIN_WIN_H			2
+#define OMAP3ISP_AEWB_MAX_WIN_H			256
+#define OMAP3ISP_AEWB_MIN_WIN_W			6
+#define OMAP3ISP_AEWB_MAX_WIN_W			256
+#define OMAP3ISP_AEWB_MIN_WINVC			1
+#define OMAP3ISP_AEWB_MIN_WINHC			1
+#define OMAP3ISP_AEWB_MAX_WINVC			128
+#define OMAP3ISP_AEWB_MAX_WINHC			36
+#define OMAP3ISP_AEWB_MAX_WINSTART		4095
+#define OMAP3ISP_AEWB_MIN_SUB_INC		2
+#define OMAP3ISP_AEWB_MAX_SUB_INC		32
+#define OMAP3ISP_AEWB_MAX_BUF_SIZE		83600
+
+#define OMAP3ISP_AF_IIRSH_MIN			0
+#define OMAP3ISP_AF_IIRSH_MAX			4095
+#define OMAP3ISP_AF_PAXEL_HORIZONTAL_COUNT_MIN	1
+#define OMAP3ISP_AF_PAXEL_HORIZONTAL_COUNT_MAX	36
+#define OMAP3ISP_AF_PAXEL_VERTICAL_COUNT_MIN	1
+#define OMAP3ISP_AF_PAXEL_VERTICAL_COUNT_MAX	128
+#define OMAP3ISP_AF_PAXEL_INCREMENT_MIN		2
+#define OMAP3ISP_AF_PAXEL_INCREMENT_MAX		32
+#define OMAP3ISP_AF_PAXEL_HEIGHT_MIN		2
+#define OMAP3ISP_AF_PAXEL_HEIGHT_MAX		256
+#define OMAP3ISP_AF_PAXEL_WIDTH_MIN		16
+#define OMAP3ISP_AF_PAXEL_WIDTH_MAX		256
+#define OMAP3ISP_AF_PAXEL_HZSTART_MIN		1
+#define OMAP3ISP_AF_PAXEL_HZSTART_MAX		4095
+#define OMAP3ISP_AF_PAXEL_VTSTART_MIN		0
+#define OMAP3ISP_AF_PAXEL_VTSTART_MAX		4095
+#define OMAP3ISP_AF_THRESHOLD_MAX		255
+#define OMAP3ISP_AF_COEF_MAX			4095
+#define OMAP3ISP_AF_PAXEL_SIZE			48
+#define OMAP3ISP_AF_MAX_BUF_SIZE		221184
+
+/**
+ * struct omap3isp_h3a_aewb_config - AE AWB configuration reset values
+ * saturation_limit: Saturation limit.
+ * @win_height: Window Height. Range 2 - 256, even values only.
+ * @win_width: Window Width. Range 6 - 256, even values only.
+ * @ver_win_count: Vertical Window Count. Range 1 - 128.
+ * @hor_win_count: Horizontal Window Count. Range 1 - 36.
+ * @ver_win_start: Vertical Window Start. Range 0 - 4095.
+ * @hor_win_start: Horizontal Window Start. Range 0 - 4095.
+ * @blk_ver_win_start: Black Vertical Windows Start. Range 0 - 4095.
+ * @blk_win_height: Black Window Height. Range 2 - 256, even values only.
+ * @subsample_ver_inc: Subsample Vertical points increment Range 2 - 32, even
+ *                     values only.
+ * @subsample_hor_inc: Subsample Horizontal points increment Range 2 - 32, even
+ *                     values only.
+ * @alaw_enable: AEW ALAW EN flag.
+ */
+struct omap3isp_h3a_aewb_config {
+	/*
+	 * Common fields.
+	 * They should be the first ones and must be in the same order as in
+	 * ispstat_generic_config struct.
+	 */
+	__u32 buf_size;
+	__u16 config_counter;
+
+	/* Private fields */
+	__u16 saturation_limit;
+	__u16 win_height;
+	__u16 win_width;
+	__u16 ver_win_count;
+	__u16 hor_win_count;
+	__u16 ver_win_start;
+	__u16 hor_win_start;
+	__u16 blk_ver_win_start;
+	__u16 blk_win_height;
+	__u16 subsample_ver_inc;
+	__u16 subsample_hor_inc;
+	__u8 alaw_enable;
+};
+
+/**
+ * struct omap3isp_stat_data - Statistic data sent to or received from user
+ * @ts: Timestamp of returned framestats.
+ * @buf: Pointer to pass to user.
+ * @frame_number: Frame number of requested stats.
+ * @cur_frame: Current frame number being processed.
+ * @config_counter: Number of the configuration associated with the data.
+ */
+struct omap3isp_stat_data {
+	struct timeval ts;
+	void __user *buf;
+	__u32 buf_size;
+	__u16 frame_number;
+	__u16 cur_frame;
+	__u16 config_counter;
+};
+
+
+/* Histogram related structs */
+
+/* Flags for number of bins */
+#define OMAP3ISP_HIST_BINS_32		0
+#define OMAP3ISP_HIST_BINS_64		1
+#define OMAP3ISP_HIST_BINS_128		2
+#define OMAP3ISP_HIST_BINS_256		3
+
+/* Number of bins * 4 colors * 4-bytes word */
+#define OMAP3ISP_HIST_MEM_SIZE_BINS(n)	((1 << ((n)+5))*4*4)
+
+#define OMAP3ISP_HIST_MEM_SIZE		1024
+#define OMAP3ISP_HIST_MIN_REGIONS	1
+#define OMAP3ISP_HIST_MAX_REGIONS	4
+#define OMAP3ISP_HIST_MAX_WB_GAIN	255
+#define OMAP3ISP_HIST_MIN_WB_GAIN	0
+#define OMAP3ISP_HIST_MAX_BIT_WIDTH	14
+#define OMAP3ISP_HIST_MIN_BIT_WIDTH	8
+#define OMAP3ISP_HIST_MAX_WG		4
+#define OMAP3ISP_HIST_MAX_BUF_SIZE	4096
+
+/* Source */
+#define OMAP3ISP_HIST_SOURCE_CCDC	0
+#define OMAP3ISP_HIST_SOURCE_MEM	1
+
+/* CFA pattern */
+#define OMAP3ISP_HIST_CFA_BAYER		0
+#define OMAP3ISP_HIST_CFA_FOVEONX3	1
+
+struct omap3isp_hist_region {
+	__u16 h_start;
+	__u16 h_end;
+	__u16 v_start;
+	__u16 v_end;
+};
+
+struct omap3isp_hist_config {
+	/*
+	 * Common fields.
+	 * They should be the first ones and must be in the same order as in
+	 * ispstat_generic_config struct.
+	 */
+	__u32 buf_size;
+	__u16 config_counter;
+
+	__u8 num_acc_frames;	/* Num of image frames to be processed and
+				   accumulated for each histogram frame */
+	__u16 hist_bins;	/* number of bins: 32, 64, 128, or 256 */
+	__u8 cfa;		/* BAYER or FOVEON X3 */
+	__u8 wg[OMAP3ISP_HIST_MAX_WG];	/* White Balance Gain */
+	__u8 num_regions;	/* number of regions to be configured */
+	struct omap3isp_hist_region region[OMAP3ISP_HIST_MAX_REGIONS];
+};
+
+/* Auto Focus related structs */
+
+#define OMAP3ISP_AF_NUM_COEF		11
+
+enum omap3isp_h3a_af_fvmode {
+	OMAP3ISP_AF_MODE_SUMMED = 0,
+	OMAP3ISP_AF_MODE_PEAK = 1
+};
+
+/* Red, Green, and blue pixel location in the AF windows */
+enum omap3isp_h3a_af_rgbpos {
+	OMAP3ISP_AF_GR_GB_BAYER = 0,	/* GR and GB as Bayer pattern */
+	OMAP3ISP_AF_RG_GB_BAYER = 1,	/* RG and GB as Bayer pattern */
+	OMAP3ISP_AF_GR_BG_BAYER = 2,	/* GR and BG as Bayer pattern */
+	OMAP3ISP_AF_RG_BG_BAYER = 3,	/* RG and BG as Bayer pattern */
+	OMAP3ISP_AF_GG_RB_CUSTOM = 4,	/* GG and RB as custom pattern */
+	OMAP3ISP_AF_RB_GG_CUSTOM = 5	/* RB and GG as custom pattern */
+};
+
+/* Contains the information regarding the Horizontal Median Filter */
+struct omap3isp_h3a_af_hmf {
+	__u8 enable;	/* Status of Horizontal Median Filter */
+	__u8 threshold;	/* Threshhold Value for Horizontal Median Filter */
+};
+
+/* Contains the information regarding the IIR Filters */
+struct omap3isp_h3a_af_iir {
+	__u16 h_start;			/* IIR horizontal start */
+	__u16 coeff_set0[OMAP3ISP_AF_NUM_COEF];	/* Filter coefficient, set 0 */
+	__u16 coeff_set1[OMAP3ISP_AF_NUM_COEF];	/* Filter coefficient, set 1 */
+};
+
+/* Contains the information regarding the Paxels Structure in AF Engine */
+struct omap3isp_h3a_af_paxel {
+	__u16 h_start;	/* Horizontal Start Position */
+	__u16 v_start;	/* Vertical Start Position */
+	__u8 width;	/* Width of the Paxel */
+	__u8 height;	/* Height of the Paxel */
+	__u8 h_cnt;	/* Horizontal Count */
+	__u8 v_cnt;	/* vertical Count */
+	__u8 line_inc;	/* Line Increment */
+};
+
+/* Contains the parameters required for hardware set up of AF Engine */
+struct omap3isp_h3a_af_config {
+	/*
+	 * Common fields.
+	 * They should be the first ones and must be in the same order as in
+	 * ispstat_generic_config struct.
+	 */
+	__u32 buf_size;
+	__u16 config_counter;
+
+	struct omap3isp_h3a_af_hmf hmf;		/* HMF configurations */
+	struct omap3isp_h3a_af_iir iir;		/* IIR filter configurations */
+	struct omap3isp_h3a_af_paxel paxel;	/* Paxel parameters */
+	enum omap3isp_h3a_af_rgbpos rgb_pos;	/* RGB Positions */
+	enum omap3isp_h3a_af_fvmode fvmode;	/* Accumulator mode */
+	__u8 alaw_enable;			/* AF ALAW status */
+};
+
+/* ISP CCDC structs */
+
+/* Abstraction layer CCDC configurations */
+#define OMAP3ISP_CCDC_ALAW		(1 << 0)
+#define OMAP3ISP_CCDC_LPF		(1 << 1)
+#define OMAP3ISP_CCDC_BLCLAMP		(1 << 2)
+#define OMAP3ISP_CCDC_BCOMP		(1 << 3)
+#define OMAP3ISP_CCDC_FPC		(1 << 4)
+#define OMAP3ISP_CCDC_CULL		(1 << 5)
+#define OMAP3ISP_CCDC_CONFIG_LSC	(1 << 7)
+#define OMAP3ISP_CCDC_TBL_LSC		(1 << 8)
+
+#define OMAP3ISP_RGB_MAX		3
+
+/* Enumeration constants for Alaw input width */
+enum omap3isp_alaw_ipwidth {
+	OMAP3ISP_ALAW_BIT12_3 = 0x3,
+	OMAP3ISP_ALAW_BIT11_2 = 0x4,
+	OMAP3ISP_ALAW_BIT10_1 = 0x5,
+	OMAP3ISP_ALAW_BIT9_0 = 0x6
+};
+
+/**
+ * struct omap3isp_ccdc_lsc_config - LSC configuration
+ * @offset: Table Offset of the gain table.
+ * @gain_mode_n: Vertical dimension of a paxel in LSC configuration.
+ * @gain_mode_m: Horizontal dimension of a paxel in LSC configuration.
+ * @gain_format: Gain table format.
+ * @fmtsph: Start pixel horizontal from start of the HS sync pulse.
+ * @fmtlnh: Number of pixels in horizontal direction to use for the data
+ *          reformatter.
+ * @fmtslv: Start line from start of VS sync pulse for the data reformatter.
+ * @fmtlnv: Number of lines in vertical direction for the data reformatter.
+ * @initial_x: X position, in pixels, of the first active pixel in reference
+ *             to the first active paxel. Must be an even number.
+ * @initial_y: Y position, in pixels, of the first active pixel in reference
+ *             to the first active paxel. Must be an even number.
+ * @size: Size of LSC gain table. Filled when loaded from userspace.
+ */
+struct omap3isp_ccdc_lsc_config {
+	__u16 offset;
+	__u8 gain_mode_n;
+	__u8 gain_mode_m;
+	__u8 gain_format;
+	__u16 fmtsph;
+	__u16 fmtlnh;
+	__u16 fmtslv;
+	__u16 fmtlnv;
+	__u8 initial_x;
+	__u8 initial_y;
+	__u32 size;
+};
+
+/**
+ * struct omap3isp_ccdc_bclamp - Optical & Digital black clamp subtract
+ * @obgain: Optical black average gain.
+ * @obstpixel: Start Pixel w.r.t. HS pulse in Optical black sample.
+ * @oblines: Optical Black Sample lines.
+ * @oblen: Optical Black Sample Length.
+ * @dcsubval: Digital Black Clamp subtract value.
+ */
+struct omap3isp_ccdc_bclamp {
+	__u8 obgain;
+	__u8 obstpixel;
+	__u8 oblines;
+	__u8 oblen;
+	__u16 dcsubval;
+};
+
+/**
+ * struct omap3isp_ccdc_fpc - Faulty Pixels Correction
+ * @fpnum: Number of faulty pixels to be corrected in the frame.
+ * @fpcaddr: Memory address of the FPC Table
+ */
+struct omap3isp_ccdc_fpc {
+	__u16 fpnum;
+	__u32 fpcaddr;
+};
+
+/**
+ * struct omap3isp_ccdc_blcomp - Black Level Compensation parameters
+ * @b_mg: B/Mg pixels. 2's complement. -128 to +127.
+ * @gb_g: Gb/G pixels. 2's complement. -128 to +127.
+ * @gr_cy: Gr/Cy pixels. 2's complement. -128 to +127.
+ * @r_ye: R/Ye pixels. 2's complement. -128 to +127.
+ */
+struct omap3isp_ccdc_blcomp {
+	__u8 b_mg;
+	__u8 gb_g;
+	__u8 gr_cy;
+	__u8 r_ye;
+};
+
+/**
+ * omap3isp_ccdc_culling - Culling parameters
+ * @v_pattern: Vertical culling pattern.
+ * @h_odd: Horizontal Culling pattern for odd lines.
+ * @h_even: Horizontal Culling pattern for even lines.
+ */
+struct omap3isp_ccdc_culling {
+	__u8 v_pattern;
+	__u16 h_odd;
+	__u16 h_even;
+};
+
+/**
+ * omap3isp_ccdc_update_config - CCDC configuration
+ * @update: Specifies which CCDC registers should be updated.
+ * @flag: Specifies which CCDC functions should be enabled.
+ * @alawip: Enable/Disable A-Law compression.
+ * @bclamp: Black clamp control register.
+ * @blcomp: Black level compensation value for RGrGbB Pixels. 2's complement.
+ * @fpc: Number of faulty pixels corrected in the frame, address of FPC table.
+ * @cull: Cull control register.
+ * @lsc: Pointer to LSC gain table.
+ */
+struct omap3isp_ccdc_update_config {
+	__u16 update;
+	__u16 flag;
+	enum omap3isp_alaw_ipwidth alawip;
+	struct omap3isp_ccdc_bclamp __user *bclamp;
+	struct omap3isp_ccdc_blcomp __user *blcomp;
+	struct omap3isp_ccdc_fpc __user *fpc;
+	struct omap3isp_ccdc_lsc_config __user *lsc_cfg;
+	struct omap3isp_ccdc_culling __user *cull;
+	__u8 __user *lsc;
+};
+
+/* Preview configurations */
+#define OMAP3ISP_PREV_LUMAENH		(1 << 0)
+#define OMAP3ISP_PREV_INVALAW		(1 << 1)
+#define OMAP3ISP_PREV_HRZ_MED		(1 << 2)
+#define OMAP3ISP_PREV_CFA		(1 << 3)
+#define OMAP3ISP_PREV_CHROMA_SUPP	(1 << 4)
+#define OMAP3ISP_PREV_WB		(1 << 5)
+#define OMAP3ISP_PREV_BLKADJ		(1 << 6)
+#define OMAP3ISP_PREV_RGB2RGB		(1 << 7)
+#define OMAP3ISP_PREV_COLOR_CONV	(1 << 8)
+#define OMAP3ISP_PREV_YC_LIMIT		(1 << 9)
+#define OMAP3ISP_PREV_DEFECT_COR	(1 << 10)
+#define OMAP3ISP_PREV_GAMMABYPASS	(1 << 11)
+#define OMAP3ISP_PREV_DRK_FRM_CAPTURE	(1 << 12)
+#define OMAP3ISP_PREV_DRK_FRM_SUBTRACT	(1 << 13)
+#define OMAP3ISP_PREV_LENS_SHADING	(1 << 14)
+#define OMAP3ISP_PREV_NF		(1 << 15)
+#define OMAP3ISP_PREV_GAMMA		(1 << 16)
+
+#define OMAP3ISP_PREV_NF_TBL_SIZE	64
+#define OMAP3ISP_PREV_CFA_TBL_SIZE	576
+#define OMAP3ISP_PREV_GAMMA_TBL_SIZE	1024
+#define OMAP3ISP_PREV_YENH_TBL_SIZE	128
+
+#define OMAP3ISP_PREV_DETECT_CORRECT_CHANNELS	4
+
+/**
+ * struct omap3isp_prev_hmed - Horizontal Median Filter
+ * @odddist: Distance between consecutive pixels of same color in the odd line.
+ * @evendist: Distance between consecutive pixels of same color in the even
+ *            line.
+ * @thres: Horizontal median filter threshold.
+ */
+struct omap3isp_prev_hmed {
+	__u8 odddist;
+	__u8 evendist;
+	__u8 thres;
+};
+
+/*
+ * Enumeration for CFA Formats supported by preview
+ */
+enum omap3isp_cfa_fmt {
+	OMAP3ISP_CFAFMT_BAYER,
+	OMAP3ISP_CFAFMT_SONYVGA,
+	OMAP3ISP_CFAFMT_RGBFOVEON,
+	OMAP3ISP_CFAFMT_DNSPL,
+	OMAP3ISP_CFAFMT_HONEYCOMB,
+	OMAP3ISP_CFAFMT_RRGGBBFOVEON
+};
+
+/**
+ * struct omap3isp_prev_cfa - CFA Interpolation
+ * @format: CFA Format Enum value supported by preview.
+ * @gradthrs_vert: CFA Gradient Threshold - Vertical.
+ * @gradthrs_horz: CFA Gradient Threshold - Horizontal.
+ * @table: Pointer to the CFA table.
+ */
+struct omap3isp_prev_cfa {
+	enum omap3isp_cfa_fmt format;
+	__u8 gradthrs_vert;
+	__u8 gradthrs_horz;
+	__u32 table[OMAP3ISP_PREV_CFA_TBL_SIZE];
+};
+
+/**
+ * struct omap3isp_prev_csup - Chrominance Suppression
+ * @gain: Gain.
+ * @thres: Threshold.
+ * @hypf_en: Flag to enable/disable the High Pass Filter.
+ */
+struct omap3isp_prev_csup {
+	__u8 gain;
+	__u8 thres;
+	__u8 hypf_en;
+};
+
+/**
+ * struct omap3isp_prev_wbal - White Balance
+ * @dgain: Digital gain (U10Q8).
+ * @coef3: White balance gain - COEF 3 (U8Q5).
+ * @coef2: White balance gain - COEF 2 (U8Q5).
+ * @coef1: White balance gain - COEF 1 (U8Q5).
+ * @coef0: White balance gain - COEF 0 (U8Q5).
+ */
+struct omap3isp_prev_wbal {
+	__u16 dgain;
+	__u8 coef3;
+	__u8 coef2;
+	__u8 coef1;
+	__u8 coef0;
+};
+
+/**
+ * struct omap3isp_prev_blkadj - Black Level Adjustment
+ * @red: Black level offset adjustment for Red in 2's complement format
+ * @green: Black level offset adjustment for Green in 2's complement format
+ * @blue: Black level offset adjustment for Blue in 2's complement format
+ */
+struct omap3isp_prev_blkadj {
+	/*Black level offset adjustment for Red in 2's complement format */
+	__u8 red;
+	/*Black level offset adjustment for Green in 2's complement format */
+	__u8 green;
+	/* Black level offset adjustment for Blue in 2's complement format */
+	__u8 blue;
+};
+
+/**
+ * struct omap3isp_prev_rgbtorgb - RGB to RGB Blending
+ * @matrix: Blending values(S12Q8 format)
+ *              [RR] [GR] [BR]
+ *              [RG] [GG] [BG]
+ *              [RB] [GB] [BB]
+ * @offset: Blending offset value for R,G,B in 2's complement integer format.
+ */
+struct omap3isp_prev_rgbtorgb {
+	__u16 matrix[OMAP3ISP_RGB_MAX][OMAP3ISP_RGB_MAX];
+	__u16 offset[OMAP3ISP_RGB_MAX];
+};
+
+/**
+ * struct omap3isp_prev_csc - Color Space Conversion from RGB-YCbYCr
+ * @matrix: Color space conversion coefficients(S10Q8)
+ *              [CSCRY]  [CSCGY]  [CSCBY]
+ *              [CSCRCB] [CSCGCB] [CSCBCB]
+ *              [CSCRCR] [CSCGCR] [CSCBCR]
+ * @offset: CSC offset values for Y offset, CB offset and CR offset respectively
+ */
+struct omap3isp_prev_csc {
+	__u16 matrix[OMAP3ISP_RGB_MAX][OMAP3ISP_RGB_MAX];
+	__s16 offset[OMAP3ISP_RGB_MAX];
+};
+
+/**
+ * struct omap3isp_prev_yclimit - Y, C Value Limit
+ * @minC: Minimum C value
+ * @maxC: Maximum C value
+ * @minY: Minimum Y value
+ * @maxY: Maximum Y value
+ */
+struct omap3isp_prev_yclimit {
+	__u8 minC;
+	__u8 maxC;
+	__u8 minY;
+	__u8 maxY;
+};
+
+/**
+ * struct omap3isp_prev_dcor - Defect correction
+ * @couplet_mode_en: Flag to enable or disable the couplet dc Correction in NF
+ * @detect_correct: Thresholds for correction bit 0:10 detect 16:25 correct
+ */
+struct omap3isp_prev_dcor {
+	__u8 couplet_mode_en;
+	__u32 detect_correct[OMAP3ISP_PREV_DETECT_CORRECT_CHANNELS];
+};
+
+/**
+ * struct omap3isp_prev_nf - Noise Filter
+ * @spread: Spread value to be used in Noise Filter
+ * @table: Pointer to the Noise Filter table
+ */
+struct omap3isp_prev_nf {
+	__u8 spread;
+	__u32 table[OMAP3ISP_PREV_NF_TBL_SIZE];
+};
+
+/**
+ * struct omap3isp_prev_gtables - Gamma correction tables
+ * @red: Array for red gamma table.
+ * @green: Array for green gamma table.
+ * @blue: Array for blue gamma table.
+ */
+struct omap3isp_prev_gtables {
+	__u32 red[OMAP3ISP_PREV_GAMMA_TBL_SIZE];
+	__u32 green[OMAP3ISP_PREV_GAMMA_TBL_SIZE];
+	__u32 blue[OMAP3ISP_PREV_GAMMA_TBL_SIZE];
+};
+
+/**
+ * struct omap3isp_prev_luma - Luma enhancement
+ * @table: Array for luma enhancement table.
+ */
+struct omap3isp_prev_luma {
+	__u32 table[OMAP3ISP_PREV_YENH_TBL_SIZE];
+};
+
+/**
+ * struct omap3isp_prev_update_config - Preview engine configuration (user)
+ * @update: Specifies which ISP Preview registers should be updated.
+ * @flag: Specifies which ISP Preview functions should be enabled.
+ * @shading_shift: 3bit value of shift used in shading compensation.
+ * @luma: Pointer to luma enhancement structure.
+ * @hmed: Pointer to structure containing the odd and even distance.
+ *        between the pixels in the image along with the filter threshold.
+ * @cfa: Pointer to structure containing the CFA interpolation table, CFA.
+ *       format in the image, vertical and horizontal gradient threshold.
+ * @csup: Pointer to Structure for Chrominance Suppression coefficients.
+ * @wbal: Pointer to structure for White Balance.
+ * @blkadj: Pointer to structure for Black Adjustment.
+ * @rgb2rgb: Pointer to structure for RGB to RGB Blending.
+ * @csc: Pointer to structure for Color Space Conversion from RGB-YCbYCr.
+ * @yclimit: Pointer to structure for Y, C Value Limit.
+ * @dcor: Pointer to structure for defect correction.
+ * @nf: Pointer to structure for Noise Filter
+ * @gamma: Pointer to gamma structure.
+ */
+struct omap3isp_prev_update_config {
+	__u32 update;
+	__u32 flag;
+	__u32 shading_shift;
+	struct omap3isp_prev_luma __user *luma;
+	struct omap3isp_prev_hmed __user *hmed;
+	struct omap3isp_prev_cfa __user *cfa;
+	struct omap3isp_prev_csup __user *csup;
+	struct omap3isp_prev_wbal __user *wbal;
+	struct omap3isp_prev_blkadj __user *blkadj;
+	struct omap3isp_prev_rgbtorgb __user *rgb2rgb;
+	struct omap3isp_prev_csc __user *csc;
+	struct omap3isp_prev_yclimit __user *yclimit;
+	struct omap3isp_prev_dcor __user *dcor;
+	struct omap3isp_prev_nf __user *nf;
+	struct omap3isp_prev_gtables __user *gamma;
+};
+
+#endif	/* OMAP3_ISP_USER_H */
-- 
1.7.3.4

