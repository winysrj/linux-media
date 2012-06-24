Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2703 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2FXL3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:18 -0400
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
Subject: [RFC PATCH 07/26] mem2mem_testdev: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:25:59 +0200
Message-Id: <68b02bb05ec7fbedda7f563b2bf135b725a85774.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/mem2mem_testdev.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index d2dec58..595e268 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -849,10 +849,15 @@ static int m2mtest_open(struct file *file)
 {
 	struct m2mtest_dev *dev = video_drvdata(file);
 	struct m2mtest_ctx *ctx = NULL;
+	int rc = 0;
 
+	if (mutex_lock_interruptible(&dev->dev_mutex))
+		return -ERESTARTSYS;
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto open_unlock;
+	}
 
 	file->private_data = ctx;
 	ctx->dev = dev;
@@ -863,16 +868,18 @@ static int m2mtest_open(struct file *file)
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
 
 	if (IS_ERR(ctx->m2m_ctx)) {
-		int ret = PTR_ERR(ctx->m2m_ctx);
+		rc = PTR_ERR(ctx->m2m_ctx);
 
 		kfree(ctx);
-		return ret;
+		goto open_unlock;
 	}
 
 	atomic_inc(&dev->num_inst);
 
 	dprintk(dev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
 
+open_unlock:
+	mutex_unlock(&dev->dev_mutex);
 	return 0;
 }
 
@@ -883,7 +890,9 @@ static int m2mtest_release(struct file *file)
 
 	dprintk(dev, "Releasing instance %p\n", ctx);
 
+	mutex_lock(&dev->dev_mutex);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	mutex_unlock(&dev->dev_mutex);
 	kfree(ctx);
 
 	atomic_dec(&dev->num_inst);
@@ -901,9 +910,15 @@ static unsigned int m2mtest_poll(struct file *file,
 
 static int m2mtest_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct m2mtest_dev *dev = video_drvdata(file);
 	struct m2mtest_ctx *ctx = file->private_data;
+	int res;
 
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	if (mutex_lock_interruptible(&dev->dev_mutex))
+		return -ERESTARTSYS;
+	res = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&dev->dev_mutex);
+	return res;
 }
 
 static const struct v4l2_file_operations m2mtest_fops = {
@@ -958,10 +973,6 @@ static int m2mtest_probe(struct platform_device *pdev)
 	}
 
 	*vfd = m2mtest_videodev;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->dev_mutex;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-- 
1.7.10

