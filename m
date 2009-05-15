Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42754 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZEOShR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 14:37:17 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4FIbDf4008388
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:37:18 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 4/9] dm644x ccdc module for vpfe capture driver
Date: Fri, 15 May 2009 14:37:10 -0400
Message-Id: <1242412630-11421-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

DM644x CCDC hw module

This is the hw module for DM644x CCDC. This registers with the
vpfe capture driver and provides a set of hw_ops to configure
CCDC for a specific decoder device connected to the VPFE

This has the comments incorporated from the previous review

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/davinci/dm644x_ccdc.c      | 1018 ++++++++++++++++++++++++
 drivers/media/video/davinci/dm644x_ccdc_regs.h |  140 ++++
 include/media/davinci/dm644x_ccdc.h            |  206 +++++
 3 files changed, 1364 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm644x_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm644x_ccdc_regs.h
 create mode 100644 include/media/davinci/dm644x_ccdc.h

diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
new file mode 100644
index 0000000..24a358f
--- /dev/null
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -0,0 +1,1018 @@
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
+ */
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <asm/page.h>
+#include <media/davinci/ccdc_hw_device.h>
+#include <media/davinci/dm644x_ccdc.h>
+#include "dm644x_ccdc_regs.h"
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
+	.image_invert_enable = 0,
+	.data_sz = _10BITS,
+	.alaw = {
+		.b_alaw_enable = 0
+	},
+	.blk_clamp = {
+		.b_clamp_enable = 0,
+		.dc_sub = 0
+	},
+	.blk_comp = {0, 0, 0, 0},
+	.fault_pxl = {
+		.fpc_enable = 0
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
+#define CCDC_MAX_RAW_BAYER_FORMATS	2
+#define CCDC_MAX_RAW_YUV_FORMATS	2
+
+/* Raw Bayer formats */
+static enum vpfe_hw_pix_format
+	ccdc_raw_bayer_hw_formats[CCDC_MAX_RAW_BAYER_FORMATS] =
+		{VPFE_BAYER_8BIT_PACK_ALAW, VPFE_BAYER};
+
+/* Raw YUV formats */
+static enum vpfe_hw_pix_format
+	ccdc_raw_yuv_hw_formats[CCDC_MAX_RAW_YUV_FORMATS] =
+		{VPFE_UYVY, VPFE_YUYV};
+
+static void *__iomem ccdc_base_addr;
+static int ccdc_addr_size;
+static void *__iomem vpss_base_addr;
+static int vpss_addr_size;
+static struct ccdc_config_params_raw ccdc_hw_params_raw_temp;
+static enum vpfe_hw_if_type ccdc_if_type;
+
+/* register access routines */
+static inline u32 regr(u32 offset)
+{
+	if (offset <= ccdc_addr_size)
+		return __raw_readl(ccdc_base_addr + offset);
+	else {
+		dev_err(dev, "offset exceeds ccdc register address space\n");
+		return -1;
+	}
+}
+
+static inline u32 regw(u32 val, u32 offset)
+{
+	if (offset <= ccdc_addr_size) {
+		__raw_writel(val, ccdc_base_addr + offset);
+		return val;
+	} else {
+		dev_err(dev, "offset exceeds ccdc register address space\n");
+		return -1;
+	}
+}
+
+/* register access routines */
+static inline u32 regr_sb(u32 offset)
+{
+	if (offset <= vpss_addr_size)
+		return __raw_readl(vpss_base_addr + offset);
+	else {
+		dev_err(dev, "offset exceeds vpss register address space\n");
+		return -1;
+	}
+}
+
+static inline u32 regw_sb(u32 val, u32 offset)
+{
+	if (offset <= vpss_addr_size) {
+		__raw_writel(val, vpss_base_addr + offset);
+		return val;
+	} else {
+		dev_err(dev, "offset exceeds vpss register address space\n");
+		return -1;
+	}
+}
+
+static void ccdc_set_ccdc_base(void *addr, int size)
+{
+	ccdc_base_addr = addr;
+	ccdc_addr_size = size;
+}
+
+static void ccdc_set_vpss_base(void *addr, int size)
+{
+	vpss_base_addr = addr;
+	vpss_addr_size = size;
+}
+
+static void ccdc_enable(int flag)
+{
+	regw(flag, PCR);
+}
+
+static void ccdc_enable_vport(int flag)
+{
+	if (flag)
+		/* enable video port */
+		regw(ENABLE_VIDEO_PORT, FMTCFG);
+	else
+		regw(DISABLE_VIDEO_PORT, FMTCFG);
+}
+
+/*
+ * ======== ccdc_setwin  ========
+ * This function will configure the window size
+ * to be capture in CCDC reg
+ */
+void ccdc_setwin(struct ccdc_imgwin *image_win,
+		enum ccdc_frmfmt frm_fmt,
+		int ppc)
+{
+	int horz_start, horz_nr_pixels;
+	int vert_start, vert_nr_lines;
+	int val = 0, mid_img = 0;
+	dev_dbg(dev, "\nStarting ccdc_setwin...");
+	/* configure horizonal and vertical starts and sizes */
+	/* Here, (ppc-1) will be different for raw and yuv modes */
+	horz_start = image_win->left << (ppc - 1);
+	horz_nr_pixels = (image_win->width << (ppc - 1)) - 1;
+	regw((horz_start << CCDC_HORZ_INFO_SPH_SHIFT) | horz_nr_pixels,
+	     HORZ_INFO);
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
+		regw(val, VDINT);
+
+	} else {
+		/* Since first line doesn't have any data */
+		vert_start += 1;
+		vert_nr_lines = image_win->height - 1;
+		/* configure VDINT0 and VDINT1 */
+		/* VDINT1 will be at half of image height */
+		mid_img = vert_start + (image_win->height / 2);
+		val = (vert_start << CCDC_VDINT_VDINT0_SHIFT) |
+		    (mid_img & CCDC_VDINT_VDINT1_MASK);
+		regw(val, VDINT);
+
+	}
+	regw((vert_start << CCDC_VERT_START_SLV0_SHIFT) | vert_start,
+	     VERT_START);
+	regw(vert_nr_lines, VERT_LINES);
+	dev_dbg(dev, "\nEnd of ccdc_setwin...");
+}
+
+static void ccdc_readregs(void)
+{
+	unsigned int val = 0;
+
+	val = regr(ALAW);
+	dev_notice(dev, "\nReading 0x%x to ALAW...\n", val);
+	val = regr(CLAMP);
+	dev_notice(dev, "\nReading 0x%x to CLAMP...\n", val);
+	val = regr(DCSUB);
+	dev_notice(dev, "\nReading 0x%x to DCSUB...\n", val);
+	val = regr(BLKCMP);
+	dev_notice(dev, "\nReading 0x%x to BLKCMP...\n", val);
+	val = regr(FPC_ADDR);
+	dev_notice(dev, "\nReading 0x%x to FPC_ADDR...\n", val);
+	val = regr(FPC);
+	dev_notice(dev, "\nReading 0x%x to FPC...\n", val);
+	val = regr(FMTCFG);
+	dev_notice(dev, "\nReading 0x%x to FMTCFG...\n", val);
+	val = regr(COLPTN);
+	dev_notice(dev, "\nReading 0x%x to COLPTN...\n", val);
+	val = regr(FMT_HORZ);
+	dev_notice(dev, "\nReading 0x%x to FMT_HORZ...\n", val);
+	val = regr(FMT_VERT);
+	dev_notice(dev, "\nReading 0x%x to FMT_VERT...\n", val);
+	val = regr(HSIZE_OFF);
+	dev_notice(dev, "\nReading 0x%x to HSIZE_OFF...\n", val);
+	val = regr(SDOFST);
+	dev_notice(dev, "\nReading 0x%x to SDOFST...\n", val);
+	val = regr(VP_OUT);
+	dev_notice(dev, "\nReading 0x%x to VP_OUT...\n", val);
+	val = regr(SYN_MODE);
+	dev_notice(dev, "\nReading 0x%x to SYN_MODE...\n", val);
+	val = regr(HORZ_INFO);
+	dev_notice(dev, "\nReading 0x%x to HORZ_INFO...\n", val);
+	val = regr(VERT_START);
+	dev_notice(dev, "\nReading 0x%x to VERT_START...\n", val);
+	val = regr(VERT_LINES);
+	dev_notice(dev, "\nReading 0x%x to VERT_LINES...\n", val);
+}
+
+static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
+{
+	if (ccdc_hw_params_raw.alaw.b_alaw_enable) {
+		if ((ccdcparam->alaw.gama_wd > BITS_09_0)
+		    || (ccdcparam->alaw.gama_wd < BITS_15_6)
+		    || (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
+			dev_err(dev, "\nInvalid data line select");
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int ccdc_update_raw_params(void *arg)
+{
+	unsigned int *fpc_virtaddr = NULL;
+	unsigned int *fpc_physaddr = NULL;
+	struct ccdc_params_raw *ccd_params = &ccdc_hw_params_raw;
+	struct ccdc_config_params_raw *raw_params =
+			(struct ccdc_config_params_raw *) arg;
+	ccd_params->image_invert_enable = raw_params->image_invert_enable;
+
+	dev_dbg(dev, "\nimage_invert_enable = %d",
+	       ccd_params->image_invert_enable);
+
+	ccd_params->data_sz = raw_params->data_sz;
+	dev_dbg(dev, "\ndata_sz = %d", ccd_params->data_sz);
+
+	ccd_params->alaw.b_alaw_enable = raw_params->alaw.b_alaw_enable;
+	dev_dbg(dev, "\nALaw Enable = %d", ccd_params->alaw.b_alaw_enable);
+	/* copy A-Law configurations to vpfe_device, from arg
+	 * passed by application */
+	if (ccd_params->alaw.b_alaw_enable) {
+		ccd_params->alaw.gama_wd = raw_params->alaw.gama_wd;
+		dev_dbg(dev, "\nALaw Gama width = %d",
+		       ccd_params->alaw.gama_wd);
+	}
+
+	/* copy Optical Balck Clamping configurations to
+	 * vpfe_device,from arg passed by application */
+	ccd_params->blk_clamp.b_clamp_enable
+	    = raw_params->blk_clamp.b_clamp_enable;
+	dev_dbg(dev, "\nb_clamp_enable = %d",
+	       ccd_params->blk_clamp.b_clamp_enable);
+	if (ccd_params->blk_clamp.b_clamp_enable) {
+		/*gain */
+		ccd_params->blk_clamp.sgain = raw_params->blk_clamp.sgain;
+		dev_dbg(dev, "\nblk_clamp.sgain = %d",
+		       ccd_params->blk_clamp.sgain);
+		/*Start pixel */
+		ccd_params->blk_clamp.start_pixel
+		    = raw_params->blk_clamp.start_pixel;
+		dev_dbg(dev, "\nblk_clamp.start_pixel = %d",
+		       ccd_params->blk_clamp.start_pixel);
+		/*No of line to be avg */
+		ccd_params->blk_clamp.sample_ln
+		    = raw_params->blk_clamp.sample_ln;
+		dev_dbg(dev, "\nblk_clamp.sample_ln = %d",
+		       ccd_params->blk_clamp.sample_ln);
+		/*No of pixel/line to be avg */
+		ccd_params->blk_clamp.sample_pixel
+		    = raw_params->blk_clamp.sample_pixel;
+		dev_dbg(dev, "\nblk_clamp.sample_pixel  = %d",
+		       ccd_params->blk_clamp.sample_pixel);
+	} else {		/* configure DCSub */
+
+		ccd_params->blk_clamp.dc_sub = raw_params->blk_clamp.dc_sub;
+		dev_dbg(dev, "\nblk_clamp.dc_sub  = %d",
+		       ccd_params->blk_clamp.dc_sub);
+	}
+
+	/* copy BalckLevel Compansation configurations to
+	 * vpfe_device,from arg passed by application
+	 */
+	ccd_params->blk_comp.r_comp = raw_params->blk_comp.r_comp;
+	ccd_params->blk_comp.gr_comp = raw_params->blk_comp.gr_comp;
+	ccd_params->blk_comp.b_comp = raw_params->blk_comp.b_comp;
+	ccd_params->blk_comp.gb_comp = raw_params->blk_comp.gb_comp;
+	dev_dbg(dev, "\nblk_comp.r_comp   = %d",
+	       ccd_params->blk_comp.r_comp);
+	dev_dbg(dev, "\nblk_comp.gr_comp  = %d",
+	       ccd_params->blk_comp.gr_comp);
+	dev_dbg(dev, "\nblk_comp.b_comp   = %d",
+	       ccd_params->blk_comp.b_comp);
+	dev_dbg(dev, "\nblk_comp.gb_comp  = %d",
+	       ccd_params->blk_comp.gb_comp);
+
+	/* copy FPC configurations to vpfe_device,from
+	 * arg passed by application
+	 */
+	ccd_params->fault_pxl.fpc_enable = raw_params->fault_pxl.fpc_enable;
+	dev_dbg(dev, "\nfault_pxl.fpc_enable  = %d",
+	       ccd_params->fault_pxl.fpc_enable);
+
+	if (ccd_params->fault_pxl.fpc_enable) {
+		fpc_physaddr =
+		    (unsigned int *)ccd_params->fault_pxl.fpc_table_addr;
+
+		fpc_virtaddr = (unsigned int *)
+		    phys_to_virt((unsigned long)
+				 fpc_physaddr);
+
+		/* Allocate memory for FPC table if current
+		 * FPC table buffer is not big enough to
+		 * accomodate FPC Number requested
+		 */
+		if (raw_params->fault_pxl.fp_num !=
+		    ccd_params->fault_pxl.fp_num) {
+			if (fpc_physaddr != NULL) {
+				free_pages((unsigned long)
+					   fpc_physaddr,
+					   get_order
+					   (ccd_params->
+					    fault_pxl.fp_num * FP_NUM_BYTES));
+
+			}
+
+			/* Allocate memory for FPC table */
+			fpc_virtaddr = (unsigned int *)
+			    __get_free_pages(GFP_KERNEL |
+					     GFP_DMA,
+					     get_order
+					     (raw_params->
+					      fault_pxl.fp_num * FP_NUM_BYTES));
+
+			if (fpc_virtaddr == NULL) {
+				dev_err(dev,
+					"\nUnable to allocate memory for FPC");
+				return -1;
+			}
+			fpc_physaddr =
+			    (unsigned int *)virt_to_phys((void *)fpc_virtaddr);
+		}
+
+		/* Copy number of fault pixels and FPC table */
+		ccd_params->fault_pxl.fp_num = raw_params->fault_pxl.fp_num;
+		if (copy_from_user((void *)fpc_virtaddr,
+			       (void *)raw_params->
+			       fault_pxl.fpc_table_addr,
+			       (unsigned long)ccd_params->
+			       fault_pxl.fp_num * FP_NUM_BYTES)) {
+				dev_err(dev, "\n copy_from_user failed");
+				return -1;
+		}
+
+		ccd_params->fault_pxl.fpc_table_addr =
+		    (unsigned int)fpc_physaddr;
+	}
+	return 0;
+}
+
+static int ccdc_close(struct device *dev)
+{
+	unsigned int *fpc_physaddr = NULL, *fpc_virtaddr = NULL;
+	fpc_physaddr = (unsigned int *)
+	    ccdc_hw_params_raw.fault_pxl.fpc_table_addr;
+
+	if (fpc_physaddr != NULL) {
+		fpc_virtaddr = (unsigned int *)
+		    phys_to_virt((unsigned long)fpc_physaddr);
+		free_pages((unsigned long)fpc_virtaddr,
+			   get_order(ccdc_hw_params_raw.fault_pxl.
+				     fp_num * FP_NUM_BYTES));
+	}
+	return 0;
+}
+
+/*
+ * ======== ccdc_reset  ========
+ *
+ * This function will reset all CCDc reg
+ */
+static void ccdc_reset(void)
+{
+	int i;
+
+	/* disable CCDC */
+	ccdc_enable(0);
+	/* set all registers to default value */
+	for (i = 0; i <= 0x94; i += 4)
+		regw(0,  i);
+	regw(0, PCR);
+	regw(0, SYN_MODE);
+	regw(0, HD_VD_WID);
+	regw(0, PIX_LINES);
+	regw(0, HORZ_INFO);
+	regw(0, VERT_START);
+	regw(0, VERT_LINES);
+	regw(0xffff00ff, CULLING);
+	regw(0, HSIZE_OFF);
+	regw(0, SDOFST);
+	regw(0, SDR_ADDR);
+	regw(0, VDINT);
+	regw(0, REC656IF);
+	regw(0, CCDCFG);
+	regw(0, FMTCFG);
+	regw(0, VP_OUT);
+}
+
+static int ccdc_open(struct device *device)
+{
+	dev = device;
+	ccdc_reset();
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		ccdc_enable_vport(1);
+	return 0;
+}
+
+static void ccdc_sbl_reset(void)
+{
+	u32 sb_reset;
+	sb_reset = regr_sb(SBL_PCR_VPSS);
+	regw_sb((sb_reset & SBL_PCR_CCDC_WBL_O), SBL_PCR_VPSS);
+}
+
+/* Parameter operations */
+static int ccdc_setparams(void *params)
+{
+	int x;
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		x = copy_from_user(&ccdc_hw_params_raw_temp,
+				   (struct ccdc_config_params_raw *)params,
+				   sizeof(struct ccdc_config_params_raw));
+		if (x) {
+			dev_err(dev, "ccdc_setparams: error in copying"
+				   "ccdc params, %d\n", x);
+			return -EFAULT;
+		}
+
+		if (!validate_ccdc_param(&ccdc_hw_params_raw_temp)) {
+			if (!ccdc_update_raw_params(&ccdc_hw_params_raw_temp))
+				return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+/*
+ * ======== ccdc_config_ycbcr  ========
+ * This function will configure CCDC for YCbCr parameters
+ */
+void ccdc_config_ycbcr(void)
+{
+	u32 syn_mode;
+	struct ccdc_params_ycbcr *params = &ccdc_hw_params_ycbcr;
+
+	/* first reset the CCDC                                          */
+	/* all registers have default values after reset                 */
+	/* This is important since we assume default values to be set in */
+	/* a lot of registers that we didn't touch                       */
+	dev_dbg(dev, "\nStarting ccdc_config_ycbcr...");
+	ccdc_reset();
+
+	/* configure pixel format */
+	syn_mode = (params->pix_fmt & 0x3) << 12;
+
+	/* configure video frame format */
+	syn_mode |= (params->frm_fmt & 0x1) << 7;
+
+	/* setup BT.656 sync mode */
+	if (params->bt656_enable) {
+		regw(3, REC656IF);
+
+		/* configure the FID, VD, HD pin polarity */
+		/* fld,hd pol positive, vd negative, 8-bit pack mode */
+		syn_mode |= 0x00000F04;
+	} else {
+		/* y/c external sync mode */
+		syn_mode |= ((params->fid_pol & 0x1) << 4);
+		syn_mode |= ((params->hd_pol & 0x1) << 3);
+		syn_mode |= ((params->vd_pol & 0x1) << 2);
+	}
+
+	/* configure video window */
+	ccdc_setwin(&params->win, params->frm_fmt, 2);
+
+	/* configure the order of y cb cr in SD-RAM */
+	regw((params->pix_order << 11) | 0x8000, CCDCFG);
+
+	/* configure the horizontal line offset */
+	/* this is done by rounding up width to a multiple of 16 pixels */
+	/* and multiply by two to account for y:cb:cr 4:2:2 data */
+	regw(((params->win.width * 2) + 31) & 0xffffffe0, HSIZE_OFF);
+
+	/* configure the memory line offset */
+	if (params->buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED)
+		/* two fields are interleaved in memory */
+		regw(0x00000249, SDOFST);
+	/* enable output to SDRAM */
+	syn_mode |= (0x1 << 17);
+	/* enable internal timing generator */
+	syn_mode |= (0x1 << 16);
+
+	syn_mode |= CCDC_DATA_PACK_ENABLE;
+	regw(syn_mode, SYN_MODE);
+
+	ccdc_sbl_reset();
+	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
+	ccdc_readregs();
+}
+
+/*
+ * ======== ccdc_config_raw  ========
+ *
+ * This function will configure CCDC for Raw mode parameters
+ */
+void ccdc_config_raw(void)
+{
+	struct ccdc_params_raw *params = &ccdc_hw_params_raw;
+	unsigned int syn_mode = 0;
+	unsigned int val;
+	dev_dbg(dev, "\nStarting ccdc_config_raw...");
+	/*      Reset CCDC */
+	ccdc_reset();
+	/* Disable latching function registers on VSYNC  */
+	regw(CCDC_LATCH_ON_VSYNC_DISABLE, CCDCFG);
+
+	/*      Configure the vertical sync polarity(SYN_MODE.VDPOL) */
+	syn_mode = (params->vd_pol & CCDC_VD_POL_MASK) << CCDC_VD_POL_SHIFT;
+
+	/*      Configure the horizontal sync polarity (SYN_MODE.HDPOL) */
+	syn_mode |= (params->hd_pol & CCDC_HD_POL_MASK) << CCDC_HD_POL_SHIFT;
+
+	/*      Configure frame id polarity (SYN_MODE.FLDPOL) */
+	syn_mode |= (params->fid_pol & CCDC_FID_POL_MASK) << CCDC_FID_POL_SHIFT;
+
+	/* Configure frame format(progressive or interlace) */
+	syn_mode |= (params->frm_fmt & CCDC_FRM_FMT_MASK) << CCDC_FRM_FMT_SHIFT;
+
+	/* Configure the data size(SYNMODE.DATSIZ) */
+	syn_mode |= (params->data_sz & CCDC_DATA_SZ_MASK) << CCDC_DATA_SZ_SHIFT;
+
+	/* Configure pixel format (Input mode) */
+	syn_mode |= (params->pix_fmt & CCDC_PIX_FMT_MASK) << CCDC_PIX_FMT_SHIFT;
+
+	/* Configure VP2SDR bit of syn_mode = 0 */
+	syn_mode &= CCDC_VP2SDR_DISABLE;
+
+	/* Enable write enable bit */
+	syn_mode |= CCDC_WEN_ENABLE;
+
+	/* Disable output to resizer */
+	syn_mode &= CCDC_SDR2RSZ_DISABLE;
+
+	/* enable internal timing generator */
+	syn_mode |= CCDC_VDHDEN_ENABLE;
+
+	/* Enable and configure aLaw register if needed */
+	if (params->alaw.b_alaw_enable) {
+		val = (params->alaw.gama_wd & CCDC_ALAW_GAMA_WD_MASK);
+		/*set enable bit of alaw */
+		val |= CCDC_ALAW_ENABLE;
+		regw(val, ALAW);
+
+		dev_dbg(dev, "\nWriting 0x%x to ALAW...\n", val);
+	}
+
+	/* configure video window */
+	ccdc_setwin(&params->win, params->frm_fmt, PPC_RAW);
+
+	if (params->blk_clamp.b_clamp_enable) {
+		/*gain */
+		val = (params->blk_clamp.sgain) & CCDC_BLK_SGAIN_MASK;
+		/*Start pixel */
+		val |= (params->blk_clamp.start_pixel & CCDC_BLK_ST_PXL_MASK)
+		    << CCDC_BLK_ST_PXL_SHIFT;
+		/*No of line to be avg */
+		val |= (params->blk_clamp.sample_ln & CCDC_BLK_SAMPLE_LINE_MASK)
+		    << CCDC_BLK_SAMPLE_LINE_SHIFT;
+		/*No of pixel/line to be avg */
+		val |=
+		    (params->blk_clamp.sample_pixel & CCDC_BLK_SAMPLE_LN_MASK)
+		    << CCDC_BLK_SAMPLE_LN_SHIFT;
+		/*Enable the Black clamping */
+		val |= CCDC_BLK_CLAMP_ENABLE;
+		regw(val, CLAMP);
+
+		dev_dbg(dev, "\nWriting 0x%x to CLAMP...\n", val);
+		/*If Black clamping is enable then make dcsub 0 */
+		regw(DCSUB_DEFAULT_VAL, DCSUB);
+		dev_dbg(dev, "\nWriting 0x00000000 to DCSUB...\n");
+
+	} else {
+		/* configure DCSub */
+		val = (params->blk_clamp.dc_sub) & CCDC_BLK_DC_SUB_MASK;
+		regw(val, DCSUB);
+
+		dev_dbg(dev, "\nWriting 0x%x to DCSUB...\n", val);
+		regw(CLAMP_DEFAULT_VAL, CLAMP);
+
+		dev_dbg(dev, "\nWriting 0x0000 to CLAMP...\n");
+	}
+
+	/*      Configure Black level compensation */
+	val = (params->blk_comp.b_comp & CCDC_BLK_COMP_MASK);
+	val |= (params->blk_comp.gb_comp & CCDC_BLK_COMP_MASK)
+	    << CCDC_BLK_COMP_GB_COMP_SHIFT;
+	val |= (params->blk_comp.gr_comp & CCDC_BLK_COMP_MASK)
+	    << CCDC_BLK_COMP_GR_COMP_SHIFT;
+	val |= (params->blk_comp.r_comp & CCDC_BLK_COMP_MASK)
+	    << CCDC_BLK_COMP_R_COMP_SHIFT;
+
+	regw(val, BLKCMP);
+
+	dev_dbg(dev, "\nWriting 0x%x to BLKCMP...\n", val);
+	dev_dbg(dev, "\nbelow 	regw(val, BLKCMP)...");
+	/* Initially disable FPC */
+	val = CCDC_FPC_DISABLE;
+	regw(val, FPC);
+	/* Configure Fault pixel if needed */
+	if (params->fault_pxl.fpc_enable) {
+		regw(params->fault_pxl.fpc_table_addr, FPC_ADDR);
+
+		dev_dbg(dev, "\nWriting 0x%x to FPC_ADDR...\n",
+		       (params->fault_pxl.fpc_table_addr));
+		/* Write the FPC params with FPC disable */
+		val = params->fault_pxl.fp_num & CCDC_FPC_FPC_NUM_MASK;
+		regw(val, FPC);
+
+		dev_dbg(dev, "\nWriting 0x%x to FPC...\n", val);
+		/* read the FPC register */
+		val = regr(FPC);
+		val |= CCDC_FPC_ENABLE;
+		regw(val, FPC);
+
+		dev_dbg(dev, "\nWriting 0x%x to FPC...\n", val);
+	}
+	/* If data size is 8 bit then pack the data */
+	if ((params->data_sz == _8BITS) || params->alaw.b_alaw_enable)
+		syn_mode |= CCDC_DATA_PACK_ENABLE;
+#if VIDEO_PORT_ENABLE
+	/* enable video port */
+	val = ENABLE_VIDEO_PORT;
+#else
+	/* disable video port */
+	val = DISABLE_VIDEO_PORT;
+#endif
+
+	if (params->data_sz == _8BITS)
+		val |= (_10BITS & CCDC_FMTCFG_VPIN_MASK)
+		    << CCDC_FMTCFG_VPIN_SHIFT;
+	else
+		val |= (params->data_sz & CCDC_FMTCFG_VPIN_MASK)
+		    << CCDC_FMTCFG_VPIN_SHIFT;
+
+	/* Write value in FMTCFG */
+	regw(val, FMTCFG);
+
+	dev_dbg(dev, "\nWriting 0x%x to FMTCFG...\n", val);
+
+	/* Configure the color pattern according to mt9t001 sensor */
+	regw(CCDC_COLPTN_VAL, COLPTN);
+
+	dev_dbg(dev, "\nWriting 0xBB11BB11 to COLPTN...\n");
+	/* Configure Data formatter(Video port) pixel selection
+	 * (FMT_HORZ, FMT_VERT)
+	 */
+	val = 0;
+	val |= ((params->win.left) & CCDC_FMT_HORZ_FMTSPH_MASK)
+	    << CCDC_FMT_HORZ_FMTSPH_SHIFT;
+	val |= (((params->win.width)) & CCDC_FMT_HORZ_FMTLNH_MASK);
+	regw(val, FMT_HORZ);
+
+	dev_dbg(dev, "\nWriting 0x%x to FMT_HORZ...\n", val);
+	val = 0;
+	val |= (params->win.top & CCDC_FMT_VERT_FMTSLV_MASK)
+	    << CCDC_FMT_VERT_FMTSLV_SHIFT;
+	if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE)
+		val |= (params->win.height) & CCDC_FMT_VERT_FMTLNV_MASK;
+	else
+		val |= (params->win.height >> 1) & CCDC_FMT_VERT_FMTLNV_MASK;
+
+	dev_dbg(dev, "\nparams->win.height  0x%x ...\n",
+	       params->win.height);
+	regw(val, FMT_VERT);
+
+	dev_dbg(dev, "\nWriting 0x%x to FMT_VERT...\n", val);
+
+	dev_dbg(dev, "\nbelow regw(val, FMT_VERT)...");
+
+	/* Configure Horizontal offset register */
+	/* If pack 8 is enabled then 1 pixel will take 1 byte */
+	if ((params->data_sz == _8BITS) || params->alaw.b_alaw_enable)
+		regw(((params->win.width) + CCDC_32BYTE_ALIGN_VAL)
+		     & CCDC_HSIZE_OFF_MASK, HSIZE_OFF);
+
+	else
+		/* else one pixel will take 2 byte */
+		regw(((params->win.width * TWO_BYTES_PER_PIXEL)
+		      + CCDC_32BYTE_ALIGN_VAL)
+		     & CCDC_HSIZE_OFF_MASK, HSIZE_OFF);
+
+	/* Set value for SDOFST */
+	if (params->frm_fmt == CCDC_FRMFMT_INTERLACED) {
+		if (params->image_invert_enable) {
+			/* For intelace inverse mode */
+			regw(INTERLACED_IMAGE_INVERT, SDOFST);
+			dev_dbg(dev, "\nWriting 0x4B6D to SDOFST...\n");
+		}
+
+		else {
+			/* For intelace non inverse mode */
+			regw(INTERLACED_NO_IMAGE_INVERT, SDOFST);
+			dev_dbg(dev, "\nWriting 0x0249 to SDOFST...\n");
+		}
+	} else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
+		regw(PROGRESSIVE_NO_IMAGE_INVERT, SDOFST);
+		dev_dbg(dev, "\nWriting 0x0000 to SDOFST...\n");
+	}
+
+	/* Configure video port pixel selection (VPOUT) */
+	/* Here -1 is to make the height value less than FMT_VERT.FMTLNV */
+	if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE)
+		val = (((params->win.height - 1) & CCDC_VP_OUT_VERT_NUM_MASK))
+		    << CCDC_VP_OUT_VERT_NUM_SHIFT;
+	else
+		val =
+		    ((((params->win.
+			height >> CCDC_INTERLACED_HEIGHT_SHIFT) -
+		       1) & CCDC_VP_OUT_VERT_NUM_MASK))
+		    << CCDC_VP_OUT_VERT_NUM_SHIFT;
+
+	val |= ((((params->win.width))) & CCDC_VP_OUT_HORZ_NUM_MASK)
+	    << CCDC_VP_OUT_HORZ_NUM_SHIFT;
+	val |= (params->win.left) & CCDC_VP_OUT_HORZ_ST_MASK;
+	regw(val, VP_OUT);
+
+	dev_dbg(dev, "\nWriting 0x%x to VP_OUT...\n", val);
+	regw(syn_mode, SYN_MODE);
+	dev_dbg(dev, "\nWriting 0x%x to SYN_MODE...\n", syn_mode);
+
+	ccdc_sbl_reset();
+	dev_dbg(dev, "\nend of ccdc_config_raw...");
+	ccdc_readregs();
+}
+
+static int ccdc_configure(void)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		dev_info(dev, "calling ccdc_config_raw()\n");
+		ccdc_config_raw();
+	} else {
+		dev_info(dev, "calling ccdc_config_ycbcr()\n");
+		ccdc_config_ycbcr();
+	}
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
+static int ccdc_enum_pix(enum vpfe_hw_pix_format *hw_pix, int i)
+{
+	int ret = -EINVAL;
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		if (i < CCDC_MAX_RAW_BAYER_FORMATS) {
+			*hw_pix = ccdc_raw_bayer_hw_formats[i];
+			ret = 0;
+		}
+	} else {
+		if (i < CCDC_MAX_RAW_YUV_FORMATS) {
+			*hw_pix = ccdc_raw_yuv_hw_formats[i];
+			ret = 0;
+		}
+	}
+	return ret;
+}
+
+static int ccdc_set_pixel_format(enum vpfe_hw_pix_format pixfmt)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		ccdc_hw_params_raw.pix_fmt = CCDC_PIXFMT_RAW;
+		if (pixfmt == VPFE_BAYER_8BIT_PACK_ALAW)
+			ccdc_hw_params_raw.alaw.b_alaw_enable = 1;
+		else if (pixfmt != VPFE_BAYER)
+			return -1;
+	} else {
+		if (pixfmt == VPFE_YUYV)
+			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
+		else if (pixfmt == VPFE_UYVY)
+			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
+		else
+			return -1;
+	}
+	return 0;
+}
+
+static enum vpfe_hw_pix_format ccdc_get_pixel_format(void)
+{
+	enum vpfe_hw_pix_format pixfmt;
+
+	if (ccdc_if_type == VPFE_RAW_BAYER)
+		if (ccdc_hw_params_raw.alaw.b_alaw_enable)
+			pixfmt = VPFE_BAYER_8BIT_PACK_ALAW;
+		else
+			pixfmt = VPFE_BAYER;
+	else {
+		if (ccdc_hw_params_ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
+			pixfmt = VPFE_YUYV;
+		else
+			pixfmt = VPFE_UYVY;
+	}
+	return pixfmt;
+}
+
+static int ccdc_set_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		ccdc_hw_params_raw.win.top = win->top;
+		ccdc_hw_params_raw.win.left = win->left;
+		ccdc_hw_params_raw.win.width = win->width;
+		ccdc_hw_params_raw.win.height = win->height;
+	} else {
+		ccdc_hw_params_ycbcr.win.top = win->top;
+		ccdc_hw_params_ycbcr.win.left = win->left;
+		ccdc_hw_params_ycbcr.win.width = win->width;
+		ccdc_hw_params_ycbcr.win.height = win->height;
+	}
+	return 0;
+}
+
+static void ccdc_get_image_window(struct v4l2_rect *win)
+{
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		win->top = ccdc_hw_params_raw.win.top;
+		win->left = ccdc_hw_params_raw.win.left;
+		win->width = ccdc_hw_params_raw.win.width;
+		win->height = ccdc_hw_params_raw.win.height;
+	} else {
+		win->top = ccdc_hw_params_ycbcr.win.top;
+		win->left = ccdc_hw_params_ycbcr.win.left;
+		win->width = ccdc_hw_params_ycbcr.win.width;
+		win->height = ccdc_hw_params_ycbcr.win.height;
+	}
+}
+
+static unsigned int ccdc_get_line_length(void)
+{
+	unsigned int len;
+
+	if (ccdc_if_type == VPFE_RAW_BAYER) {
+		if ((ccdc_hw_params_raw.alaw.b_alaw_enable) ||
+		    (ccdc_hw_params_raw.data_sz == _8BITS))
+			len = ccdc_hw_params_raw.win.width;
+		else
+			len = ccdc_hw_params_raw.win.width * 2;
+	} else
+		len = ccdc_hw_params_ycbcr.win.width * 2;
+
+	len = ((len + 31) & ~0x1f);
+	return len;
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
+	int fid = (regr(SYN_MODE) >> 15) & 0x1;
+	return fid;
+}
+
+/* misc operations */
+static inline void ccdc_setfbaddr(unsigned long addr)
+{
+	regw(addr & 0xffffffe0, SDR_ADDR);
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
+		return -1;
+	}
+	return 0;
+}
+
+static struct ccdc_hw_device ccdc_hw_dev = {
+	.name = "DM6446 CCDC",
+	.owner = THIS_MODULE,
+	.open = ccdc_open,
+	.close = ccdc_close,
+	.hw_ops = {
+		.set_ccdc_base = ccdc_set_ccdc_base,
+		.set_vpss_base = ccdc_set_vpss_base,
+		.reset = ccdc_sbl_reset,
+		.enable = ccdc_enable,
+		.set_hw_if_params = ccdc_set_hw_if_params,
+		.setparams = ccdc_setparams,
+		.configure = ccdc_configure,
+		.set_buftype = ccdc_set_buftype,
+		.get_buftype = ccdc_get_buftype,
+		.enum_pix = ccdc_enum_pix,
+		.set_pixelformat = ccdc_set_pixel_format,
+		.get_pixelformat = ccdc_get_pixel_format,
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
index 0000000..b788457
--- /dev/null
+++ b/drivers/media/video/davinci/dm644x_ccdc_regs.h
@@ -0,0 +1,140 @@
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
+#define PID                             0x0
+#define PCR                             0x4
+#define SYN_MODE                        0x8
+#define HD_VD_WID                       0xc
+#define PIX_LINES                       0x10
+#define HORZ_INFO                       0x14
+#define VERT_START                      0x18
+#define VERT_LINES                      0x1c
+#define CULLING                         0x20
+#define HSIZE_OFF                       0x24
+#define SDOFST                          0x28
+#define SDR_ADDR                        0x2c
+#define CLAMP                           0x30
+#define DCSUB                           0x34
+#define COLPTN                          0x38
+#define BLKCMP                          0x3c
+#define FPC                             0x40
+#define FPC_ADDR                        0x44
+#define VDINT                           0x48
+#define ALAW                            0x4c
+#define REC656IF                        0x50
+#define CCDCFG                          0x54
+#define FMTCFG                          0x58
+#define FMT_HORZ                        0x5c
+#define FMT_VERT                        0x60
+#define FMT_ADDR0                       0x64
+#define FMT_ADDR1                       0x68
+#define FMT_ADDR2                       0x6c
+#define FMT_ADDR3                       0x70
+#define FMT_ADDR4                       0x74
+#define FMT_ADDR5                       0x78
+#define FMT_ADDR6                       0x7c
+#define FMT_ADDR7                       0x80
+#define PRGEVEN_0                       0x84
+#define PRGEVEN_1                       0x88
+#define PRGODD_0                        0x8c
+#define PRGODD_1                        0x90
+#define VP_OUT                          0x94
+
+
+/***************************************************************
+*	Define for various register bit mask and shifts for CCDC
+****************************************************************/
+#define CCDC_FID_POL_MASK			(0x01)
+#define CCDC_FID_POL_SHIFT			(4)
+#define CCDC_HD_POL_MASK			(0x01)
+#define CCDC_HD_POL_SHIFT			(3)
+#define CCDC_VD_POL_MASK			(0x01)
+#define CCDC_VD_POL_SHIFT			(2)
+#define CCDC_HSIZE_OFF_MASK			(0xffffffe0)
+#define CCDC_32BYTE_ALIGN_VAL			(31)
+#define CCDC_FRM_FMT_MASK			(0x01)
+#define CCDC_FRM_FMT_SHIFT			(7)
+#define CCDC_DATA_SZ_MASK			(0x07)
+#define CCDC_DATA_SZ_SHIFT			(8)
+#define CCDC_PIX_FMT_MASK			(0x03)
+#define CCDC_PIX_FMT_SHIFT			(12)
+#define CCDC_VP2SDR_DISABLE			(0xFFFBFFFF)
+#define CCDC_WEN_ENABLE				(0x01 << 17)
+#define CCDC_SDR2RSZ_DISABLE			(0xFFF7FFFF)
+#define CCDC_VDHDEN_ENABLE			(0x01 << 16)
+#define CCDC_LPF_ENABLE				(0x01 << 14)
+#define CCDC_ALAW_ENABLE			(0x01 << 3)
+#define CCDC_ALAW_GAMA_WD_MASK			(0x07)
+#define CCDC_BLK_CLAMP_ENABLE			(0x01 << 31)
+#define CCDC_BLK_SGAIN_MASK			(0x1F)
+#define CCDC_BLK_ST_PXL_MASK			(0x7FFF)
+#define CCDC_BLK_ST_PXL_SHIFT			(10)
+#define CCDC_BLK_SAMPLE_LN_MASK			(0x07)
+#define CCDC_BLK_SAMPLE_LN_SHIFT		(28)
+#define CCDC_BLK_SAMPLE_LINE_MASK		(0x07)
+#define CCDC_BLK_SAMPLE_LINE_SHIFT		(25)
+#define CCDC_BLK_DC_SUB_MASK			(0x03FFF)
+#define CCDC_BLK_COMP_MASK			(0x000000FF)
+#define CCDC_BLK_COMP_GB_COMP_SHIFT		(8)
+#define CCDC_BLK_COMP_GR_COMP_SHIFT		(16)
+#define CCDC_BLK_COMP_R_COMP_SHIFT		(24)
+#define CCDC_LATCH_ON_VSYNC_DISABLE		(0x01 << 15)
+#define CCDC_FPC_ENABLE				(0x01 << 15)
+#define CCDC_FPC_DISABLE			(0x0)
+#define CCDC_FPC_FPC_NUM_MASK 			(0x7FFF)
+#define CCDC_DATA_PACK_ENABLE			(0x01<<11)
+#define CCDC_FMTCFG_VPIN_MASK			(0x07)
+#define CCDC_FMTCFG_VPIN_SHIFT			(12)
+#define CCDC_FMT_HORZ_FMTLNH_MASK		(0x1FFF)
+#define CCDC_FMT_HORZ_FMTSPH_MASK		(0x1FFF)
+#define CCDC_FMT_HORZ_FMTSPH_SHIFT		(16)
+#define CCDC_FMT_VERT_FMTLNV_MASK		(0x1FFF)
+#define CCDC_FMT_VERT_FMTSLV_MASK		(0x1FFF)
+#define CCDC_FMT_VERT_FMTSLV_SHIFT		(16)
+#define CCDC_VP_OUT_VERT_NUM_MASK		(0x3FFF)
+#define CCDC_VP_OUT_VERT_NUM_SHIFT		(17)
+#define CCDC_VP_OUT_HORZ_NUM_MASK		(0x1FFF)
+#define CCDC_VP_OUT_HORZ_NUM_SHIFT		(4)
+#define CCDC_VP_OUT_HORZ_ST_MASK		(0x000F)
+#define CCDC_HORZ_INFO_SPH_SHIFT		(16)
+#define CCDC_VERT_START_SLV0_SHIFT		(16)
+#define CCDC_VDINT_VDINT0_SHIFT			(16)
+#define CCDC_VDINT_VDINT1_MASK			(0xFFFF)
+
+/* SBL register and mask defination */
+#define SBL_PCR_VPSS				(4)
+#define SBL_PCR_CCDC_WBL_O			(0xFF7FFFFF)
+
+#define PPC_RAW					(1)
+#define DCSUB_DEFAULT_VAL			(0)
+#define CLAMP_DEFAULT_VAL			(0)
+#define ENABLE_VIDEO_PORT			(0x00008000)
+#define DISABLE_VIDEO_PORT			(0)
+#define CCDC_COLPTN_VAL				(0xBB11BB11)
+#define TWO_BYTES_PER_PIXEL			(2)
+#define INTERLACED_IMAGE_INVERT			(0x4B6D)
+#define INTERLACED_NO_IMAGE_INVERT		(0x0249)
+#define PROGRESSIVE_IMAGE_INVERT		(0x4000)
+#define PROGRESSIVE_NO_IMAGE_INVERT		(0)
+#define CCDC_INTERLACED_HEIGHT_SHIFT		(1)
+#endif
diff --git a/include/media/davinci/dm644x_ccdc.h b/include/media/davinci/dm644x_ccdc.h
new file mode 100644
index 0000000..193091e
--- /dev/null
+++ b/include/media/davinci/dm644x_ccdc.h
@@ -0,0 +1,206 @@
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
+enum sample_length {
+	_1PIXELS = 0,
+	_2PIXELS,
+	_4PIXELS,
+	_8PIXELS,
+	_16PIXELS
+};
+
+/* Define to enable/disable video port */
+#define VIDEO_PORT_ENABLE	(1)
+#define FP_NUM_BYTES		(4)
+/* Define for extra pixel/line and extra lines/frame */
+#define NUM_EXTRAPIXELS		8
+#define NUM_EXTRALINES		8
+
+/* settings for commonly used video formats */
+#define CCDC_WIN_PAL     {0, 0, 720, 576}
+/* ntsc square pixel */
+#define CCDC_WIN_VGA	{0, 0, (640 + NUM_EXTRAPIXELS), (480 + NUM_EXTRALINES)}
+
+/* enum for No of lines in Black Clamping */
+enum sample_line {
+	_1LINES = 0,
+	_2LINES,
+	_4LINES,
+	_8LINES,
+	_16LINES
+};
+
+/* enum for Alaw gama width */
+enum gama_width {
+	BITS_15_6 = 0,
+	BITS_14_5,
+	BITS_13_4,
+	BITS_12_3,
+	BITS_11_2,
+	BITS_10_1,
+	BITS_09_0
+};
+
+enum data_size {
+	_16BITS = 0,
+	_15BITS,
+	_14BITS,
+	_13BITS,
+	_12BITS,
+	_11BITS,
+	_10BITS,
+	_8BITS
+};
+
+/* structure for ALaw */
+struct a_law {
+	/* Enable/disable A-Law */
+	unsigned char b_alaw_enable;
+	/* Gama Width Input */
+	enum gama_width gama_wd;
+};
+
+/* structure for Black Clamping */
+struct black_clamp {
+	unsigned char b_clamp_enable;
+	/* only if bClampEnable is TRUE */
+	enum sample_length sample_pixel;
+	/* only if bClampEnable is TRUE */
+	enum sample_line sample_ln;
+	/* only if bClampEnable is TRUE */
+	unsigned short start_pixel;
+	/* only if bClampEnable is TRUE */
+	unsigned short sgain;
+	/* only if bClampEnable is FALSE */
+	unsigned short dc_sub;
+};
+
+/* structure for Black Level Compensation */
+struct black_compensation {
+	/* Constant value to subtract from Red component */
+	char r_comp;
+	/* Constant value to subtract from Gr component */
+	char gr_comp;
+	/* Constant value to subtract from Blue component */
+	char b_comp;
+	/* Constant value to subtract from Gb component */
+	char gb_comp;
+};
+
+/* structure for fault pixel correction */
+struct fault_pixel {
+	/* Enable or Disable fault pixel correction */
+	unsigned char fpc_enable;
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
+	/*
+	 * enable to store the image in inverse order in
+	 * memory(bottom to top)
+	 */
+	unsigned char image_invert_enable;
+	/* data size value from 8 to 16 bits */
+	enum data_size data_sz;
+	/* Structure for Optional A-Law */
+	struct a_law alaw;
+	/* Structure for Optical Black Clamp */
+	struct black_clamp blk_clamp;
+	/* Structure for Black Compensation */
+	struct black_compensation blk_comp;
+	/* Structure for Fault Pixel Module Configuration */
+	struct fault_pixel fault_pxl;
+};
+
+
+#ifdef __KERNEL__
+#include <linux/io.h>
+
+struct ccdc_imgwin {
+	unsigned int top;
+	unsigned int left;
+	unsigned int width;
+	unsigned int height;
+};
+
+/* Structure for CCDC configuration parameters for raw capture mode */
+struct ccdc_params_raw {
+	/* pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* progressive or interlaced frame */
+	enum ccdc_frmfmt frm_fmt;
+	/* video window */
+	struct ccdc_imgwin win;
+	/* field id polarity */
+	enum vpfe_pin_pol fid_pol;
+	/* vertical sync polarity */
+	enum vpfe_pin_pol vd_pol;
+	/* horizontal sync polarity */
+	enum vpfe_pin_pol hd_pol;
+	/* interleaved or separated fields */
+	enum ccdc_buftype buf_type;
+	/* enable to store the image in inverse
+	 * order in memory(bottom to top)
+	 */
+	unsigned char image_invert_enable;
+	/* data size value from 8 to 16 bits */
+	enum data_size data_sz;
+	/* Structure for Optional A-Law */
+	struct a_law alaw;
+	/* Structure for Optical Black Clamp */
+	struct black_clamp blk_clamp;
+	/* Structure for Black Compensation */
+	struct black_compensation blk_comp;
+	/* Structure for Fault Pixel Module Configuration */
+	struct fault_pixel fault_pxl;
+};
+
+struct ccdc_params_ycbcr {
+	/* pixel format */
+	enum ccdc_pixfmt pix_fmt;
+	/* progressive or interlaced frame */
+	enum ccdc_frmfmt frm_fmt;
+	/* video window */
+	struct ccdc_imgwin win;
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
+
+#endif
+#endif				/* _DM644X_CCDC_H */
-- 
1.6.0.4

