Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:19030 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab2FONow (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 09:44:52 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	snjw23@gmail.com, t.stanislaws@samsung.com
Subject: [PATCH v4 5/7] v4l: Unify selection flags
Date: Fri, 15 Jun 2012 16:44:38 +0300
Message-Id: <1339767880-8412-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FDB3C2E.9060502@iki.fi>
References: <4FDB3C2E.9060502@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unify flags on the selection interfaces on V4L2 and V4L2 subdev. Flags are
very similar to targets in this case: there are more similarities than
differences between the two interfaces.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispccdc.c    |    2 +-
 drivers/media/video/omap3isp/isppreview.c |    2 +-
 drivers/media/video/smiapp/smiapp-core.c  |   10 +++++-----
 include/linux/v4l2-common.h               |    5 +++++
 include/linux/v4l2-subdev.h               |    6 +-----
 include/linux/videodev2.h                 |    6 +-----
 6 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 82df7a0..f1220d3 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -2064,7 +2064,7 @@ static int ccdc_set_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	 * pad. If the KEEP_CONFIG flag is set, just return the current crop
 	 * rectangle.
 	 */
-	if (sel->flags & V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG) {
+	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
 		sel->r = *__ccdc_get_crop(ccdc, fh, sel->which);
 		return 0;
 	}
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 6fa70f4..99d5cc4 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -2000,7 +2000,7 @@ static int preview_set_selection(struct v4l2_subdev *sd,
 	 * pad. If the KEEP_CONFIG flag is set, just return the current crop
 	 * rectangle.
 	 */
-	if (sel->flags & V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG) {
+	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
 		sel->r = *__preview_get_crop(prev, fh, sel->which);
 		return 0;
 	}
diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index 09f0e30..e43be87 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -37,9 +37,9 @@
 
 #include "smiapp.h"
 
-#define SMIAPP_ALIGN_DIM(dim, flags)		\
-	((flags) & V4L2_SUBDEV_SEL_FLAG_SIZE_GE	\
-	 ? ALIGN((dim), 2)			\
+#define SMIAPP_ALIGN_DIM(dim, flags)	\
+	((flags) & V4L2_SEL_FLAG_GE	\
+	 ? ALIGN((dim), 2)		\
 	 : (dim) & ~1)
 
 /*
@@ -1746,14 +1746,14 @@ static int scaling_goodness(struct v4l2_subdev *subdev, int w, int ask_w,
 	h &= ~1;
 	ask_h &= ~1;
 
-	if (flags & V4L2_SUBDEV_SEL_FLAG_SIZE_GE) {
+	if (flags & V4L2_SEL_FLAG_GE) {
 		if (w < ask_w)
 			val -= SCALING_GOODNESS;
 		if (h < ask_h)
 			val -= SCALING_GOODNESS;
 	}
 
-	if (flags & V4L2_SUBDEV_SEL_FLAG_SIZE_LE) {
+	if (flags & V4L2_SEL_FLAG_LE) {
 		if (w > ask_w)
 			val -= SCALING_GOODNESS;
 		if (h > ask_h)
diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
index 45b9ec4..fba06da 100644
--- a/include/linux/v4l2-common.h
+++ b/include/linux/v4l2-common.h
@@ -50,4 +50,9 @@
 #define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
 #define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
 
+/* Selection flags */
+#define V4L2_SEL_FLAG_GE		(1 << 0)
+#define V4L2_SEL_FLAG_LE		(1 << 1)
+#define V4L2_SEL_FLAG_KEEP_CONFIG	(1 << 2)
+
 #endif /* __V4L2_COMMON__  */
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index 1d7d457..8c57ee9 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -124,10 +124,6 @@ struct v4l2_subdev_frame_interval_enum {
 	__u32 reserved[9];
 };
 
-#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE			(1 << 0)
-#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE			(1 << 1)
-#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1 << 2)
-
 /**
  * struct v4l2_subdev_selection - selection info
  *
@@ -135,7 +131,7 @@ struct v4l2_subdev_frame_interval_enum {
  * @pad: pad number, as reported by the media API
  * @target: Selection target, used to choose one of possible rectangles,
  *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
- * @flags: constraint flags
+ * @flags: constraint flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r: coordinates of the selection window
  * @reserved: for future use, set to zero for now
  *
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 252f4b2..27da0c6 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -762,16 +762,12 @@ struct v4l2_crop {
 	struct v4l2_rect        c;
 };
 
-/* Hints for adjustments of selection rectangle */
-#define V4L2_SEL_FLAG_GE	0x00000001
-#define V4L2_SEL_FLAG_LE	0x00000002
-
 /**
  * struct v4l2_selection - selection info
  * @type:	buffer type (do not use *_MPLANE types)
  * @target:	Selection target, used to choose one of possible rectangles;
  *		defined in v4l2-common.h; V4L2_SEL_TGT_* .
- * @flags:	constraints flags
+ * @flags:	constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r:		coordinates of selection window
  * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
  *
-- 
1.7.2.5

