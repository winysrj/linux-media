Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26016 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2F0OLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 10:11:41 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6A003TH4R88SG0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 23:11:40 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6A008NR4OC4950@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 23:11:40 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Remove V4L2_FL_LOCK_ALL_FOPS flag
Date: Wed, 27 Jun 2012 16:09:46 +0200
Message-id: <1340806186-6484-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1340806186-6484-1-git-send-email-s.nawrocki@samsung.com>
References: <1340806186-6484-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds locking for open(), close(), poll() and mmap()
file operations in the driver as a follow up to the changes
done in commit 5126f2590bee412e3053de851cb07f531
"v4l2-dev: add flag to have the core lock all file operations".

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   78 ++++++++++++++++++---------
 drivers/media/video/s5p-fimc/fimc-m2m.c     |   45 ++++++++++++----
 2 files changed, 87 insertions(+), 36 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 500b588..69708dc 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -480,48 +480,59 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc);
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	int ret;
+	int ret = -EBUSY;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
 	if (fimc_m2m_active(fimc))
-		return -EBUSY;
+		goto unlock;
 
 	set_bit(ST_CAPT_BUSY, &fimc->state);
 	ret = pm_runtime_get_sync(&fimc->pdev->dev);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	ret = v4l2_fh_open(file);
-	if (ret)
-		return ret;
-
-	if (++fimc->vid_cap.refcnt != 1)
-		return 0;
+	if (ret) {
+		pm_runtime_put(&fimc->pdev->dev);
+		goto unlock;
+	}
 
-	ret = fimc_pipeline_initialize(&fimc->pipeline,
+	if (++fimc->vid_cap.refcnt == 1) {
+		ret = fimc_pipeline_initialize(&fimc->pipeline,
 				       &fimc->vid_cap.vfd->entity, true);
-	if (ret < 0) {
-		clear_bit(ST_CAPT_BUSY, &fimc->state);
-		pm_runtime_put_sync(&fimc->pdev->dev);
-		fimc->vid_cap.refcnt--;
-		v4l2_fh_release(file);
-		return ret;
-	}
-	ret = fimc_capture_ctrls_create(fimc);
 
-	if (!ret && !fimc->vid_cap.user_subdev_api)
-		ret = fimc_capture_set_default_format(fimc);
+		if (!ret && !fimc->vid_cap.user_subdev_api)
+			ret = fimc_capture_set_default_format(fimc);
+
+		if (!ret)
+			ret = fimc_capture_ctrls_create(fimc);
 
+		if (ret < 0) {
+			clear_bit(ST_CAPT_BUSY, &fimc->state);
+			pm_runtime_put_sync(&fimc->pdev->dev);
+			fimc->vid_cap.refcnt--;
+			v4l2_fh_release(file);
+		}
+	}
+unlock:
+	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
 static int fimc_capture_close(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	int ret;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
 	if (--fimc->vid_cap.refcnt == 0) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
@@ -535,22 +546,40 @@ static int fimc_capture_close(struct file *file)
 		vb2_queue_release(&fimc->vid_cap.vbq);
 		fimc_ctrls_delete(fimc->vid_cap.ctx);
 	}
-	return v4l2_fh_release(file);
+
+	ret = v4l2_fh_release(file);
+
+	mutex_unlock(&fimc->lock);
+	return ret;
 }
 
 static unsigned int fimc_capture_poll(struct file *file,
 				      struct poll_table_struct *wait)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	int ret;
 
-	return vb2_poll(&fimc->vid_cap.vbq, file, wait);
+	if (mutex_lock_interruptible(&fimc->lock))
+		return POLL_ERR;
+
+	ret = vb2_poll(&fimc->vid_cap.vbq, file, wait);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
 }
 
 static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
 
-	return vb2_mmap(&fimc->vid_cap.vbq, vma);
+	ret = vb2_mmap(&fimc->vid_cap.vbq, vma);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
 }
 
 static const struct v4l2_file_operations fimc_capture_fops = {
@@ -1598,10 +1627,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
 	vfd->lock	= &fimc->lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
+
 	video_set_drvdata(vfd, fimc);
 
 	vid_cap = &fimc->vid_cap;
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index 4c58e05..41eda2e 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -642,21 +642,25 @@ static int fimc_m2m_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx;
-	int ret;
+	int ret = -EBUSY;
 
 	dbg("pid: %d, state: 0x%lx, refcnt: %d",
 	    task_pid_nr(current), fimc->state, fimc->vid_cap.refcnt);
 
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
 	/*
 	 * Return if the corresponding video capture node
 	 * is already opened.
 	 */
 	if (fimc->vid_cap.refcnt > 0)
-		return -EBUSY;
+		goto unlock;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
 	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
 	ctx->fimc_dev = fimc;
 
@@ -687,6 +691,8 @@ static int fimc_m2m_open(struct file *file)
 
 	if (fimc->m2m.refcnt++ == 0)
 		set_bit(ST_M2M_RUN, &fimc->state);
+
+	mutex_unlock(&fimc->lock);
 	return 0;
 
 error_c:
@@ -695,6 +701,8 @@ error_fh:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
+unlock:
+	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
@@ -706,6 +714,9 @@ static int fimc_m2m_release(struct file *file)
 	dbg("pid: %d, state: 0x%lx, refcnt= %d",
 		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
 
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	fimc_ctrls_delete(ctx);
 	v4l2_fh_del(&ctx->fh);
@@ -714,6 +725,8 @@ static int fimc_m2m_release(struct file *file)
 	if (--fimc->m2m.refcnt <= 0)
 		clear_bit(ST_M2M_RUN, &fimc->state);
 	kfree(ctx);
+
+	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -721,16 +734,32 @@ static unsigned int fimc_m2m_poll(struct file *file,
 				  struct poll_table_struct *wait)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
 
-	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
 }
 
 
 static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
 
-	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
 }
 
 static const struct v4l2_file_operations fimc_m2m_fops = {
@@ -772,10 +801,6 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
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

