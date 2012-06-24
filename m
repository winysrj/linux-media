Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4916 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2FXL3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:21 -0400
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
Subject: [RFC PATCH 25/26] s5p-mfc: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:17 +0200
Message-Id: <451838d4b2e404fdc4babf044ac6326dfc5790d7.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/s5p-mfc/s5p_mfc.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 9bb68e7..e3e616d 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -645,6 +645,8 @@ static int s5p_mfc_open(struct file *file)
 	int ret = 0;
 
 	mfc_debug_enter();
+	if (mutex_lock_interruptible(&dev->mfc_mutex))
+		return -ERESTARTSYS;
 	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
 	/* Allocate memory for context */
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
@@ -765,6 +767,7 @@ static int s5p_mfc_open(struct file *file)
 		goto err_queue_init;
 	}
 	init_waitqueue_head(&ctx->queue);
+	mutex_unlock(&dev->mfc_mutex);
 	mfc_debug_leave();
 	return ret;
 	/* Deinit when failure occured */
@@ -790,6 +793,7 @@ err_no_ctx:
 	kfree(ctx);
 err_alloc:
 	dev->num_inst--;
+	mutex_unlock(&dev->mfc_mutex);
 	mfc_debug_leave();
 	return ret;
 }
@@ -802,6 +806,7 @@ static int s5p_mfc_release(struct file *file)
 	unsigned long flags;
 
 	mfc_debug_enter();
+	mutex_lock(&dev->mfc_mutex);
 	s5p_mfc_clock_on();
 	vb2_queue_release(&ctx->vq_src);
 	vb2_queue_release(&ctx->vq_dst);
@@ -855,6 +860,7 @@ static int s5p_mfc_release(struct file *file)
 	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 	mfc_debug_leave();
+	mutex_unlock(&dev->mfc_mutex);
 	return 0;
 }
 
@@ -869,6 +875,7 @@ static unsigned int s5p_mfc_poll(struct file *file,
 	unsigned int rc = 0;
 	unsigned long flags;
 
+	mutex_lock(&dev->mfc_mutex);
 	src_q = &ctx->vq_src;
 	dst_q = &ctx->vq_dst;
 	/*
@@ -902,6 +909,7 @@ static unsigned int s5p_mfc_poll(struct file *file,
 		rc |= POLLIN | POLLRDNORM;
 	spin_unlock_irqrestore(&dst_q->done_lock, flags);
 end:
+	mutex_unlock(&dev->mfc_mutex);
 	return rc;
 }
 
@@ -909,8 +917,12 @@ end:
 static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	int ret;
+
+	if (mutex_lock_interruptible(&dev->mfc_mutex))
+		return -ERESTARTSYS;
 	if (offset < DST_QUEUE_OFF_BASE) {
 		mfc_debug(2, "mmaping source\n");
 		ret = vb2_mmap(&ctx->vq_src, vma);
@@ -919,6 +931,7 @@ static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
 		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
 		ret = vb2_mmap(&ctx->vq_dst, vma);
 	}
+	mutex_unlock(&dev->mfc_mutex);
 	return ret;
 }
 
@@ -1034,10 +1047,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->ioctl_ops	= get_dec_v4l2_ioctl_ops();
 	vfd->release	= video_device_release,
 	vfd->lock	= &dev->mfc_mutex;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_DEC_NAME);
 	dev->vfd_dec	= vfd;
@@ -1062,8 +1071,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->ioctl_ops	= get_enc_v4l2_ioctl_ops();
 	vfd->release	= video_device_release,
 	vfd->lock	= &dev->mfc_mutex;
-	/* This should not be necessary */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_ENC_NAME);
 	dev->vfd_enc	= vfd;
-- 
1.7.10

