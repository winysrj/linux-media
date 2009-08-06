Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37592 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZHFPHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 11:07:40 -0400
Received: from ravenclaw.localnet (unknown [192.100.124.156])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 0039835B38
	for <linux-media@vger.kernel.org>; Thu,  6 Aug 2009 17:07:39 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH,RFC] Drop non-unlocked ioctl support in v4l2-dev.c
Date: Thu, 6 Aug 2009 17:09:40 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908061709.41211.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

this patch moves the BKL one level down by removing the non-unlocked ioctl in
v4l2-dev.c and calling lock_kernel/unlock_kernel in the unlocked_ioctl handler
if the driver only supports locked ioctl.

Opinions/comments/applause/kicks ?

Regards,

Laurent Pinchart

diff -r 4533a406fddb linux/drivers/media/video/v4l2-dev.c
--- a/linux/drivers/media/video/v4l2-dev.c	Thu Aug 06 16:41:17 2009 +0200
+++ b/linux/drivers/media/video/v4l2-dev.c	Thu Aug 06 17:04:37 2009 +0200
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
@@ -211,28 +212,22 @@
 	return vdev->fops->poll(filp, poll);
 }
 
-static int v4l2_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg)
-{
-	struct video_device *vdev = video_devdata(filp);
-
-	if (!vdev->fops->ioctl)
-		return -ENOTTY;
-	/* Allow ioctl to continue even if the device was unregistered.
-	   Things like dequeueing buffers might still be useful. */
-	return vdev->fops->ioctl(filp, cmd, arg);
-}
-
 static long v4l2_unlocked_ioctl(struct file *filp,
 		unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vdev = video_devdata(filp);
+	int ret = -ENOTTY;
 
-	if (!vdev->fops->unlocked_ioctl)
-		return -ENOTTY;
 	/* Allow ioctl to continue even if the device was unregistered.
 	   Things like dequeueing buffers might still be useful. */
-	return vdev->fops->unlocked_ioctl(filp, cmd, arg);
+	if (vdev->fops->ioctl) {
+		lock_kernel();
+		ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
+		unlock_kernel();
+	} else if (vdev->fops->unlocked_ioctl)
+		ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
+
+	return ret;
 }
 
 #ifdef CONFIG_MMU
@@ -320,22 +315,6 @@
 	.llseek = no_llseek,
 };
 
-static const struct file_operations v4l2_fops = {
-	.owner = THIS_MODULE,
-	.read = v4l2_read,
-	.write = v4l2_write,
-	.open = v4l2_open,
-	.get_unmapped_area = v4l2_get_unmapped_area,
-	.mmap = v4l2_mmap,
-	.ioctl = v4l2_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = v4l2_compat_ioctl32,
-#endif
-	.release = v4l2_release,
-	.poll = v4l2_poll,
-	.llseek = no_llseek,
-};
-
 /**
  * get_index - assign stream number based on parent device
  * @vdev: video_device to assign index number to, vdev->parent should be assigned
@@ -534,15 +513,9 @@
 		goto cleanup;
 	}
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 17)
-	if (vdev->fops->unlocked_ioctl)
-		vdev->cdev->ops = &v4l2_unlocked_fops;
-	else
-		vdev->cdev->ops = &v4l2_fops;
+	vdev->cdev->ops = &v4l2_unlocked_fops;
 #else
-	if (vdev->fops->unlocked_ioctl)
-		vdev->cdev->ops = (struct file_operations *)&v4l2_unlocked_fops;
-	else
-		vdev->cdev->ops = (struct file_operations *)&v4l2_fops;
+	vdev->cdev->ops = (struct file_operations *)&v4l2_unlocked_fops;
 #endif
 	vdev->cdev->owner = vdev->fops->owner;
 	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);

