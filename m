Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40194 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1LRXzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 18:55:48 -0500
Received: from localhost.localdomain (unknown [91.178.220.210])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5864E35B9F
	for <linux-media@vger.kernel.org>; Sun, 18 Dec 2011 23:55:47 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 1/3] v4l: Add custom compat_ioctl operation
Date: Mon, 19 Dec 2011 00:55:44 +0100
Message-Id: <1324252546-18437-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1324252546-18437-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1324252546-18437-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers implementing custom ioctls need to handle 32-bit/64-bit
compatibility themselves. Provide them with a way to do so.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |   13 ++++++++++---
 include/media/v4l2-dev.h                  |    3 +++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index c68531b..5787e57 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -16,6 +16,7 @@
 #include <linux/compat.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
+#include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 
 #ifdef CONFIG_COMPAT
@@ -937,6 +938,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 
 long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct video_device *vdev = video_devdata(file);
 	long ret = -ENOIOCTLCMD;
 
 	if (!file->f_op->unlocked_ioctl)
@@ -1023,9 +1025,14 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 
 	default:
-		printk(KERN_WARNING "compat_ioctl32: "
-			"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
-			_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
+		if (vdev->fops->compat_ioctl)
+			ret = vdev->fops->compat_ioctl(file, cmd, arg);
+
+		if (ret == -ENOIOCTLCMD)
+			printk(KERN_WARNING "compat_ioctl32: "
+				"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
+				_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd),
+				cmd);
 		break;
 	}
 	return ret;
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index c7c40f1..5d4462c 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -62,6 +62,9 @@ struct v4l2_file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
+#ifdef CONFIG_COMPAT
+	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+#endif
 	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
 				unsigned long, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
-- 
1.7.3.4

