Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55805 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbeDSJb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:31:27 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] drm: bridge: Add support for static image formats
Date: Thu, 19 Apr 2018 11:31:02 +0200
Message-Id: <1524130269-32688-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for storing image format information in DRM bridges with
associated helper function.

This patch replicates for bridges what 'drm_display_info_set_bus_formats()'
is for connectors.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/gpu/drm/drm_bridge.c | 30 ++++++++++++++++++++++++++++++
 include/drm/drm_bridge.h     |  8 ++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 1638bfe..e2ad098 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -157,6 +157,36 @@ void drm_bridge_detach(struct drm_bridge *bridge)
 }
 
 /**
+ * drm_bridge_set_bus_formats() - set bridge supported image formats
+ * @bridge: the bridge to set image formats in
+ * @formats: array of MEDIA_BUS_FMT\_ supported image formats
+ * @num_formats: number of elements in the @formats array
+ *
+ * Store a list of supported image formats in a bridge.
+ * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-format.h for
+ * a full list of available formats.
+ */
+int drm_bridge_set_bus_formats(struct drm_bridge *bridge, const u32 *formats,
+			       unsigned int num_formats)
+{
+	u32 *fmts;
+
+	if (!formats || !num_formats)
+		return -EINVAL;
+
+	fmts = kmemdup(formats, sizeof(*formats) * num_formats, GFP_KERNEL);
+	if (!fmts)
+		return -ENOMEM;
+
+	kfree(bridge->bus_formats);
+	bridge->bus_formats = fmts;
+	bridge->num_bus_formats = num_formats;
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_bridge_set_bus_formats);
+
+/**
  * DOC: bridge callbacks
  *
  * The &drm_bridge_funcs ops are populated by the bridge driver. The DRM
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 3270fec..6b3648c 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -258,6 +258,9 @@ struct drm_bridge_timings {
  * @encoder: encoder to which this bridge is connected
  * @next: the next bridge in the encoder chain
  * @of_node: device node pointer to the bridge
+ * @bus_formats: wire image formats. Array of @num_bus_formats MEDIA_BUS_FMT\_
+ * elements
+ * @num_bus_formats: size of @bus_formats array
  * @list: to keep track of all added bridges
  * @timings: the timing specification for the bridge, if any (may
  * be NULL)
@@ -271,6 +274,9 @@ struct drm_bridge {
 #ifdef CONFIG_OF
 	struct device_node *of_node;
 #endif
+	const u32 *bus_formats;
+	unsigned int num_bus_formats;
+
 	struct list_head list;
 	const struct drm_bridge_timings *timings;
 
@@ -296,6 +302,8 @@ void drm_bridge_mode_set(struct drm_bridge *bridge,
 			struct drm_display_mode *adjusted_mode);
 void drm_bridge_pre_enable(struct drm_bridge *bridge);
 void drm_bridge_enable(struct drm_bridge *bridge);
+int drm_bridge_set_bus_formats(struct drm_bridge *bridge, const u32 *fmts,
+			       unsigned int num_fmts);
 
 #ifdef CONFIG_DRM_PANEL_BRIDGE
 struct drm_bridge *drm_panel_bridge_add(struct drm_panel *panel,
-- 
2.7.4
