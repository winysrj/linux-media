Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34287 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964821AbdGTI4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 04:56:45 -0400
Received: by mail-wr0-f193.google.com with SMTP id o33so2309581wrb.1
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 01:56:44 -0700 (PDT)
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [v3 2/2] media: platform: davinci: drop VPFE_CMD_S_CCDC_RAW_PARAMS
Date: Thu, 20 Jul 2017 09:56:31 +0100
Message-Id: <1500540991-27430-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1500540991-27430-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1500540991-27430-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drop VPFE_CMD_S_CCDC_RAW_PARAMS ioctl from dm355/dm644x following reasons:

- This ioctl was never in public api and was only defined in kernel header.
- The function set_params constantly mixes up pointers and phys_addr_t
  numbers.
- This is part of a 'VPFE_CMD_S_CCDC_RAW_PARAMS' ioctl command that is
  described as an 'experimental ioctl that will change in future kernels'.
- The code to allocate the table never gets called after we copy_from_user
  the user input over the kernel settings, and then compare them
  for inequality.
- We then go on to use an address provided by user space as both the
  __user pointer for input and pass it through phys_to_virt to come up
  with a kernel pointer to copy the data to. This looks like a trivially
  exploitable root hole.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/ccdc_hw_device.h |  10 --
 drivers/media/platform/davinci/dm355_ccdc.c     |  92 +--------------
 drivers/media/platform/davinci/dm644x_ccdc.c    | 151 +-----------------------
 drivers/media/platform/davinci/vpfe_capture.c   |  75 ------------
 include/media/davinci/dm644x_ccdc.h             |  12 --
 include/media/davinci/vpfe_capture.h            |  10 --
 6 files changed, 4 insertions(+), 346 deletions(-)

diff --git a/drivers/media/platform/davinci/ccdc_hw_device.h b/drivers/media/platform/davinci/ccdc_hw_device.h
index 8f6688a..f1b5210 100644
--- a/drivers/media/platform/davinci/ccdc_hw_device.h
+++ b/drivers/media/platform/davinci/ccdc_hw_device.h
@@ -42,16 +42,6 @@ struct ccdc_hw_ops {
 	int (*set_hw_if_params) (struct vpfe_hw_if_param *param);
 	/* get interface parameters */
 	int (*get_hw_if_params) (struct vpfe_hw_if_param *param);
-	/*
-	 * Pointer to function to set parameters. Used
-	 * for implementing VPFE_S_CCDC_PARAMS
-	 */
-	int (*set_params) (void *params);
-	/*
-	 * Pointer to function to get parameter. Used
-	 * for implementing VPFE_G_CCDC_PARAMS
-	 */
-	int (*get_params) (void *params);
 	/* Pointer to function to configure ccdc */
 	int (*configure) (void);
 
diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index 73db166..6d492dc 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -17,12 +17,7 @@
  * This module is for configuring DM355 CCD controller of VPFE to capture
  * Raw yuv or Bayer RGB data from a decoder. CCDC has several modules
  * such as Defect Pixel Correction, Color Space Conversion etc to
- * pre-process the Bayer RGB data, before writing it to SDRAM. This
- * module also allows application to configure individual
- * module parameters through VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL.
- * To do so, application include dm355_ccdc.h and vpfe_capture.h header
- * files. The setparams() API is called by vpfe_capture driver
- * to configure module parameters
+ * pre-process the Bayer RGB data, before writing it to SDRAM.
  *
  * TODO: 1) Raw bayer parameter settings and bayer capture
  * 	 2) Split module parameter structure to module specific ioctl structs
@@ -260,90 +255,6 @@ static void ccdc_setwin(struct v4l2_rect *image_win,
 	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_setwin...");
 }
 
-static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
-{
-	if (ccdcparam->datasft < CCDC_DATA_NO_SHIFT ||
-	    ccdcparam->datasft > CCDC_DATA_SHIFT_6BIT) {
-		dev_dbg(ccdc_cfg.dev, "Invalid value of data shift\n");
-		return -EINVAL;
-	}
-
-	if (ccdcparam->mfilt1 < CCDC_NO_MEDIAN_FILTER1 ||
-	    ccdcparam->mfilt1 > CCDC_MEDIAN_FILTER1) {
-		dev_dbg(ccdc_cfg.dev, "Invalid value of median filter1\n");
-		return -EINVAL;
-	}
-
-	if (ccdcparam->mfilt2 < CCDC_NO_MEDIAN_FILTER2 ||
-	    ccdcparam->mfilt2 > CCDC_MEDIAN_FILTER2) {
-		dev_dbg(ccdc_cfg.dev, "Invalid value of median filter2\n");
-		return -EINVAL;
-	}
-
-	if ((ccdcparam->med_filt_thres < 0) ||
-	   (ccdcparam->med_filt_thres > CCDC_MED_FILT_THRESH)) {
-		dev_dbg(ccdc_cfg.dev,
-			"Invalid value of median filter threshold\n");
-		return -EINVAL;
-	}
-
-	if (ccdcparam->data_sz < CCDC_DATA_16BITS ||
-	    ccdcparam->data_sz > CCDC_DATA_8BITS) {
-		dev_dbg(ccdc_cfg.dev, "Invalid value of data size\n");
-		return -EINVAL;
-	}
-
-	if (ccdcparam->alaw.enable) {
-		if (ccdcparam->alaw.gamma_wd < CCDC_GAMMA_BITS_13_4 ||
-		    ccdcparam->alaw.gamma_wd > CCDC_GAMMA_BITS_09_0) {
-			dev_dbg(ccdc_cfg.dev, "Invalid value of ALAW\n");
-			return -EINVAL;
-		}
-	}
-
-	if (ccdcparam->blk_clamp.b_clamp_enable) {
-		if (ccdcparam->blk_clamp.sample_pixel < CCDC_SAMPLE_1PIXELS ||
-		    ccdcparam->blk_clamp.sample_pixel > CCDC_SAMPLE_16PIXELS) {
-			dev_dbg(ccdc_cfg.dev,
-				"Invalid value of sample pixel\n");
-			return -EINVAL;
-		}
-		if (ccdcparam->blk_clamp.sample_ln < CCDC_SAMPLE_1LINES ||
-		    ccdcparam->blk_clamp.sample_ln > CCDC_SAMPLE_16LINES) {
-			dev_dbg(ccdc_cfg.dev,
-				"Invalid value of sample lines\n");
-			return -EINVAL;
-		}
-	}
-	return 0;
-}
-
-/* Parameter operations */
-static int ccdc_set_params(void __user *params)
-{
-	struct ccdc_config_params_raw ccdc_raw_params;
-	int x;
-
-	/* only raw module parameters can be set through the IOCTL */
-	if (ccdc_cfg.if_type != VPFE_RAW_BAYER)
-		return -EINVAL;
-
-	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
-	if (x) {
-		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copying ccdcparams, %d\n",
-			x);
-		return -EFAULT;
-	}
-
-	if (!validate_ccdc_param(&ccdc_raw_params)) {
-		memcpy(&ccdc_cfg.bayer.config_params,
-			&ccdc_raw_params,
-			sizeof(ccdc_raw_params));
-		return 0;
-	}
-	return -EINVAL;
-}
-
 /* This function will configure CCDC for YCbCr video capture */
 static void ccdc_config_ycbcr(void)
 {
@@ -939,7 +850,6 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 		.enable = ccdc_enable,
 		.enable_out_to_sdram = ccdc_enable_output_to_sdram,
 		.set_hw_if_params = ccdc_set_hw_if_params,
-		.set_params = ccdc_set_params,
 		.configure = ccdc_configure,
 		.set_buftype = ccdc_set_buftype,
 		.get_buftype = ccdc_get_buftype,
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 740fbc7..3b2d8a9 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -17,13 +17,9 @@
  * This module is for configuring CCD controller of DM6446 VPFE to capture
  * Raw yuv or Bayer RGB data from a decoder. CCDC has several modules
  * such as Defect Pixel Correction, Color Space Conversion etc to
- * pre-process the Raw Bayer RGB data, before writing it to SDRAM. This
- * module also allows application to configure individual
- * module parameters through VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL.
- * To do so, application includes dm644x_ccdc.h and vpfe_capture.h header
- * files.  The setparams() API is called by vpfe_capture driver
- * to configure module parameters. This file is named DM644x so that other
- * variants such DM6443 may be supported using the same module.
+ * pre-process the Raw Bayer RGB data, before writing it to SDRAM.
+ * This file is named DM644x so that other variants such DM6443
+ * may be supported using the same module.
  *
  * TODO: Test Raw bayer parameter settings and bayer capture
  * 	 Split module parameter structure to module specific ioctl structs
@@ -216,96 +212,8 @@ static void ccdc_readregs(void)
 	dev_notice(ccdc_cfg.dev, "\nReading 0x%x to VERT_LINES...\n", val);
 }
 
-static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
-{
-	if (ccdcparam->alaw.enable) {
-		u8 max_gamma = ccdc_gamma_width_max_bit(ccdcparam->alaw.gamma_wd);
-		u8 max_data = ccdc_data_size_max_bit(ccdcparam->data_sz);
-
-		if ((ccdcparam->alaw.gamma_wd > CCDC_GAMMA_BITS_09_0) ||
-		    (ccdcparam->alaw.gamma_wd < CCDC_GAMMA_BITS_15_6) ||
-		    (max_gamma > max_data)) {
-			dev_dbg(ccdc_cfg.dev, "\nInvalid data line select");
-			return -1;
-		}
-	}
-	return 0;
-}
-
-static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
-{
-	struct ccdc_config_params_raw *config_params =
-				&ccdc_cfg.bayer.config_params;
-	unsigned int *fpc_virtaddr = NULL;
-	unsigned int *fpc_physaddr = NULL;
-
-	memcpy(config_params, raw_params, sizeof(*raw_params));
-	/*
-	 * allocate memory for fault pixel table and copy the user
-	 * values to the table
-	 */
-	if (!config_params->fault_pxl.enable)
-		return 0;
-
-	fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
-	fpc_virtaddr = (unsigned int *)phys_to_virt(
-				(unsigned long)fpc_physaddr);
-	/*
-	 * Allocate memory for FPC table if current
-	 * FPC table buffer is not big enough to
-	 * accommodate FPC Number requested
-	 */
-	if (raw_params->fault_pxl.fp_num != config_params->fault_pxl.fp_num) {
-		if (fpc_physaddr != NULL) {
-			free_pages((unsigned long)fpc_virtaddr,
-				   get_order
-				   (config_params->fault_pxl.fp_num *
-				   FP_NUM_BYTES));
-		}
-
-		/* Allocate memory for FPC table */
-		fpc_virtaddr =
-			(unsigned int *)__get_free_pages(GFP_KERNEL | GFP_DMA,
-							 get_order(raw_params->
-							 fault_pxl.fp_num *
-							 FP_NUM_BYTES));
-
-		if (fpc_virtaddr == NULL) {
-			dev_dbg(ccdc_cfg.dev,
-				"\nUnable to allocate memory for FPC");
-			return -EFAULT;
-		}
-		fpc_physaddr =
-		    (unsigned int *)virt_to_phys((void *)fpc_virtaddr);
-	}
-
-	/* Copy number of fault pixels and FPC table */
-	config_params->fault_pxl.fp_num = raw_params->fault_pxl.fp_num;
-	if (copy_from_user(fpc_virtaddr,
-			(void __user *)raw_params->fault_pxl.fpc_table_addr,
-			config_params->fault_pxl.fp_num * FP_NUM_BYTES)) {
-		dev_dbg(ccdc_cfg.dev, "\n copy_from_user failed");
-		return -EFAULT;
-	}
-	config_params->fault_pxl.fpc_table_addr = (unsigned long)fpc_physaddr;
-	return 0;
-}
-
 static int ccdc_close(struct device *dev)
 {
-	struct ccdc_config_params_raw *config_params =
-				&ccdc_cfg.bayer.config_params;
-	unsigned int *fpc_physaddr = NULL, *fpc_virtaddr = NULL;
-
-	fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
-
-	if (fpc_physaddr != NULL) {
-		fpc_virtaddr = (unsigned int *)
-		    phys_to_virt((unsigned long)fpc_physaddr);
-		free_pages((unsigned long)fpc_virtaddr,
-			   get_order(config_params->fault_pxl.fp_num *
-			   FP_NUM_BYTES));
-	}
 	return 0;
 }
 
@@ -339,29 +247,6 @@ static void ccdc_sbl_reset(void)
 	vpss_clear_wbl_overflow(VPSS_PCR_CCDC_WBL_O);
 }
 
-/* Parameter operations */
-static int ccdc_set_params(void __user *params)
-{
-	struct ccdc_config_params_raw ccdc_raw_params;
-	int x;
-
-	if (ccdc_cfg.if_type != VPFE_RAW_BAYER)
-		return -EINVAL;
-
-	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
-	if (x) {
-		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copyingccdc params, %d\n",
-			x);
-		return -EFAULT;
-	}
-
-	if (!validate_ccdc_param(&ccdc_raw_params)) {
-		if (!ccdc_update_raw_params(&ccdc_raw_params))
-			return 0;
-	}
-	return -EINVAL;
-}
-
 /*
  * ccdc_config_ycbcr()
  * This function will configure CCDC for YCbCr video capture
@@ -489,32 +374,6 @@ static void ccdc_config_black_compense(struct ccdc_black_compensation *bcomp)
 	regw(val, CCDC_BLKCMP);
 }
 
-static void ccdc_config_fpc(struct ccdc_fault_pixel *fpc)
-{
-	u32 val;
-
-	/* Initially disable FPC */
-	val = CCDC_FPC_DISABLE;
-	regw(val, CCDC_FPC);
-
-	if (!fpc->enable)
-		return;
-
-	/* Configure Fault pixel if needed */
-	regw(fpc->fpc_table_addr, CCDC_FPC_ADDR);
-	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%lx to FPC_ADDR...\n",
-		       (fpc->fpc_table_addr));
-	/* Write the FPC params with FPC disable */
-	val = fpc->fp_num & CCDC_FPC_FPC_NUM_MASK;
-	regw(val, CCDC_FPC);
-
-	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FPC...\n", val);
-	/* read the FPC register */
-	val = regr(CCDC_FPC) | CCDC_FPC_ENABLE;
-	regw(val, CCDC_FPC);
-	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FPC...\n", val);
-}
-
 /*
  * ccdc_config_raw()
  * This function will configure CCDC for Raw capture mode
@@ -569,9 +428,6 @@ static void ccdc_config_raw(void)
 	/* Configure Black level compensation */
 	ccdc_config_black_compense(&config_params->blk_comp);
 
-	/* Configure Fault Pixel Correction */
-	ccdc_config_fpc(&config_params->fault_pxl);
-
 	/* If data size is 8 bit then pack the data */
 	if ((config_params->data_sz == CCDC_DATA_8BITS) ||
 	     config_params->alaw.enable)
@@ -929,7 +785,6 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 		.reset = ccdc_sbl_reset,
 		.enable = ccdc_enable,
 		.set_hw_if_params = ccdc_set_hw_if_params,
-		.set_params = ccdc_set_params,
 		.configure = ccdc_configure,
 		.set_buftype = ccdc_set_buftype,
 		.get_buftype = ccdc_get_buftype,
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 1831bf5..b1bf4a7 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -281,45 +281,6 @@ void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev)
 EXPORT_SYMBOL(vpfe_unregister_ccdc_device);
 
 /*
- * vpfe_get_ccdc_image_format - Get image parameters based on CCDC settings
- */
-static int vpfe_get_ccdc_image_format(struct vpfe_device *vpfe_dev,
-				 struct v4l2_format *f)
-{
-	struct v4l2_rect image_win;
-	enum ccdc_buftype buf_type;
-	enum ccdc_frmfmt frm_fmt;
-
-	memset(f, 0, sizeof(*f));
-	f->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	ccdc_dev->hw_ops.get_image_window(&image_win);
-	f->fmt.pix.width = image_win.width;
-	f->fmt.pix.height = image_win.height;
-	f->fmt.pix.bytesperline = ccdc_dev->hw_ops.get_line_length();
-	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
-				f->fmt.pix.height;
-	buf_type = ccdc_dev->hw_ops.get_buftype();
-	f->fmt.pix.pixelformat = ccdc_dev->hw_ops.get_pixel_format();
-	frm_fmt = ccdc_dev->hw_ops.get_frame_format();
-	if (frm_fmt == CCDC_FRMFMT_PROGRESSIVE)
-		f->fmt.pix.field = V4L2_FIELD_NONE;
-	else if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
-		if (buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED)
-			f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-		else if (buf_type == CCDC_BUFTYPE_FLD_SEPARATED)
-			f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
-		else {
-			v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf_type\n");
-			return -EINVAL;
-		}
-	} else {
-		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid frm_fmt\n");
-		return -EINVAL;
-	}
-	return 0;
-}
-
-/*
  * vpfe_config_ccdc_image_format()
  * For a pix format, configure ccdc to setup the capture
  */
@@ -1697,41 +1658,6 @@ static int vpfe_s_selection(struct file *file, void *priv,
 	return ret;
 }
 
-
-static long vpfe_param_handler(struct file *file, void *priv,
-		bool valid_prio, unsigned int cmd, void *param)
-{
-	struct vpfe_device *vpfe_dev = video_drvdata(file);
-	int ret;
-
-	v4l2_dbg(2, debug, &vpfe_dev->v4l2_dev, "vpfe_param_handler\n");
-
-	if (vpfe_dev->started) {
-		/* only allowed if streaming is not started */
-		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-			"device already started\n");
-		return -EBUSY;
-	}
-
-	ret = mutex_lock_interruptible(&vpfe_dev->lock);
-	if (ret)
-		return ret;
-
-	switch (cmd) {
-	case VPFE_CMD_S_CCDC_RAW_PARAMS:
-		ret = -EINVAL;
-		v4l2_warn(&vpfe_dev->v4l2_dev,
-			"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
-		break;
-	default:
-		ret = -ENOTTY;
-	}
-unlock_out:
-	mutex_unlock(&vpfe_dev->lock);
-	return ret;
-}
-
-
 /* vpfe capture ioctl operations */
 static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_querycap	 = vpfe_querycap,
@@ -1754,7 +1680,6 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_cropcap		 = vpfe_cropcap,
 	.vidioc_g_selection	 = vpfe_g_selection,
 	.vidioc_s_selection	 = vpfe_s_selection,
-	.vidioc_default		 = vpfe_param_handler,
 };
 
 static struct vpfe_device *vpfe_initialize(void)
diff --git a/include/media/davinci/dm644x_ccdc.h b/include/media/davinci/dm644x_ccdc.h
index 7c909da..6ea2ce2 100644
--- a/include/media/davinci/dm644x_ccdc.h
+++ b/include/media/davinci/dm644x_ccdc.h
@@ -103,16 +103,6 @@ struct ccdc_black_compensation {
 	char gb;
 };
 
-/* structure for fault pixel correction */
-struct ccdc_fault_pixel {
-	/* Enable or Disable fault pixel correction */
-	unsigned char enable;
-	/* Number of fault pixel */
-	unsigned short fp_num;
-	/* Address of fault pixel table */
-	unsigned long fpc_table_addr;
-};
-
 /* Structure for CCDC configuration parameters for raw capture mode passed
  * by application
  */
@@ -125,8 +115,6 @@ struct ccdc_config_params_raw {
 	struct ccdc_black_clamp blk_clamp;
 	/* Structure for Black Compensation */
 	struct ccdc_black_compensation blk_comp;
-	/* Structure for Fault Pixel Module Configuration */
-	struct ccdc_fault_pixel fault_pxl;
 };
 
 
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index 8e1a4d8..f003533 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -183,14 +183,4 @@ struct vpfe_config_params {
 };
 
 #endif				/* End of __KERNEL__ */
-/**
- * VPFE_CMD_S_CCDC_RAW_PARAMS - EXPERIMENTAL IOCTL to set raw capture params
- * This can be used to configure modules such as defect pixel correction,
- * color space conversion, culling etc. This is an experimental ioctl that
- * will change in future kernels. So use this ioctl with care !
- * TODO: This is to be split into multiple ioctls and also explore the
- * possibility of extending the v4l2 api to include this
- **/
-#define VPFE_CMD_S_CCDC_RAW_PARAMS _IOW('V', BASE_VIDIOC_PRIVATE + 1, \
-					void *)
 #endif				/* _DAVINCI_VPFE_H */
-- 
2.7.4
