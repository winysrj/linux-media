Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35596 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752666AbcJKOyo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:54:44 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: [RFC PATCH 06/11] drm: Expose fb_id property for writeback connectors
Date: Tue, 11 Oct 2016 15:54:03 +0100
Message-Id: <1476197648-24918-7-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Expose the framebuffer for writeback connectors to userspace by
attaching the fb_id property to them.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/drm_atomic.c    |    9 +++++++++
 drivers/gpu/drm/drm_connector.c |    4 ++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index b16b4fc..82e8e3a 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -986,12 +986,19 @@ int drm_atomic_connector_set_property(struct drm_connector *connector,
 		 * now?) atomic writes to DPMS property:
 		 */
 		return -EINVAL;
+	} else if (property == config->prop_fb_id) {
+		struct drm_framebuffer *fb = drm_framebuffer_lookup(dev, val);
+		drm_atomic_set_fb_for_connector(state, fb);
+		if (fb)
+			drm_framebuffer_unreference(fb);
 	} else if (connector->funcs->atomic_set_property) {
 		return connector->funcs->atomic_set_property(connector,
 				state, property, val);
 	} else {
 		return -EINVAL;
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL(drm_atomic_connector_set_property);
 
@@ -1022,6 +1029,8 @@ drm_atomic_connector_get_property(struct drm_connector *connector,
 		*val = (state->crtc) ? state->crtc->base.id : 0;
 	} else if (property == config->dpms_property) {
 		*val = connector->dpms;
+	} else if (property == config->prop_fb_id) {
+		*val = (state->fb) ? state->fb->base.id : 0;
 	} else if (connector->funcs->atomic_get_property) {
 		return connector->funcs->atomic_get_property(connector,
 				state, property, val);
diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 027d7a9..fb83870 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -249,6 +249,10 @@ int drm_connector_init(struct drm_device *dev,
 		drm_object_attach_property(&connector->base, config->prop_crtc_id, 0);
 	}
 
+	if (connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+		drm_object_attach_property(&connector->base,
+					   config->prop_fb_id, 0);
+
 	connector->debugfs_entry = NULL;
 out_put_type_id:
 	if (ret)
-- 
1.7.9.5

