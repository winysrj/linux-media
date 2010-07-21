Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46861 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0GUOmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:42:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v2 06/12] v4l: Add subdev userspace API to enumerate and configure frame interval
Date: Wed, 21 Jul 2010 16:41:53 +0200
Message-Id: <1279723318-28943-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The three new ioctl VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL,
VIDIOC_SUBDEV_G_FRAME_INTERVAL and VIDIOC_SUBDEV_S_FRAME_INTERVAL can be
used to enumerate and configure a subdev's frame rate from userspace.

Two new video::g/s_frame_interval subdev operations are introduced to
support those ioctls. The existing video::g/s_parm operations are
deprecated and shouldn't be used anymore.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-subdev.c |   16 ++++++++++++++++
 include/linux/v4l2-subdev.h       |   24 ++++++++++++++++++++++++
 include/media/v4l2-subdev.h       |    7 +++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index d8b261f..8ddb2fb 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -208,6 +208,22 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 					fse);
 	}
 
+	case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
+		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
+
+	case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
+		return v4l2_subdev_call(sd, video, s_frame_interval, arg);
+
+	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL: {
+		struct v4l2_subdev_frame_interval_enum *fie = arg;
+
+		if (fie->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, enum_frame_interval, subdev_fh,
+					fie);
+	}
+
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index 6504f22..e3362aa 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -56,11 +56,35 @@ struct v4l2_subdev_frame_size_enum {
 	__u32 reserved[9];
 };
 
+/**
+ * struct v4l2_subdev_pad_frame_rate
+ */
+struct v4l2_subdev_frame_interval {
+	struct v4l2_fract interval;
+	__u32 reserved[6];
+};
+
+struct v4l2_subdev_frame_interval_enum {
+	__u32 index;
+	__u32 pad;
+	__u32 code;
+	__u32 width;
+	__u32 height;
+	struct v4l2_fract interval;
+	__u32 reserved[9];
+};
+
 #define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_pad_format)
 #define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_pad_format)
+#define VIDIOC_SUBDEV_G_FRAME_INTERVAL \
+			_IOWR('V', 6, struct v4l2_subdev_frame_interval)
+#define VIDIOC_SUBDEV_S_FRAME_INTERVAL \
+			_IOWR('V', 7, struct v4l2_subdev_frame_interval)
 #define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
 			_IOWR('V', 8, struct v4l2_subdev_pad_mbus_code_enum)
 #define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
 			_IOWR('V', 9, struct v4l2_subdev_frame_size_enum)
+#define VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
+			_IOWR('V', 10, struct v4l2_subdev_frame_interval_enum)
 
 #endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index acbcd8f..58ef923 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -245,6 +245,10 @@ struct v4l2_subdev_video_ops {
 	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
+	int (*g_frame_interval)(struct v4l2_subdev *sd,
+				struct v4l2_subdev_frame_interval *interval);
+	int (*s_frame_interval)(struct v4l2_subdev *sd,
+				struct v4l2_subdev_frame_interval *interval);
 	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
 	int (*enum_dv_presets) (struct v4l2_subdev *sd,
@@ -406,6 +410,9 @@ struct v4l2_subdev_pad_ops {
 	int (*enum_frame_size)(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_fh *fh,
 			       struct v4l2_subdev_frame_size_enum *fse);
+	int (*enum_frame_interval)(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_interval_enum *fie);
 	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		       enum v4l2_subdev_format which);
-- 
1.7.1

