Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58357 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZCSM12 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 08:27:28 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>,
	Brijesh Jadav <brijesh.j@ti.com>,
	Hardik Shah <hardik.shah@ti.com>
Subject: [PATCH 1/2 (V3)] OMAP3 ISP-Camera: Added BT656 support ontop of Sakari's repository
Date: Thu, 19 Mar 2009 17:57:17 +0530
Message-Id: <1237465637-5398-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Support for BT656 through TVP5146 decoder, works on top of
Sakari's repository

http://git.gitorious.org/omap3camera/mainline.git

NOTE: Please note that, hence forth I will try to avoid submitting
      patches on top of V4L2-int framework. The next immediate activity
      should be migration to sub-device framework.

Tested:
	- On OMAP3EVM + Multi-Media Daughter card
	- NTSC and PAL standard
	- S-Video and Composite input

TODO:
	- Migration to sub-devide framework
	- Support for Scaling and Cropping

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/isp/isp.c     |   85 ++++++++++++++++--
 drivers/media/video/isp/isp.h     |    3 +-
 drivers/media/video/isp/ispccdc.c |  119 +++++++++++++++++++++---
 drivers/media/video/isp/ispccdc.h |    9 ++
 drivers/media/video/omap34xxcam.c |  179 +++++++++++++++++++++++++++++++++---
 drivers/media/video/omap34xxcam.h |    1 +
 6 files changed, 357 insertions(+), 39 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index 54c839b..18313b3 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -215,6 +215,7 @@ struct isp_irq {
  * @resizer_input_height: ISP Resizer module input image height.
  * @resizer_output_width: ISP Resizer module output image width.
  * @resizer_output_height: ISP Resizer module output image height.
+ * @current_field: Current field for interlaced capture.
  */
 struct isp_module {
 	unsigned int isp_pipeline;
@@ -232,6 +233,7 @@ struct isp_module {
 	unsigned int resizer_input_height;
 	unsigned int resizer_output_width;
 	unsigned int resizer_output_height;
+	int current_field;
 };

 #define RAW_CAPTURE(isp)					\
@@ -258,6 +260,7 @@ static struct isp {
 	dma_addr_t tmp_buf;
 	size_t tmp_buf_size;
 	unsigned long tmp_buf_offset;
+	int bt656ifen;
 	struct isp_bufs bufs;
 	struct isp_irq irq;
 	struct isp_module module;
@@ -266,6 +269,8 @@ static struct isp {
 /* Structure for saving/restoring ISP module registers */
 static struct isp_reg isp_reg_list[] = {
 	{OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_IRQ1ENABLE, 0},
 	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_GRESET_LENGTH, 0},
 	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_PSTRB_REPLAY, 0},
 	{OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, 0},
@@ -800,7 +805,10 @@ int isp_configure_interface(struct isp_interface_config *config)

 	isp_buf_init();

+	isp_obj.bt656ifen = 0;
 	switch (config->ccdc_par_ser) {
+	case ISP_PARLL_YUV_BT:
+		isp_obj.bt656ifen = 1;
 	case ISP_PARLL:
 		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
 		ispctrl_val |= config->u.par.par_clk_pol
@@ -885,8 +893,18 @@ static irqreturn_t omap34xx_isp_isr(int irq, void *_isp)

 	spin_lock_irqsave(&bufs->lock, flags);
 	wait_hs_vs = bufs->wait_hs_vs;
-	if (irqstatus & HS_VS && bufs->wait_hs_vs)
-		bufs->wait_hs_vs--;
+	if (irqstatus & HS_VS) {
+		if (bufs->wait_hs_vs)
+			bufs->wait_hs_vs--;
+		else {
+			if (isp_obj.module.pix.field == V4L2_FIELD_INTERLACED) {
+				isp_obj.module.current_field =
+					(isp_reg_readl(OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_SYN_MODE) &
+					ISPCCDC_SYN_MODE_FLDSTAT) ? 1 : 0;
+			}
+		}
+	}
 	spin_unlock_irqrestore(&bufs->lock, flags);

 	spin_lock_irqsave(&isp_obj.lock, irqflags);
@@ -898,6 +916,12 @@ static irqreturn_t omap34xx_isp_isr(int irq, void *_isp)
 		goto out_ignore_buff;

 	if (irqstatus & CCDC_VD0) {
+		if (isp_obj.module.pix.field == V4L2_FIELD_INTERLACED) {
+			/* Skip even fields */
+			if (isp_obj.module.current_field == 0) {
+				goto out_ignore_buff;
+			}
+		}
 		if (RAW_CAPTURE(&isp_obj))
 			isp_buf_process(bufs);
 		if (!ispccdc_busy())
@@ -1046,6 +1070,11 @@ out_ignore_buff:
 	}
 #endif

+	/* TODO: Workaround suggested by Tony for spurious
+	 * interrupt issue
+	*/
+	irqstatus = isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+
 	return IRQ_HANDLED;
 }

@@ -1262,11 +1291,16 @@ static u32 isp_calc_pipeline(struct v4l2_pix_format *pix_input,
 		isp_obj.module.isp_pipeline = OMAP_ISP_CCDC;
 		ispccdc_request();
 		if (pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10
-		    || pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10DPCM8)
+		    || pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10DPCM8) {
 			ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP_MEM);
-		else
-			ispccdc_config_datapath(CCDC_YUV_SYNC,
+		} else {
+			if (isp_obj.bt656ifen)
+				ispccdc_config_datapath(CCDC_YUV_BT,
+						CCDC_OTHERS_MEM);
+			else
+				ispccdc_config_datapath(CCDC_YUV_SYNC,
 						CCDC_OTHERS_MEM);
+		}
 	}
 	return 0;
 }
@@ -1293,6 +1327,31 @@ static void isp_config_pipeline(struct v4l2_pix_format *pix_input,
 				       isp_obj.module.preview_output_width,
 				       isp_obj.module.preview_output_height);
 	}
+	if (pix_input->pixelformat == V4L2_PIX_FMT_UYVY)
+		ispccdc_config_y8pos(Y8POS_ODD);
+	else if (pix_input->pixelformat == V4L2_PIX_FMT_YUYV)
+		ispccdc_config_y8pos(Y8POS_EVEN);
+
+	if (((pix_input->pixelformat == V4L2_PIX_FMT_UYVY) &&
+			(pix_output->pixelformat == V4L2_PIX_FMT_UYVY)) ||
+			((pix_input->pixelformat == V4L2_PIX_FMT_YUYV) &&
+			(pix_output->pixelformat == V4L2_PIX_FMT_YUYV)))
+		/* input and output formats are in same order */
+		ispccdc_config_byteswap(0);
+	else if (((pix_input->pixelformat == V4L2_PIX_FMT_YUYV) &&
+			(pix_output->pixelformat == V4L2_PIX_FMT_UYVY)) ||
+			((pix_input->pixelformat == V4L2_PIX_FMT_UYVY) &&
+			(pix_output->pixelformat == V4L2_PIX_FMT_YUYV)))
+		/* input and output formats are in reverse order */
+		ispccdc_config_byteswap(1);
+
+	/*
+	 * Configure Pitch - This enables application to use a different pitch
+	 * other than active pixels per line.
+	 */
+	if (isp_obj.bt656ifen)
+		ispccdc_config_outlineoffset(isp_obj.module.pix.bytesperline,
+						0, 0);

 	if (isp_obj.module.isp_pipeline & OMAP_ISP_RESIZER) {
 		ispresizer_config_size(isp_obj.module.resizer_input_width,
@@ -2071,15 +2130,25 @@ int isp_try_fmt(struct v4l2_pix_format *pix_input,
 	if (ifmt == NUM_ISP_CAPTURE_FORMATS)
 		ifmt = 1;
 	pix_output->pixelformat = isp_formats[ifmt].pixelformat;
-	pix_output->field = V4L2_FIELD_NONE;
-	pix_output->bytesperline = pix_output->width * ISP_BYTES_PER_PIXEL;
+
+	if (isp_obj.bt656ifen)
+		pix_output->field = pix_input->field;
+	else {
+		pix_output->field = V4L2_FIELD_NONE;
+		pix_output->bytesperline =
+			pix_output->width * ISP_BYTES_PER_PIXEL;
+	}
+
 	pix_output->sizeimage =
 		PAGE_ALIGN(pix_output->bytesperline * pix_output->height);
 	pix_output->priv = 0;
 	switch (pix_output->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
-		pix_output->colorspace = V4L2_COLORSPACE_JPEG;
+		if (isp_obj.bt656ifen)
+			pix_output->colorspace = pix_input->colorspace;
+		else
+			pix_output->colorspace = V4L2_COLORSPACE_JPEG;
 		break;
 	default:
 		pix_output->colorspace = V4L2_COLORSPACE_SRGB;
diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
index 55c98a9..ca070fd 100644
--- a/drivers/media/video/isp/isp.h
+++ b/drivers/media/video/isp/isp.h
@@ -98,7 +98,8 @@ enum isp_interface_type {
 	ISP_PARLL = 1,
 	ISP_CSIA = 2,
 	ISP_CSIB = 4,
-	ISP_NONE = 8 /* memory input to preview / resizer */
+	ISP_PARLL_YUV_BT = 8,
+	ISP_NONE = 16 /* memory input to preview / resizer */
 };

 enum isp_irqevents {
diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index 2574ea2..e702bef 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -625,9 +625,15 @@ int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
 		syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 		syn_mode |= ISPCCDC_SYN_MODE_WEN;
-		syn_mode &= ~ISPCCDC_SYN_MODE_EXWEN;
-		isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
-			    ~ISPCCDC_CFG_WENLOG);
+		if (input == CCDC_YUV_BT) {
+			syn_mode &= ~ISPCCDC_SYN_MODE_EXWEN;
+			isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+					~ISPCCDC_CFG_WENLOG);
+		} else {
+			syn_mode |= ISPCCDC_SYN_MODE_EXWEN;
+			isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+					ISPCCDC_CFG_WENLOG);
+		}
 		vpcfg.bitshift_sel = BIT11_2;
 		vpcfg.freq_sel = PIXCLKBY2;
 		ispccdc_config_vp(vpcfg);
@@ -667,6 +673,7 @@ int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
 		syncif.hdpol = 0;
 		syncif.ipmod = RAW;
 		syncif.vdpol = 0;
+		syncif.bt_r656_en = 0;
 		ispccdc_config_sync_if(syncif);
 		ispccdc_config_imgattr(colptn);
 		blkcfg.dcsubval = 64;
@@ -689,12 +696,28 @@ int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
 		syncif.hdpol = 0;
 		syncif.ipmod = YUV16;
 		syncif.vdpol = 1;
+		syncif.bt_r656_en = 0;
 		ispccdc_config_imgattr(0);
 		ispccdc_config_sync_if(syncif);
 		blkcfg.dcsubval = 0;
 		ispccdc_config_black_clamp(blkcfg);
 		break;
 	case CCDC_YUV_BT:
+		syncif.ccdc_mastermode = 0;
+		syncif.datapol = 0;
+		syncif.datsz = DAT8;
+		syncif.fldmode = 1;
+		syncif.fldout = 0;
+		syncif.fldpol = 0;
+		syncif.fldstat = 0;
+		syncif.hdpol = 0;
+		syncif.ipmod = YUV8;
+		syncif.vdpol = 1;
+		syncif.bt_r656_en = 1;
+		ispccdc_config_imgattr(0);
+		ispccdc_config_sync_if(syncif);
+		blkcfg.dcsubval = 0;
+		ispccdc_config_black_clamp(blkcfg);
 		break;
 	case CCDC_OTHERS:
 		break;
@@ -739,6 +762,8 @@ void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
 		break;
 	case YUV8:
 		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+		if (syncif.bt_r656_en)
+			syn_mode |= ISPCCDC_SYN_MODE_PACK8;
 		break;
 	};

@@ -803,6 +828,10 @@ void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
 	if (!(syncif.bt_r656_en)) {
 		isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
 			    ~ISPCCDC_REC656IF_R656ON);
+	} else {
+		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+				ISPCCDC_REC656IF_R656ON |
+				ISPCCDC_REC656IF_ECCFVH);
 	}
 }
 EXPORT_SYMBOL(ispccdc_config_sync_if);
@@ -1228,35 +1257,59 @@ int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h)

 	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) {
 		isp_reg_writel(0, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
-		if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
+		if (ispccdc_obj.ccdc_inpfmt != CCDC_YUV_BT) {
 			isp_reg_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
 				       | ((ispccdc_obj.ccdcout_w - 1)
 					  << ISPCCDC_HORZ_INFO_NPH_SHIFT),
 				       OMAP3_ISP_IOMEM_CCDC,
 				       ISPCCDC_HORZ_INFO);
+			isp_reg_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+					OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_VERT_START);
+			isp_reg_writel((ispccdc_obj.ccdcout_h - 1) <<
+					ISPCCDC_VERT_LINES_NLV_SHIFT,
+					OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_VERT_LINES);
 		} else {
-			isp_reg_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
-				       | ((ispccdc_obj.ccdcout_w - 1)
-					  << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+			isp_reg_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+					(((ispccdc_obj.ccdcout_w << 1) - 1) <<
+					 ISPCCDC_HORZ_INFO_NPH_SHIFT),
 				       OMAP3_ISP_IOMEM_CCDC,
 				       ISPCCDC_HORZ_INFO);
-		}
-		isp_reg_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
-			       OMAP3_ISP_IOMEM_CCDC,
-			       ISPCCDC_VERT_START);
-		isp_reg_writel((ispccdc_obj.ccdcout_h - 1) <<
+			isp_reg_writel(2 << ISPCCDC_VERT_START_SLV0_SHIFT |
+					2 << ISPCCDC_VERT_START_SLV1_SHIFT,
+					OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_VERT_START);
+			isp_reg_writel(((ispccdc_obj.ccdcout_h >> 1) - 1) <<
 			       ISPCCDC_VERT_LINES_NLV_SHIFT,
 			       OMAP3_ISP_IOMEM_CCDC,
 			       ISPCCDC_VERT_LINES);
+		}

 		ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
-		isp_reg_writel((((ispccdc_obj.ccdcout_h - 2) &
+		if (ispccdc_obj.ccdc_inpfmt != CCDC_YUV_BT) {
+			isp_reg_writel((((ispccdc_obj.ccdcout_h - 2) &
+				ISPCCDC_VDINT_0_MASK) << ISPCCDC_VDINT_0_SHIFT)
+				| ((100 & ISPCCDC_VDINT_1_MASK) <<
+				ISPCCDC_VDINT_1_SHIFT), OMAP3_ISP_IOMEM_CCDC,
+				ISPCCDC_VDINT);
+		} else {
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					EVENEVEN, 1);
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					ODDEVEN, 1);
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					EVENODD, 1);
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					ODDODD, 1);
+			isp_reg_writel(((((ispccdc_obj.ccdcout_h >> 1) - 1) &
 				 ISPCCDC_VDINT_0_MASK) <<
 				ISPCCDC_VDINT_0_SHIFT) |
-			       ((100 & ISPCCDC_VDINT_1_MASK) <<
-				ISPCCDC_VDINT_1_SHIFT),
+				((50 & ISPCCDC_VDINT_1_MASK) <<
+				 ISPCCDC_VDINT_1_SHIFT),
 			       OMAP3_ISP_IOMEM_CCDC,
 			       ISPCCDC_VDINT);
+		}
 	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP_MEM) {
 		isp_reg_writel((0 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
 			       (ispccdc_obj.ccdcin_w <<
@@ -1464,6 +1517,42 @@ int ispccdc_sbl_busy(void)
 EXPORT_SYMBOL(ispccdc_sbl_busy);

 /**
+ * ispccdc_config_y8pos - Configures the location of Y color component
+ * @mode: Y8POS_EVEN Y pixel in even position, otherwise Y pixel in odd
+ *
+ * Configures the location of Y color componenent for YCbCr 8-bit data
+ */
+void ispccdc_config_y8pos(enum y8pos_mode mode)
+{
+	if (mode == Y8POS_EVEN) {
+		isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+							~ISPCCDC_CFG_Y8POS);
+	} else {
+		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+							ISPCCDC_CFG_Y8POS);
+	}
+}
+EXPORT_SYMBOL(ispccdc_config_y8pos);
+
+/**
+ * ispccdc_config_byteswap - Configures byte swap data stored in memory
+ * @swap: 1 - swap bytes, 0 - normal
+ *
+ * Controls the order in which the Y and C pixels are stored in memory
+ */
+void ispccdc_config_byteswap(int swap)
+{
+	if (swap) {
+		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+							ISPCCDC_CFG_BSWD);
+	} else {
+		isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+							~ISPCCDC_CFG_BSWD);
+	}
+}
+EXPORT_SYMBOL(ispccdc_config_byteswap);
+
+/**
  * ispccdc_busy - Gets busy state of the CCDC.
  **/
 int ispccdc_busy(void)
diff --git a/drivers/media/video/isp/ispccdc.h b/drivers/media/video/isp/ispccdc.h
index 4ef40a6..f3ab5b4 100644
--- a/drivers/media/video/isp/ispccdc.h
+++ b/drivers/media/video/isp/ispccdc.h
@@ -55,6 +55,11 @@ enum datasize {
 	DAT12
 };

+/* Enumeration constants for location of Y component in 8-bit YUV data */
+enum y8pos_mode {
+	Y8POS_EVEN = 0,
+	Y8POS_ODD = 1
+};

 /**
  * struct ispccdc_syncif - Structure for Sync Interface between sensor and CCDC
@@ -194,6 +199,10 @@ void ispccdc_resume(void);

 int ispccdc_sbl_busy(void);

+void ispccdc_config_y8pos(enum y8pos_mode mode);
+
+void ispccdc_config_byteswap(int swap);
+
 int ispccdc_busy(void);

 void ispccdc_save_context(void);
diff --git a/drivers/media/video/omap34xxcam.c b/drivers/media/video/omap34xxcam.c
index 00fdbf2..1b0cb24 100644
--- a/drivers/media/video/omap34xxcam.c
+++ b/drivers/media/video/omap34xxcam.c
@@ -56,6 +56,8 @@
 #include "isp/isppreview.h"
 #include "isp/ispresizer.h"

+#include <media/tvp514x.h>
+
 #define OMAP34XXCAM_VERSION KERNEL_VERSION(0, 0, 0)

 /* global variables */
@@ -653,14 +655,36 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
 		goto out;
 	}

-	vdev->want_pix = f->fmt.pix;
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		struct v4l2_format input_fmt = *f;
+		struct v4l2_pix_format *pix = &f->fmt.pix;

-	timeperframe = vdev->want_timeperframe;
+		rval = isp_try_fmt_cap(pix, pix);
+		if (rval)
+			goto out;
+		/* Always negotiate with the sensor first */
+		rval = vidioc_int_s_fmt_cap(vdev->vdev_sensor, &input_fmt);
+		if (rval)
+			goto out;
+
+		pix->width = input_fmt.fmt.pix.width;
+		pix->height = input_fmt.fmt.pix.height;
+		pix->field = input_fmt.fmt.pix.field;
+		pix->bytesperline = input_fmt.fmt.pix.bytesperline;
+		pix->colorspace = input_fmt.fmt.pix.colorspace;
+		pix->sizeimage = input_fmt.fmt.pix.sizeimage;
+
+		/* Negotiate with OMAP3 ISP */
+		rval = isp_s_fmt_cap(pix, pix);
+	} else {
+		vdev->want_pix = pix_tmp = f->fmt.pix;
+
+		timeperframe = vdev->want_timeperframe;

-	rval = s_pix_parm(vdev, &pix_tmp, &f->fmt.pix, &timeperframe);
+		rval = s_pix_parm(vdev, &pix_tmp, &f->fmt.pix, &timeperframe);
+	}
 	if (!rval)
 		vdev->pix = f->fmt.pix;
-
 out:
 	mutex_unlock(&vdev->mutex);

@@ -905,12 +929,23 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 static int vidioc_enum_input(struct file *file, void *fh,
 			     struct v4l2_input *inp)
 {
-	if (inp->index > 0)
-		return -EINVAL;
+	struct omap34xxcam_videodev *vdev = ((struct omap34xxcam_fh *)fh)->vdev;

-	strlcpy(inp->name, "camera", sizeof(inp->name));
-	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				== INPUT_CVBS_VI4A)
+			strlcpy(inp->name, "COMPOSITE", sizeof(inp->name));
+		else if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR]
+				.cur_input == INPUT_SVIDEO_VI2C_VI1C)
+			strlcpy(inp->name, "S-VIDEO", sizeof(inp->name));
+	} else {
+		if (inp->index > 0)
+			return -EINVAL;

+		strlcpy(inp->name, "camera", sizeof(inp->name));
+	}
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	return 0;
 }

@@ -924,9 +959,43 @@ static int vidioc_enum_input(struct file *file, void *fh,
  */
 static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
 {
-	*i = 0;
+	struct omap34xxcam_videodev *vdev = ((struct omap34xxcam_fh *)fh)->vdev;
+	int rval = 0;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		if ((vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				!= INPUT_CVBS_VI4A) &&
+				(vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].
+				 cur_input != INPUT_SVIDEO_VI2C_VI1C)) {
+			struct v4l2_routing route;
+			route.input = INPUT_CVBS_VI4A;
+			route.output = 0;
+			rval = vidioc_int_s_video_routing(vdev->vdev_sensor,
+					&route);
+			if (rval) {
+				route.input = INPUT_SVIDEO_VI2C_VI1C;
+				rval = vidioc_int_s_video_routing(
+						vdev->vdev_sensor, &route);
+			}
+			if (!rval)
+				vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR]
+					.cur_input = route.input;
+		}
+		if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				== INPUT_CVBS_VI4A)
+			*i = 0;
+		else if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				== INPUT_SVIDEO_VI2C_VI1C)
+			*i = 1;
+	} else {
+		*i = 0;
+	}
+
+	mutex_unlock(&vdev->mutex);
+
+	return rval;

-	return 0;
 }

 /**
@@ -939,10 +1008,30 @@ static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
  */
 static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
 {
-	if (i > 0)
-		return -EINVAL;
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval = 0;
+	struct v4l2_routing route;

-	return 0;
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		if (i == 0)
+			route.input = INPUT_CVBS_VI4A;
+		else
+			route.input = INPUT_SVIDEO_VI2C_VI1C;
+
+		route.output = 0;
+		rval = vidioc_int_s_video_routing(vdev->vdev_sensor, &route);
+		if (!rval)
+			vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				= route.input;
+	} else {
+		if (i > 0)
+			rval = -EINVAL;
+	}
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
 }

 /**
@@ -1434,11 +1523,60 @@ out:
 	return rval;
 }

-/*
+
+/**
+ * vidioc_querystd - V4L2 query current standard IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @std: standard V4L2 v4l2_std_id enum
  *
- * File operations.
+ * If using a "smart" sensor, just forwards request to the sensor driver,
+ * otherwise returns error
+ */
+static int vidioc_querystd(struct file *file, void *fh, v4l2_std_id *std)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval = 0;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		rval = vidioc_int_querystd(vdev->vdev_sensor, std);
+		if (rval == 0)
+			vdev->vfd->current_norm = *std;
+	} else
+		rval = -EINVAL;
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
+/**
+ * vidioc_s_std - V4L2 set standard IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @std: standard V4L2 v4l2_std_id enum
  *
+ * If using a "smart" sensor, just forwards request to the sensor driver,
+ * otherwise returns error
  */
+static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *std)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval = 0;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		rval = vidioc_int_s_std(vdev->vdev_sensor, std);
+		if (rval == 0)
+			vdev->vfd->current_norm = *std;
+	} else
+		rval = -EINVAL;
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}

 /**
  * omap34xxcam_poll - file operations poll handler
@@ -1565,6 +1703,8 @@ static int omap34xxcam_open(struct file *file)
 	if (!vdev->pix.width
 	    && vdev->vdev_sensor != v4l2_int_device_dummy()) {
 		memset(&format, 0, sizeof(format));
+		if (vdev->vdev_sensor_config.sensor_isp)
+			format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		if (vidioc_int_g_fmt_cap(vdev->vdev_sensor, &format)) {
 			dev_err(&vdev->vfd->dev,
 				"can't get current pix from sensor!\n");
@@ -1758,6 +1898,8 @@ static const struct v4l2_ioctl_ops omap34xxcam_ioctl_ops = {
 	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals	= vidioc_enum_frameintervals,
 	.vidioc_default			= vidioc_default,
+	.vidioc_s_std			 = vidioc_s_std,
+	.vidioc_querystd		 = vidioc_querystd,
 };

 /**
@@ -1777,6 +1919,7 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 	struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
 	struct omap34xxcam_hw_config hwc;
 	int rval;
+	struct v4l2_ifparm ifparm;

 	/* We need to check rval just once. The place is here. */
 	if (vidioc_int_g_priv(s, &hwc))
@@ -1857,6 +2000,12 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 			goto err;
 		}
 	}
+	/*Determine whether the slave connected is BT656 decoder or a sensor*/
+	if (!vidioc_int_g_ifparm(s, &ifparm))
+		if (ifparm.if_type == V4L2_IF_TYPE_BT656) {
+			vdev->vfd->current_norm	 = V4L2_STD_NTSC;
+			vdev->vfd->tvnorms = V4L2_STD_NTSC | V4L2_STD_PAL;
+		}

 	omap34xxcam_vfd_name_update(vdev);

diff --git a/drivers/media/video/omap34xxcam.h b/drivers/media/video/omap34xxcam.h
index 9859d15..727cacf 100644
--- a/drivers/media/video/omap34xxcam.h
+++ b/drivers/media/video/omap34xxcam.h
@@ -95,6 +95,7 @@ struct omap34xxcam_hw_config {
 		struct omap34xxcam_lens_config lens;
 		struct omap34xxcam_flash_config flash;
 	} u;
+	int cur_input;
 };

 /**
--
1.5.6

