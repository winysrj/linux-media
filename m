Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ5cD8R017826
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 00:38:13 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJ5bubB014456
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 00:37:56 -0500
From: hvaibhav@ti.com
To: video4linux-list@redhat.com
Date: Fri, 19 Dec 2008 11:07:46 +0530
Message-Id: <1229665066-8098-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Cc: linux-omap@vger.kernel.org
Subject: [REVIEW PATCH] OMAP3 ISP-Camera: Added BT656 support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Support for BT656 through TVP5146 decoder, works on top of
ISP-Camera patches posted by Sergio on 12th Dec 2008.

The TVP514x driver patch has been accepted under V4L, will
be part of O-L in the next merge window. As of now you can
access the patches from -

http://markmail.org/search/?q=TVP514x#query:TVP514x%20from%3A%22Hiremath%2C%20Vaibhav%22%20extension%3Apatch+page:1+mid:b5pcj3sriwknm2cv+state:results

Patch has been tested on OMAP3EVM for BT656 support, these
changes will not affect the existing ensor support (verified
on OMAP3SDP board).

ToDO List:
    - Refresh the patch with the Sergio's updated
      ISP-Camera patches (Fix for review comments)

    - Add support for OMAP3 Mass Market Daughter Card

    - Add support for scaling and cropping

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Manjunath Hadli <mrh@ti.com>
Signed-off-by: R Sivaraj <sivaraj@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/isp/isp.c     |  121 ++++++++++++++++++++---
 drivers/media/video/isp/isp.h     |    7 +-
 drivers/media/video/isp/ispccdc.c |  132 ++++++++++++++++++++++---
 drivers/media/video/isp/ispccdc.h |    9 ++
 drivers/media/video/omap34xxcam.c |  197 +++++++++++++++++++++++++++++++++----
 drivers/media/video/omap34xxcam.h |    5 +
 6 files changed, 424 insertions(+), 47 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index f117f36..a64b8bf 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -191,6 +191,7 @@ struct isp_sgdma ispsg;
  * @resizer_input_height: ISP Resizer module input image height.
  * @resizer_output_width: ISP Resizer module output image width.
  * @resizer_output_height: ISP Resizer module output image height.
+ * @current_field: Current field for interlaced capture.
  */
 struct ispmodule {
 	unsigned int isp_pipeline;
@@ -209,6 +210,7 @@ struct ispmodule {
 	unsigned int resizer_input_height;
 	unsigned int resizer_output_width;
 	unsigned int resizer_output_height;
+	int current_field;
 };

 static struct ispmodule ispmodule_obj = {
@@ -224,11 +226,14 @@ static struct ispmodule ispmodule_obj = {
 		.colorspace = V4L2_COLORSPACE_JPEG,
 		.priv = 0,
 	},
+	.current_field = 0,
 };

 /* Structure for saving/restoring ISP module registers */
 static struct isp_reg isp_reg_list[] = {
 	{ISP_SYSCONFIG, 0},
+	{ISP_IRQ0ENABLE, 0},
+	{ISP_IRQ1ENABLE, 0},
 	{ISP_TCTRL_GRESET_LENGTH, 0},
 	{ISP_TCTRL_PSTRB_REPLAY, 0},
 	{ISP_CTRL, 0},
@@ -550,6 +555,11 @@ EXPORT_SYMBOL(isp_unset_callback);
  **/
 int isp_request_interface(enum isp_interface_type if_t)
 {
+	enum isp_interface_type temp_if_t = if_t;
+
+	if (if_t == ISP_PARLL_YUV_BT)
+		if_t = ISP_PARLL;
+
 	if (isp_obj.if_status & if_t) {
 		DPRINTK_ISPCTRL("ISP_ERR : Requested Interface already \
 			allocated\n");
@@ -569,7 +579,7 @@ int isp_request_interface(enum isp_interface_type if_t)
 				((isp_obj.if_status == ISP_CSIB) &&
 				(if_t == ISP_CSIA)) ||
 				(isp_obj.if_status == 0)) {
-		isp_obj.if_status |= if_t;
+		isp_obj.if_status |= (if_t | temp_if_t);
 		return 0;
 	} else {
 		DPRINTK_ISPCTRL("ISP_ERR : Invalid Combination Serial- \
@@ -590,6 +600,9 @@ EXPORT_SYMBOL(isp_request_interface);
  **/
 int isp_free_interface(enum isp_interface_type if_t)
 {
+	if ((if_t == ISP_PARLL) || (if_t == ISP_PARLL_YUV_BT))
+		if_t |= (ISP_PARLL | ISP_PARLL_YUV_BT);
+
 	isp_obj.if_status &= ~if_t;
 	return 0;
 }
@@ -891,6 +904,7 @@ int isp_configure_interface(struct isp_interface_config *config)
 	ispctrl_val &= (ISPCTRL_PAR_SER_CLK_SEL_MASK);
 	switch (config->ccdc_par_ser) {
 	case ISP_PARLL:
+	case ISP_PARLL_YUV_BT:
 		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
 		ispctrl_val |= (config->u.par.par_clk_pol
 						<< ISPCTRL_PAR_CLK_POL_SHIFT);
@@ -1348,9 +1362,14 @@ u32 isp_calc_pipeline(struct v4l2_pix_format *pix_input,
 		ispccdc_request();
 		if (pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10)
 			ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP_MEM);
-		else
-			ispccdc_config_datapath(CCDC_YUV_SYNC,
-							CCDC_OTHERS_MEM);
+		else {
+			if (isp_obj.if_status & ISP_PARLL_YUV_BT)
+				ispccdc_config_datapath(CCDC_YUV_BT,
+						CCDC_OTHERS_MEM);
+			else
+				ispccdc_config_datapath(CCDC_YUV_SYNC,
+						CCDC_OTHERS_MEM);
+		}
 	}
 	return 0;
 }
@@ -1384,6 +1403,31 @@ void isp_config_pipeline(struct v4l2_pix_format *pix_input,
 			ispmodule_obj.resizer_output_width,
 			ispmodule_obj.resizer_output_height);
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
+	if (isp_obj.if_status & ISP_PARLL_YUV_BT)
+		ispccdc_config_outlineoffset(ispmodule_obj.pix.bytesperline,
+						0, 0);

 	if (pix_output->pixelformat == V4L2_PIX_FMT_UYVY) {
 		isppreview_config_ycpos(YCPOS_YCrYCb);
@@ -1410,9 +1454,23 @@ void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2)
 	int notify = 0;
 	int rval = 0;
 	unsigned long flags;
+	unsigned long fld_stat = (omap_readl(ISPCCDC_SYN_MODE) >> 15) & 0x1;

 	switch (status) {
 	case CCDC_VD0:
+		if (ispmodule_obj.pix.field == V4L2_FIELD_INTERLACED) {
+			spin_lock(&isp_obj.isp_temp_buf_lock);
+			/* Skip even fields */
+			if (ispmodule_obj.current_field != fld_stat) {
+				if (fld_stat == 0)
+					ispmodule_obj.current_field = fld_stat;
+
+				spin_unlock(&isp_obj.isp_temp_buf_lock);
+				return;
+			}
+			spin_unlock(&isp_obj.isp_temp_buf_lock);
+		}
+
 		ispccdc_config_shadow_registers();
 		if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
 			(ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
@@ -1430,6 +1488,20 @@ void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2)
 		}
 		break;
 	case CCDC_VD1:
+		if (ispmodule_obj.pix.field == V4L2_FIELD_INTERLACED) {
+			spin_lock(&isp_obj.isp_temp_buf_lock);
+			if (ispmodule_obj.current_field != fld_stat) {
+				if (fld_stat == 0)
+					ispmodule_obj.current_field = fld_stat;
+
+				spin_unlock(&isp_obj.isp_temp_buf_lock);
+				return;
+			}
+			spin_unlock(&isp_obj.isp_temp_buf_lock);
+			if (fld_stat == 0)	/* Skip even fields */
+				return;
+		}
+
 		if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
 				(ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
 			return;
@@ -1476,13 +1548,26 @@ void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2)
 		}
 		break;
 	case HS_VS:
-		spin_lock(&isp_obj.isp_temp_buf_lock);
-		if (ispmodule_obj.isp_temp_state == ISP_BUF_TRAN) {
-			isp_CCDC_VD01_enable();
-			ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+		if (ispmodule_obj.pix.field == V4L2_FIELD_INTERLACED) {
+			ispmodule_obj.current_field ^= 1;
+			spin_lock(&isp_obj.isp_temp_buf_lock);
+			if ((ispmodule_obj.isp_temp_state == ISP_BUF_TRAN) &&
+					(fld_stat == 1)) {
+				isp_CCDC_VD01_enable();
+				ispmodule_obj.current_field = fld_stat;
+				ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+			}
+			spin_unlock(&isp_obj.isp_temp_buf_lock);
+			return;
+		} else {
+			spin_lock(&isp_obj.isp_temp_buf_lock);
+			if (ispmodule_obj.isp_temp_state == ISP_BUF_TRAN) {
+				isp_CCDC_VD01_enable();
+				ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+			}
+			spin_unlock(&isp_obj.isp_temp_buf_lock);
+			return;
 		}
-		spin_unlock(&isp_obj.isp_temp_buf_lock);
-		return;
 	default:
 		return;
 	}
@@ -2204,15 +2289,25 @@ int isp_try_fmt(struct v4l2_pix_format *pix_input,
 	if (ifmt == NUM_ISP_CAPTURE_FORMATS)
 		ifmt = 1;
 	pix_output->pixelformat = isp_formats[ifmt].pixelformat;
-	pix_output->field = V4L2_FIELD_NONE;
-	pix_output->bytesperline = pix_output->width * ISP_BYTES_PER_PIXEL;
+
+	if (isp_obj.if_status & ISP_PARLL_YUV_BT)
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
+		if (isp_obj.if_status & ISP_PARLL_YUV_BT)
+			pix_output->colorspace = pix_input->colorspace;
+		else
+			pix_output->colorspace = V4L2_COLORSPACE_JPEG;
 		break;
 	default:
 		pix_output->colorspace = V4L2_COLORSPACE_SRGB;
diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
index aac7056..27f192a 100644
--- a/drivers/media/video/isp/isp.h
+++ b/drivers/media/video/isp/isp.h
@@ -73,7 +73,8 @@ typedef void (*isp_callback_t) (unsigned long status,
 enum isp_interface_type {
 	ISP_PARLL = 1,
 	ISP_CSIA = 2,
-	ISP_CSIB = 4
+	ISP_CSIB = 4,
+	ISP_PARLL_YUV_BT = 8
 };

 enum isp_irqevents {
@@ -302,6 +303,10 @@ int isp_try_size(struct v4l2_pix_format *pix_input,
 int isp_try_fmt(struct v4l2_pix_format *pix_input,
 					struct v4l2_pix_format *pix_output);

+int isp_configure_std(struct v4l2_pix_format *fmt);
+
+int isp_check_format(struct v4l2_pix_format *pixfmt);
+
 int isp_handle_private(int cmd, void *arg);

 void isp_save_context(struct isp_reg *);
diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index 9167f54..259606d 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -567,8 +567,10 @@ int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 		syn_mode |= ISPCCDC_SYN_MODE_WEN;
 		syn_mode &= ~ISPCCDC_SYN_MODE_EXWEN;
-		omap_writel((omap_readl(ISPCCDC_CFG)) & ~ISPCCDC_CFG_WENLOG,
-								ISPCCDC_CFG);
+		omap_writel((omap_readl(ISPCCDC_CFG)) &
+				~ISPCCDC_CFG_WENLOG,
+				ISPCCDC_CFG);
+
 		vpcfg.bitshift_sel = BIT11_2;
 		vpcfg.freq_sel = PIXCLKBY2;
 		ispccdc_config_vp(vpcfg);
@@ -627,12 +629,28 @@ int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
 		syncif.hdpol = 0;
 		syncif.ipmod = YUV16;
 		syncif.vdpol = 0;
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
@@ -677,6 +695,8 @@ void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
 		break;
 	case YUV8:
 		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+		if (syncif.bt_r656_en)
+			syn_mode |= ISPCCDC_SYN_MODE_PACK8;
 		break;
 	};

@@ -741,6 +761,11 @@ void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
 		omap_writel((omap_readl(ISPCCDC_REC656IF)) &
 						~ISPCCDC_REC656IF_R656ON,
 						ISPCCDC_REC656IF);
+	} else {
+		omap_writel((omap_readl(ISPCCDC_REC656IF)) |
+				(ISPCCDC_REC656IF_R656ON |
+				 ISPCCDC_REC656IF_ECCFVH),
+				ISPCCDC_REC656IF);
 	}
 }
 EXPORT_SYMBOL(ispccdc_config_sync_if);
@@ -1178,35 +1203,78 @@ int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h)
 	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) {
 		omap_writel(0, ISPCCDC_VP_OUT);
 		if (cpu_is_omap3410()) {
-			omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+			if (ispccdc_obj.ccdc_inpfmt != CCDC_YUV_BT)
+				omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
 						((ispccdc_obj.ccdcout_w - 1) <<
-						ISPCCDC_HORZ_INFO_NPH_SHIFT),
+						 ISPCCDC_HORZ_INFO_NPH_SHIFT),
 						ISPCCDC_HORZ_INFO);
+			else
+				omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+					(((ispccdc_obj.ccdcout_w << 1) - 1) <<
+					 ISPCCDC_HORZ_INFO_NPH_SHIFT),
+					ISPCCDC_HORZ_INFO);
 		} else {
-			if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
-				omap_writel(1 << ISPCCDC_HORZ_INFO_SPH_SHIFT
+			if (ispccdc_obj.ccdc_inpfmt != CCDC_YUV_BT) {
+				if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
+					omap_writel(1 << ISPCCDC_HORZ_INFO_SPH_SHIFT
 						| ((ispccdc_obj.ccdcout_w - 1)
 						<< ISPCCDC_HORZ_INFO_NPH_SHIFT),
 						ISPCCDC_HORZ_INFO);
-			} else {
-				omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
+				else
+					omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
 						| ((ispccdc_obj.ccdcout_w - 1)
 						<< ISPCCDC_HORZ_INFO_NPH_SHIFT),
 						ISPCCDC_HORZ_INFO);
-			}
+			} else
+				omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+					(((ispccdc_obj.ccdcout_w << 1) - 1) <<
+					 ISPCCDC_HORZ_INFO_NPH_SHIFT),
+					ISPCCDC_HORZ_INFO);
+		}
+
+		if (ispccdc_obj.ccdc_inpfmt != CCDC_YUV_BT) {
+			omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+					ISPCCDC_VERT_START);
+			omap_writel((ispccdc_obj.ccdcout_h - 1) <<
+					ISPCCDC_VERT_LINES_NLV_SHIFT,
+					ISPCCDC_VERT_LINES);
+		} else {
+			omap_writel(2 << ISPCCDC_VERT_START_SLV0_SHIFT |
+					2 << ISPCCDC_VERT_START_SLV1_SHIFT,
+					ISPCCDC_VERT_START);
+			omap_writel(((ispccdc_obj.ccdcout_h >> 1) - 1) <<
+					ISPCCDC_VERT_LINES_NLV_SHIFT,
+					ISPCCDC_VERT_LINES);
 		}
-		omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
-							ISPCCDC_VERT_START);
-		omap_writel((ispccdc_obj.ccdcout_h - 1) <<
-						ISPCCDC_VERT_LINES_NLV_SHIFT,
-						ISPCCDC_VERT_LINES);

 		ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
-		omap_writel((((ispccdc_obj.ccdcout_h - 2) &
+
+		if (ispccdc_obj.ccdc_inpfmt != CCDC_YUV_BT) {
+			omap_writel((((ispccdc_obj.ccdcout_h - 2) &
 					ISPCCDC_VDINT_0_MASK) <<
 					ISPCCDC_VDINT_0_SHIFT) |
 					((50 & ISPCCDC_VDINT_1_MASK) <<
 					ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+		} else {
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					EVENEVEN,
+					1);
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					ODDEVEN,
+					1);
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					EVENODD,
+					1);
+			ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2,
+					ODDODD,
+					1);
+
+			omap_writel(((((ispccdc_obj.ccdcout_h >> 1) - 1) &
+					ISPCCDC_VDINT_0_MASK) <<
+					ISPCCDC_VDINT_0_SHIFT) |
+					((50 & ISPCCDC_VDINT_1_MASK) <<
+					 ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+		}
 	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP_MEM) {
 		omap_writel((1 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
 					(ispccdc_obj.ccdcin_w <<
@@ -1356,6 +1424,40 @@ void ispccdc_enable(u8 enable)
 EXPORT_SYMBOL(ispccdc_enable);

 /**
+ * ispccdc_config_y8pos - Configures the location of Y color component
+ * @mode: Y8POS_EVEN Y pixel in even position, otherwise Y pixel in odd
+ *
+ * Configures the location of Y color componenent for YCbCr 8-bit data
+ */
+void ispccdc_config_y8pos(enum y8pos_mode mode)
+{
+	if (mode == Y8POS_EVEN)
+		omap_writel(omap_readl(ISPCCDC_CFG) & ~(ISPCCDC_CFG_Y8POS),
+				ISPCCDC_CFG);
+	else
+		omap_writel(omap_readl(ISPCCDC_CFG) | (ISPCCDC_CFG_Y8POS),
+				ISPCCDC_CFG);
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
+	if (swap)
+		omap_writel(omap_readl(ISPCCDC_CFG) | (ISPCCDC_CFG_BSWD),
+				ISPCCDC_CFG);
+	else
+		omap_writel(omap_readl(ISPCCDC_CFG) & ~(ISPCCDC_CFG_BSWD),
+				ISPCCDC_CFG);
+}
+EXPORT_SYMBOL(ispccdc_config_byteswap);
+
+/**
  * ispccdc_busy - Gets busy state of the CCDC.
  **/
 int ispccdc_busy(void)
diff --git a/drivers/media/video/isp/ispccdc.h b/drivers/media/video/isp/ispccdc.h
index 9ee67ce..a5e7b14 100644
--- a/drivers/media/video/isp/ispccdc.h
+++ b/drivers/media/video/isp/ispccdc.h
@@ -66,6 +66,11 @@ enum datasize {
 	DAT12
 };

+/* Enumeration constants for location of Y component in 8-bit YUV data */
+enum y8pos_mode {
+	Y8POS_EVEN = 0,
+	Y8POS_ODD = 1
+};

 /**
  * struct ispccdc_syncif - Structure for Sync Interface between sensor and CCDC
@@ -197,6 +202,10 @@ int ispccdc_set_outaddr(u32 addr);

 void ispccdc_enable(u8 enable);

+void ispccdc_config_y8pos(enum y8pos_mode mode);
+
+void ispccdc_config_byteswap(int swap);
+
 int ispccdc_busy(void);

 void ispccdc_save_context(void);
diff --git a/drivers/media/video/omap34xxcam.c b/drivers/media/video/omap34xxcam.c
index 31b6b60..e90e7e8 100644
--- a/drivers/media/video/omap34xxcam.c
+++ b/drivers/media/video/omap34xxcam.c
@@ -56,6 +56,8 @@
 #include "isp/isppreview.h"
 #include "isp/ispresizer.h"

+#include <media/tvp514x.h>
+
 #define OMAP34XXCAM_VERSION KERNEL_VERSION(0, 0, 0)

 /* global variables */
@@ -262,7 +264,8 @@ static int omap34xxcam_vbq_prepare(struct videobuf_queue *vbq,
 	 */
 	if (vb->baddr) {
 		/* This is a userspace buffer. */
-		if (fh->pix.sizeimage > vb->bsize)
+		if ((fh->pix.sizeimage > vb->bsize) ||
+				vb->baddr != (vb->baddr & ~0x1F))
 			/* The buffer isn't big enough. */
 			return -EINVAL;
 	} else {
@@ -379,7 +382,9 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh,
 	struct omap34xxcam_videodev *vdev = ofh->vdev;
 	int rval;

-	if (vdev->vdev_sensor_config.sensor_isp)
+	if (vdev->vdev_sensor_mode)
+		rval = isp_enum_fmt_cap(f);
+	else if (vdev->vdev_sensor_config.sensor_isp)
 		rval = vidioc_int_enum_fmt_cap(vdev->vdev_sensor, f);
 	else
 		rval = isp_enum_fmt_cap(f);
@@ -403,7 +408,10 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *fh,
 	struct omap34xxcam_videodev *vdev = ofh->vdev;

 	mutex_lock(&vdev->mutex);
-	f->fmt.pix = ofh->pix;
+	if (vdev->vdev_sensor_mode)
+		isp_g_fmt_cap(&f->fmt.pix);
+	else
+		f->fmt.pix = ofh->pix;
 	mutex_unlock(&vdev->mutex);

 	return 0;
@@ -607,20 +615,44 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
 	struct v4l2_pix_format pix_tmp;
 	struct v4l2_fract timeperframe;
 	int rval;
+	struct v4l2_format input_fmt = *f;

 	mutex_lock(&vdev->mutex);
 	if (vdev->streaming) {
 		rval = -EBUSY;
 		goto out;
 	}
+	if (vdev->vdev_sensor_mode) {
+		struct v4l2_pix_format *pix = &f->fmt.pix;
+		rval = isp_try_fmt_cap(pix, pix);
+		if (rval)
+			goto out;

-	vdev->want_pix = f->fmt.pix;
+		/* Always negotiate with the sensor first */
+		rval = vidioc_int_s_fmt_cap(vdev->vdev_sensor, &input_fmt);
+		if (rval)
+			goto out;

-	timeperframe = vdev->want_timeperframe;
+		pix->width = input_fmt.fmt.pix.width;
+		pix->height = input_fmt.fmt.pix.height;
+		pix->pixelformat = input_fmt.fmt.pix.pixelformat;
+		pix->field = input_fmt.fmt.pix.field;
+		pix->bytesperline = input_fmt.fmt.pix.bytesperline;
+		pix->colorspace = input_fmt.fmt.pix.colorspace;
+		pix->sizeimage = input_fmt.fmt.pix.sizeimage;

-	rval = s_pix_parm(vdev, &pix_tmp, &f->fmt.pix, &timeperframe);
-	pix_tmp = f->fmt.pix;
+		/* Negotiate with OMAP3 ISP */
+		rval = isp_s_fmt_cap(pix, pix);
+		if (!rval)
+			pix_tmp = f->fmt.pix;
+	} else {
+		vdev->want_pix = f->fmt.pix;

+		timeperframe = vdev->want_timeperframe;
+
+		rval = s_pix_parm(vdev, &pix_tmp, &f->fmt.pix, &timeperframe);
+		pix_tmp = f->fmt.pix;
+	}
 out:
 	mutex_unlock(&vdev->mutex);

@@ -859,15 +891,28 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 static int vidioc_enum_input(struct file *file, void *fh,
 			     struct v4l2_input *inp)
 {
-	if (inp->index > 0)
-		return -EINVAL;
-
-	strlcpy(inp->name, "camera", sizeof(inp->name));
-	inp->type = V4L2_INPUT_TYPE_CAMERA;
-
+	struct omap34xxcam_videodev *vdev = ((struct omap34xxcam_fh *)fh)->vdev;
+
+	if (vdev->vdev_sensor_mode) {
+		if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				== INPUT_CVBS_VI2B) {
+			strlcpy(inp->name, "COMPOSITE", sizeof(inp->name));
+			inp->type = V4L2_INPUT_TYPE_CAMERA;
+		} else if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR]
+				.cur_input == INPUT_SVIDEO_VI2C_VI1C) {
+			strlcpy(inp->name, "S-VIDEO", sizeof(inp->name));
+			inp->type = V4L2_INPUT_TYPE_CAMERA;
+		}
+	} else {
+		if (inp->index > 0)
+			return -EINVAL;
+		strlcpy(inp->name, "camera", sizeof(inp->name));
+		inp->type = V4L2_INPUT_TYPE_CAMERA;
+	}
 	return 0;
 }

+
 /**
  * vidioc_g_input - V4L2 get input IOCTL handler
  * @file: ptr. to system file structure
@@ -878,9 +923,35 @@ static int vidioc_enum_input(struct file *file, void *fh,
  */
 static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
 {
-	*i = 0;
+	struct omap34xxcam_videodev *vdev = ((struct omap34xxcam_fh *)fh)->vdev;
+	int rval = 0;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_mode) {
+		if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				== 0) {
+			struct v4l2_routing route;
+			route.input = INPUT_CVBS_VI2B;
+			route.output = 0;
+			rval = vidioc_int_s_video_routing(vdev->vdev_sensor,
+					&route);
+			if (!rval)
+				vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR]
+					.cur_input = route.input;
+		}
+		if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				== INPUT_CVBS_VI2B)
+			*i = 0;
+		else if (vdev->slave_config[OMAP34XXCAM_SLAVE_SENSOR].cur_input
+				== INPUT_SVIDEO_VI2C_VI1C)
+			*i = 1;
+	} else
+		*i = 0;
+
+	mutex_unlock(&vdev->mutex);
+
+	return rval;

-	return 0;
 }

 /**
@@ -893,10 +964,30 @@ static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
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
+	if (vdev->vdev_sensor_mode) {
+		if (i == 0)
+			route.input = INPUT_CVBS_VI2B;
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
@@ -1381,6 +1472,61 @@ out:
 	return rval;
 }

+
+/**
+ * vidioc_querystd - V4L2 query current standard IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @std: standard V4L2 v4l2_std_id enum
+ *
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
+	if (vdev->vdev_sensor_mode) {
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
+ *
+ * If using a "smart" sensor, just forwards request to the sensor driver,
+ * otherwise returns error
+ */
+static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *std)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval = 0;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_mode) {
+		rval = vidioc_int_s_std(vdev->vdev_sensor, std);
+		if (rval == 0)
+			vdev->vfd->current_norm = *std;
+	} else
+		rval = -EINVAL;
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
 /*
  *
  * File operations.
@@ -1683,6 +1829,8 @@ static const struct v4l2_ioctl_ops omap34xxcam_ioctl_ops = {
 	.vidioc_g_crop		 = vidioc_g_crop,
 	.vidioc_s_crop		 = vidioc_s_crop,
 	.vidioc_default		 = vidioc_default,
+	.vidioc_s_std	 	= vidioc_s_std,
+	.vidioc_querystd	= vidioc_querystd,
 };

 /**
@@ -1704,6 +1852,7 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 	struct omap34xxcam_hw_config hwc;
 	struct video_device *vfd;
 	int rval;
+	struct v4l2_ifparm ifparm;

 	/* We need to check rval just once. The place is here. */
 	if (vidioc_int_g_priv(s, &hwc))
@@ -1783,6 +1932,18 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 	} else {
 		vfd = vdev->vfd;
 	}
+	/*Determine whether the slave connected is BT656 decoder or a sensor*/
+	if (!vidioc_int_g_ifparm(s, &ifparm)) {
+		if (ifparm.if_type == V4L2_IF_TYPE_BT656) {
+			vfd->current_norm	 = V4L2_STD_NTSC;
+			vfd->tvnorms		 = V4L2_STD_NTSC | V4L2_STD_PAL;
+			if ((ifparm.u.bt656.mode ==
+					V4L2_IF_TYPE_BT656_MODE_BT_8BIT) ||
+					(ifparm.u.bt656.mode ==
+					 V4L2_IF_TYPE_BT656_MODE_BT_10BIT))
+				vdev->slave_mode[hwc.dev_type] = 1;
+		}
+	}

 	omap34xxcam_vfd_name_update(vdev);

diff --git a/drivers/media/video/omap34xxcam.h b/drivers/media/video/omap34xxcam.h
index 36f7fd5..39e581c 100644
--- a/drivers/media/video/omap34xxcam.h
+++ b/drivers/media/video/omap34xxcam.h
@@ -92,6 +92,7 @@ struct omap34xxcam_hw_config {
 		struct omap34xxcam_lens_config lens;
 		struct omap34xxcam_flash_config flash;
 	} u;
+	int cur_input;
 };

 /**
@@ -155,6 +156,10 @@ struct omap34xxcam_videodev {
 #define vdev_lens_config slave_config[OMAP34XXCAM_SLAVE_LENS].u.lens
 #define vdev_flash_config slave_config[OMAP34XXCAM_SLAVE_FLASH].u.flash
 	struct omap34xxcam_hw_config slave_config[OMAP34XXCAM_SLAVE_FLASH + 1];
+#define vdev_sensor_mode slave_mode[OMAP34XXCAM_SLAVE_SENSOR]
+#define vdev_lens_mode slave_mode[OMAP34XXCAM_SLAVE_LENS]
+#define vdev_flash_mode slave_mode[OMAP34XXCAM_SLAVE_FLASH]
+	int slave_mode[OMAP34XXCAM_SLAVE_FLASH + 1];

 	/*** capture data ***/
 	struct v4l2_fract want_timeperframe;
--
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
