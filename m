Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62741 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbdJIKTh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 15/24] media: v4l2-subdev: get rid of __V4L2_SUBDEV_MK_GET_TRY() macro
Date: Mon,  9 Oct 2017 07:19:21 -0300
Message-Id: <63937cedcefd1c56b211ec115b717510c470bd1a.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __V4L2_SUBDEV_MK_GET_TRY() macro is used to define
3 functions that have the same arguments. The code of those
functions is simple enough to just declare them, de-obfuscating
the code.

While here, replace BUG_ON() by WARN_ON() as there's no reason
why to panic the Kernel if this fails.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1f34045f07ce..35c4476c56ee 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -897,19 +897,32 @@ struct v4l2_subdev_fh {
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-#define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
-	static inline struct rtype *					\
-	fun_name(struct v4l2_subdev *sd,				\
-		 struct v4l2_subdev_pad_config *cfg,			\
-		 unsigned int pad)					\
-	{								\
-		BUG_ON(pad >= sd->entity.num_pads);			\
-		return &cfg[pad].field_name;				\
-	}
+static inline struct v4l2_mbus_framefmt
+*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    unsigned int pad)
+{
+	WARN_ON(pad >= sd->entity.num_pads);
+	return &cfg[pad].try_fmt;
+}
 
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
+static inline struct v4l2_rect
+*v4l2_subdev_get_try_crop(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  unsigned int pad)
+{
+	WARN_ON(pad >= sd->entity.num_pads);
+	return &cfg[pad].try_crop;
+}
+
+static inline struct v4l2_rect
+*v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     unsigned int pad)
+{
+	WARN_ON(pad >= sd->entity.num_pads);
+	return &cfg[pad].try_compose;
+}
 #endif
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
-- 
2.13.6
