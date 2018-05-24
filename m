Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44013 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965555AbeEXOvE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 10:51:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Rui Miguel Silva <rui.silva@linaro.org>, kernel@pengutronix.de,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3] media: video-mux: fix compliance failures
Date: Thu, 24 May 2018 16:50:44 +0200
Message-Id: <20180524145044.15975-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Limit frame sizes to the [1, 65536] interval, media bus formats to
the available list of formats, and initialize pad and try formats.

Reported-by: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Rui Miguel Silva <rui.silva@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v2:
 - Make loop variables unsigned
 - Initialize try formats to default format, not currently configured format
---
 drivers/media/platform/video-mux.c | 119 ++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index 1fb887293337..c01e1592ad0a 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -34,6 +34,13 @@ struct video_mux {
 	int active;
 };
 
+static const struct v4l2_mbus_framefmt video_mux_format_mbus_default = {
+	.width = 1,
+	.height = 1,
+	.code = MEDIA_BUS_FMT_Y8_1X8,
+	.field = V4L2_FIELD_NONE,
+};
+
 static inline struct video_mux *v4l2_subdev_to_video_mux(struct v4l2_subdev *sd)
 {
 	return container_of(sd, struct video_mux, subdev);
@@ -180,6 +187,88 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 	if (!source_mbusformat)
 		return -EINVAL;
 
+	/* No size limitations except V4L2 compliance requirements */
+	v4l_bound_align_image(&sdformat->format.width, 1, 65536, 0,
+			      &sdformat->format.height, 1, 65536, 0, 0);
+
+	/* All formats except LVDS and vendor specific formats are acceptable */
+	switch (sdformat->format.code) {
+	case MEDIA_BUS_FMT_RGB444_1X12:
+	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB565_1X16:
+	case MEDIA_BUS_FMT_BGR565_2X8_BE:
+	case MEDIA_BUS_FMT_BGR565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB666_1X18:
+	case MEDIA_BUS_FMT_RBG888_1X24:
+	case MEDIA_BUS_FMT_RGB666_1X24_CPADHI:
+	case MEDIA_BUS_FMT_BGR888_1X24:
+	case MEDIA_BUS_FMT_GBR888_1X24:
+	case MEDIA_BUS_FMT_RGB888_1X24:
+	case MEDIA_BUS_FMT_RGB888_2X12_BE:
+	case MEDIA_BUS_FMT_RGB888_2X12_LE:
+	case MEDIA_BUS_FMT_ARGB8888_1X32:
+	case MEDIA_BUS_FMT_RGB888_1X32_PADHI:
+	case MEDIA_BUS_FMT_RGB101010_1X30:
+	case MEDIA_BUS_FMT_RGB121212_1X36:
+	case MEDIA_BUS_FMT_RGB161616_1X48:
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_UV8_1X8:
+	case MEDIA_BUS_FMT_UYVY8_1_5X8:
+	case MEDIA_BUS_FMT_VYUY8_1_5X8:
+	case MEDIA_BUS_FMT_YUYV8_1_5X8:
+	case MEDIA_BUS_FMT_YVYU8_1_5X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_Y10_1X10:
+	case MEDIA_BUS_FMT_UYVY10_2X10:
+	case MEDIA_BUS_FMT_VYUY10_2X10:
+	case MEDIA_BUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_YVYU10_2X10:
+	case MEDIA_BUS_FMT_Y12_1X12:
+	case MEDIA_BUS_FMT_UYVY12_2X12:
+	case MEDIA_BUS_FMT_VYUY12_2X12:
+	case MEDIA_BUS_FMT_YUYV12_2X12:
+	case MEDIA_BUS_FMT_YVYU12_2X12:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_VYUY8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YVYU8_1X16:
+	case MEDIA_BUS_FMT_YDYUYDYV8_1X16:
+	case MEDIA_BUS_FMT_UYVY10_1X20:
+	case MEDIA_BUS_FMT_VYUY10_1X20:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_YVYU10_1X20:
+	case MEDIA_BUS_FMT_VUY8_1X24:
+	case MEDIA_BUS_FMT_YUV8_1X24:
+	case MEDIA_BUS_FMT_UYYVYY8_0_5X24:
+	case MEDIA_BUS_FMT_UYVY12_1X24:
+	case MEDIA_BUS_FMT_VYUY12_1X24:
+	case MEDIA_BUS_FMT_YUYV12_1X24:
+	case MEDIA_BUS_FMT_YVYU12_1X24:
+	case MEDIA_BUS_FMT_YUV10_1X30:
+	case MEDIA_BUS_FMT_UYYVYY10_0_5X30:
+	case MEDIA_BUS_FMT_AYUV8_1X32:
+	case MEDIA_BUS_FMT_UYYVYY12_0_5X36:
+	case MEDIA_BUS_FMT_YUV12_1X36:
+	case MEDIA_BUS_FMT_YUV16_1X48:
+	case MEDIA_BUS_FMT_UYYVYY16_0_5X48:
+	case MEDIA_BUS_FMT_JPEG_1X8:
+	case MEDIA_BUS_FMT_AHSV8888_1X32:
+		break;
+	default:
+		sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;
+		break;
+	}
+	if (sdformat->format.field == V4L2_FIELD_ANY)
+		sdformat->format.field = V4L2_FIELD_NONE;
+
 	mutex_lock(&vmux->lock);
 
 	/* Source pad mirrors active sink pad, no limitations on sink pads */
@@ -197,7 +286,27 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int video_mux_init_cfg(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg)
+{
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	struct v4l2_mbus_framefmt *mbusformat;
+	unsigned int i;
+
+	mutex_lock(&vmux->lock);
+
+	for (i = 0; i < sd->entity.num_pads; i++) {
+		mbusformat = v4l2_subdev_get_try_format(sd, cfg, i);
+		*mbusformat = video_mux_format_mbus_default;
+	}
+
+	mutex_unlock(&vmux->lock);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops video_mux_pad_ops = {
+	.init_cfg = video_mux_init_cfg,
 	.get_fmt = video_mux_get_format,
 	.set_fmt = video_mux_set_format,
 };
@@ -214,8 +323,8 @@ static int video_mux_probe(struct platform_device *pdev)
 	struct device_node *ep;
 	struct video_mux *vmux;
 	unsigned int num_pads = 0;
+	unsigned int i;
 	int ret;
-	int i;
 
 	vmux = devm_kzalloc(dev, sizeof(*vmux), GFP_KERNEL);
 	if (!vmux)
@@ -260,9 +369,11 @@ static int video_mux_probe(struct platform_device *pdev)
 					 sizeof(*vmux->format_mbus),
 					 GFP_KERNEL);
 
-	for (i = 0; i < num_pads - 1; i++)
-		vmux->pads[i].flags = MEDIA_PAD_FL_SINK;
-	vmux->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
+	for (i = 0; i < num_pads; i++) {
+		vmux->pads[i].flags = (i < num_pads - 1) ? MEDIA_PAD_FL_SINK
+							 : MEDIA_PAD_FL_SOURCE;
+		vmux->format_mbus[i] = video_mux_format_mbus_default;
+	}
 
 	vmux->subdev.entity.function = MEDIA_ENT_F_VID_MUX;
 	ret = media_entity_pads_init(&vmux->subdev.entity, num_pads,
-- 
2.17.0
