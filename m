Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4771 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2FXL3S (ORCPT
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
Subject: [RFC PATCH 15/26] mx2_emmaprp: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:07 +0200
Message-Id: <4065112408ed239421a5a0767e2ee407f0eb8d52.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/mx2_emmaprp.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 0bd5815..c5f6c5c 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -791,11 +791,17 @@ static int emmaprp_open(struct file *file)
 	file->private_data = ctx;
 	ctx->dev = pcdev;
 
+	if (mutex_lock_interruptible(&pcdev->dev_mutex)) {
+		kfree(ctx);
+		return -ERESTARTSYS;
+	}
+
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(pcdev->m2m_dev, ctx, &queue_init);
 
 	if (IS_ERR(ctx->m2m_ctx)) {
 		int ret = PTR_ERR(ctx->m2m_ctx);
 
+		mutex_unlock(&pcdev->dev_mutex);
 		kfree(ctx);
 		return ret;
 	}
@@ -803,6 +809,7 @@ static int emmaprp_open(struct file *file)
 	clk_enable(pcdev->clk_emma);
 	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[1];
 	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
+	mutex_unlock(&pcdev->dev_mutex);
 
 	dprintk(pcdev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
 
@@ -816,8 +823,10 @@ static int emmaprp_release(struct file *file)
 
 	dprintk(pcdev, "Releasing instance %p\n", ctx);
 
+	mutex_lock(&pcdev->dev_mutex);
 	clk_disable(pcdev->clk_emma);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	mutex_unlock(&pcdev->dev_mutex);
 	kfree(ctx);
 
 	return 0;
@@ -826,16 +835,27 @@ static int emmaprp_release(struct file *file)
 static unsigned int emmaprp_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
+	struct emmaprp_dev *pcdev = video_drvdata(file);
 	struct emmaprp_ctx *ctx = file->private_data;
+	unsigned int res;
 
-	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_lock(&pcdev->dev_mutex);
+	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&pcdev->dev_mutex);
+	return res;
 }
 
 static int emmaprp_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct emmaprp_dev *pcdev = video_drvdata(file);
 	struct emmaprp_ctx *ctx = file->private_data;
+	int ret;
 
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	if (mutex_lock_interruptible(&pcdev->dev_mutex))
+		return -ERESTARTSYS;
+	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&pcdev->dev_mutex);
+	return ret;
 }
 
 static const struct v4l2_file_operations emmaprp_fops = {
@@ -904,10 +924,6 @@ static int emmaprp_probe(struct platform_device *pdev)
 	}
 
 	*vfd = emmaprp_videodev;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &pcdev->dev_mutex;
 
 	video_set_drvdata(vfd, pcdev);
-- 
1.7.10

