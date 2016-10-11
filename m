Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752263AbcJKOyn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:54:43 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: [RFC PATCH 03/11] drm: Extract CRTC/plane disable from drm_framebuffer_remove
Date: Tue, 11 Oct 2016 15:54:00 +0100
Message-Id: <1476197648-24918-4-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for adding an atomic version of the disable code, extract
the actual disable operation into a separate function.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/drm_framebuffer.c |   87 +++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
index 398efd6..528f75d 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -795,22 +795,61 @@ void drm_framebuffer_cleanup(struct drm_framebuffer *fb)
 EXPORT_SYMBOL(drm_framebuffer_cleanup);
 
 /**
- * drm_framebuffer_remove - remove and unreference a framebuffer object
+ * __drm_framebuffer_remove - remove all usage of a framebuffer object
+ * @dev: drm device
  * @fb: framebuffer to remove
  *
  * Scans all the CRTCs and planes in @dev's mode_config.  If they're
- * using @fb, removes it, setting it to NULL. Then drops the reference to the
- * passed-in framebuffer. Might take the modeset locks.
+ * using @fb, removes it, setting it to NULL. Takes the modeset locks.
  *
- * Note that this function optimizes the cleanup away if the caller holds the
- * last reference to the framebuffer. It is also guaranteed to not take the
- * modeset locks in this case.
+ * Returns:
+ * true if the framebuffer was successfully removed from use
  */
-void drm_framebuffer_remove(struct drm_framebuffer *fb)
+static bool __drm_framebuffer_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 {
-	struct drm_device *dev;
 	struct drm_crtc *crtc;
 	struct drm_plane *plane;
+	bool ret = true;
+
+	drm_modeset_lock_all(dev);
+	/* remove from any CRTC */
+	drm_for_each_crtc(crtc, dev) {
+		if (crtc->primary->fb == fb) {
+			/* should turn off the crtc */
+			if (drm_crtc_force_disable(crtc))
+				ret = false;
+		}
+	}
+
+	drm_for_each_plane(plane, dev) {
+		if (plane->fb == fb)
+			/* TODO: Propagate error here? */
+			drm_plane_force_disable(plane);
+	}
+	drm_modeset_unlock_all(dev);
+
+	return ret;
+}
+
+/**
+ * drm_framebuffer_remove - remove and unreference a framebuffer object
+ * @fb: framebuffer to remove
+ *
+ * drm ABI mandates that we remove any deleted framebuffers from active usage.
+ * This function takes care of this detail, disabling any CRTCs/Planes which
+ * are using the framebuffer being removed.
+ *
+ * Since most sane clients only remove framebuffers they no longer need, we
+ * skip the disable step if the caller holds the last reference to the
+ * framebuffer. It is also guaranteed to not take the modeset locks in
+ * this case.
+ *
+ * Before returning this function drops (what should be) the last reference
+ * on the framebuffer.
+ */
+void drm_framebuffer_remove(struct drm_framebuffer *fb)
+{
+	struct drm_device *dev;
 
 	if (!fb)
 		return;
@@ -820,37 +859,19 @@ void drm_framebuffer_remove(struct drm_framebuffer *fb)
 	WARN_ON(!list_empty(&fb->filp_head));
 
 	/*
-	 * drm ABI mandates that we remove any deleted framebuffers from active
-	 * useage. But since most sane clients only remove framebuffers they no
-	 * longer need, try to optimize this away.
-	 *
 	 * Since we're holding a reference ourselves, observing a refcount of 1
-	 * means that we're the last holder and can skip it. Also, the refcount
-	 * can never increase from 1 again, so we don't need any barriers or
-	 * locks.
+	 * means that we're the last holder and can skip the disable. Also, the
+	 * refcount can never increase from 1 again, so we don't need any
+	 * barriers or locks.
 	 *
-	 * Note that userspace could try to race with use and instate a new
+	 * Note that userspace could try to race with us and instate a new
 	 * usage _after_ we've cleared all current ones. End result will be an
 	 * in-use fb with fb-id == 0. Userspace is allowed to shoot its own foot
 	 * in this manner.
 	 */
-	if (drm_framebuffer_read_refcount(fb) > 1) {
-		drm_modeset_lock_all(dev);
-		/* remove from any CRTC */
-		drm_for_each_crtc(crtc, dev) {
-			if (crtc->primary->fb == fb) {
-				/* should turn off the crtc */
-				if (drm_crtc_force_disable(crtc))
-					DRM_ERROR("failed to reset crtc %p when fb was deleted\n", crtc);
-			}
-		}
-
-		drm_for_each_plane(plane, dev) {
-			if (plane->fb == fb)
-				drm_plane_force_disable(plane);
-		}
-		drm_modeset_unlock_all(dev);
-	}
+	if (drm_framebuffer_read_refcount(fb) > 1)
+		if (!__drm_framebuffer_remove(dev, fb))
+			DRM_ERROR("failed to remove fb from active usage\n");
 
 	drm_framebuffer_unreference(fb);
 }
-- 
1.7.9.5

