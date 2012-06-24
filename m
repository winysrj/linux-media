Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3961 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2FXL3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:14 -0400
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
Subject: [RFC PATCH 20/26] s5p-jpeg: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:12 +0200
Message-Id: <b33f0e65af2264f2a173d14ac2900402ffe7fc54.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/s5p-jpeg/jpeg-core.c |   34 +++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 28b5225d..ff0cc37 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -292,6 +292,11 @@ static int s5p_jpeg_open(struct file *file)
 	if (!ctx)
 		return -ENOMEM;
 
+	if (mutex_lock_interruptible(&jpeg->lock)) {
+		ret = -ERESTARTSYS;
+		goto free;
+	}
+
 	v4l2_fh_init(&ctx->fh, vfd);
 	/* Use separate control handler per file handle */
 	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
@@ -319,20 +324,26 @@ static int s5p_jpeg_open(struct file *file)
 
 	ctx->out_q.fmt = out_fmt;
 	ctx->cap_q.fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_YUYV);
+	mutex_unlock(&jpeg->lock);
 	return 0;
 
 error:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
+	mutex_unlock(&jpeg->lock);
+free:
 	kfree(ctx);
 	return ret;
 }
 
 static int s5p_jpeg_release(struct file *file)
 {
+	struct s5p_jpeg *jpeg = video_drvdata(file);
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
 
+	mutex_lock(&jpeg->lock);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	mutex_unlock(&jpeg->lock);
 	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
@@ -344,16 +355,27 @@ static int s5p_jpeg_release(struct file *file)
 static unsigned int s5p_jpeg_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
+	struct s5p_jpeg *jpeg = video_drvdata(file);
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
+	unsigned int res;
 
-	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_lock(&jpeg->lock);
+	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&jpeg->lock);
+	return res;
 }
 
 static int s5p_jpeg_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct s5p_jpeg *jpeg = video_drvdata(file);
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
+	int ret;
 
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	if (mutex_lock_interruptible(&jpeg->lock))
+		return -ERESTARTSYS;
+	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&jpeg->lock);
+	return ret;
 }
 
 static const struct v4l2_file_operations s5p_jpeg_fops = {
@@ -1368,10 +1390,6 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	jpeg->vfd_encoder->release	= video_device_release;
 	jpeg->vfd_encoder->lock		= &jpeg->lock;
 	jpeg->vfd_encoder->v4l2_dev	= &jpeg->v4l2_dev;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &jpeg->vfd_encoder->flags);
 
 	ret = video_register_device(jpeg->vfd_encoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
@@ -1399,10 +1417,6 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	jpeg->vfd_decoder->release	= video_device_release;
 	jpeg->vfd_decoder->lock		= &jpeg->lock;
 	jpeg->vfd_decoder->v4l2_dev	= &jpeg->v4l2_dev;
-	/* Locking in file operations other than ioctl should be done by the driver,
-	   not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &jpeg->vfd_decoder->flags);
 
 	ret = video_register_device(jpeg->vfd_decoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-- 
1.7.10

