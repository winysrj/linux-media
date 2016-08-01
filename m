Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34631 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbcHAIph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 04:45:37 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-common: add s_selection helper function
Message-ID: <ecb574ab-58df-8a9d-e3c0-c269cb4ad294@xs4all.nl>
Date: Mon, 1 Aug 2016 10:45:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking the selection constraint flags is often forgotten by drivers, especially
if the selection code just clamps the rectangle to the minimum and maximum allowed
rectangles.

This patch adds a simple helper function that checks the adjusted rectangle against
the constraint flags and either returns -ERANGE if it doesn't fit, or fills in the
new rectangle and returns 0.

It also adds a small helper function to v4l2-rect.h to check if one rectangle fits
inside another.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 5b80850..a2e5119 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -61,6 +61,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-rect.h>

 #include <linux/videodev2.h>

@@ -371,6 +372,21 @@ void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
 }
 EXPORT_SYMBOL_GPL(v4l_bound_align_image);

+int v4l2_s_selection(struct v4l2_selection *s, const struct v4l2_rect *r)
+{
+	/* The original rect must lay inside the adjusted one */
+	if ((s->flags & V4L2_SEL_FLAG_GE) &&
+	    !v4l2_rect_is_inside(&s->r, r))
+		return -ERANGE;
+	/* The adjusted rect must lay inside the original one */
+	if ((s->flags & V4L2_SEL_FLAG_LE) &&
+	    !v4l2_rect_is_inside(r, &s->r))
+		return -ERANGE;
+	s->r = *r;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_s_selection);
+
 const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 		const struct v4l2_discrete_probe *probe,
 		s32 width, s32 height)
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 350cbf9..cfa9cbf 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -246,6 +246,17 @@ void v4l_bound_align_image(unsigned int *w, unsigned int wmin,
 			   unsigned int hmax, unsigned int halign,
 			   unsigned int salign);

+/**
+ * v4l2_s_selection - Helper to check adjusted rectangle against constraint flags
+ *
+ * @s: pointer to &struct v4l2_selection containing the original rectangle
+ * @r: pointer to &struct v4l2_rect containing the adjusted rectangle.
+ *
+ * Returns -ERANGE if the adjusted rectangle doesn't fit the constraints
+ * or 0 if it is fine. On success it sets @s->r to @r.
+ */
+int v4l2_s_selection(struct v4l2_selection *s, const struct v4l2_rect *r);
+
 struct v4l2_discrete_probe {
 	const struct v4l2_frmsize_discrete	*sizes;
 	int					num_sizes;
diff --git a/include/media/v4l2-rect.h b/include/media/v4l2-rect.h
index d2125f0..858c8cb 100644
--- a/include/media/v4l2-rect.h
+++ b/include/media/v4l2-rect.h
@@ -95,6 +95,21 @@ static inline bool v4l2_rect_same_size(const struct v4l2_rect *r1,
 }

 /**
+ * v4l2_rect_is_inside() - return true if r1 is inside r2
+ * @r1: rectangle.
+ * @r2: rectangle.
+ *
+ * Return true if r1 fits inside r2.
+ */
+static inline bool v4l2_rect_is_inside(const struct v4l2_rect *r1,
+				       const struct v4l2_rect *r2)
+{
+	return r1->left >= r2->left && r1->top >= r2->top &&
+	       r1->left + r1->width <= r2->left + r2->width &&
+	       r1->top + r1->height <= r2->top + r2->height;
+}
+
+/**
  * v4l2_rect_intersect() - calculate the intersection of two rects.
  * @r: intersection of @r1 and @r2.
  * @r1: rectangle.
