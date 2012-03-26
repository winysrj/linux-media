Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55242 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab2CZOmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 10:42:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/3] omap3isp: preview: Shorten shadow update delay
Date: Mon, 26 Mar 2012 16:42:31 +0200
Message-Id: <1332772951-19108-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When applications modify preview engine parameters, the new values are
applied to the hardware by the preview engine interrupt handler during
vertical blanking. If the parameters are being changed when the
interrupt handler is called, it just delays applying the parameters
until the next frame.

If an application modifies the parameters for every frame, and the
preview engine interrupt is triggerred synchronously, the parameters are
never applied to the hardware.

Fix this by storing new parameters in a shadow copy, and replace the
active parameters with the shadow values atomically.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  122 ++++++++++++++++++++---------
 drivers/media/video/omap3isp/isppreview.h |   19 +++--
 2 files changed, 95 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 2b5c137..34fecc9 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -649,12 +649,17 @@ preview_config_rgb_to_ycbcr(struct isp_prev_device *prev, const void *prev_csc)
 static void
 preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
 {
-	struct prev_params *params = &prev->params;
+	struct prev_params *params;
+	unsigned long flags;
+
+	spin_lock_irqsave(&prev->params.lock, flags);
+	params = prev->params.active;
 
 	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
 		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
-		prev->update |= PREV_CONTRAST;
+		params->update |= PREV_CONTRAST;
 	}
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 /*
@@ -681,12 +686,17 @@ preview_config_contrast(struct isp_prev_device *prev, const void *params)
 static void
 preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
 {
-	struct prev_params *params = &prev->params;
+	struct prev_params *params;
+	unsigned long flags;
+
+	spin_lock_irqsave(&prev->params.lock, flags);
+	params = prev->params.active;
 
 	if (params->brightness != (brightness * ISPPRV_BRIGHT_UNITS)) {
 		params->brightness = brightness * ISPPRV_BRIGHT_UNITS;
-		prev->update |= PREV_BRIGHTNESS;
+		params->update |= PREV_BRIGHTNESS;
 	}
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 /*
@@ -886,20 +896,24 @@ static int preview_config(struct isp_prev_device *prev,
 			  struct omap3isp_prev_update_config *cfg)
 {
 	struct prev_params *params;
+	struct prev_params *shadow;
 	struct preview_update *attr;
+	unsigned long flags;
 	int i, bit, rval = 0;
 
-	params = &prev->params;
 	if (cfg->update == 0)
 		return 0;
 
-	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
-		unsigned long flags;
+	params = kmalloc(sizeof(*params), GFP_KERNEL);
+	if (params == NULL)
+		return -ENOMEM;
 
-		spin_lock_irqsave(&prev->lock, flags);
-		prev->shadow_update = 1;
-		spin_unlock_irqrestore(&prev->lock, flags);
-	}
+	spin_lock_irqsave(&prev->params.lock, flags);
+	memcpy(params, prev->params.shadow ? : prev->params.active,
+	       sizeof(*params));
+	spin_unlock_irqrestore(&prev->params.lock, flags);
+
+	params->update = 0;
 
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
 		attr = &update_attrs[i];
@@ -926,11 +940,28 @@ static int preview_config(struct isp_prev_device *prev,
 			params->features &= ~attr->feature_bit;
 		}
 
-		prev->update |= attr->feature_bit;
+		params->update |= attr->feature_bit;
+	}
+
+	if (rval < 0) {
+		kfree(params);
+		return rval;
 	}
 
-	prev->shadow_update = 0;
-	return rval;
+	spin_lock_irqsave(&prev->params.lock, flags);
+	/* If shadow parameters are still present, keep their update flags as
+	 * the hardware hasn't been updated yet. The values have been copied at
+	 * the beginning of the function.
+	 */
+	if (prev->params.shadow)
+		params->update |= prev->params.shadow->update;
+
+	shadow = prev->params.shadow;
+	prev->params.shadow = params;
+	spin_unlock_irqrestore(&prev->params.lock, flags);
+
+	kfree(shadow);
+	return 0;
 }
 
 /*
@@ -941,7 +972,7 @@ static int preview_config(struct isp_prev_device *prev,
  */
 static void preview_setup_hw(struct isp_prev_device *prev)
 {
-	struct prev_params *params = &prev->params;
+	struct prev_params *params = prev->params.active;
 	struct preview_update *attr;
 	int i, bit;
 	void *param_ptr;
@@ -952,7 +983,7 @@ static void preview_setup_hw(struct isp_prev_device *prev)
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
 		attr = &update_attrs[i];
 
-		if (!(prev->update & attr->feature_bit))
+		if (!(params->update & attr->feature_bit))
 			continue;
 		bit = params->features & attr->feature_bit;
 		if (bit) {
@@ -967,7 +998,7 @@ static void preview_setup_hw(struct isp_prev_device *prev)
 			if (attr->enable)
 				attr->enable(prev, 0);
 
-		prev->update &= ~attr->feature_bit;
+		params->update &= ~attr->feature_bit;
 	}
 }
 
@@ -1004,14 +1035,15 @@ preview_config_ycpos(struct isp_prev_device *prev,
  */
 static void preview_config_averager(struct isp_prev_device *prev, u8 average)
 {
+	struct prev_params *params = prev->params.active;
 	struct isp_device *isp = to_isp_device(prev);
 	int reg = 0;
 
-	if (prev->params.cfa.format == OMAP3ISP_CFAFMT_BAYER)
+	if (params->cfa.format == OMAP3ISP_CFAFMT_BAYER)
 		reg = ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
 		      ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
 		      average;
-	else if (prev->params.cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
+	else if (params->cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
 		reg = ISPPRV_AVE_EVENDIST_3 << ISPPRV_AVE_EVENDIST_SHIFT |
 		      ISPPRV_AVE_ODDDIST_3 << ISPPRV_AVE_ODDDIST_SHIFT |
 		      average;
@@ -1032,7 +1064,7 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
 static void preview_config_input_size(struct isp_prev_device *prev)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	struct prev_params *params = &prev->params;
+	struct prev_params *params = prev->params.active;
 	unsigned int sph = prev->crop.left;
 	unsigned int eph = prev->crop.left + prev->crop.width - 1;
 	unsigned int slv = prev->crop.top;
@@ -1189,7 +1221,7 @@ int omap3isp_preview_busy(struct isp_prev_device *prev)
  */
 void omap3isp_preview_restore_context(struct isp_device *isp)
 {
-	isp->isp_prev.update = PREV_FEATURES_END - 1;
+	isp->isp_prev.params.active->update = PREV_FEATURES_END - 1;
 	preview_setup_hw(&isp->isp_prev);
 }
 
@@ -1249,12 +1281,19 @@ static void preview_print_status(struct isp_prev_device *prev)
 /*
  * preview_init_params - init image processing parameters.
  * @prev: pointer to previewer private structure
- * return none
+ *
+ * Returns 0 on success or -ENOMEM if parameters memory can't be allocated.
  */
-static void preview_init_params(struct isp_prev_device *prev)
+static int preview_init_params(struct isp_prev_device *prev)
 {
-	struct prev_params *params = &prev->params;
-	int i = 0;
+	struct prev_params *params;
+	unsigned int i;
+
+	spin_lock_init(&prev->params.lock);
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (params == NULL)
+		return -ENOMEM;
 
 	/* Init values */
 	params->contrast = ISPPRV_CONTRAST_DEF * ISPPRV_CONTRAST_UNITS;
@@ -1297,7 +1336,10 @@ static void preview_init_params(struct isp_prev_device *prev)
 			 | PREV_RGB2RGB | PREV_COLOR_CONV | PREV_WB
 			 | PREV_BRIGHTNESS | PREV_CONTRAST;
 
-	prev->update = PREV_FEATURES_END - 1;
+	params->update = PREV_FEATURES_END - 1;
+
+	prev->params.active = params;
+	return 0;
 }
 
 /*
@@ -1457,16 +1499,17 @@ void omap3isp_preview_isr(struct isp_prev_device *prev)
 	if (omap3isp_module_sync_is_stopping(&prev->wait, &prev->stopping))
 		return;
 
-	spin_lock_irqsave(&prev->lock, flags);
-	if (prev->shadow_update)
-		goto done;
+	spin_lock_irqsave(&prev->params.lock, flags);
+	if (prev->params.shadow) {
+		kfree(prev->params.active);
+		prev->params.active = prev->params.shadow;
+		prev->params.shadow = NULL;
+	}
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 
 	preview_setup_hw(prev);
 	preview_config_input_size(prev);
 
-done:
-	spin_unlock_irqrestore(&prev->lock, flags);
-
 	if (prev->input == PREVIEW_INPUT_MEMORY ||
 	    prev->output & PREVIEW_OUTPUT_MEMORY)
 		preview_isr_buffer(prev);
@@ -1557,7 +1600,6 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
 	struct isp_video *video_out = &prev->video_out;
 	struct isp_device *isp = to_isp_device(prev);
 	struct device *dev = to_device(prev);
-	unsigned long flags;
 
 	if (prev->state == ISP_PIPELINE_STREAM_STOPPED) {
 		if (enable == ISP_PIPELINE_STREAM_STOPPED)
@@ -1594,11 +1636,9 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
 		if (omap3isp_module_sync_idle(&sd->entity, &prev->wait,
 					      &prev->stopping))
 			dev_dbg(dev, "%s: stop timeout.\n", sd->name);
-		spin_lock_irqsave(&prev->lock, flags);
 		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_READ);
 		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_WRITE);
 		omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_PREVIEW);
-		spin_unlock_irqrestore(&prev->lock, flags);
 		isp_video_dmaqueue_flags_clr(video_out);
 		break;
 	}
@@ -2206,17 +2246,20 @@ error_video_in:
 }
 
 /*
- * isp_preview_init - Previewer initialization.
+ * omap3isp_preview_init - Previewer initialization.
  * @dev : Pointer to ISP device
  * return -ENOMEM or zero on success
  */
 int omap3isp_preview_init(struct isp_device *isp)
 {
 	struct isp_prev_device *prev = &isp->isp_prev;
+	int ret;
 
-	spin_lock_init(&prev->lock);
 	init_waitqueue_head(&prev->wait);
-	preview_init_params(prev);
+
+	ret = preview_init_params(prev);
+	if (ret < 0)
+		return ret;
 
 	return preview_init_entities(prev);
 }
@@ -2229,4 +2272,7 @@ void omap3isp_preview_cleanup(struct isp_device *isp)
 	omap3isp_video_cleanup(&prev->video_in);
 	omap3isp_video_cleanup(&prev->video_out);
 	media_entity_cleanup(&prev->subdev.entity);
+
+	kfree(prev->params.active);
+	kfree(prev->params.shadow);
 }
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index 0968660..c38ed09 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -89,6 +89,7 @@ enum preview_ycpos_mode {
 /*
  * struct prev_params - Structure for all configuration
  * @features: Set of features enabled.
+ * @update: Bitmask of the parameters to be updated
  * @cfa: CFA coefficients.
  * @csup: Chroma suppression coefficients.
  * @luma: Luma enhancement coefficients.
@@ -106,6 +107,7 @@ enum preview_ycpos_mode {
  */
 struct prev_params {
 	u32 features;
+	u32 update;
 	struct omap3isp_prev_cfa cfa;
 	struct omap3isp_prev_csup csup;
 	struct omap3isp_prev_luma luma;
@@ -157,12 +159,11 @@ struct isptables_update {
  * @output: Bitmask of the active output
  * @video_in: Input video entity
  * @video_out: Output video entity
- * @params: Module configuration data
- * @shadow_update: If set, update the hardware configured in the next interrupt
+ * @params.active: Active module configuration data
+ * @params.shadow: Shadow module configuration data
+ * @params.lock: Parameters lock, protects params.active and params.shadow
  * @underrun: Whether the preview entity has queued buffers on the output
  * @state: Current preview pipeline state
- * @lock: Shadow update lock
- * @update: Bitmask of the parameters to be updated
  *
  * This structure is used to store the OMAP ISP Preview module Information.
  */
@@ -179,13 +180,15 @@ struct isp_prev_device {
 	struct isp_video video_in;
 	struct isp_video video_out;
 
-	struct prev_params params;
-	unsigned int shadow_update:1;
+	struct {
+		struct prev_params *active;
+		struct prev_params *shadow;
+		spinlock_t lock;
+	} params;
+
 	enum isp_pipeline_stream_state state;
 	wait_queue_head_t wait;
 	atomic_t stopping;
-	spinlock_t lock;
-	u32 update;
 };
 
 struct isp_device;
-- 
1.7.3.4

