Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34296 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754046AbcJZI4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:08 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v2 8/9] drm: writeback: Add out-fences for writeback connectors
Date: Wed, 26 Oct 2016 09:55:07 +0100
Message-Id: <1477472108-27222-9-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the OUT_FENCE_PTR property to writeback connectors, to enable
userspace to get a fence which will signal once the writeback is
complete.

A timeline is added to drm_connector for use by the writeback
out-fences. It is up to drivers to check for a fence in the
connector_state and signal the it appropriately when their writeback has
finished.

It is not allowed to request an out-fence without a framebuffer attached
to the connector.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/drm_atomic.c        |   60 +++++++++++++++++++++++---
 drivers/gpu/drm/drm_atomic_helper.c |    5 ++-
 drivers/gpu/drm/drm_writeback.c     |   80 +++++++++++++++++++++++++++++++++++
 include/drm/drm_connector.h         |   14 ++++++
 include/drm/drm_writeback.h         |    2 +
 5 files changed, 155 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 3f8fc97..061ea13 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -30,6 +30,7 @@
 #include <drm/drm_atomic.h>
 #include <drm/drm_mode.h>
 #include <drm/drm_plane_helper.h>
+#include <drm/drm_writeback.h>
 #include <linux/sync_file.h>
 
 #include "drm_crtc_internal.h"
@@ -646,6 +647,12 @@ static int drm_atomic_connector_check(struct drm_connector *connector,
 		return -EINVAL;
 	}
 
+	if (state->out_fence && !state->fb) {
+		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] requesting out-fence without framebuffer\n",
+				 connector->base.id, connector->name);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -1047,6 +1054,8 @@ int drm_atomic_connector_set_property(struct drm_connector *connector,
 		drm_atomic_set_fb_for_connector(state, fb);
 		if (fb)
 			drm_framebuffer_unreference(fb);
+	} else if (property == config->prop_out_fence_ptr) {
+		state->out_fence_ptr = u64_to_user_ptr(val);
 	} else if (connector->funcs->atomic_set_property) {
 		return connector->funcs->atomic_set_property(connector,
 				state, property, val);
@@ -1088,6 +1097,8 @@ drm_atomic_connector_get_property(struct drm_connector *connector,
 	} else if (property == config->writeback_fb_id_property) {
 		/* Writeback framebuffer is one-shot, write and forget */
 		*val = 0;
+	} else if (property == config->prop_out_fence_ptr) {
+		*val = 0;
 	} else if (connector->funcs->atomic_get_property) {
 		return connector->funcs->atomic_get_property(connector,
 				state, property, val);
@@ -1736,6 +1747,39 @@ static int setup_out_fence(struct drm_out_fence_state *fence_state,
 	return 0;
 }
 
+static int setup_connector_out_fences(struct drm_atomic_state *state,
+				      struct drm_out_fence_state *fence_state,
+				      int *fence_idx)
+{
+	struct drm_connector *conn;
+	struct drm_connector_state *conn_state;
+	int i, ret;
+
+	for_each_connector_in_state(state, conn, conn_state, i) {
+		struct fence *fence;
+
+		if (!conn_state->out_fence_ptr)
+			continue;
+
+		fence = drm_writeback_get_out_fence(conn, conn_state);
+		if (!fence)
+			return -ENOMEM;
+
+		ret = setup_out_fence(&fence_state[(*fence_idx)++],
+				      conn_state->out_fence_ptr,
+				      fence);
+		if (ret) {
+			fence_put(fence);
+			return ret;
+		}
+
+		/* One-time usage only */
+		conn_state->out_fence_ptr = NULL;
+	}
+
+	return 0;
+}
+
 int drm_mode_atomic_ioctl(struct drm_device *dev,
 			  void *data, struct drm_file *file_priv)
 {
@@ -1868,8 +1912,8 @@ retry:
 		drm_mode_object_unreference(obj);
 	}
 
-	fence_state = kcalloc(dev->mode_config.num_crtc, sizeof(*fence_state),
-			      GFP_KERNEL);
+	fence_state = kcalloc(dev->mode_config.num_crtc + state->num_connector,
+			      sizeof(*fence_state), GFP_KERNEL);
 	if (!fence_state) {
 		ret = -ENOMEM;
 		goto out;
@@ -1929,10 +1973,16 @@ retry:
 		 * Below we call drm_atomic_state_free for it.
 		 */
 		ret = drm_atomic_check_only(state);
-	} else if (arg->flags & DRM_MODE_ATOMIC_NONBLOCK) {
-		ret = drm_atomic_nonblocking_commit(state);
 	} else {
-		ret = drm_atomic_commit(state);
+		ret = setup_connector_out_fences(state, fence_state,
+						 &fence_idx);
+		if (ret)
+			goto out;
+
+		if (arg->flags & DRM_MODE_ATOMIC_NONBLOCK)
+			ret = drm_atomic_nonblocking_commit(state);
+		else
+			ret = drm_atomic_commit(state);
 	}
 
 	if (!ret)
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index bba8672..88da299 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -3234,8 +3234,9 @@ __drm_atomic_helper_connector_duplicate_state(struct drm_connector *connector,
 	if (state->crtc)
 		drm_connector_reference(connector);
 
-	/* Don't copy over framebuffers, they are used only once */
+	/* Don't copy over framebuffers or fences, they are used only once */
 	state->fb = NULL;
+	state->out_fence = NULL;
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_duplicate_state);
 
@@ -3365,6 +3366,8 @@ __drm_atomic_helper_connector_destroy_state(struct drm_connector_state *state)
 		drm_connector_unreference(state->connector);
 	if (state->fb)
 		drm_framebuffer_unreference(state->fb);
+
+	fence_put(state->out_fence);
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_destroy_state);
 
diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
index 5a6e0ad..4a6ef30 100644
--- a/drivers/gpu/drm/drm_writeback.c
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -11,6 +11,7 @@
 #include <drm/drm_crtc.h>
 #include <drm/drm_property.h>
 #include <drm/drmP.h>
+#include <linux/fence.h>
 
 /**
  * DOC: overview
@@ -32,6 +33,16 @@
  * explicitly cleared in order to make a subsequent commit which doesn't use
  * writeback.
  *
+ * Unlike with planes, when a writeback framebuffer is removed by userspace DRM
+ * makes no attempt to remove it from active use by the connector. This is
+ * because no method is provided to abort a writeback operation, and in any
+ * case making a new commit whilst a writeback is ongoing is undefined (see
+ * OUT_FENCE_PTR below). As soon as the current writeback is finished, the
+ * framebuffer will automatically no longer be in active use. As it will also
+ * have already been removed from the framebuffer list, there will be no way for
+ * any userspace application to retrieve a reference to it in the intervening
+ * period.
+ *
  * Writeback connectors have several additional properties, which userspace
  * can use to query and control them:
  *
@@ -52,8 +63,48 @@
  *  "PIXEL_FORMATS_SIZE":
  *	Immutable unsigned range property storing the number of entries in the
  *	PIXEL_FORMATS array.
+ *
+ *  "OUT_FENCE_PTR":
+ *	Userspace can provide the address of a 64-bit integer in this property,
+ *	which will be filled with a sync_file file descriptor by the kernel.
+ *	The sync_file will signal when the associated writeback has finished.
+ *	Userspace should wait for this fence to signal before making another
+ *	commit affecting any of the same CRTCs, Planes or Connectors.
+ *	**Failure to do so will result in undefined behaviour.**
+ *	For this reason it is strongly recommended that all userspace
+ *	applications making use of writeback connectors *always* retrieve an
+ *	out-fence for the commit and use it appropriately.
+ *	From userspace, this property will always read as zero.
  */
 
+#define fence_to_connector(x) container_of(x->lock, struct drm_connector, fence_lock)
+
+static const char *drm_writeback_fence_get_driver_name(struct fence *fence)
+{
+	struct drm_connector *connector = fence_to_connector(fence);
+
+	return connector->dev->driver->name;
+}
+
+static const char *drm_writeback_fence_get_timeline_name(struct fence *fence)
+{
+	struct drm_connector *connector = fence_to_connector(fence);
+
+	return connector->timeline_name;
+}
+
+static bool drm_writeback_fence_enable_signaling(struct fence *fence)
+{
+	return true;
+}
+
+static const struct fence_ops drm_writeback_fence_ops = {
+	.get_driver_name = drm_writeback_fence_get_driver_name,
+	.get_timeline_name = drm_writeback_fence_get_timeline_name,
+	.enable_signaling = drm_writeback_fence_enable_signaling,
+	.wait = fence_default_wait,
+};
+
 /**
  * create_writeback_properties - Create writeback connector-specific properties
  * @dev: DRM device
@@ -136,6 +187,14 @@ int drm_writeback_connector_init(struct drm_device *dev,
 	if (ret)
 		goto fail;
 
+	connector->fence_context = fence_context_alloc(1);
+	spin_lock_init(&connector->fence_lock);
+	snprintf(connector->timeline_name, sizeof(connector->timeline_name),
+		 "CONNECTOR:%d", connector->base.id);
+
+	drm_object_attach_property(&connector->base,
+				   config->prop_out_fence_ptr, 0);
+
 	drm_object_attach_property(&connector->base,
 				   config->writeback_fb_id_property, 0);
 
@@ -155,3 +214,24 @@ fail:
 	return ret;
 }
 EXPORT_SYMBOL(drm_writeback_connector_init);
+
+struct fence *drm_writeback_get_out_fence(struct drm_connector *connector,
+					  struct drm_connector_state *conn_state)
+{
+	struct fence *fence;
+
+	if (WARN_ON(connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK))
+		return NULL;
+
+	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence)
+		return NULL;
+
+	fence_init(fence, &drm_writeback_fence_ops, &connector->fence_lock,
+		   connector->fence_context, ++connector->fence_seqno);
+
+	conn_state->out_fence = fence_get(fence);
+
+	return fence;
+}
+EXPORT_SYMBOL(drm_writeback_get_out_fence);
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index a5e3778..7d40537 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -199,6 +199,7 @@ int drm_display_info_set_bus_formats(struct drm_display_info *info,
  * @best_encoder: can be used by helpers and drivers to select the encoder
  * @state: backpointer to global drm_atomic_state
  * @fb: Writeback framebuffer, for DRM_MODE_CONNECTOR_WRITEBACK
+ * @out_fence: Fence which will clear when the framebuffer write has finished
  */
 struct drm_connector_state {
 	struct drm_connector *connector;
@@ -216,6 +217,9 @@ struct drm_connector_state {
 	struct drm_atomic_state *state;
 
 	struct drm_framebuffer *fb;  /* do not write directly, use drm_atomic_set_fb_for_connector() */
+
+	struct fence *out_fence;
+	u64 __user *out_fence_ptr;
 };
 
 /**
@@ -546,6 +550,10 @@ struct drm_cmdline_mode {
  * @tile_v_loc: vertical location of this tile
  * @tile_h_size: horizontal size of this tile.
  * @tile_v_size: vertical size of this tile.
+ * @fence_context: context for fence signalling
+ * @fence_lock: fence lock for the fence context
+ * @fence_seqno: seqno variable to create fences
+ * @timeline_name: fence timeline name
  *
  * Each connector may be connected to one or more CRTCs, or may be clonable by
  * another connector if they can share a CRTC.  Each connector also has a specific
@@ -694,6 +702,12 @@ struct drm_connector {
 	uint8_t num_h_tile, num_v_tile;
 	uint8_t tile_h_loc, tile_v_loc;
 	uint16_t tile_h_size, tile_v_size;
+
+	/* fence timelines info for DRM out-fences */
+	unsigned int fence_context;
+	spinlock_t fence_lock;
+	unsigned long fence_seqno;
+	char timeline_name[32];
 };
 
 #define obj_to_connector(x) container_of(x, struct drm_connector, base)
diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
index afdc2742..01f33bc 100644
--- a/include/drm/drm_writeback.h
+++ b/include/drm/drm_writeback.h
@@ -16,4 +16,6 @@ int drm_writeback_connector_init(struct drm_device *dev,
 				 const struct drm_connector_funcs *funcs,
 				 u32 *formats, int n_formats);
 
+struct fence *drm_writeback_get_out_fence(struct drm_connector *connector,
+					  struct drm_connector_state *conn_state);
 #endif
-- 
1.7.9.5

