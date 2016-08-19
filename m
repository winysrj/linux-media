Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51092 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754472AbcHSIj2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:39:28 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/6] drm: Unconstify state argument to prepare_fb()/cleanup_fb()
Date: Fri, 19 Aug 2016 11:39:30 +0300
Message-Id: <1471595974-28960-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions might need to modify the state to store memory-related
data.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c | 4 ++--
 drivers/gpu/drm/i915/intel_display.c            | 4 ++--
 drivers/gpu/drm/i915/intel_drv.h                | 4 ++--
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c       | 4 ++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c       | 4 ++--
 drivers/gpu/drm/omapdrm/omap_plane.c            | 4 ++--
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c     | 4 ++--
 include/drm/drm_modeset_helper_vtables.h        | 4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index 016c191221f3..ae2b31dd9487 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -755,7 +755,7 @@ static int atmel_hlcdc_plane_atomic_check(struct drm_plane *p,
 }
 
 static int atmel_hlcdc_plane_prepare_fb(struct drm_plane *p,
-					const struct drm_plane_state *new_state)
+					struct drm_plane_state *new_state)
 {
 	/*
 	 * FIXME: we should avoid this const -> non-const cast but it's
@@ -780,7 +780,7 @@ static int atmel_hlcdc_plane_prepare_fb(struct drm_plane *p,
 }
 
 static void atmel_hlcdc_plane_cleanup_fb(struct drm_plane *p,
-				const struct drm_plane_state *old_state)
+				struct drm_plane_state *old_state)
 {
 	/*
 	 * FIXME: we should avoid this const -> non-const cast but it's
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index dcf93b3d4fb6..cf70de704b2a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -13974,7 +13974,7 @@ static const struct drm_crtc_funcs intel_crtc_funcs = {
  */
 int
 intel_prepare_plane_fb(struct drm_plane *plane,
-		       const struct drm_plane_state *new_state)
+		       struct drm_plane_state *new_state)
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_framebuffer *fb = new_state->fb;
@@ -14058,7 +14058,7 @@ intel_prepare_plane_fb(struct drm_plane *plane,
  */
 void
 intel_cleanup_plane_fb(struct drm_plane *plane,
-		       const struct drm_plane_state *old_state)
+		       struct drm_plane_state *old_state)
 {
 	struct drm_device *dev = plane->dev;
 	struct intel_plane_state *old_intel_state;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index cc937a19b1ba..aa0d6679eff3 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -1238,9 +1238,9 @@ void intel_finish_page_flip_cs(struct drm_i915_private *dev_priv, int pipe);
 void intel_finish_page_flip_mmio(struct drm_i915_private *dev_priv, int pipe);
 void intel_check_page_flip(struct drm_i915_private *dev_priv, int pipe);
 int intel_prepare_plane_fb(struct drm_plane *plane,
-			   const struct drm_plane_state *new_state);
+			   struct drm_plane_state *new_state);
 void intel_cleanup_plane_fb(struct drm_plane *plane,
-			    const struct drm_plane_state *old_state);
+			    struct drm_plane_state *old_state);
 int intel_plane_atomic_get_property(struct drm_plane *plane,
 				    const struct drm_plane_state *state,
 				    struct drm_property *property,
diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c
index 9f96dfe67769..0689a06bec8e 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c
@@ -99,7 +99,7 @@ static const struct drm_plane_funcs mdp4_plane_funcs = {
 };
 
 static int mdp4_plane_prepare_fb(struct drm_plane *plane,
-		const struct drm_plane_state *new_state)
+		struct drm_plane_state *new_state)
 {
 	struct mdp4_plane *mdp4_plane = to_mdp4_plane(plane);
 	struct mdp4_kms *mdp4_kms = get_kms(plane);
@@ -113,7 +113,7 @@ static int mdp4_plane_prepare_fb(struct drm_plane *plane,
 }
 
 static void mdp4_plane_cleanup_fb(struct drm_plane *plane,
-		const struct drm_plane_state *old_state)
+		struct drm_plane_state *old_state)
 {
 	struct mdp4_plane *mdp4_plane = to_mdp4_plane(plane);
 	struct mdp4_kms *mdp4_kms = get_kms(plane);
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
index 432c09836b0e..1ef024df51a8 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
@@ -250,7 +250,7 @@ static const struct drm_plane_funcs mdp5_plane_funcs = {
 };
 
 static int mdp5_plane_prepare_fb(struct drm_plane *plane,
-		const struct drm_plane_state *new_state)
+		struct drm_plane_state *new_state)
 {
 	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
@@ -264,7 +264,7 @@ static int mdp5_plane_prepare_fb(struct drm_plane *plane,
 }
 
 static void mdp5_plane_cleanup_fb(struct drm_plane *plane,
-		const struct drm_plane_state *old_state)
+		struct drm_plane_state *old_state)
 {
 	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index 5252ab720e70..bdfbb6181398 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -60,7 +60,7 @@ to_omap_plane_state(struct drm_plane_state *state)
 }
 
 static int omap_plane_prepare_fb(struct drm_plane *plane,
-				 const struct drm_plane_state *new_state)
+				 struct drm_plane_state *new_state)
 {
 	if (!new_state->fb)
 		return 0;
@@ -69,7 +69,7 @@ static int omap_plane_prepare_fb(struct drm_plane *plane,
 }
 
 static void omap_plane_cleanup_fb(struct drm_plane *plane,
-				  const struct drm_plane_state *old_state)
+				  struct drm_plane_state *old_state)
 {
 	if (old_state->fb)
 		omap_framebuffer_unpin(old_state->fb);
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 91305eb7d312..a2466e37b0a1 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -569,7 +569,7 @@ static void vop_plane_destroy(struct drm_plane *plane)
 }
 
 static int vop_plane_prepare_fb(struct drm_plane *plane,
-				const struct drm_plane_state *new_state)
+				struct drm_plane_state *new_state)
 {
 	if (plane->state->fb)
 		drm_framebuffer_reference(plane->state->fb);
@@ -578,7 +578,7 @@ static int vop_plane_prepare_fb(struct drm_plane *plane,
 }
 
 static void vop_plane_cleanup_fb(struct drm_plane *plane,
-				 const struct drm_plane_state *old_state)
+				 struct drm_plane_state *old_state)
 {
 	if (old_state->fb)
 		drm_framebuffer_unreference(old_state->fb);
diff --git a/include/drm/drm_modeset_helper_vtables.h b/include/drm/drm_modeset_helper_vtables.h
index b55f21857a98..bfe145e602d2 100644
--- a/include/drm/drm_modeset_helper_vtables.h
+++ b/include/drm/drm_modeset_helper_vtables.h
@@ -826,7 +826,7 @@ struct drm_plane_helper_funcs {
 	 * everything else must complete successfully.
 	 */
 	int (*prepare_fb)(struct drm_plane *plane,
-			  const struct drm_plane_state *new_state);
+			  struct drm_plane_state *new_state);
 	/**
 	 * @cleanup_fb:
 	 *
@@ -837,7 +837,7 @@ struct drm_plane_helper_funcs {
 	 * transitional plane helpers, but it is optional.
 	 */
 	void (*cleanup_fb)(struct drm_plane *plane,
-			   const struct drm_plane_state *old_state);
+			   struct drm_plane_state *old_state);
 
 	/**
 	 * @atomic_check:
-- 
Regards,

Laurent Pinchart

