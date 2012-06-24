Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3968 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab2FXL3T (ORCPT
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
Subject: [RFC PATCH 10/26] fsl-viu: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:02 +0200
Message-Id: <b29f8ac3c3f204397f557df4988f2cd17a170a1a.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/fsl-viu.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 777486f..20f9810 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -1279,10 +1279,16 @@ static int viu_open(struct file *file)
 	dprintk(1, "open minor=%d type=%s users=%d\n", minor,
 		v4l2_type_names[V4L2_BUF_TYPE_VIDEO_CAPTURE], dev->users);
 
+	if (mutex_lock_interruptible(&dev->lock)) {
+		dev->users--;
+		return -ERESTARTSYS;
+	}
+
 	/* allocate and initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (!fh) {
 		dev->users--;
+		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
 
@@ -1325,6 +1331,7 @@ static int viu_open(struct file *file)
 				       fh->type, V4L2_FIELD_INTERLACED,
 				       sizeof(struct viu_buf), fh,
 				       &fh->dev->lock);
+	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -1340,9 +1347,12 @@ static ssize_t viu_read(struct file *file, char __user *data, size_t count,
 		dev->ovenable = 0;
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		if (mutex_lock_interruptible(&dev->lock))
+			return -ERESTARTSYS;
 		viu_start_dma(dev);
 		ret = videobuf_read_stream(&fh->vb_vidq, data, count,
 				ppos, 0, file->f_flags & O_NONBLOCK);
+		mutex_unlock(&dev->lock);
 		return ret;
 	}
 	return 0;
@@ -1352,11 +1362,16 @@ static unsigned int viu_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct viu_fh *fh = file->private_data;
 	struct videobuf_queue *q = &fh->vb_vidq;
+	struct viu_dev *dev = fh->dev;
+	unsigned int res;
 
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
 
-	return videobuf_poll_stream(file, q, wait);
+	mutex_lock(&dev->lock);
+	res = videobuf_poll_stream(file, q, wait);
+	mutex_unlock(&dev->lock);
+	return res;
 }
 
 static int viu_release(struct file *file)
@@ -1365,9 +1380,11 @@ static int viu_release(struct file *file)
 	struct viu_dev *dev = fh->dev;
 	int minor = video_devdata(file)->minor;
 
+	mutex_lock(&dev->lock);
 	viu_stop_dma(dev);
 	videobuf_stop(&fh->vb_vidq);
 	videobuf_mmap_free(&fh->vb_vidq);
+	mutex_unlock(&dev->lock);
 
 	kfree(fh);
 
@@ -1394,11 +1411,15 @@ void viu_reset(struct viu_reg *reg)
 static int viu_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct viu_fh *fh = file->private_data;
+	struct viu_dev *dev = fh->dev;
 	int ret;
 
 	dprintk(1, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	mutex_unlock(&dev->lock);
 
 	dprintk(1, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
@@ -1544,10 +1565,6 @@ static int __devinit viu_of_probe(struct platform_device *op)
 
 	/* initialize locks */
 	mutex_init(&viu_dev->lock);
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &viu_dev->vdev->flags);
 	viu_dev->vdev->lock = &viu_dev->lock;
 	spin_lock_init(&viu_dev->slock);
 
-- 
1.7.10

