Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1867 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2FXL3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:19 -0400
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
Subject: [RFC PATCH 11/26] s2255drv: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:03 +0200
Message-Id: <aa92f15566079d468d8aae2a1167985eb832116d.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/s2255drv.c |   42 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 01c2179..0001f1d 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -258,7 +258,6 @@ struct s2255_dev {
 	atomic_t                num_channels;
 	int			frames;
 	struct mutex		lock;	/* channels[].vdev.lock */
-	struct mutex		open_lock;
 	struct usb_device	*udev;
 	struct usb_interface	*interface;
 	u8			read_endpoint;
@@ -1684,7 +1683,7 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 	return 0;
 }
 
-static int s2255_open(struct file *file)
+static int __s2255_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct s2255_channel *channel = video_drvdata(file);
@@ -1694,16 +1693,9 @@ static int s2255_open(struct file *file)
 	int state;
 	dprintk(1, "s2255: open called (dev=%s)\n",
 		video_device_node_name(vdev));
-	/*
-	 * open lock necessary to prevent multiple instances
-	 * of v4l-conf (or other programs) from simultaneously
-	 * reloading firmware.
-	 */
-	mutex_lock(&dev->open_lock);
 	state = atomic_read(&dev->fw_data->fw_state);
 	switch (state) {
 	case S2255_FW_DISCONNECTING:
-		mutex_unlock(&dev->open_lock);
 		return -ENODEV;
 	case S2255_FW_FAILED:
 		s2255_dev_err(&dev->udev->dev,
@@ -1742,11 +1734,9 @@ static int s2255_open(struct file *file)
 		break;
 	case S2255_FW_FAILED:
 		printk(KERN_INFO "2255 firmware load failed.\n");
-		mutex_unlock(&dev->open_lock);
 		return -ENODEV;
 	case S2255_FW_DISCONNECTING:
 		printk(KERN_INFO "%s: disconnecting\n", __func__);
-		mutex_unlock(&dev->open_lock);
 		return -ENODEV;
 	case S2255_FW_LOADED_DSPWAIT:
 	case S2255_FW_NOTLOADED:
@@ -1760,14 +1750,11 @@ static int s2255_open(struct file *file)
 		 */
 		atomic_set(&dev->fw_data->fw_state,
 			   S2255_FW_FAILED);
-		mutex_unlock(&dev->open_lock);
 		return -EAGAIN;
 	default:
 		printk(KERN_INFO "%s: unknown state\n", __func__);
-		mutex_unlock(&dev->open_lock);
 		return -EFAULT;
 	}
-	mutex_unlock(&dev->open_lock);
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh)
@@ -1798,16 +1785,30 @@ static int s2255_open(struct file *file)
 	return 0;
 }
 
+static int s2255_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	int ret;
+
+	if (mutex_lock_interruptible(vdev->lock))
+		return -ERESTARTSYS;
+	ret = __s2255_open(file);
+	mutex_unlock(vdev->lock);
+	return ret;
+}
 
 static unsigned int s2255_poll(struct file *file,
 			       struct poll_table_struct *wait)
 {
 	struct s2255_fh *fh = file->private_data;
+	struct s2255_dev *dev = fh->dev;
 	int rc;
 	dprintk(100, "%s\n", __func__);
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
+	mutex_lock(&dev->lock);
 	rc = videobuf_poll_stream(file, &fh->vb_vidq, wait);
+	mutex_unlock(&dev->lock);
 	return rc;
 }
 
@@ -1827,7 +1828,6 @@ static void s2255_destroy(struct s2255_dev *dev)
 	kfree(dev->fw_data);
 	/* reset the DSP so firmware can be reloaded next time */
 	s2255_reset_dsppower(dev);
-	mutex_destroy(&dev->open_lock);
 	mutex_destroy(&dev->lock);
 	usb_put_dev(dev->udev);
 	v4l2_device_unregister(&dev->v4l2_dev);
@@ -1843,6 +1843,7 @@ static int s2255_release(struct file *file)
 	struct s2255_channel *channel = fh->channel;
 	if (!dev)
 		return -ENODEV;
+	mutex_lock(&dev->lock);
 	/* turn off stream */
 	if (res_check(fh)) {
 		if (channel->b_acquire)
@@ -1851,6 +1852,7 @@ static int s2255_release(struct file *file)
 		res_free(fh);
 	}
 	videobuf_mmap_free(&fh->vb_vidq);
+	mutex_unlock(&dev->lock);
 	dprintk(1, "%s (dev=%s)\n", __func__, video_device_node_name(vdev));
 	kfree(fh);
 	return 0;
@@ -1859,12 +1861,16 @@ static int s2255_release(struct file *file)
 static int s2255_mmap_v4l(struct file *file, struct vm_area_struct *vma)
 {
 	struct s2255_fh *fh = file->private_data;
+	struct s2255_dev *dev = fh->dev;
 	int ret;
 
 	if (!fh)
 		return -ENODEV;
 	dprintk(4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	mutex_unlock(&dev->lock);
 	dprintk(4, "%s vma start=0x%08lx, size=%ld, ret=%d\n", __func__,
 		(unsigned long)vma->vm_start,
 		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start, ret);
@@ -1944,10 +1950,6 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 		/* register 4 video devices */
 		channel->vdev = template;
 		channel->vdev.lock = &dev->lock;
-		/* Locking in file operations other than ioctl should be done
-		   by the driver, not the V4L2 core.
-		   This driver needs auditing so that this flag can be removed. */
-		set_bit(V4L2_FL_LOCK_ALL_FOPS, &channel->vdev.flags);
 		channel->vdev.v4l2_dev = &dev->v4l2_dev;
 		video_set_drvdata(&channel->vdev, channel);
 		if (video_nr == -1)
@@ -2535,7 +2537,6 @@ static int s2255_probe(struct usb_interface *interface,
 	if (!dev->fw_data)
 		goto errorFWDATA1;
 	mutex_init(&dev->lock);
-	mutex_init(&dev->open_lock);
 	/* grab usb_device and save it */
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
 	if (dev->udev == NULL) {
@@ -2637,7 +2638,6 @@ errorEP:
 	usb_put_dev(dev->udev);
 errorUDEV:
 	kfree(dev->fw_data);
-	mutex_destroy(&dev->open_lock);
 	mutex_destroy(&dev->lock);
 errorFWDATA1:
 	kfree(dev);
-- 
1.7.10

