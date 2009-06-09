Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42155 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbZFISsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 14:48:51 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n59Imm4v016288
	for <linux-media@vger.kernel.org>; Tue, 9 Jun 2009 13:48:53 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 4/10 - v2] dm644x ccdc module for vpfe capture driver
Date: Tue,  9 Jun 2009 14:48:47 -0400
Message-Id: <1244573327-20463-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1244573327-20463-1-git-send-email-m-karicheri2@ti.com>
References: <1244573327-20463-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

DM644x CCDC hw module

This is the hw module for DM644x CCDC. This registers with the
vpfe capture driver and provides a set of hw_ops to configure
CCDC for a specific decoder device connected to the VPFE

Following are some of the major comments addressed :-
	1) removed vpss configration from this module to a standalone
	   vpss module that can be used by other video drivers as well
	2) replaced magic numbers with #defines
	3) cleaned up and refractored ccdc_config_raw()
	4) embedded config part of the variables inside
	   ccdc_params_raw to help in memcpy.
	5) avoided generic names for ccdc types in include file by
	   prefixing with  ccdc_

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/davinci/dm644x_ccdc.c      |  876 ++++++++++++++++++++++++
 drivers/media/video/davinci/dm644x_ccdc_regs.h |  145 ++++
 include/media/davinci/dm644x_ccdc.h            |  184 +++++
 3 files changed, 1205 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm644x_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm644x_ccdc_regs.h
 create mode 100644 include/media/davinci/dm644x_ccdc.h

diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
new file mode 100644
index 0000000..4f81f69
--- /dev/null
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -0,0 +1,876 @@
+/*
+ * Copyright (C) 2006-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * CCDC hardware module for DM6446
+ * ------------------------------
+ *
+ * This module is for configuring CCD controller of DM6446 VPFE to capture
+ * Raw yuv or Bayer RGB data from a decoder. CCDC has several modules
+ * such as Defect Pixel Correction, Color Space Conversion etc to
+ * pre-process the Raw Bayer RGB data, before writing it to SDRAM. This
+ * module also allows application to configure individual
+ * module parameters through VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL.
+ * To do so, application includes dm644x_ccdc.h and vpfe_capture.h header
+ * files.  The setparams() API is called by vpfe_capture driver
+ * to configure module parameters. This file is named DM644x so that other
+ * variants such DM6443 may be supported using the same module.
+ *
+ * TODO: Test Raw bayer parameter settings and bayer capture
+ * 	 Split module parameter structure to module specific ioctl structs
+ * 	 investigate if enum used for user space type definition
+ * 	 to be replaced by #defines or integer
+ */
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/videodev2.h>
+#include <media/davinci/dm644x_ccdc.h>
+#include <media/davinci/vpss.h>
+#include "dm644x_ccdc_regs.h"
+#include "ccdc_hw_device.h"
+
+static struct device *dev;
+
+/* Object for CCDC raw mode */
+static struct ccdc_params_raw ccdc_hw_params_raw = {
+	.pix_fmt = CCDC_PIXFMT_RAW,
+	.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
+	.win = CCDC_WIN_VGA,
+	.fid_pol = VPFE_PINPOL_POSITIVE,
+	.vd_pol = VPFE_PINPOL_POSITIVE,
+	.hd_pol = VPFE_PINPOL_POSITIVE,
+	.config_params = {
+		.data_sz = CCDC_DATA_10BITS,
+	},
+};
+
+/* Object for CCDC ycbcr mode */
+static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
+	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
+	.frm_fmt = CCDC_FRMFMT_INTERLACED,
+	.win = CCDC_WIN_PAL,
+	.fid_pol = VPFE_PINPOL_POSITIVE,
+	.vd_pol = VPFE_PINPOL_POSITIVE,
+	.hd_pol = VPFE_PINPOL_POSITIVE,
+	.bt656_enable = 1,
+	.pix_order = CCDC_PIXORDER_CBYCRY,
+	.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
+};
+
+#define CCDC_MAX_RAW_YUV_FORMATS	2
+
+/* Raw Bayer formats */
+static u32 ccdc_raw_bayer_pix_formats[] =
+	{V4L2_PIX_FMT_SBGGR8, V4L2_PIX_FMT_SBGGR16};
+
+/* Raw YUV formats */
+static u32 ccdc_raw_yuv_pix_formats[] =
+	{V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YUYV};
+
+static void *__iomem ccdc_base_addr;
+static int ccdc_addr_size;
+static enum vpfe_hw_if_type ccdc_if_type;
+
+/* register access routines */
+static inline u32 regr(u32 offset)
+{
+	return __raw_readl(ccdc_base_addr + offset);
+}
+
+static inline void regw(u32 val, u32 offset)
+{
+	__raw_writel(val, ccdc_base_addr + offset);
+}
+
+static void ccdc_set_ccdc_base(void *addr, int size)
+{
+	ccdc_base_addr = addr;
+	ccdc_addr_size = size;
+}
+
+static void ccdc_enable(int flag)
+{
+	regw(flag, CCDC_PCR);
+}
+
+static void ccdc_enable_vport(int flag)
+{
+	if (flag)
+		/* enable video port */
+		regw(CCDC_ENABLE_VIDEO_PORT, CCDC_FMTCFG);
+	else
+		regw(CCDC_DISABLE_VIDEO_PORT, CCDC_FMTCFG);
+}
+
+/*
+ * ccdc_setwin()
+ * This function will configure the window size
+ * to be capture in CCDC reg
+ */
+void ccdc_setwin(struct v4l2_rect *image_win,
+		enum ccdc_frmfmt frm_fmt,
+		int ppc)
+{
+	int horz_start, horz_nr_pixels;
+	int vert_start, vert_nr_lines;
+	int val = 0, mid_img = 0;
+
+	dev_dbg(dev, "\nStarting ccdc_setwin...");
+	/*
+	 * ppc - per pixel count. indicates how many pixels per cell
+	 * output to SDRAM. example, for ycbcr, it is one y and one c, so 2.
+	 * raw capture this is 1
+	 */
+	horz_start = image_win->left << (ppc - 1);
+	horz_nr_pixels = (image_win->width << (ppc - 1)) - 1;
+	regw((horz_start << CCDC_HORZ_INFO_SPH_SHIFT) | horz_nr_pixels,
+	     CCDC_HORZ_INFO);
+
+	vert_start = image_win->top;
+
+	if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
+		vert_nr_lines = (image_win->height >> 1) - 1;
+		vert_start >>= 1;
+		/* Since first line doesn't have any data */
+		vert_start += 1;
+		/* configure VDINT0 */
+		val = (vert_start << CCDC_VDINT_VDINT0_SHIFT);
+		regw(val, CCDC_VDINT);
+
+	} else {
+		/* Since first line doesn't have any data */
+		vert_start += 1;
+		vert_nr_lines = image_win->height - 1;
+		/*
+		 * configure VDINT0 and VDINT1. VDINT1 will be at half
+		 * of image height
+		 */
+		mid_img = vert_start + (image_win->height / 2);
+		val = (vert_start << CCDC_VDINT_VDINT0_SHIFT) |
+		    (mid_img & CCDC_VDINT_VDINT1_MASK);
+		regw(val, CCDC_VDINT);
+
+	}
+	regw((vert_start << CCDC_VERT_START_SLV0_SHIFT) | vert_start,
+	     CCDC_VERT_START);
+	regw(vert_nr_lines, CCDC_VERT_LINES);
+	dev_dbg(dev, "\nEnd of ccdc_setwin...");
+}
+
+static void ccdc_readregs(void)
+{
+	unsigned int val = 0;
+
+	val = regr(CCDC_ALAW);
+	dev_notice(dev, "\nReading 0x%x to ALAW...\n", val);
+	val = regr(CCDC_CLAMP);
+	dev_notice(dev, "\nReading 0x%x to CLAMP...\n", val);
+	val = regr(CCDC_DCSUB);
+	dev_notice(dev, "\nReading 0x%x to DCSUB...\n", val);
+	val = regr(CCDC_BLKCMP);
+	dev_notice(dev, "\nReading 0x%x to BLKCMP...\n", val);
+	val = regr(CCDC_FPC_ADDR);
+	dev_notice(dev, "\nReading 0x%x to FPC_ADDR...\n", val);
+	val = regr(CCDC_FPC);
+	dev_notice(dev, "\nReading 0x%x to FPC...\n", val);
+	val = regr(CCDC_FMTCFG);
+	dev_notice(dev, "\nReading 0x%x to FMTCFG...\n", val);
+	val = regr(CCDC_COLPTN);
+	dev_notice(dev, "\nReading 0x%x to COLPTN...\n", val);
+	val = regr(CCDC_FMT_HORZ);
+	dev_notice(dev, "\nReading 0x%x to FMT_HORZ...\n", val);
+	val = regr(CCDC_FMT_VERT);
+	dev_notice(dev, "\nReading 0x%x to FMT_VERT...\n", val);
+	val = regr(CCDC_HSIZE_OFF);
+	dev_notice(dev, "\nReading 0x%x to HSIZE_OFF...\n", val);
+	val = regr(CCDC_SDOFST);
+	dev_notice(dev, "\nReading 0x%x to SDOFST...\n", val);
+	val = regr(CCDC_VP_OUT);
+	dev_notice(dev, "\nReading 0x%x to VP_OUT...\n", val);
+	val = regr(CCDC_SYN_MODE);
+	dev_notice(dev, "\nReading 0x%x to SYN_MODE...\n", val);
+	val = regr(CCDC_HORZ_INFO);
+	dev_notice(dev, "\nReading 0x%x to HORZ_INFO...\n", val);
+	val = regr(CCDC_VERT_START);
+	dev_notice(dev, "\nReading 0x%x to VERT_START...\n", val);
+	val = regr(CCDC_VERT_LINES);
+	dev_notice(dev, "\nReading 0x%x to VERT_LINES...\n", val);
+}
+
+static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
+{
+	if (ccdcparam->alaw.enable) {
+		if ((ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) ||
+		    (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_15_6) ||
+		    (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
+			dev_dbg(dev, "\nInvalid data line select");
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
+{
+	struct ccdc_config_params_raw *config_params =
+		&ccdc_hw_params_raw.config_params;
+	unsigned int *fpc_virtaddr = NULL;
+	unsigned int *fpc_physaddr = NULL;
+
+	memcpy(config_params, raw_params, sizeof(*raw_params));
+	/*
+	 * allocate memory for fault pixel table and copy the user
+	 * values to the table
+	 */
+	if (!config_params->fault_pxl.enable)
+		return 0;
+
+	fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
+	fpc_virtaddr = (unsigned int *)phys_to_virt(
+				(unsigned long)fpc_physaddr);
+	/*
+	 * Allocate memory for FPC table if current
+	 * FPC table buffer is not big enough to
+	 * accomodate FPC Number requested
+	 */
+	if (raw_params->fault_pxl.fp_num != config_params->fault_pxl.fp_num) {
+		if (fpc_physaddr != NULL) {
+			free_pages((unsigned long)fpc_physaddr,
+				   get_order
+				   (config_params->fault_pxl.fp_num *
+				   FP_NUM_BYTES));
+		}
+
+		/* Allocate memory for FPC table */
+		fpc_virtaddr =
+			(unsigned int *)__get_free_pages(GFP_KERNEL | GFP_DMA,
+							 get_order(raw_params->
+							 fault_pxl.fp_num *
+							 FP_NUM_BYTES));
+
+		if (fpc_virtaddr == NULL) {
+			dev_dbg(dev,
+				"\nUnable to allocate memory for FPC");
+			return -EFAULT;
+		}
+		fpc_physaddr =
+		    (unsigned int *)virt_to_phys((void *)fpc_virtaddr);
+	}
+
+	/* Copy number of fault pixels and FPC table */
+	config_params->fault_pxl.fp_num = raw_params->fault_pxl.fp_num;
+	if (copy_from_user(fpc_virtaddr,
+			(void __user *)raw_params->fault_pxl.fpc_table_addr,
+			config_params->fault_pxl.fp_num * FP_NUM_BYTES)) {
+		dev_dbg(dev, "\n copy_from_user failed");
+		return -EFAULT;
+	}
+	config_params->fault_pxl.fpc_table_addr = (unsigned int)fpc_physaddr;
+	return 0;
+}
+
+static int ccdc_close(struct device *dev)
+{
+	struct ccdc_config_params_raw *config_params =
+		&ccdc_hw_params_raw.config_params;
+	unsigned int *fpc_physaddr = NULL, *fpc_virtaddr = NULL;
+
+	fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
+
+	if (fpc_physaddr != NULL) {
+		fpc_virtaddr = (unsigned int *)
+		    phys_to_virt((unsigned long)fpc_physaddr);
+		free_pages((unsigned long)fpc_virtaddr,
+			   get_order(config_params->fault_pxl.fp_num *
+			   FP_NUM_BYTES));
+	}
+	return 0;
+}
+
+/*
+ * ccdc_restore_defaults()
+ * This function will write defaults to all CCDC registers
+ */
+static void ccdc_restore_defaults(void)
+{
+	int i;
+
+	/* disable CCDC */
+	ccdc_enable(0);
+	/* set all registers to default value */
+	for (i = 4; i <= 0x94; i += 4)
+		regw(0,  i);
+	regw(CCDC_NO_CULLING, CCDC_CULLING);
+	regw(CCDC_GAMMA_BITS_11_2, CCDC_ALAW);
+}
+
+static int ccdc_open(struct device *device)
+{
+	dev = device;
+	ccdc_restore_defaults();
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_enable_vport(1);
+	return 0;
+}
+
+static void ccdc_sbl_reset(void)
+{
+	vpss_clear_wbl_overflow(VPSS_PCR_CCDC_WBL_O);
+}
+
+/* Parameter operations */
+static int ccdc_set_params(void __user *params)
+{
+	struct ccdc_config_params_raw ccdc_raw_params;
+	int x;
+
+	if (ccdc_if_type != VPFE_RAW_BAYER)
+		return -EINVAL;
+
+	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
+	if (x) {
+		dev_dbg(dev, "ccdc_set_params: error in copying"
+			   "ccdc params, %d\n", x);
+		return -EFAULT;
+	}
+
+	if (!validate_ccdc_param(&ccdc_raw_params)) {
+		if (!ccdc_update_raw_params(&ccdc_raw_params))
+			return 0;
+	}
+	return -EINVAL;
+}
+
+/*
+ * ccdc_config_ycbcr()
+ * This function will configure CCDC for YCbCr video capture
+ */
+void ccdc_config_ycbcr(void)
+{
+	struct ccdc_params_ycbcr *params = &ccdc_hw_params_ycbcr;
+	u32 syn_mode;
+
+	dev_dbg(dev, "\nStarting ccdc_config_ycbcr...");
+	/*
+	 * first restore the CCDC registers to default values
+	 * This is important since we assume default values to be set in
+	 * a lot of registers that we didn't touch
+	 */
+	ccdc_restore_defaults();
+
+	/*
+	 * configure pixel format, frame format, configure video frame
+	 * format, enable output to SDRAM, enable internal timing generator
+	 * and 8bit pack mode
+	 */
+	syn_mode = (((params->pix_fmt & CCDC_SYN_MODE_INPMOD_MASK) <<
+		    CCDC_SYN_MODE_INPMOD_SHIFT) |
+		    ((params->frm_fmt & CCDC_SYN_FLDMODE_MASK) <<
+		    CCDC_SYN_FLDMODE_SHIFT) | CCDC_VDHDEN_ENABLE |
+		    CCDC_WEN_ENABLE | CCDC_DATA_PACK_ENABLE);
+
+	/* setup BT.656 sync mode */
+	if (params->bt656_enable) {
+		regw(CCDC_REC656IF_BT656_EN, CCDC_REC656IF);
+
+		/*
+		 * configure the FID, VD, HD pin polarity,
+		 * fld,hd pol positive, vd negative, 8-bit data
+		 */
+		syn_mode |= CCDC_SYN_MODE_VD_POL_NEGATIVE | CCDC_SYN_MODE_8BITS;
+	} else {
+		/* y/c external sync mode */
+		syn_mode |= (((params->fid_pol & CCDC_FID_POL_MASK) <<
+			     CCDC_FID_POL_SHIFT) |
+			     ((params->hd_pol & CCDC_HD_POL_MASK) <<
+			     CCDC_HD_POL_SHIFT) |
+			     ((params->vd_pol & CCDC_VD_POL_MASK) <<
+			     CCDC_VD_POL_SHIFT));
+	}
+	regw(syn_mode, CCDC_SYN_MODE);
+
+	/* configure video window */
+	ccdc_setwin(&params->win, params->frm_fmt, 2);
+
+	/*
+	 * configure the order of y cb cr in SDRAM, and disable latch
+	 * internal register on vsync
+	 */
+	regw((params->pix_order << CCDC_CCDCFG_Y8POS_SHIFT) |
+		 CCDC_LATCH_ON_VSYNC_DISABLE, CCDC_CCDCFG);
+
+	/*
+	 * configure the horizontal line offset. This should be a
+	 * on 32 byte bondary. So clear LSB 5 bits
+	 */
+	regw(((params->win.width * 2  + 31) & ~0x1f), CCDC_HSIZE_OFF);
+
+	/* configure the memory line offset */
+	if (params->buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED)
+		/* two fields are interleaved in memory */
+		regw(CCDC_SDOFST_FIELD_INTERLEAVED, CCDC_SDOFST);
+
+	ccdc_sbl_reset();
+	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
+	ccdc_readregs();
+}
+
+static void ccdc_config_black_clamp(struct ccdc_black_clamp *bclamp)
+{
+	u32 val;
+
+	if (!bclamp->enable) {
+		/* configure DCSub */
+		val = (bclamp->dc_sub) & CCDC_BLK_DC_SUB_MASK;
+		regw(val, CCDC_DCSUB);
+		dev_dbg(dev, "\nWriting 0x%x to DCSUB...\n", val);
+		regw(CCDC_CLAMP_DEFAULT_VAL, CCDC_CLAMP);
+		dev_dbg(dev, "\nWriting 0x0000 to CLAMP...\n");
+		return;
+	}
+	/*
+	 * Configure gain,  Start pixel, No of line to be avg,
+	 * No of pixel/line to be avg, & Enable the Black clamping
+	 */
+	val = ((bclamp->sgain & CCDC_BLK_SGAIN_MASK) |
+	       ((bclamp->start_pixel & CCDC_BLK_ST_PXL_MASK) <<
+		CCDC_BLK_ST_PXL_SHIFT) |
+	       ((bclamp->sample_ln & CCDC_BLK_SAMPLE_LINE_MASK) <<
+		CCDC_BLK_SAMPLE_LINE_SHIFT) |
+	       ((bclamp->sample_pixel & CCDC_BLK_SAMPLE_LN_MASK) <<
+		CCDC_BLK_SAMPLE_LN_SHIFT) | CCDC_BLK_CLAMP_ENABLE);
+	regw(val, CCDC_CLAMP);
+	dev_dbg(dev, "\nWriting 0x%x to CLAMP...\n", val);
+	/* If Black clamping is enable then make dcsub 0 */
+	regw(CCDC_DCSUB_DEFAULT_VAL, CCDC_DCSUB);
+	dev_dbg(dev, "\nWriting 0x00000000 to DCSUB...\n");
+}
+
+static void ccdc_config_black_compense(struct ccdc_black_compensation *bcomp)
+{
+	u32 val;
+
+	val = ((bcomp->b & CCDC_BLK_COMP_MASK) |
+	      ((bcomp->gb & CCDC_BLK_COMP_MASK) <<
+	       CCDC_BLK_COMP_GB_COMP_SHIFT) |
+	      ((bcomp->gr & CCDC_BLK_COMP_MASK) <<
+	       CCDC_BLK_COMP_GR_COMP_SHIFT) |
+	      ((bcomp->r & CCDC_BLK_COMP_MASK) <<
+	       CCDC_BLK_COMP_R_COMP_SHIFT));
+	regw(val, CCDC_BLKCMP);
+}
+
+static void ccdc_config_fpc(struct ccdc_fault_pixel *fpc)
+{
+	u32 val;
+
+	/* Initially disable FPC */
+	val = CCDC_FPC_DISABLE;
+	regw(val, CCDC_FPC);
+
+	if (!fpc->enable)
+		return;
+
+	/* Configure Fault pixel if needed */
+	regw(fpc->fpc_table_addr, CCDC_FPC_ADDR);
+	dev_dbg(dev, "\nWriting 0x%x to FPC_ADDR...\n",
+		       (fpc->fpc_table_addr));
+	/* Write the FPC params with FPC disable */
+	val = fpc->fp_num & CCDC_FPC_FPC_NUM_MASK;
+	regw(val, CCDC_FPC);
+
+	dev_dbg(dev, "\nWriting 0x%x to FPC...\n", val);
+	/* read the FPC register */
+	val = regr(CCDC_FPC) | CCDC_FPC_ENABLE;
+	regw(val, CCDC_FPC);
+	dev_dbg(dev, "\nWriting 0x%x to FPC...\n", val);
+}
+
+/*
+ * ccdc_config_raw()
+ * This function will configure CCDC for Raw capture mode
+ */
+void ccdc_config_raw(void)
+{
+	struct ccdc_params_raw *params = &ccdc_hw_params_raw;
+	struct ccdc_config_params_raw *config_params =
+		&ccdc_hw_params_raw.config_params;
+	unsigned int syn_mode = 0;
+	unsigned int val;
+
+	dev_dbg(dev, "\nStarting ccdc_config_raw...");
+
+	/*      Reset CCDC */
+	ccdc_restore_defaults();
+
+	/* Disable latching function registers on VSYNC  */
+	regw(CCDC_LATCH_ON_VSYNC_DISABLE, CCDC_CCDCFG);
+
+	/*
+	 * Configure the vertical sync polarity(SYN_MODE.VDPOL),
+	 * horizontal sync polarity (SYN_MODE.HDPOL), frame id polarity
+	 * (SYN_MODE.FLDPOL), frame format(progressive or interlace),
+	 * data size(SYNMODE.DATSIZ), &pixel format (Input mode), output
+	 * SDRAM, enable internal timing generator
+	 */
+	syn_mode =
+		(((params->vd_pol & CCDC_VD_POL_MASK) << CCDC_VD_POL_SHIFT) |
+		((params->hd_pol & CCDC_HD_POL_MASK) << CCDC_HD_POL_SHIFT) |
+		((params->fid_pol & CCDC_FID_POL_MASK) << CCDC_FID_POL_SHIFT) |
+		((params->frm_fmt & CCDC_FRM_FMT_MASK) << CCDC_FRM_FMT_SHIFT) |
+		((config_params->data_sz & CCDC_DATA_SZ_MASK) <<
+		CCDC_DATA_SZ_SHIFT) |
+		((params->pix_fmt & CCDC_PIX_FMT_MASK) << CCDC_PIX_FMT_SHIFT) |
+		CCDC_WEN_ENABLE | CCDC_VDHDEN_ENABLE);
+
+	/* Enable and configure aLaw register if needed */
+	if (config_params->alaw.enable) {
+		val = ((config_params->alaw.gama_wd &
+		      CCDC_ALAW_GAMA_WD_MASK) | CCDC_ALAW_ENABLE);
+		regw(val, CCDC_ALAW);
+		dev_dbg(dev, "\nWriting 0x%x to ALAW...\n", val);
+	}
+
+	/* Configure video window */
+	ccdc_setwin(&params->win, params->frm_fmt, CCDC_PPC_RAW);
+
+	/* Configure Black Clamp */
+	ccdc_config_black_clamp(&config_params->blk_clamp);
+
+	/* Configure Black level compensation */
+	ccdc_config_black_compense(&config_params->blk_comp);
+
+	/* Configure Fault Pixel Correction */
+	ccdc_config_fpc(&config_params->fault_pxl);
+
+	/* If data size is 8 bit then pack the data */
+	if ((config_params->data_sz == CCDC_DATA_8BITS) ||
+	     config_params->alaw.enable)
+		syn_mode |= CCDC_DATA_PACK_ENABLE;
+
+#ifdef CONFIG_DM644X_VIDEO_PORT_ENABLE
+	/* enable video port */
+	val = CCDC_ENABLE_VIDEO_PORT;
+#else
+	/* disable video port */
+	val = CCDC_DISABLE_VIDEO_PORT;
+#endif
+
+	if (config_params->data_sz == CCDC_DATA_8BITS)
+		val |= (CCDC_DATA_10BITS & CCDC_FMTCFG_VPIN_MASK)
+		    << CCDC_FMTCFG_VPIN_SHIFT;
+	else
+		val |= (config_params->data_sz & CCDC_FMTCFG_VPIN_MASK)
+		    << CCDC_FMTCFG_VPIN_SHIFT;
+	/* Write value in FMTCFG */
+	regw(val, CCDC_FMTCFG);
+
+	dev_dbg(dev, "\nWriting 0x%x to FMTCFG...\n", val);
+	/* Configure the color pattern according to mt9t001 sensor */
+	regw(CCDC_COLPTN_VAL, CCDC_COLPTN);
+
+	dev_dbg(dev, "\nWriting 0xBB11BB11 to COLPTN...\n");
+	/*
+	 * Configure Data formatter(Video port) pixel selection
+	 * (FMT_HORZ, FMT_VERT)
+	 */
+	val = ((params->win.left & CCDC_FMT_HORZ_FMTSPH_MASK) <<
+	      CCDC_FMT_HORZ_FMTSPH_SHIFT) |
+	      (params->win.width & CCDC_FMT_HORZ_FMTLNH_MASK);
+	regw(val, CCDC_FMT_HORZ);
+
+	dev_dbg(dev, "\nWriting 0x%x to FMT_HORZ...\n", val);
+	val = (params->win.top & CCDC_FMT_VERT_FMTSLV_MASK)
+	    << CCDC_FMT_VERT_FMTSLV_SHIFT;
+	if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE)
+		val |= (params->win.height) & CCDC_FMT_VERT_FMTLNV_MASK;
+	else
+		val |= (params->win.height >> 1) & CCDC_FMT_VERT_FMTLNV_MASK;
+
+	dev_dbg(dev, "\nparams->win.height  0x%x ...\n",
+	       params->win.height);
+	regw(val, CCDC_FMT_VERT);
+
+	dev_dbg(dev, "\nWriting 0x%x to FMT_VERT...\n", val);
+
+	dev_dbg(dev, "\nbelow regw(val, FMT_VERT)...");
+
+	/*
+	 * Configure Horizontal offset register. If pack 8 is enabled then
+	 * 1 pixel will take 1 byte
+	 */
+	if ((config_params->data_sz == CCDC_DATA_8BITS) ||
+	    config_params->alaw.enable)
+		regw((params->win.width + CCDC_32BYTE_ALIGN_VAL) &
+		    CCDC_HSIZE_OFF_MASK, CCDC_HSIZE_OFF);
+	else
+		/* else one pixel will take 2 byte */
+		regw(((params->win.width * CCDC_TWO_BYTES_PER_PIXEL) +
+		    CCDC_32BYTE_ALIGN_VAL) & CCDC_HSIZE_OFF_MASK,
+		    CCDC_HSIZE_OFF);
+
+	/* Set value for SDOFST */
+	if (params->frm_fmt == CCDC_FRMFMT_INTERLACED) {
+		if (params->image_invert_enable) {
+			/* For intelace inverse mode */
+			regw(CCDC_INTERLACED_IMAGE_INVERT, CCDC_SDOFST);
+			dev_dbg(dev, "\nWriting 0x4B6D to SDOFST...\n");
+		}
+
+		else {
+			/* For intelace non inverse mode */
+			regw(CCDC_INTERLACED_NO_IMAGE_INVERT, CCDC_SDOFST);
+			dev_dbg(dev, "\nWriting 0x0249 to SDOFST...\n");
+		}
+	} else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
+		regw(CCDC_PROGRESSIVE_NO_IMAGE_INVERT, CCDC_SDOFST);
+		dev_dbg(dev, "\nWriting 0x0000 to SDOFST...\n");
+	}
+
+	/*
+	 * Configure video port pixel selection (VPOUT)
+	 * Here -1 is to make the height value less than FMT_VERT.FMTLNV
+	 */
+	if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE)
+		val = (((params->win.height - 1) & CCDC_VP_OUT_VERT_NUM_MASK))
+		    << CCDC_VP_OUT_VERT_NUM_SHIFT;
+	else
+		val =
+		    ((((params->win.height >> CCDC_INTERLACED_HEIGHT_SHIFT) -
+		     1) & CCDC_VP_OUT_VERT_NUM_MASK)) <<
+		    CCDC_VP_OUT_VERT_NUM_SHIFT;
+
+	val |= ((((params->win.width))) & CCDC_VP_OUT_HORZ_NUM_MASK)
+	    << CCDC_VP_OUT_HORZ_NUM_SHIFT;
+	val |= (params->win.left) & CCDC_VP_OUT_HORZ_ST_MASK;
+	regw(val, CCDC_VP_OUT);
+
+	dev_dbg(dev, "\nWriting 0x%x to VP_OUT...\n", val);
+	regw(syn_mode, CCDC_SYN_MODE);
+	dev_dbg(dev, "\nWriting 0x%x to SYN_MODE...\n", syn_mode);
+
+	ccdc_sbl_reset();
+	dev_dbg(dev, "\nend of ccdc_config_raw...");
+	ccdc_readregs();
+}
+
+static int ccdc_configure(void)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_config_raw();
+	else
+		ccdc_config_ycbcr();
+	return 0;
+}
+
+static int ccdc_set_buftype(enum ccdc_buftype buf_type)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_hw_params_raw.buf_type = buf_type;
+	else
+		ccdc_hw_params_ycbcr.buf_type = buf_type;
+	return 0;
+}
+
+static enum ccdc_buftype ccdc_get_buftype(void)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		return ccdc_hw_params_raw.buf_type;
+	return ccdc_hw_params_ycbcr.buf_type;
+}
+
+static int ccdc_enum_pix(u32 *pix, int i)
+{
+	int ret = -EINVAL;
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		if (i < ARRAY_SIZE(ccdc_raw_bayer_pix_formats)) {
+			*pix = ccdc_raw_bayer_pix_formats[i];
+			ret = 0;
+		}
+	} else {
+		if (i < ARRAY_SIZE(ccdc_raw_yuv_pix_formats)) {
+			*pix = ccdc_raw_yuv_pix_formats[i];
+			ret = 0;
+		}
+	}
+	return ret;
+}
+
+static int ccdc_set_pixel_format(u32 pixfmt)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		ccdc_hw_params_raw.pix_fmt = CCDC_PIXFMT_RAW;
+		if (pixfmt == V4L2_PIX_FMT_SBGGR8)
+			ccdc_hw_params_raw.config_params.alaw.enable = 1;
+		else if (pixfmt != V4L2_PIX_FMT_SBGGR16)
+			return -EINVAL;
+	} else {
+		if (pixfmt == V4L2_PIX_FMT_YUYV)
+			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
+		else if (pixfmt == V4L2_PIX_FMT_UYVY)
+			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
+		else
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static u32 ccdc_get_pixel_format(void)
+{
+	struct ccdc_a_law *alaw =
+		&ccdc_hw_params_raw.config_params.alaw;
+	u32 pixfmt;
+
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		if (alaw->enable)
+			pixfmt = V4L2_PIX_FMT_SBGGR8;
+		else
+			pixfmt = V4L2_PIX_FMT_SBGGR16;
+	else {
+		if (ccdc_hw_params_ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
+			pixfmt = V4L2_PIX_FMT_YUYV;
+		else
+			pixfmt = V4L2_PIX_FMT_UYVY;
+	}
+	return pixfmt;
+}
+
+static int ccdc_set_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_hw_params_raw.win = *win;
+	else
+		ccdc_hw_params_ycbcr.win = *win;
+	return 0;
+}
+
+static void ccdc_get_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		*win = ccdc_hw_params_raw.win;
+	else
+		*win = ccdc_hw_params_ycbcr.win;
+}
+
+static unsigned int ccdc_get_line_length(void)
+{
+	struct ccdc_config_params_raw *config_params =
+		&ccdc_hw_params_raw.config_params;
+	unsigned int len;
+
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		if ((config_params->alaw.enable) ||
+		    (config_params->data_sz == CCDC_DATA_8BITS))
+			len = ccdc_hw_params_raw.win.width;
+		else
+			len = ccdc_hw_params_raw.win.width * 2;
+	} else
+		len = ccdc_hw_params_ycbcr.win.width * 2;
+	return ALIGN(len, 32);
+}
+
+static int ccdc_set_frame_format(enum ccdc_frmfmt frm_fmt)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_hw_params_raw.frm_fmt = frm_fmt;
+	else
+		ccdc_hw_params_ycbcr.frm_fmt = frm_fmt;
+	return 0;
+}
+
+static enum ccdc_frmfmt ccdc_get_frame_format(void)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		return ccdc_hw_params_raw.frm_fmt;
+	else
+		return ccdc_hw_params_ycbcr.frm_fmt;
+}
+
+static int ccdc_getfid(void)
+{
+	return (regr(CCDC_SYN_MODE) >> 15) & 1;
+}
+
+/* misc operations */
+static inline void ccdc_setfbaddr(unsigned long addr)
+{
+	regw(addr & 0xffffffe0, CCDC_SDR_ADDR);
+}
+
+static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
+{
+	ccdc_if_type = params->if_type;
+
+	switch (params->if_type) {
+	case VPFE_BT656:
+	case VPFE_YCBCR_SYNC_16:
+	case VPFE_YCBCR_SYNC_8:
+		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
+		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
+		break;
+	default:
+		/* TODO add support for raw bayer here */
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct ccdc_hw_device ccdc_hw_dev = {
+	.name = "DM6446 CCDC",
+	.owner = THIS_MODULE,
+	.hw_ops = {
+		.open = ccdc_open,
+		.close = ccdc_close,
+		.set_ccdc_base = ccdc_set_ccdc_base,
+		.reset = ccdc_sbl_reset,
+		.enable = ccdc_enable,
+		.set_hw_if_params = ccdc_set_hw_if_params,
+		.set_params = ccdc_set_params,
+		.configure = ccdc_configure,
+		.set_buftype = ccdc_set_buftype,
+		.get_buftype = ccdc_get_buftype,
+		.enum_pix = ccdc_enum_pix,
+		.set_pixel_format = ccdc_set_pixel_format,
+		.get_pixel_format = ccdc_get_pixel_format,
+		.set_frame_format = ccdc_set_frame_format,
+		.get_frame_format = ccdc_get_frame_format,
+		.set_image_window = ccdc_set_image_window,
+		.get_image_window = ccdc_get_image_window,
+		.get_line_length = ccdc_get_line_length,
+		.setfbaddr = ccdc_setfbaddr,
+		.getfid = ccdc_getfid,
+	},
+};
+
+static int dm644x_ccdc_init(void)
+{
+	printk(KERN_NOTICE "dm644x_ccdc_init\n");
+	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
+		return -1;
+	printk(KERN_NOTICE "%s is registered with vpfe.\n",
+		ccdc_hw_dev.name);
+	return 0;
+}
+
+static void dm644x_ccdc_exit(void)
+{
+	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+}
+
+module_init(dm644x_ccdc_init);
+module_exit(dm644x_ccdc_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/davinci/dm644x_ccdc_regs.h b/drivers/media/video/davinci/dm644x_ccdc_regs.h
new file mode 100644
index 0000000..6e5d053
--- /dev/null
+++ b/drivers/media/video/davinci/dm644x_ccdc_regs.h
@@ -0,0 +1,145 @@
+/*
+ * Copyright (C) 2006-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _DM644X_CCDC_REGS_H
+#define _DM644X_CCDC_REGS_H
+
+/**************************************************************************\
+* Register OFFSET Definitions
+\**************************************************************************/
+#define CCDC_PID				0x0
+#define CCDC_PCR				0x4
+#define CCDC_SYN_MODE				0x8
+#define CCDC_HD_VD_WID				0xc
+#define CCDC_PIX_LINES				0x10
+#define CCDC_HORZ_INFO				0x14
+#define CCDC_VERT_START				0x18
+#define CCDC_VERT_LINES				0x1c
+#define CCDC_CULLING				0x20
+#define CCDC_HSIZE_OFF				0x24
+#define CCDC_SDOFST				0x28
+#define CCDC_SDR_ADDR				0x2c
+#define CCDC_CLAMP				0x30
+#define CCDC_DCSUB				0x34
+#define CCDC_COLPTN				0x38
+#define CCDC_BLKCMP				0x3c
+#define CCDC_FPC				0x40
+#define CCDC_FPC_ADDR				0x44
+#define CCDC_VDINT				0x48
+#define CCDC_ALAW				0x4c
+#define CCDC_REC656IF				0x50
+#define CCDC_CCDCFG				0x54
+#define CCDC_FMTCFG				0x58
+#define CCDC_FMT_HORZ				0x5c
+#define CCDC_FMT_VERT				0x60
+#define CCDC_FMT_ADDR0				0x64
+#define CCDC_FMT_ADDR1				0x68
+#define CCDC_FMT_ADDR2				0x6c
+#define CCDC_FMT_ADDR3				0x70
+#define CCDC_FMT_ADDR4				0x74
+#define CCDC_FMT_ADDR5				0x78
+#define CCDC_FMT_ADDR6				0x7c
+#define CCDC_FMT_ADDR7				0x80
+#define CCDC_PRGEVEN_0				0x84
+#define CCDC_PRGEVEN_1				0x88
+#define CCDC_PRGODD_0				0x8c
+#define CCDC_PRGODD_1				0x90
+#define CCDC_VP_OUT				0x94
+
+
+/***************************************************************
+*	Define for various register bit mask and shifts for CCDC
+****************************************************************/
+#define CCDC_FID_POL_MASK			1
+#define CCDC_FID_POL_SHIFT			4
+#define CCDC_HD_POL_MASK			1
+#define CCDC_HD_POL_SHIFT			3
+#define CCDC_VD_POL_MASK			1
+#define CCDC_VD_POL_SHIFT			2
+#define CCDC_HSIZE_OFF_MASK			0xffffffe0
+#define CCDC_32BYTE_ALIGN_VAL			31
+#define CCDC_FRM_FMT_MASK			0x1
+#define CCDC_FRM_FMT_SHIFT			7
+#define CCDC_DATA_SZ_MASK			7
+#define CCDC_DATA_SZ_SHIFT			8
+#define CCDC_PIX_FMT_MASK			3
+#define CCDC_PIX_FMT_SHIFT			12
+#define CCDC_VP2SDR_DISABLE			0xFFFBFFFF
+#define CCDC_WEN_ENABLE				(1 << 17)
+#define CCDC_SDR2RSZ_DISABLE			0xFFF7FFFF
+#define CCDC_VDHDEN_ENABLE			(1 << 16)
+#define CCDC_LPF_ENABLE				(1 << 14)
+#define CCDC_ALAW_ENABLE			(1 << 3)
+#define CCDC_ALAW_GAMA_WD_MASK			7
+#define CCDC_BLK_CLAMP_ENABLE			(1 << 31)
+#define CCDC_BLK_SGAIN_MASK			0x1F
+#define CCDC_BLK_ST_PXL_MASK			0x7FFF
+#define CCDC_BLK_ST_PXL_SHIFT			10
+#define CCDC_BLK_SAMPLE_LN_MASK			7
+#define CCDC_BLK_SAMPLE_LN_SHIFT		28
+#define CCDC_BLK_SAMPLE_LINE_MASK		7
+#define CCDC_BLK_SAMPLE_LINE_SHIFT		25
+#define CCDC_BLK_DC_SUB_MASK			0x03FFF
+#define CCDC_BLK_COMP_MASK			0xFF
+#define CCDC_BLK_COMP_GB_COMP_SHIFT		8
+#define CCDC_BLK_COMP_GR_COMP_SHIFT		16
+#define CCDC_BLK_COMP_R_COMP_SHIFT		24
+#define CCDC_LATCH_ON_VSYNC_DISABLE		(1 << 15)
+#define CCDC_FPC_ENABLE				(1 << 15)
+#define CCDC_FPC_DISABLE			0
+#define CCDC_FPC_FPC_NUM_MASK 			0x7FFF
+#define CCDC_DATA_PACK_ENABLE			(1 << 11)
+#define CCDC_FMTCFG_VPIN_MASK			7
+#define CCDC_FMTCFG_VPIN_SHIFT			12
+#define CCDC_FMT_HORZ_FMTLNH_MASK		0x1FFF
+#define CCDC_FMT_HORZ_FMTSPH_MASK		0x1FFF
+#define CCDC_FMT_HORZ_FMTSPH_SHIFT		16
+#define CCDC_FMT_VERT_FMTLNV_MASK		0x1FFF
+#define CCDC_FMT_VERT_FMTSLV_MASK		0x1FFF
+#define CCDC_FMT_VERT_FMTSLV_SHIFT		16
+#define CCDC_VP_OUT_VERT_NUM_MASK		0x3FFF
+#define CCDC_VP_OUT_VERT_NUM_SHIFT		17
+#define CCDC_VP_OUT_HORZ_NUM_MASK		0x1FFF
+#define CCDC_VP_OUT_HORZ_NUM_SHIFT		4
+#define CCDC_VP_OUT_HORZ_ST_MASK		0xF
+#define CCDC_HORZ_INFO_SPH_SHIFT		16
+#define CCDC_VERT_START_SLV0_SHIFT		16
+#define CCDC_VDINT_VDINT0_SHIFT			16
+#define CCDC_VDINT_VDINT1_MASK			0xFFFF
+#define CCDC_PPC_RAW				1
+#define CCDC_DCSUB_DEFAULT_VAL			0
+#define CCDC_CLAMP_DEFAULT_VAL			0
+#define CCDC_ENABLE_VIDEO_PORT			0x8000
+#define CCDC_DISABLE_VIDEO_PORT			0
+#define CCDC_COLPTN_VAL				0xBB11BB11
+#define CCDC_TWO_BYTES_PER_PIXEL		2
+#define CCDC_INTERLACED_IMAGE_INVERT		0x4B6D
+#define CCDC_INTERLACED_NO_IMAGE_INVERT		0x0249
+#define CCDC_PROGRESSIVE_IMAGE_INVERT		0x4000
+#define CCDC_PROGRESSIVE_NO_IMAGE_INVERT	0
+#define CCDC_INTERLACED_HEIGHT_SHIFT		1
+#define CCDC_SYN_MODE_INPMOD_SHIFT		12
+#define CCDC_SYN_MODE_INPMOD_MASK		3
+#define CCDC_SYN_MODE_8BITS			(7 << 8)
+#define CCDC_SYN_FLDMODE_MASK			1
+#define CCDC_SYN_FLDMODE_SHIFT			7
+#define CCDC_REC656IF_BT656_EN			3
+#define CCDC_SYN_MODE_VD_POL_NEGATIVE		(1 << 2)
+#define CCDC_CCDCFG_Y8POS_SHIFT			11
+#define CCDC_SDOFST_FIELD_INTERLEAVED		0x249
+#define CCDC_NO_CULLING				0xffff00ff
+#endif
diff --git a/include/media/davinci/dm644x_ccdc.h b/include/media/davinci/dm644x_ccdc.h
new file mode 100644
index 0000000..3e178eb
--- /dev/null
+++ b/include/media/davinci/dm644x_ccdc.h
@@ -0,0 +1,184 @@
+/*
+ * Copyright (C) 2006-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _DM644X_CCDC_H
+#define _DM644X_CCDC_H
+#include <media/davinci/ccdc_types.h>
+#include <media/davinci/vpfe_types.h>
+
+/* enum for No of pixel per line to be avg. in Black Clamping*/
+enum ccdc_sample_length {
+	CCDC_SAMPLE_1PIXELS,
+	CCDC_SAMPLE_2PIXELS,
+	CCDC_SAMPLE_4PIXELS,
+	CCDC_SAMPLE_8PIXELS,
+	CCDC_SAMPLE_16PIXELS
+};
+
+/* enum for No of lines in Black Clamping */
+enum ccdc_sample_line {
+	CCDC_SAMPLE_1LINES,
+	CCDC_SAMPLE_2LINES,
+	CCDC_SAMPLE_4LINES,
+	CCDC_SAMPLE_8LINES,
+	CCDC_SAMPLE_16LINES
+};
+
+/* enum for Alaw gama width */
+enum ccdc_gama_width {
+	CCDC_GAMMA_BITS_15_6,
+	CCDC_GAMMA_BITS_14_5,
+	CCDC_GAMMA_BITS_13_4,
+	CCDC_GAMMA_BITS_12_3,
+	CCDC_GAMMA_BITS_11_2,
+	CCDC_GAMMA_BITS_10_1,
+	CCDC_GAMMA_BITS_09_0
+};
+
+enum ccdc_data_size {
+	CCDC_DATA_16BITS,
+	CCDC_DATA_15BITS,
+	CCDC_DATA_14BITS,
+	CCDC_DATA_13BITS,
+	CCDC_DATA_12BITS,
+	CCDC_DATA_11BITS,
+	CCDC_DATA_10BITS,
+	CCDC_DATA_8BITS
+};
+
+/* structure for ALaw */
+struct ccdc_a_law {
+	/* Enable/disable A-Law */
+	unsigned char enable;
+	/* Gama Width Input */
+	enum ccdc_gama_width gama_wd;
+};
+
+/* structure for Black Clamping */
+struct ccdc_black_clamp {
+	unsigned char enable;
+	/* only if bClampEnable is TRUE */
+	enum ccdc_sample_length sample_pixel;
+	/* only if bClampEnable is TRUE */
+	enum ccdc_sample_line sample_ln;
+	/* only if bClampEnable is TRUE */
+	unsigned short start_pixel;
+	/* only if bClampEnable is TRUE */
+	unsigned short sgain;
+	/* only if bClampEnable is FALSE */
+	unsigned short dc_sub;
+};
+
+/* structure for Black Level Compensation */
+struct ccdc_black_compensation {
+	/* Constant value to subtract from Red component */
+	char r;
+	/* Constant value to subtract from Gr component */
+	char gr;
+	/* Constant value to subtract from Blue component */
+	char b;
+	/* Constant value to subtract from Gb component */
+	char gb;
+};
+
+/* structure for fault pixel correction */
+struct ccdc_fault_pixel {
+	/* Enable or Disable fault pixel correction */
+	unsigned char enable;
+	/* Number of fault pixel */
+	unsigned short fp_num;
+	/* Address of fault pixel table */
+	unsigned int fpc_table_addr;
+};
+
+/* Structure for CCDC configuration parameters for raw capture mode passed
+ * by application
+ */
+struct ccdc_config_params_raw {
+	/* data size value from 8 to 16 bits */
+	enum ccdc_data_size data_sz;
+	/* Structure for Optional A-Law */
+	struct ccdc_a_law alaw;
+	/* Structure for Optical Black Clamp */
+	struct ccdc_black_clamp blk_clamp;
+	/* Structure for Black Compensation */
+	struct ccdc_black_compensation blk_comp;
+	/* Structure for Fault Pixel Module Configuration */
+	struct ccdc_fault_pixel fault_pxl;
+};
+
+
+#ifdef __KERNEL__
+#include <linux/io.h>
+/* Define to enable/disable video port */
+#define FP_NUM_BYTES		4
+/* Define for extra pixel/line and extra lines/frame */
+#define NUM_EXTRAPIXELS		8
+#define NUM_EXTRALINES		8
+
+/* settings for commonly used video formats */
+#define CCDC_WIN_PAL     {0, 0, 720, 576}
+/* ntsc square pixel */
+#define CCDC_WIN_VGA	{0, 0, (640 + NUM_EXTRAPIXELS), (480 + NUM_EXTRALINES)}
+
+/* Structure for CCDC configuration parameters for raw capture mode */
+struct ccdc_params_raw {
+	/* pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* progressive or interlaced frame */
+	enum ccdc_frmfmt frm_fmt;
+	/* video window */
+	struct v4l2_rect win;
+	/* field id polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* vertical sync polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* horizontal sync polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* interleaved or separated fields */
+	enum ccdc_buftype buf_type;
+	/*
+	 * enable to store the image in inverse
+	 * order in memory(bottom to top)
+	 */
+	unsigned char image_invert_enable;
+	/* configurable paramaters */
+	struct ccdc_config_params_raw config_params;
+};
+
+struct ccdc_params_ycbcr {
+	/* pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* progressive or interlaced frame */
+	enum ccdc_frmfmt frm_fmt;
+	/* video window */
+	struct v4l2_rect win;
+	/* field id polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* vertical sync polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* horizontal sync polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* enable BT.656 embedded sync mode */
+	int bt656_enable;
+	/* cb:y:cr:y or y:cb:y:cr in memory */
+	enum ccdc_pixorder pix_order;
+	/* interleaved or separated fields  */
+	enum ccdc_buftype buf_type;
+};
+#endif
+#endif				/* _DM644X_CCDC_H */
-- 
1.6.0.4

