Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaEZTuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:08 -0400
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
Subject: [PATCH 11/11] omap3isp: ccdc: Add support for BT.656 YUV format at the CCDC input
Date: Mon, 26 May 2014 21:50:12 +0200
Message-Id: <1401133812-8745-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Query the CCDC input media bus type from the subdev connected to the
CCDC sink pad and configure the CCDC accordingly to support BT.656
synchronization.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 94 +++++++++++++++++++++++++------
 drivers/media/platform/omap3isp/ispccdc.h |  2 +
 2 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 8d1861d..150bbf0 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -970,10 +970,16 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
 	    format->code == V4L2_MBUS_FMT_UYVY8_2X8) {
-		/* The bridge is enabled for YUV8 formats. Configure the input
-		 * mode accordingly.
+		/* According to the OMAP3 TRM the input mode only affects SYNC
+		 * mode, enabling BT.656 mode should take precedence. However,
+		 * in practice setting the input mode to YCbCr data on 8 bits
+		 * seems to be required in BT.656 mode. In SYNC mode set it to
+		 * YCbCr on 16 bits as the bridge is enabled in that case.
 		 */
-		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+		if (ccdc->bt656)
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+		else
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
 	}
 
 	switch (data_size) {
@@ -997,7 +1003,10 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	if (pdata && pdata->hs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
 
-	if (pdata && pdata->vs_pol)
+	/* The polarity of the vertical sync signal output by the BT.656
+	 * decoder is not documented and seems to be active low.
+	 */
+	if ((pdata && pdata->vs_pol) || ccdc->bt656)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
 	if (pdata && pdata->fld_pol)
@@ -1015,8 +1024,16 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
 			    ISPCCDC_CFG_Y8POS);
 
-	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-		    ISPCCDC_REC656IF_R656ON);
+	/* Enable or disable BT.656 mode, including error correction for the
+	 * synchronization codes.
+	 */
+	if (ccdc->bt656)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
+
 }
 
 /* CCDC formats descriptions */
@@ -1107,20 +1124,32 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	unsigned long flags;
 	unsigned int bridge;
 	unsigned int shift;
+	unsigned int nph;
+	unsigned int sph;
 	u32 syn_mode;
 	u32 ccdc_pattern;
 
+	ccdc->bt656 = false;
+
 	pad = media_entity_remote_pad(&ccdc->pads[CCDC_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
-	if (ccdc->input == CCDC_INPUT_PARALLEL)
+	if (ccdc->input == CCDC_INPUT_PARALLEL) {
+		struct v4l2_mbus_config cfg;
+		int ret;
+
+		ret = v4l2_subdev_call(sensor, video, g_mbus_config, &cfg);
+		if (!ret)
+			ccdc->bt656 = cfg.type == V4L2_MBUS_BT656;
+
 		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
 			->bus.parallel;
+	}
 
 	/* CCDC_PAD_SINK */
 	format = &ccdc->formats[CCDC_PAD_SINK];
 
 	/* Compute the lane shifter shift value and enable the bridge when the
-	 * input format is YUV.
+	 * input format is a non-BT.656 YUV variant.
 	 */
 	fmt_src.pad = pad->index;
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
@@ -1133,7 +1162,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	depth_out = fmt_info->width;
 	shift = depth_in - depth_out;
 
-	if (fmt_info->code == V4L2_MBUS_FMT_YUYV8_2X8)
+	if (ccdc->bt656)
+		bridge = ISPCTRL_PAR_BRIDGE_DISABLE;
+	else if (fmt_info->code == V4L2_MBUS_FMT_YUYV8_2X8)
 		bridge = ISPCTRL_PAR_BRIDGE_LENDIAN;
 	else if (fmt_info->code == V4L2_MBUS_FMT_UYVY8_2X8)
 		bridge = ISPCTRL_PAR_BRIDGE_BENDIAN;
@@ -1194,10 +1225,24 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
 	crop = &ccdc->crop;
 
-	isp_reg_writel(isp, (crop->left << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
-		       ((crop->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+	/* The horizontal coordinates are expressed in pixel clock cycles. We
+	 * need two cycles per pixel in BT.656 mode, and one cycle per pixel in
+	 * SYNC mode regardless of the format as the bridge is enabled for YUV
+	 * formats in that case.
+	 */
+	if (ccdc->bt656) {
+		sph = crop->left * 2;
+		nph = crop->width * 2 - 1;
+	} else {
+		sph = crop->left;
+		nph = crop->width - 1;
+	}
+
+	isp_reg_writel(isp, (sph << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+		       (nph << ISPCCDC_HORZ_INFO_NPH_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
-	isp_reg_writel(isp, crop->top << ISPCCDC_VERT_START_SLV0_SHIFT,
+	isp_reg_writel(isp, (crop->top << ISPCCDC_VERT_START_SLV0_SHIFT) |
+		       (crop->top << ISPCCDC_VERT_START_SLV1_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
 	isp_reg_writel(isp, (crop->height - 1)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
@@ -1225,8 +1270,11 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
 			    ISPCCDC_CFG_BSWD);
 
-	/* Use PACK8 mode for 1byte per pixel formats. */
-	if (omap3isp_video_format_info(format->code)->width <= 8)
+	/* Use PACK8 mode for 1byte per pixel formats. Check for BT.656 mode
+	 * explicitly as the driver reports 1X16 instead of 2X8 at the OF pad
+	 * for simplicity.
+	 */
+	if (omap3isp_video_format_info(format->code)->width <= 8 || ccdc->bt656)
 		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
@@ -1598,6 +1646,16 @@ static void ccdc_vd1_isr(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
 
+	/* In BT.656 mode the CCDC doesn't generate an HS/VS interrupt. We thus
+	 * need to increment the frame counter here.
+	 */
+	if (ccdc->bt656) {
+		struct isp_pipeline *pipe =
+			to_isp_pipeline(&ccdc->subdev.entity);
+
+		atomic_inc(&pipe->frame_number);
+	}
+
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
 
 	/*
@@ -1885,8 +1943,12 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		field = fmt->field;
 		*fmt = *__ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
 
-		/* YUV formats are converted from 2X8 to 1X16 by the bridge and
-		 * can be byte-swapped.
+		/* In SYNC mode the bridge converts YUV formats from 2X8 to
+		 * 1X16. In BT.656 no such conversion occurs. As we don't know
+		 * at this point whether the source will use SYNC or BT.656 mode
+		 * let's pretend the conversion always occurs. The CCDC will be
+		 * configured to pack bytes in BT.656, hiding the inaccuracy.
+		 * In all cases bytes can be swapped.
 		 */
 		if (fmt->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
 		    fmt->code == V4L2_MBUS_FMT_UYVY8_2X8) {
diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index dd999be..c325b89 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -113,6 +113,7 @@ struct ispccdc_lsc {
  * @lsc: Lens shading compensation configuration
  * @update: Bitmask of controls to update during the next interrupt
  * @shadow_update: Controls update in progress by userspace
+ * @bt656: Whether the input interface uses BT.656 synchronization
  * @underrun: A buffer underrun occurred and a new buffer has been queued
  * @state: Streaming state
  * @lock: Serializes shadow_update with interrupt handler
@@ -141,6 +142,7 @@ struct isp_ccdc_device {
 	unsigned int update;
 	unsigned int shadow_update;
 
+	bool bt656;
 	unsigned int underrun:1;
 	enum isp_pipeline_stream_state state;
 	spinlock_t lock;
-- 
1.8.5.5

