Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4985 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2FXL3S (ORCPT
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
Subject: [RFC PATCH 24/26] fimc-m2m.c: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:16 +0200
Message-Id: <73ea71dfb4e307a78a9f993dd3d778d639ad7228.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/s5p-fimc/fimc-m2m.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index 4c58e05..1074397 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -660,6 +660,11 @@ static int fimc_m2m_open(struct file *file)
 	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
 	ctx->fimc_dev = fimc;
 
+	if (mutex_lock_interruptible(&fimc->lock)) {
+		kfree(ctx);
+		return -ERESTARTSYS;
+	}
+
 	/* Default color format */
 	ctx->s_frame.fmt = fimc_get_format(0);
 	ctx->d_frame.fmt = fimc_get_format(0);
@@ -687,6 +692,7 @@ static int fimc_m2m_open(struct file *file)
 
 	if (fimc->m2m.refcnt++ == 0)
 		set_bit(ST_M2M_RUN, &fimc->state);
+	mutex_unlock(&fimc->lock);
 	return 0;
 
 error_c:
@@ -695,6 +701,7 @@ error_fh:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
+	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
@@ -706,6 +713,7 @@ static int fimc_m2m_release(struct file *file)
 	dbg("pid: %d, state: 0x%lx, refcnt= %d",
 		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
 
+	mutex_lock(&fimc->lock);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	fimc_ctrls_delete(ctx);
 	v4l2_fh_del(&ctx->fh);
@@ -713,6 +721,7 @@ static int fimc_m2m_release(struct file *file)
 
 	if (--fimc->m2m.refcnt <= 0)
 		clear_bit(ST_M2M_RUN, &fimc->state);
+	mutex_unlock(&fimc->lock);
 	kfree(ctx);
 	return 0;
 }
@@ -721,16 +730,27 @@ static unsigned int fimc_m2m_poll(struct file *file,
 				  struct poll_table_struct *wait)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	unsigned int res;
 
-	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_lock(&fimc->lock);
+	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&fimc->lock);
+	return res;
 }
 
 
 static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
 
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&fimc->lock);
+	return ret;
 }
 
 static const struct v4l2_file_operations fimc_m2m_fops = {
@@ -772,10 +792,6 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	vfd->minor = -1;
 	vfd->release = video_device_release;
 	vfd->lock = &fimc->lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.m2m", fimc->id);
 	video_set_drvdata(vfd, fimc);
-- 
1.7.10

