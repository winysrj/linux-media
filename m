Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49120 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbaGWO5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 10:57:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/3] omap3isp: resizer: Protect against races when updating crop
Date: Wed, 23 Jul 2014 16:57:11 +0200
Message-Id: <1406127431-9503-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When updating the crop rectangle during streaming, the IRQ handler will
reprogram the resizer after the current frame. A race condition
currently exists between the set selection operation and the IRQ
handler: if the set selection operation is called twice in a row and the
IRQ handler runs only during the second call, it could reprogram the
hardware with partially updated values. Use a spinlock to protect
against that.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispresizer.c | 43 ++++++++++++++++++++--------
 drivers/media/platform/omap3isp/ispresizer.h |  3 ++
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index c8676e1..5fcf3cf 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1072,10 +1072,13 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 void omap3isp_resizer_isr(struct isp_res_device *res)
 {
 	struct v4l2_mbus_framefmt *informat, *outformat;
+	unsigned long flags;
 
 	if (omap3isp_module_sync_is_stopping(&res->wait, &res->stopping))
 		return;
 
+	spin_lock_irqsave(&res->lock, flags);
+
 	if (res->applycrop) {
 		outformat = __resizer_get_format(res, NULL, RESZ_PAD_SOURCE,
 					      V4L2_SUBDEV_FORMAT_ACTIVE);
@@ -1085,6 +1088,8 @@ void omap3isp_resizer_isr(struct isp_res_device *res)
 		res->applycrop = 0;
 	}
 
+	spin_unlock_irqrestore(&res->lock, flags);
+
 	resizer_isr_buffer(res);
 }
 
@@ -1287,8 +1292,10 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = to_isp_device(res);
-	struct v4l2_mbus_framefmt *format_sink, *format_source;
+	const struct v4l2_mbus_framefmt *format_sink;
+	struct v4l2_mbus_framefmt format_source;
 	struct resizer_ratio ratio;
+	unsigned long flags;
 
 	if (sel->target != V4L2_SEL_TGT_CROP ||
 	    sel->pad != RESZ_PAD_SINK)
@@ -1296,14 +1303,14 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 
 	format_sink = __resizer_get_format(res, fh, RESZ_PAD_SINK,
 					   sel->which);
-	format_source = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
-					     sel->which);
+	format_source = *__resizer_get_format(res, fh, RESZ_PAD_SOURCE,
+					      sel->which);
 
 	dev_dbg(isp->dev, "%s(%s): req %ux%u -> (%d,%d)/%ux%u -> %ux%u\n",
 		__func__, sel->which == V4L2_SUBDEV_FORMAT_TRY ? "try" : "act",
 		format_sink->width, format_sink->height,
 		sel->r.left, sel->r.top, sel->r.width, sel->r.height,
-		format_source->width, format_source->height);
+		format_source.width, format_source.height);
 
 	/* Clamp the crop rectangle to the bounds, and then mangle it further to
 	 * fulfill the TRM equations. Store the clamped but otherwise unmangled
@@ -1313,29 +1320,39 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	 * smaller input crop rectangle every time the output size is set if we
 	 * stored the mangled rectangle.
 	 */
-	resizer_try_crop(format_sink, format_source, &sel->r);
+	resizer_try_crop(format_sink, &format_source, &sel->r);
 	*__resizer_get_crop(res, fh, sel->which) = sel->r;
-	resizer_calc_ratios(res, &sel->r, format_source, &ratio);
+	resizer_calc_ratios(res, &sel->r, &format_source, &ratio);
 
 	dev_dbg(isp->dev, "%s(%s): got %ux%u -> (%d,%d)/%ux%u -> %ux%u\n",
 		__func__, sel->which == V4L2_SUBDEV_FORMAT_TRY ? "try" : "act",
 		format_sink->width, format_sink->height,
 		sel->r.left, sel->r.top, sel->r.width, sel->r.height,
-		format_source->width, format_source->height);
+		format_source.width, format_source.height);
 
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		*__resizer_get_format(res, fh, RESZ_PAD_SOURCE, sel->which) =
+			format_source;
 		return 0;
+	}
+
+	/* Update the source format, resizing ratios and crop rectangle. If
+	 * streaming is on the IRQ handler will reprogram the resizer after the
+	 * current frame. We thus we need to protect against race conditions.
+	 */
+	spin_lock_irqsave(&res->lock, flags);
+
+	*__resizer_get_format(res, fh, RESZ_PAD_SOURCE, sel->which) =
+		format_source;
 
 	res->ratio = ratio;
 	res->crop.active = sel->r;
 
-	/*
-	 * set_selection can be called while streaming is on. In this case the
-	 * crop values will be set in the next IRQ.
-	 */
 	if (res->state != ISP_PIPELINE_STREAM_STOPPED)
 		res->applycrop = 1;
 
+	spin_unlock_irqrestore(&res->lock, flags);
+
 	return 0;
 }
 
@@ -1782,6 +1799,8 @@ int omap3isp_resizer_init(struct isp_device *isp)
 
 	init_waitqueue_head(&res->wait);
 	atomic_set(&res->stopping, 0);
+	spin_lock_init(&res->lock);
+
 	return resizer_init_entities(res);
 }
 
diff --git a/drivers/media/platform/omap3isp/ispresizer.h b/drivers/media/platform/omap3isp/ispresizer.h
index 9b01e90..e355211 100644
--- a/drivers/media/platform/omap3isp/ispresizer.h
+++ b/drivers/media/platform/omap3isp/ispresizer.h
@@ -27,6 +27,7 @@
 #ifndef OMAP3_ISP_RESIZER_H
 #define OMAP3_ISP_RESIZER_H
 
+#include <linux/spinlock.h>
 #include <linux/types.h>
 
 /*
@@ -96,6 +97,7 @@ enum resizer_input_entity {
 
 /*
  * struct isp_res_device - OMAP3 ISP resizer module
+ * @lock: Protects formats and crop rectangles between set_selection and IRQ
  * @crop.request: Crop rectangle requested by the user
  * @crop.active: Active crop rectangle (based on hardware requirements)
  */
@@ -116,6 +118,7 @@ struct isp_res_device {
 	enum isp_pipeline_stream_state state;
 	wait_queue_head_t wait;
 	atomic_t stopping;
+	spinlock_t lock;
 
 	struct {
 		struct v4l2_rect request;
-- 
1.8.5.5

