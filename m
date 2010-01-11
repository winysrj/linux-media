Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57794 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0AKTXJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 14:23:09 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, khilman@deeprootsystems.com,
	mchehab@infradead.org
Cc: hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v4 3/4] V4L-vpfe-capture-converting-dm644x-driver to a platform driver
Date: Mon, 11 Jan 2010 14:22:57 -0500
Message-Id: <1263237778-22361-3-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1263237778-22361-2-git-send-email-m-karicheri2@ti.com>
References: <1263237778-22361-1-git-send-email-m-karicheri2@ti.com>
 <1263237778-22361-2-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Rebased to latest linux-next tree

Updated based on Kevin's comments on clock configuration.
The ccdc now uses a generic name for clocks. master and slave. On individual platforms
these clocks will inherit from the platform specific clock. This will allow re-use of
the driver for the same IP across different SoCs.

Following are the changes done:-
	1) clocks are configured using generic clock names
	2) converting the driver to a platform driver
	3) cleanup - consolidate all static variables inside a structure, ccdc_cfg

Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-next tree of v4l-dvb
 drivers/media/video/davinci/dm644x_ccdc.c |  360 ++++++++++++++++++-----------
 1 files changed, 224 insertions(+), 136 deletions(-)

diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index d5fa193..7e35269 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -37,8 +37,11 @@
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 #include <linux/videodev2.h>
+#include <linux/clk.h>
+
 #include <media/davinci/dm644x_ccdc.h>
 #include <media/davinci/vpss.h>
+
 #include "dm644x_ccdc_regs.h"
 #include "ccdc_hw_device.h"
 
@@ -46,32 +49,44 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CCDC Driver for DM6446");
 MODULE_AUTHOR("Texas Instruments");
 
-static struct device *dev;
-
-/* Object for CCDC raw mode */
-static struct ccdc_params_raw ccdc_hw_params_raw = {
-	.pix_fmt = CCDC_PIXFMT_RAW,
-	.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
-	.win = CCDC_WIN_VGA,
-	.fid_pol = VPFE_PINPOL_POSITIVE,
-	.vd_pol = VPFE_PINPOL_POSITIVE,
-	.hd_pol = VPFE_PINPOL_POSITIVE,
-	.config_params = {
-		.data_sz = CCDC_DATA_10BITS,
+static struct ccdc_oper_config {
+	struct device *dev;
+	/* CCDC interface type */
+	enum vpfe_hw_if_type if_type;
+	/* Raw Bayer configuration */
+	struct ccdc_params_raw bayer;
+	/* YCbCr configuration */
+	struct ccdc_params_ycbcr ycbcr;
+	/* Master clock */
+	struct clk *mclk;
+	/* slave clock */
+	struct clk *sclk;
+	/* ccdc base address */
+	void __iomem *base_addr;
+} ccdc_cfg = {
+	/* Raw configurations */
+	.bayer = {
+		.pix_fmt = CCDC_PIXFMT_RAW,
+		.frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
+		.win = CCDC_WIN_VGA,
+		.fid_pol = VPFE_PINPOL_POSITIVE,
+		.vd_pol = VPFE_PINPOL_POSITIVE,
+		.hd_pol = VPFE_PINPOL_POSITIVE,
+		.config_params = {
+			.data_sz = CCDC_DATA_10BITS,
+		},
+	},
+	.ycbcr = {
+		.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
+		.frm_fmt = CCDC_FRMFMT_INTERLACED,
+		.win = CCDC_WIN_PAL,
+		.fid_pol = VPFE_PINPOL_POSITIVE,
+		.vd_pol = VPFE_PINPOL_POSITIVE,
+		.hd_pol = VPFE_PINPOL_POSITIVE,
+		.bt656_enable = 1,
+		.pix_order = CCDC_PIXORDER_CBYCRY,
+		.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
 	},
-};
-
-/* Object for CCDC ycbcr mode */
-static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
-	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
-	.frm_fmt = CCDC_FRMFMT_INTERLACED,
-	.win = CCDC_WIN_PAL,
-	.fid_pol = VPFE_PINPOL_POSITIVE,
-	.vd_pol = VPFE_PINPOL_POSITIVE,
-	.hd_pol = VPFE_PINPOL_POSITIVE,
-	.bt656_enable = 1,
-	.pix_order = CCDC_PIXORDER_CBYCRY,
-	.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED
 };
 
 #define CCDC_MAX_RAW_YUV_FORMATS	2
@@ -84,25 +99,15 @@ static u32 ccdc_raw_bayer_pix_formats[] =
 static u32 ccdc_raw_yuv_pix_formats[] =
 	{V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YUYV};
 
-static void *__iomem ccdc_base_addr;
-static int ccdc_addr_size;
-static enum vpfe_hw_if_type ccdc_if_type;
-
 /* register access routines */
 static inline u32 regr(u32 offset)
 {
-	return __raw_readl(ccdc_base_addr + offset);
+	return __raw_readl(ccdc_cfg.base_addr + offset);
 }
 
 static inline void regw(u32 val, u32 offset)
 {
-	__raw_writel(val, ccdc_base_addr + offset);
-}
-
-static void ccdc_set_ccdc_base(void *addr, int size)
-{
-	ccdc_base_addr = addr;
-	ccdc_addr_size = size;
+	__raw_writel(val, ccdc_cfg.base_addr + offset);
 }
 
 static void ccdc_enable(int flag)
@@ -132,7 +137,7 @@ void ccdc_setwin(struct v4l2_rect *image_win,
 	int vert_start, vert_nr_lines;
 	int val = 0, mid_img = 0;
 
-	dev_dbg(dev, "\nStarting ccdc_setwin...");
+	dev_dbg(ccdc_cfg.dev, "\nStarting ccdc_setwin...");
 	/*
 	 * ppc - per pixel count. indicates how many pixels per cell
 	 * output to SDRAM. example, for ycbcr, it is one y and one c, so 2.
@@ -171,7 +176,7 @@ void ccdc_setwin(struct v4l2_rect *image_win,
 	regw((vert_start << CCDC_VERT_START_SLV0_SHIFT) | vert_start,
 	     CCDC_VERT_START);
 	regw(vert_nr_lines, CCDC_VERT_LINES);
-	dev_dbg(dev, "\nEnd of ccdc_setwin...");
+	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_setwin...");
 }
 
 static void ccdc_readregs(void)
@@ -179,39 +184,39 @@ static void ccdc_readregs(void)
 	unsigned int val = 0;
 
 	val = regr(CCDC_ALAW);
-	dev_notice(dev, "\nReading 0x%x to ALAW...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to ALAW...\n", val);
 	val = regr(CCDC_CLAMP);
-	dev_notice(dev, "\nReading 0x%x to CLAMP...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to CLAMP...\n", val);
 	val = regr(CCDC_DCSUB);
-	dev_notice(dev, "\nReading 0x%x to DCSUB...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to DCSUB...\n", val);
 	val = regr(CCDC_BLKCMP);
-	dev_notice(dev, "\nReading 0x%x to BLKCMP...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to BLKCMP...\n", val);
 	val = regr(CCDC_FPC_ADDR);
-	dev_notice(dev, "\nReading 0x%x to FPC_ADDR...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to FPC_ADDR...\n", val);
 	val = regr(CCDC_FPC);
-	dev_notice(dev, "\nReading 0x%x to FPC...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to FPC...\n", val);
 	val = regr(CCDC_FMTCFG);
-	dev_notice(dev, "\nReading 0x%x to FMTCFG...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to FMTCFG...\n", val);
 	val = regr(CCDC_COLPTN);
-	dev_notice(dev, "\nReading 0x%x to COLPTN...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to COLPTN...\n", val);
 	val = regr(CCDC_FMT_HORZ);
-	dev_notice(dev, "\nReading 0x%x to FMT_HORZ...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to FMT_HORZ...\n", val);
 	val = regr(CCDC_FMT_VERT);
-	dev_notice(dev, "\nReading 0x%x to FMT_VERT...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to FMT_VERT...\n", val);
 	val = regr(CCDC_HSIZE_OFF);
-	dev_notice(dev, "\nReading 0x%x to HSIZE_OFF...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to HSIZE_OFF...\n", val);
 	val = regr(CCDC_SDOFST);
-	dev_notice(dev, "\nReading 0x%x to SDOFST...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to SDOFST...\n", val);
 	val = regr(CCDC_VP_OUT);
-	dev_notice(dev, "\nReading 0x%x to VP_OUT...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to VP_OUT...\n", val);
 	val = regr(CCDC_SYN_MODE);
-	dev_notice(dev, "\nReading 0x%x to SYN_MODE...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to SYN_MODE...\n", val);
 	val = regr(CCDC_HORZ_INFO);
-	dev_notice(dev, "\nReading 0x%x to HORZ_INFO...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to HORZ_INFO...\n", val);
 	val = regr(CCDC_VERT_START);
-	dev_notice(dev, "\nReading 0x%x to VERT_START...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to VERT_START...\n", val);
 	val = regr(CCDC_VERT_LINES);
-	dev_notice(dev, "\nReading 0x%x to VERT_LINES...\n", val);
+	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to VERT_LINES...\n", val);
 }
 
 static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
@@ -220,7 +225,7 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 		if ((ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) ||
 		    (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_15_6) ||
 		    (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
-			dev_dbg(dev, "\nInvalid data line select");
+			dev_dbg(ccdc_cfg.dev, "\nInvalid data line select");
 			return -1;
 		}
 	}
@@ -230,7 +235,7 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 {
 	struct ccdc_config_params_raw *config_params =
-		&ccdc_hw_params_raw.config_params;
+				&ccdc_cfg.bayer.config_params;
 	unsigned int *fpc_virtaddr = NULL;
 	unsigned int *fpc_physaddr = NULL;
 
@@ -266,7 +271,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 							 FP_NUM_BYTES));
 
 		if (fpc_virtaddr == NULL) {
-			dev_dbg(dev,
+			dev_dbg(ccdc_cfg.dev,
 				"\nUnable to allocate memory for FPC");
 			return -EFAULT;
 		}
@@ -279,7 +284,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 	if (copy_from_user(fpc_virtaddr,
 			(void __user *)raw_params->fault_pxl.fpc_table_addr,
 			config_params->fault_pxl.fp_num * FP_NUM_BYTES)) {
-		dev_dbg(dev, "\n copy_from_user failed");
+		dev_dbg(ccdc_cfg.dev, "\n copy_from_user failed");
 		return -EFAULT;
 	}
 	config_params->fault_pxl.fpc_table_addr = (unsigned int)fpc_physaddr;
@@ -289,7 +294,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 static int ccdc_close(struct device *dev)
 {
 	struct ccdc_config_params_raw *config_params =
-		&ccdc_hw_params_raw.config_params;
+				&ccdc_cfg.bayer.config_params;
 	unsigned int *fpc_physaddr = NULL, *fpc_virtaddr = NULL;
 
 	fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
@@ -323,9 +328,8 @@ static void ccdc_restore_defaults(void)
 
 static int ccdc_open(struct device *device)
 {
-	dev = device;
 	ccdc_restore_defaults();
-	if (ccdc_if_type == VPFE_RAW_BAYER)
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
 		ccdc_enable_vport(1);
 	return 0;
 }
@@ -341,12 +345,12 @@ static int ccdc_set_params(void __user *params)
 	struct ccdc_config_params_raw ccdc_raw_params;
 	int x;
 
-	if (ccdc_if_type != VPFE_RAW_BAYER)
+	if (ccdc_cfg.if_type != VPFE_RAW_BAYER)
 		return -EINVAL;
 
 	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
 	if (x) {
-		dev_dbg(dev, "ccdc_set_params: error in copying"
+		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copying"
 			   "ccdc params, %d\n", x);
 		return -EFAULT;
 	}
@@ -364,10 +368,10 @@ static int ccdc_set_params(void __user *params)
  */
 void ccdc_config_ycbcr(void)
 {
-	struct ccdc_params_ycbcr *params = &ccdc_hw_params_ycbcr;
+	struct ccdc_params_ycbcr *params = &ccdc_cfg.ycbcr;
 	u32 syn_mode;
 
-	dev_dbg(dev, "\nStarting ccdc_config_ycbcr...");
+	dev_dbg(ccdc_cfg.dev, "\nStarting ccdc_config_ycbcr...");
 	/*
 	 * first restore the CCDC registers to default values
 	 * This is important since we assume default values to be set in
@@ -428,7 +432,7 @@ void ccdc_config_ycbcr(void)
 		regw(CCDC_SDOFST_FIELD_INTERLEAVED, CCDC_SDOFST);
 
 	ccdc_sbl_reset();
-	dev_dbg(dev, "\nEnd of ccdc_config_ycbcr...\n");
+	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_config_ycbcr...\n");
 	ccdc_readregs();
 }
 
@@ -440,9 +444,9 @@ static void ccdc_config_black_clamp(struct ccdc_black_clamp *bclamp)
 		/* configure DCSub */
 		val = (bclamp->dc_sub) & CCDC_BLK_DC_SUB_MASK;
 		regw(val, CCDC_DCSUB);
-		dev_dbg(dev, "\nWriting 0x%x to DCSUB...\n", val);
+		dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to DCSUB...\n", val);
 		regw(CCDC_CLAMP_DEFAULT_VAL, CCDC_CLAMP);
-		dev_dbg(dev, "\nWriting 0x0000 to CLAMP...\n");
+		dev_dbg(ccdc_cfg.dev, "\nWriting 0x0000 to CLAMP...\n");
 		return;
 	}
 	/*
@@ -457,10 +461,10 @@ static void ccdc_config_black_clamp(struct ccdc_black_clamp *bclamp)
 	       ((bclamp->sample_pixel & CCDC_BLK_SAMPLE_LN_MASK) <<
 		CCDC_BLK_SAMPLE_LN_SHIFT) | CCDC_BLK_CLAMP_ENABLE);
 	regw(val, CCDC_CLAMP);
-	dev_dbg(dev, "\nWriting 0x%x to CLAMP...\n", val);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to CLAMP...\n", val);
 	/* If Black clamping is enable then make dcsub 0 */
 	regw(CCDC_DCSUB_DEFAULT_VAL, CCDC_DCSUB);
-	dev_dbg(dev, "\nWriting 0x00000000 to DCSUB...\n");
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x00000000 to DCSUB...\n");
 }
 
 static void ccdc_config_black_compense(struct ccdc_black_compensation *bcomp)
@@ -490,17 +494,17 @@ static void ccdc_config_fpc(struct ccdc_fault_pixel *fpc)
 
 	/* Configure Fault pixel if needed */
 	regw(fpc->fpc_table_addr, CCDC_FPC_ADDR);
-	dev_dbg(dev, "\nWriting 0x%x to FPC_ADDR...\n",
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FPC_ADDR...\n",
 		       (fpc->fpc_table_addr));
 	/* Write the FPC params with FPC disable */
 	val = fpc->fp_num & CCDC_FPC_FPC_NUM_MASK;
 	regw(val, CCDC_FPC);
 
-	dev_dbg(dev, "\nWriting 0x%x to FPC...\n", val);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FPC...\n", val);
 	/* read the FPC register */
 	val = regr(CCDC_FPC) | CCDC_FPC_ENABLE;
 	regw(val, CCDC_FPC);
-	dev_dbg(dev, "\nWriting 0x%x to FPC...\n", val);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FPC...\n", val);
 }
 
 /*
@@ -509,13 +513,13 @@ static void ccdc_config_fpc(struct ccdc_fault_pixel *fpc)
  */
 void ccdc_config_raw(void)
 {
-	struct ccdc_params_raw *params = &ccdc_hw_params_raw;
+	struct ccdc_params_raw *params = &ccdc_cfg.bayer;
 	struct ccdc_config_params_raw *config_params =
-		&ccdc_hw_params_raw.config_params;
+				&ccdc_cfg.bayer.config_params;
 	unsigned int syn_mode = 0;
 	unsigned int val;
 
-	dev_dbg(dev, "\nStarting ccdc_config_raw...");
+	dev_dbg(ccdc_cfg.dev, "\nStarting ccdc_config_raw...");
 
 	/*      Reset CCDC */
 	ccdc_restore_defaults();
@@ -545,7 +549,7 @@ void ccdc_config_raw(void)
 		val = ((config_params->alaw.gama_wd &
 		      CCDC_ALAW_GAMA_WD_MASK) | CCDC_ALAW_ENABLE);
 		regw(val, CCDC_ALAW);
-		dev_dbg(dev, "\nWriting 0x%x to ALAW...\n", val);
+		dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to ALAW...\n", val);
 	}
 
 	/* Configure video window */
@@ -582,11 +586,11 @@ void ccdc_config_raw(void)
 	/* Write value in FMTCFG */
 	regw(val, CCDC_FMTCFG);
 
-	dev_dbg(dev, "\nWriting 0x%x to FMTCFG...\n", val);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FMTCFG...\n", val);
 	/* Configure the color pattern according to mt9t001 sensor */
 	regw(CCDC_COLPTN_VAL, CCDC_COLPTN);
 
-	dev_dbg(dev, "\nWriting 0xBB11BB11 to COLPTN...\n");
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0xBB11BB11 to COLPTN...\n");
 	/*
 	 * Configure Data formatter(Video port) pixel selection
 	 * (FMT_HORZ, FMT_VERT)
@@ -596,7 +600,7 @@ void ccdc_config_raw(void)
 	      (params->win.width & CCDC_FMT_HORZ_FMTLNH_MASK);
 	regw(val, CCDC_FMT_HORZ);
 
-	dev_dbg(dev, "\nWriting 0x%x to FMT_HORZ...\n", val);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FMT_HORZ...\n", val);
 	val = (params->win.top & CCDC_FMT_VERT_FMTSLV_MASK)
 	    << CCDC_FMT_VERT_FMTSLV_SHIFT;
 	if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE)
@@ -604,13 +608,13 @@ void ccdc_config_raw(void)
 	else
 		val |= (params->win.height >> 1) & CCDC_FMT_VERT_FMTLNV_MASK;
 
-	dev_dbg(dev, "\nparams->win.height  0x%x ...\n",
+	dev_dbg(ccdc_cfg.dev, "\nparams->win.height  0x%x ...\n",
 	       params->win.height);
 	regw(val, CCDC_FMT_VERT);
 
-	dev_dbg(dev, "\nWriting 0x%x to FMT_VERT...\n", val);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FMT_VERT...\n", val);
 
-	dev_dbg(dev, "\nbelow regw(val, FMT_VERT)...");
+	dev_dbg(ccdc_cfg.dev, "\nbelow regw(val, FMT_VERT)...");
 
 	/*
 	 * Configure Horizontal offset register. If pack 8 is enabled then
@@ -631,17 +635,17 @@ void ccdc_config_raw(void)
 		if (params->image_invert_enable) {
 			/* For intelace inverse mode */
 			regw(CCDC_INTERLACED_IMAGE_INVERT, CCDC_SDOFST);
-			dev_dbg(dev, "\nWriting 0x4B6D to SDOFST...\n");
+			dev_dbg(ccdc_cfg.dev, "\nWriting 0x4B6D to SDOFST..\n");
 		}
 
 		else {
 			/* For intelace non inverse mode */
 			regw(CCDC_INTERLACED_NO_IMAGE_INVERT, CCDC_SDOFST);
-			dev_dbg(dev, "\nWriting 0x0249 to SDOFST...\n");
+			dev_dbg(ccdc_cfg.dev, "\nWriting 0x0249 to SDOFST..\n");
 		}
 	} else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
 		regw(CCDC_PROGRESSIVE_NO_IMAGE_INVERT, CCDC_SDOFST);
-		dev_dbg(dev, "\nWriting 0x0000 to SDOFST...\n");
+		dev_dbg(ccdc_cfg.dev, "\nWriting 0x0000 to SDOFST...\n");
 	}
 
 	/*
@@ -662,18 +666,18 @@ void ccdc_config_raw(void)
 	val |= (params->win.left) & CCDC_VP_OUT_HORZ_ST_MASK;
 	regw(val, CCDC_VP_OUT);
 
-	dev_dbg(dev, "\nWriting 0x%x to VP_OUT...\n", val);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to VP_OUT...\n", val);
 	regw(syn_mode, CCDC_SYN_MODE);
-	dev_dbg(dev, "\nWriting 0x%x to SYN_MODE...\n", syn_mode);
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to SYN_MODE...\n", syn_mode);
 
 	ccdc_sbl_reset();
-	dev_dbg(dev, "\nend of ccdc_config_raw...");
+	dev_dbg(ccdc_cfg.dev, "\nend of ccdc_config_raw...");
 	ccdc_readregs();
 }
 
 static int ccdc_configure(void)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER)
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
 		ccdc_config_raw();
 	else
 		ccdc_config_ycbcr();
@@ -682,24 +686,24 @@ static int ccdc_configure(void)
 
 static int ccdc_set_buftype(enum ccdc_buftype buf_type)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER)
-		ccdc_hw_params_raw.buf_type = buf_type;
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
+		ccdc_cfg.bayer.buf_type = buf_type;
 	else
-		ccdc_hw_params_ycbcr.buf_type = buf_type;
+		ccdc_cfg.ycbcr.buf_type = buf_type;
 	return 0;
 }
 
 static enum ccdc_buftype ccdc_get_buftype(void)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER)
-		return ccdc_hw_params_raw.buf_type;
-	return ccdc_hw_params_ycbcr.buf_type;
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
+		return ccdc_cfg.bayer.buf_type;
+	return ccdc_cfg.ycbcr.buf_type;
 }
 
 static int ccdc_enum_pix(u32 *pix, int i)
 {
 	int ret = -EINVAL;
-	if (ccdc_if_type == VPFE_RAW_BAYER) {
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER) {
 		if (i < ARRAY_SIZE(ccdc_raw_bayer_pix_formats)) {
 			*pix = ccdc_raw_bayer_pix_formats[i];
 			ret = 0;
@@ -715,17 +719,17 @@ static int ccdc_enum_pix(u32 *pix, int i)
 
 static int ccdc_set_pixel_format(u32 pixfmt)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER) {
-		ccdc_hw_params_raw.pix_fmt = CCDC_PIXFMT_RAW;
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER) {
+		ccdc_cfg.bayer.pix_fmt = CCDC_PIXFMT_RAW;
 		if (pixfmt == V4L2_PIX_FMT_SBGGR8)
-			ccdc_hw_params_raw.config_params.alaw.enable = 1;
+			ccdc_cfg.bayer.config_params.alaw.enable = 1;
 		else if (pixfmt != V4L2_PIX_FMT_SBGGR16)
 			return -EINVAL;
 	} else {
 		if (pixfmt == V4L2_PIX_FMT_YUYV)
-			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
+			ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
 		else if (pixfmt == V4L2_PIX_FMT_UYVY)
-			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
+			ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
 		else
 			return -EINVAL;
 	}
@@ -734,17 +738,16 @@ static int ccdc_set_pixel_format(u32 pixfmt)
 
 static u32 ccdc_get_pixel_format(void)
 {
-	struct ccdc_a_law *alaw =
-		&ccdc_hw_params_raw.config_params.alaw;
+	struct ccdc_a_law *alaw = &ccdc_cfg.bayer.config_params.alaw;
 	u32 pixfmt;
 
-	if (ccdc_if_type == VPFE_RAW_BAYER)
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
 		if (alaw->enable)
 			pixfmt = V4L2_PIX_FMT_SBGGR8;
 		else
 			pixfmt = V4L2_PIX_FMT_SBGGR16;
 	else {
-		if (ccdc_hw_params_ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
+		if (ccdc_cfg.ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
 			pixfmt = V4L2_PIX_FMT_YUYV;
 		else
 			pixfmt = V4L2_PIX_FMT_UYVY;
@@ -754,53 +757,53 @@ static u32 ccdc_get_pixel_format(void)
 
 static int ccdc_set_image_window(struct v4l2_rect *win)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER)
-		ccdc_hw_params_raw.win = *win;
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
+		ccdc_cfg.bayer.win = *win;
 	else
-		ccdc_hw_params_ycbcr.win = *win;
+		ccdc_cfg.ycbcr.win = *win;
 	return 0;
 }
 
 static void ccdc_get_image_window(struct v4l2_rect *win)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER)
-		*win = ccdc_hw_params_raw.win;
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
+		*win = ccdc_cfg.bayer.win;
 	else
-		*win = ccdc_hw_params_ycbcr.win;
+		*win = ccdc_cfg.ycbcr.win;
 }
 
 static unsigned int ccdc_get_line_length(void)
 {
 	struct ccdc_config_params_raw *config_params =
-		&ccdc_hw_params_raw.config_params;
+				&ccdc_cfg.bayer.config_params;
 	unsigned int len;
 
-	if (ccdc_if_type == VPFE_RAW_BAYER) {
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER) {
 		if ((config_params->alaw.enable) ||
 		    (config_params->data_sz == CCDC_DATA_8BITS))
-			len = ccdc_hw_params_raw.win.width;
+			len = ccdc_cfg.bayer.win.width;
 		else
-			len = ccdc_hw_params_raw.win.width * 2;
+			len = ccdc_cfg.bayer.win.width * 2;
 	} else
-		len = ccdc_hw_params_ycbcr.win.width * 2;
+		len = ccdc_cfg.ycbcr.win.width * 2;
 	return ALIGN(len, 32);
 }
 
 static int ccdc_set_frame_format(enum ccdc_frmfmt frm_fmt)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER)
-		ccdc_hw_params_raw.frm_fmt = frm_fmt;
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
+		ccdc_cfg.bayer.frm_fmt = frm_fmt;
 	else
-		ccdc_hw_params_ycbcr.frm_fmt = frm_fmt;
+		ccdc_cfg.ycbcr.frm_fmt = frm_fmt;
 	return 0;
 }
 
 static enum ccdc_frmfmt ccdc_get_frame_format(void)
 {
-	if (ccdc_if_type == VPFE_RAW_BAYER)
-		return ccdc_hw_params_raw.frm_fmt;
+	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
+		return ccdc_cfg.bayer.frm_fmt;
 	else
-		return ccdc_hw_params_ycbcr.frm_fmt;
+		return ccdc_cfg.ycbcr.frm_fmt;
 }
 
 static int ccdc_getfid(void)
@@ -816,14 +819,14 @@ static inline void ccdc_setfbaddr(unsigned long addr)
 
 static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
 {
-	ccdc_if_type = params->if_type;
+	ccdc_cfg.if_type = params->if_type;
 
 	switch (params->if_type) {
 	case VPFE_BT656:
 	case VPFE_YCBCR_SYNC_16:
 	case VPFE_YCBCR_SYNC_8:
-		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
-		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
+		ccdc_cfg.ycbcr.vd_pol = params->vdpol;
+		ccdc_cfg.ycbcr.hd_pol = params->hdpol;
 		break;
 	default:
 		/* TODO add support for raw bayer here */
@@ -838,7 +841,6 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	.hw_ops = {
 		.open = ccdc_open,
 		.close = ccdc_close,
-		.set_ccdc_base = ccdc_set_ccdc_base,
 		.reset = ccdc_sbl_reset,
 		.enable = ccdc_enable,
 		.set_hw_if_params = ccdc_set_hw_if_params,
@@ -859,19 +861,105 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int __init dm644x_ccdc_init(void)
+static int __init dm644x_ccdc_probe(struct platform_device *pdev)
 {
-	printk(KERN_NOTICE "dm644x_ccdc_init\n");
-	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
-		return -1;
-	printk(KERN_NOTICE "%s is registered with vpfe.\n",
-		ccdc_hw_dev.name);
+	struct resource	*res;
+	int status = 0;
+
+	/*
+	 * first try to register with vpfe. If not correct platform, then we
+	 * don't have to iomap
+	 */
+	status = vpfe_register_ccdc_device(&ccdc_hw_dev);
+	if (status < 0)
+		return status;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		status = -ENODEV;
+		goto fail_nores;
+	}
+
+	res = request_mem_region(res->start, resource_size(res), res->name);
+	if (!res) {
+		status = -EBUSY;
+		goto fail_nores;
+	}
+
+	ccdc_cfg.base_addr = ioremap_nocache(res->start, resource_size(res));
+	if (!ccdc_cfg.base_addr) {
+		status = -ENOMEM;
+		goto fail_nomem;
+	}
+
+	/* Get and enable Master clock */
+	ccdc_cfg.mclk = clk_get(&pdev->dev, "master");
+	if (NULL == ccdc_cfg.mclk) {
+		status = -ENODEV;
+		goto fail_nomap;
+	}
+	if (clk_enable(ccdc_cfg.mclk)) {
+		status = -ENODEV;
+		goto fail_mclk;
+	}
+
+	/* Get and enable Slave clock */
+	ccdc_cfg.sclk = clk_get(&pdev->dev, "slave");
+	if (NULL == ccdc_cfg.sclk) {
+		status = -ENODEV;
+		goto fail_mclk;
+	}
+	if (clk_enable(ccdc_cfg.sclk)) {
+		status = -ENODEV;
+		goto fail_sclk;
+	}
+	ccdc_cfg.dev = &pdev->dev;
+	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
 	return 0;
+fail_sclk:
+	clk_put(ccdc_cfg.sclk);
+fail_mclk:
+	clk_put(ccdc_cfg.mclk);
+fail_nomap:
+	iounmap(ccdc_cfg.base_addr);
+fail_nomem:
+	release_mem_region(res->start, resource_size(res));
+fail_nores:
+	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+	return status;
 }
 
-static void __exit dm644x_ccdc_exit(void)
+static int dm644x_ccdc_remove(struct platform_device *pdev)
 {
+	struct resource	*res;
+
+	clk_put(ccdc_cfg.mclk);
+	clk_put(ccdc_cfg.sclk);
+	iounmap(ccdc_cfg.base_addr);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res)
+		release_mem_region(res->start, resource_size(res));
 	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+	return 0;
+}
+
+static struct platform_driver dm644x_ccdc_driver = {
+	.driver = {
+		.name	= "dm644x_ccdc",
+		.owner = THIS_MODULE,
+	},
+	.remove = __devexit_p(dm644x_ccdc_remove),
+	.probe = dm644x_ccdc_probe,
+};
+
+static int __init dm644x_ccdc_init(void)
+{
+	return platform_driver_register(&dm644x_ccdc_driver);
+}
+
+static void __exit dm644x_ccdc_exit(void)
+{
+	platform_driver_unregister(&dm644x_ccdc_driver);
 }
 
 module_init(dm644x_ccdc_init);
-- 
1.6.0.4

