Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1256 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2FXL3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:17 -0400
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
Subject: [RFC PATCH 05/26] em28xx: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:25:57 +0200
Message-Id: <20e7db5cf6648ffa13f40b4770cb85b7f46265be.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/em28xx/em28xx-video.c |   52 +++++++++++++++++++----------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 50f5f4f..ecb23df 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2146,9 +2146,12 @@ static int em28xx_v4l2_open(struct file *filp)
 			dev->users);
 
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 	fh = kzalloc(sizeof(struct em28xx_fh), GFP_KERNEL);
 	if (!fh) {
 		em28xx_errdev("em28xx-video.c: Out of memory?!\n");
+		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
 	fh->dev = dev;
@@ -2189,6 +2192,7 @@ static int em28xx_v4l2_open(struct file *filp)
 				    V4L2_BUF_TYPE_VBI_CAPTURE,
 				    V4L2_FIELD_SEQ_TB,
 				    sizeof(struct em28xx_buffer), fh, &dev->lock);
+	mutex_unlock(&dev->lock);
 
 	return errCode;
 }
@@ -2243,6 +2247,7 @@ static int em28xx_v4l2_close(struct file *filp)
 
 	em28xx_videodbg("users=%d\n", dev->users);
 
+	mutex_lock(&dev->lock);
 	if (res_check(fh, EM28XX_RESOURCE_VIDEO)) {
 		videobuf_stop(&fh->vb_vidq);
 		res_free(fh, EM28XX_RESOURCE_VIDEO);
@@ -2261,6 +2266,7 @@ static int em28xx_v4l2_close(struct file *filp)
 			kfree(dev->alt_max_pkt_size);
 			kfree(dev);
 			kfree(fh);
+			mutex_unlock(&dev->lock);
 			return 0;
 		}
 
@@ -2285,6 +2291,7 @@ static int em28xx_v4l2_close(struct file *filp)
 	videobuf_mmap_free(&fh->vb_vbiq);
 	kfree(fh);
 	dev->users--;
+	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -2304,35 +2311,35 @@ em28xx_v4l2_read(struct file *filp, char __user *buf, size_t count,
 	if (rc < 0)
 		return rc;
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 	/* FIXME: read() is not prepared to allow changing the video
 	   resolution while streaming. Seems a bug at em28xx_set_fmt
 	 */
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (res_locked(dev, EM28XX_RESOURCE_VIDEO))
-			return -EBUSY;
-
-		return videobuf_read_stream(&fh->vb_vidq, buf, count, pos, 0,
+			rc = -EBUSY;
+		else
+			rc = videobuf_read_stream(&fh->vb_vidq, buf, count, pos, 0,
 					filp->f_flags & O_NONBLOCK);
-	}
-
-
-	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
+	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
 		if (!res_get(fh, EM28XX_RESOURCE_VBI))
-			return -EBUSY;
-
-		return videobuf_read_stream(&fh->vb_vbiq, buf, count, pos, 0,
+			rc = -EBUSY;
+		else
+			rc = videobuf_read_stream(&fh->vb_vbiq, buf, count, pos, 0,
 					filp->f_flags & O_NONBLOCK);
 	}
+	mutex_unlock(&dev->lock);
 
-	return 0;
+	return rc;
 }
 
 /*
- * em28xx_v4l2_poll()
+ * em28xx_poll()
  * will allocate buffers when called for the first time
  */
-static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table *wait)
+static unsigned int em28xx_poll(struct file *filp, poll_table *wait)
 {
 	struct em28xx_fh *fh = filp->private_data;
 	struct em28xx *dev = fh->dev;
@@ -2355,6 +2362,18 @@ static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table *wait)
 	}
 }
 
+static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table *wait)
+{
+	struct em28xx_fh *fh = filp->private_data;
+	struct em28xx *dev = fh->dev;
+	unsigned int res;
+
+	mutex_lock(&dev->lock);
+	res = em28xx_poll(filp, wait);
+	mutex_unlock(&dev->lock);
+	return res;
+}
+
 /*
  * em28xx_v4l2_mmap()
  */
@@ -2368,10 +2387,13 @@ static int em28xx_v4l2_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (rc < 0)
 		return rc;
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		rc = videobuf_mmap_mapper(&fh->vb_vidq, vma);
 	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
 		rc = videobuf_mmap_mapper(&fh->vb_vbiq, vma);
+	mutex_unlock(&dev->lock);
 
 	em28xx_videodbg("vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
@@ -2495,10 +2517,6 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 	vfd->release	= video_device_release;
 	vfd->debug	= video_debug;
 	vfd->lock	= &dev->lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
 		 dev->name, type_name);
-- 
1.7.10

