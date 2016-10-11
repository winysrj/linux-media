Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35594 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752602AbcJKOyo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:54:44 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: [RFC PATCH 05/11] drm: Add fb to connector state
Date: Tue, 11 Oct 2016 15:54:02 +0100
Message-Id: <1476197648-24918-6-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a framebuffer to the connector state, for use as the output target
by writeback connectors.

If a framebuffer is in use by a writeback connector when userspace
removes it, it is handled by removing the framebuffer from the connector.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/drm_atomic.c        |   31 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_atomic_helper.c |    4 ++++
 drivers/gpu/drm/drm_framebuffer.c   |   24 ++++++++++++++++++++----
 include/drm/drm_atomic.h            |    3 +++
 include/drm/drm_connector.h         |    3 +++
 5 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 2373960..b16b4fc 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1205,6 +1205,37 @@ drm_atomic_set_crtc_for_connector(struct drm_connector_state *conn_state,
 EXPORT_SYMBOL(drm_atomic_set_crtc_for_connector);
 
 /**
+ * drm_atomic_set_fb_for_connector - set framebuffer for (writeback) connector
+ * @connector_state: atomic state object for the connector
+ * @fb: fb to use for the connector
+ *
+ * This is used to set the framebuffer for a writeback connector, which outputs
+ * to a buffer instead of an actual physical connector.
+ * Changing the assigned framebuffer requires us to grab a reference to the new
+ * fb and drop the reference to the old fb, if there is one. This function
+ * takes care of all these details besides updating the pointer in the
+ * state object itself.
+ */
+void
+drm_atomic_set_fb_for_connector(struct drm_connector_state *conn_state,
+				struct drm_framebuffer *fb)
+{
+	if (conn_state->fb)
+		drm_framebuffer_unreference(conn_state->fb);
+	if (fb)
+		drm_framebuffer_reference(fb);
+	conn_state->fb = fb;
+
+	if (fb)
+		DRM_DEBUG_ATOMIC("Set [FB:%d] for connector state %p\n",
+				 fb->base.id, conn_state);
+	else
+		DRM_DEBUG_ATOMIC("Set [NOFB] for connector state %p\n",
+				 conn_state);
+}
+EXPORT_SYMBOL(drm_atomic_set_fb_for_connector);
+
+/**
  * drm_atomic_add_affected_connectors - add connectors for crtc
  * @state: atomic state
  * @crtc: DRM crtc
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 3eecfc1..78ea735 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -3234,6 +3234,8 @@ __drm_atomic_helper_connector_duplicate_state(struct drm_connector *connector,
 	memcpy(state, connector->state, sizeof(*state));
 	if (state->crtc)
 		drm_connector_reference(connector);
+	if (state->fb)
+		drm_framebuffer_reference(state->fb);
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_duplicate_state);
 
@@ -3361,6 +3363,8 @@ __drm_atomic_helper_connector_destroy_state(struct drm_connector_state *state)
 	 */
 	if (state->crtc)
 		drm_connector_unreference(state->connector);
+	if (state->fb)
+		drm_framebuffer_unreference(state->fb);
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_destroy_state);
 
diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
index b02cf73..f66908b1 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -24,6 +24,7 @@
 #include <drm/drmP.h>
 #include <drm/drm_atomic.h>
 #include <drm/drm_auth.h>
+#include <drm/drm_connector.h>
 #include <drm/drm_framebuffer.h>
 
 #include "drm_crtc_internal.h"
@@ -808,6 +809,8 @@ EXPORT_SYMBOL(drm_framebuffer_cleanup);
  * it is removed and the CRTC/plane disabled.
  * The legacy references are dropped and the ->fb pointers set to NULL
  * accordingly.
+ * It also checks for (writeback) connectors which are using @fb, and removes
+ * it if found.
  *
  * Returns:
  * true if the framebuffer was successfully removed from use
@@ -900,7 +903,7 @@ retry:
 		plane_state->src_h = 0;
 	}
 
-	/* All of the connectors in state need disabling */
+	/* All of the connectors currently in state need disabling */
 	for_each_connector_in_state(state, connector, conn_state, i) {
 		ret = drm_atomic_set_crtc_for_connector(conn_state,
 							NULL);
@@ -908,10 +911,23 @@ retry:
 			goto fail;
 	}
 
-	if (WARN_ON(!plane_mask)) {
-		DRM_ERROR("Couldn't find any usage of [FB:%d]\n", fb->base.id);
-		ret = -ENOENT;
+	/* Now find any writeback connectors that need handling */
+	ret = drm_modeset_lock(&state->dev->mode_config.connection_mutex,
+			       state->acquire_ctx);
+	if (ret)
 		goto fail;
+
+	drm_for_each_connector(connector, dev) {
+		conn_state = drm_atomic_get_connector_state(state, connector);
+		if (IS_ERR(conn_state)) {
+			ret = PTR_ERR(conn_state);
+			goto fail;
+		}
+
+		if (conn_state->fb != fb)
+			continue;
+
+		drm_atomic_set_fb_for_connector(conn_state, NULL);
 	}
 
 	ret = drm_atomic_commit(state);
diff --git a/include/drm/drm_atomic.h b/include/drm/drm_atomic.h
index 9701f2d..d9aff06 100644
--- a/include/drm/drm_atomic.h
+++ b/include/drm/drm_atomic.h
@@ -319,6 +319,9 @@ void drm_atomic_set_fb_for_plane(struct drm_plane_state *plane_state,
 int __must_check
 drm_atomic_set_crtc_for_connector(struct drm_connector_state *conn_state,
 				  struct drm_crtc *crtc);
+void
+drm_atomic_set_fb_for_connector(struct drm_connector_state *conn_state,
+				struct drm_framebuffer *fb);
 int __must_check
 drm_atomic_add_affected_connectors(struct drm_atomic_state *state,
 				   struct drm_crtc *crtc);
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 287a610..30a766a 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -198,6 +198,7 @@ int drm_display_info_set_bus_formats(struct drm_display_info *info,
  * @connector: backpointer to the connector
  * @best_encoder: can be used by helpers and drivers to select the encoder
  * @state: backpointer to global drm_atomic_state
+ * @fb: Writeback framebuffer, for DRM_MODE_CONNECTOR_WRITEBACK
  */
 struct drm_connector_state {
 	struct drm_connector *connector;
@@ -213,6 +214,8 @@ struct drm_connector_state {
 	struct drm_encoder *best_encoder;
 
 	struct drm_atomic_state *state;
+
+	struct drm_framebuffer *fb;  /* do not write directly, use drm_atomic_set_fb_for_connector() */
 };
 
 /**
-- 
1.7.9.5

