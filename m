Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60235 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbcDCTm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 15:42:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund+renesas@ragnatech.se,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] vivid: use new v4l2-rect.h header
Date: Sun,  3 Apr 2016 12:42:43 -0700
Message-Id: <1459712563-8796-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1459712563-8796-1-git-send-email-hverkuil@xs4all.nl>
References: <1459712563-8796-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_rect helper functions have been moved to include/media/v4l2-rect.h.
Use this new header, dropping the functions from vivid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c |  13 +--
 drivers/media/platform/vivid/vivid-vid-cap.c     | 101 +++++++++++-----------
 drivers/media/platform/vivid/vivid-vid-common.c  |  97 ---------------------
 drivers/media/platform/vivid/vivid-vid-common.h  |   9 --
 drivers/media/platform/vivid/vivid-vid-out.c     | 103 ++++++++++++-----------
 5 files changed, 110 insertions(+), 213 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 9034281..c004ef4 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-rect.h>
 
 #include "vivid-core.h"
 #include "vivid-vid-common.h"
@@ -184,15 +185,15 @@ static void vivid_precalc_copy_rects(struct vivid_dev *dev)
 		dev->compose_out.width, dev->compose_out.height
 	};
 
-	dev->loop_vid_copy = rect_intersect(&dev->crop_cap, &dev->compose_out);
+	dev->loop_vid_copy = v4l2_rect_intersect(&dev->crop_cap, &dev->compose_out);
 
 	dev->loop_vid_out = dev->loop_vid_copy;
-	rect_scale(&dev->loop_vid_out, &dev->compose_out, &dev->crop_out);
+	v4l2_rect_scale(&dev->loop_vid_out, &dev->compose_out, &dev->crop_out);
 	dev->loop_vid_out.left += dev->crop_out.left;
 	dev->loop_vid_out.top += dev->crop_out.top;
 
 	dev->loop_vid_cap = dev->loop_vid_copy;
-	rect_scale(&dev->loop_vid_cap, &dev->crop_cap, &dev->compose_cap);
+	v4l2_rect_scale(&dev->loop_vid_cap, &dev->crop_cap, &dev->compose_cap);
 
 	dprintk(dev, 1,
 		"loop_vid_copy: %dx%d@%dx%d loop_vid_out: %dx%d@%dx%d loop_vid_cap: %dx%d@%dx%d\n",
@@ -203,13 +204,13 @@ static void vivid_precalc_copy_rects(struct vivid_dev *dev)
 		dev->loop_vid_cap.width, dev->loop_vid_cap.height,
 		dev->loop_vid_cap.left, dev->loop_vid_cap.top);
 
-	r_overlay = rect_intersect(&r_fb, &r_overlay);
+	r_overlay = v4l2_rect_intersect(&r_fb, &r_overlay);
 
 	/* shift r_overlay to the same origin as compose_out */
 	r_overlay.left += dev->compose_out.left - dev->overlay_out_left;
 	r_overlay.top += dev->compose_out.top - dev->overlay_out_top;
 
-	dev->loop_vid_overlay = rect_intersect(&r_overlay, &dev->loop_vid_copy);
+	dev->loop_vid_overlay = v4l2_rect_intersect(&r_overlay, &dev->loop_vid_copy);
 	dev->loop_fb_copy = dev->loop_vid_overlay;
 
 	/* shift dev->loop_fb_copy back again to the fb origin */
@@ -217,7 +218,7 @@ static void vivid_precalc_copy_rects(struct vivid_dev *dev)
 	dev->loop_fb_copy.top -= dev->compose_out.top - dev->overlay_out_top;
 
 	dev->loop_vid_overlay_cap = dev->loop_vid_overlay;
-	rect_scale(&dev->loop_vid_overlay_cap, &dev->crop_cap, &dev->compose_cap);
+	v4l2_rect_scale(&dev->loop_vid_overlay_cap, &dev->crop_cap, &dev->compose_cap);
 
 	dprintk(dev, 1,
 		"loop_fb_copy: %dx%d@%dx%d loop_vid_overlay: %dx%d@%dx%d loop_vid_overlay_cap: %dx%d@%dx%d\n",
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index b84f081..4f730f3 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-dv-timings.h>
+#include <media/v4l2-rect.h>
 
 #include "vivid-core.h"
 #include "vivid-vid-common.h"
@@ -590,16 +591,16 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 	} else {
 		struct v4l2_rect r = { 0, 0, mp->width, mp->height * factor };
 
-		rect_set_min_size(&r, &vivid_min_rect);
-		rect_set_max_size(&r, &vivid_max_rect);
+		v4l2_rect_set_min_size(&r, &vivid_min_rect);
+		v4l2_rect_set_max_size(&r, &vivid_max_rect);
 		if (dev->has_scaler_cap && !dev->has_compose_cap) {
 			struct v4l2_rect max_r = { 0, 0, MAX_ZOOM * w, MAX_ZOOM * h };
 
-			rect_set_max_size(&r, &max_r);
+			v4l2_rect_set_max_size(&r, &max_r);
 		} else if (!dev->has_scaler_cap && dev->has_crop_cap && !dev->has_compose_cap) {
-			rect_set_max_size(&r, &dev->src_rect);
+			v4l2_rect_set_max_size(&r, &dev->src_rect);
 		} else if (!dev->has_scaler_cap && !dev->has_crop_cap) {
-			rect_set_min_size(&r, &dev->src_rect);
+			v4l2_rect_set_min_size(&r, &dev->src_rect);
 		}
 		mp->width = r.width;
 		mp->height = r.height / factor;
@@ -668,7 +669,7 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
 
 		if (dev->has_scaler_cap) {
 			if (dev->has_compose_cap)
-				rect_map_inside(compose, &r);
+				v4l2_rect_map_inside(compose, &r);
 			else
 				*compose = r;
 			if (dev->has_crop_cap && !dev->has_compose_cap) {
@@ -683,9 +684,9 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
 					factor * r.height * MAX_ZOOM
 				};
 
-				rect_set_min_size(crop, &min_r);
-				rect_set_max_size(crop, &max_r);
-				rect_map_inside(crop, &dev->crop_bounds_cap);
+				v4l2_rect_set_min_size(crop, &min_r);
+				v4l2_rect_set_max_size(crop, &max_r);
+				v4l2_rect_map_inside(crop, &dev->crop_bounds_cap);
 			} else if (dev->has_crop_cap) {
 				struct v4l2_rect min_r = {
 					0, 0,
@@ -698,27 +699,27 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
 					factor * compose->height * MAX_ZOOM
 				};
 
-				rect_set_min_size(crop, &min_r);
-				rect_set_max_size(crop, &max_r);
-				rect_map_inside(crop, &dev->crop_bounds_cap);
+				v4l2_rect_set_min_size(crop, &min_r);
+				v4l2_rect_set_max_size(crop, &max_r);
+				v4l2_rect_map_inside(crop, &dev->crop_bounds_cap);
 			}
 		} else if (dev->has_crop_cap && !dev->has_compose_cap) {
 			r.height *= factor;
-			rect_set_size_to(crop, &r);
-			rect_map_inside(crop, &dev->crop_bounds_cap);
+			v4l2_rect_set_size_to(crop, &r);
+			v4l2_rect_map_inside(crop, &dev->crop_bounds_cap);
 			r = *crop;
 			r.height /= factor;
-			rect_set_size_to(compose, &r);
+			v4l2_rect_set_size_to(compose, &r);
 		} else if (!dev->has_crop_cap) {
-			rect_map_inside(compose, &r);
+			v4l2_rect_map_inside(compose, &r);
 		} else {
 			r.height *= factor;
-			rect_set_max_size(crop, &r);
-			rect_map_inside(crop, &dev->crop_bounds_cap);
+			v4l2_rect_set_max_size(crop, &r);
+			v4l2_rect_map_inside(crop, &dev->crop_bounds_cap);
 			compose->top *= factor;
 			compose->height *= factor;
-			rect_set_size_to(compose, crop);
-			rect_map_inside(compose, &r);
+			v4l2_rect_set_size_to(compose, crop);
+			v4l2_rect_map_inside(compose, &r);
 			compose->top /= factor;
 			compose->height /= factor;
 		}
@@ -735,9 +736,9 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
 	} else {
 		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
 
-		rect_set_size_to(compose, &r);
+		v4l2_rect_set_size_to(compose, &r);
 		r.height *= factor;
-		rect_set_size_to(crop, &r);
+		v4l2_rect_set_size_to(crop, &r);
 	}
 
 	dev->fmt_cap_rect.width = mp->width;
@@ -886,9 +887,9 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 		ret = vivid_vid_adjust_sel(s->flags, &s->r);
 		if (ret)
 			return ret;
-		rect_set_min_size(&s->r, &vivid_min_rect);
-		rect_set_max_size(&s->r, &dev->src_rect);
-		rect_map_inside(&s->r, &dev->crop_bounds_cap);
+		v4l2_rect_set_min_size(&s->r, &vivid_min_rect);
+		v4l2_rect_set_max_size(&s->r, &dev->src_rect);
+		v4l2_rect_map_inside(&s->r, &dev->crop_bounds_cap);
 		s->r.top /= factor;
 		s->r.height /= factor;
 		if (dev->has_scaler_cap) {
@@ -904,36 +905,36 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 				s->r.height / MAX_ZOOM
 			};
 
-			rect_set_min_size(&fmt, &min_rect);
+			v4l2_rect_set_min_size(&fmt, &min_rect);
 			if (!dev->has_compose_cap)
-				rect_set_max_size(&fmt, &max_rect);
-			if (!rect_same_size(&dev->fmt_cap_rect, &fmt) &&
+				v4l2_rect_set_max_size(&fmt, &max_rect);
+			if (!v4l2_rect_same_size(&dev->fmt_cap_rect, &fmt) &&
 			    vb2_is_busy(&dev->vb_vid_cap_q))
 				return -EBUSY;
 			if (dev->has_compose_cap) {
-				rect_set_min_size(compose, &min_rect);
-				rect_set_max_size(compose, &max_rect);
+				v4l2_rect_set_min_size(compose, &min_rect);
+				v4l2_rect_set_max_size(compose, &max_rect);
 			}
 			dev->fmt_cap_rect = fmt;
 			tpg_s_buf_height(&dev->tpg, fmt.height);
 		} else if (dev->has_compose_cap) {
 			struct v4l2_rect fmt = dev->fmt_cap_rect;
 
-			rect_set_min_size(&fmt, &s->r);
-			if (!rect_same_size(&dev->fmt_cap_rect, &fmt) &&
+			v4l2_rect_set_min_size(&fmt, &s->r);
+			if (!v4l2_rect_same_size(&dev->fmt_cap_rect, &fmt) &&
 			    vb2_is_busy(&dev->vb_vid_cap_q))
 				return -EBUSY;
 			dev->fmt_cap_rect = fmt;
 			tpg_s_buf_height(&dev->tpg, fmt.height);
-			rect_set_size_to(compose, &s->r);
-			rect_map_inside(compose, &dev->fmt_cap_rect);
+			v4l2_rect_set_size_to(compose, &s->r);
+			v4l2_rect_map_inside(compose, &dev->fmt_cap_rect);
 		} else {
-			if (!rect_same_size(&s->r, &dev->fmt_cap_rect) &&
+			if (!v4l2_rect_same_size(&s->r, &dev->fmt_cap_rect) &&
 			    vb2_is_busy(&dev->vb_vid_cap_q))
 				return -EBUSY;
-			rect_set_size_to(&dev->fmt_cap_rect, &s->r);
-			rect_set_size_to(compose, &s->r);
-			rect_map_inside(compose, &dev->fmt_cap_rect);
+			v4l2_rect_set_size_to(&dev->fmt_cap_rect, &s->r);
+			v4l2_rect_set_size_to(compose, &s->r);
+			v4l2_rect_map_inside(compose, &dev->fmt_cap_rect);
 			tpg_s_buf_height(&dev->tpg, dev->fmt_cap_rect.height);
 		}
 		s->r.top *= factor;
@@ -946,8 +947,8 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 		ret = vivid_vid_adjust_sel(s->flags, &s->r);
 		if (ret)
 			return ret;
-		rect_set_min_size(&s->r, &vivid_min_rect);
-		rect_set_max_size(&s->r, &dev->fmt_cap_rect);
+		v4l2_rect_set_min_size(&s->r, &vivid_min_rect);
+		v4l2_rect_set_max_size(&s->r, &dev->fmt_cap_rect);
 		if (dev->has_scaler_cap) {
 			struct v4l2_rect max_rect = {
 				0, 0,
@@ -955,7 +956,7 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 				(dev->src_rect.height / factor) * MAX_ZOOM
 			};
 
-			rect_set_max_size(&s->r, &max_rect);
+			v4l2_rect_set_max_size(&s->r, &max_rect);
 			if (dev->has_crop_cap) {
 				struct v4l2_rect min_rect = {
 					0, 0,
@@ -968,23 +969,23 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 					(s->r.height * factor) * MAX_ZOOM
 				};
 
-				rect_set_min_size(crop, &min_rect);
-				rect_set_max_size(crop, &max_rect);
-				rect_map_inside(crop, &dev->crop_bounds_cap);
+				v4l2_rect_set_min_size(crop, &min_rect);
+				v4l2_rect_set_max_size(crop, &max_rect);
+				v4l2_rect_map_inside(crop, &dev->crop_bounds_cap);
 			}
 		} else if (dev->has_crop_cap) {
 			s->r.top *= factor;
 			s->r.height *= factor;
-			rect_set_max_size(&s->r, &dev->src_rect);
-			rect_set_size_to(crop, &s->r);
-			rect_map_inside(crop, &dev->crop_bounds_cap);
+			v4l2_rect_set_max_size(&s->r, &dev->src_rect);
+			v4l2_rect_set_size_to(crop, &s->r);
+			v4l2_rect_map_inside(crop, &dev->crop_bounds_cap);
 			s->r.top /= factor;
 			s->r.height /= factor;
 		} else {
-			rect_set_size_to(&s->r, &dev->src_rect);
+			v4l2_rect_set_size_to(&s->r, &dev->src_rect);
 			s->r.height /= factor;
 		}
-		rect_map_inside(&s->r, &dev->fmt_cap_rect);
+		v4l2_rect_map_inside(&s->r, &dev->fmt_cap_rect);
 		if (dev->bitmap_cap && (compose->width != s->r.width ||
 					compose->height != s->r.height)) {
 			kfree(dev->bitmap_cap);
@@ -1124,7 +1125,7 @@ int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
 			for (j = i + 1; j < win->clipcount; j++) {
 				struct v4l2_rect *r2 = &dev->try_clips_cap[j].c;
 
-				if (rect_overlap(r1, r2))
+				if (v4l2_rect_overlap(r1, r2))
 					return -EINVAL;
 			}
 		}
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index b0d4e3a..39ea228 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -653,103 +653,6 @@ int fmt_sp2mp_func(struct file *file, void *priv,
 	return ret;
 }
 
-/* v4l2_rect helper function: copy the width/height values */
-void rect_set_size_to(struct v4l2_rect *r, const struct v4l2_rect *size)
-{
-	r->width = size->width;
-	r->height = size->height;
-}
-
-/* v4l2_rect helper function: width and height of r should be >= min_size */
-void rect_set_min_size(struct v4l2_rect *r, const struct v4l2_rect *min_size)
-{
-	if (r->width < min_size->width)
-		r->width = min_size->width;
-	if (r->height < min_size->height)
-		r->height = min_size->height;
-}
-
-/* v4l2_rect helper function: width and height of r should be <= max_size */
-void rect_set_max_size(struct v4l2_rect *r, const struct v4l2_rect *max_size)
-{
-	if (r->width > max_size->width)
-		r->width = max_size->width;
-	if (r->height > max_size->height)
-		r->height = max_size->height;
-}
-
-/* v4l2_rect helper function: r should be inside boundary */
-void rect_map_inside(struct v4l2_rect *r, const struct v4l2_rect *boundary)
-{
-	rect_set_max_size(r, boundary);
-	if (r->left < boundary->left)
-		r->left = boundary->left;
-	if (r->top < boundary->top)
-		r->top = boundary->top;
-	if (r->left + r->width > boundary->width)
-		r->left = boundary->width - r->width;
-	if (r->top + r->height > boundary->height)
-		r->top = boundary->height - r->height;
-}
-
-/* v4l2_rect helper function: return true if r1 has the same size as r2 */
-bool rect_same_size(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
-{
-	return r1->width == r2->width && r1->height == r2->height;
-}
-
-/* v4l2_rect helper function: calculate the intersection of two rects */
-struct v4l2_rect rect_intersect(const struct v4l2_rect *a, const struct v4l2_rect *b)
-{
-	struct v4l2_rect r;
-	int right, bottom;
-
-	r.top = max(a->top, b->top);
-	r.left = max(a->left, b->left);
-	bottom = min(a->top + a->height, b->top + b->height);
-	right = min(a->left + a->width, b->left + b->width);
-	r.height = max(0, bottom - r.top);
-	r.width = max(0, right - r.left);
-	return r;
-}
-
-/*
- * v4l2_rect helper function: scale rect r by to->width / from->width and
- * to->height / from->height.
- */
-void rect_scale(struct v4l2_rect *r, const struct v4l2_rect *from,
-				     const struct v4l2_rect *to)
-{
-	if (from->width == 0 || from->height == 0) {
-		r->left = r->top = r->width = r->height = 0;
-		return;
-	}
-	r->left = (((r->left - from->left) * to->width) / from->width) & ~1;
-	r->width = ((r->width * to->width) / from->width) & ~1;
-	r->top = ((r->top - from->top) * to->height) / from->height;
-	r->height = (r->height * to->height) / from->height;
-}
-
-bool rect_overlap(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
-{
-	/*
-	 * IF the left side of r1 is to the right of the right side of r2 OR
-	 *    the left side of r2 is to the right of the right side of r1 THEN
-	 * they do not overlap.
-	 */
-	if (r1->left >= r2->left + r2->width ||
-	    r2->left >= r1->left + r1->width)
-		return false;
-	/*
-	 * IF the top side of r1 is below the bottom of r2 OR
-	 *    the top side of r2 is below the bottom of r1 THEN
-	 * they do not overlap.
-	 */
-	if (r1->top >= r2->top + r2->height ||
-	    r2->top >= r1->top + r1->height)
-		return false;
-	return true;
-}
 int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r)
 {
 	unsigned w = r->width;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.h b/drivers/media/platform/vivid/vivid-vid-common.h
index 3ec4fa8..4b6175e 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.h
+++ b/drivers/media/platform/vivid/vivid-vid-common.h
@@ -37,15 +37,6 @@ const struct vivid_fmt *vivid_get_format(struct vivid_dev *dev, u32 pixelformat)
 bool vivid_vid_can_loop(struct vivid_dev *dev);
 void vivid_send_source_change(struct vivid_dev *dev, unsigned type);
 
-bool rect_overlap(const struct v4l2_rect *r1, const struct v4l2_rect *r2);
-void rect_set_size_to(struct v4l2_rect *r, const struct v4l2_rect *size);
-void rect_set_min_size(struct v4l2_rect *r, const struct v4l2_rect *min_size);
-void rect_set_max_size(struct v4l2_rect *r, const struct v4l2_rect *max_size);
-void rect_map_inside(struct v4l2_rect *r, const struct v4l2_rect *boundary);
-bool rect_same_size(const struct v4l2_rect *r1, const struct v4l2_rect *r2);
-struct v4l2_rect rect_intersect(const struct v4l2_rect *a, const struct v4l2_rect *b);
-void rect_scale(struct v4l2_rect *r, const struct v4l2_rect *from,
-				     const struct v4l2_rect *to);
 int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r);
 
 int vivid_enum_fmt_vid(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 64e4d66..f92f449 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -25,6 +25,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-dv-timings.h>
+#include <media/v4l2-rect.h>
 
 #include "vivid-core.h"
 #include "vivid-vid-common.h"
@@ -376,16 +377,16 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 	} else {
 		struct v4l2_rect r = { 0, 0, mp->width, mp->height * factor };
 
-		rect_set_min_size(&r, &vivid_min_rect);
-		rect_set_max_size(&r, &vivid_max_rect);
+		v4l2_rect_set_min_size(&r, &vivid_min_rect);
+		v4l2_rect_set_max_size(&r, &vivid_max_rect);
 		if (dev->has_scaler_out && !dev->has_crop_out) {
 			struct v4l2_rect max_r = { 0, 0, MAX_ZOOM * w, MAX_ZOOM * h };
 
-			rect_set_max_size(&r, &max_r);
+			v4l2_rect_set_max_size(&r, &max_r);
 		} else if (!dev->has_scaler_out && dev->has_compose_out && !dev->has_crop_out) {
-			rect_set_max_size(&r, &dev->sink_rect);
+			v4l2_rect_set_max_size(&r, &dev->sink_rect);
 		} else if (!dev->has_scaler_out && !dev->has_compose_out) {
-			rect_set_min_size(&r, &dev->sink_rect);
+			v4l2_rect_set_min_size(&r, &dev->sink_rect);
 		}
 		mp->width = r.width;
 		mp->height = r.height / factor;
@@ -473,7 +474,7 @@ int vivid_s_fmt_vid_out(struct file *file, void *priv,
 
 		if (dev->has_scaler_out) {
 			if (dev->has_crop_out)
-				rect_map_inside(crop, &r);
+				v4l2_rect_map_inside(crop, &r);
 			else
 				*crop = r;
 			if (dev->has_compose_out && !dev->has_crop_out) {
@@ -488,9 +489,9 @@ int vivid_s_fmt_vid_out(struct file *file, void *priv,
 					factor * r.height * MAX_ZOOM
 				};
 
-				rect_set_min_size(compose, &min_r);
-				rect_set_max_size(compose, &max_r);
-				rect_map_inside(compose, &dev->compose_bounds_out);
+				v4l2_rect_set_min_size(compose, &min_r);
+				v4l2_rect_set_max_size(compose, &max_r);
+				v4l2_rect_map_inside(compose, &dev->compose_bounds_out);
 			} else if (dev->has_compose_out) {
 				struct v4l2_rect min_r = {
 					0, 0,
@@ -503,36 +504,36 @@ int vivid_s_fmt_vid_out(struct file *file, void *priv,
 					factor * crop->height * MAX_ZOOM
 				};
 
-				rect_set_min_size(compose, &min_r);
-				rect_set_max_size(compose, &max_r);
-				rect_map_inside(compose, &dev->compose_bounds_out);
+				v4l2_rect_set_min_size(compose, &min_r);
+				v4l2_rect_set_max_size(compose, &max_r);
+				v4l2_rect_map_inside(compose, &dev->compose_bounds_out);
 			}
 		} else if (dev->has_compose_out && !dev->has_crop_out) {
-			rect_set_size_to(crop, &r);
+			v4l2_rect_set_size_to(crop, &r);
 			r.height *= factor;
-			rect_set_size_to(compose, &r);
-			rect_map_inside(compose, &dev->compose_bounds_out);
+			v4l2_rect_set_size_to(compose, &r);
+			v4l2_rect_map_inside(compose, &dev->compose_bounds_out);
 		} else if (!dev->has_compose_out) {
-			rect_map_inside(crop, &r);
+			v4l2_rect_map_inside(crop, &r);
 			r.height /= factor;
-			rect_set_size_to(compose, &r);
+			v4l2_rect_set_size_to(compose, &r);
 		} else {
 			r.height *= factor;
-			rect_set_max_size(compose, &r);
-			rect_map_inside(compose, &dev->compose_bounds_out);
+			v4l2_rect_set_max_size(compose, &r);
+			v4l2_rect_map_inside(compose, &dev->compose_bounds_out);
 			crop->top *= factor;
 			crop->height *= factor;
-			rect_set_size_to(crop, compose);
-			rect_map_inside(crop, &r);
+			v4l2_rect_set_size_to(crop, compose);
+			v4l2_rect_map_inside(crop, &r);
 			crop->top /= factor;
 			crop->height /= factor;
 		}
 	} else {
 		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
 
-		rect_set_size_to(crop, &r);
+		v4l2_rect_set_size_to(crop, &r);
 		r.height /= factor;
-		rect_set_size_to(compose, &r);
+		v4l2_rect_set_size_to(compose, &r);
 	}
 
 	dev->fmt_out_rect.width = mp->width;
@@ -683,8 +684,8 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
 		ret = vivid_vid_adjust_sel(s->flags, &s->r);
 		if (ret)
 			return ret;
-		rect_set_min_size(&s->r, &vivid_min_rect);
-		rect_set_max_size(&s->r, &dev->fmt_out_rect);
+		v4l2_rect_set_min_size(&s->r, &vivid_min_rect);
+		v4l2_rect_set_max_size(&s->r, &dev->fmt_out_rect);
 		if (dev->has_scaler_out) {
 			struct v4l2_rect max_rect = {
 				0, 0,
@@ -692,7 +693,7 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
 				(dev->sink_rect.height / factor) * MAX_ZOOM
 			};
 
-			rect_set_max_size(&s->r, &max_rect);
+			v4l2_rect_set_max_size(&s->r, &max_rect);
 			if (dev->has_compose_out) {
 				struct v4l2_rect min_rect = {
 					0, 0,
@@ -705,23 +706,23 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
 					(s->r.height * factor) * MAX_ZOOM
 				};
 
-				rect_set_min_size(compose, &min_rect);
-				rect_set_max_size(compose, &max_rect);
-				rect_map_inside(compose, &dev->compose_bounds_out);
+				v4l2_rect_set_min_size(compose, &min_rect);
+				v4l2_rect_set_max_size(compose, &max_rect);
+				v4l2_rect_map_inside(compose, &dev->compose_bounds_out);
 			}
 		} else if (dev->has_compose_out) {
 			s->r.top *= factor;
 			s->r.height *= factor;
-			rect_set_max_size(&s->r, &dev->sink_rect);
-			rect_set_size_to(compose, &s->r);
-			rect_map_inside(compose, &dev->compose_bounds_out);
+			v4l2_rect_set_max_size(&s->r, &dev->sink_rect);
+			v4l2_rect_set_size_to(compose, &s->r);
+			v4l2_rect_map_inside(compose, &dev->compose_bounds_out);
 			s->r.top /= factor;
 			s->r.height /= factor;
 		} else {
-			rect_set_size_to(&s->r, &dev->sink_rect);
+			v4l2_rect_set_size_to(&s->r, &dev->sink_rect);
 			s->r.height /= factor;
 		}
-		rect_map_inside(&s->r, &dev->fmt_out_rect);
+		v4l2_rect_map_inside(&s->r, &dev->fmt_out_rect);
 		*crop = s->r;
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
@@ -730,9 +731,9 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
 		ret = vivid_vid_adjust_sel(s->flags, &s->r);
 		if (ret)
 			return ret;
-		rect_set_min_size(&s->r, &vivid_min_rect);
-		rect_set_max_size(&s->r, &dev->sink_rect);
-		rect_map_inside(&s->r, &dev->compose_bounds_out);
+		v4l2_rect_set_min_size(&s->r, &vivid_min_rect);
+		v4l2_rect_set_max_size(&s->r, &dev->sink_rect);
+		v4l2_rect_map_inside(&s->r, &dev->compose_bounds_out);
 		s->r.top /= factor;
 		s->r.height /= factor;
 		if (dev->has_scaler_out) {
@@ -748,35 +749,35 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
 				s->r.height / MAX_ZOOM
 			};
 
-			rect_set_min_size(&fmt, &min_rect);
+			v4l2_rect_set_min_size(&fmt, &min_rect);
 			if (!dev->has_crop_out)
-				rect_set_max_size(&fmt, &max_rect);
-			if (!rect_same_size(&dev->fmt_out_rect, &fmt) &&
+				v4l2_rect_set_max_size(&fmt, &max_rect);
+			if (!v4l2_rect_same_size(&dev->fmt_out_rect, &fmt) &&
 			    vb2_is_busy(&dev->vb_vid_out_q))
 				return -EBUSY;
 			if (dev->has_crop_out) {
-				rect_set_min_size(crop, &min_rect);
-				rect_set_max_size(crop, &max_rect);
+				v4l2_rect_set_min_size(crop, &min_rect);
+				v4l2_rect_set_max_size(crop, &max_rect);
 			}
 			dev->fmt_out_rect = fmt;
 		} else if (dev->has_crop_out) {
 			struct v4l2_rect fmt = dev->fmt_out_rect;
 
-			rect_set_min_size(&fmt, &s->r);
-			if (!rect_same_size(&dev->fmt_out_rect, &fmt) &&
+			v4l2_rect_set_min_size(&fmt, &s->r);
+			if (!v4l2_rect_same_size(&dev->fmt_out_rect, &fmt) &&
 			    vb2_is_busy(&dev->vb_vid_out_q))
 				return -EBUSY;
 			dev->fmt_out_rect = fmt;
-			rect_set_size_to(crop, &s->r);
-			rect_map_inside(crop, &dev->fmt_out_rect);
+			v4l2_rect_set_size_to(crop, &s->r);
+			v4l2_rect_map_inside(crop, &dev->fmt_out_rect);
 		} else {
-			if (!rect_same_size(&s->r, &dev->fmt_out_rect) &&
+			if (!v4l2_rect_same_size(&s->r, &dev->fmt_out_rect) &&
 			    vb2_is_busy(&dev->vb_vid_out_q))
 				return -EBUSY;
-			rect_set_size_to(&dev->fmt_out_rect, &s->r);
-			rect_set_size_to(crop, &s->r);
+			v4l2_rect_set_size_to(&dev->fmt_out_rect, &s->r);
+			v4l2_rect_set_size_to(crop, &s->r);
 			crop->height /= factor;
-			rect_map_inside(crop, &dev->fmt_out_rect);
+			v4l2_rect_map_inside(crop, &dev->fmt_out_rect);
 		}
 		s->r.top *= factor;
 		s->r.height *= factor;
@@ -901,7 +902,7 @@ int vidioc_try_fmt_vid_out_overlay(struct file *file, void *priv,
 			for (j = i + 1; j < win->clipcount; j++) {
 				struct v4l2_rect *r2 = &dev->try_clips_out[j].c;
 
-				if (rect_overlap(r1, r2))
+				if (v4l2_rect_overlap(r1, r2))
 					return -EINVAL;
 			}
 		}
-- 
2.8.0.rc3

