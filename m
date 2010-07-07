Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50316 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab0GGLxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 07:53:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 2/6] v4l: subdev: Add device node support
Date: Wed,  7 Jul 2010 13:53:24 +0200
Message-Id: <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a device node named subdevX for every registered subdev.

As the device node is registered before the subdev core::s_config
function is called, return -EGAIN on open until initialization
completes.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
---
 drivers/media/video/Makefile      |    2 +-
 drivers/media/video/v4l2-common.c |    3 ++
 drivers/media/video/v4l2-dev.c    |    5 +++
 drivers/media/video/v4l2-device.c |   27 +++++++++++++++-
 drivers/media/video/v4l2-subdev.c |   65 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-dev.h          |    3 +-
 include/media/v4l2-subdev.h       |   10 ++++++
 7 files changed, 112 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/video/v4l2-subdev.c

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index cc93859..c9c07e5 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -11,7 +11,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
-			v4l2-event.o
+			v4l2-event.o v4l2-subdev.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 4e53b0b..3032aa3 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -871,6 +871,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 
 	/* Register with the v4l2_device which increases the module's
 	   use count as well. */
+	sd->initialized = 0;
 	if (v4l2_device_register_subdev(v4l2_dev, sd))
 		sd = NULL;
 	/* Decrease the module use count to match the first try_module_get. */
@@ -885,6 +886,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 		if (err && err != -ENOIOCTLCMD) {
 			v4l2_device_unregister_subdev(sd);
 			sd = NULL;
+		} else {
+			sd->initialized = 1;
 		}
 	}
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7ec9..5a9e9df 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -401,6 +401,8 @@ static int get_index(struct video_device *vdev)
  *	%VFL_TYPE_VBI - Vertical blank data (undecoded)
  *
  *	%VFL_TYPE_RADIO - A radio card
+ *
+ *	%VFL_TYPE_SUBDEV - A subdevice
  */
 static int __video_register_device(struct video_device *vdev, int type, int nr,
 		int warn_if_nr_in_use)
@@ -439,6 +441,9 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	case VFL_TYPE_RADIO:
 		name_base = "radio";
 		break;
+	case VFL_TYPE_SUBDEV:
+		name_base = "subdev";
+		break;
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 5a7dc4a..685fa82 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -115,18 +115,40 @@ EXPORT_SYMBOL_GPL(v4l2_device_unregister);
 int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 						struct v4l2_subdev *sd)
 {
+	struct video_device *vdev;
+	int ret;
+
 	/* Check for valid input */
 	if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
 		return -EINVAL;
+
 	/* Warn if we apparently re-register a subdev */
 	WARN_ON(sd->v4l2_dev != NULL);
+
 	if (!try_module_get(sd->owner))
 		return -ENODEV;
+
 	sd->v4l2_dev = v4l2_dev;
 	spin_lock(&v4l2_dev->lock);
 	list_add_tail(&sd->list, &v4l2_dev->subdevs);
 	spin_unlock(&v4l2_dev->lock);
-	return 0;
+
+	/* Register the device node. */
+	vdev = &sd->devnode;
+	snprintf(vdev->name, sizeof(vdev->name), "subdev");
+	vdev->parent = v4l2_dev->dev;
+	vdev->fops = &v4l2_subdev_fops;
+	vdev->release = video_device_release_empty;
+	ret = video_register_device(vdev, VFL_TYPE_SUBDEV, -1);
+	if (ret < 0) {
+		spin_lock(&v4l2_dev->lock);
+		list_del(&sd->list);
+		spin_unlock(&v4l2_dev->lock);
+		sd->v4l2_dev = NULL;
+		module_put(sd->owner);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
@@ -135,10 +157,13 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	/* return if it isn't registered */
 	if (sd == NULL || sd->v4l2_dev == NULL)
 		return;
+
 	spin_lock(&sd->v4l2_dev->lock);
 	list_del(&sd->list);
 	spin_unlock(&sd->v4l2_dev->lock);
 	sd->v4l2_dev = NULL;
+
 	module_put(sd->owner);
+	video_unregister_device(&sd->devnode);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
new file mode 100644
index 0000000..a048161
--- /dev/null
+++ b/drivers/media/video/v4l2-subdev.c
@@ -0,0 +1,65 @@
+/*
+ *  V4L2 subdevice support.
+ *
+ *  Copyright (C) 2009  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+
+static int subdev_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
+
+	if (!sd->initialized)
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int subdev_close(struct file *file)
+{
+	return 0;
+}
+
+static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
+{
+	switch (cmd) {
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
+static long subdev_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
+}
+
+const struct v4l2_file_operations v4l2_subdev_fops = {
+	.owner = THIS_MODULE,
+	.open = subdev_open,
+	.unlocked_ioctl = subdev_ioctl,
+	.release = subdev_close,
+};
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index bebe44b..eee1e2b 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -22,7 +22,8 @@
 #define VFL_TYPE_VBI		1
 #define VFL_TYPE_RADIO		2
 #define VFL_TYPE_VTX		3
-#define VFL_TYPE_MAX		4
+#define VFL_TYPE_SUBDEV		4
+#define VFL_TYPE_MAX		5
 
 struct v4l2_ioctl_callbacks;
 struct video_device;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 6088316..00010bd 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -22,6 +22,7 @@
 #define _V4L2_SUBDEV_H
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
 #include <media/v4l2-mediabus.h>
 
 /* generic v4l2_device notify callback notification values */
@@ -421,8 +422,16 @@ struct v4l2_subdev {
 	u32 grp_id;
 	/* pointer to private data */
 	void *priv;
+	/* subdev device node */
+	struct video_device devnode;
+	unsigned int initialized;
 };
 
+#define vdev_to_v4l2_subdev(vdev) \
+	container_of(vdev, struct v4l2_subdev, devnode)
+
+extern const struct v4l2_file_operations v4l2_subdev_fops;
+
 static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
 {
 	sd->priv = p;
@@ -444,6 +453,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
 	sd->name[0] = '\0';
 	sd->grp_id = 0;
 	sd->priv = NULL;
+	sd->initialized = 0;
 }
 
 /* Call an ops of a v4l2_subdev, doing the right checks against
-- 
1.7.1

