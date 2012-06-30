Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:51622 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab2F3RFj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 13:05:39 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH 3/8] v4l: Unify selection targets across V4L2 and V4L2 subdev interfaces
Date: Sat, 30 Jun 2012 20:03:54 +0300
Message-Id: <1341075839-18586-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/omap3isp/ispccdc.c      |    6 +-
 drivers/media/video/omap3isp/isppreview.c   |    6 +-
 drivers/media/video/omap3isp/ispresizer.c   |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |   18 ++++----
 drivers/media/video/s5p-fimc/fimc-lite.c    |   11 ++---
 drivers/media/video/smiapp/smiapp-core.c    |   30 +++++++-------
 drivers/media/video/v4l2-subdev.c           |    4 +-
 include/linux/v4l2-common.h                 |   57 +++++++++++++++++++++++++++
 include/linux/v4l2-subdev.h                 |   19 +-------
 include/linux/videodev2.h                   |   25 +----------
 10 files changed, 103 insertions(+), 79 deletions(-)
 create mode 100644 include/linux/v4l2-common.h

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index f19774f..82df7a0 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -2014,7 +2014,7 @@ static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		return -EINVAL;
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		sel->r.left = 0;
 		sel->r.top = 0;
 		sel->r.width = INT_MAX;
@@ -2024,7 +2024,7 @@ static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		ccdc_try_crop(ccdc, format, &sel->r);
 		break;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP:
 		sel->r = *__ccdc_get_crop(ccdc, fh, sel->which);
 		break;
 
@@ -2052,7 +2052,7 @@ static int ccdc_set_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP ||
+	if (sel->target != V4L2_SEL_TGT_CROP ||
 	    sel->pad != CCDC_PAD_SOURCE_OF)
 		return -EINVAL;
 
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 1086f6a..6fa70f4 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1949,7 +1949,7 @@ static int preview_get_selection(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		sel->r.left = 0;
 		sel->r.top = 0;
 		sel->r.width = INT_MAX;
@@ -1960,7 +1960,7 @@ static int preview_get_selection(struct v4l2_subdev *sd,
 		preview_try_crop(prev, format, &sel->r);
 		break;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP:
 		sel->r = *__preview_get_crop(prev, fh, sel->which);
 		break;
 
@@ -1988,7 +1988,7 @@ static int preview_set_selection(struct v4l2_subdev *sd,
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP ||
+	if (sel->target != V4L2_SEL_TGT_CROP ||
 	    sel->pad != PREV_PAD_SINK)
 		return -EINVAL;
 
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 9456652..ae17d91 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1249,7 +1249,7 @@ static int resizer_get_selection(struct v4l2_subdev *sd,
 					     sel->which);
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		sel->r.left = 0;
 		sel->r.top = 0;
 		sel->r.width = INT_MAX;
@@ -1259,7 +1259,7 @@ static int resizer_get_selection(struct v4l2_subdev *sd,
 		resizer_calc_ratios(res, &sel->r, format_source, &ratio);
 		break;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP:
 		sel->r = *__resizer_get_crop(res, fh, sel->which);
 		resizer_calc_ratios(res, &sel->r, format_source, &ratio);
 		break;
@@ -1293,7 +1293,7 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *format_sink, *format_source;
 	struct resizer_ratio ratio;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP ||
+	if (sel->target != V4L2_SEL_TGT_CROP ||
 	    sel->pad != RESZ_PAD_SINK)
 		return -EINVAL;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index a3cd78d..521e371 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1429,9 +1429,9 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 	mutex_lock(&fimc->lock);
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		f = &ctx->d_frame;
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		r->width = f->o_width;
 		r->height = f->o_height;
 		r->left = 0;
@@ -1439,10 +1439,10 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 		mutex_unlock(&fimc->lock);
 		return 0;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SEL_TGT_CROP:
 		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SEL_TGT_COMPOSE:
 		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
 		f = &ctx->d_frame;
 		break;
@@ -1486,9 +1486,9 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 	fimc_capture_try_selection(ctx, r, V4L2_SEL_TGT_CROP);
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		f = &ctx->d_frame;
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		r->width = f->o_width;
 		r->height = f->o_height;
 		r->left = 0;
@@ -1496,10 +1496,10 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 		mutex_unlock(&fimc->lock);
 		return 0;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SEL_TGT_CROP:
 		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SEL_TGT_COMPOSE:
 		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
 		f = &ctx->d_frame;
 		break;
@@ -1515,7 +1515,7 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 		set_frame_crop(f, r->left, r->top, r->width, r->height);
 		set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 		spin_unlock_irqrestore(&fimc->slock, flags);
-		if (sel->target == V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL)
+		if (sel->target == V4L2_SEL_TGT_COMPOSE)
 			ctx->state |= FIMC_COMPOSE;
 	}
 
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 52ede56..8785089 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -1086,9 +1086,9 @@ static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	struct flite_frame *f = &fimc->inp_frame;
 
-	if ((sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL &&
-	     sel->target != V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS) ||
-	    sel->pad != FLITE_SD_PAD_SINK)
+	if ((sel->target != V4L2_SEL_TGT_CROP &&
+	     sel->target != V4L2_SEL_TGT_CROP_BOUNDS) ||
+	     sel->pad != FLITE_SD_PAD_SINK)
 		return -EINVAL;
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
@@ -1097,7 +1097,7 @@ static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
 	}
 
 	mutex_lock(&fimc->lock);
-	if (sel->target == V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL) {
+	if (sel->target == V4L2_SEL_TGT_CROP) {
 		sel->r = f->rect;
 	} else {
 		sel->r.left = 0;
@@ -1122,8 +1122,7 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 	struct flite_frame *f = &fimc->inp_frame;
 	int ret = 0;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL ||
-	    sel->pad != FLITE_SD_PAD_SINK)
+	if (sel->target != V4L2_SEL_TGT_CROP || sel->pad != FLITE_SD_PAD_SINK)
 		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index 37622bb6..9bbb5d3 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -1630,7 +1630,7 @@ static void smiapp_propagate(struct v4l2_subdev *subdev,
 	smiapp_get_crop_compose(subdev, fh, crops, &comp, which);
 
 	switch (target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP:
 		comp->width = crops[SMIAPP_PAD_SINK]->width;
 		comp->height = crops[SMIAPP_PAD_SINK]->height;
 		if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
@@ -1646,7 +1646,7 @@ static void smiapp_propagate(struct v4l2_subdev *subdev,
 			}
 		}
 		/* Fall through */
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE:
 		*crops[SMIAPP_PAD_SRC] = *comp;
 		break;
 	default:
@@ -1722,7 +1722,7 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		ssd->sink_fmt = *crops[ssd->sink_pad];
 	smiapp_propagate(subdev, fh, fmt->which,
-			 V4L2_SUBDEV_SEL_TGT_CROP);
+			 V4L2_SEL_TGT_CROP);
 
 	mutex_unlock(&sensor->mutex);
 
@@ -1957,7 +1957,7 @@ static int smiapp_set_compose(struct v4l2_subdev *subdev,
 
 	*comp = sel->r;
 	smiapp_propagate(subdev, fh, sel->which,
-			 V4L2_SUBDEV_SEL_TGT_COMPOSE);
+			 V4L2_SEL_TGT_COMPOSE);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return smiapp_update_mode(sensor);
@@ -1973,8 +1973,8 @@ static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
 
 	/* We only implement crop in three places. */
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP:
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		if (ssd == sensor->pixel_array
 		    && sel->pad == SMIAPP_PA_PAD_SRC)
 			return 0;
@@ -1987,8 +1987,8 @@ static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
 		    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP)
 			return 0;
 		return -EINVAL;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		if (sel->pad == ssd->source_pad)
 			return -EINVAL;
 		if (ssd == sensor->binner)
@@ -2050,7 +2050,7 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 
 	if (ssd != sensor->pixel_array && sel->pad == SMIAPP_PAD_SINK)
 		smiapp_propagate(subdev, fh, sel->which,
-				 V4L2_SUBDEV_SEL_TGT_CROP);
+				 V4L2_SEL_TGT_CROP);
 
 	return 0;
 }
@@ -2084,7 +2084,7 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 	}
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		if (ssd == sensor->pixel_array) {
 			sel->r.width =
 				sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
@@ -2096,11 +2096,11 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 			sel->r = *comp;
 		}
 		break;
-	case V4L2_SUBDEV_SEL_TGT_CROP:
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		sel->r = *crops[sel->pad];
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE:
 		sel->r = *comp;
 		break;
 	}
@@ -2147,10 +2147,10 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
 			      sel->r.height);
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP:
 		ret = smiapp_set_crop(subdev, fh, sel);
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE:
 		ret = smiapp_set_compose(subdev, fh, sel);
 		break;
 	default:
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index cd86f0c..9182f81 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -245,7 +245,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
-		sel.target = V4L2_SUBDEV_SEL_TGT_CROP;
+		sel.target = V4L2_SEL_TGT_CROP;
 
 		rval = v4l2_subdev_call(
 			sd, pad, get_selection, subdev_fh, &sel);
@@ -274,7 +274,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
-		sel.target = V4L2_SUBDEV_SEL_TGT_CROP;
+		sel.target = V4L2_SEL_TGT_CROP;
 		sel.r = crop->rect;
 
 		rval = v4l2_subdev_call(
diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
new file mode 100644
index 0000000..b49a37a
--- /dev/null
+++ b/include/linux/v4l2-common.h
@@ -0,0 +1,57 @@
+/*
+ * include/linux/v4l2-common.h
+ *
+ * Common V4L2 and V4L2 subdev definitions.
+ *
+ * Users are advised to #include this file either through videodev2.h
+ * (V4L2) or through v4l2-subdev.h (V4L2 subdev) rather than to refer
+ * to this file directly.
+ *
+ * Copyright (C) 2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __V4L2_COMMON__
+#define __V4L2_COMMON__
+
+/* Selection target definitions */
+
+/* Current cropping area */
+#define V4L2_SEL_TGT_CROP		0x0000
+/* Default cropping area */
+#define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
+/* Cropping bounds */
+#define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
+/* Current composing area */
+#define V4L2_SEL_TGT_COMPOSE		0x0100
+/* Default composing area */
+#define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
+/* Composing bounds */
+#define V4L2_SEL_TGT_COMPOSE_BOUNDS	0x0102
+/* Current composing area plus all padding pixels */
+#define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
+
+/* Backward compatibility definitions */
+#define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
+#define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
+#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL \
+	V4L2_SUBDEV_SEL_TGT_CROP
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL \
+	V4L2_SUBDEV_SEL_TGT_COMPOSE
+
+#endif /* __V4L2_COMMON__  */
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index 3cbe688..1d7d457 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -25,6 +25,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#include <linux/v4l2-common.h>
 #include <linux/v4l2-mediabus.h>
 
 /**
@@ -127,27 +128,13 @@ struct v4l2_subdev_frame_interval_enum {
 #define V4L2_SUBDEV_SEL_FLAG_SIZE_LE			(1 << 1)
 #define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1 << 2)
 
-/* active cropping area */
-#define V4L2_SUBDEV_SEL_TGT_CROP			0x0000
-/* cropping bounds */
-#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
-/* current composing area */
-#define V4L2_SUBDEV_SEL_TGT_COMPOSE			0x0100
-/* composing bounds */
-#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0102
-
-/* backward compatibility definitions */
-#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL \
-	V4L2_SUBDEV_SEL_TGT_CROP
-#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL \
-	V4L2_SUBDEV_SEL_TGT_COMPOSE
-
 /**
  * struct v4l2_subdev_selection - selection info
  *
  * @which: either V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY
  * @pad: pad number, as reported by the media API
- * @target: selection target, used to choose one of possible rectangles
+ * @target: Selection target, used to choose one of possible rectangles,
+ *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags: constraint flags
  * @r: coordinates of the selection window
  * @reserved: for future use, set to zero for now
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 0425c12..ce86855 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -64,6 +64,7 @@
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#include <linux/v4l2-common.h>
 
 /*
  * Common stuff for both V4L1 and V4L2
@@ -765,31 +766,11 @@ struct v4l2_crop {
 #define V4L2_SEL_FLAG_GE	0x00000001
 #define V4L2_SEL_FLAG_LE	0x00000002
 
-/* Selection targets */
-
-/* Current cropping area */
-#define V4L2_SEL_TGT_CROP		0x0000
-/* Default cropping area */
-#define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
-/* Cropping bounds */
-#define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
-/* Current composing area */
-#define V4L2_SEL_TGT_COMPOSE		0x0100
-/* Default composing area */
-#define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
-/* Composing bounds */
-#define V4L2_SEL_TGT_COMPOSE_BOUNDS	0x0102
-/* Current composing area plus all padding pixels */
-#define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
-
-/* Backward compatibility definitions */
-#define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
-#define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
-
 /**
  * struct v4l2_selection - selection info
  * @type:	buffer type (do not use *_MPLANE types)
- * @target:	selection target, used to choose one of possible rectangles
+ * @target:	Selection target, used to choose one of possible rectangles;
+ *		defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags:	constraints flags
  * @r:		coordinates of selection window
  * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
-- 
1.7.2.5

