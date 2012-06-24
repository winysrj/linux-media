Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3966 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2FXL3R (ORCPT
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
Subject: [RFC PATCH 21/26] s5p-g2d: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:13 +0200
Message-Id: <0c5af6204bf82f2a7acd17376f61bac13cfc2547.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/s5p-g2d/g2d.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 7c98ee7..d8cf1db 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -248,9 +248,14 @@ static int g2d_open(struct file *file)
 	ctx->in		= def_frame;
 	ctx->out	= def_frame;
 
+	if (mutex_lock_interruptible(&dev->mutex)) {
+		kfree(ctx);
+		return -ERESTARTSYS;
+	}
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
 		ret = PTR_ERR(ctx->m2m_ctx);
+		mutex_unlock(&dev->mutex);
 		kfree(ctx);
 		return ret;
 	}
@@ -264,6 +269,7 @@ static int g2d_open(struct file *file)
 	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
 
 	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	mutex_unlock(&dev->mutex);
 
 	v4l2_info(&dev->v4l2_dev, "instance opened\n");
 	return 0;
@@ -401,13 +407,26 @@ static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
 static unsigned int g2d_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct g2d_ctx *ctx = fh2ctx(file->private_data);
-	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	struct g2d_dev *dev = ctx->dev;
+	unsigned int res;
+
+	mutex_lock(&dev->mutex);
+	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&dev->mutex);
+	return res;
 }
 
 static int g2d_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct g2d_ctx *ctx = fh2ctx(file->private_data);
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	struct g2d_dev *dev = ctx->dev;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&dev->mutex);
+	return ret;
 }
 
 static int vidioc_reqbufs(struct file *file, void *priv,
@@ -748,10 +767,6 @@ static int g2d_probe(struct platform_device *pdev)
 		goto unreg_v4l2_dev;
 	}
 	*vfd = g2d_videodev;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->mutex;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
-- 
1.7.10

