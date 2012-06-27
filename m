Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55342 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab2F0OLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 10:11:32 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6A00I1O4R71K10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 23:11:31 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6A008NR4OC4950@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 23:11:31 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Add missing FIMC-LITE file operations locking
Date: Wed, 27 Jun 2012 16:09:45 +0200
Message-id: <1340806186-6484-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1340806186-6484-1-git-send-email-s.nawrocki@samsung.com>
References: <1340806186-6484-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 5126f2590bee412e3053de851cb07f531e4be36a
"v4l2-dev: add flag to have the core lock all file operations"
introduced an additional bit flag (V4L2_FL_LOCK_ALL_FOPS) that
should be set by drivers that use the v4l2 core lock for all file
operations. Since this driver has been merged at the same time as
the core changes it doesn't set this flags and thus its all file
operations except IOCTL are not properly serialized. Fix this by
adding file ops locking in the driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-lite.c |   61 +++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 4d269b8..74ff310 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -453,34 +453,42 @@ static int fimc_lite_open(struct file *file)
 	struct fimc_lite *fimc = video_drvdata(file);
 	int ret;
 
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
 	set_bit(ST_FLITE_IN_USE, &fimc->state);
 	ret = pm_runtime_get_sync(&fimc->pdev->dev);
 	if (ret < 0)
-		return ret;
-
-	if (++fimc->ref_count != 1 || fimc->out_path != FIMC_IO_DMA)
-		return 0;
+		goto done;
 
 	ret = v4l2_fh_open(file);
 	if (ret < 0)
-		return ret;
+		goto done;
 
-	ret = fimc_pipeline_initialize(&fimc->pipeline, &fimc->vfd->entity,
-				       true);
-	if (ret < 0) {
-		pm_runtime_put_sync(&fimc->pdev->dev);
-		fimc->ref_count--;
-		v4l2_fh_release(file);
-		clear_bit(ST_FLITE_IN_USE, &fimc->state);
-	}
+	if (++fimc->ref_count == 1 && fimc->out_path == FIMC_IO_DMA) {
+		ret = fimc_pipeline_initialize(&fimc->pipeline,
+					       &fimc->vfd->entity, true);
+		if (ret < 0) {
+			pm_runtime_put_sync(&fimc->pdev->dev);
+			fimc->ref_count--;
+			v4l2_fh_release(file);
+			clear_bit(ST_FLITE_IN_USE, &fimc->state);
+		}
 
-	fimc_lite_clear_event_counters(fimc);
+		fimc_lite_clear_event_counters(fimc);
+	}
+done:
+	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
 static int fimc_lite_close(struct file *file)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
 
 	if (--fimc->ref_count == 0 && fimc->out_path == FIMC_IO_DMA) {
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
@@ -494,20 +502,39 @@ static int fimc_lite_close(struct file *file)
 	if (fimc->ref_count == 0)
 		vb2_queue_release(&fimc->vb_queue);
 
-	return v4l2_fh_release(file);
+	ret = v4l2_fh_release(file);
+
+	mutex_unlock(&fimc->lock);
+	return ret;
 }
 
 static unsigned int fimc_lite_poll(struct file *file,
 				   struct poll_table_struct *wait)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	return vb2_poll(&fimc->vb_queue, file, wait);
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return POLL_ERR;
+
+	ret = vb2_poll(&fimc->vb_queue, file, wait);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
 }
 
 static int fimc_lite_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	return vb2_mmap(&fimc->vb_queue, vma);
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	ret = vb2_mmap(&fimc->vb_queue, vma);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
 }
 
 static const struct v4l2_file_operations fimc_lite_fops = {
-- 
1.7.10

