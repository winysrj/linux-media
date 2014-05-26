Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaEZTuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 09/11] omap3isp: ccdc: Add basic support for interlaced video
Date: Mon, 26 May 2014 21:50:10 +0200
Message-Id: <1401133812-8745-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the CCDC input is interlaced enable the alternate field order on
the CCDC output video node. The field signal polarity is specified
through platform data.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c  | 21 ++++++++++++++++++++-
 drivers/media/platform/omap3isp/ispvideo.c |  6 ++++++
 drivers/media/platform/omap3isp/ispvideo.h |  2 ++
 include/media/omap3isp.h                   |  3 +++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 76d4fd7..49d7256 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1001,6 +1001,9 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	if (pdata && pdata->vs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
+	if (pdata && pdata->fld_pol)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
+
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* The CCDC_CFG.Y8POS bit is used in YCbCr8 input mode only. The
@@ -1140,6 +1143,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift, bridge);
 
+	/* Configure the sync interface. */
 	ccdc_config_sync_if(ccdc, pdata, depth_out);
 
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
@@ -1499,6 +1503,17 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		return 1;
 	}
 
+	/* When capturing fields in alternate order read the current field
+	 * identifier and store it in the pipeline.
+	 */
+	if (ccdc->formats[CCDC_PAD_SOURCE_OF].field == V4L2_FIELD_ALTERNATE) {
+		u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
+					     ISPCCDC_SYN_MODE);
+
+		pipe->field = syn_mode & ISPCCDC_SYN_MODE_FLDSTAT
+			    ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
+	}
+
 	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
 		dev_info(isp->dev, "CCDC won't become idle!\n");
 		isp->crashed |= 1U << ccdc->subdev.entity.id;
@@ -1830,6 +1845,11 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		/* Clamp the input size. */
 		fmt->width = clamp_t(u32, width, 32, 4096);
 		fmt->height = clamp_t(u32, height, 32, 4096);
+
+		/* Default to progressive field order. */
+		if (fmt->field == V4L2_FIELD_ANY)
+			fmt->field = V4L2_FIELD_NONE;
+
 		break;
 
 	case CCDC_PAD_SOURCE_OF:
@@ -1885,7 +1905,6 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 	 * stored on 2 bytes.
 	 */
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
-	fmt->field = V4L2_FIELD_NONE;
 }
 
 /*
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 756c162..c38f1d4 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -482,6 +482,11 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	else
 		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
 
+	if (pipe->field != V4L2_FIELD_NONE)
+		buf->vb.v4l2_buf.sequence /= 2;
+
+	buf->vb.v4l2_buf.field = pipe->field;
+
 	/* Report pipeline errors to userspace on the capture device side. */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
 		state = VB2_BUF_STATE_ERROR;
@@ -1038,6 +1043,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->queue = &vfh->queue;
 	INIT_LIST_HEAD(&video->dmaqueue);
 	atomic_set(&pipe->frame_number, -1);
+	pipe->field = vfh->format.fmt.pix.field;
 
 	mutex_lock(&video->queue_lock);
 	ret = vb2_streamon(&vfh->queue, type);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index a76124c..0b7efed 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -78,6 +78,7 @@ enum isp_pipeline_state {
 
 /*
  * struct isp_pipeline - An ISP hardware pipeline
+ * @field: The field being processed by the pipeline
  * @error: A hardware error occurred during capture
  * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
  */
@@ -91,6 +92,7 @@ struct isp_pipeline {
 	u32 entities;
 	unsigned long l3_ick;
 	unsigned int max_rate;
+	enum v4l2_field field;
 	atomic_t frame_number;
 	bool do_propagation; /* of frame number */
 	bool error;
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index c9d06d9..398279d 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -57,6 +57,8 @@ enum {
  *		0 - Active high, 1 - Active low
  * @vs_pol: Vertical synchronization polarity
  *		0 - Active high, 1 - Active low
+ * @fld_pol: Field signal polarity
+ *		0 - Positive, 1 - Negative
  * @data_pol: Data polarity
  *		0 - Normal, 1 - One's complement
  */
@@ -65,6 +67,7 @@ struct isp_parallel_platform_data {
 	unsigned int clk_pol:1;
 	unsigned int hs_pol:1;
 	unsigned int vs_pol:1;
+	unsigned int fld_pol:1;
 	unsigned int data_pol:1;
 };
 
-- 
1.8.5.5

