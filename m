Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:58615 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab2BTB6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 20:58:06 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH v3 06/33] v4l: Check pad number in get try pointer functions
Date: Mon, 20 Feb 2012 03:56:45 +0200
Message-Id: <1329703032-31314-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120220015605.GI7784@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unify functions to get try pointers and validate the pad number accessed by
the user.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/media/v4l2-subdev.h |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index bcaf6b8..d48dae5 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -565,23 +565,20 @@ struct v4l2_subdev_fh {
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-static inline struct v4l2_mbus_framefmt *
-v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)
-{
-	return &fh->pad[pad].try_fmt;
-}
-
-static inline struct v4l2_rect *
-v4l2_subdev_get_try_crop(struct v4l2_subdev_fh *fh, unsigned int pad)
-{
-	return &fh->pad[pad].try_crop;
-}
-
-static inline struct v4l2_rect *
-v4l2_subdev_get_try_compose(struct v4l2_subdev_fh *fh, unsigned int pad)
-{
-	return &fh->pad[pad].try_compose;
-}
+#define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
+	static inline struct rtype *					\
+	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
+				       unsigned int pad)		\
+	{								\
+		if (unlikely(pad > vdev_to_v4l2_subdev(			\
+				     fh->vfh.vdev->entity.num_pads)	\
+			return NULL;					\
+		return &fh->pad[pad].field_name;			\
+	}
+
+__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
+__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_compose)
+__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
 #endif
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
-- 
1.7.2.5

