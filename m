Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbcCXX2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 33/51] v4l: vsp1: Merge RPF and WPF pad ops structures
Date: Fri, 25 Mar 2016 01:27:29 +0200
Message-Id: <1458862067-19525-34-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two structures are identical, merge them and move the result to
vsp1_rwpf.c. All rwpf pad operations can now be declared static.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 12 +------
 drivers/media/platform/vsp1/vsp1_rwpf.c | 60 +++++++++++++++++++--------------
 drivers/media/platform/vsp1/vsp1_rwpf.h | 19 +----------
 drivers/media/platform/vsp1/vsp1_wpf.c  | 12 +------
 4 files changed, 38 insertions(+), 65 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index acc88b4a449b..886312de9089 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -36,18 +36,8 @@ static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_pad_ops rpf_pad_ops = {
-	.init_cfg = vsp1_entity_init_cfg,
-	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
-	.enum_frame_size = vsp1_rwpf_enum_frame_size,
-	.get_fmt = vsp1_rwpf_get_format,
-	.set_fmt = vsp1_rwpf_set_format,
-	.get_selection = vsp1_rwpf_get_selection,
-	.set_selection = vsp1_rwpf_set_selection,
-};
-
 static struct v4l2_subdev_ops rpf_ops = {
-	.pad    = &rpf_pad_ops,
+	.pad    = &vsp1_rwpf_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 0c5ad023adfb..4d302f5cccb2 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -20,13 +20,20 @@
 #define RWPF_MIN_WIDTH				1
 #define RWPF_MIN_HEIGHT				1
 
+struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
+				     struct v4l2_subdev_pad_config *config)
+{
+	return v4l2_subdev_get_try_crop(&rwpf->entity.subdev, config,
+					RWPF_PAD_SINK);
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Pad Operations
  */
 
-int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_pad_config *cfg,
-			     struct v4l2_subdev_mbus_code_enum *code)
+static int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
 		MEDIA_BUS_FMT_ARGB8888_1X32,
@@ -41,9 +48,9 @@ int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_pad_config *cfg,
-			      struct v4l2_subdev_frame_size_enum *fse)
+static int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
+				     struct v4l2_subdev_pad_config *cfg,
+				     struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -76,16 +83,9 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
-				     struct v4l2_subdev_pad_config *config)
-{
-	return v4l2_subdev_get_try_crop(&rwpf->entity.subdev, config,
-					RWPF_PAD_SINK);
-}
-
-int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
-			 struct v4l2_subdev_pad_config *cfg,
-			 struct v4l2_subdev_format *fmt)
+static int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -100,9 +100,9 @@ int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
-			 struct v4l2_subdev_pad_config *cfg,
-			 struct v4l2_subdev_format *fmt)
+static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -154,9 +154,9 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_pad_config *cfg,
-			    struct v4l2_subdev_selection *sel)
+static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -191,9 +191,9 @@ int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_pad_config *cfg,
-			    struct v4l2_subdev_selection *sel)
+static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_subdev_pad_config *config;
@@ -250,6 +250,16 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
+	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
+	.enum_frame_size = vsp1_rwpf_enum_frame_size,
+	.get_fmt = vsp1_rwpf_get_format,
+	.set_fmt = vsp1_rwpf_set_format,
+	.get_selection = vsp1_rwpf_get_selection,
+	.set_selection = vsp1_rwpf_set_selection,
+};
+
 /* -----------------------------------------------------------------------------
  * Controls
  */
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 4ebfab61e0ef..9502710977e8 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -68,24 +68,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
 int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf);
 
-int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_pad_config *cfg,
-			     struct v4l2_subdev_mbus_code_enum *code);
-int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_pad_config *cfg,
-			      struct v4l2_subdev_frame_size_enum *fse);
-int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
-			 struct v4l2_subdev_pad_config *cfg,
-			 struct v4l2_subdev_format *fmt);
-int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
-			 struct v4l2_subdev_pad_config *cfg,
-			 struct v4l2_subdev_format *fmt);
-int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_pad_config *cfg,
-			    struct v4l2_subdev_selection *sel);
-int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_pad_config *cfg,
-			    struct v4l2_subdev_selection *sel);
+extern const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops;
 
 struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
 				     struct v4l2_subdev_pad_config *config);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 65481930b218..783a923fa76c 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -63,19 +63,9 @@ static struct v4l2_subdev_video_ops wpf_video_ops = {
 	.s_stream = wpf_s_stream,
 };
 
-static struct v4l2_subdev_pad_ops wpf_pad_ops = {
-	.init_cfg = vsp1_entity_init_cfg,
-	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
-	.enum_frame_size = vsp1_rwpf_enum_frame_size,
-	.get_fmt = vsp1_rwpf_get_format,
-	.set_fmt = vsp1_rwpf_set_format,
-	.get_selection = vsp1_rwpf_get_selection,
-	.set_selection = vsp1_rwpf_set_selection,
-};
-
 static struct v4l2_subdev_ops wpf_ops = {
 	.video	= &wpf_video_ops,
-	.pad    = &wpf_pad_ops,
+	.pad    = &vsp1_rwpf_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.7.3

