Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52119 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab2DPN3t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 9/9] omap3isp: preview: Shorten shadow update delay
Date: Mon, 16 Apr 2012 15:29:54 +0200
Message-Id: <1334582994-6967-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
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

Fix this by storing new parameters in a shadow copy, and switch the
active parameters with the shadow values atomically.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  298 +++++++++++++++++++----------
 drivers/media/video/omap3isp/isppreview.h |   21 ++-
 2 files changed, 212 insertions(+), 107 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index e12df2c..5ccfe46 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -649,12 +649,18 @@ preview_config_rgb_to_ycbcr(struct isp_prev_device *prev, const void *prev_csc)
 static void
 preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
 {
-	struct prev_params *params = &prev->params;
+	struct prev_params *params;
+	unsigned long flags;
+
+	spin_lock_irqsave(&prev->params.lock, flags);
+	params = (prev->params.active & OMAP3ISP_PREV_CONTRAST)
+	       ? &prev->params.params[0] : &prev->params.params[1];
 
 	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
 		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
-		prev->update |= OMAP3ISP_PREV_CONTRAST;
+		params->update |= OMAP3ISP_PREV_CONTRAST;
 	}
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 /*
@@ -681,12 +687,18 @@ preview_config_contrast(struct isp_prev_device *prev, const void *params)
 static void
 preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
 {
-	struct prev_params *params = &prev->params;
+	struct prev_params *params;
+	unsigned long flags;
+
+	spin_lock_irqsave(&prev->params.lock, flags);
+	params = (prev->params.active & OMAP3ISP_PREV_CONTRAST)
+	       ? &prev->params.params[0] : &prev->params.params[1];
 
 	if (params->brightness != (brightness * ISPPRV_BRIGHT_UNITS)) {
 		params->brightness = brightness * ISPPRV_BRIGHT_UNITS;
-		prev->update |= OMAP3ISP_PREV_BRIGHTNESS;
+		params->update |= OMAP3ISP_PREV_BRIGHTNESS;
 	}
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 /*
@@ -721,6 +733,75 @@ preview_config_yc_range(struct isp_prev_device *prev, const void *yclimit)
 		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SETUP_YC);
 }
 
+static u32
+preview_params_lock(struct isp_prev_device *prev, u32 update, bool shadow)
+{
+	u32 active = prev->params.active;
+
+	if (shadow) {
+		/* Mark all shadow parameters we are going to touch as busy. */
+		prev->params.params[0].busy |= ~active & update;
+		prev->params.params[1].busy |= active & update;
+	} else {
+		/* Mark all active parameters we are going to touch as busy. */
+		update = (prev->params.params[0].update & active)
+		       | (prev->params.params[1].update & ~active);
+
+		prev->params.params[0].busy |= active & update;
+		prev->params.params[1].busy |= ~active & update;
+	}
+
+	return update;
+}
+
+static void
+preview_params_unlock(struct isp_prev_device *prev, u32 update, bool shadow)
+{
+	u32 active = prev->params.active;
+
+	if (shadow) {
+		/* Set the update flag for shadow parameters that have been
+		 * updated and clear the busy flag for all shadow parameters.
+		 */
+		prev->params.params[0].update |= (~active & update);
+		prev->params.params[1].update |= (active & update);
+		prev->params.params[0].busy &= active;
+		prev->params.params[1].busy &= ~active;
+	} else {
+		/* Clear the update flag for active parameters that have been
+		 * applied and the busy flag for all active parameters.
+		 */
+		prev->params.params[0].update &= ~(active & update);
+		prev->params.params[1].update &= ~(~active & update);
+		prev->params.params[0].busy &= ~active;
+		prev->params.params[1].busy &= active;
+	}
+}
+
+static void preview_params_switch(struct isp_prev_device *prev)
+{
+	u32 to_switch;
+
+	/* Switch active parameters with updated shadow parameters when the
+	 * shadow parameter has been updated and neither the active not the
+	 * shadow parameter is busy.
+	 */
+	to_switch = (prev->params.params[0].update & ~prev->params.active)
+		  | (prev->params.params[1].update & prev->params.active);
+	to_switch &= ~(prev->params.params[0].busy |
+		       prev->params.params[1].busy);
+	if (to_switch == 0)
+		return;
+
+	prev->params.active ^= to_switch;
+
+	/* Remove the update flag for the shadow copy of parameters we have
+	 * switched.
+	 */
+	prev->params.params[0].update &= ~(~prev->params.active & to_switch);
+	prev->params.params[1].update &= ~(prev->params.active & to_switch);
+}
+
 /* preview parameters update structure */
 struct preview_update {
 	void (*config)(struct isp_prev_device *, const void *);
@@ -834,37 +915,6 @@ static const struct preview_update update_attrs[] = {
 };
 
 /*
- * __preview_get_ptrs - helper function which return pointers to members
- *                         of params and config structures.
- * @params - pointer to preview_params structure.
- * @param - return pointer to appropriate structure field.
- * @configs - pointer to update config structure.
- * @config - return pointer to appropriate structure field.
- * @bit - for which feature to return pointers.
- * Return size of corresponding prev_params member
- */
-static u32
-__preview_get_ptrs(struct prev_params *params, void **param,
-		   struct omap3isp_prev_update_config *configs,
-		   void __user **config, unsigned int index)
-{
-	const struct preview_update *info = &update_attrs[index];
-
-	if (index >= ARRAY_SIZE(update_attrs)) {
-		if (config)
-			*config = NULL;
-		*param = NULL;
-		return 0;
-	}
-
-	if (configs && config)
-		*config = *(void **)((void *)configs + info->config_offset);
-
-	*param = (void *)params + info->param_offset;
-	return info->param_size;
-}
-
-/*
  * preview_config - Copy and update local structure with userspace preview
  *                  configuration.
  * @prev: ISP preview engine
@@ -876,36 +926,41 @@ __preview_get_ptrs(struct prev_params *params, void **param,
 static int preview_config(struct isp_prev_device *prev,
 			  struct omap3isp_prev_update_config *cfg)
 {
-	const struct preview_update *attr;
-	struct prev_params *params;
-	int i, bit, rval = 0;
+	unsigned long flags;
+	unsigned int i;
+	int rval = 0;
+	u32 update;
+	u32 active;
 
-	params = &prev->params;
 	if (cfg->update == 0)
 		return 0;
 
-	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
-		unsigned long flags;
+	/* Mark the shadow parameters we're going to update as busy. */
+	spin_lock_irqsave(&prev->params.lock, flags);
+	preview_params_lock(prev, cfg->update, true);
+	active = prev->params.active;
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 
-		spin_lock_irqsave(&prev->lock, flags);
-		prev->shadow_update = 1;
-		spin_unlock_irqrestore(&prev->lock, flags);
-	}
+	update = 0;
 
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
-		attr = &update_attrs[i];
-		bit = 1 << i;
+		const struct preview_update *attr = &update_attrs[i];
+		struct prev_params *params;
+		unsigned int bit = 1 << i;
 
 		if (attr->skip || !(cfg->update & bit))
 			continue;
 
+		params = &prev->params.params[!!(active & bit)];
+
 		if (cfg->flag & bit) {
-			void *to = NULL, __user *from = NULL;
-			unsigned long sz = 0;
+			void __user *from = *(void * __user *)
+				((void *)cfg + attr->config_offset);
+			void *to = (void *)params + attr->param_offset;
+			size_t size = attr->param_size;
 
-			sz = __preview_get_ptrs(params, &to, cfg, &from, i);
-			if (to && from && sz) {
-				if (copy_from_user(to, from, sz)) {
+			if (to && from && size) {
+				if (copy_from_user(to, from, size)) {
 					rval = -EFAULT;
 					break;
 				}
@@ -915,50 +970,59 @@ static int preview_config(struct isp_prev_device *prev,
 			params->features &= ~bit;
 		}
 
-		prev->update |= bit;
+		update |= bit;
 	}
 
-	prev->shadow_update = 0;
+	spin_lock_irqsave(&prev->params.lock, flags);
+	preview_params_unlock(prev, update, true);
+	preview_params_switch(prev);
+	spin_unlock_irqrestore(&prev->params.lock, flags);
+
 	return rval;
 }
 
 /*
  * preview_setup_hw - Setup preview registers and/or internal memory
  * @prev: pointer to preview private structure
+ * @update: Bitmask of parameters to setup
+ * @active: Bitmask of parameters active in set 0
  * Note: can be called from interrupt context
  * Return none
  */
-static void preview_setup_hw(struct isp_prev_device *prev)
+static void preview_setup_hw(struct isp_prev_device *prev, u32 update,
+			     u32 active)
 {
-	struct prev_params *params = &prev->params;
-	const struct preview_update *attr;
-	unsigned int bit;
 	unsigned int i;
-	void *param_ptr;
+	u32 features;
 
-	if (prev->update == 0)
+	if (update == 0)
 		return;
 
+	features = (prev->params.params[0].features & active)
+		 | (prev->params.params[1].features & ~active);
+
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
-		attr = &update_attrs[i];
-		bit = 1 << i;
+		const struct preview_update *attr = &update_attrs[i];
+		struct prev_params *params;
+		unsigned int bit = 1 << i;
+		void *param_ptr;
 
-		if (!(prev->update & bit))
+		if (!(update & bit))
 			continue;
 
+		params = &prev->params.params[!(active & bit)];
+
 		if (params->features & bit) {
 			if (attr->config) {
-				__preview_get_ptrs(params, &param_ptr, NULL,
-						   NULL, i);
+				param_ptr = (void *)params + attr->param_offset;
 				attr->config(prev, param_ptr);
 			}
 			if (attr->enable)
 				attr->enable(prev, 1);
-		} else
+		} else {
 			if (attr->enable)
 				attr->enable(prev, 0);
-
-		prev->update &= ~bit;
+		}
 	}
 }
 
@@ -996,13 +1060,17 @@ preview_config_ycpos(struct isp_prev_device *prev,
 static void preview_config_averager(struct isp_prev_device *prev, u8 average)
 {
 	struct isp_device *isp = to_isp_device(prev);
+	struct prev_params *params;
 	int reg = 0;
 
-	if (prev->params.cfa.format == OMAP3ISP_CFAFMT_BAYER)
+	params = (prev->params.active & OMAP3ISP_PREV_CFA)
+	       ? &prev->params.params[0] : &prev->params.params[1];
+
+	if (params->cfa.format == OMAP3ISP_CFAFMT_BAYER)
 		reg = ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
 		      ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
 		      average;
-	else if (prev->params.cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
+	else if (params->cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
 		reg = ISPPRV_AVE_EVENDIST_3 << ISPPRV_AVE_EVENDIST_SHIFT |
 		      ISPPRV_AVE_ODDDIST_3 << ISPPRV_AVE_ODDDIST_SHIFT |
 		      average;
@@ -1020,33 +1088,35 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
  *
  * See the explanation at the PREV_MARGIN_* definitions for more details.
  */
-static void preview_config_input_size(struct isp_prev_device *prev)
+static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	struct prev_params *params = &prev->params;
 	unsigned int sph = prev->crop.left;
 	unsigned int eph = prev->crop.left + prev->crop.width - 1;
 	unsigned int slv = prev->crop.top;
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
+	u32 features;
 
-	if (params->features & OMAP3ISP_PREV_CFA) {
+	features = (prev->params.params[0].features & active)
+		 | (prev->params.params[1].features & ~active);
+
+	if (features & OMAP3ISP_PREV_CFA) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
 		elv += 2;
 	}
-	if (params->features & (OMAP3ISP_PREV_DEFECT_COR | OMAP3ISP_PREV_NF)) {
+	if (features & (OMAP3ISP_PREV_DEFECT_COR | OMAP3ISP_PREV_NF)) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
 		elv += 2;
 	}
-	if (params->features & OMAP3ISP_PREV_HRZ_MED) {
+	if (features & OMAP3ISP_PREV_HRZ_MED) {
 		sph -= 2;
 		eph += 2;
 	}
-	if (params->features & (OMAP3ISP_PREV_CHROMA_SUPP |
-				OMAP3ISP_PREV_LUMAENH))
+	if (features & (OMAP3ISP_PREV_CHROMA_SUPP | OMAP3ISP_PREV_LUMAENH))
 		sph -= 2;
 
 	isp_reg_writel(isp, (sph << ISPPRV_HORZ_INFO_SPH_SHIFT) | eph,
@@ -1181,8 +1251,16 @@ int omap3isp_preview_busy(struct isp_prev_device *prev)
  */
 void omap3isp_preview_restore_context(struct isp_device *isp)
 {
-	isp->isp_prev.update = OMAP3ISP_PREV_FEATURES_END - 1;
-	preview_setup_hw(&isp->isp_prev);
+	struct isp_prev_device *prev = &isp->isp_prev;
+	const u32 update = OMAP3ISP_PREV_FEATURES_END - 1;
+
+	prev->params.params[0].update = prev->params.active & update;
+	prev->params.params[1].update = ~prev->params.active & update;
+
+	preview_setup_hw(prev, update, prev->params.active);
+
+	prev->params.params[0].update = 0;
+	prev->params.params[1].update = 0;
 }
 
 /*
@@ -1241,12 +1319,21 @@ static void preview_print_status(struct isp_prev_device *prev)
 /*
  * preview_init_params - init image processing parameters.
  * @prev: pointer to previewer private structure
- * return none
  */
 static void preview_init_params(struct isp_prev_device *prev)
 {
-	struct prev_params *params = &prev->params;
-	int i = 0;
+	struct prev_params *params;
+	unsigned int i;
+
+	spin_lock_init(&prev->params.lock);
+
+	prev->params.active = ~0;
+	prev->params.params[0].busy = 0;
+	prev->params.params[0].update = OMAP3ISP_PREV_FEATURES_END - 1;
+	prev->params.params[1].busy = 0;
+	prev->params.params[1].update = 0;
+
+	params = &prev->params.params[0];
 
 	/* Init values */
 	params->contrast = ISPPRV_CONTRAST_DEF * ISPPRV_CONTRAST_UNITS;
@@ -1290,8 +1377,6 @@ static void preview_init_params(struct isp_prev_device *prev)
 			 | OMAP3ISP_PREV_RGB2RGB | OMAP3ISP_PREV_COLOR_CONV
 			 | OMAP3ISP_PREV_WB | OMAP3ISP_PREV_BRIGHTNESS
 			 | OMAP3ISP_PREV_CONTRAST;
-
-	prev->update = OMAP3ISP_PREV_FEATURES_END - 1;
 }
 
 /*
@@ -1320,8 +1405,17 @@ static void preview_configure(struct isp_prev_device *prev)
 {
 	struct isp_device *isp = to_isp_device(prev);
 	struct v4l2_mbus_framefmt *format;
+	unsigned long flags;
+	u32 update;
+	u32 active;
 
-	preview_setup_hw(prev);
+	spin_lock_irqsave(&prev->params.lock, flags);
+	/* Mark all active parameters we are going to touch as busy. */
+	update = preview_params_lock(prev, 0, false);
+	active = prev->params.active;
+	spin_unlock_irqrestore(&prev->params.lock, flags);
+
+	preview_setup_hw(prev, update, active);
 
 	if (prev->output & PREVIEW_OUTPUT_MEMORY)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
@@ -1342,7 +1436,7 @@ static void preview_configure(struct isp_prev_device *prev)
 
 	preview_adjust_bandwidth(prev);
 
-	preview_config_input_size(prev);
+	preview_config_input_size(prev, active);
 
 	if (prev->input == PREVIEW_INPUT_CCDC)
 		preview_config_inlineoffset(prev, 0);
@@ -1359,6 +1453,10 @@ static void preview_configure(struct isp_prev_device *prev)
 
 	preview_config_averager(prev, 0);
 	preview_config_ycpos(prev, format->code);
+
+	spin_lock_irqsave(&prev->params.lock, flags);
+	preview_params_unlock(prev, update, false);
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 /* -----------------------------------------------------------------------------
@@ -1447,25 +1545,30 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 void omap3isp_preview_isr(struct isp_prev_device *prev)
 {
 	unsigned long flags;
+	u32 update;
+	u32 active;
 
 	if (omap3isp_module_sync_is_stopping(&prev->wait, &prev->stopping))
 		return;
 
-	spin_lock_irqsave(&prev->lock, flags);
-	if (prev->shadow_update)
-		goto done;
+	spin_lock_irqsave(&prev->params.lock, flags);
+	preview_params_switch(prev);
+	update = preview_params_lock(prev, 0, false);
+	active = prev->params.active;
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 
-	preview_setup_hw(prev);
-	preview_config_input_size(prev);
-
-done:
-	spin_unlock_irqrestore(&prev->lock, flags);
+	preview_setup_hw(prev, update, active);
+	preview_config_input_size(prev, active);
 
 	if (prev->input == PREVIEW_INPUT_MEMORY ||
 	    prev->output & PREVIEW_OUTPUT_MEMORY)
 		preview_isr_buffer(prev);
 	else if (prev->state == ISP_PIPELINE_STREAM_CONTINUOUS)
 		preview_enable_oneshot(prev);
+
+	spin_lock_irqsave(&prev->params.lock, flags);
+	preview_params_unlock(prev, update, false);
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 /* -----------------------------------------------------------------------------
@@ -1551,7 +1654,6 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
 	struct isp_video *video_out = &prev->video_out;
 	struct isp_device *isp = to_isp_device(prev);
 	struct device *dev = to_device(prev);
-	unsigned long flags;
 
 	if (prev->state == ISP_PIPELINE_STREAM_STOPPED) {
 		if (enable == ISP_PIPELINE_STREAM_STOPPED)
@@ -1588,11 +1690,9 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
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
@@ -2200,7 +2300,7 @@ error_video_in:
 }
 
 /*
- * isp_preview_init - Previewer initialization.
+ * omap3isp_preview_init - Previewer initialization.
  * @dev : Pointer to ISP device
  * return -ENOMEM or zero on success
  */
@@ -2208,8 +2308,8 @@ int omap3isp_preview_init(struct isp_device *isp)
 {
 	struct isp_prev_device *prev = &isp->isp_prev;
 
-	spin_lock_init(&prev->lock);
 	init_waitqueue_head(&prev->wait);
+
 	preview_init_params(prev);
 
 	return preview_init_entities(prev);
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index 6ee8306..6663ab6 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -69,6 +69,8 @@ enum preview_ycpos_mode {
 
 /*
  * struct prev_params - Structure for all configuration
+ * @busy: Bitmask of busy parameters (being updated or used)
+ * @update: Bitmask of the parameters to be updated
  * @features: Set of features enabled.
  * @cfa: CFA coefficients.
  * @csup: Chroma suppression coefficients.
@@ -86,6 +88,8 @@ enum preview_ycpos_mode {
  * @brightness: Brightness.
  */
 struct prev_params {
+	u32 busy;
+	u32 update;
 	u32 features;
 	struct omap3isp_prev_cfa cfa;
 	struct omap3isp_prev_csup csup;
@@ -118,12 +122,11 @@ struct prev_params {
  * @output: Bitmask of the active output
  * @video_in: Input video entity
  * @video_out: Output video entity
- * @params: Module configuration data
- * @shadow_update: If set, update the hardware configured in the next interrupt
+ * @params.params : Active and shadow parameters sets
+ * @params.active: Bitmask of parameters active in set 0
+ * @params.lock: Parameters lock, protects params.active and params.shadow
  * @underrun: Whether the preview entity has queued buffers on the output
  * @state: Current preview pipeline state
- * @lock: Shadow update lock
- * @update: Bitmask of the parameters to be updated
  *
  * This structure is used to store the OMAP ISP Preview module Information.
  */
@@ -140,13 +143,15 @@ struct isp_prev_device {
 	struct isp_video video_in;
 	struct isp_video video_out;
 
-	struct prev_params params;
-	unsigned int shadow_update:1;
+	struct {
+		struct prev_params params[2];
+		u32 active;
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

