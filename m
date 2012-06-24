Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3296 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2FXL3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/26] usbvision: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:25:56 +0200
Message-Id: <76823a2f9c23a9fba29370d1fae9d8c072e6548c.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/usbvision/usbvision-video.c |   42 +++++++++++++++++++----
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 9bd8f08..8a43179 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -349,6 +349,8 @@ static int usbvision_v4l2_open(struct file *file)
 
 	PDEBUG(DBG_IO, "open");
 
+	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
+		return -ERESTARTSYS;
 	usbvision_reset_power_off_timer(usbvision);
 
 	if (usbvision->user)
@@ -402,6 +404,7 @@ static int usbvision_v4l2_open(struct file *file)
 
 	/* prepare queues */
 	usbvision_empty_framequeues(usbvision);
+	mutex_unlock(&usbvision->v4l2_lock);
 
 	PDEBUG(DBG_IO, "success");
 	return err_code;
@@ -421,6 +424,7 @@ static int usbvision_v4l2_close(struct file *file)
 
 	PDEBUG(DBG_IO, "close");
 
+	mutex_lock(&usbvision->v4l2_lock);
 	usbvision_audio_off(usbvision);
 	usbvision_restart_isoc(usbvision);
 	usbvision_stop_isoc(usbvision);
@@ -443,6 +447,7 @@ static int usbvision_v4l2_close(struct file *file)
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
 	}
+	mutex_unlock(&usbvision->v4l2_lock);
 
 	PDEBUG(DBG_IO, "success");
 	return 0;
@@ -956,7 +961,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static ssize_t usbvision_v4l2_read(struct file *file, char __user *buf,
+static ssize_t usbvision_read(struct file *file, char __user *buf,
 		      size_t count, loff_t *ppos)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
@@ -1060,7 +1065,20 @@ static ssize_t usbvision_v4l2_read(struct file *file, char __user *buf,
 	return count;
 }
 
-static int usbvision_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
+static ssize_t usbvision_v4l2_read(struct file *file, char __user *buf,
+		      size_t count, loff_t *ppos)
+{
+	struct usb_usbvision *usbvision = video_drvdata(file);
+	int res;
+
+	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
+		return -ERESTARTSYS;
+	res = usbvision_read(file, buf, count, ppos);
+	mutex_unlock(&usbvision->v4l2_lock);
+	return res;
+}
+
+static int usbvision_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	unsigned long size = vma->vm_end - vma->vm_start,
 		start = vma->vm_start;
@@ -1107,6 +1125,17 @@ static int usbvision_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+static int usbvision_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct usb_usbvision *usbvision = video_drvdata(file);
+	int res;
+
+	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
+		return -ERESTARTSYS;
+	res = usbvision_mmap(file, vma);
+	mutex_unlock(&usbvision->v4l2_lock);
+	return res;
+}
 
 /*
  * Here comes the stuff for radio on usbvision based devices
@@ -1119,6 +1148,8 @@ static int usbvision_radio_open(struct file *file)
 
 	PDEBUG(DBG_IO, "%s:", __func__);
 
+	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
+		return -ERESTARTSYS;
 	if (usbvision->user) {
 		dev_err(&usbvision->rdev->dev,
 			"%s: Someone tried to open an already opened USBVision Radio!\n",
@@ -1156,6 +1187,7 @@ static int usbvision_radio_open(struct file *file)
 		}
 	}
 out:
+	mutex_unlock(&usbvision->v4l2_lock);
 	return err_code;
 }
 
@@ -1167,6 +1199,7 @@ static int usbvision_radio_close(struct file *file)
 
 	PDEBUG(DBG_IO, "");
 
+	mutex_lock(&usbvision->v4l2_lock);
 	/* Set packet size to 0 */
 	usbvision->iface_alt = 0;
 	err_code = usb_set_interface(usbvision->dev, usbvision->iface,
@@ -1186,6 +1219,7 @@ static int usbvision_radio_close(struct file *file)
 		usbvision_release(usbvision);
 	}
 
+	mutex_unlock(&usbvision->v4l2_lock);
 	PDEBUG(DBG_IO, "success");
 	return err_code;
 }
@@ -1296,10 +1330,6 @@ static struct video_device *usbvision_vdev_init(struct usb_usbvision *usbvision,
 	if (NULL == vdev)
 		return NULL;
 	*vdev = *vdev_template;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags);
 	vdev->lock = &usbvision->v4l2_lock;
 	vdev->v4l2_dev = &usbvision->v4l2_dev;
 	snprintf(vdev->name, sizeof(vdev->name), "%s", name);
-- 
1.7.10

