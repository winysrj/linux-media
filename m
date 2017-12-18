Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35389 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758821AbdLRTyM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 14:54:12 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 7/8] media: v4l2-subdev: document remaining undocumented functions
Date: Mon, 18 Dec 2017 17:54:01 -0200
Message-Id: <ecbf720686b6469848498934710779ca626aed9c.1513625884.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513625884.git.mchehab@s-opensource.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513625884.git.mchehab@s-opensource.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several undocumented v4l2-subdev functions that are
part of kAPI. Document them.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 69 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 64 insertions(+), 5 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1c280cf7dd41..2562e8854022 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -867,6 +867,13 @@ struct v4l2_subdev {
 	struct v4l2_subdev_platform_data *pdata;
 };
 
+
+/**
+ * media_entity_to_v4l2_subdev - Returns a &struct v4l2_subdev from
+ *     the &struct media_entity embedded in it.
+ *
+ * @ent: pointer to &struct media_entity.
+ */
 #define media_entity_to_v4l2_subdev(ent)				\
 ({									\
 	typeof(ent) __me_sd_ent = (ent);				\
@@ -876,14 +883,20 @@ struct v4l2_subdev {
 		NULL;							\
 })
 
+/**
+ * vdev_to_v4l2_subdev - Returns a &struct v4l2_subdev from
+ *     the &struct video_device embedded on it.
+ *
+ * @vdev: pointer to &struct video_device
+ */
 #define vdev_to_v4l2_subdev(vdev) \
 	((struct v4l2_subdev *)video_get_drvdata(vdev))
 
 /**
  * struct v4l2_subdev_fh - Used for storing subdev information per file handle
  *
- * @vfh: pointer to struct v4l2_fh
- * @pad: pointer to v4l2_subdev_pad_config
+ * @vfh: pointer to &struct v4l2_fh
+ * @pad: pointer to &struct v4l2_subdev_pad_config
  */
 struct v4l2_subdev_fh {
 	struct v4l2_fh vfh;
@@ -892,10 +905,25 @@ struct v4l2_subdev_fh {
 #endif
 };
 
+/**
+ * to_v4l2_subdev_fh - Returns a &struct v4l2_subdev_fh from
+ *     the &struct v4l2_fh embedded on it.
+ *
+ * @fh: pointer to &struct v4l2_fh
+ */
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
+
+/**
+ * v4l2_subdev_get_try_format - ancillary routine to call
+ * 	&struct v4l2_subdev_pad_config->try_fmt
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @cfg: pointer to &struct v4l2_subdev_pad_config array.
+ * @pad: index of the pad in the @cfg array.
+ */
 static inline struct v4l2_mbus_framefmt
 *v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
 			    struct v4l2_subdev_pad_config *cfg,
@@ -906,6 +934,14 @@ static inline struct v4l2_mbus_framefmt
 	return &cfg[pad].try_fmt;
 }
 
+/**
+ * v4l2_subdev_get_try_crop - ancillary routine to call
+ * 	&struct v4l2_subdev_pad_config->try_crop
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @cfg: pointer to &struct v4l2_subdev_pad_config array.
+ * @pad: index of the pad in the @cfg array.
+ */
 static inline struct v4l2_rect
 *v4l2_subdev_get_try_crop(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
@@ -916,6 +952,14 @@ static inline struct v4l2_rect
 	return &cfg[pad].try_crop;
 }
 
+/**
+ * v4l2_subdev_get_try_crop - ancillary routine to call
+ * 	&struct v4l2_subdev_pad_config->try_compose
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @cfg: pointer to &struct v4l2_subdev_pad_config array.
+ * @pad: index of the pad in the @cfg array.
+ */
 static inline struct v4l2_rect
 *v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_pad_config *cfg,
@@ -1032,9 +1076,16 @@ void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg);
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
-/*
- * Call an ops of a v4l2_subdev, doing the right checks against
- * NULL pointers.
+/**
+ * v4l2_subdev_call - call an operation of a v4l2_subdev.
+ *
+ * @sd: pointer to the &struct v4l2_subdev
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of callbacks functions.
+ * @f: callback function that will be called if @cond matches.
+ *     The callback functions are defined in groups, according to
+ *     each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
  *
  * Example: err = v4l2_subdev_call(sd, video, s_std, norm);
  */
@@ -1050,6 +1101,14 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 		__result;						\
 	})
 
+/**
+ * v4l2_subdev_has_op - Checks if a subdev defines a certain operation.
+ *
+ * @sd: pointer to the &struct v4l2_subdev
+ * @o: The group of callback functions in &struct v4l2_subdev_ops
+ * which @f is a part of.
+ * @f: callback function to be checked for its existence.
+ */
 #define v4l2_subdev_has_op(sd, o, f) \
 	((sd)->ops->o && (sd)->ops->o->f)
 
-- 
2.14.3
