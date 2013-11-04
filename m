Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48333 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3KDAGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 03/18] v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
Date: Mon,  4 Nov 2013 01:06:28 +0100
Message-Id: <1383523603-3907-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergio Aguirre <sergio.a.aguirre@gmail.com>

This adds a very simplistic driver to utilize the CSI2A interface inside
the ISS subsystem in OMAP4, and dump the data to memory.

Check Documentation/video4linux/omap4_camera.txt for details.

This commit adds CSI receivers support.

Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>

[Port the driver to v3.12-rc3, including the following changes
- Don't include plat/ headers
- Don't use cpu_is_omap44xx() macro
- Don't depend on EXPERIMENTAL
- Fix s_crop operation prototype
- Update link_notify prototype
- Rename media_entity_remote_source to media_entity_remote_pad]

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c   | 1368 +++++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_csi2.h   |  156 +++
 drivers/staging/media/omap4iss/iss_csiphy.c |  278 ++++++
 drivers/staging/media/omap4iss/iss_csiphy.h |   51 +
 4 files changed, 1853 insertions(+)
 create mode 100644 drivers/staging/media/omap4iss/iss_csi2.c
 create mode 100644 drivers/staging/media/omap4iss/iss_csi2.h
 create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.c
 create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.h

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
new file mode 100644
index 0000000..0ee8381
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -0,0 +1,1368 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI PHY module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <media/v4l2-common.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/mm.h>
+
+#include "iss.h"
+#include "iss_regs.h"
+#include "iss_csi2.h"
+
+/*
+ * csi2_if_enable - Enable CSI2 Receiver interface.
+ * @enable: enable flag
+ *
+ */
+static void csi2_if_enable(struct iss_csi2_device *csi2, u8 enable)
+{
+	struct iss_csi2_ctrl_cfg *currctrl = &csi2->ctrl;
+
+	writel((readl(csi2->regs1 + CSI2_CTRL) & ~CSI2_CTRL_IF_EN) |
+		(enable ? CSI2_CTRL_IF_EN : 0),
+		csi2->regs1 + CSI2_CTRL);
+
+	currctrl->if_enable = enable;
+}
+
+/*
+ * csi2_recv_config - CSI2 receiver module configuration.
+ * @currctrl: iss_csi2_ctrl_cfg structure
+ *
+ */
+static void csi2_recv_config(struct iss_csi2_device *csi2,
+			     struct iss_csi2_ctrl_cfg *currctrl)
+{
+	u32 reg = 0;
+
+	if (currctrl->frame_mode)
+		reg |= CSI2_CTRL_FRAME;
+	else
+		reg &= ~CSI2_CTRL_FRAME;
+
+	if (currctrl->vp_clk_enable)
+		reg |= CSI2_CTRL_VP_CLK_EN;
+	else
+		reg &= ~CSI2_CTRL_VP_CLK_EN;
+
+	if (currctrl->vp_only_enable)
+		reg |= CSI2_CTRL_VP_ONLY_EN;
+	else
+		reg &= ~CSI2_CTRL_VP_ONLY_EN;
+
+	reg &= ~CSI2_CTRL_VP_OUT_CTRL_MASK;
+	reg |= currctrl->vp_out_ctrl << CSI2_CTRL_VP_OUT_CTRL_SHIFT;
+
+	if (currctrl->ecc_enable)
+		reg |= CSI2_CTRL_ECC_EN;
+	else
+		reg &= ~CSI2_CTRL_ECC_EN;
+
+	/*
+	 * Set MFlag assertion boundaries to:
+	 * Low: 4/8 of FIFO size
+	 * High: 6/8 of FIFO size
+	 */
+	reg &= ~(CSI2_CTRL_MFLAG_LEVH_MASK | CSI2_CTRL_MFLAG_LEVL_MASK);
+	reg |= (2 << CSI2_CTRL_MFLAG_LEVH_SHIFT) |
+	       (4 << CSI2_CTRL_MFLAG_LEVL_SHIFT);
+
+	/* Generation of 16x64-bit bursts (Recommended) */
+	reg |= CSI2_CTRL_BURST_SIZE_EXPAND;
+
+	/* Do Non-Posted writes (Recommended) */
+	reg |= CSI2_CTRL_NON_POSTED_WRITE;
+
+	/*
+	 * Enforce Little endian for all formats, including:
+	 * YUV4:2:2 8-bit and YUV4:2:0 Legacy
+	 */
+	reg |= CSI2_CTRL_ENDIANNESS;
+
+	writel(reg, csi2->regs1 + CSI2_CTRL);
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
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+	V4L2_MBUS_FMT_SGBRG8_1X8,
+	V4L2_MBUS_FMT_SGRBG8_1X8,
+	V4L2_MBUS_FMT_SRGGB8_1X8,
+	V4L2_MBUS_FMT_UYVY8_1X16,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+};
+
+/* To set the format on the CSI2 requires a mapping function that takes
+ * the following inputs:
+ * - 3 different formats (at this time)
+ * - 2 destinations (mem, vp+mem) (vp only handled separately)
+ * - 2 decompression options (on, off)
+ * Output should be CSI2 frame format code
+ * Array indices as follows: [format][dest][decompr]
+ * Not all combinations are valid. 0 means invalid.
+ */
+static const u16 __csi2_fmt_map[][2][2] = {
+	/* RAW10 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW10_EXP16,
+			/* DPCM decompression */
+			0,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW10_EXP16_VP,
+			/* DPCM decompression */
+			0,
+		},
+	},
+	/* RAW10 DPCM8 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_USERDEF_8BIT_DATA1,
+			/* DPCM decompression */
+			CSI2_USERDEF_8BIT_DATA1_DPCM10,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW8_VP,
+			/* DPCM decompression */
+			CSI2_USERDEF_8BIT_DATA1_DPCM10_VP,
+		},
+	},
+	/* RAW8 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW8,
+			/* DPCM decompression */
+			0,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_RAW8_VP,
+			/* DPCM decompression */
+			0,
+		},
+	},
+	/* YUV422 formats */
+	{
+		/* Output to memory */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_YUV422_8BIT,
+			/* DPCM decompression */
+			0,
+		},
+		/* Output to both */
+		{
+			/* No DPCM decompression */
+			CSI2_PIX_FMT_YUV422_8BIT_VP16,
+			/* DPCM decompression */
+			0,
+		},
+	},
+};
+
+/*
+ * csi2_ctx_map_format - Map CSI2 sink media bus format to CSI2 format ID
+ * @csi2: ISS CSI2 device
+ *
+ * Returns CSI2 physical format id
+ */
+static u16 csi2_ctx_map_format(struct iss_csi2_device *csi2)
+{
+	const struct v4l2_mbus_framefmt *fmt = &csi2->formats[CSI2_PAD_SINK];
+	int fmtidx, destidx;
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
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case V4L2_MBUS_FMT_SGBRG8_1X8:
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
+	case V4L2_MBUS_FMT_SRGGB8_1X8:
+		fmtidx = 2;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		fmtidx = 3;
+		break;
+	default:
+		WARN(1, KERN_ERR "CSI2: pixel format %08x unsupported!\n",
+		     fmt->code);
+		return 0;
+	}
+
+	if (!(csi2->output & CSI2_OUTPUT_IPIPEIF) &&
+	    !(csi2->output & CSI2_OUTPUT_MEMORY)) {
+		/* Neither output enabled is a valid combination */
+		return CSI2_PIX_FMT_OTHERS;
+	}
+
+	/* If we need to skip frames at the beginning of the stream disable the
+	 * video port to avoid sending the skipped frames to the IPIPEIF.
+	 */
+	destidx = csi2->frame_skip ? 0 : !!(csi2->output & CSI2_OUTPUT_IPIPEIF);
+
+	return __csi2_fmt_map[fmtidx][destidx][csi2->dpcm_decompress];
+}
+
+/*
+ * csi2_set_outaddr - Set memory address to save output image
+ * @csi2: Pointer to ISS CSI2a device.
+ * @addr: 32-bit memory address aligned on 32 byte boundary.
+ *
+ * Sets the memory address where the output will be saved.
+ *
+ * Returns 0 if successful, or -EINVAL if the address is not in the 32 byte
+ * boundary.
+ */
+static void csi2_set_outaddr(struct iss_csi2_device *csi2, u32 addr)
+{
+	struct iss_csi2_ctx_cfg *ctx = &csi2->contexts[0];
+
+	ctx->ping_addr = addr;
+	ctx->pong_addr = addr;
+	writel(ctx->ping_addr,
+	       csi2->regs1 + CSI2_CTX_PING_ADDR(ctx->ctxnum));
+	writel(ctx->pong_addr,
+	       csi2->regs1 + CSI2_CTX_PONG_ADDR(ctx->ctxnum));
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
+	return ((format_id & 0xF0) == 0x40) ? 1 : 0;
+}
+
+/*
+ * csi2_ctx_enable - Enable specified CSI2 context
+ * @ctxnum: Context number, valid between 0 and 7 values.
+ * @enable: enable
+ *
+ */
+static void csi2_ctx_enable(struct iss_csi2_device *csi2, u8 ctxnum, u8 enable)
+{
+	struct iss_csi2_ctx_cfg *ctx = &csi2->contexts[ctxnum];
+	u32 reg;
+
+	reg = readl(csi2->regs1 + CSI2_CTX_CTRL1(ctxnum));
+
+	if (enable) {
+		unsigned int skip = 0;
+
+		if (csi2->frame_skip)
+			skip = csi2->frame_skip;
+		else if (csi2->output & CSI2_OUTPUT_MEMORY)
+			skip = 1;
+
+		reg &= ~CSI2_CTX_CTRL1_COUNT_MASK;
+		reg |= CSI2_CTX_CTRL1_COUNT_UNLOCK
+		    |  (skip << CSI2_CTX_CTRL1_COUNT_SHIFT)
+		    |  CSI2_CTX_CTRL1_CTX_EN;
+	} else {
+		reg &= ~CSI2_CTX_CTRL1_CTX_EN;
+	}
+
+	writel(reg, csi2->regs1 + CSI2_CTX_CTRL1(ctxnum));
+	ctx->enabled = enable;
+}
+
+/*
+ * csi2_ctx_config - CSI2 context configuration.
+ * @ctx: context configuration
+ *
+ */
+static void csi2_ctx_config(struct iss_csi2_device *csi2,
+			    struct iss_csi2_ctx_cfg *ctx)
+{
+	u32 reg;
+
+	/* Set up CSI2_CTx_CTRL1 */
+	if (ctx->eof_enabled)
+		reg = CSI2_CTX_CTRL1_EOF_EN;
+
+	if (ctx->eol_enabled)
+		reg |= CSI2_CTX_CTRL1_EOL_EN;
+
+	if (ctx->checksum_enabled)
+		reg |= CSI2_CTX_CTRL1_CS_EN;
+
+	writel(reg, csi2->regs1 + CSI2_CTX_CTRL1(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_CTRL2 */
+	reg = ctx->virtual_id << CSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT;
+	reg |= ctx->format_id << CSI2_CTX_CTRL2_FORMAT_SHIFT;
+
+	if (ctx->dpcm_decompress && ctx->dpcm_predictor)
+		reg |= CSI2_CTX_CTRL2_DPCM_PRED;
+
+	if (is_usr_def_mapping(ctx->format_id))
+		reg |= 2 << CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT;
+
+	writel(reg, csi2->regs1 + CSI2_CTX_CTRL2(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_CTRL3 */
+	writel(ctx->alpha << CSI2_CTX_CTRL3_ALPHA_SHIFT,
+		csi2->regs1 + CSI2_CTX_CTRL3(ctx->ctxnum));
+
+	/* Set up CSI2_CTx_DAT_OFST */
+	reg = readl(csi2->regs1 + CSI2_CTX_DAT_OFST(ctx->ctxnum));
+	reg &= ~CSI2_CTX_DAT_OFST_MASK;
+	reg |= ctx->data_offset;
+	writel(reg, csi2->regs1 + CSI2_CTX_DAT_OFST(ctx->ctxnum));
+
+	writel(ctx->ping_addr,
+		       csi2->regs1 + CSI2_CTX_PING_ADDR(ctx->ctxnum));
+
+	writel(ctx->pong_addr,
+		       csi2->regs1 + CSI2_CTX_PONG_ADDR(ctx->ctxnum));
+}
+
+/*
+ * csi2_timing_config - CSI2 timing configuration.
+ * @timing: csi2_timing_cfg structure
+ */
+static void csi2_timing_config(struct iss_csi2_device *csi2,
+			       struct iss_csi2_timing_cfg *timing)
+{
+	u32 reg;
+
+	reg = readl(csi2->regs1 + CSI2_TIMING);
+
+	if (timing->force_rx_mode)
+		reg |= CSI2_TIMING_FORCE_RX_MODE_IO1;
+	else
+		reg &= ~CSI2_TIMING_FORCE_RX_MODE_IO1;
+
+	if (timing->stop_state_16x)
+		reg |= CSI2_TIMING_STOP_STATE_X16_IO1;
+	else
+		reg &= ~CSI2_TIMING_STOP_STATE_X16_IO1;
+
+	if (timing->stop_state_4x)
+		reg |= CSI2_TIMING_STOP_STATE_X4_IO1;
+	else
+		reg &= ~CSI2_TIMING_STOP_STATE_X4_IO1;
+
+	reg &= ~CSI2_TIMING_STOP_STATE_COUNTER_IO1_MASK;
+	reg |= timing->stop_state_counter <<
+	       CSI2_TIMING_STOP_STATE_COUNTER_IO1_SHIFT;
+
+	writel(reg, csi2->regs1 + CSI2_TIMING);
+}
+
+/*
+ * csi2_irq_ctx_set - Enables CSI2 Context IRQs.
+ * @enable: Enable/disable CSI2 Context interrupts
+ */
+static void csi2_irq_ctx_set(struct iss_csi2_device *csi2, int enable)
+{
+	u32 reg = CSI2_CTX_IRQ_FE;
+	int i;
+
+	if (csi2->use_fs_irq)
+		reg |= CSI2_CTX_IRQ_FS;
+
+	for (i = 0; i < 8; i++) {
+		writel(reg, csi2->regs1 + CSI2_CTX_IRQSTATUS(i));
+		if (enable)
+			writel(readl(csi2->regs1 + CSI2_CTX_IRQENABLE(i)) | reg,
+				csi2->regs1 + CSI2_CTX_IRQENABLE(i));
+		else
+			writel(readl(csi2->regs1 + CSI2_CTX_IRQENABLE(i)) &
+				~reg,
+				csi2->regs1 + CSI2_CTX_IRQENABLE(i));
+	}
+}
+
+/*
+ * csi2_irq_complexio1_set - Enables CSI2 ComplexIO IRQs.
+ * @enable: Enable/disable CSI2 ComplexIO #1 interrupts
+ */
+static void csi2_irq_complexio1_set(struct iss_csi2_device *csi2, int enable)
+{
+	u32 reg;
+	reg = CSI2_COMPLEXIO_IRQ_STATEALLULPMEXIT |
+		CSI2_COMPLEXIO_IRQ_STATEALLULPMENTER |
+		CSI2_COMPLEXIO_IRQ_STATEULPM5 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL5 |
+		CSI2_COMPLEXIO_IRQ_ERRESC5 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS5 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS5 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM4 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL4 |
+		CSI2_COMPLEXIO_IRQ_ERRESC4 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS4 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS4 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM3 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL3 |
+		CSI2_COMPLEXIO_IRQ_ERRESC3 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS3 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS3 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM2 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL2 |
+		CSI2_COMPLEXIO_IRQ_ERRESC2 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS2 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS2 |
+		CSI2_COMPLEXIO_IRQ_STATEULPM1 |
+		CSI2_COMPLEXIO_IRQ_ERRCONTROL1 |
+		CSI2_COMPLEXIO_IRQ_ERRESC1 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTSYNCHS1 |
+		CSI2_COMPLEXIO_IRQ_ERRSOTHS1;
+	writel(reg, csi2->regs1 + CSI2_COMPLEXIO_IRQSTATUS);
+	if (enable)
+		reg |= readl(csi2->regs1 + CSI2_COMPLEXIO_IRQENABLE);
+	else
+		reg = 0;
+	writel(reg, csi2->regs1 + CSI2_COMPLEXIO_IRQENABLE);
+}
+
+/*
+ * csi2_irq_status_set - Enables CSI2 Status IRQs.
+ * @enable: Enable/disable CSI2 Status interrupts
+ */
+static void csi2_irq_status_set(struct iss_csi2_device *csi2, int enable)
+{
+	u32 reg;
+	reg = CSI2_IRQ_OCP_ERR |
+		CSI2_IRQ_SHORT_PACKET |
+		CSI2_IRQ_ECC_CORRECTION |
+		CSI2_IRQ_ECC_NO_CORRECTION |
+		CSI2_IRQ_COMPLEXIO_ERR |
+		CSI2_IRQ_FIFO_OVF |
+		CSI2_IRQ_CONTEXT0;
+	writel(reg, csi2->regs1 + CSI2_IRQSTATUS);
+	if (enable)
+		reg |= readl(csi2->regs1 + CSI2_IRQENABLE);
+	else
+		reg = 0;
+
+	writel(reg, csi2->regs1 + CSI2_IRQENABLE);
+}
+
+/*
+ * omap4iss_csi2_reset - Resets the CSI2 module.
+ *
+ * Must be called with the phy lock held.
+ *
+ * Returns 0 if successful, or -EBUSY if power command didn't respond.
+ */
+int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
+{
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
+	writel(readl(csi2->regs1 + CSI2_SYSCONFIG) |
+		CSI2_SYSCONFIG_SOFT_RESET,
+		csi2->regs1 + CSI2_SYSCONFIG);
+
+	do {
+		reg = readl(csi2->regs1 + CSI2_SYSSTATUS) &
+				    CSI2_SYSSTATUS_RESET_DONE;
+		if (reg == CSI2_SYSSTATUS_RESET_DONE)
+			break;
+		soft_reset_retries++;
+		if (soft_reset_retries < 5)
+			usleep_range(100, 100);
+	} while (soft_reset_retries < 5);
+
+	if (soft_reset_retries == 5) {
+		printk(KERN_ERR "CSI2: Soft reset try count exceeded!\n");
+		return -EBUSY;
+	}
+
+	writel(readl(csi2->regs1 + CSI2_COMPLEXIO_CFG) |
+		CSI2_COMPLEXIO_CFG_RESET_CTRL,
+		csi2->regs1 + CSI2_COMPLEXIO_CFG);
+
+	i = 100;
+	do {
+		reg = readl(csi2->phy->phy_regs + REGISTER1)
+		    & REGISTER1_RESET_DONE_CTRLCLK;
+		if (reg == REGISTER1_RESET_DONE_CTRLCLK)
+			break;
+		usleep_range(100, 100);
+	} while (--i > 0);
+
+	if (i == 0) {
+		printk(KERN_ERR
+		       "CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
+		return -EBUSY;
+	}
+
+	writel((readl(csi2->regs1 + CSI2_SYSCONFIG) &
+		~(CSI2_SYSCONFIG_MSTANDBY_MODE_MASK |
+		  CSI2_SYSCONFIG_AUTO_IDLE)) |
+		CSI2_SYSCONFIG_MSTANDBY_MODE_NO,
+		csi2->regs1 + CSI2_SYSCONFIG);
+
+	return 0;
+}
+
+static int csi2_configure(struct iss_csi2_device *csi2)
+{
+	const struct iss_v4l2_subdevs_group *pdata;
+	struct iss_csi2_timing_cfg *timing = &csi2->timing[0];
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
+	pad = media_entity_remote_pad(&csi2->pads[CSI2_PAD_SINK]);
+	sensor = media_entity_to_v4l2_subdev(pad->entity);
+	pdata = sensor->host_priv;
+
+	csi2->frame_skip = 0;
+	v4l2_subdev_call(sensor, sensor, g_skip_frames, &csi2->frame_skip);
+
+	csi2->ctrl.vp_out_ctrl = pdata->bus.csi2.vpclk_div;
+	csi2->ctrl.frame_mode = ISS_CSI2_FRAME_IMMEDIATE;
+	csi2->ctrl.ecc_enable = pdata->bus.csi2.crc;
+
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
+	csi2_irq_complexio1_set(csi2, 1);
+	csi2_irq_ctx_set(csi2, 1);
+	csi2_irq_status_set(csi2, 1);
+
+	/* Set configuration (timings, format and links) */
+	csi2_timing_config(csi2, timing);
+	csi2_recv_config(csi2, &csi2->ctrl);
+	csi2_ctx_config(csi2, &csi2->contexts[0]);
+
+	return 0;
+}
+
+/*
+ * csi2_print_status - Prints CSI2 debug information.
+ */
+#define CSI2_PRINT_REGISTER(iss, regs, name)\
+	dev_dbg(iss->dev, "###CSI2 " #name "=0x%08x\n", \
+		readl(regs + CSI2_##name))
+
+static void csi2_print_status(struct iss_csi2_device *csi2)
+{
+	struct iss_device *iss = csi2->iss;
+
+	if (!csi2->available)
+		return;
+
+	dev_dbg(iss->dev, "-------------CSI2 Register dump-------------\n");
+
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, SYSCONFIG);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, SYSSTATUS);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, IRQENABLE);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, IRQSTATUS);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTRL);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, DBG_H);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_CFG);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_IRQSTATUS);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, SHORT_PACKET);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_IRQENABLE);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, DBG_P);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, TIMING);
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL1(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL2(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_DAT_OFST(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_PING_ADDR(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_PONG_ADDR(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_IRQENABLE(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_IRQSTATUS(0));
+	CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL3(0));
+
+	dev_dbg(iss->dev, "--------------------------------------------\n");
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
+static void csi2_isr_buffer(struct iss_csi2_device *csi2)
+{
+	struct iss_buffer *buffer;
+
+	csi2_ctx_enable(csi2, 0, 0);
+
+	buffer = omap4iss_video_buffer_next(&csi2->video_out);
+
+	/*
+	 * Let video queue operation restart engine if there is an underrun
+	 * condition.
+	 */
+	if (buffer == NULL)
+		return;
+
+	csi2_set_outaddr(csi2, buffer->iss_addr);
+	csi2_ctx_enable(csi2, 0, 1);
+}
+
+static void csi2_isr_ctx(struct iss_csi2_device *csi2,
+			 struct iss_csi2_ctx_cfg *ctx)
+{
+	unsigned int n = ctx->ctxnum;
+	u32 status;
+
+	status = readl(csi2->regs1 + CSI2_CTX_IRQSTATUS(n));
+	writel(status, csi2->regs1 + CSI2_CTX_IRQSTATUS(n));
+
+	/* Propagate frame number */
+	if (status & CSI2_CTX_IRQ_FS) {
+		struct iss_pipeline *pipe =
+				     to_iss_pipeline(&csi2->subdev.entity);
+		if (pipe->do_propagation)
+			atomic_inc(&pipe->frame_number);
+	}
+
+	if (!(status & CSI2_CTX_IRQ_FE))
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
+			csi2_ctx_config(csi2, ctx);
+			csi2_ctx_enable(csi2, n, 1);
+		}
+		return;
+	}
+
+	if (csi2->output & CSI2_OUTPUT_MEMORY)
+		csi2_isr_buffer(csi2);
+}
+
+/*
+ * omap4iss_csi2_isr - CSI2 interrupt handling.
+ */
+void omap4iss_csi2_isr(struct iss_csi2_device *csi2)
+{
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
+	u32 csi2_irqstatus, cpxio1_irqstatus;
+	struct iss_device *iss = csi2->iss;
+
+	if (!csi2->available)
+		return;
+
+	csi2_irqstatus = readl(csi2->regs1 + CSI2_IRQSTATUS);
+	writel(csi2_irqstatus, csi2->regs1 + CSI2_IRQSTATUS);
+
+	/* Failure Cases */
+	if (csi2_irqstatus & CSI2_IRQ_COMPLEXIO_ERR) {
+		cpxio1_irqstatus = readl(csi2->regs1 +
+					 CSI2_COMPLEXIO_IRQSTATUS);
+		writel(cpxio1_irqstatus,
+			csi2->regs1 + CSI2_COMPLEXIO_IRQSTATUS);
+		dev_dbg(iss->dev, "CSI2: ComplexIO Error IRQ "
+			"%x\n", cpxio1_irqstatus);
+		pipe->error = true;
+	}
+
+	if (csi2_irqstatus & (CSI2_IRQ_OCP_ERR |
+			      CSI2_IRQ_SHORT_PACKET |
+			      CSI2_IRQ_ECC_NO_CORRECTION |
+			      CSI2_IRQ_COMPLEXIO_ERR |
+			      CSI2_IRQ_FIFO_OVF)) {
+		dev_dbg(iss->dev, "CSI2 Err:"
+			" OCP:%d,"
+			" Short_pack:%d,"
+			" ECC:%d,"
+			" CPXIO:%d,"
+			" FIFO_OVF:%d,"
+			"\n",
+			(csi2_irqstatus &
+			 CSI2_IRQ_OCP_ERR) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_SHORT_PACKET) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_ECC_NO_CORRECTION) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_COMPLEXIO_ERR) ? 1 : 0,
+			(csi2_irqstatus &
+			 CSI2_IRQ_FIFO_OVF) ? 1 : 0);
+		pipe->error = true;
+	}
+
+	if (omap4iss_module_sync_is_stopping(&csi2->wait, &csi2->stopping))
+		return;
+
+	/* Successful cases */
+	if (csi2_irqstatus & CSI2_IRQ_CONTEXT0)
+		csi2_isr_ctx(csi2, &csi2->contexts[0]);
+
+	if (csi2_irqstatus & CSI2_IRQ_ECC_CORRECTION)
+		dev_dbg(iss->dev, "CSI2: ECC correction done\n");
+}
+
+/* -----------------------------------------------------------------------------
+ * ISS video operations
+ */
+
+/*
+ * csi2_queue - Queues the first buffer when using memory output
+ * @video: The video node
+ * @buffer: buffer to queue
+ */
+static int csi2_queue(struct iss_video *video, struct iss_buffer *buffer)
+{
+	struct iss_csi2_device *csi2 = container_of(video,
+				struct iss_csi2_device, video_out);
+
+	csi2_set_outaddr(csi2, buffer->iss_addr);
+
+	/*
+	 * If streaming was enabled before there was a buffer queued
+	 * or underrun happened in the ISR, the hardware was not enabled
+	 * and DMA queue flag ISS_VIDEO_DMAQUEUE_UNDERRUN is still set.
+	 * Enable it now.
+	 */
+	if (csi2->video_out.dmaqueue_flags & ISS_VIDEO_DMAQUEUE_UNDERRUN) {
+		/* Enable / disable context 0 and IRQs */
+		csi2_if_enable(csi2, 1);
+		csi2_ctx_enable(csi2, 0, 1);
+		iss_video_dmaqueue_flags_clr(&csi2->video_out);
+	}
+
+	return 0;
+}
+
+static const struct iss_video_operations csi2_issvideo_ops = {
+	.queue = csi2_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+static struct v4l2_mbus_framefmt *
+__csi2_get_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &csi2->formats[pad];
+}
+
+static void
+csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		enum v4l2_subdev_format_whence which)
+{
+	enum v4l2_mbus_pixelcode pixelcode;
+	struct v4l2_mbus_framefmt *format;
+	const struct iss_format_info *info;
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
+		info = omap4iss_video_format_info(fmt->code);
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
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+	const struct iss_format_info *info;
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
+			info = omap4iss_video_format_info(format->code);
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
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
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
+ * return -EINVAL or zero on success
+ */
+static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
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
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
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
+static int csi2_link_validate(struct v4l2_subdev *sd, struct media_link *link,
+			      struct v4l2_subdev_format *source_fmt,
+			      struct v4l2_subdev_format *sink_fmt)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
+	int rval;
+
+	pipe->external = media_entity_to_v4l2_subdev(link->source->entity);
+	rval = omap4iss_get_external_info(pipe, link);
+	if (rval < 0)
+		return rval;
+
+	return v4l2_subdev_link_validate_default(sd, link, source_fmt,
+						 sink_fmt);
+}
+
+/*
+ * csi2_init_formats - Initialize formats on all pads
+ * @sd: ISS CSI2 V4L2 subdevice
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
+ * @sd: ISS CSI2 V4L2 subdevice
+ * @enable: ISS pipeline stream state
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct iss_device *iss = csi2->iss;
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
+	struct iss_video *video_out = &csi2->video_out;
+
+	if (csi2->state == ISS_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+
+		if (csi2 == &iss->csi2a)
+			omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_CSI2_A);
+		else if (csi2 == &iss->csi2b)
+			omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_CSI2_B);
+	}
+
+	switch (enable) {
+	case ISS_PIPELINE_STREAM_CONTINUOUS: {
+		int ret;
+
+		ret = omap4iss_csiphy_config(iss, sd);
+		if (ret < 0)
+			return ret;
+
+		if (omap4iss_csiphy_acquire(csi2->phy) < 0)
+			return -ENODEV;
+		csi2->use_fs_irq = pipe->do_propagation;
+		csi2_configure(csi2);
+		csi2_print_status(csi2);
+
+		/*
+		 * When outputting to memory with no buffer available, let the
+		 * buffer queue handler start the hardware. A DMA queue flag
+		 * ISS_VIDEO_DMAQUEUE_QUEUED will be set as soon as there is
+		 * a buffer available.
+		 */
+		if (csi2->output & CSI2_OUTPUT_MEMORY &&
+		    !(video_out->dmaqueue_flags & ISS_VIDEO_DMAQUEUE_QUEUED))
+			break;
+		/* Enable context 0 and IRQs */
+		atomic_set(&csi2->stopping, 0);
+		csi2_ctx_enable(csi2, 0, 1);
+		csi2_if_enable(csi2, 1);
+		iss_video_dmaqueue_flags_clr(video_out);
+		break;
+	}
+	case ISS_PIPELINE_STREAM_STOPPED:
+		if (csi2->state == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+		if (omap4iss_module_sync_idle(&sd->entity, &csi2->wait,
+					      &csi2->stopping))
+			dev_dbg(iss->dev, "%s: module stop timeout.\n",
+				sd->name);
+		csi2_ctx_enable(csi2, 0, 0);
+		csi2_if_enable(csi2, 0);
+		csi2_irq_ctx_set(csi2, 0);
+		omap4iss_csiphy_release(csi2->phy);
+		if (csi2 == &iss->csi2a)
+			omap4iss_subclk_disable(iss, OMAP4_ISS_SUBCLK_CSI2_A);
+		else if (csi2 == &iss->csi2b)
+			omap4iss_subclk_disable(iss, OMAP4_ISS_SUBCLK_CSI2_B);
+		iss_video_dmaqueue_flags_clr(video_out);
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
+	.link_validate = csi2_link_validate,
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
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
+	struct iss_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
+
+	/*
+	 * The ISS core doesn't support pipelines with multiple video outputs.
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
+			if (csi2->output & ~CSI2_OUTPUT_IPIPEIF)
+				return -EBUSY;
+			csi2->output |= CSI2_OUTPUT_IPIPEIF;
+		} else {
+			csi2->output &= ~CSI2_OUTPUT_IPIPEIF;
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
+	ctrl->vp_clk_enable = !!(csi2->output & CSI2_OUTPUT_IPIPEIF);
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations csi2_media_ops = {
+	.link_setup = csi2_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+void omap4iss_csi2_unregister_entities(struct iss_csi2_device *csi2)
+{
+	v4l2_device_unregister_subdev(&csi2->subdev);
+	omap4iss_video_unregister(&csi2->video_out);
+}
+
+int omap4iss_csi2_register_entities(struct iss_csi2_device *csi2,
+				    struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video nodes. */
+	ret = v4l2_device_register_subdev(vdev, &csi2->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap4iss_video_register(&csi2->video_out, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap4iss_csi2_unregister_entities(csi2);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISS CSI2 initialisation and cleanup
+ */
+
+/*
+ * csi2_init_entities - Initialize subdev and media entity.
+ * @csi2: Pointer to csi2 structure.
+ * return -ENOMEM or zero on success
+ */
+static int csi2_init_entities(struct iss_csi2_device *csi2, const char *subname)
+{
+	struct v4l2_subdev *sd = &csi2->subdev;
+	struct media_pad *pads = csi2->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+	char name[V4L2_SUBDEV_NAME_SIZE];
+
+	v4l2_subdev_init(sd, &csi2_ops);
+	sd->internal_ops = &csi2_internal_ops;
+	sprintf(name, "CSI2%s", subname);
+	strlcpy(sd->name, "", sizeof(sd->name));
+	sprintf(sd->name, "OMAP4 ISS %s", name);
+
+	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
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
+	csi2->video_out.ops = &csi2_issvideo_ops;
+	csi2->video_out.bpl_alignment = 32;
+	csi2->video_out.bpl_zero_padding = 1;
+	csi2->video_out.bpl_max = 0x1ffe0;
+	csi2->video_out.iss = csi2->iss;
+	csi2->video_out.capture_mem = PAGE_ALIGN(4096 * 4096) * 3;
+
+	ret = omap4iss_video_init(&csi2->video_out, name);
+	if (ret < 0)
+		goto error_video;
+
+	/* Connect the CSI2 subdev to the video node. */
+	ret = media_entity_create_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
+				       &csi2->video_out.video.entity, 0, 0);
+	if (ret < 0)
+		goto error_link;
+
+	return 0;
+
+error_link:
+	omap4iss_video_cleanup(&csi2->video_out);
+error_video:
+	media_entity_cleanup(&csi2->subdev.entity);
+	return ret;
+}
+
+/*
+ * omap4iss_csi2_init - Routine for module driver init
+ */
+int omap4iss_csi2_init(struct iss_device *iss)
+{
+	struct iss_csi2_device *csi2a = &iss->csi2a;
+	struct iss_csi2_device *csi2b = &iss->csi2b;
+	int ret;
+
+	csi2a->iss = iss;
+	csi2a->available = 1;
+	csi2a->regs1 = iss->regs[OMAP4_ISS_MEM_CSI2_A_REGS1];
+	csi2a->phy = &iss->csiphy1;
+	csi2a->state = ISS_PIPELINE_STREAM_STOPPED;
+	init_waitqueue_head(&csi2a->wait);
+
+	ret = csi2_init_entities(csi2a, "a");
+	if (ret < 0)
+		return ret;
+
+	csi2b->iss = iss;
+	csi2b->available = 1;
+	csi2b->regs1 = iss->regs[OMAP4_ISS_MEM_CSI2_B_REGS1];
+	csi2b->phy = &iss->csiphy2;
+	csi2b->state = ISS_PIPELINE_STREAM_STOPPED;
+	init_waitqueue_head(&csi2b->wait);
+
+	ret = csi2_init_entities(csi2b, "b");
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * omap4iss_csi2_cleanup - Routine for module driver cleanup
+ */
+void omap4iss_csi2_cleanup(struct iss_device *iss)
+{
+	struct iss_csi2_device *csi2a = &iss->csi2a;
+	struct iss_csi2_device *csi2b = &iss->csi2b;
+
+	omap4iss_video_cleanup(&csi2a->video_out);
+	media_entity_cleanup(&csi2a->subdev.entity);
+
+	omap4iss_video_cleanup(&csi2b->video_out);
+	media_entity_cleanup(&csi2b->subdev.entity);
+}
diff --git a/drivers/staging/media/omap4iss/iss_csi2.h b/drivers/staging/media/omap4iss/iss_csi2.h
new file mode 100644
index 0000000..d1d077b
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_csi2.h
@@ -0,0 +1,156 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI2 module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef OMAP4_ISS_CSI2_H
+#define OMAP4_ISS_CSI2_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include "iss_video.h"
+
+struct iss_csiphy;
+
+/* This is not an exhaustive list */
+enum iss_csi2_pix_formats {
+	CSI2_PIX_FMT_OTHERS = 0,
+	CSI2_PIX_FMT_YUV422_8BIT = 0x1e,
+	CSI2_PIX_FMT_YUV422_8BIT_VP = 0x9e,
+	CSI2_PIX_FMT_YUV422_8BIT_VP16 = 0xde,
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
+enum iss_csi2_irqevents {
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
+enum iss_csi2_ctx_irqevents {
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
+enum iss_csi2_frame_mode {
+	ISS_CSI2_FRAME_IMMEDIATE,
+	ISS_CSI2_FRAME_AFTERFEC,
+};
+
+#define ISS_CSI2_MAX_CTX_NUM	7
+
+struct iss_csi2_ctx_cfg {
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
+struct iss_csi2_timing_cfg {
+	u8 ionum;			/* IO1 or IO2 as in CSI2_TIMING */
+	unsigned force_rx_mode:1;
+	unsigned stop_state_16x:1;
+	unsigned stop_state_4x:1;
+	u16 stop_state_counter;
+};
+
+struct iss_csi2_ctrl_cfg {
+	bool vp_clk_enable;
+	bool vp_only_enable;
+	u8 vp_out_ctrl;
+	enum iss_csi2_frame_mode frame_mode;
+	bool ecc_enable;
+	bool if_enable;
+};
+
+#define CSI2_PAD_SINK		0
+#define CSI2_PAD_SOURCE		1
+#define CSI2_PADS_NUM		2
+
+#define CSI2_OUTPUT_IPIPEIF	(1 << 0)
+#define CSI2_OUTPUT_MEMORY	(1 << 1)
+
+struct iss_csi2_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[CSI2_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[CSI2_PADS_NUM];
+
+	struct iss_video video_out;
+	struct iss_device *iss;
+
+	u8 available;		/* Is the IP present on the silicon? */
+
+	/* Pointer to register remaps into kernel space */
+	void __iomem *regs1;
+	void __iomem *regs2;
+
+	u32 output; /* output to IPIPEIF, memory or both? */
+	bool dpcm_decompress;
+	unsigned int frame_skip;
+	bool use_fs_irq;
+
+	struct iss_csiphy *phy;
+	struct iss_csi2_ctx_cfg contexts[ISS_CSI2_MAX_CTX_NUM + 1];
+	struct iss_csi2_timing_cfg timing[2];
+	struct iss_csi2_ctrl_cfg ctrl;
+	enum iss_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+};
+
+void omap4iss_csi2_isr(struct iss_csi2_device *csi2);
+int omap4iss_csi2_reset(struct iss_csi2_device *csi2);
+int omap4iss_csi2_init(struct iss_device *iss);
+void omap4iss_csi2_cleanup(struct iss_device *iss);
+void omap4iss_csi2_unregister_entities(struct iss_csi2_device *csi2);
+int omap4iss_csi2_register_entities(struct iss_csi2_device *csi2,
+				    struct v4l2_device *vdev);
+#endif	/* OMAP4_ISS_CSI2_H */
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
new file mode 100644
index 0000000..2afea98
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -0,0 +1,278 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI PHY module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+
+#include "../../../../arch/arm/mach-omap2/control.h"
+
+#include "iss.h"
+#include "iss_regs.h"
+#include "iss_csiphy.h"
+
+/*
+ * csiphy_lanes_config - Configuration of CSIPHY lanes.
+ *
+ * Updates HW configuration.
+ * Called with phy->mutex taken.
+ */
+static void csiphy_lanes_config(struct iss_csiphy *phy)
+{
+	unsigned int i;
+	u32 reg;
+
+	reg = readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+
+	for (i = 0; i < phy->max_data_lanes; i++) {
+		reg &= ~(CSI2_COMPLEXIO_CFG_DATA_POL(i + 1) |
+			 CSI2_COMPLEXIO_CFG_DATA_POSITION_MASK(i + 1));
+		reg |= (phy->lanes.data[i].pol ?
+			CSI2_COMPLEXIO_CFG_DATA_POL(i + 1) : 0);
+		reg |= (phy->lanes.data[i].pos <<
+			CSI2_COMPLEXIO_CFG_DATA_POSITION_SHIFT(i + 1));
+	}
+
+	reg &= ~(CSI2_COMPLEXIO_CFG_CLOCK_POL |
+		 CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK);
+	reg |= phy->lanes.clk.pol ? CSI2_COMPLEXIO_CFG_CLOCK_POL : 0;
+	reg |= phy->lanes.clk.pos << CSI2_COMPLEXIO_CFG_CLOCK_POSITION_SHIFT;
+
+	writel(reg, phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+}
+
+/*
+ * csiphy_set_power
+ * @power: Power state to be set.
+ *
+ * Returns 0 if successful, or -EBUSY if the retry count is exceeded.
+ */
+static int csiphy_set_power(struct iss_csiphy *phy, u32 power)
+{
+	u32 reg;
+	u8 retry_count;
+
+	writel((readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG) &
+		~CSI2_COMPLEXIO_CFG_PWD_CMD_MASK) |
+		power,
+		phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+
+	retry_count = 0;
+	do {
+		udelay(1);
+		reg = readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG) &
+				CSI2_COMPLEXIO_CFG_PWD_STATUS_MASK;
+
+		if (reg != power >> 2)
+			retry_count++;
+
+	} while ((reg != power >> 2) && (retry_count < 250));
+
+	if (retry_count == 250) {
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
+static void csiphy_dphy_config(struct iss_csiphy *phy)
+{
+	u32 reg;
+
+	/* Set up REGISTER0 */
+	reg = phy->dphy.ths_term << REGISTER0_THS_TERM_SHIFT;
+	reg |= phy->dphy.ths_settle << REGISTER0_THS_SETTLE_SHIFT;
+
+	writel(reg, phy->phy_regs + REGISTER0);
+
+	/* Set up REGISTER1 */
+	reg = phy->dphy.tclk_term << REGISTER1_TCLK_TERM_SHIFT;
+	reg |= phy->dphy.tclk_miss << REGISTER1_CTRLCLK_DIV_FACTOR_SHIFT;
+	reg |= phy->dphy.tclk_settle << REGISTER1_TCLK_SETTLE_SHIFT;
+	reg |= 0xB8 << REGISTER1_DPHY_HS_SYNC_PATTERN_SHIFT;
+
+	writel(reg, phy->phy_regs + REGISTER1);
+}
+
+/*
+ * TCLK values are OK at their reset values
+ */
+#define TCLK_TERM	0
+#define TCLK_MISS	1
+#define TCLK_SETTLE	14
+
+int omap4iss_csiphy_config(struct iss_device *iss,
+			   struct v4l2_subdev *csi2_subdev)
+{
+	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
+	struct iss_pipeline *pipe = to_iss_pipeline(&csi2_subdev->entity);
+	struct iss_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
+	struct iss_csiphy_dphy_cfg csi2phy;
+	int csi2_ddrclk_khz;
+	struct iss_csiphy_lanes_cfg *lanes;
+	unsigned int used_lanes = 0;
+	u32 cam_rx_ctrl;
+	unsigned int i;
+
+	lanes = &subdevs->bus.csi2.lanecfg;
+
+	/*
+	 * SCM.CONTROL_CAMERA_RX
+	 * - bit [31] : CSIPHY2 lane 2 enable (4460+ only)
+	 * - bit [30:29] : CSIPHY2 per-lane enable (1 to 0)
+	 * - bit [28:24] : CSIPHY1 per-lane enable (4 to 0)
+	 * - bit [21] : CSIPHY2 CTRLCLK enable
+	 * - bit [20:19] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
+	 * - bit [18] : CSIPHY1 CTRLCLK enable
+	 * - bit [17:16] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
+	 */
+	cam_rx_ctrl = omap4_ctrl_pad_readl(
+			OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
+
+
+	if (subdevs->interface == ISS_INTERFACE_CSI2A_PHY1) {
+		cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI21_LANEENABLE_MASK |
+				OMAP4_CAMERARX_CSI21_CAMMODE_MASK);
+		/* NOTE: Leave CSIPHY1 config to 0x0: D-PHY mode */
+		/* Enable all lanes for now */
+		cam_rx_ctrl |=
+			0x1F << OMAP4_CAMERARX_CSI21_LANEENABLE_SHIFT;
+		/* Enable CTRLCLK */
+		cam_rx_ctrl |= OMAP4_CAMERARX_CSI21_CTRLCLKEN_MASK;
+	}
+
+	if (subdevs->interface == ISS_INTERFACE_CSI2B_PHY2) {
+		cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI22_LANEENABLE_MASK |
+				OMAP4_CAMERARX_CSI22_CAMMODE_MASK);
+		/* NOTE: Leave CSIPHY2 config to 0x0: D-PHY mode */
+		/* Enable all lanes for now */
+		cam_rx_ctrl |=
+			0x3 << OMAP4_CAMERARX_CSI22_LANEENABLE_SHIFT;
+		/* Enable CTRLCLK */
+		cam_rx_ctrl |= OMAP4_CAMERARX_CSI22_CTRLCLKEN_MASK;
+	}
+
+	omap4_ctrl_pad_writel(cam_rx_ctrl,
+		 OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
+
+	/* Reset used lane count */
+	csi2->phy->used_data_lanes = 0;
+
+	/* Clock and data lanes verification */
+	for (i = 0; i < csi2->phy->max_data_lanes; i++) {
+		if (lanes->data[i].pos == 0)
+			continue;
+
+		if (lanes->data[i].pol > 1 || lanes->data[i].pos > (csi2->phy->max_data_lanes + 1))
+			return -EINVAL;
+
+		if (used_lanes & (1 << lanes->data[i].pos))
+			return -EINVAL;
+
+		used_lanes |= 1 << lanes->data[i].pos;
+		csi2->phy->used_data_lanes++;
+	}
+
+	if (lanes->clk.pol > 1 || lanes->clk.pos > (csi2->phy->max_data_lanes + 1))
+		return -EINVAL;
+
+	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
+		return -EINVAL;
+
+	csi2_ddrclk_khz = pipe->external_rate / 1000
+		/ (2 * csi2->phy->used_data_lanes)
+		* pipe->external_bpp;
+
+	/*
+	 * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
+	 * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
+	 */
+	csi2phy.ths_term = DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1;
+	csi2phy.ths_settle = DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3;
+	csi2phy.tclk_term = TCLK_TERM;
+	csi2phy.tclk_miss = TCLK_MISS;
+	csi2phy.tclk_settle = TCLK_SETTLE;
+
+	mutex_lock(&csi2->phy->mutex);
+	csi2->phy->dphy = csi2phy;
+	csi2->phy->lanes = *lanes;
+	mutex_unlock(&csi2->phy->mutex);
+
+	return 0;
+}
+
+int omap4iss_csiphy_acquire(struct iss_csiphy *phy)
+{
+	int rval;
+
+	mutex_lock(&phy->mutex);
+
+	rval = omap4iss_csi2_reset(phy->csi2);
+	if (rval)
+		goto done;
+
+	csiphy_dphy_config(phy);
+	csiphy_lanes_config(phy);
+
+	rval = csiphy_set_power(phy, CSI2_COMPLEXIO_CFG_PWD_CMD_ON);
+	if (rval)
+		goto done;
+
+	phy->phy_in_use = 1;
+
+done:
+	mutex_unlock(&phy->mutex);
+	return rval;
+}
+
+void omap4iss_csiphy_release(struct iss_csiphy *phy)
+{
+	mutex_lock(&phy->mutex);
+	if (phy->phy_in_use) {
+		csiphy_set_power(phy, CSI2_COMPLEXIO_CFG_PWD_CMD_OFF);
+		phy->phy_in_use = 0;
+	}
+	mutex_unlock(&phy->mutex);
+}
+
+/*
+ * omap4iss_csiphy_init - Initialize the CSI PHY frontends
+ */
+int omap4iss_csiphy_init(struct iss_device *iss)
+{
+	struct iss_csiphy *phy1 = &iss->csiphy1;
+	struct iss_csiphy *phy2 = &iss->csiphy2;
+
+	phy1->iss = iss;
+	phy1->csi2 = &iss->csi2a;
+	phy1->max_data_lanes = ISS_CSIPHY1_NUM_DATA_LANES;
+	phy1->used_data_lanes = 0;
+	phy1->cfg_regs = iss->regs[OMAP4_ISS_MEM_CSI2_A_REGS1];
+	phy1->phy_regs = iss->regs[OMAP4_ISS_MEM_CAMERARX_CORE1];
+	mutex_init(&phy1->mutex);
+
+	phy2->iss = iss;
+	phy2->csi2 = &iss->csi2b;
+	phy2->max_data_lanes = ISS_CSIPHY2_NUM_DATA_LANES;
+	phy2->used_data_lanes = 0;
+	phy2->cfg_regs = iss->regs[OMAP4_ISS_MEM_CSI2_B_REGS1];
+	phy2->phy_regs = iss->regs[OMAP4_ISS_MEM_CAMERARX_CORE2];
+	mutex_init(&phy2->mutex);
+
+	return 0;
+}
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.h b/drivers/staging/media/omap4iss/iss_csiphy.h
new file mode 100644
index 0000000..df63eda
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_csiphy.h
@@ -0,0 +1,51 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - CSI PHY module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef OMAP4_ISS_CSI_PHY_H
+#define OMAP4_ISS_CSI_PHY_H
+
+#include <media/omap4iss.h>
+
+struct iss_csi2_device;
+
+struct iss_csiphy_dphy_cfg {
+	u8 ths_term;
+	u8 ths_settle;
+	u8 tclk_term;
+	unsigned tclk_miss:1;
+	u8 tclk_settle;
+};
+
+struct iss_csiphy {
+	struct iss_device *iss;
+	struct mutex mutex;	/* serialize csiphy configuration */
+	u8 phy_in_use;
+	struct iss_csi2_device *csi2;
+
+	/* Pointer to register remaps into kernel space */
+	void __iomem *cfg_regs;
+	void __iomem *phy_regs;
+
+	u8 max_data_lanes;	/* number of CSI2 Data Lanes supported */
+	u8 used_data_lanes;	/* number of CSI2 Data Lanes used */
+	struct iss_csiphy_lanes_cfg lanes;
+	struct iss_csiphy_dphy_cfg dphy;
+};
+
+int omap4iss_csiphy_config(struct iss_device *iss,
+			   struct v4l2_subdev *csi2_subdev);
+int omap4iss_csiphy_acquire(struct iss_csiphy *phy);
+void omap4iss_csiphy_release(struct iss_csiphy *phy);
+int omap4iss_csiphy_init(struct iss_device *iss);
+
+#endif	/* OMAP4_ISS_CSI_PHY_H */
-- 
1.8.1.5

