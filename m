Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58628 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762260AbdLSLSb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:18:31 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 6/8] media: v4l2-subdev: get rid of __V4L2_SUBDEV_MK_GET_TRY() macro
Date: Tue, 19 Dec 2017 09:18:22 -0200
Message-Id: <e1a835c0f4c43a61bdee2950e1752051c92ca73d.1513682135.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513682135.git.mchehab@s-opensource.com>
References: <cover.1513682135.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513682135.git.mchehab@s-opensource.com>
References: <cover.1513682135.git.mchehab@s-opensource.com>
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
 include/media/v4l2-subdev.h | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 71b8ff4b2e0e..443e5e019006 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -896,19 +896,35 @@ struct v4l2_subdev_fh {
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
+	if (WARN_ON(pad >= sd->entity.num_pads))
+		pad = 0;
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
+	if (WARN_ON(pad >= sd->entity.num_pads))
+		pad = 0;
+	return &cfg[pad].try_crop;
+}
+
+static inline struct v4l2_rect
+*v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     unsigned int pad)
+{
+	if (WARN_ON(pad >= sd->entity.num_pads))
+		pad = 0;
+	return &cfg[pad].try_compose;
+}
 #endif
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
-- 
2.14.3
