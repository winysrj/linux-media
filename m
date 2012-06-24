Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4153 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2FXL3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:15 -0400
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
Subject: [RFC PATCH 23/26] fimc-capture.c: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:15 +0200
Message-Id: <d78ece169a8da8e72ef0ed784fe88b4f62ca345c.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/s5p-fimc/fimc-capture.c |   36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 62ce539..62045dc 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -479,17 +479,22 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc);
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	int ret = v4l2_fh_open(file);
+	int ret;
+
+	/* Return if the corresponding video mem2mem node is already opened. */
+	if (fimc_m2m_active(fimc))
+		return -EBUSY;
 
+	ret = v4l2_fh_open(file);
 	if (ret)
 		return ret;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
-	/* Return if the corresponding video mem2mem node is already opened. */
-	if (fimc_m2m_active(fimc))
-		return -EBUSY;
-
+	if (mutex_lock_interruptible(&fimc->lock)) {
+		v4l2_fh_release(file);
+		return -ERESTARTSYS;
+	}
 	set_bit(ST_CAPT_BUSY, &fimc->state);
 	pm_runtime_get_sync(&fimc->pdev->dev);
 
@@ -503,6 +508,7 @@ static int fimc_capture_open(struct file *file)
 			fimc->vid_cap.refcnt--;
 			v4l2_fh_release(file);
 			clear_bit(ST_CAPT_BUSY, &fimc->state);
+			mutex_unlock(&fimc->lock);
 			return ret;
 		}
 		ret = fimc_capture_ctrls_create(fimc);
@@ -510,6 +516,7 @@ static int fimc_capture_open(struct file *file)
 		if (!ret && !fimc->vid_cap.user_subdev_api)
 			ret = fimc_capture_set_default_format(fimc);
 	}
+	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
@@ -519,6 +526,7 @@ static int fimc_capture_close(struct file *file)
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
+	mutex_lock(&fimc->lock);
 	if (--fimc->vid_cap.refcnt == 0) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
@@ -532,6 +540,7 @@ static int fimc_capture_close(struct file *file)
 		vb2_queue_release(&fimc->vid_cap.vbq);
 		fimc_ctrls_delete(fimc->vid_cap.ctx);
 	}
+	mutex_unlock(&fimc->lock);
 	return v4l2_fh_release(file);
 }
 
@@ -539,15 +548,24 @@ static unsigned int fimc_capture_poll(struct file *file,
 				      struct poll_table_struct *wait)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	unsigned res;
 
-	return vb2_poll(&fimc->vid_cap.vbq, file, wait);
+	mutex_lock(&fimc->lock);
+	res = vb2_poll(&fimc->vid_cap.vbq, file, wait);
+	mutex_unlock(&fimc->lock);
+	return res;
 }
 
 static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	int ret;
 
-	return vb2_mmap(&fimc->vid_cap.vbq, vma);
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+	ret = vb2_mmap(&fimc->vid_cap.vbq, vma);
+	mutex_unlock(&fimc->lock);
+	return ret;
 }
 
 static const struct v4l2_file_operations fimc_capture_fops = {
@@ -1590,10 +1608,6 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
 	vfd->lock	= &fimc->lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	video_set_drvdata(vfd, fimc);
 
 	vid_cap = &fimc->vid_cap;
-- 
1.7.10

