Return-path: <mchehab@pedra>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54744 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750789Ab1FTU0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 16:26:14 -0400
Received: from c-67-161-37-189.hsd1.ca.comcast.net ([67.161.37.189] helo=jbarnes-desktop)
	by box514.bluehost.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.69)
	(envelope-from <jbarnes@virtuousgeek.org>)
	id 1QYl2z-0004Iy-5o
	for linux-media@vger.kernel.org; Mon, 20 Jun 2011 14:26:13 -0600
From: Jesse Barnes <jbarnes@virtuousgeek.org> (by way of Jesse Barnes
	<jbarnes@virtuousgeek.org>)
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 20 Jun 2011 13:11:40 -0700
Message-Id: <1308600701-7442-4-git-send-email-jbarnes@virtuousgeek.org>
In-Reply-To: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
Subject: [PATCH 3/4] drm/i915: rename existing overlay support to "legacy"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The old overlay block has all sorts of quirks and is very different than
ILK+ video sprites.  So rename it to legacy to make that clear and clash
less with core overlay support.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_debugfs.c  |    2 +-
 drivers/gpu/drm/i915/i915_drv.h      |   12 ++--
 drivers/gpu/drm/i915/i915_irq.c      |    2 +-
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 drivers/gpu/drm/i915/intel_drv.h     |    4 +-
 drivers/gpu/drm/i915/intel_overlay.c |  126 +++++++++++++++++-----------------
 6 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 51c2257..c83ed15 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -825,7 +825,7 @@ static int i915_error_state(struct seq_file *m, void *unused)
 	}
 
 	if (error->overlay)
-		intel_overlay_print_error_state(m, error->overlay);
+		intel_legacy_overlay_print_error_state(m, error->overlay);
 
 	if (error->display)
 		intel_display_print_error_state(m, dev, error->display);
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 31e199f..062e80e 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -117,8 +117,8 @@ struct intel_opregion {
 };
 #define OPREGION_SIZE            (8*1024)
 
-struct intel_overlay;
-struct intel_overlay_error_state;
+struct intel_legacy_overlay;
+struct intel_legacy_overlay_error_state;
 
 struct drm_i915_master_private {
 	drm_local_map_t *sarea;
@@ -191,7 +191,7 @@ struct drm_i915_error_state {
 		u32 cache_level:2;
 	} *active_bo, *pinned_bo;
 	u32 active_bo_count, pinned_bo_count;
-	struct intel_overlay_error_state *overlay;
+	struct intel_legacy_overlay_error_state *overlay;
 	struct intel_display_error_state *display;
 };
 
@@ -336,7 +336,7 @@ typedef struct drm_i915_private {
 	struct intel_opregion opregion;
 
 	/* overlay */
-	struct intel_overlay *overlay;
+	struct intel_legacy_overlay *overlay;
 
 	/* LVDS info */
 	int backlight_level;  /* restore backlight to this value */
@@ -1329,8 +1329,8 @@ extern int intel_trans_dp_port_sel (struct drm_crtc *crtc);
 
 /* overlay */
 #ifdef CONFIG_DEBUG_FS
-extern struct intel_overlay_error_state *intel_overlay_capture_error_state(struct drm_device *dev);
-extern void intel_overlay_print_error_state(struct seq_file *m, struct intel_overlay_error_state *error);
+extern struct intel_legacy_overlay_error_state *intel_legacy_overlay_capture_error_state(struct drm_device *dev);
+extern void intel_legacy_overlay_print_error_state(struct seq_file *m, struct intel_legacy_overlay_error_state *error);
 
 extern struct intel_display_error_state *intel_display_capture_error_state(struct drm_device *dev);
 extern void intel_display_print_error_state(struct seq_file *m,
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b79619a..7a34167 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -991,7 +991,7 @@ static void i915_capture_error_state(struct drm_device *dev)
 
 	do_gettimeofday(&error->time);
 
-	error->overlay = intel_overlay_capture_error_state(dev);
+	error->overlay = intel_legacy_overlay_capture_error_state(dev);
 	error->display = intel_display_capture_error_state(dev);
 
 	spin_lock_irqsave(&dev_priv->error_lock, flags);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 8a6e3ab..7901f16 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2936,7 +2936,7 @@ static void intel_crtc_dpms_overlay(struct intel_crtc *intel_crtc, bool enable)
 
 		mutex_lock(&dev->struct_mutex);
 		dev_priv->mm.interruptible = false;
-		(void) intel_overlay_switch_off(intel_crtc->overlay);
+		(void) intel_legacy_overlay_switch_off(intel_crtc->overlay);
 		dev_priv->mm.interruptible = true;
 		mutex_unlock(&dev->struct_mutex);
 	}
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 3cfc391..d73e622 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -161,7 +161,7 @@ struct intel_crtc {
 	bool busy; /* is scanout buffer being updated frequently? */
 	struct timer_list idle_timer;
 	bool lowfreq_avail;
-	struct intel_overlay *overlay;
+	struct intel_legacy_overlay *overlay;
 	struct intel_unpin_work *unpin_work;
 	int fdi_lanes;
 
@@ -337,7 +337,7 @@ extern void intel_finish_page_flip_plane(struct drm_device *dev, int plane);
 
 extern void intel_setup_overlay(struct drm_device *dev);
 extern void intel_cleanup_overlay(struct drm_device *dev);
-extern int intel_overlay_switch_off(struct intel_overlay *overlay);
+extern int intel_legacy_overlay_switch_off(struct intel_legacy_overlay *overlay);
 extern int intel_overlay_put_image(struct drm_device *dev, void *data,
 				   struct drm_file *file_priv);
 extern int intel_overlay_attrs(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index a670c00..42e6561 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -170,7 +170,7 @@ struct overlay_registers {
     u16 RESERVEDG[0x100 / 2 - N_HORIZ_UV_TAPS * N_PHASES];
 };
 
-struct intel_overlay {
+struct intel_legacy_overlay {
 	struct drm_device *dev;
 	struct intel_crtc *crtc;
 	struct drm_i915_gem_object *vid_bo;
@@ -186,11 +186,11 @@ struct intel_overlay {
 	struct drm_i915_gem_object *reg_bo;
 	/* flip handling */
 	uint32_t last_flip_req;
-	void (*flip_tail)(struct intel_overlay *);
+	void (*flip_tail)(struct intel_legacy_overlay *);
 };
 
 static struct overlay_registers *
-intel_overlay_map_regs(struct intel_overlay *overlay)
+intel_legacy_overlay_map_regs(struct intel_legacy_overlay *overlay)
 {
         drm_i915_private_t *dev_priv = overlay->dev->dev_private;
 	struct overlay_registers *regs;
@@ -204,16 +204,16 @@ intel_overlay_map_regs(struct intel_overlay *overlay)
 	return regs;
 }
 
-static void intel_overlay_unmap_regs(struct intel_overlay *overlay,
+static void intel_legacy_overlay_unmap_regs(struct intel_legacy_overlay *overlay,
 				     struct overlay_registers *regs)
 {
 	if (!OVERLAY_NEEDS_PHYSICAL(overlay->dev))
 		io_mapping_unmap(regs);
 }
 
-static int intel_overlay_do_wait_request(struct intel_overlay *overlay,
+static int intel_legacy_overlay_do_wait_request(struct intel_legacy_overlay *overlay,
 					 struct drm_i915_gem_request *request,
-					 void (*tail)(struct intel_overlay *))
+					 void (*tail)(struct intel_legacy_overlay *))
 {
 	struct drm_device *dev = overlay->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -284,7 +284,7 @@ i830_deactivate_pipe_a(struct drm_device *dev)
 }
 
 /* overlay needs to be disable in OCMD reg */
-static int intel_overlay_on(struct intel_overlay *overlay)
+static int intel_legacy_overlay_on(struct intel_legacy_overlay *overlay)
 {
 	struct drm_device *dev = overlay->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -319,7 +319,7 @@ static int intel_overlay_on(struct intel_overlay *overlay)
 	OUT_RING(MI_NOOP);
 	ADVANCE_LP_RING();
 
-	ret = intel_overlay_do_wait_request(overlay, request, NULL);
+	ret = intel_legacy_overlay_do_wait_request(overlay, request, NULL);
 out:
 	if (pipe_a_quirk)
 		i830_deactivate_pipe_a(dev);
@@ -328,7 +328,7 @@ out:
 }
 
 /* overlay needs to be enabled in OCMD reg */
-static int intel_overlay_continue(struct intel_overlay *overlay,
+static int intel_legacy_overlay_continue(struct intel_legacy_overlay *overlay,
 				  bool load_polyphase_filter)
 {
 	struct drm_device *dev = overlay->dev;
@@ -371,7 +371,7 @@ static int intel_overlay_continue(struct intel_overlay *overlay,
 	return 0;
 }
 
-static void intel_overlay_release_old_vid_tail(struct intel_overlay *overlay)
+static void intel_legacy_overlay_release_old_vid_tail(struct intel_legacy_overlay *overlay)
 {
 	struct drm_i915_gem_object *obj = overlay->old_vid_bo;
 
@@ -381,7 +381,7 @@ static void intel_overlay_release_old_vid_tail(struct intel_overlay *overlay)
 	overlay->old_vid_bo = NULL;
 }
 
-static void intel_overlay_off_tail(struct intel_overlay *overlay)
+static void intel_legacy_overlay_off_tail(struct intel_legacy_overlay *overlay)
 {
 	struct drm_i915_gem_object *obj = overlay->vid_bo;
 
@@ -398,7 +398,7 @@ static void intel_overlay_off_tail(struct intel_overlay *overlay)
 }
 
 /* overlay needs to be disabled in OCMD reg */
-static int intel_overlay_off(struct intel_overlay *overlay)
+static int intel_legacy_overlay_off(struct intel_legacy_overlay *overlay)
 {
 	struct drm_device *dev = overlay->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -433,13 +433,13 @@ static int intel_overlay_off(struct intel_overlay *overlay)
 	OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
 	ADVANCE_LP_RING();
 
-	return intel_overlay_do_wait_request(overlay, request,
-					     intel_overlay_off_tail);
+	return intel_legacy_overlay_do_wait_request(overlay, request,
+					     intel_legacy_overlay_off_tail);
 }
 
 /* recover from an interruption due to a signal
  * We have to be careful not to repeat work forever an make forward progess. */
-static int intel_overlay_recover_from_interrupt(struct intel_overlay *overlay)
+static int intel_legacy_overlay_recover_from_interrupt(struct intel_legacy_overlay *overlay)
 {
 	struct drm_device *dev = overlay->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -461,9 +461,9 @@ static int intel_overlay_recover_from_interrupt(struct intel_overlay *overlay)
 
 /* Wait for pending overlay flip and release old frame.
  * Needs to be called before the overlay register are changed
- * via intel_overlay_(un)map_regs
+ * via intel_legacy_overlay_(un)map_regs
  */
-static int intel_overlay_release_old_vid(struct intel_overlay *overlay)
+static int intel_legacy_overlay_release_old_vid(struct intel_legacy_overlay *overlay)
 {
 	struct drm_device *dev = overlay->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -493,13 +493,13 @@ static int intel_overlay_release_old_vid(struct intel_overlay *overlay)
 		OUT_RING(MI_NOOP);
 		ADVANCE_LP_RING();
 
-		ret = intel_overlay_do_wait_request(overlay, request,
-						    intel_overlay_release_old_vid_tail);
+		ret = intel_legacy_overlay_do_wait_request(overlay, request,
+						    intel_legacy_overlay_release_old_vid_tail);
 		if (ret)
 			return ret;
 	}
 
-	intel_overlay_release_old_vid_tail(overlay);
+	intel_legacy_overlay_release_old_vid_tail(overlay);
 	return 0;
 }
 
@@ -625,7 +625,7 @@ static void update_polyphase_filter(struct overlay_registers *regs)
 	memcpy(regs->UV_HCOEFS, uv_static_hcoeffs, sizeof(uv_static_hcoeffs));
 }
 
-static bool update_scaling_factors(struct intel_overlay *overlay,
+static bool update_scaling_factors(struct intel_legacy_overlay *overlay,
 				   struct overlay_registers *regs,
 				   struct put_image_params *params)
 {
@@ -682,7 +682,7 @@ static bool update_scaling_factors(struct intel_overlay *overlay,
 	return scale_changed;
 }
 
-static void update_colorkey(struct intel_overlay *overlay,
+static void update_colorkey(struct intel_legacy_overlay *overlay,
 			    struct overlay_registers *regs)
 {
 	u32 key = overlay->color_key;
@@ -756,7 +756,7 @@ static u32 overlay_cmd_reg(struct put_image_params *params)
 	return cmd;
 }
 
-static int intel_overlay_do_put_image(struct intel_overlay *overlay,
+static int intel_legacy_overlay_do_put_image(struct intel_legacy_overlay *overlay,
 				      struct drm_i915_gem_object *new_bo,
 				      struct put_image_params *params)
 {
@@ -769,7 +769,7 @@ static int intel_overlay_do_put_image(struct intel_overlay *overlay,
 	BUG_ON(!mutex_is_locked(&dev->mode_config.mutex));
 	BUG_ON(!overlay);
 
-	ret = intel_overlay_release_old_vid(overlay);
+	ret = intel_legacy_overlay_release_old_vid(overlay);
 	if (ret != 0)
 		return ret;
 
@@ -786,7 +786,7 @@ static int intel_overlay_do_put_image(struct intel_overlay *overlay,
 		goto out_unpin;
 
 	if (!overlay->active) {
-		regs = intel_overlay_map_regs(overlay);
+		regs = intel_legacy_overlay_map_regs(overlay);
 		if (!regs) {
 			ret = -ENOMEM;
 			goto out_unpin;
@@ -796,14 +796,14 @@ static int intel_overlay_do_put_image(struct intel_overlay *overlay,
 			regs->OCONFIG |= OCONF_CSC_MODE_BT709;
 		regs->OCONFIG |= overlay->crtc->pipe == 0 ?
 			OCONF_PIPE_A : OCONF_PIPE_B;
-		intel_overlay_unmap_regs(overlay, regs);
+		intel_legacy_overlay_unmap_regs(overlay, regs);
 
-		ret = intel_overlay_on(overlay);
+		ret = intel_legacy_overlay_on(overlay);
 		if (ret != 0)
 			goto out_unpin;
 	}
 
-	regs = intel_overlay_map_regs(overlay);
+	regs = intel_legacy_overlay_map_regs(overlay);
 	if (!regs) {
 		ret = -ENOMEM;
 		goto out_unpin;
@@ -846,9 +846,9 @@ static int intel_overlay_do_put_image(struct intel_overlay *overlay,
 
 	regs->OCMD = overlay_cmd_reg(params);
 
-	intel_overlay_unmap_regs(overlay, regs);
+	intel_legacy_overlay_unmap_regs(overlay, regs);
 
-	ret = intel_overlay_continue(overlay, scale_changed);
+	ret = intel_legacy_overlay_continue(overlay, scale_changed);
 	if (ret)
 		goto out_unpin;
 
@@ -862,7 +862,7 @@ out_unpin:
 	return ret;
 }
 
-int intel_overlay_switch_off(struct intel_overlay *overlay)
+int intel_legacy_overlay_switch_off(struct intel_legacy_overlay *overlay)
 {
 	struct overlay_registers *regs;
 	struct drm_device *dev = overlay->dev;
@@ -871,30 +871,30 @@ int intel_overlay_switch_off(struct intel_overlay *overlay)
 	BUG_ON(!mutex_is_locked(&dev->struct_mutex));
 	BUG_ON(!mutex_is_locked(&dev->mode_config.mutex));
 
-	ret = intel_overlay_recover_from_interrupt(overlay);
+	ret = intel_legacy_overlay_recover_from_interrupt(overlay);
 	if (ret != 0)
 		return ret;
 
 	if (!overlay->active)
 		return 0;
 
-	ret = intel_overlay_release_old_vid(overlay);
+	ret = intel_legacy_overlay_release_old_vid(overlay);
 	if (ret != 0)
 		return ret;
 
-	regs = intel_overlay_map_regs(overlay);
+	regs = intel_legacy_overlay_map_regs(overlay);
 	regs->OCMD = 0;
-	intel_overlay_unmap_regs(overlay, regs);
+	intel_legacy_overlay_unmap_regs(overlay, regs);
 
-	ret = intel_overlay_off(overlay);
+	ret = intel_legacy_overlay_off(overlay);
 	if (ret != 0)
 		return ret;
 
-	intel_overlay_off_tail(overlay);
+	intel_legacy_overlay_off_tail(overlay);
 	return 0;
 }
 
-static int check_overlay_possible_on_crtc(struct intel_overlay *overlay,
+static int check_overlay_possible_on_crtc(struct intel_legacy_overlay *overlay,
 					  struct intel_crtc *crtc)
 {
 	drm_i915_private_t *dev_priv = overlay->dev->dev_private;
@@ -910,7 +910,7 @@ static int check_overlay_possible_on_crtc(struct intel_overlay *overlay,
 	return 0;
 }
 
-static void update_pfit_vscale_ratio(struct intel_overlay *overlay)
+static void update_pfit_vscale_ratio(struct intel_legacy_overlay *overlay)
 {
 	struct drm_device *dev = overlay->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -934,7 +934,7 @@ static void update_pfit_vscale_ratio(struct intel_overlay *overlay)
 	overlay->pfit_vscale_ratio = ratio;
 }
 
-static int check_overlay_dst(struct intel_overlay *overlay,
+static int check_overlay_dst(struct intel_legacy_overlay *overlay,
 			     struct drm_intel_overlay_put_image *rec)
 {
 	struct drm_display_mode *mode = &overlay->crtc->base.mode;
@@ -1106,7 +1106,7 @@ int intel_overlay_put_image(struct drm_device *dev, void *data,
 {
 	struct drm_intel_overlay_put_image *put_image_rec = data;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct intel_overlay *overlay;
+	struct intel_legacy_overlay *overlay;
 	struct drm_mode_object *drmmode_obj;
 	struct intel_crtc *crtc;
 	struct drm_i915_gem_object *new_bo;
@@ -1128,7 +1128,7 @@ int intel_overlay_put_image(struct drm_device *dev, void *data,
 		mutex_lock(&dev->mode_config.mutex);
 		mutex_lock(&dev->struct_mutex);
 
-		ret = intel_overlay_switch_off(overlay);
+		ret = intel_legacy_overlay_switch_off(overlay);
 
 		mutex_unlock(&dev->struct_mutex);
 		mutex_unlock(&dev->mode_config.mutex);
@@ -1164,13 +1164,13 @@ int intel_overlay_put_image(struct drm_device *dev, void *data,
 		goto out_unlock;
 	}
 
-	ret = intel_overlay_recover_from_interrupt(overlay);
+	ret = intel_legacy_overlay_recover_from_interrupt(overlay);
 	if (ret != 0)
 		goto out_unlock;
 
 	if (overlay->crtc != crtc) {
 		struct drm_display_mode *mode = &crtc->base.mode;
-		ret = intel_overlay_switch_off(overlay);
+		ret = intel_legacy_overlay_switch_off(overlay);
 		if (ret != 0)
 			goto out_unlock;
 
@@ -1232,7 +1232,7 @@ int intel_overlay_put_image(struct drm_device *dev, void *data,
 	if (ret != 0)
 		goto out_unlock;
 
-	ret = intel_overlay_do_put_image(overlay, new_bo, params);
+	ret = intel_legacy_overlay_do_put_image(overlay, new_bo, params);
 	if (ret != 0)
 		goto out_unlock;
 
@@ -1253,7 +1253,7 @@ out_free:
 	return ret;
 }
 
-static void update_reg_attrs(struct intel_overlay *overlay,
+static void update_reg_attrs(struct intel_legacy_overlay *overlay,
 			     struct overlay_registers *regs)
 {
 	regs->OCLRC0 = (overlay->contrast << 18) | (overlay->brightness & 0xff);
@@ -1309,7 +1309,7 @@ int intel_overlay_attrs(struct drm_device *dev, void *data,
 {
 	struct drm_intel_overlay_attrs *attrs = data;
         drm_i915_private_t *dev_priv = dev->dev_private;
-	struct intel_overlay *overlay;
+	struct intel_legacy_overlay *overlay;
 	struct overlay_registers *regs;
 	int ret;
 
@@ -1355,7 +1355,7 @@ int intel_overlay_attrs(struct drm_device *dev, void *data,
 		overlay->contrast   = attrs->contrast;
 		overlay->saturation = attrs->saturation;
 
-		regs = intel_overlay_map_regs(overlay);
+		regs = intel_legacy_overlay_map_regs(overlay);
 		if (!regs) {
 			ret = -ENOMEM;
 			goto out_unlock;
@@ -1363,7 +1363,7 @@ int intel_overlay_attrs(struct drm_device *dev, void *data,
 
 		update_reg_attrs(overlay, regs);
 
-		intel_overlay_unmap_regs(overlay, regs);
+		intel_legacy_overlay_unmap_regs(overlay, regs);
 
 		if (attrs->flags & I915_OVERLAY_UPDATE_GAMMA) {
 			if (IS_GEN2(dev))
@@ -1398,7 +1398,7 @@ out_unlock:
 void intel_setup_overlay(struct drm_device *dev)
 {
         drm_i915_private_t *dev_priv = dev->dev_private;
-	struct intel_overlay *overlay;
+	struct intel_legacy_overlay *overlay;
 	struct drm_i915_gem_object *reg_bo;
 	struct overlay_registers *regs;
 	int ret;
@@ -1406,7 +1406,7 @@ void intel_setup_overlay(struct drm_device *dev)
 	if (!HAS_OVERLAY(dev))
 		return;
 
-	overlay = kzalloc(sizeof(struct intel_overlay), GFP_KERNEL);
+	overlay = kzalloc(sizeof(struct intel_legacy_overlay), GFP_KERNEL);
 	if (!overlay)
 		return;
 	overlay->dev = dev;
@@ -1446,7 +1446,7 @@ void intel_setup_overlay(struct drm_device *dev)
 	overlay->contrast = 75;
 	overlay->saturation = 146;
 
-	regs = intel_overlay_map_regs(overlay);
+	regs = intel_legacy_overlay_map_regs(overlay);
 	if (!regs)
 		goto out_free_bo;
 
@@ -1454,7 +1454,7 @@ void intel_setup_overlay(struct drm_device *dev)
 	update_polyphase_filter(regs);
 	update_reg_attrs(overlay, regs);
 
-	intel_overlay_unmap_regs(overlay, regs);
+	intel_legacy_overlay_unmap_regs(overlay, regs);
 
 	dev_priv->overlay = overlay;
 	DRM_INFO("initialized overlay support\n");
@@ -1488,7 +1488,7 @@ void intel_cleanup_overlay(struct drm_device *dev)
 #ifdef CONFIG_DEBUG_FS
 #include <linux/seq_file.h>
 
-struct intel_overlay_error_state {
+struct intel_legacy_overlay_error_state {
 	struct overlay_registers regs;
 	unsigned long base;
 	u32 dovsta;
@@ -1496,7 +1496,7 @@ struct intel_overlay_error_state {
 };
 
 static struct overlay_registers *
-intel_overlay_map_regs_atomic(struct intel_overlay *overlay)
+intel_legacy_overlay_map_regs_atomic(struct intel_legacy_overlay *overlay)
 {
 	drm_i915_private_t *dev_priv = overlay->dev->dev_private;
 	struct overlay_registers *regs;
@@ -1510,7 +1510,7 @@ intel_overlay_map_regs_atomic(struct intel_overlay *overlay)
 	return regs;
 }
 
-static void intel_overlay_unmap_regs_atomic(struct intel_overlay *overlay,
+static void intel_legacy_overlay_unmap_regs_atomic(struct intel_legacy_overlay *overlay,
 					    struct overlay_registers *regs)
 {
 	if (!OVERLAY_NEEDS_PHYSICAL(overlay->dev))
@@ -1518,12 +1518,12 @@ static void intel_overlay_unmap_regs_atomic(struct intel_overlay *overlay,
 }
 
 
-struct intel_overlay_error_state *
-intel_overlay_capture_error_state(struct drm_device *dev)
+struct intel_legacy_overlay_error_state *
+intel_legacy_overlay_capture_error_state(struct drm_device *dev)
 {
         drm_i915_private_t *dev_priv = dev->dev_private;
-	struct intel_overlay *overlay = dev_priv->overlay;
-	struct intel_overlay_error_state *error;
+	struct intel_legacy_overlay *overlay = dev_priv->overlay;
+	struct intel_legacy_overlay_error_state *error;
 	struct overlay_registers __iomem *regs;
 
 	if (!overlay || !overlay->active)
@@ -1540,12 +1540,12 @@ intel_overlay_capture_error_state(struct drm_device *dev)
 	else
 		error->base = (long) overlay->reg_bo->gtt_offset;
 
-	regs = intel_overlay_map_regs_atomic(overlay);
+	regs = intel_legacy_overlay_map_regs_atomic(overlay);
 	if (!regs)
 		goto err;
 
 	memcpy_fromio(&error->regs, regs, sizeof(struct overlay_registers));
-	intel_overlay_unmap_regs_atomic(overlay, regs);
+	intel_legacy_overlay_unmap_regs_atomic(overlay, regs);
 
 	return error;
 
@@ -1555,7 +1555,7 @@ err:
 }
 
 void
-intel_overlay_print_error_state(struct seq_file *m, struct intel_overlay_error_state *error)
+intel_legacy_overlay_print_error_state(struct seq_file *m, struct intel_legacy_overlay_error_state *error)
 {
 	seq_printf(m, "Overlay, status: 0x%08x, interrupt: 0x%08x\n",
 		   error->dovsta, error->isr);
-- 
1.7.4.1


