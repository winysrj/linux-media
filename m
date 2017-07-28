Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:40814 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751719AbdG1Kwk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 06:52:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/2] v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
Date: Fri, 28 Jul 2017 12:52:30 +0200
Message-Id: <20170728105231.12043-2-hverkuil@xs4all.nl>
In-Reply-To: <20170728105231.12043-1-hverkuil@xs4all.nl>
References: <20170728105231.12043-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While normal video/radio/vbi/swradio nodes have a proper QUERYCAP ioctl
that apps can call to determine that it is indeed a V4L2 device, there
is currently no equivalent for v4l-subdev nodes. Adding this ioctl will
solve that, and it will allow utilities like v4l2-compliance to be used
with these devices as well.

SUBDEV_QUERYCAP currently returns the version and device_caps of the
subdevice. If the subdev is used as part of a media controller, then
it also returns the entity ID and the major and minor numbers of the
media controller device node.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 26 ++++++++++++++++++++++++++
 include/uapi/linux/v4l2-subdev.h      | 29 +++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 43fefa73e0a3..1c7881d0ab08 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -20,8 +20,10 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/kdev_t.h>
 #include <linux/videodev2.h>
 #include <linux/export.h>
+#include <linux/version.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -186,6 +188,30 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 #endif
 
 	switch (cmd) {
+	case VIDIOC_SUBDEV_QUERYCAP: {
+		struct v4l2_subdev_capability *cap = arg;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		struct media_device *mdev = sd->entity.graph_obj.mdev;
+		struct media_devnode *devnode = mdev ? mdev->devnode : NULL;
+#endif
+
+		cap->version = LINUX_VERSION_CODE;
+		cap->device_caps = 0;
+		cap->entity_id = 0;
+		cap->media_node_major = 0;
+		cap->media_node_minor = 0;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		if (devnode) {
+			cap->device_caps = V4L2_SUBDEV_CAP_ENTITY;
+			cap->entity_id = sd->entity.graph_obj.id;
+			cap->media_node_major = MAJOR(devnode->cdev.dev);
+			cap->media_node_minor = MINOR(devnode->cdev.dev);
+		}
+#endif
+		memset(cap->reserved, 0, sizeof(cap->reserved));
+		break;
+	}
+
 	case VIDIOC_QUERYCTRL:
 		return v4l2_queryctrl(vfh->ctrl_handler, arg);
 
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index dbce2b554e02..83e8e68c9dcd 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -154,9 +154,38 @@ struct v4l2_subdev_selection {
 	__u32 reserved[8];
 };
 
+/**
+ * struct v4l2_subdev_capability - subdev capabilities
+ * @version: the kernel version
+ * @device_caps: the subdev capabilities
+ * @entity_id: the entity ID as assigned by the media controller. Only
+ * valid if V4L2_SUBDEV_CAP_ENTITY is set
+ * @media_node_major: the major number of the media controller device node.
+ * Only valid if V4L2_SUBDEV_CAP_ENTITY is set
+ * @media_node_minor: the minor number of the media controller device node.
+ * Only valid if V4L2_SUBDEV_CAP_ENTITY is set
+ * @reserved: for future use, set to zero for now
+ */
+struct v4l2_subdev_capability {
+	__u32 version;
+	__u32 device_caps;
+	__u32 entity_id;
+	/* Corresponding media controller device node specifications */
+	__u32 media_node_major;
+	__u32 media_node_minor;
+	__u32 reserved[27];
+};
+
+/*
+ * This v4l2_subdev is also a media entity and the entity_id, media_node_major
+ * and media_node_minor fields are valid
+ */
+#define V4L2_SUBDEV_CAP_ENTITY		(1 << 0)
+
 /* Backwards compatibility define --- to be removed */
 #define v4l2_subdev_edid v4l2_edid
 
+#define VIDIOC_SUBDEV_QUERYCAP			 _IOR('V',  0, struct v4l2_subdev_capability)
 #define VIDIOC_SUBDEV_G_FMT			_IOWR('V',  4, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_S_FMT			_IOWR('V',  5, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_G_FRAME_INTERVAL		_IOWR('V', 21, struct v4l2_subdev_frame_interval)
-- 
2.13.1
