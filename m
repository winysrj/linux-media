Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53685 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752145AbdLCK5i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:57:38 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/9] v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation code
Date: Sun,  3 Dec 2017 12:57:29 +0200
Message-Id: <20171203105735.10529-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The implementation of the set_fmt pad operation is identical in the
three modules. Move it to a generic helper function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_clu.c    | 65 +++++----------------------
 drivers/media/platform/vsp1/vsp1_entity.c | 75 +++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  6 +++
 drivers/media/platform/vsp1/vsp1_lif.c    | 65 +++++----------------------
 drivers/media/platform/vsp1/vsp1_lut.c    | 65 +++++----------------------
 5 files changed, 116 insertions(+), 160 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index f2fb26e5ab4e..bc931a3ab498 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -118,18 +118,18 @@ static const struct v4l2_ctrl_config clu_mode_control = {
  * V4L2 Subdevice Pad Operations
  */
 
+static const unsigned int clu_codes[] = {
+	MEDIA_BUS_FMT_ARGB8888_1X32,
+	MEDIA_BUS_FMT_AHSV8888_1X32,
+	MEDIA_BUS_FMT_AYUV8_1X32,
+};
+
 static int clu_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
-	static const unsigned int codes[] = {
-		MEDIA_BUS_FMT_ARGB8888_1X32,
-		MEDIA_BUS_FMT_AHSV8888_1X32,
-		MEDIA_BUS_FMT_AYUV8_1X32,
-	};
-
-	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
-					  ARRAY_SIZE(codes));
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, clu_codes,
+					  ARRAY_SIZE(clu_codes));
 }
 
 static int clu_enum_frame_size(struct v4l2_subdev *subdev,
@@ -145,51 +145,10 @@ static int clu_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
-	struct vsp1_clu *clu = to_clu(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-	int ret = 0;
-
-	mutex_lock(&clu->entity.lock);
-
-	config = vsp1_entity_get_pad_config(&clu->entity, cfg, fmt->which);
-	if (!config) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	/* Default to YUV if the requested format is not supported. */
-	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
-	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
-	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
-		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
-
-	format = vsp1_entity_get_pad_format(&clu->entity, config, fmt->pad);
-
-	if (fmt->pad == CLU_PAD_SOURCE) {
-		/* The CLU output format can't be modified. */
-		fmt->format = *format;
-		goto done;
-	}
-
-	format->code = fmt->format.code;
-	format->width = clamp_t(unsigned int, fmt->format.width,
-				CLU_MIN_SIZE, CLU_MAX_SIZE);
-	format->height = clamp_t(unsigned int, fmt->format.height,
-				 CLU_MIN_SIZE, CLU_MAX_SIZE);
-	format->field = V4L2_FIELD_NONE;
-	format->colorspace = V4L2_COLORSPACE_SRGB;
-
-	fmt->format = *format;
-
-	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&clu->entity, config,
-					    CLU_PAD_SOURCE);
-	*format = fmt->format;
-
-done:
-	mutex_unlock(&clu->entity.lock);
-	return ret;
+	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, clu_codes,
+					  ARRAY_SIZE(clu_codes),
+					  CLU_MIN_SIZE, CLU_MIN_SIZE,
+					  CLU_MAX_SIZE, CLU_MAX_SIZE);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 54de15095709..0fa310f1a8d1 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -311,6 +311,81 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
 	return ret;
 }
 
+/*
+ * vsp1_subdev_set_pad_format - Subdev pad set_fmt handler
+ * @subdev: V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @fmt: V4L2 subdev format
+ * @codes: Array of supported media bus codes
+ * @ncodes: Number of supported media bus codes
+ * @min_width: Minimum image width
+ * @min_height: Minimum image height
+ * @max_width: Maximum image width
+ * @max_height: Maximum image height
+ *
+ * This function implements the subdev set_fmt pad operation for entities that
+ * do not support scaling or cropping. It defaults to the first supplied media
+ * bus code if the requested code isn't supported, clamps the size to the
+ * supplied minimum and maximum, and propagates the sink pad format to the
+ * source pad.
+ */
+int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_format *fmt,
+			       const unsigned int *codes, unsigned int ncodes,
+			       unsigned int min_width, unsigned int min_height,
+			       unsigned int max_width, unsigned int max_height)
+{
+	struct vsp1_entity *entity = to_vsp1_entity(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+	unsigned int i;
+	int ret = 0;
+
+	mutex_lock(&entity->lock);
+
+	config = vsp1_entity_get_pad_config(entity, cfg, fmt->which);
+	if (!config) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	format = vsp1_entity_get_pad_format(entity, config, fmt->pad);
+
+	if (fmt->pad != 0) {
+		/* The output format can't be modified. */
+		fmt->format = *format;
+		goto done;
+	}
+
+	/*
+	 * Default to the first media bus code if the requested format is not
+	 * supported.
+	 */
+	for (i = 0; i < ncodes; ++i) {
+		if (fmt->format.code == codes[i])
+			break;
+	}
+
+	format->code = i < ncodes ? codes[i] : codes[0];
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				min_width, max_width);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 min_height, max_height);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Propagate the format to the source pad. */
+	format = vsp1_entity_get_pad_format(entity, config, 1);
+	*format = fmt->format;
+
+done:
+	mutex_unlock(&entity->lock);
+	return ret;
+}
+
 /* -----------------------------------------------------------------------------
  * Media Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 408602ebeb97..319e053737fd 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -162,6 +162,12 @@ struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad);
 int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt);
+int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_format *fmt,
+			       const unsigned int *codes, unsigned int ncodes,
+			       unsigned int min_width, unsigned int min_height,
+			       unsigned int max_width, unsigned int max_height);
 int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code,
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index e6fa16d7fda8..ad56629450ec 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -37,17 +37,17 @@ static inline void vsp1_lif_write(struct vsp1_lif *lif, struct vsp1_dl_list *dl,
  * V4L2 Subdevice Operations
  */
 
+static const unsigned int lif_codes[] = {
+	MEDIA_BUS_FMT_ARGB8888_1X32,
+	MEDIA_BUS_FMT_AYUV8_1X32,
+};
+
 static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
-	static const unsigned int codes[] = {
-		MEDIA_BUS_FMT_ARGB8888_1X32,
-		MEDIA_BUS_FMT_AYUV8_1X32,
-	};
-
-	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
-					  ARRAY_SIZE(codes));
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, lif_codes,
+					  ARRAY_SIZE(lif_codes));
 }
 
 static int lif_enum_frame_size(struct v4l2_subdev *subdev,
@@ -63,53 +63,10 @@ static int lif_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
-	struct vsp1_lif *lif = to_lif(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-	int ret = 0;
-
-	mutex_lock(&lif->entity.lock);
-
-	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fmt->which);
-	if (!config) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	/* Default to YUV if the requested format is not supported. */
-	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
-	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
-		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
-
-	format = vsp1_entity_get_pad_format(&lif->entity, config, fmt->pad);
-
-	if (fmt->pad == LIF_PAD_SOURCE) {
-		/*
-		 * The LIF source format is always identical to its sink
-		 * format.
-		 */
-		fmt->format = *format;
-		goto done;
-	}
-
-	format->code = fmt->format.code;
-	format->width = clamp_t(unsigned int, fmt->format.width,
-				LIF_MIN_SIZE, LIF_MAX_SIZE);
-	format->height = clamp_t(unsigned int, fmt->format.height,
-				 LIF_MIN_SIZE, LIF_MAX_SIZE);
-	format->field = V4L2_FIELD_NONE;
-	format->colorspace = V4L2_COLORSPACE_SRGB;
-
-	fmt->format = *format;
-
-	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&lif->entity, config,
-					    LIF_PAD_SOURCE);
-	*format = fmt->format;
-
-done:
-	mutex_unlock(&lif->entity.lock);
-	return ret;
+	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, lif_codes,
+					  ARRAY_SIZE(lif_codes),
+					  LIF_MIN_SIZE, LIF_MIN_SIZE,
+					  LIF_MAX_SIZE, LIF_MAX_SIZE);
 }
 
 static const struct v4l2_subdev_pad_ops lif_pad_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index c67cc60db0db..63f8127a65a4 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -94,18 +94,18 @@ static const struct v4l2_ctrl_config lut_table_control = {
  * V4L2 Subdevice Pad Operations
  */
 
+static const unsigned int lut_codes[] = {
+	MEDIA_BUS_FMT_ARGB8888_1X32,
+	MEDIA_BUS_FMT_AHSV8888_1X32,
+	MEDIA_BUS_FMT_AYUV8_1X32,
+};
+
 static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
-	static const unsigned int codes[] = {
-		MEDIA_BUS_FMT_ARGB8888_1X32,
-		MEDIA_BUS_FMT_AHSV8888_1X32,
-		MEDIA_BUS_FMT_AYUV8_1X32,
-	};
-
-	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
-					  ARRAY_SIZE(codes));
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, lut_codes,
+					  ARRAY_SIZE(lut_codes));
 }
 
 static int lut_enum_frame_size(struct v4l2_subdev *subdev,
@@ -121,51 +121,10 @@ static int lut_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
-	struct vsp1_lut *lut = to_lut(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-	int ret = 0;
-
-	mutex_lock(&lut->entity.lock);
-
-	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fmt->which);
-	if (!config) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	/* Default to YUV if the requested format is not supported. */
-	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
-	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
-	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
-		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
-
-	format = vsp1_entity_get_pad_format(&lut->entity, config, fmt->pad);
-
-	if (fmt->pad == LUT_PAD_SOURCE) {
-		/* The LUT output format can't be modified. */
-		fmt->format = *format;
-		goto done;
-	}
-
-	format->code = fmt->format.code;
-	format->width = clamp_t(unsigned int, fmt->format.width,
-				LUT_MIN_SIZE, LUT_MAX_SIZE);
-	format->height = clamp_t(unsigned int, fmt->format.height,
-				 LUT_MIN_SIZE, LUT_MAX_SIZE);
-	format->field = V4L2_FIELD_NONE;
-	format->colorspace = V4L2_COLORSPACE_SRGB;
-
-	fmt->format = *format;
-
-	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&lut->entity, config,
-					    LUT_PAD_SOURCE);
-	*format = fmt->format;
-
-done:
-	mutex_unlock(&lut->entity.lock);
-	return ret;
+	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, lut_codes,
+					  ARRAY_SIZE(lut_codes),
+					  LUT_MIN_SIZE, LUT_MIN_SIZE,
+					  LUT_MAX_SIZE, LUT_MAX_SIZE);
 }
 
 /* -----------------------------------------------------------------------------
-- 
Regards,

Laurent Pinchart
