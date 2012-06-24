Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3078 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2FXL3Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:24 -0400
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
Subject: [RFC PATCH 06/26] tm6000: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:25:58 +0200
Message-Id: <2ea98c76651bece62a8d7fba0b3da8f93a121496.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/tm6000/tm6000-video.c |   52 ++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
index f7034df..45ed59c 100644
--- a/drivers/media/video/tm6000/tm6000-video.c
+++ b/drivers/media/video/tm6000/tm6000-video.c
@@ -1448,7 +1448,7 @@ static int radio_queryctrl(struct file *file, void *priv,
 	File operations for the device
    ------------------------------------------------------------------*/
 
-static int tm6000_open(struct file *file)
+static int __tm6000_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct tm6000_core *dev = video_drvdata(file);
@@ -1540,23 +1540,41 @@ static int tm6000_open(struct file *file)
 	return 0;
 }
 
+static int tm6000_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	int res;
+
+	mutex_lock(vdev->lock);
+	res = __tm6000_open(file);
+	mutex_unlock(vdev->lock);
+	return res;
+}
+
 static ssize_t
 tm6000_read(struct file *file, char __user *data, size_t count, loff_t *pos)
 {
-	struct tm6000_fh        *fh = file->private_data;
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		int res;
+
 		if (!res_get(fh->dev, fh, true))
 			return -EBUSY;
 
-		return videobuf_read_stream(&fh->vb_vidq, data, count, pos, 0,
+		if (mutex_lock_interruptible(&dev->lock))
+			return -ERESTARTSYS;
+		res = videobuf_read_stream(&fh->vb_vidq, data, count, pos, 0,
 					file->f_flags & O_NONBLOCK);
+		mutex_unlock(&dev->lock);
+		return res;
 	}
 	return 0;
 }
 
 static unsigned int
-tm6000_poll(struct file *file, struct poll_table_struct *wait)
+__tm6000_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct tm6000_fh        *fh = file->private_data;
 	struct tm6000_buffer    *buf;
@@ -1583,6 +1601,18 @@ tm6000_poll(struct file *file, struct poll_table_struct *wait)
 	return 0;
 }
 
+static unsigned int tm6000_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+	unsigned int res;
+
+	mutex_lock(&dev->lock);
+	res = __tm6000_poll(file, wait);
+	mutex_unlock(&dev->lock);
+	return res;
+}
+
 static int tm6000_release(struct file *file)
 {
 	struct tm6000_fh         *fh = file->private_data;
@@ -1592,6 +1622,7 @@ static int tm6000_release(struct file *file)
 	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: close called (dev=%s, users=%d)\n",
 		video_device_node_name(vdev), dev->users);
 
+	mutex_lock(&dev->lock);
 	dev->users--;
 
 	res_free(dev, fh);
@@ -1619,6 +1650,7 @@ static int tm6000_release(struct file *file)
 	}
 
 	kfree(fh);
+	mutex_unlock(&dev->lock);
 
 	return 0;
 }
@@ -1626,8 +1658,14 @@ static int tm6000_release(struct file *file)
 static int tm6000_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct tm6000_fh *fh = file->private_data;
+	struct tm6000_core *dev = fh->dev;
+	int res;
 
-	return videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
+	res = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	mutex_unlock(&dev->lock);
+	return res;
 }
 
 static struct v4l2_file_operations tm6000_fops = {
@@ -1724,10 +1762,6 @@ static struct video_device *vdev_init(struct tm6000_core *dev,
 	vfd->release = video_device_release;
 	vfd->debug = tm6000_debug;
 	vfd->lock = &dev->lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
-- 
1.7.10

