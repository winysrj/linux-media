Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45061 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752756AbcIEPNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 11:13:16 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: [PATCH] v4l: vsp1: Move subdev operations from HGO to common histogram code
Date: Mon,  5 Sep 2016 18:13:39 +0300
Message-Id: <1473088419-2800-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code will be shared with the HGT entity, move it to the generic
histogram implementation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c   |   7 +-
 drivers/media/platform/vsp1/vsp1_hgo.c   | 308 ++--------------------------
 drivers/media/platform/vsp1/vsp1_hgo.h   |   7 +-
 drivers/media/platform/vsp1/vsp1_histo.c | 334 +++++++++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_histo.h |  25 ++-
 5 files changed, 355 insertions(+), 326 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 0b53280be150..1d6e87105752 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -151,8 +151,8 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 	}
 
 	if (vsp1->hgo) {
-		ret = media_create_pad_link(&vsp1->hgo->entity.subdev.entity,
-					    HGO_PAD_SOURCE,
+		ret = media_create_pad_link(&vsp1->hgo->histo.entity.subdev.entity,
+					    HISTO_PAD_SOURCE,
 					    &vsp1->hgo->histo.video.entity, 0,
 					    MEDIA_LNK_FL_ENABLED |
 					    MEDIA_LNK_FL_IMMUTABLE);
@@ -298,7 +298,8 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			goto done;
 		}
 
-		list_add_tail(&vsp1->hgo->entity.list_dev, &vsp1->entities);
+		list_add_tail(&vsp1->hgo->histo.entity.list_dev,
+			      &vsp1->entities);
 	}
 
 	/* The LIF is only supported when used in conjunction with the DU, in
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index 94bb46f3e12b..2b257ad492db 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -21,8 +21,6 @@
 #include "vsp1_dl.h"
 #include "vsp1_hgo.h"
 
-#define HGO_MIN_SIZE				4U
-#define HGO_MAX_SIZE				8192U
 #define HGO_DATA_SIZE				((2 + 256) * 4)
 
 /* -----------------------------------------------------------------------------
@@ -31,7 +29,7 @@
 
 static inline u32 vsp1_hgo_read(struct vsp1_hgo *hgo, u32 reg)
 {
-	return vsp1_read(hgo->entity.vsp1, reg);
+	return vsp1_read(hgo->histo.entity.vsp1, reg);
 }
 
 static inline void vsp1_hgo_write(struct vsp1_hgo *hgo, struct vsp1_dl_list *dl,
@@ -63,7 +61,8 @@ void vsp1_hgo_frame_end(struct vsp1_entity *entity)
 		*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_SUM);
 
 		for (i = 0; i < 256; ++i) {
-			vsp1_write(hgo->entity.vsp1, VI6_HGO_EXT_HIST_ADDR, i);
+			vsp1_write(hgo->histo.entity.vsp1,
+				   VI6_HGO_EXT_HIST_ADDR, i);
 			*data++ = vsp1_hgo_read(hgo, VI6_HGO_EXT_HIST_DATA);
 		}
 
@@ -129,272 +128,6 @@ static const struct v4l2_ctrl_config hgo_num_bins_control = {
 };
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Operations
- */
-
-static int hgo_enum_mbus_code(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_pad_config *cfg,
-			       struct v4l2_subdev_mbus_code_enum *code)
-{
-	static const unsigned int codes[] = {
-		MEDIA_BUS_FMT_ARGB8888_1X32,
-		MEDIA_BUS_FMT_AHSV8888_1X32,
-		MEDIA_BUS_FMT_AYUV8_1X32,
-	};
-
-	if (code->pad == HGO_PAD_SOURCE) {
-		code->code = MEDIA_BUS_FMT_FIXED;
-		return 0;
-	}
-
-	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
-					  ARRAY_SIZE(codes));
-}
-
-static int hgo_enum_frame_size(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_pad_config *cfg,
-				struct v4l2_subdev_frame_size_enum *fse)
-{
-	if (fse->pad != HGO_PAD_SINK)
-		return -EINVAL;
-
-	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, HGO_MIN_SIZE,
-					   HGO_MIN_SIZE, HGO_MAX_SIZE,
-					   HGO_MAX_SIZE);
-}
-
-static int hgo_get_selection(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_pad_config *cfg,
-			     struct v4l2_subdev_selection *sel)
-{
-	struct vsp1_hgo *hgo = to_hgo(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *crop;
-
-	if (sel->pad != HGO_PAD_SINK)
-		return -EINVAL;
-
-	config = vsp1_entity_get_pad_config(&hgo->entity, cfg, sel->which);
-	if (!config)
-		return -EINVAL;
-
-	switch (sel->target) {
-	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
-		crop = vsp1_entity_get_pad_selection(&hgo->entity, config,
-						     HGO_PAD_SINK,
-						     V4L2_SEL_TGT_CROP);
-		sel->r.left = 0;
-		sel->r.top = 0;
-		sel->r.width = crop->width;
-		sel->r.height = crop->height;
-		return 0;
-
-	case V4L2_SEL_TGT_CROP_BOUNDS:
-	case V4L2_SEL_TGT_CROP_DEFAULT:
-		format = vsp1_entity_get_pad_format(&hgo->entity, config,
-						    HGO_PAD_SINK);
-		sel->r.left = 0;
-		sel->r.top = 0;
-		sel->r.width = format->width;
-		sel->r.height = format->height;
-		return 0;
-
-	case V4L2_SEL_TGT_COMPOSE:
-	case V4L2_SEL_TGT_CROP:
-		sel->r = *vsp1_entity_get_pad_selection(&hgo->entity, config,
-							sel->pad, sel->target);
-		return 0;
-
-	default:
-		return -EINVAL;
-	}
-}
-
-static int hgo_set_crop(struct v4l2_subdev *subdev,
-			struct v4l2_subdev_pad_config *config,
-			struct v4l2_subdev_selection *sel)
-{
-	struct vsp1_hgo *hgo = to_hgo(subdev);
-	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *selection;
-
-	/* The crop rectangle must be inside the input frame. */
-	format = vsp1_entity_get_pad_format(&hgo->entity, config, HGO_PAD_SINK);
-	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
-	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
-	sel->r.width = clamp_t(unsigned int, sel->r.width, HGO_MIN_SIZE,
-			       format->width - sel->r.left);
-	sel->r.height = clamp_t(unsigned int, sel->r.height, HGO_MIN_SIZE,
-				format->height - sel->r.top);
-
-	/* Set the crop rectangle and reset the compose rectangle. */
-	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
-						  sel->pad, V4L2_SEL_TGT_CROP);
-	*selection = sel->r;
-
-	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
-						  sel->pad,
-						  V4L2_SEL_TGT_COMPOSE);
-	*selection = sel->r;
-
-	return 0;
-}
-
-static int hgo_set_compose(struct v4l2_subdev *subdev,
-			   struct v4l2_subdev_pad_config *config,
-			   struct v4l2_subdev_selection *sel)
-{
-	struct vsp1_hgo *hgo = to_hgo(subdev);
-	struct v4l2_rect *compose;
-	struct v4l2_rect *crop;
-	unsigned int ratio;
-
-	/* The compose rectangle is used to configure downscaling, the top left
-	 * corner is fixed to (0,0) and the size to 1/2 or 1/4 of the crop
-	 * rectangle.
-	 */
-	sel->r.left = 0;
-	sel->r.top = 0;
-
-	crop = vsp1_entity_get_pad_selection(&hgo->entity, config, sel->pad,
-					     V4L2_SEL_TGT_CROP);
-
-	/* Clamp the width and height to acceptable values first and then
-	 * compute the closest rounded dividing ratio.
-	 *
-	 * Ratio	Rounded ratio
-	 * --------------------------
-	 * [1.0 1.5[	1
-	 * [1.5 3.0[	2
-	 * [3.0 4.0]	4
-	 *
-	 * The rounded ratio can be computed using
-	 *
-	 * 1 << (ceil(ratio * 2) / 3)
-	 */
-	sel->r.width = clamp(sel->r.width, crop->width / 4, crop->width);
-	ratio = 1 << (crop->width * 2 / sel->r.width / 3);
-	sel->r.width = crop->width / ratio;
-
-
-	sel->r.height = clamp(sel->r.height, crop->height / 4, crop->height);
-	ratio = 1 << (crop->height * 2 / sel->r.height / 3);
-	sel->r.height = crop->height / ratio;
-
-	compose = vsp1_entity_get_pad_selection(&hgo->entity, config, sel->pad,
-						V4L2_SEL_TGT_COMPOSE);
-	*compose = sel->r;
-
-	return 0;
-}
-
-static int hgo_set_selection(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_pad_config *cfg,
-			     struct v4l2_subdev_selection *sel)
-{
-	struct vsp1_hgo *hgo = to_hgo(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	if (sel->pad != HGO_PAD_SINK)
-		return -EINVAL;
-
-	config = vsp1_entity_get_pad_config(&hgo->entity, cfg, sel->which);
-	if (!config)
-		return -EINVAL;
-
-	if (sel->target == V4L2_SEL_TGT_CROP)
-		return hgo_set_crop(subdev, config, sel);
-	else if (sel->target == V4L2_SEL_TGT_COMPOSE)
-		return hgo_set_compose(subdev, config, sel);
-	else
-		return -EINVAL;
-}
-
-static int hgo_get_format(struct v4l2_subdev *subdev,
-			   struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
-{
-	if (fmt->pad == HGO_PAD_SOURCE) {
-		fmt->format.code = MEDIA_BUS_FMT_FIXED;
-		fmt->format.width = 0;
-		fmt->format.height = 0;
-		fmt->format.field = V4L2_FIELD_NONE;
-		fmt->format.colorspace = V4L2_COLORSPACE_RAW;
-		return 0;
-	}
-
-	return vsp1_subdev_get_pad_format(subdev, cfg, fmt);
-}
-
-static int hgo_set_format(struct v4l2_subdev *subdev,
-			   struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_hgo *hgo = to_hgo(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *selection;
-
-	if (fmt->pad != HGO_PAD_SINK)
-		return hgo_get_format(subdev, cfg, fmt);
-
-	config = vsp1_entity_get_pad_config(&hgo->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	/* Default to YUV if the requested format is not supported. */
-	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
-	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
-	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
-		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
-
-	format = vsp1_entity_get_pad_format(&hgo->entity, config, fmt->pad);
-
-	format->code = fmt->format.code;
-	format->width = clamp_t(unsigned int, fmt->format.width,
-				HGO_MIN_SIZE, HGO_MAX_SIZE);
-	format->height = clamp_t(unsigned int, fmt->format.height,
-				 HGO_MIN_SIZE, HGO_MAX_SIZE);
-	format->field = V4L2_FIELD_NONE;
-	format->colorspace = V4L2_COLORSPACE_SRGB;
-
-	fmt->format = *format;
-
-	/* Reset the crop and compose rectangles */
-	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
-						  fmt->pad, V4L2_SEL_TGT_CROP);
-	selection->left = 0;
-	selection->top = 0;
-	selection->width = format->width;
-	selection->height = format->height;
-
-	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
-						  fmt->pad,
-						  V4L2_SEL_TGT_COMPOSE);
-	selection->left = 0;
-	selection->top = 0;
-	selection->width = format->width;
-	selection->height = format->height;
-
-	return 0;
-}
-
-static const struct v4l2_subdev_pad_ops hgo_pad_ops = {
-	.enum_mbus_code = hgo_enum_mbus_code,
-	.enum_frame_size = hgo_enum_frame_size,
-	.get_fmt = hgo_get_format,
-	.set_fmt = hgo_set_format,
-	.get_selection = hgo_get_selection,
-	.set_selection = hgo_set_selection,
-};
-
-static const struct v4l2_subdev_ops hgo_ops = {
-	.pad    = &hgo_pad_ops,
-};
-
-/* -----------------------------------------------------------------------------
  * VSP1 Entity Operations
  */
 
@@ -412,9 +145,9 @@ static void hgo_configure(struct vsp1_entity *entity,
 		return;
 
 	crop = vsp1_entity_get_pad_selection(entity, entity->config,
-					     HGO_PAD_SINK, V4L2_SEL_TGT_CROP);
+					     HISTO_PAD_SINK, V4L2_SEL_TGT_CROP);
 	compose = vsp1_entity_get_pad_selection(entity, entity->config,
-						HGO_PAD_SINK,
+						HISTO_PAD_SINK,
 						V4L2_SEL_TGT_COMPOSE);
 
 	vsp1_hgo_write(hgo, dl, VI6_HGO_REGRST, VI6_HGO_REGRST_RCLEA);
@@ -441,22 +174,21 @@ static void hgo_configure(struct vsp1_entity *entity,
 		       (vratio << VI6_HGO_MODE_VRATIO_SHIFT));
 }
 
-static void hgo_destroy(struct vsp1_entity *entity)
-{
-	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
-
-	vsp1_histogram_cleanup(&hgo->histo);
-}
-
 static const struct vsp1_entity_operations hgo_entity_ops = {
 	.configure = hgo_configure,
-	.destroy = hgo_destroy,
+	.destroy = vsp1_histogram_destroy,
 };
 
 /* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
+static const unsigned int hgo_mbus_formats[] = {
+	MEDIA_BUS_FMT_AYUV8_1X32,
+	MEDIA_BUS_FMT_ARGB8888_1X32,
+	MEDIA_BUS_FMT_AHSV8888_1X32,
+};
+
 struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1)
 {
 	struct vsp1_hgo *hgo;
@@ -466,14 +198,6 @@ struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1)
 	if (hgo == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	hgo->entity.ops = &hgo_entity_ops;
-	hgo->entity.type = VSP1_ENTITY_HGO;
-
-	ret = vsp1_entity_init(vsp1, &hgo->entity, "hgo", 2, &hgo_ops,
-			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&hgo->ctrls.handler,
 			       vsp1->info->gen == 3 ? 2 : 1);
@@ -487,13 +211,15 @@ struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1)
 	hgo->max_rgb = false;
 	hgo->num_bins = 64;
 
-	hgo->entity.subdev.ctrl_handler = &hgo->ctrls.handler;
+	hgo->histo.entity.subdev.ctrl_handler = &hgo->ctrls.handler;
 
 	/* Initialize the video device and queue for statistics data. */
-	ret = vsp1_histogram_init(vsp1, &hgo->histo, hgo->entity.subdev.name,
+	ret = vsp1_histogram_init(vsp1, &hgo->histo, VSP1_ENTITY_HGO, "hgo",
+				  &hgo_entity_ops, hgo_mbus_formats,
+				  ARRAY_SIZE(hgo_mbus_formats),
 				  HGO_DATA_SIZE, V4L2_META_FMT_VSP1_HGO);
 	if (ret < 0) {
-		vsp1_entity_destroy(&hgo->entity);
+		vsp1_entity_destroy(&hgo->histo.entity);
 		return ERR_PTR(ret);
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.h b/drivers/media/platform/vsp1/vsp1_hgo.h
index d677b3fe6023..c6c0b7a80e0c 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.h
+++ b/drivers/media/platform/vsp1/vsp1_hgo.h
@@ -17,16 +17,11 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 
-#include "vsp1_entity.h"
 #include "vsp1_histo.h"
 
 struct vsp1_device;
 
-#define HGO_PAD_SINK				0
-#define HGO_PAD_SOURCE				1
-
 struct vsp1_hgo {
-	struct vsp1_entity entity;
 	struct vsp1_histogram histo;
 
 	struct {
@@ -41,7 +36,7 @@ struct vsp1_hgo {
 
 static inline struct vsp1_hgo *to_hgo(struct v4l2_subdev *subdev)
 {
-	return container_of(subdev, struct vsp1_hgo, entity.subdev);
+	return container_of(subdev, struct vsp1_hgo, histo.entity.subdev);
 }
 
 struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1);
diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
index 89e162438bd6..382a93fead14 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.c
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -23,6 +23,9 @@
 #include "vsp1_histo.h"
 #include "vsp1_pipe.h"
 
+#define HISTO_MIN_SIZE				4U
+#define HISTO_MAX_SIZE				8192U
+
 /* -----------------------------------------------------------------------------
  * Buffer Operations
  */
@@ -166,6 +169,275 @@ static const struct vb2_ops histo_video_queue_qops = {
 };
 
 /* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static int histo_enum_mbus_code(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct vsp1_histogram *histo = subdev_to_histo(subdev);
+
+	if (code->pad == HISTO_PAD_SOURCE) {
+		code->code = MEDIA_BUS_FMT_FIXED;
+		return 0;
+	}
+
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, histo->formats,
+					  histo->num_formats);
+}
+
+static int histo_enum_frame_size(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_frame_size_enum *fse)
+{
+	if (fse->pad != HISTO_PAD_SINK)
+		return -EINVAL;
+
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, HISTO_MIN_SIZE,
+					   HISTO_MIN_SIZE, HISTO_MAX_SIZE,
+					   HISTO_MAX_SIZE);
+}
+
+static int histo_get_selection(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_histogram *histo = subdev_to_histo(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
+
+	if (sel->pad != HISTO_PAD_SINK)
+		return -EINVAL;
+
+	config = vsp1_entity_get_pad_config(&histo->entity, cfg, sel->which);
+	if (!config)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		crop = vsp1_entity_get_pad_selection(&histo->entity, config,
+						     HISTO_PAD_SINK,
+						     V4L2_SEL_TGT_CROP);
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = crop->width;
+		sel->r.height = crop->height;
+		return 0;
+
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		format = vsp1_entity_get_pad_format(&histo->entity, config,
+						    HISTO_PAD_SINK);
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = format->width;
+		sel->r.height = format->height;
+		return 0;
+
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_CROP:
+		sel->r = *vsp1_entity_get_pad_selection(&histo->entity, config,
+							sel->pad, sel->target);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int histo_set_crop(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *config,
+			 struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_histogram *histo = subdev_to_histo(subdev);
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *selection;
+
+	/* The crop rectangle must be inside the input frame. */
+	format = vsp1_entity_get_pad_format(&histo->entity, config,
+					    HISTO_PAD_SINK);
+	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
+	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
+	sel->r.width = clamp_t(unsigned int, sel->r.width, HISTO_MIN_SIZE,
+			       format->width - sel->r.left);
+	sel->r.height = clamp_t(unsigned int, sel->r.height, HISTO_MIN_SIZE,
+				format->height - sel->r.top);
+
+	/* Set the crop rectangle and reset the compose rectangle. */
+	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
+						  sel->pad, V4L2_SEL_TGT_CROP);
+	*selection = sel->r;
+
+	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
+						  sel->pad,
+						  V4L2_SEL_TGT_COMPOSE);
+	*selection = sel->r;
+
+	return 0;
+}
+
+static int histo_set_compose(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_pad_config *config,
+			     struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_histogram *histo = subdev_to_histo(subdev);
+	struct v4l2_rect *compose;
+	struct v4l2_rect *crop;
+	unsigned int ratio;
+
+	/* The compose rectangle is used to configure downscaling, the top left
+	 * corner is fixed to (0,0) and the size to 1/2 or 1/4 of the crop
+	 * rectangle.
+	 */
+	sel->r.left = 0;
+	sel->r.top = 0;
+
+	crop = vsp1_entity_get_pad_selection(&histo->entity, config, sel->pad,
+					     V4L2_SEL_TGT_CROP);
+
+	/* Clamp the width and height to acceptable values first and then
+	 * compute the closest rounded dividing ratio.
+	 *
+	 * Ratio	Rounded ratio
+	 * --------------------------
+	 * [1.0 1.5[	1
+	 * [1.5 3.0[	2
+	 * [3.0 4.0]	4
+	 *
+	 * The rounded ratio can be computed using
+	 *
+	 * 1 << (ceil(ratio * 2) / 3)
+	 */
+	sel->r.width = clamp(sel->r.width, crop->width / 4, crop->width);
+	ratio = 1 << (crop->width * 2 / sel->r.width / 3);
+	sel->r.width = crop->width / ratio;
+
+
+	sel->r.height = clamp(sel->r.height, crop->height / 4, crop->height);
+	ratio = 1 << (crop->height * 2 / sel->r.height / 3);
+	sel->r.height = crop->height / ratio;
+
+	compose = vsp1_entity_get_pad_selection(&histo->entity, config,
+						sel->pad,
+						V4L2_SEL_TGT_COMPOSE);
+	*compose = sel->r;
+
+	return 0;
+}
+
+static int histo_set_selection(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_histogram *histo = subdev_to_histo(subdev);
+	struct v4l2_subdev_pad_config *config;
+
+	if (sel->pad != HISTO_PAD_SINK)
+		return -EINVAL;
+
+	config = vsp1_entity_get_pad_config(&histo->entity, cfg, sel->which);
+	if (!config)
+		return -EINVAL;
+
+	if (sel->target == V4L2_SEL_TGT_CROP)
+		return histo_set_crop(subdev, config, sel);
+	else if (sel->target == V4L2_SEL_TGT_COMPOSE)
+		return histo_set_compose(subdev, config, sel);
+	else
+		return -EINVAL;
+}
+
+static int histo_get_format(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *fmt)
+{
+	if (fmt->pad == HISTO_PAD_SOURCE) {
+		fmt->format.code = MEDIA_BUS_FMT_FIXED;
+		fmt->format.width = 0;
+		fmt->format.height = 0;
+		fmt->format.field = V4L2_FIELD_NONE;
+		fmt->format.colorspace = V4L2_COLORSPACE_RAW;
+		return 0;
+	}
+
+	return vsp1_subdev_get_pad_format(subdev, cfg, fmt);
+}
+
+static int histo_set_format(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_histogram *histo = subdev_to_histo(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *selection;
+	unsigned int i;
+
+	if (fmt->pad != HISTO_PAD_SINK)
+		return histo_get_format(subdev, cfg, fmt);
+
+	config = vsp1_entity_get_pad_config(&histo->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	/* Default to the first format if the requested format is not
+	 * supported.
+	 */
+	for (i = 0; i < histo->num_formats; ++i) {
+		if (fmt->format.code == histo->formats[i])
+			break;
+	}
+	if (i == histo->num_formats)
+		fmt->format.code = histo->formats[0];
+
+	format = vsp1_entity_get_pad_format(&histo->entity, config, fmt->pad);
+
+	format->code = fmt->format.code;
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				HISTO_MIN_SIZE, HISTO_MAX_SIZE);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 HISTO_MIN_SIZE, HISTO_MAX_SIZE);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Reset the crop and compose rectangles */
+	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
+						  fmt->pad, V4L2_SEL_TGT_CROP);
+	selection->left = 0;
+	selection->top = 0;
+	selection->width = format->width;
+	selection->height = format->height;
+
+	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
+						  fmt->pad,
+						  V4L2_SEL_TGT_COMPOSE);
+	selection->left = 0;
+	selection->top = 0;
+	selection->width = format->width;
+	selection->height = format->height;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops histo_pad_ops = {
+	.enum_mbus_code = histo_enum_mbus_code,
+	.enum_frame_size = histo_enum_frame_size,
+	.get_fmt = histo_get_format,
+	.set_fmt = histo_set_format,
+	.get_selection = histo_get_selection,
+	.set_selection = histo_set_selection,
+};
+
+static const struct v4l2_subdev_ops histo_ops = {
+	.pad    = &histo_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
  * V4L2 ioctls
  */
 
@@ -173,7 +445,7 @@ static int histo_v4l2_querycap(struct file *file, void *fh,
 			       struct v4l2_capability *cap)
 {
 	struct v4l2_fh *vfh = file->private_data;
-	struct vsp1_histogram *histo = to_vsp1_histo(vfh->vdev);
+	struct vsp1_histogram *histo = vdev_to_histo(vfh->vdev);
 
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
 			  | V4L2_CAP_VIDEO_CAPTURE_MPLANE
@@ -185,7 +457,7 @@ static int histo_v4l2_querycap(struct file *file, void *fh,
 	strlcpy(cap->driver, "vsp1", sizeof(cap->driver));
 	strlcpy(cap->card, histo->video.name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
-		 dev_name(histo->vsp1->dev));
+		 dev_name(histo->entity.vsp1->dev));
 
 	return 0;
 }
@@ -194,12 +466,12 @@ static int histo_v4l2_enum_format(struct file *file, void *fh,
 				  struct v4l2_fmtdesc *f)
 {
 	struct v4l2_fh *vfh = file->private_data;
-	struct vsp1_histogram *histo = to_vsp1_histo(vfh->vdev);
+	struct vsp1_histogram *histo = vdev_to_histo(vfh->vdev);
 
 	if (f->index > 0 || f->type != histo->queue.type)
 		return -EINVAL;
 
-	f->pixelformat = histo->format;
+	f->pixelformat = histo->meta_format;
 
 	return 0;
 }
@@ -208,7 +480,7 @@ static int histo_v4l2_get_format(struct file *file, void *fh,
 				 struct v4l2_format *format)
 {
 	struct v4l2_fh *vfh = file->private_data;
-	struct vsp1_histogram *histo = to_vsp1_histo(vfh->vdev);
+	struct vsp1_histogram *histo = vdev_to_histo(vfh->vdev);
 	struct v4l2_meta_format *meta = &format->fmt.meta;
 
 	if (format->type != histo->queue.type)
@@ -216,7 +488,7 @@ static int histo_v4l2_get_format(struct file *file, void *fh,
 
 	memset(meta, 0, sizeof(*meta));
 
-	meta->dataformat = histo->format;
+	meta->dataformat = histo->meta_format;
 	meta->buffersize = histo->data_size;
 
 	return 0;
@@ -251,14 +523,33 @@ static const struct v4l2_file_operations histo_v4l2_fops = {
 	.mmap = vb2_fop_mmap,
 };
 
+static void vsp1_histogram_cleanup(struct vsp1_histogram *histo)
+{
+	if (video_is_registered(&histo->video))
+		video_unregister_device(&histo->video);
+
+	media_entity_cleanup(&histo->video.entity);
+}
+
+void vsp1_histogram_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_histogram *histo = subdev_to_histo(&entity->subdev);
+
+	vsp1_histogram_cleanup(histo);
+}
+
 int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
-			const char *name, size_t data_size, u32 format)
+			enum vsp1_entity_type type, const char *name,
+			const struct vsp1_entity_operations *ops,
+			const unsigned int *formats, unsigned int num_formats,
+			size_t data_size, u32 meta_format)
 {
 	int ret;
 
-	histo->vsp1 = vsp1;
+	histo->formats = formats;
+	histo->num_formats = num_formats;
 	histo->data_size = data_size;
-	histo->format = format;
+	histo->meta_format = meta_format;
 
 	histo->pad.flags = MEDIA_PAD_FL_SINK;
 	histo->video.vfl_dir = VFL_DIR_RX;
@@ -268,7 +559,16 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
 	INIT_LIST_HEAD(&histo->irqqueue);
 	init_waitqueue_head(&histo->wait_queue);
 
-	/* Initialize the media entity... */
+	/* Initialize the VSP entity... */
+	histo->entity.ops = ops;
+	histo->entity.type = type;
+
+	ret = vsp1_entity_init(vsp1, &histo->entity, name, 2, &histo_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
+	if (ret < 0)
+		return ret;
+
+	/* ... and the media entity... */
 	ret = media_entity_pads_init(&histo->video.entity, 1, &histo->pad);
 	if (ret < 0)
 		return ret;
@@ -293,10 +593,10 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
 	histo->queue.ops = &histo_video_queue_qops;
 	histo->queue.mem_ops = &vb2_vmalloc_memops;
 	histo->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	histo->queue.dev = histo->vsp1->dev;
+	histo->queue.dev = vsp1->dev;
 	ret = vb2_queue_init(&histo->queue);
 	if (ret < 0) {
-		dev_err(histo->vsp1->dev, "failed to initialize vb2 queue\n");
+		dev_err(vsp1->dev, "failed to initialize vb2 queue\n");
 		goto error;
 	}
 
@@ -304,7 +604,7 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
 	histo->video.queue = &histo->queue;
 	ret = video_register_device(&histo->video, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
-		dev_err(histo->vsp1->dev, "failed to register video device\n");
+		dev_err(vsp1->dev, "failed to register video device\n");
 		goto error;
 	}
 
@@ -314,11 +614,3 @@ error:
 	vsp1_histogram_cleanup(histo);
 	return ret;
 }
-
-void vsp1_histogram_cleanup(struct vsp1_histogram *histo)
-{
-	if (video_is_registered(&histo->video))
-		video_unregister_device(&histo->video);
-
-	media_entity_cleanup(&histo->video.entity);
-}
diff --git a/drivers/media/platform/vsp1/vsp1_histo.h b/drivers/media/platform/vsp1/vsp1_histo.h
index daf648c490f5..af2874f6031d 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.h
+++ b/drivers/media/platform/vsp1/vsp1_histo.h
@@ -22,9 +22,14 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-v4l2.h>
 
+#include "vsp1_entity.h"
+
 struct vsp1_device;
 struct vsp1_pipeline;
 
+#define HISTO_PAD_SINK				0
+#define HISTO_PAD_SOURCE			1
+
 struct vsp1_histogram_buffer {
 	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
@@ -32,14 +37,16 @@ struct vsp1_histogram_buffer {
 };
 
 struct vsp1_histogram {
-	struct vsp1_device *vsp1;
 	struct vsp1_pipeline *pipe;
 
+	struct vsp1_entity entity;
 	struct video_device video;
 	struct media_pad pad;
 
+	const u32 *formats;
+	unsigned int num_formats;
 	size_t data_size;
-	u32 format;
+	u32 meta_format;
 
 	struct mutex lock;
 	struct vb2_queue queue;
@@ -51,14 +58,22 @@ struct vsp1_histogram {
 	bool readout;
 };
 
-static inline struct vsp1_histogram *to_vsp1_histo(struct video_device *vdev)
+static inline struct vsp1_histogram *vdev_to_histo(struct video_device *vdev)
 {
 	return container_of(vdev, struct vsp1_histogram, video);
 }
 
+static inline struct vsp1_histogram *subdev_to_histo(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_histogram, entity.subdev);
+}
+
 int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
-			const char *name, size_t data_size, u32 format);
-void vsp1_histogram_cleanup(struct vsp1_histogram *histo);
+			enum vsp1_entity_type type, const char *name,
+			const struct vsp1_entity_operations *ops,
+			const unsigned int *formats, unsigned int num_formats,
+			size_t data_size, u32 meta_format);
+void vsp1_histogram_destroy(struct vsp1_entity *entity);
 
 struct vsp1_histogram_buffer *
 vsp1_histogram_buffer_get(struct vsp1_histogram *histo);
-- 
Regards,

Laurent Pinchart

