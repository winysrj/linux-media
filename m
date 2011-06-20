Return-path: <mchehab@pedra>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:40054 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750789Ab1FTU01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 16:26:27 -0400
Received: from c-67-161-37-189.hsd1.ca.comcast.net ([67.161.37.189] helo=jbarnes-desktop)
	by box514.bluehost.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.69)
	(envelope-from <jbarnes@virtuousgeek.org>)
	id 1QYl3C-0004Ws-7H
	for linux-media@vger.kernel.org; Mon, 20 Jun 2011 14:26:26 -0600
From: Jesse Barnes <jbarnes@virtuousgeek.org> (by way of Jesse Barnes
	<jbarnes@virtuousgeek.org>)
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 20 Jun 2011 13:11:38 -0700
Message-Id: <1308600701-7442-2-git-send-email-jbarnes@virtuousgeek.org>
In-Reply-To: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
Subject: [PATCH 1/4] drm: add plane support
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Planes are a bit like half-CRTCs.  They have a location and fb, but
don't drive outputs directly.  Add support for handling them to the core
KMS code.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/drm_crtc.c |  235 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/drm_drv.c  |    3 +
 include/drm/drm.h          |    3 +
 include/drm/drm_crtc.h     |   73 ++++++++++++++-
 include/drm/drm_mode.h     |   35 +++++++
 5 files changed, 346 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 872747c..9be36a5 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -533,6 +533,47 @@ void drm_encoder_cleanup(struct drm_encoder *encoder)
 }
 EXPORT_SYMBOL(drm_encoder_cleanup);
 
+void drm_plane_init(struct drm_device *dev, struct drm_plane *plane,
+		    unsigned long possible_crtcs,
+		    const struct drm_plane_funcs *funcs,
+		    uint32_t *formats, uint32_t format_count)
+{
+	mutex_lock(&dev->mode_config.mutex);
+
+	plane->dev = dev;
+	drm_mode_object_get(dev, &plane->base, DRM_MODE_OBJECT_PLANE);
+	plane->funcs = funcs;
+	plane->format_types = kmalloc(sizeof(uint32_t) * format_count,
+				      GFP_KERNEL);
+	if (!plane->format_types) {
+		DRM_DEBUG_KMS("out of memory when allocating plane\n");
+		drm_mode_object_put(dev, &plane->base);
+		return;
+	}
+
+	memcpy(plane->format_types, formats, format_count);
+	plane->format_count = format_count;
+	plane->possible_crtcs = possible_crtcs;
+
+	list_add_tail(&plane->head, &dev->mode_config.plane_list);
+	dev->mode_config.num_plane++;
+
+	mutex_unlock(&dev->mode_config.mutex);
+}
+EXPORT_SYMBOL(drm_plane_init);
+
+void drm_plane_cleanup(struct drm_plane *plane)
+{
+	struct drm_device *dev = plane->dev;
+
+	mutex_lock(&dev->mode_config.mutex);
+	drm_mode_object_put(dev, &plane->base);
+	list_del(&plane->head);
+	dev->mode_config.num_plane--;
+	mutex_unlock(&dev->mode_config.mutex);
+}
+EXPORT_SYMBOL(drm_plane_cleanup);
+
 /**
  * drm_mode_create - create a new display mode
  * @dev: DRM device
@@ -864,6 +905,7 @@ void drm_mode_config_init(struct drm_device *dev)
 	INIT_LIST_HEAD(&dev->mode_config.encoder_list);
 	INIT_LIST_HEAD(&dev->mode_config.property_list);
 	INIT_LIST_HEAD(&dev->mode_config.property_blob_list);
+	INIT_LIST_HEAD(&dev->mode_config.plane_list);
 	idr_init(&dev->mode_config.crtc_idr);
 
 	mutex_lock(&dev->mode_config.mutex);
@@ -1467,6 +1509,193 @@ out:
 }
 
 /**
+ * drm_mode_getplane_res - get plane info
+ * @dev: DRM device
+ * @data: ioctl data
+ * @file_priv: DRM file info
+ *
+ * Return an plane count and set of IDs.
+ */
+int drm_mode_getplane_res(struct drm_device *dev, void *data,
+			    struct drm_file *file_priv)
+{
+	struct drm_mode_get_plane_res *plane_resp = data;
+	struct drm_mode_config *config;
+	struct drm_plane *plane;
+	uint32_t __user *plane_ptr;
+	int copied = 0, ret = 0;
+
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
+	mutex_lock(&dev->mode_config.mutex);
+	config = &dev->mode_config;
+
+	/*
+	 * This ioctl is called twice, once to determine how much space is
+	 * needed, and the 2nd time to fill it.
+	 */
+	if (config->num_plane &&
+	    (plane_resp->count_planes >= config->num_plane)) {
+		plane_ptr = (uint32_t *)(unsigned long)plane_resp->plane_id_ptr;
+
+		list_for_each_entry(plane, &config->plane_list, head) {
+			if (put_user(plane->base.id, plane_ptr + copied)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			copied++;
+		}
+	}
+	plane_resp->count_planes = config->num_plane;
+
+out:
+	mutex_unlock(&dev->mode_config.mutex);
+	return ret;
+}
+
+/**
+ * drm_mode_getplane - get plane info
+ * @dev: DRM device
+ * @data: ioctl data
+ * @file_priv: DRM file info
+ *
+ * Return plane info, including formats supported, gamma size, any
+ * current fb, etc.
+ */
+int drm_mode_getplane(struct drm_device *dev, void *data,
+			struct drm_file *file_priv)
+{
+	struct drm_mode_get_plane *plane_resp = data;
+	struct drm_mode_object *obj;
+	struct drm_plane *plane;
+	uint32_t __user *format_ptr;
+	int ret = 0;
+
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
+	mutex_lock(&dev->mode_config.mutex);
+	obj = drm_mode_object_find(dev, plane_resp->plane_id,
+				   DRM_MODE_OBJECT_PLANE);
+	if (!obj) {
+		ret = -EINVAL;
+		goto out;
+	}
+	plane = obj_to_plane(obj);
+
+	if (plane->crtc)
+		plane_resp->crtc_id = plane->crtc->base.id;
+	else
+		plane_resp->crtc_id = 0;
+
+	if (plane->fb)
+		plane_resp->fb_id = plane->fb->base.id;
+	else
+		plane_resp->fb_id = 0;
+
+	plane_resp->plane_id = plane->base.id;
+	plane_resp->possible_crtcs = plane->possible_crtcs;
+	plane_resp->gamma_size = plane->gamma_size;
+
+	/*
+	 * This ioctl is called twice, once to determine how much space is
+	 * needed, and the 2nd time to fill it.
+	 */
+	if (plane->format_count &&
+	    (plane_resp->count_format_types >= plane->format_count)) {
+		format_ptr = (uint32_t *)(unsigned long)plane_resp->format_type_ptr;
+		if (copy_to_user(format_ptr,
+				 plane->format_types,
+				 sizeof(uint32_t) * plane->format_count)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+	plane_resp->count_format_types = plane->format_count;
+
+out:
+	mutex_unlock(&dev->mode_config.mutex);
+	return ret;
+}
+
+/**
+ * drm_mode_setplane - set up or tear down an plane
+ * @dev: DRM device
+ * @data: ioctl data*
+ * @file_prive: DRM file info
+ *
+ * Set plane info, including placement, fb, scaling, and other factors.
+ * Or pass a NULL fb to disable.
+ */
+int drm_mode_setplane(struct drm_device *dev, void *data,
+			struct drm_file *file_priv)
+{
+	struct drm_mode_set_plane *plane_req = data;
+	struct drm_mode_object *obj;
+	struct drm_plane *plane;
+	struct drm_crtc *crtc;
+	struct drm_framebuffer *fb;
+	int ret = 0;
+
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
+	mutex_lock(&dev->mode_config.mutex);
+
+	/*
+	 * First, find the plane, crtc, and fb objects.  If not available,
+	 * we don't bother to call the driver.
+	 */
+	obj = drm_mode_object_find(dev, plane_req->plane_id,
+				   DRM_MODE_OBJECT_PLANE);
+	if (!obj) {
+		DRM_DEBUG_KMS("Unknown plane ID %d\n",
+			      plane_req->plane_id);
+		ret = -EINVAL;
+		goto out;
+	}
+	plane = obj_to_plane(obj);
+
+	/* No fb means shut it down */
+	if (!plane_req->fb_id) {
+		plane->funcs->disable_plane(plane);
+		goto out;
+	}
+
+	obj = drm_mode_object_find(dev, plane_req->crtc_id,
+				   DRM_MODE_OBJECT_CRTC);
+	if (!obj) {
+		DRM_DEBUG_KMS("Unknown crtc ID %d\n",
+			      plane_req->crtc_id);
+		ret = -EINVAL;
+		goto out;
+	}
+	crtc = obj_to_crtc(obj);
+
+	obj = drm_mode_object_find(dev, plane_req->fb_id,
+				   DRM_MODE_OBJECT_FB);
+	if (!obj) {
+		DRM_DEBUG_KMS("Unknown framebuffer ID %d\n",
+			      plane_req->fb_id);
+		ret = -EINVAL;
+		goto out;
+	}
+	fb = obj_to_fb(obj);
+
+	ret = plane->funcs->update_plane(plane, crtc, fb,
+					 plane_req->crtc_x, plane_req->crtc_y,
+					 plane_req->crtc_w, plane_req->crtc_h,
+					 plane_req->src_x, plane_req->src_y,
+					 plane_req->src_h, plane_req->src_w);
+
+out:
+	mutex_unlock(&dev->mode_config.mutex);
+
+	return ret;
+}
+
+/**
  * drm_mode_setcrtc - set CRTC configuration
  * @inode: inode from the ioctl
  * @filp: file * from the ioctl
@@ -1689,11 +1918,13 @@ int drm_mode_addfb(struct drm_device *dev,
 		return -EINVAL;
 
 	if ((config->min_width > r->width) || (r->width > config->max_width)) {
-		DRM_ERROR("mode new framebuffer width not within limits\n");
+		DRM_ERROR("bad framebuffer width %d, should be >= %d && <= %d\n",
+			  r->width, config->min_width, config->max_width);
 		return -EINVAL;
 	}
 	if ((config->min_height > r->height) || (r->height > config->max_height)) {
-		DRM_ERROR("mode new framebuffer height not within limits\n");
+		DRM_ERROR("bad framebuffer height %d, should be >= %d && <= %d\n",
+			  r->height, config->min_height, config->max_height);
 		return -EINVAL;
 	}
 
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 93a112d..15da618 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -135,8 +135,11 @@ static struct drm_ioctl_desc drm_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_IOCTL_GEM_OPEN, drm_gem_open_ioctl, DRM_AUTH|DRM_UNLOCKED),
 
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETRESOURCES, drm_mode_getresources, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPLANERESOURCES, drm_mode_getplane_res, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETCRTC, drm_mode_getcrtc, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETCRTC, drm_mode_setcrtc, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPLANE, drm_mode_getplane, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETPLANE, drm_mode_setplane, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_CURSOR, drm_mode_cursor_ioctl, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETGAMMA, drm_mode_gamma_get_ioctl, DRM_MASTER|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETGAMMA, drm_mode_gamma_set_ioctl, DRM_MASTER|DRM_UNLOCKED),
diff --git a/include/drm/drm.h b/include/drm/drm.h
index 4be33b4..2897967 100644
--- a/include/drm/drm.h
+++ b/include/drm/drm.h
@@ -714,6 +714,9 @@ struct drm_get_cap {
 #define DRM_IOCTL_MODE_CREATE_DUMB DRM_IOWR(0xB2, struct drm_mode_create_dumb)
 #define DRM_IOCTL_MODE_MAP_DUMB    DRM_IOWR(0xB3, struct drm_mode_map_dumb)
 #define DRM_IOCTL_MODE_DESTROY_DUMB    DRM_IOWR(0xB4, struct drm_mode_destroy_dumb)
+#define DRM_IOCTL_MODE_GETPLANERESOURCES DRM_IOWR(0xB5, struct drm_mode_get_plane_res)
+#define DRM_IOCTL_MODE_GETPLANE	DRM_IOWR(0xB6, struct drm_mode_get_plane)
+#define DRM_IOCTL_MODE_SETPLANE	DRM_IOWR(0xB7, struct drm_mode_set_plane)
 
 /**
  * Device specific ioctls should only be in their respective headers
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 9573e0c..caa72ae 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -44,6 +44,7 @@ struct drm_framebuffer;
 #define DRM_MODE_OBJECT_PROPERTY 0xb0b0b0b0
 #define DRM_MODE_OBJECT_FB 0xfbfbfbfb
 #define DRM_MODE_OBJECT_BLOB 0xbbbbbbbb
+#define DRM_MODE_OBJECT_PLANE 0xeeeeeeee
 
 struct drm_mode_object {
 	uint32_t id;
@@ -276,6 +277,7 @@ struct drm_crtc;
 struct drm_connector;
 struct drm_encoder;
 struct drm_pending_vblank_event;
+struct drm_plane;
 
 /**
  * drm_crtc_funcs - control CRTCs for a given device
@@ -523,6 +525,60 @@ struct drm_connector {
 };
 
 /**
+ * drm_plane_funcs - driver plane control functions
+ * @update_plane: update the plane configuration
+ */
+struct drm_plane_funcs {
+	int (*update_plane)(struct drm_plane *plane,
+			    struct drm_crtc *crtc, struct drm_framebuffer *fb,
+			    int crtc_x, int crtc_y,
+			    unsigned int crtc_w, unsigned int crtc_h,
+			    uint32_t src_x, uint32_t src_y,
+			    uint32_t src_w, uint32_t src_h);
+	void (*disable_plane)(struct drm_plane *plane);
+};
+
+/**
+ * drm_plane - central DRM plane control structure
+ * @dev: DRM device this plane belongs to
+ * @kdev: kernel device
+ * @attr: kdev attributes
+ * @head: for list management
+ * @base: base mode object
+ * @crtc_x: x position of plane (relative to pipe base)
+ * @crtc_y: y position of plane
+ * @x: x offset into fb
+ * @y: y offset into fb
+ * @crtc: CRTC this plane is feeding
+ */
+struct drm_plane {
+	struct drm_device *dev;
+	struct device kdev;
+	struct device_attribute *attr;
+	struct list_head head;
+
+	struct drm_mode_object base;
+
+	int crtc_x, crtc_y;
+	int x, y;
+	uint32_t possible_crtcs;
+	uint32_t *format_types;
+	uint32_t format_count;
+
+	struct drm_crtc *crtc;
+	struct drm_framebuffer *fb;
+
+	/* CRTC gamma size for reporting to userspace */
+	uint32_t gamma_size;
+	uint16_t *gamma_store;
+
+	bool enabled;
+
+	const struct drm_plane_funcs *funcs;
+	void *helper_private;
+};
+
+/**
  * struct drm_mode_set
  *
  * Represents a single crtc the connectors that it drives with what mode
@@ -576,6 +632,8 @@ struct drm_mode_config {
 	struct list_head connector_list;
 	int num_encoder;
 	struct list_head encoder_list;
+	int num_plane;
+	struct list_head plane_list;
 
 	int num_crtc;
 	struct list_head crtc_list;
@@ -628,6 +686,7 @@ struct drm_mode_config {
 #define obj_to_fb(x) container_of(x, struct drm_framebuffer, base)
 #define obj_to_property(x) container_of(x, struct drm_property, base)
 #define obj_to_blob(x) container_of(x, struct drm_property_blob, base)
+#define obj_to_plane(x) container_of(x, struct drm_plane, base)
 
 
 extern void drm_crtc_init(struct drm_device *dev,
@@ -647,6 +706,13 @@ extern void drm_encoder_init(struct drm_device *dev,
 			     const struct drm_encoder_funcs *funcs,
 			     int encoder_type);
 
+extern void drm_plane_init(struct drm_device *dev,
+			   struct drm_plane *plane,
+			   unsigned long possible_crtcs,
+			   const struct drm_plane_funcs *funcs,
+			   uint32_t *formats, uint32_t format_count);
+extern void drm_plane_cleanup(struct drm_plane *plane);
+
 extern void drm_encoder_cleanup(struct drm_encoder *encoder);
 
 extern char *drm_get_connector_name(struct drm_connector *connector);
@@ -740,13 +806,18 @@ extern struct drm_mode_object *drm_mode_object_find(struct drm_device *dev,
 /* IOCTLs */
 extern int drm_mode_getresources(struct drm_device *dev,
 				 void *data, struct drm_file *file_priv);
-
+extern int drm_mode_getplane_res(struct drm_device *dev, void *data,
+				   struct drm_file *file_priv);
 extern int drm_mode_getcrtc(struct drm_device *dev,
 			    void *data, struct drm_file *file_priv);
 extern int drm_mode_getconnector(struct drm_device *dev,
 			      void *data, struct drm_file *file_priv);
 extern int drm_mode_setcrtc(struct drm_device *dev,
 			    void *data, struct drm_file *file_priv);
+extern int drm_mode_getplane(struct drm_device *dev,
+			       void *data, struct drm_file *file_priv);
+extern int drm_mode_setplane(struct drm_device *dev,
+			       void *data, struct drm_file *file_priv);
 extern int drm_mode_cursor_ioctl(struct drm_device *dev,
 				void *data, struct drm_file *file_priv);
 extern int drm_mode_addfb(struct drm_device *dev,
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index c4961ea..fa6d348 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -120,6 +120,41 @@ struct drm_mode_crtc {
 	struct drm_mode_modeinfo mode;
 };
 
+/* Planes blend with or override other bits on the CRTC */
+struct drm_mode_set_plane {
+	__u32 plane_id;
+	__u32 crtc_id;
+	__u32 fb_id; /* fb object contains surface format type */
+
+	/* Signed dest location allows it to be partially off screen */
+	__s32 crtc_x, crtc_y;
+	__u32 crtc_w, crtc_h;
+
+	/* Source values are 16.16 fixed point */
+	__u32 src_x, src_y;
+	__u32 src_h, src_w;
+
+	__u32 zpos;
+};
+
+struct drm_mode_get_plane {
+	__u64 format_type_ptr;
+	__u32 plane_id;
+
+	__u32 crtc_id;
+	__u32 fb_id;
+
+	__u32 possible_crtcs;
+	__u32 gamma_size;
+
+	__u32 count_format_types;
+};
+
+struct drm_mode_get_plane_res {
+	__u64 plane_id_ptr;
+	__u32 count_planes;
+};
+
 #define DRM_MODE_ENCODER_NONE	0
 #define DRM_MODE_ENCODER_DAC	1
 #define DRM_MODE_ENCODER_TMDS	2
-- 
1.7.4.1


