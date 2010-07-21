Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46863 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab0GUOmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:42:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	Antti Koskipaa <antti.koskipaa@nokia.com>
Subject: [SAMPLE v2 07/12] v4l: Add crop ioctl to V4L2 subdev API
Date: Wed, 21 Jul 2010 16:41:54 +0200
Message-Id: <1279723318-28943-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Koskipaa <antti.koskipaa@nokia.com>

This patch adds the VIDIOC_SUBDEV_S_CROP and G_CROP ioctls to the
userland API. CROPCAP is not implemented because it's redundant.

Signed-off-by: Antti Koskipaa <antti.koskipaa@nokia.com>
---
 drivers/media/video/v4l2-subdev.c |   36 ++++++++++++++++++++++++++++++++++--
 include/linux/v4l2-subdev.h       |   12 ++++++++++++
 include/media/v4l2-subdev.h       |   11 +++++++++++
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 8ddb2fb..ad4b95e 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -30,11 +30,16 @@
 
 static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
 {
-	fh->probe_fmt = kzalloc(sizeof(*fh->probe_fmt) *
-				sd->entity.num_pads, GFP_KERNEL);
+	/* Allocate probe format and crop in the same memory block */
+	fh->probe_fmt = kzalloc((sizeof(*fh->probe_fmt) +
+				sizeof(*fh->probe_crop)) * sd->entity.num_pads,
+				GFP_KERNEL);
 	if (fh->probe_fmt == NULL)
 		return -ENOMEM;
 
+	fh->probe_crop = (struct v4l2_rect *)
+		(fh->probe_fmt + sd->entity.num_pads);
+
 	return 0;
 }
 
@@ -42,6 +47,7 @@ static void subdev_fh_free(struct v4l2_subdev_fh *fh)
 {
 	kfree(fh->probe_fmt);
 	fh->probe_fmt = NULL;
+	fh->probe_crop = NULL;
 }
 
 static int subdev_open(struct file *file)
@@ -188,6 +194,32 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 					format->which);
 	}
 
+	case VIDIOC_SUBDEV_G_CROP: {
+		struct v4l2_subdev_pad_crop *crop = arg;
+
+		if (crop->which != V4L2_SUBDEV_FORMAT_PROBE &&
+		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (crop->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
+	}
+
+	case VIDIOC_SUBDEV_S_CROP: {
+		struct v4l2_subdev_pad_crop *crop = arg;
+
+		if (crop->which != V4L2_SUBDEV_FORMAT_PROBE &&
+		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (crop->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
+	}
+
 	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
 		struct v4l2_subdev_pad_mbus_code_enum *code = arg;
 
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index e3362aa..5738e81 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -36,6 +36,16 @@ struct v4l2_subdev_pad_format {
 };
 
 /**
+ * struct v4l2_subdev_pad_crop
+ */
+struct v4l2_subdev_pad_crop {
+	__u32 pad;
+	__u32 which;
+	struct v4l2_rect rect;
+	__u32 reserved[10];
+};
+
+/**
  * struct v4l2_subdev_pad_mbus_code_enum
  */
 struct v4l2_subdev_pad_mbus_code_enum {
@@ -86,5 +96,7 @@ struct v4l2_subdev_frame_interval_enum {
 			_IOWR('V', 9, struct v4l2_subdev_frame_size_enum)
 #define VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
 			_IOWR('V', 10, struct v4l2_subdev_frame_interval_enum)
+#define VIDIOC_SUBDEV_S_CROP	_IOWR('V', 11, struct v4l2_subdev_pad_crop)
+#define VIDIOC_SUBDEV_G_CROP	_IOWR('V', 12, struct v4l2_subdev_pad_crop)
 
 #endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 58ef923..41183ab 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -419,6 +419,10 @@ struct v4l2_subdev_pad_ops {
 	int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		       enum v4l2_subdev_format which);
+	int (*set_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_pad_crop *crop);
+	int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_pad_crop *crop);
 };
 
 struct v4l2_subdev_ops {
@@ -478,6 +482,7 @@ struct v4l2_subdev {
 struct v4l2_subdev_fh {
 	struct v4l2_fh vfh;
 	struct v4l2_mbus_framefmt *probe_fmt;
+	struct v4l2_rect *probe_crop;
 };
 
 #define to_v4l2_subdev_fh(fh)	\
@@ -489,6 +494,12 @@ v4l2_subdev_get_probe_format(struct v4l2_subdev_fh *fh, unsigned int pad)
 	return &fh->probe_fmt[pad];
 }
 
+static inline struct v4l2_rect *
+v4l2_subdev_get_probe_crop(struct v4l2_subdev_fh *fh, unsigned int pad)
+{
+	return &fh->probe_crop[pad];
+}
+
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
 static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
-- 
1.7.1

