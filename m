Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1150 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab2FXL3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:25 -0400
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
Subject: [RFC PATCH 18/26] cx231xx: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:10 +0200
Message-Id: <ef7ba462c7093f67765ad08fbe31239cc09ee5f8.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/cx231xx/cx231xx-video.c |   47 ++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 523aa49..790b28d 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2168,6 +2168,10 @@ static int cx231xx_v4l2_open(struct file *filp)
 		cx231xx_errdev("cx231xx-video.c: Out of memory?!\n");
 		return -ENOMEM;
 	}
+	if (mutex_lock_interruptible(&dev->lock)) {
+		kfree(fh);
+		return -ERESTARTSYS;
+	}
 	fh->dev = dev;
 	fh->radio = radio;
 	fh->type = fh_type;
@@ -2226,6 +2230,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 					    sizeof(struct cx231xx_buffer),
 					    fh, &dev->lock);
 	}
+	mutex_unlock(&dev->lock);
 
 	return errCode;
 }
@@ -2272,11 +2277,11 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 }
 
 /*
- * cx231xx_v4l2_close()
+ * cx231xx_close()
  * stops streaming and deallocates all resources allocated by the v4l2
  * calls and ioctls
  */
-static int cx231xx_v4l2_close(struct file *filp)
+static int cx231xx_close(struct file *filp)
 {
 	struct cx231xx_fh *fh = filp->private_data;
 	struct cx231xx *dev = fh->dev;
@@ -2355,6 +2360,18 @@ static int cx231xx_v4l2_close(struct file *filp)
 	return 0;
 }
 
+static int cx231xx_v4l2_close(struct file *filp)
+{
+	struct cx231xx_fh *fh = filp->private_data;
+	struct cx231xx *dev = fh->dev;
+	int rc;
+
+	mutex_lock(&dev->lock);
+	rc = cx231xx_close(filp);
+	mutex_unlock(&dev->lock);
+	return rc;
+}
+
 /*
  * cx231xx_v4l2_read()
  * will allocate buffers when called for the first time
@@ -2378,8 +2395,12 @@ cx231xx_v4l2_read(struct file *filp, char __user *buf, size_t count,
 		if (unlikely(rc < 0))
 			return rc;
 
-		return videobuf_read_stream(&fh->vb_vidq, buf, count, pos, 0,
+		if (mutex_lock_interruptible(&dev->lock))
+			return -ERESTARTSYS;
+		rc = videobuf_read_stream(&fh->vb_vidq, buf, count, pos, 0,
 					    filp->f_flags & O_NONBLOCK);
+		mutex_unlock(&dev->lock);
+		return rc;
 	}
 	return 0;
 }
@@ -2404,10 +2425,15 @@ static unsigned int cx231xx_v4l2_poll(struct file *filp, poll_table *wait)
 		return POLLERR;
 
 	if ((V4L2_BUF_TYPE_VIDEO_CAPTURE == fh->type) ||
-	    (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type))
-		return videobuf_poll_stream(filp, &fh->vb_vidq, wait);
-	else
-		return POLLERR;
+	    (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)) {
+		unsigned int res;
+
+		mutex_lock(&dev->lock);
+		res = videobuf_poll_stream(filp, &fh->vb_vidq, wait);
+		mutex_unlock(&dev->lock);
+		return res;
+	}
+	return POLLERR;
 }
 
 /*
@@ -2428,7 +2454,10 @@ static int cx231xx_v4l2_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (unlikely(rc < 0))
 		return rc;
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 	rc = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	mutex_unlock(&dev->lock);
 
 	cx231xx_videodbg("vma start=0x%08lx, size=%ld, ret=%d\n",
 			 (unsigned long)vma->vm_start,
@@ -2545,10 +2574,6 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
 	vfd->release = video_device_release;
 	vfd->debug = video_debug;
 	vfd->lock = &dev->lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
-- 
1.7.10

