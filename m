Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:38125 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbbEFG5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 1/8] v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
Date: Wed,  6 May 2015 08:57:16 +0200
Message-Id: <1430895443-41839-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While normal video/radio/vbi/swradio nodes have a proper QUERYCAP ioctl
that apps can call to determine that it is indeed a V4L2 device, there
is currently no equivalent for v4l-subdev nodes. Adding this ioctl will
solve that, and it will allow utilities like v4l2-compliance to be used
with these devices as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 14 ++++++++++++++
 include/uapi/linux/v4l2-subdev.h      | 10 ++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 6359606..50ada27 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/export.h>
+#include <linux/version.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -187,6 +188,19 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 #endif
 
 	switch (cmd) {
+	case VIDIOC_SUBDEV_QUERYCAP: {
+		struct v4l2_subdev_capability *cap = arg;
+
+		cap->version = LINUX_VERSION_CODE;
+		cap->device_caps = 0;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		if (sd->entity.parent)
+			cap->device_caps = V4L2_SUBDEV_CAP_ENTITY;
+#endif
+		memset(cap->reserved, 0, sizeof(cap->reserved));
+		break;
+	}
+
 	case VIDIOC_QUERYCTRL:
 		return v4l2_queryctrl(vfh->ctrl_handler, arg);
 
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index dbce2b5..1848b74 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -154,9 +154,19 @@ struct v4l2_subdev_selection {
 	__u32 reserved[8];
 };
 
+struct v4l2_subdev_capability {
+	__u32 version;
+	__u32 device_caps;
+	__u32 reserved[50];
+};
+
+/* This v4l2_subdev is also a media entity and the entity_id field is valid */
+#define V4L2_SUBDEV_CAP_ENTITY		(1 << 0)
+
 /* Backwards compatibility define --- to be removed */
 #define v4l2_subdev_edid v4l2_edid
 
+#define VIDIOC_SUBDEV_QUERYCAP			 _IOR('V',  0, struct v4l2_subdev_capability)
 #define VIDIOC_SUBDEV_G_FMT			_IOWR('V',  4, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_S_FMT			_IOWR('V',  5, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_G_FRAME_INTERVAL		_IOWR('V', 21, struct v4l2_subdev_frame_interval)
-- 
2.1.4

