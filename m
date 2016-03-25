Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbcCYKpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:08 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 44/54] v4l: vsp1: Factorize frame size enumeration code
Date: Fri, 25 Mar 2016 12:44:18 +0200
Message-Id: <1458902668-1141-45-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the entities can't perform scaling and implement the same frame
size enumeration function. Factorize the code into a single
implementation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 52 +++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  5 +++
 drivers/media/platform/vsp1/vsp1_hsit.c   | 32 ++-----------------
 drivers/media/platform/vsp1/vsp1_lif.c    | 29 ++---------------
 drivers/media/platform/vsp1/vsp1_lut.c    | 32 ++-----------------
 drivers/media/platform/vsp1/vsp1_rwpf.c   | 30 ++----------------
 6 files changed, 69 insertions(+), 111 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index b347442bc662..01a2e9958494 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -187,6 +187,58 @@ int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+/*
+ * vsp1_subdev_enum_frame_size - Subdev pad enum_frame_size handler
+ * @subdev: V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @fse: Frame size enumeration
+ * @min_width: Minimum image width
+ * @min_height: Minimum image height
+ * @max_width: Maximum image width
+ * @max_height: Maximum image height
+ *
+ * This function implements the subdev enum_frame_size pad operation for
+ * entities that do not support scaling or cropping. It reports the given
+ * minimum and maximum frame width and height on the sink pad, and a fixed
+ * source pad size identical to the sink pad.
+ */
+int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_frame_size_enum *fse,
+				unsigned int min_width, unsigned int min_height,
+				unsigned int max_width, unsigned int max_height)
+{
+	struct vsp1_entity *entity = to_vsp1_entity(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+
+	config = vsp1_entity_get_pad_config(entity, cfg, fse->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(entity, config, fse->pad);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == 0) {
+		fse->min_width = min_width;
+		fse->max_width = max_width;
+		fse->min_height = min_height;
+		fse->max_height = max_height;
+	} else {
+		/* The size on the source pad are fixed and always identical to
+		 * the size on the sink pad.
+		 */
+		fse->min_width = format->width;
+		fse->max_width = format->width;
+		fse->min_height = format->height;
+		fse->max_height = format->height;
+	}
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * Media Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index fbde42256522..130a919052d4 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -134,5 +134,10 @@ int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code,
 			       const unsigned int *codes, unsigned int ncodes);
+int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_frame_size_enum *fse,
+				unsigned int min_w, unsigned int min_h,
+				unsigned int max_w, unsigned int max_h);
 
 #endif /* __VSP1_ENTITY_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index af810eb1fdb0..da0b2d9ac39d 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -59,35 +59,9 @@ static int hsit_enum_frame_size(struct v4l2_subdev *subdev,
 				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
-	struct vsp1_hsit *hsit = to_hsit(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-
-	config = vsp1_entity_get_pad_config(&hsit->entity, cfg, fse->which);
-	if (!config)
-		return -EINVAL;
-
-	format = vsp1_entity_get_pad_format(&hsit->entity, config, fse->pad);
-
-	if (fse->index || fse->code != format->code)
-		return -EINVAL;
-
-	if (fse->pad == HSIT_PAD_SINK) {
-		fse->min_width = HSIT_MIN_SIZE;
-		fse->max_width = HSIT_MAX_SIZE;
-		fse->min_height = HSIT_MIN_SIZE;
-		fse->max_height = HSIT_MAX_SIZE;
-	} else {
-		/* The size on the source pad are fixed and always identical to
-		 * the size on the sink pad.
-		 */
-		fse->min_width = format->width;
-		fse->max_width = format->width;
-		fse->min_height = format->height;
-		fse->max_height = format->height;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, HSIT_MIN_SIZE,
+					   HSIT_MIN_SIZE, HSIT_MAX_SIZE,
+					   HSIT_MAX_SIZE);
 }
 
 static int hsit_set_format(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index ded4c5a87d4c..d1d52a25c15b 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -54,32 +54,9 @@ static int lif_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
-	struct vsp1_lif *lif = to_lif(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-
-	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fse->which);
-	if (!config)
-		return -EINVAL;
-
-	format = vsp1_entity_get_pad_format(&lif->entity, config, LIF_PAD_SINK);
-
-	if (fse->index || fse->code != format->code)
-		return -EINVAL;
-
-	if (fse->pad == LIF_PAD_SINK) {
-		fse->min_width = LIF_MIN_SIZE;
-		fse->max_width = LIF_MAX_SIZE;
-		fse->min_height = LIF_MIN_SIZE;
-		fse->max_height = LIF_MAX_SIZE;
-	} else {
-		fse->min_width = format->width;
-		fse->max_width = format->width;
-		fse->min_height = format->height;
-		fse->max_height = format->height;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, LIF_MIN_SIZE,
+					   LIF_MIN_SIZE, LIF_MAX_SIZE,
+					   LIF_MAX_SIZE);
 }
 
 static int lif_set_format(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 781ea99abccf..875937681850 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -80,35 +80,9 @@ static int lut_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
-	struct vsp1_lut *lut = to_lut(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-
-	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fse->which);
-	if (!config)
-		return -EINVAL;
-
-	format = vsp1_entity_get_pad_format(&lut->entity, config, fse->pad);
-
-	if (fse->index || fse->code != format->code)
-		return -EINVAL;
-
-	if (fse->pad == LUT_PAD_SINK) {
-		fse->min_width = LUT_MIN_SIZE;
-		fse->max_width = LUT_MAX_SIZE;
-		fse->min_height = LUT_MIN_SIZE;
-		fse->max_height = LUT_MAX_SIZE;
-	} else {
-		/* The size on the source pad are fixed and always identical to
-		 * the size on the sink pad.
-		 */
-		fse->min_width = format->width;
-		fse->max_width = format->width;
-		fse->min_height = format->height;
-		fse->max_height = format->height;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, LUT_MIN_SIZE,
+					   LUT_MIN_SIZE, LUT_MAX_SIZE,
+					   LUT_MAX_SIZE);
 }
 
 static int lut_set_format(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 64d649a1bcf5..3b6e032e7806 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -53,34 +53,10 @@ static int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 				     struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-
-	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, fse->which);
-	if (!config)
-		return -EINVAL;
-
-	format = vsp1_entity_get_pad_format(&rwpf->entity, config, fse->pad);
 
-	if (fse->index || fse->code != format->code)
-		return -EINVAL;
-
-	if (fse->pad == RWPF_PAD_SINK) {
-		fse->min_width = RWPF_MIN_WIDTH;
-		fse->max_width = rwpf->max_width;
-		fse->min_height = RWPF_MIN_HEIGHT;
-		fse->max_height = rwpf->max_height;
-	} else {
-		/* The size on the source pad are fixed and always identical to
-		 * the size on the sink pad.
-		 */
-		fse->min_width = format->width;
-		fse->max_width = format->width;
-		fse->min_height = format->height;
-		fse->max_height = format->height;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, RWPF_MIN_WIDTH,
+					   RWPF_MIN_HEIGHT, rwpf->max_width,
+					   rwpf->max_height);
 }
 
 static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
-- 
2.7.3

