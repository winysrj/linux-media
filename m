Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42366 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab0GLP0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 11:26:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v3 4/7] v4l: subdev: Add device node support
Date: Mon, 12 Jul 2010 17:25:49 +0200
Message-Id: <1278948352-17892-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a device node named subdevX for every registered subdev.

As the device node is registered before the subdev core::s_config
function is called, return -EGAIN on open until initialization
completes.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
---
 Documentation/video4linux/v4l2-framework.txt |   18 +++++++
 drivers/media/radio/radio-si4713.c           |    2 +-
 drivers/media/video/Makefile                 |    2 +-
 drivers/media/video/soc_camera.c             |    2 +-
 drivers/media/video/v4l2-common.c            |   15 +++++-
 drivers/media/video/v4l2-dev.c               |   27 ++++------
 drivers/media/video/v4l2-device.c            |   25 +++++++++-
 drivers/media/video/v4l2-ioctl.c             |    2 +-
 drivers/media/video/v4l2-subdev.c            |   65 ++++++++++++++++++++++++++
 include/media/v4l2-common.h                  |    6 ++-
 include/media/v4l2-dev.h                     |   18 ++++++-
 include/media/v4l2-ioctl.h                   |    3 +
 include/media/v4l2-subdev.h                  |   16 ++++++-
 13 files changed, 170 insertions(+), 31 deletions(-)
 create mode 100644 drivers/media/video/v4l2-subdev.c

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index e831aac..164bb0f 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -314,6 +314,24 @@ controlled through GPIO pins. This distinction is only relevant when setting
 up the device, but once the subdev is registered it is completely transparent.
 
 
+V4L2 sub-device userspace API
+-----------------------------
+
+Beside exposing a kernel API through the v4l2_subdev_ops structure, V4L2
+sub-devices can also be controlled directly by userspace applications.
+
+When a sub-device is registered, a device node named v4l-subdevX can be created
+in /dev. If the sub-device supports direct userspace configuration it must set
+the V4L2_SUBDEV_FL_HAS_DEVNODE flag before being registered.
+
+For I2C and SPI sub-devices, the v4l2_device driver can disable registration of
+the device node if it wants to control the sub-device on its own. In that case
+it must set the v4l2_i2c_new_subdev_board or v4l2_spi_new_subdev enable_devnode
+argument to 0. Setting the argument to 1 will only enable device node
+registration if the sub-device driver has set the V4L2_SUBDEV_FL_HAS_DEVNODE
+flag.
+
+
 I2C sub-device drivers
 ----------------------
 
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 13554ab..58dd199 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -292,7 +292,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	}
 
 	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter, "si4713_i2c",
-					pdata->subdev_board_info, NULL);
+					pdata->subdev_board_info, NULL, 0);
 	if (!sd) {
 		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
 		rval = -ENODEV;
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
 
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 475757b..10fae27 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -895,7 +895,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 	icl->board_info->platform_data = icd;
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
-				icl->module_name, icl->board_info, NULL);
+				icl->module_name, icl->board_info, NULL, 0);
 	if (!subdev)
 		goto ei2cnd;
 
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index bbda421..4265562 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -838,7 +838,8 @@ EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 /* Load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, const char *module_name,
-		struct i2c_board_info *info, const unsigned short *probe_addrs)
+		struct i2c_board_info *info, const unsigned short *probe_addrs,
+		int enable_devnode)
 {
 	struct v4l2_subdev *sd = NULL;
 	struct i2c_client *client;
@@ -868,9 +869,12 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 	if (!try_module_get(client->driver->driver.owner))
 		goto error;
 	sd = i2c_get_clientdata(client);
+	if (!enable_devnode)
+		sd->flags &= ~V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	/* Register with the v4l2_device which increases the module's
 	   use count as well. */
+	sd->initialized = 0;
 	if (v4l2_device_register_subdev(v4l2_dev, sd))
 		sd = NULL;
 	/* Decrease the module use count to match the first try_module_get. */
@@ -885,6 +889,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 		if (err && err != -ENOIOCTLCMD) {
 			v4l2_device_unregister_subdev(sd);
 			sd = NULL;
+		} else {
+			sd->initialized = 1;
 		}
 	}
 
@@ -911,7 +917,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 	info.addr = addr;
 
 	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, module_name,
-			&info, probe_addrs);
+			&info, probe_addrs, 0);
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
 
@@ -981,7 +987,8 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
 EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
 
 struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
-		struct spi_master *master, struct spi_board_info *info)
+		struct spi_master *master, struct spi_board_info *info,
+		int enable_devnode)
 {
 	struct v4l2_subdev *sd = NULL;
 	struct spi_device *spi = NULL;
@@ -1000,6 +1007,8 @@ struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
 		goto error;
 
 	sd = spi_get_drvdata(spi);
+	if (!enable_devnode)
+		sd->flags &= ~V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	/* Register with the v4l2_device which increases the module's
 	   use count as well. */
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7ec9..bcd47a0 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -376,13 +376,14 @@ static int get_index(struct video_device *vdev)
 }
 
 /**
- *	video_register_device - register video4linux devices
+ *	__video_register_device - register video4linux devices
  *	@vdev: video device structure we want to register
  *	@type: type of device to register
  *	@nr:   which device node number (0 == /dev/video0, 1 == /dev/video1, ...
  *             -1 == first free)
  *	@warn_if_nr_in_use: warn if the desired device node number
  *	       was already in use and another number was chosen instead.
+ *	@owner: module that owns the video device node
  *
  *	The registration code assigns minor numbers and device node numbers
  *	based on the requested type and registers the new device node with
@@ -401,9 +402,11 @@ static int get_index(struct video_device *vdev)
  *	%VFL_TYPE_VBI - Vertical blank data (undecoded)
  *
  *	%VFL_TYPE_RADIO - A radio card
+ *
+ *	%VFL_TYPE_SUBDEV - A subdevice
  */
-static int __video_register_device(struct video_device *vdev, int type, int nr,
-		int warn_if_nr_in_use)
+int __video_register_device(struct video_device *vdev, int type, int nr,
+		int warn_if_nr_in_use, struct module *owner)
 {
 	int i = 0;
 	int ret;
@@ -439,6 +442,9 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	case VFL_TYPE_RADIO:
 		name_base = "radio";
 		break;
+	case VFL_TYPE_SUBDEV:
+		name_base = "v4l-subdev";
+		break;
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
@@ -525,7 +531,7 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 		vdev->cdev->ops = &v4l2_unlocked_fops;
 	else
 		vdev->cdev->ops = &v4l2_fops;
-	vdev->cdev->owner = vdev->fops->owner;
+	vdev->cdev->owner = owner;
 	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: cdev_add failed\n", __func__);
@@ -574,18 +580,7 @@ cleanup:
 	vdev->minor = -1;
 	return ret;
 }
-
-int video_register_device(struct video_device *vdev, int type, int nr)
-{
-	return __video_register_device(vdev, type, nr, 1);
-}
-EXPORT_SYMBOL(video_register_device);
-
-int video_register_device_no_warn(struct video_device *vdev, int type, int nr)
-{
-	return __video_register_device(vdev, type, nr, 0);
-}
-EXPORT_SYMBOL(video_register_device_no_warn);
+EXPORT_SYMBOL(__video_register_device);
 
 /**
  *	video_unregister_device - unregister a video4linux device
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 5a7dc4a..b287aaa 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -115,18 +115,38 @@ EXPORT_SYMBOL_GPL(v4l2_device_unregister);
 int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 						struct v4l2_subdev *sd)
 {
+	struct video_device *vdev;
+	int ret = 0;
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
+	strlcpy(vdev->name, sd->name, sizeof(vdev->name));
+	vdev->parent = v4l2_dev->dev;
+	vdev->fops = &v4l2_subdev_fops;
+	vdev->release = video_device_release_empty;
+	if (sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE) {
+		ret = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
+					      sd->owner);
+		if (ret < 0)
+			v4l2_device_unregister_subdev(sd);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
@@ -135,10 +155,13 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
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
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 486eaba..e49ace8 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -412,7 +412,7 @@ static unsigned long cmd_input_size(unsigned int cmd)
 	}
 }
 
-static long
+long
 __video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		v4l2_kioctl func)
 {
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
new file mode 100644
index 0000000..424c9c2
--- /dev/null
+++ b/drivers/media/video/v4l2-subdev.c
@@ -0,0 +1,65 @@
+/*
+ *  V4L2 subdevice support.
+ *
+ *  Copyright (C) 2010  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
+	return __video_usercopy(file, cmd, arg, subdev_do_ioctl);
+}
+
+const struct v4l2_file_operations v4l2_subdev_fops = {
+	.owner = THIS_MODULE,
+	.open = subdev_open,
+	.unlocked_ioctl = subdev_ioctl,
+	.release = subdev_close,
+};
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 6fc3d7a..496d158 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -148,7 +148,8 @@ struct i2c_board_info;
 
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, const char *module_name,
-		struct i2c_board_info *info, const unsigned short *probe_addrs);
+		struct i2c_board_info *info, const unsigned short *probe_addrs,
+		int enable_devnode);
 
 /* Initialize an v4l2_subdev with data from an i2c_client struct */
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
@@ -181,7 +182,8 @@ struct spi_device;
 /* Load an spi module and return an initialized v4l2_subdev struct.
    The client_type argument is the name of the chip that's on the adapter. */
 struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
-		struct spi_master *master, struct spi_board_info *info);
+		struct spi_master *master, struct spi_board_info *info,
+		int enable_devnode);
 
 /* Initialize an v4l2_subdev with data from an spi_device struct */
 void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index bebe44b..195fa56 100644
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
@@ -98,15 +99,26 @@ struct video_device
 /* dev to video-device */
 #define to_video_device(cd) container_of(cd, struct video_device, dev)
 
+int __must_check __video_register_device(struct video_device *vdev, int type,
+		int nr, int warn_if_nr_in_use, struct module *owner);
+
 /* Register video devices. Note that if video_register_device fails,
    the release() callback of the video_device structure is *not* called, so
    the caller is responsible for freeing any data. Usually that means that
    you call video_device_release() on failure. */
-int __must_check video_register_device(struct video_device *vdev, int type, int nr);
+static inline int __must_check video_register_device(struct video_device *vdev,
+		int type, int nr)
+{
+	return __video_register_device(vdev, type, nr, 1, vdev->fops->owner);
+}
 
 /* Same as video_register_device, but no warning is issued if the desired
    device node number was already in use. */
-int __must_check video_register_device_no_warn(struct video_device *vdev, int type, int nr);
+static inline int __must_check video_register_device_no_warn(
+		struct video_device *vdev, int type, int nr)
+{
+	return __video_register_device(vdev, type, nr, 0, vdev->fops->owner);
+}
 
 /* Unregister video devices. Will do nothing if vdev == NULL or
    video_is_registered() returns false. */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 06daa6e..abb64d0 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -316,6 +316,9 @@ extern long v4l2_compat_ioctl32(struct file *file, unsigned int cmd,
 				unsigned long arg);
 #endif
 
+extern long __video_usercopy(struct file *file, unsigned int cmd,
+				unsigned long arg, v4l2_kioctl func);
+
 /* Include support for obsoleted stuff */
 extern long video_usercopy(struct file *file, unsigned int cmd,
 				unsigned long arg, v4l2_kioctl func);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 6088316..dc0ccd3 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -22,6 +22,7 @@
 #define _V4L2_SUBDEV_H
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
 #include <media/v4l2-mediabus.h>
 
 /* generic v4l2_device notify callback notification values */
@@ -402,9 +403,11 @@ struct v4l2_subdev_ops {
 #define V4L2_SUBDEV_NAME_SIZE 32
 
 /* Set this flag if this subdev is a i2c device. */
-#define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+#define V4L2_SUBDEV_FL_IS_I2C			(1U << 0)
 /* Set this flag if this subdev is a spi device. */
-#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
+#define V4L2_SUBDEV_FL_IS_SPI			(1U << 1)
+/* Set this flag if this subdev needs a device node. */
+#define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.
@@ -421,8 +424,16 @@ struct v4l2_subdev {
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
@@ -444,6 +455,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
 	sd->name[0] = '\0';
 	sd->grp_id = 0;
 	sd->priv = NULL;
+	sd->initialized = 1;
 }
 
 /* Call an ops of a v4l2_subdev, doing the right checks against
-- 
1.7.1

