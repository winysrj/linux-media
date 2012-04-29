Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44755 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2D2QX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 12:23:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/3] omap3isp: preview: Replace the crop API by the selection API
Date: Sun, 29 Apr 2012 18:23:44 +0200
Message-Id: <1335716625-2388-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335716625-2388-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335716625-2388-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for the legacy crop API is emulated in the subdev core.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |   74 +++++++++++++++++++++--------
 1 files changed, 54 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 420b131..cbc8870 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1929,55 +1929,89 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
 }
 
 /*
- * preview_get_crop - Retrieve the crop rectangle on a pad
+ * preview_get_selection - Retrieve a selection rectangle on a pad
  * @sd: ISP preview V4L2 subdevice
  * @fh: V4L2 subdev file handle
- * @crop: crop rectangle
+ * @sel: Selection rectangle
+ *
+ * The only supported rectangles are the crop rectangles on the sink pad.
  *
  * Return 0 on success or a negative error code otherwise.
  */
-static int preview_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int preview_get_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	if (sel->pad != PREV_PAD_SINK)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = INT_MAX;
+		sel->r.height = INT_MAX;
+
+		format = __preview_get_format(prev, fh, PREV_PAD_SINK,
+					      sel->which);
+		preview_try_crop(prev, format, &sel->r);
+		break;
+
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+		sel->r = *__preview_get_crop(prev, fh, sel->which);
+		break;
 
-	/* Cropping is only supported on the sink pad. */
-	if (crop->pad != PREV_PAD_SINK)
+	default:
 		return -EINVAL;
+	}
 
-	crop->rect = *__preview_get_crop(prev, fh, crop->which);
 	return 0;
 }
 
 /*
- * preview_set_crop - Retrieve the crop rectangle on a pad
+ * preview_set_selection - Set a selection rectangle on a pad
  * @sd: ISP preview V4L2 subdevice
  * @fh: V4L2 subdev file handle
- * @crop: crop rectangle
+ * @sel: Selection rectangle
+ *
+ * The only supported rectangle is the actual crop rectangle on the sink pad.
  *
  * Return 0 on success or a negative error code otherwise.
  */
-static int preview_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int preview_set_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	/* Cropping is only supported on the sink pad. */
-	if (crop->pad != PREV_PAD_SINK)
+	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL ||
+	    sel->pad != PREV_PAD_SINK)
 		return -EINVAL;
 
 	/* The crop rectangle can't be changed while streaming. */
 	if (prev->state != ISP_PIPELINE_STREAM_STOPPED)
 		return -EBUSY;
 
-	format = __preview_get_format(prev, fh, PREV_PAD_SINK, crop->which);
-	preview_try_crop(prev, format, &crop->rect);
-	*__preview_get_crop(prev, fh, crop->which) = crop->rect;
+	/* Modifying the crop rectangle always changes the format on the source
+	 * pad. If the KEEP_CONFIG flag is set, just return the current crop
+	 * rectangle.
+	 */
+	if (sel->flags & V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG) {
+		sel->r = *__preview_get_crop(prev, fh, sel->which);
+		return 0;
+	}
+
+	format = __preview_get_format(prev, fh, PREV_PAD_SINK, sel->which);
+	preview_try_crop(prev, format, &sel->r);
+	*__preview_get_crop(prev, fh, sel->which) = sel->r;
 
 	/* Update the source format. */
-	format = __preview_get_format(prev, fh, PREV_PAD_SOURCE, crop->which);
-	preview_try_format(prev, fh, PREV_PAD_SOURCE, format, crop->which);
+	format = __preview_get_format(prev, fh, PREV_PAD_SOURCE, sel->which);
+	preview_try_format(prev, fh, PREV_PAD_SOURCE, format, sel->which);
 
 	return 0;
 }
@@ -2086,8 +2120,8 @@ static const struct v4l2_subdev_pad_ops preview_v4l2_pad_ops = {
 	.enum_frame_size = preview_enum_frame_size,
 	.get_fmt = preview_get_format,
 	.set_fmt = preview_set_format,
-	.get_crop = preview_get_crop,
-	.set_crop = preview_set_crop,
+	.get_selection = preview_get_selection,
+	.set_selection = preview_set_selection,
 };
 
 /* subdev operations */
-- 
1.7.3.4

