Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35600 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752778AbcJKOyp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:54:45 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: [RFC PATCH 07/11] drm: Add writeback-connector pixel format properties
Date: Tue, 11 Oct 2016 15:54:04 +0100
Message-Id: <1476197648-24918-8-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So that userspace can determine what pixel formats are supported for a
writeback connector's framebuffer, add a pixel format list to writeback
connectors. This is in the form of an immutable blob containing an array
of formats, and an immutable uint holding the array size.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/drm_connector.c |   73 ++++++++++++++++++++++++++++++++++++++-
 include/drm/drm_connector.h     |   12 +++++++
 include/drm/drm_crtc.h          |   12 +++++++
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index fb83870..2f1f61d 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -249,9 +249,14 @@ int drm_connector_init(struct drm_device *dev,
 		drm_object_attach_property(&connector->base, config->prop_crtc_id, 0);
 	}
 
-	if (connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+	if (connector_type == DRM_MODE_CONNECTOR_WRITEBACK) {
 		drm_object_attach_property(&connector->base,
 					   config->prop_fb_id, 0);
+		drm_object_attach_property(&connector->base,
+					   config->pixel_formats_property, 0);
+		drm_object_attach_property(&connector->base,
+					   config->pixel_formats_size_property, 0);
+	}
 
 	connector->debugfs_entry = NULL;
 out_put_type_id:
@@ -851,6 +856,45 @@ int drm_mode_create_suggested_offset_properties(struct drm_device *dev)
 EXPORT_SYMBOL(drm_mode_create_suggested_offset_properties);
 
 /**
+ * drm_mode_create_writeback_connector_properties - create writeback connector properties
+ * @dev: DRM device
+ *
+ * Create the properties specific to writeback connectors. These will be attached
+ * to writeback connectors by drm_connector_init. Drivers can set these
+ * properties using drm_mode_connector_set_writeback_formats().
+ *
+ *  "PIXEL_FORMATS":
+ *	Immutable blob property to store the supported pixel formats table. The
+ *	data is an array of u32 DRM_FORMAT_* fourcc values.
+ *	Userspace can use this blob to find out what pixel formats are supported
+ *	by the connector's writeback engine.
+ *
+ *  "PIXEL_FORMATS_SIZE":
+ *      Immutable unsigned range property storing the number of entries in the
+ *      PIXEL_FORMATS array.
+ */
+int drm_mode_create_writeback_connector_properties(struct drm_device *dev)
+{
+	if (dev->mode_config.pixel_formats_property &&
+	    dev->mode_config.pixel_formats_size_property)
+		return 0;
+
+	dev->mode_config.pixel_formats_property =
+		drm_property_create(dev, DRM_MODE_PROP_BLOB | DRM_MODE_PROP_IMMUTABLE,
+			"PIXEL_FORMATS", 0);
+
+	dev->mode_config.pixel_formats_size_property =
+		drm_property_create_range(dev, DRM_MODE_PROP_IMMUTABLE,
+			"PIXEL_FORMATS_SIZE", 0, UINT_MAX);
+
+	if (dev->mode_config.pixel_formats_property == NULL ||
+	    dev->mode_config.pixel_formats_size_property == NULL)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(drm_mode_create_writeback_connector_properties);
+
+/**
  * drm_mode_connector_set_path_property - set tile property on connector
  * @connector: connector to set property on.
  * @path: path to use for property; must not be NULL.
@@ -957,6 +1001,33 @@ int drm_mode_connector_update_edid_property(struct drm_connector *connector,
 }
 EXPORT_SYMBOL(drm_mode_connector_update_edid_property);
 
+int drm_mode_connector_set_writeback_formats(struct drm_connector *connector,
+					     u32 *formats,
+					     unsigned int n_formats)
+{
+	struct drm_device *dev = connector->dev;
+	size_t size = n_formats * sizeof(*formats);
+	int ret;
+
+	if (connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK)
+		return -EINVAL;
+
+	ret = drm_property_replace_global_blob(dev,
+					       &connector->pixel_formats_blob_ptr,
+					       size,
+					       formats,
+					       &connector->base,
+					       dev->mode_config.pixel_formats_property);
+
+	if (!ret)
+		drm_object_property_set_value(&connector->base,
+					      dev->mode_config.pixel_formats_size_property,
+					      n_formats);
+
+	return 0;
+}
+EXPORT_SYMBOL(drm_mode_connector_set_writeback_formats);
+
 int drm_mode_connector_set_obj_prop(struct drm_mode_object *obj,
 				    struct drm_property *property,
 				    uint64_t value)
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 30a766a..e77ae5c 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -615,6 +615,14 @@ struct drm_connector {
 	 */
 	struct drm_property_blob *tile_blob_ptr;
 
+	/**
+	 * @pixel_formats_blob_ptr
+	 *
+	 * DRM blob property data for the pixel formats list on writeback
+	 * connectors
+	 */
+	struct drm_property_blob *pixel_formats_blob_ptr;
+
 /* should we poll this connector for connects and disconnects */
 /* hot plug detectable */
 #define DRM_CONNECTOR_POLL_HPD (1 << 0)
@@ -757,12 +765,16 @@ int drm_mode_create_tv_properties(struct drm_device *dev,
 int drm_mode_create_scaling_mode_property(struct drm_device *dev);
 int drm_mode_create_aspect_ratio_property(struct drm_device *dev);
 int drm_mode_create_suggested_offset_properties(struct drm_device *dev);
+int drm_mode_create_writeback_connector_properties(struct drm_device *dev);
 
 int drm_mode_connector_set_path_property(struct drm_connector *connector,
 					 const char *path);
 int drm_mode_connector_set_tile_property(struct drm_connector *connector);
 int drm_mode_connector_update_edid_property(struct drm_connector *connector,
 					    const struct edid *edid);
+int drm_mode_connector_set_writeback_formats(struct drm_connector *connector,
+					     u32 *formats,
+					     unsigned int n_formats);
 
 /**
  * drm_for_each_connector - iterate over all connectors
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 61932f5..c4a3164 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -1302,6 +1302,18 @@ struct drm_mode_config {
 	 */
 	struct drm_property *suggested_y_property;
 
+	/**
+	 * @pixel_formats_property: Property for writeback connectors, storing
+	 * an array of the supported pixel formats for the writeback engine
+	 * (read-only).
+	 */
+	struct drm_property *pixel_formats_property;
+	/**
+	 * @pixel_formats_size_property: Property for writeback connectors,
+	 * stating the size of the pixel formats array (read-only).
+	 */
+	struct drm_property *pixel_formats_size_property;
+
 	/* dumb ioctl parameters */
 	uint32_t preferred_depth, prefer_shadow;
 
-- 
1.7.9.5

