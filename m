Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52616 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754085AbdJIKTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:44 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 16/24] media: v4l2-subdev: document remaining undocumented functions
Date: Mon,  9 Oct 2017 07:19:22 -0300
Message-Id: <178142c425bdf92818c190c3c1eded1785294881.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several undocumented v4l2-subdev functions that are
part of kAPI. Document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 70 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 35c4476c56ee..e215732eed45 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -868,6 +868,13 @@ struct v4l2_subdev {
 	struct v4l2_subdev_platform_data *pdata;
 };
 
+
+/**
+ * media_entity_to_v4l2_subdev - Returns a &struct v4l2_subdev from
+ *     the &struct media_entity embedded on it.
+ *
+ * @ent: pointer to &struct media_entity.
+ */
 #define media_entity_to_v4l2_subdev(ent)				\
 ({									\
 	typeof(ent) __me_sd_ent = (ent);				\
@@ -877,14 +884,20 @@ struct v4l2_subdev {
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
@@ -893,10 +906,25 @@ struct v4l2_subdev_fh {
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
+ * @pad: index of the pad a the @cfg array.
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
+ * @pad: index of the pad a the @cfg array.
+ */
 static inline struct v4l2_rect
 *v4l2_subdev_get_try_crop(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
@@ -915,6 +951,14 @@ static inline struct v4l2_rect
 	return &cfg[pad].try_crop;
 }
 
+/**
+ * v4l2_subdev_get_try_crop - ancillary routine to call
+ * 	&struct v4l2_subdev_pad_config->try_compose
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @cfg: pointer to &struct v4l2_subdev_pad_config array.
+ * @pad: index of the pad a the @cfg array.
+ */
 static inline struct v4l2_rect
 *v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_pad_config *cfg,
@@ -1030,9 +1074,17 @@ void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg);
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
-/*
- * Call an ops of a v4l2_subdev, doing the right checks against
- * NULL pointers.
+/**
+ * v4l2_subdev_call - call an ops of a v4l2_subdev, doing the right checks
+ *	against NULL pointers.
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
@@ -1048,6 +1100,14 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 		__result;						\
 	})
 
+/**
+ * v4l2_subdev_has_op - Checks if a subdev defines a certain ops.
+ *
+ * @sd: pointer to the &struct v4l2_subdev
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of callbacks functions.
+ * @f: callback function to be checked for its existence.
+ */
 #define v4l2_subdev_has_op(sd, o, f) \
 	((sd)->ops->o && (sd)->ops->o->f)
 
-- 
2.13.6
