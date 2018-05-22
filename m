Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35549 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbeEVQ32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 12:29:28 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Rui Miguel Silva <rui.silva@linaro.org>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] media: video-mux: fix compliance failures
Date: Tue, 22 May 2018 18:29:25 +0200
Message-Id: <20180522162925.16854-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Limit frame sizes to the [1, UINT_MAX-1] interval, media bus formats to
the available list of formats, and initialize pad and try formats.

Reported-by: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/video-mux.c | 110 +++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index 1fb887293337..ade1dae706aa 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -180,6 +180,87 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 	if (!source_mbusformat)
 		return -EINVAL;
 
+	/* No size limitations except V4L2 compliance requirements */
+	v4l_bound_align_image(&sdformat->format.width, 1, UINT_MAX - 1, 0,
+			      &sdformat->format.height, 1, UINT_MAX - 1, 0, 0);
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
+	}
+	if (sdformat->format.field == V4L2_FIELD_ANY)
+		sdformat->format.field = V4L2_FIELD_NONE;
+
 	mutex_lock(&vmux->lock);
 
 	/* Source pad mirrors active sink pad, no limitations on sink pads */
@@ -197,11 +278,33 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int video_mux_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	struct v4l2_mbus_framefmt *mbusformat;
+	int i;
+
+	mutex_lock(&vmux->lock);
+
+	for (i = 0; i < sd->entity.num_pads; i++) {
+		mbusformat = v4l2_subdev_get_try_format(sd, fh->pad, i);
+		*mbusformat = vmux->format_mbus[i];
+	}
+
+	mutex_unlock(&vmux->lock);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops video_mux_pad_ops = {
 	.get_fmt = video_mux_get_format,
 	.set_fmt = video_mux_set_format,
 };
 
+static const struct v4l2_subdev_internal_ops video_mux_internal_ops = {
+	.open = video_mux_open,
+};
+
 static const struct v4l2_subdev_ops video_mux_subdev_ops = {
 	.pad = &video_mux_pad_ops,
 	.video = &video_mux_subdev_video_ops,
@@ -226,6 +329,7 @@ static int video_mux_probe(struct platform_device *pdev)
 	v4l2_subdev_init(&vmux->subdev, &video_mux_subdev_ops);
 	snprintf(vmux->subdev.name, sizeof(vmux->subdev.name), "%s", np->name);
 	vmux->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	vmux->subdev.internal_ops = &video_mux_internal_ops;
 	vmux->subdev.dev = dev;
 
 	/*
@@ -263,6 +367,12 @@ static int video_mux_probe(struct platform_device *pdev)
 	for (i = 0; i < num_pads - 1; i++)
 		vmux->pads[i].flags = MEDIA_PAD_FL_SINK;
 	vmux->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
+	for (i = 0; i < num_pads; i++) {
+		vmux->format_mbus[i].width = 1;
+		vmux->format_mbus[i].height = 1;
+		vmux->format_mbus[i].code = MEDIA_BUS_FMT_Y8_1X8;
+		vmux->format_mbus[i].field = V4L2_FIELD_NONE;
+	}
 
 	vmux->subdev.entity.function = MEDIA_ENT_F_VID_MUX;
 	ret = media_entity_pads_init(&vmux->subdev.entity, num_pads,
-- 
2.17.0
