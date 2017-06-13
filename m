Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36929 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753996AbdFMThK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 15:37:10 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v4 07/11] [media] vimc: sen: Support several image formats
Date: Tue, 13 Jun 2017 16:35:35 -0300
Message-Id: <1497382545-16408-8-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
References: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow user space to change the image format as the frame size, the
media bus pixel format, colorspace, quantization, field YCbCr encoding
and the transfer function

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v4:
[media] vimc: sen: Support several image formats
	- use vimc_colorimetry_clamp macro
	- replace V4L2_COLORSPACE_SRGB by V4L2_COLORSPACE_DEFAULT in the
	default format struct

Changes in v3:
[media] vimc: sen: Support several image formats
	- remove support for V4L2_FIELD_ALTERNATE (left as TODO for now)
	- clamp image size to an even dimension for height and width
	- set default values for colorimetry using _DEFAULT macro
	- reset all values of colorimetry to _DEFAULT if user tries to
	set an invalid colorspace

Changes in v2:
[media] vimc: sen: Support several image formats
	- this is a new commit in the serie (the old one was splitted in two)
	- add init_cfg to initialize try_fmt
	- reorder code in vimc_sen_set_fmt
	- allow user space to change all fields from struct v4l2_mbus_framefmt
	  (e.g. colospace, quantization, field, xfer_func, ycbcr_enc)
	- merge with patch for the enum_mbus_code and enum_frame_size
	- change commit message
	- add vimc_pix_map_by_index
	- rename MIN/MAX macros
	- check set_fmt default parameters for quantization, colorspace ...media] vimc: sen: Support several image formats


---
 drivers/media/platform/vimc/vimc-common.c |   8 ++
 drivers/media/platform/vimc/vimc-common.h |  12 +++
 drivers/media/platform/vimc/vimc-sensor.c | 130 +++++++++++++++++++++++-------
 3 files changed, 121 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 6ad77fd..b698055 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -144,6 +144,14 @@ static const struct vimc_pix_map vimc_pix_map_list[] = {
 	},
 };
 
+const struct vimc_pix_map *vimc_pix_map_by_index(unsigned int i)
+{
+	if (i >= ARRAY_SIZE(vimc_pix_map_list))
+		return NULL;
+
+	return &vimc_pix_map_list[i];
+}
+
 const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
 {
 	unsigned int i;
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 43483ee..fb3463c 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -22,6 +22,11 @@
 #include <media/media-device.h>
 #include <media/v4l2-device.h>
 
+#define VIMC_FRAME_MAX_WIDTH 4096
+#define VIMC_FRAME_MAX_HEIGHT 2160
+#define VIMC_FRAME_MIN_WIDTH 16
+#define VIMC_FRAME_MIN_HEIGHT 16
+
 /**
  * struct vimc_colorimetry_clamp - Adjust colorimetry parameters
  *
@@ -139,6 +144,13 @@ static inline void vimc_pads_cleanup(struct media_pad *pads)
 int vimc_pipeline_s_stream(struct media_entity *ent, int enable);
 
 /**
+ * vimc_pix_map_by_index - get vimc_pix_map struct by its index
+ *
+ * @i:			index of the vimc_pix_map struct in vimc_pix_map_list
+ */
+const struct vimc_pix_map *vimc_pix_map_by_index(unsigned int i);
+
+/**
  * vimc_pix_map_by_code - get vimc_pix_map struct by media bus code
  *
  * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 6386ac1..d4f9705 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -24,8 +24,6 @@
 
 #include "vimc-sensor.h"
 
-#define VIMC_SEN_FRAME_MAX_WIDTH 4096
-
 struct vimc_sen_device {
 	struct vimc_ent_device ved;
 	struct v4l2_subdev sd;
@@ -36,18 +34,39 @@ struct vimc_sen_device {
 	struct v4l2_mbus_framefmt mbus_format;
 };
 
+static const struct v4l2_mbus_framefmt fmt_default = {
+	.width = 640,
+	.height = 480,
+	.code = MEDIA_BUS_FMT_RGB888_1X24,
+	.field = V4L2_FIELD_NONE,
+	.colorspace = V4L2_COLORSPACE_DEFAULT,
+};
+
+static int vimc_sen_init_cfg(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg)
+{
+	unsigned int i;
+
+	for (i = 0; i < sd->entity.num_pads; i++) {
+		struct v4l2_mbus_framefmt *mf;
+
+		mf = v4l2_subdev_get_try_format(sd, cfg, i);
+		*mf = fmt_default;
+	}
+
+	return 0;
+}
+
 static int vimc_sen_enum_mbus_code(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_mbus_code_enum *code)
 {
-	struct vimc_sen_device *vsen =
-				container_of(sd, struct vimc_sen_device, sd);
+	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(code->index);
 
-	/* TODO: Add support for other codes */
-	if (code->index)
+	if (!vpix)
 		return -EINVAL;
 
-	code->code = vsen->mbus_format.code;
+	code->code = vpix->code;
 
 	return 0;
 }
@@ -56,33 +75,34 @@ static int vimc_sen_enum_frame_size(struct v4l2_subdev *sd,
 				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_subdev_frame_size_enum *fse)
 {
-	struct vimc_sen_device *vsen =
-				container_of(sd, struct vimc_sen_device, sd);
+	const struct vimc_pix_map *vpix;
 
-	/* TODO: Add support to other formats */
 	if (fse->index)
 		return -EINVAL;
 
-	/* TODO: Add support for other codes */
-	if (fse->code != vsen->mbus_format.code)
+	/* Only accept code in the pix map table */
+	vpix = vimc_pix_map_by_code(fse->code);
+	if (!vpix)
 		return -EINVAL;
 
-	fse->min_width = vsen->mbus_format.width;
-	fse->max_width = vsen->mbus_format.width;
-	fse->min_height = vsen->mbus_format.height;
-	fse->max_height = vsen->mbus_format.height;
+	fse->min_width = VIMC_FRAME_MIN_WIDTH;
+	fse->max_width = VIMC_FRAME_MAX_WIDTH;
+	fse->min_height = VIMC_FRAME_MIN_HEIGHT;
+	fse->max_height = VIMC_FRAME_MAX_HEIGHT;
 
 	return 0;
 }
 
 static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
 			    struct v4l2_subdev_pad_config *cfg,
-			    struct v4l2_subdev_format *format)
+			    struct v4l2_subdev_format *fmt)
 {
 	struct vimc_sen_device *vsen =
 				container_of(sd, struct vimc_sen_device, sd);
 
-	format->format = vsen->mbus_format;
+	fmt->format = fmt->which == V4L2_SUBDEV_FORMAT_TRY ?
+		      *v4l2_subdev_get_try_format(sd, cfg, fmt->pad) :
+		      vsen->mbus_format;
 
 	return 0;
 }
@@ -105,12 +125,70 @@ static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
 	tpg_s_xfer_func(&vsen->tpg, vsen->mbus_format.xfer_func);
 }
 
+static void vimc_sen_adjust_fmt(struct v4l2_mbus_framefmt *fmt)
+{
+	const struct vimc_pix_map *vpix;
+
+	/* Only accept code in the pix map table */
+	vpix = vimc_pix_map_by_code(fmt->code);
+	if (!vpix)
+		fmt->code = fmt_default.code;
+
+	fmt->width = clamp_t(u32, fmt->width, VIMC_FRAME_MIN_WIDTH,
+			     VIMC_FRAME_MAX_WIDTH) & ~1;
+	fmt->height = clamp_t(u32, fmt->height, VIMC_FRAME_MIN_HEIGHT,
+			      VIMC_FRAME_MAX_HEIGHT) & ~1;
+
+	/* TODO: add support for V4L2_FIELD_ALTERNATE */
+	if (fmt->field == V4L2_FIELD_ANY || fmt->field == V4L2_FIELD_ALTERNATE)
+		fmt->field = fmt_default.field;
+
+	vimc_colorimetry_clamp(fmt);
+}
+
+static int vimc_sen_set_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *fmt)
+{
+	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		/* Do not change the format while stream is on */
+		if (vsen->frame)
+			return -EBUSY;
+
+		mf = &vsen->mbus_format;
+	} else {
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+	}
+
+	/* Set the new format */
+	vimc_sen_adjust_fmt(&fmt->format);
+
+	dev_dbg(vsen->sd.v4l2_dev->mdev->dev, "%s: format update: "
+		"old:%dx%d (0x%x, %d, %d, %d, %d) "
+		"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vsen->sd.name,
+		/* old */
+		mf->width, mf->height, mf->code,
+		mf->colorspace,	mf->quantization,
+		mf->xfer_func, mf->ycbcr_enc,
+		/* new */
+		fmt->format.width, fmt->format.height, fmt->format.code,
+		fmt->format.colorspace, fmt->format.quantization,
+		fmt->format.xfer_func, fmt->format.ycbcr_enc);
+
+	*mf = fmt->format;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
+	.init_cfg		= vimc_sen_init_cfg,
 	.enum_mbus_code		= vimc_sen_enum_mbus_code,
 	.enum_frame_size	= vimc_sen_enum_frame_size,
 	.get_fmt		= vimc_sen_get_fmt,
-	/* TODO: Add support to other formats */
-	.set_fmt		= vimc_sen_get_fmt,
+	.set_fmt		= vimc_sen_set_fmt,
 };
 
 static int vimc_sen_tpg_thread(void *data)
@@ -247,19 +325,13 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
 	if (ret)
 		goto err_free_vsen;
 
-	/* Set the active frame format (this is hardcoded for now) */
-	vsen->mbus_format.width = 640;
-	vsen->mbus_format.height = 480;
-	vsen->mbus_format.code = MEDIA_BUS_FMT_RGB888_1X24;
-	vsen->mbus_format.field = V4L2_FIELD_NONE;
-	vsen->mbus_format.colorspace = V4L2_COLORSPACE_SRGB;
-	vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
-	vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
+	/* Initialize the frame format */
+	vsen->mbus_format = fmt_default;
 
 	/* Initialize the test pattern generator */
 	tpg_init(&vsen->tpg, vsen->mbus_format.width,
 		 vsen->mbus_format.height);
-	ret = tpg_alloc(&vsen->tpg, VIMC_SEN_FRAME_MAX_WIDTH);
+	ret = tpg_alloc(&vsen->tpg, VIMC_FRAME_MAX_WIDTH);
 	if (ret)
 		goto err_unregister_ent_sd;
 
-- 
2.7.4
