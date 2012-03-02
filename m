Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:60726 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab2CBRcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:53 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 06/34] v4l: Check pad number in get try pointer functions
Date: Fri,  2 Mar 2012 19:30:14 +0200
Message-Id: <1330709442-16654-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unify functions to get try pointers and validate the pad number accessed by
the user.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/media/v4l2-subdev.h |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index bcaf6b8..7e85035 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -565,23 +565,19 @@ struct v4l2_subdev_fh {
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
+		BUG_ON(unlikely(pad >= vdev_to_v4l2_subdev(		\
+					fh->vfh.vdev)->entity.num_pads)); \
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

