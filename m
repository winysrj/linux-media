Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40081 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2AOSNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 13:13:09 -0500
Received: from localhost.localdomain (unknown [91.178.228.121])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 395B135A9D
	for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 18:13:08 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 1/3] v4l: Add custom compat_ioctl32 operation
Date: Sun, 15 Jan 2012 19:13:11 +0100
Message-Id: <1326651193-12055-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1326651193-12055-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1326651193-12055-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers implementing custom ioctls need to handle 32-bit/64-bit
compatibility themselves. Provide them with a way to do so.

To avoid circular module dependencies, merge the v4l2-compat-ioctl32
module into videodev. There is no point in keeping them separate, as the
v4l2_compat_ioctl32() function is required by videodev if CONFIG_COMPAT
is set anyway.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Makefile              |    7 +++----
 drivers/media/video/v4l2-compat-ioctl32.c |   20 +++++++++++---------
 include/media/v4l2-dev.h                  |    3 +++
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 3541388..9f33a95 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -12,14 +12,13 @@ omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
 			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
+ifeq ($(CONFIG_COMPAT),y)
+  videodev-objs += v4l2-compat-ioctl32.o
+endif
 
 # V4L2 core modules
 
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
-ifeq ($(CONFIG_COMPAT),y)
-  obj-$(CONFIG_VIDEO_DEV) += v4l2-compat-ioctl32.o
-endif
-
 obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
 
 # All i2c modules must come first:
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index af4419e..06328fa 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -14,12 +14,11 @@
  */
 
 #include <linux/compat.h>
-#include <linux/videodev2.h>
 #include <linux/module.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 
-#ifdef CONFIG_COMPAT
-
 static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret = -ENOIOCTLCMD;
@@ -937,6 +936,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 
 long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct video_device *vdev = video_devdata(file);
 	long ret = -ENOIOCTLCMD;
 
 	if (!file->f_op->unlocked_ioctl)
@@ -1025,14 +1025,16 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 
 	default:
-		printk(KERN_WARNING "compat_ioctl32: "
-			"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
-			_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
+		if (vdev->fops->compat_ioctl32)
+			ret = vdev->fops->compat_ioctl32(file, cmd, arg);
+
+		if (ret == -ENOIOCTLCMD)
+			printk(KERN_WARNING "compat_ioctl32: "
+				"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
+				_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd),
+				cmd);
 		break;
 	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_compat_ioctl32);
-#endif
-
-MODULE_LICENSE("GPL");
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index c7c40f1..96d2221 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -62,6 +62,9 @@ struct v4l2_file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
+#ifdef CONFIG_COMPAT
+	long (*compat_ioctl32) (struct file *, unsigned int, unsigned long);
+#endif
 	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
 				unsigned long, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
-- 
1.7.3.4

