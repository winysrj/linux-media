Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:35774 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1LTU2N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:13 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com
Subject: [RFC 04/17] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
Date: Tue, 20 Dec 2011 22:27:56 +0200
Message-Id: <1324412889-17961-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4EF0EFC9.6080501@maxwell.research.nokia.com>
References: <4EF0EFC9.6080501@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).

VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/v4l2-subdev.c |   26 ++++++++++++++++++++-
 include/linux/v4l2-subdev.h       |   45 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-subdev.h       |    5 ++++
 3 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 65ade5f..e8ae098 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -36,13 +36,17 @@ static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
 {
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	/* Allocate try format and crop in the same memory block */
-	fh->try_fmt = kzalloc((sizeof(*fh->try_fmt) + sizeof(*fh->try_crop))
+	fh->try_fmt = kzalloc((sizeof(*fh->try_fmt) + sizeof(*fh->try_crop)
+			       + sizeof(*fh->try_compose))
 			      * sd->entity.num_pads, GFP_KERNEL);
 	if (fh->try_fmt == NULL)
 		return -ENOMEM;
 
 	fh->try_crop = (struct v4l2_rect *)
 		(fh->try_fmt + sd->entity.num_pads);
+
+	fh->try_compose = (struct v4l2_rect *)
+		(fh->try_crop + sd->entity.num_pads);
 #endif
 	return 0;
 }
@@ -281,6 +285,26 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_subdev_call(sd, pad, enum_frame_interval, subdev_fh,
 					fie);
 	}
+
+	case VIDIOC_SUBDEV_G_SELECTION: {
+		struct v4l2_subdev_selection *sel = arg;
+
+		if (sel->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(
+			sd, pad, get_selection, subdev_fh, sel);
+	}
+
+	case VIDIOC_SUBDEV_S_SELECTION: {
+		struct v4l2_subdev_selection *sel = arg;
+
+		if (sel->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(
+			sd, pad, set_selection, subdev_fh, sel);
+	}
 #endif
 	default:
 		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index ed29cbb..d53d775 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -123,6 +123,47 @@ struct v4l2_subdev_frame_interval_enum {
 	__u32 reserved[9];
 };
 
+#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE			(1 << 0)
+#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE			(1 << 1)
+#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1 << 2)
+
+/* active cropping area */
+#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0
+/* default cropping area */
+#define V4L2_SUBDEV_SEL_TGT_CROP_DEFAULT		1
+/* cropping bounds */
+#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			2
+/* current composing area */
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		256
+/* default composing area */
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_DEFAULT		257
+/* composing bounds */
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		258
+
+
+/**
+ * struct v4l2_subdev_selection - selection info
+ *
+ * @which: either V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY
+ * @pad: pad number, as reported by the media API
+ * @target: selection target, used to choose one of possible rectangles
+ * @flags: constraints flags
+ * @r: coordinates of selection window
+ * @reserved: for future use, rounds structure size to 64 bytes, set to zero
+ *
+ * Hardware may use multiple helper window to process a video stream.
+ * The structure is used to exchange this selection areas between
+ * an application and a driver.
+ */
+struct v4l2_subdev_selection {
+	__u32 which;
+	__u32 pad;
+	__u32 target;
+	__u32 flags;
+	struct v4l2_rect r;
+	__u32 reserved[8];
+};
+
 #define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_G_FRAME_INTERVAL \
@@ -137,5 +178,9 @@ struct v4l2_subdev_frame_interval_enum {
 			_IOWR('V', 75, struct v4l2_subdev_frame_interval_enum)
 #define VIDIOC_SUBDEV_G_CROP	_IOWR('V', 59, struct v4l2_subdev_crop)
 #define VIDIOC_SUBDEV_S_CROP	_IOWR('V', 60, struct v4l2_subdev_crop)
+#define VIDIOC_SUBDEV_G_SELECTION \
+	_IOWR('V', 61, struct v4l2_subdev_selection)
+#define VIDIOC_SUBDEV_S_SELECTION \
+	_IOWR('V', 62, struct v4l2_subdev_selection)
 
 #endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index f0f3358..26eeaa4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -466,6 +466,10 @@ struct v4l2_subdev_pad_ops {
 		       struct v4l2_subdev_crop *crop);
 	int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		       struct v4l2_subdev_crop *crop);
+	int (*get_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_selection *sel);
+	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_selection *sel);
 };
 
 struct v4l2_subdev_ops {
@@ -551,6 +555,7 @@ struct v4l2_subdev_fh {
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	struct v4l2_mbus_framefmt *try_fmt;
 	struct v4l2_rect *try_crop;
+	struct v4l2_rect *try_compose;
 #endif
 };
 
-- 
1.7.2.5

