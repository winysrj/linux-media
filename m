Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52764 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0GNOGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 10:06:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE 05/12] v4l: v4l2_subdev userspace format API
Date: Wed, 14 Jul 2010 16:07:07 +0200
Message-Id: <1279116434-28278-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a userspace API to get, set and enumerate the media format on a
subdev pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-subdev.c |   51 ++++++++++++++++++++++++++++
 include/linux/v4l2-subdev.h       |   66 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-subdev.h       |    6 +---
 3 files changed, 118 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/v4l2-subdev.h

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 2fe3818..d8b261f 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -122,6 +122,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
 	struct v4l2_fh *vfh = file->private_data;
+	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
@@ -157,6 +158,56 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
 
+	case VIDIOC_SUBDEV_G_FMT: {
+		struct v4l2_subdev_pad_format *format = arg;
+
+		if (format->which != V4L2_SUBDEV_FORMAT_PROBE &&
+		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (format->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh,
+					format->pad, &format->format,
+					format->which);
+	}
+
+	case VIDIOC_SUBDEV_S_FMT: {
+		struct v4l2_subdev_pad_format *format = arg;
+
+		if (format->which != V4L2_SUBDEV_FORMAT_PROBE &&
+		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (format->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh,
+					format->pad, &format->format,
+					format->which);
+	}
+
+	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
+		struct v4l2_subdev_pad_mbus_code_enum *code = arg;
+
+		if (code->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh,
+					code);
+	}
+
+	case VIDIOC_SUBDEV_ENUM_FRAME_SIZE: {
+		struct v4l2_subdev_frame_size_enum *fse = arg;
+
+		if (fse->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh,
+					fse);
+	}
+
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
new file mode 100644
index 0000000..6504f22
--- /dev/null
+++ b/include/linux/v4l2-subdev.h
@@ -0,0 +1,66 @@
+/*
+ * V4L2 subdev userspace API
+ *
+ * Copyright (C) 2010 Nokia
+ *
+ * Contributors:
+ *	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef __LINUX_V4L2_SUBDEV_H
+#define __LINUX_V4L2_SUBDEV_H
+
+#include <linux/ioctl.h>
+#include <linux/v4l2-mediabus.h>
+
+enum v4l2_subdev_format {
+	V4L2_SUBDEV_FORMAT_PROBE = 0,
+	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
+};
+
+/**
+ * struct v4l2_subdev_pad_format
+ */
+struct v4l2_subdev_pad_format {
+	__u32 which;
+	__u32 pad;
+	struct v4l2_mbus_framefmt format;
+};
+
+/**
+ * struct v4l2_subdev_pad_mbus_code_enum
+ */
+struct v4l2_subdev_pad_mbus_code_enum {
+	__u32 pad;
+	__u32 index;
+	__u32 code;
+	__u32 reserved[5];
+};
+
+struct v4l2_subdev_frame_size_enum {
+	__u32 index;
+	__u32 pad;
+	__u32 code;
+	__u32 min_width;
+	__u32 max_width;
+	__u32 min_height;
+	__u32 max_height;
+	__u32 reserved[9];
+};
+
+#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_pad_format)
+#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_pad_format)
+#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
+			_IOWR('V', 8, struct v4l2_subdev_pad_mbus_code_enum)
+#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
+			_IOWR('V', 9, struct v4l2_subdev_frame_size_enum)
+
+#endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 684ab60..acbcd8f 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_SUBDEV_H
 #define _V4L2_SUBDEV_H
 
+#include <linux/v4l2-subdev.h>
 #include <media/media-entity.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -399,11 +400,6 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
-enum v4l2_subdev_format {
-	V4L2_SUBDEV_FORMAT_PROBE = 0,
-	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
-};
-
 struct v4l2_subdev_pad_ops {
 	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			      struct v4l2_subdev_pad_mbus_code_enum *code);
-- 
1.7.1

