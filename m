Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46482 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753795AbeDVWe0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 18:34:26 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 3/8] v4l: vsp1: Reset the crop and compose rectangles in the set_fmt helper
Date: Mon, 23 Apr 2018 01:34:25 +0300
Message-Id: <20180422223430.16407-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To make vsp1_subdev_set_pad_format() usable by entities that support
selection rectangles, we need to reset the crop and compose rectangles
when setting the format on the sink pad. Do so and replace the custom
set_fmt implementation of the histogram code by a call to
vsp1_subdev_set_pad_format().

Resetting the crop and compose rectangles for entities that don't
support crop and compose has no adverse effect as the rectangles are
ignored anyway.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 16 +++++++++
 drivers/media/platform/vsp1/vsp1_histo.c  | 59 +++----------------------------
 2 files changed, 20 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 239df047efd0..181a583aecad 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -335,6 +335,7 @@ int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
 	struct vsp1_entity *entity = to_vsp1_entity(subdev);
 	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *selection;
 	unsigned int i;
 	int ret = 0;
 
@@ -377,6 +378,21 @@ int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
 	format = vsp1_entity_get_pad_format(entity, config, 1);
 	*format = fmt->format;
 
+	/* Reset the crop and compose rectangles */
+	selection = vsp1_entity_get_pad_selection(entity, config, fmt->pad,
+						  V4L2_SEL_TGT_CROP);
+	selection->left = 0;
+	selection->top = 0;
+	selection->width = format->width;
+	selection->height = format->height;
+
+	selection = vsp1_entity_get_pad_selection(entity, config, fmt->pad,
+						  V4L2_SEL_TGT_COMPOSE);
+	selection->left = 0;
+	selection->top = 0;
+	selection->width = format->width;
+	selection->height = format->height;
+
 done:
 	mutex_unlock(&entity->lock);
 	return ret;
diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
index 029181c1fb61..5e15c8ff88d9 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.c
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -389,65 +389,14 @@ static int histo_set_format(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_histogram *histo = subdev_to_histo(subdev);
-	struct v4l2_subdev_pad_config *config;
-	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *selection;
-	unsigned int i;
-	int ret = 0;
 
 	if (fmt->pad != HISTO_PAD_SINK)
 		return histo_get_format(subdev, cfg, fmt);
 
-	mutex_lock(&histo->entity.lock);
-
-	config = vsp1_entity_get_pad_config(&histo->entity, cfg, fmt->which);
-	if (!config) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	/*
-	 * Default to the first format if the requested format is not
-	 * supported.
-	 */
-	for (i = 0; i < histo->num_formats; ++i) {
-		if (fmt->format.code == histo->formats[i])
-			break;
-	}
-	if (i == histo->num_formats)
-		fmt->format.code = histo->formats[0];
-
-	format = vsp1_entity_get_pad_format(&histo->entity, config, fmt->pad);
-
-	format->code = fmt->format.code;
-	format->width = clamp_t(unsigned int, fmt->format.width,
-				HISTO_MIN_SIZE, HISTO_MAX_SIZE);
-	format->height = clamp_t(unsigned int, fmt->format.height,
-				 HISTO_MIN_SIZE, HISTO_MAX_SIZE);
-	format->field = V4L2_FIELD_NONE;
-	format->colorspace = V4L2_COLORSPACE_SRGB;
-
-	fmt->format = *format;
-
-	/* Reset the crop and compose rectangles */
-	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
-						  fmt->pad, V4L2_SEL_TGT_CROP);
-	selection->left = 0;
-	selection->top = 0;
-	selection->width = format->width;
-	selection->height = format->height;
-
-	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
-						  fmt->pad,
-						  V4L2_SEL_TGT_COMPOSE);
-	selection->left = 0;
-	selection->top = 0;
-	selection->width = format->width;
-	selection->height = format->height;
-
-done:
-	mutex_unlock(&histo->entity.lock);
-	return ret;
+	return vsp1_subdev_set_pad_format(subdev, cfg, fmt,
+					  histo->formats, histo->num_formats,
+					  HISTO_MIN_SIZE, HISTO_MIN_SIZE,
+					  HISTO_MAX_SIZE, HISTO_MAX_SIZE);
 }
 
 static const struct v4l2_subdev_pad_ops histo_pad_ops = {
-- 
Regards,

Laurent Pinchart
