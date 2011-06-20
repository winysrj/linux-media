Return-path: <mchehab@pedra>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55143 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751731Ab1FTU0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 16:26:24 -0400
Received: from c-67-161-37-189.hsd1.ca.comcast.net ([67.161.37.189] helo=jbarnes-desktop)
	by box514.bluehost.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.69)
	(envelope-from <jbarnes@virtuousgeek.org>)
	id 1QYl39-0004TT-2F
	for linux-media@vger.kernel.org; Mon, 20 Jun 2011 14:26:23 -0600
From: Jesse Barnes <jbarnes@virtuousgeek.org> (by way of Jesse Barnes
	<jbarnes@virtuousgeek.org>)
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 20 Jun 2011 13:11:39 -0700
Message-Id: <1308600701-7442-3-git-send-email-jbarnes@virtuousgeek.org>
In-Reply-To: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
Subject: [PATCH 2/4] drm: add an fb creation ioctl that takes a pixel format
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

To properly support the various plane formats supported by different
hardware, the kernel must know the pixel format of a framebuffer object.
So add a new ioctl taking a format argument corresponding to a fourcc
name from videodev2.h.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/drm_crtc.c                |   71 ++++++++++++++++++++++++++++-
 drivers/gpu/drm/drm_crtc_helper.c         |    3 +-
 drivers/gpu/drm/drm_drv.c                 |    1 +
 drivers/gpu/drm/i915/intel_display.c      |    9 ++--
 drivers/gpu/drm/i915/intel_drv.h          |    2 +-
 drivers/gpu/drm/i915/intel_fb.c           |    3 +-
 drivers/gpu/drm/nouveau/nouveau_display.c |    4 +-
 drivers/gpu/drm/radeon/radeon_display.c   |    4 +-
 drivers/gpu/drm/radeon/radeon_fb.c        |    5 +-
 drivers/gpu/drm/radeon/radeon_mode.h      |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c       |    2 +-
 drivers/staging/gma500/psb_fb.c           |    2 +-
 include/drm/drm.h                         |    1 +
 include/drm/drm_crtc.h                    |    6 ++-
 include/drm/drm_crtc_helper.h             |    2 +-
 include/drm/drm_mode.h                    |   14 ++++++
 16 files changed, 112 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 9be36a5..f963cf5 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1909,7 +1909,76 @@ out:
 int drm_mode_addfb(struct drm_device *dev,
 		   void *data, struct drm_file *file_priv)
 {
-	struct drm_mode_fb_cmd *r = data;
+	struct drm_mode_fb_cmd *or = data;
+	struct drm_mode_fb_cmd2 r;
+	struct drm_mode_config *config = &dev->mode_config;
+	struct drm_framebuffer *fb;
+	int ret = 0;
+
+	/* Use new struct with format internally */
+	r.fb_id = or->fb_id;
+	r.width = or->width;
+	r.height = or->height;
+	r.pitch = or->pitch;
+	r.bpp = or->bpp;
+	r.depth = or->depth;
+	r.pixel_format = 0;
+	r.handle = or->handle;
+
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
+	if ((config->min_width > r.width) || (r.width > config->max_width)) {
+		DRM_ERROR("mode new framebuffer width not within limits\n");
+		return -EINVAL;
+	}
+	if ((config->min_height > r.height) || (r.height > config->max_height)) {
+		DRM_ERROR("mode new framebuffer height not within limits\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&dev->mode_config.mutex);
+
+	/* TODO check buffer is sufficiently large */
+	/* TODO setup destructor callback */
+
+	fb = dev->mode_config.funcs->fb_create(dev, file_priv, &r);
+	if (IS_ERR(fb)) {
+		DRM_ERROR("could not create framebuffer\n");
+		ret = PTR_ERR(fb);
+		goto out;
+	}
+
+	or->fb_id = fb->base.id;
+	list_add(&fb->filp_head, &file_priv->fbs);
+	DRM_DEBUG_KMS("[FB:%d]\n", fb->base.id);
+
+out:
+	mutex_unlock(&dev->mode_config.mutex);
+	return ret;
+}
+
+/**
+ * drm_mode_addfb2 - add an FB to the graphics configuration
+ * @inode: inode from the ioctl
+ * @filp: file * from the ioctl
+ * @cmd: cmd from ioctl
+ * @arg: arg from ioctl
+ *
+ * LOCKING:
+ * Takes mode config lock.
+ *
+ * Add a new FB to the specified CRTC, given a user request with format.
+ *
+ * Called by the user via ioctl.
+ *
+ * RETURNS:
+ * Zero on success, errno on failure.
+ */
+int drm_mode_addfb2(struct drm_device *dev,
+		    void *data, struct drm_file *file_priv)
+{
+	struct drm_mode_fb_cmd2 *r = data;
 	struct drm_mode_config *config = &dev->mode_config;
 	struct drm_framebuffer *fb;
 	int ret = 0;
diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 9236965..5adab04 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -801,13 +801,14 @@ void drm_helper_connector_dpms(struct drm_connector *connector, int mode)
 EXPORT_SYMBOL(drm_helper_connector_dpms);
 
 int drm_helper_mode_fill_fb_struct(struct drm_framebuffer *fb,
-				   struct drm_mode_fb_cmd *mode_cmd)
+				   struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	fb->width = mode_cmd->width;
 	fb->height = mode_cmd->height;
 	fb->pitch = mode_cmd->pitch;
 	fb->bits_per_pixel = mode_cmd->bpp;
 	fb->depth = mode_cmd->depth;
+	fb->pixel_format = mode_cmd->pixel_format;
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 15da618..f24b9b6 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -152,6 +152,7 @@ static struct drm_ioctl_desc drm_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPROPBLOB, drm_mode_getblob_ioctl, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETFB, drm_mode_getfb, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_ADDFB, drm_mode_addfb, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_ADDFB2, drm_mode_addfb2, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_RMFB, drm_mode_rmfb, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_PAGE_FLIP, drm_mode_page_flip_ioctl, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_DIRTYFB, drm_mode_dirtyfb_ioctl, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0b6fd36..8a6e3ab 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5803,7 +5803,7 @@ static struct drm_display_mode load_detect_mode = {
 
 static struct drm_framebuffer *
 intel_framebuffer_create(struct drm_device *dev,
-			 struct drm_mode_fb_cmd *mode_cmd,
+			 struct drm_mode_fb_cmd2 *mode_cmd,
 			 struct drm_i915_gem_object *obj)
 {
 	struct intel_framebuffer *intel_fb;
@@ -5845,7 +5845,7 @@ intel_framebuffer_create_for_mode(struct drm_device *dev,
 				  int depth, int bpp)
 {
 	struct drm_i915_gem_object *obj;
-	struct drm_mode_fb_cmd mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd;
 
 	obj = i915_gem_alloc_object(dev,
 				    intel_framebuffer_size_for_mode(mode, bpp));
@@ -5857,6 +5857,7 @@ intel_framebuffer_create_for_mode(struct drm_device *dev,
 	mode_cmd.depth = depth;
 	mode_cmd.bpp = bpp;
 	mode_cmd.pitch = intel_framebuffer_pitch_for_width(mode_cmd.width, bpp);
+	mode_cmd.pixel_format = 0;
 
 	return intel_framebuffer_create(dev, &mode_cmd, obj);
 }
@@ -6978,7 +6979,7 @@ static const struct drm_framebuffer_funcs intel_fb_funcs = {
 
 int intel_framebuffer_init(struct drm_device *dev,
 			   struct intel_framebuffer *intel_fb,
-			   struct drm_mode_fb_cmd *mode_cmd,
+			   struct drm_mode_fb_cmd2 *mode_cmd,
 			   struct drm_i915_gem_object *obj)
 {
 	int ret;
@@ -7013,7 +7014,7 @@ int intel_framebuffer_init(struct drm_device *dev,
 static struct drm_framebuffer *
 intel_user_framebuffer_create(struct drm_device *dev,
 			      struct drm_file *filp,
-			      struct drm_mode_fb_cmd *mode_cmd)
+			      struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	struct drm_i915_gem_object *obj;
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 0dc9018..3cfc391 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -326,7 +326,7 @@ extern int intel_pin_and_fence_fb_obj(struct drm_device *dev,
 
 extern int intel_framebuffer_init(struct drm_device *dev,
 				  struct intel_framebuffer *ifb,
-				  struct drm_mode_fb_cmd *mode_cmd,
+				  struct drm_mode_fb_cmd2 *mode_cmd,
 				  struct drm_i915_gem_object *obj);
 extern int intel_fbdev_init(struct drm_device *dev);
 extern void intel_fbdev_fini(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index ec49bae..11baa99 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -65,7 +65,7 @@ static int intelfb_create(struct intel_fbdev *ifbdev,
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct fb_info *info;
 	struct drm_framebuffer *fb;
-	struct drm_mode_fb_cmd mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd;
 	struct drm_i915_gem_object *obj;
 	struct device *device = &dev->pdev->dev;
 	int size, ret;
@@ -80,6 +80,7 @@ static int intelfb_create(struct intel_fbdev *ifbdev,
 	mode_cmd.bpp = sizes->surface_bpp;
 	mode_cmd.pitch = ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 64);
 	mode_cmd.depth = sizes->surface_depth;
+	mode_cmd.pixel_format = 0;
 
 	size = mode_cmd.pitch * mode_cmd.height;
 	size = ALIGN(size, PAGE_SIZE);
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index eb514ea..b03df00 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -64,7 +64,7 @@ static const struct drm_framebuffer_funcs nouveau_framebuffer_funcs = {
 int
 nouveau_framebuffer_init(struct drm_device *dev,
 			 struct nouveau_framebuffer *nv_fb,
-			 struct drm_mode_fb_cmd *mode_cmd,
+			 struct drm_mode_fb_cmd2 *mode_cmd,
 			 struct nouveau_bo *nvbo)
 {
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
@@ -121,7 +121,7 @@ nouveau_framebuffer_init(struct drm_device *dev,
 static struct drm_framebuffer *
 nouveau_user_framebuffer_create(struct drm_device *dev,
 				struct drm_file *file_priv,
-				struct drm_mode_fb_cmd *mode_cmd)
+				struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	struct nouveau_framebuffer *nouveau_fb;
 	struct drm_gem_object *gem;
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index ae247ee..74ffab6 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1122,7 +1122,7 @@ static const struct drm_framebuffer_funcs radeon_fb_funcs = {
 void
 radeon_framebuffer_init(struct drm_device *dev,
 			struct radeon_framebuffer *rfb,
-			struct drm_mode_fb_cmd *mode_cmd,
+			struct drm_mode_fb_cmd2 *mode_cmd,
 			struct drm_gem_object *obj)
 {
 	rfb->obj = obj;
@@ -1133,7 +1133,7 @@ radeon_framebuffer_init(struct drm_device *dev,
 static struct drm_framebuffer *
 radeon_user_framebuffer_create(struct drm_device *dev,
 			       struct drm_file *file_priv,
-			       struct drm_mode_fb_cmd *mode_cmd)
+			       struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	struct drm_gem_object *obj;
 	struct radeon_framebuffer *radeon_fb;
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 0b7b486..06215ac 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -103,7 +103,7 @@ static void radeonfb_destroy_pinned_object(struct drm_gem_object *gobj)
 }
 
 static int radeonfb_create_pinned_object(struct radeon_fbdev *rfbdev,
-					 struct drm_mode_fb_cmd *mode_cmd,
+					 struct drm_mode_fb_cmd2 *mode_cmd,
 					 struct drm_gem_object **gobj_p)
 {
 	struct radeon_device *rdev = rfbdev->rdev;
@@ -187,7 +187,7 @@ static int radeonfb_create(struct radeon_fbdev *rfbdev,
 	struct radeon_device *rdev = rfbdev->rdev;
 	struct fb_info *info;
 	struct drm_framebuffer *fb = NULL;
-	struct drm_mode_fb_cmd mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd;
 	struct drm_gem_object *gobj = NULL;
 	struct radeon_bo *rbo = NULL;
 	struct device *device = &rdev->pdev->dev;
@@ -203,6 +203,7 @@ static int radeonfb_create(struct radeon_fbdev *rfbdev,
 
 	mode_cmd.bpp = sizes->surface_bpp;
 	mode_cmd.depth = sizes->surface_depth;
+	mode_cmd.pixel_format = 0;
 
 	ret = radeonfb_create_pinned_object(rfbdev, &mode_cmd, &gobj);
 	rbo = gem_to_radeon_bo(gobj);
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 977a341..121eb56 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -637,7 +637,7 @@ extern void radeon_crtc_fb_gamma_get(struct drm_crtc *crtc, u16 *red, u16 *green
 				     u16 *blue, int regno);
 void radeon_framebuffer_init(struct drm_device *dev,
 			     struct radeon_framebuffer *rfb,
-			     struct drm_mode_fb_cmd *mode_cmd,
+			     struct drm_mode_fb_cmd2 *mode_cmd,
 			     struct drm_gem_object *obj);
 
 int radeonfb_remove(struct drm_device *dev, struct drm_framebuffer *fb);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index dfe32e6..f6566a8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -836,7 +836,7 @@ out_err1:
 
 static struct drm_framebuffer *vmw_kms_fb_create(struct drm_device *dev,
 						 struct drm_file *file_priv,
-						 struct drm_mode_fb_cmd *mode_cmd)
+						 struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	struct vmw_private *dev_priv = vmw_priv(dev);
 	struct ttm_object_file *tfile = vmw_fpriv(file_priv)->tfile;
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 99c03a2..3cfa632 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -481,7 +481,7 @@ out_err1:
  */
 static struct drm_framebuffer *psb_user_framebuffer_create
 			(struct drm_device *dev, struct drm_file *filp,
-			 struct drm_mode_fb_cmd *cmd)
+			 struct drm_mode_fb_cmd2 *cmd)
 {
         struct gtt_range *r;
         struct drm_gem_object *obj;
diff --git a/include/drm/drm.h b/include/drm/drm.h
index 2897967..49d94ed 100644
--- a/include/drm/drm.h
+++ b/include/drm/drm.h
@@ -717,6 +717,7 @@ struct drm_get_cap {
 #define DRM_IOCTL_MODE_GETPLANERESOURCES DRM_IOWR(0xB5, struct drm_mode_get_plane_res)
 #define DRM_IOCTL_MODE_GETPLANE	DRM_IOWR(0xB6, struct drm_mode_get_plane)
 #define DRM_IOCTL_MODE_SETPLANE	DRM_IOWR(0xB7, struct drm_mode_set_plane)
+#define DRM_IOCTL_MODE_ADDFB2		DRM_IOWR(0xB8, struct drm_mode_fb_cmd2)
 
 /**
  * Device specific ioctls should only be in their respective headers
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index caa72ae..6ac4d74 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/idr.h>
+#include <linux/videodev2.h> /* for plane formats */
 
 #include <linux/fb.h>
 
@@ -244,6 +245,7 @@ struct drm_framebuffer {
 	unsigned int depth;
 	int bits_per_pixel;
 	int flags;
+	uint32_t pixel_format; /* fourcc format */
 	struct list_head filp_head;
 	/* if you are using the helper */
 	void *helper_private;
@@ -604,7 +606,7 @@ struct drm_mode_set {
  * struct drm_mode_config_funcs - configure CRTCs for a given screen layout
  */
 struct drm_mode_config_funcs {
-	struct drm_framebuffer *(*fb_create)(struct drm_device *dev, struct drm_file *file_priv, struct drm_mode_fb_cmd *mode_cmd);
+	struct drm_framebuffer *(*fb_create)(struct drm_device *dev, struct drm_file *file_priv, struct drm_mode_fb_cmd2 *mode_cmd);
 	void (*output_poll_changed)(struct drm_device *dev);
 };
 
@@ -822,6 +824,8 @@ extern int drm_mode_cursor_ioctl(struct drm_device *dev,
 				void *data, struct drm_file *file_priv);
 extern int drm_mode_addfb(struct drm_device *dev,
 			  void *data, struct drm_file *file_priv);
+extern int drm_mode_addfb2(struct drm_device *dev,
+			   void *data, struct drm_file *file_priv);
 extern int drm_mode_rmfb(struct drm_device *dev,
 			 void *data, struct drm_file *file_priv);
 extern int drm_mode_getfb(struct drm_device *dev,
diff --git a/include/drm/drm_crtc_helper.h b/include/drm/drm_crtc_helper.h
index 73b0712..e88b7d7 100644
--- a/include/drm/drm_crtc_helper.h
+++ b/include/drm/drm_crtc_helper.h
@@ -117,7 +117,7 @@ extern bool drm_helper_encoder_in_use(struct drm_encoder *encoder);
 extern void drm_helper_connector_dpms(struct drm_connector *connector, int mode);
 
 extern int drm_helper_mode_fill_fb_struct(struct drm_framebuffer *fb,
-					  struct drm_mode_fb_cmd *mode_cmd);
+					  struct drm_mode_fb_cmd2 *mode_cmd);
 
 static inline void drm_crtc_helper_add(struct drm_crtc *crtc,
 				       const struct drm_crtc_helper_funcs *funcs)
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index fa6d348..82cd587 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -27,6 +27,8 @@
 #ifndef _DRM_MODE_H
 #define _DRM_MODE_H
 
+#include <linux/videodev2.h>
+
 #define DRM_DISPLAY_INFO_LEN	32
 #define DRM_CONNECTOR_NAME_LEN	32
 #define DRM_DISPLAY_MODE_LEN	32
@@ -264,6 +266,18 @@ struct drm_mode_fb_cmd {
 	__u32 handle;
 };
 
+/* For addfb2 ioctl, contains format info */
+struct drm_mode_fb_cmd2 {
+	__u32 fb_id;
+	__u32 width, height;
+	__u32 pitch;
+	__u32 bpp;
+	__u32 depth;
+	__u32 pixel_format; /* fourcc code from videodev2.h */
+	/* driver specific handle */
+	__u32 handle;
+};
+
 #define DRM_MODE_FB_DIRTY_ANNOTATE_COPY 0x01
 #define DRM_MODE_FB_DIRTY_ANNOTATE_FILL 0x02
 #define DRM_MODE_FB_DIRTY_FLAGS         0x03
-- 
1.7.4.1


