Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1400 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2FXL30 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:26 -0400
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
Subject: [RFC PATCH 22/26] s5p-tv: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:14 +0200
Message-Id: <15868aacc655863511a6cfaf4c33f59647077b56.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/s5p-tv/mixer_video.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 33fde2a..7a8880f 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -750,18 +750,20 @@ static int mxr_video_open(struct file *file)
 	int ret = 0;
 
 	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	if (mutex_lock_interruptible(&layer->mutex))
+		return -ERESTARTSYS;
 	/* assure device probe is finished */
 	wait_for_device_probe();
 	/* creating context for file descriptor */
 	ret = v4l2_fh_open(file);
 	if (ret) {
 		mxr_err(mdev, "v4l2_fh_open failed\n");
-		return ret;
+		goto unlock;
 	}
 
 	/* leaving if layer is already initialized */
 	if (!v4l2_fh_is_singular_file(file))
-		return 0;
+		goto unlock;
 
 	/* FIXME: should power be enabled on open? */
 	ret = mxr_power_get(mdev);
@@ -779,6 +781,7 @@ static int mxr_video_open(struct file *file)
 	layer->fmt = layer->fmt_array[0];
 	/* setup default geometry */
 	mxr_layer_default_geo(layer);
+	mutex_unlock(&layer->mutex);
 
 	return 0;
 
@@ -788,6 +791,9 @@ fail_power:
 fail_fh_open:
 	v4l2_fh_release(file);
 
+unlock:
+	mutex_unlock(&layer->mutex);
+
 	return ret;
 }
 
@@ -795,19 +801,28 @@ static unsigned int
 mxr_video_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct mxr_layer *layer = video_drvdata(file);
+	unsigned int res;
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
 
-	return vb2_poll(&layer->vb_queue, file, wait);
+	mutex_lock(&layer->mutex);
+	res = vb2_poll(&layer->vb_queue, file, wait);
+	mutex_unlock(&layer->mutex);
+	return res;
 }
 
 static int mxr_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct mxr_layer *layer = video_drvdata(file);
+	int ret;
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
 
-	return vb2_mmap(&layer->vb_queue, vma);
+	if (mutex_lock_interruptible(&layer->mutex))
+		return -ERESTARTSYS;
+	ret = vb2_mmap(&layer->vb_queue, vma);
+	mutex_unlock(&layer->mutex);
+	return ret;
 }
 
 static int mxr_video_release(struct file *file)
@@ -815,11 +830,13 @@ static int mxr_video_release(struct file *file)
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	mutex_lock(&layer->mutex);
 	if (v4l2_fh_is_singular_file(file)) {
 		vb2_queue_release(&layer->vb_queue);
 		mxr_power_put(layer->mdev);
 	}
 	v4l2_fh_release(file);
+	mutex_unlock(&layer->mutex);
 	return 0;
 }
 
@@ -1069,10 +1086,6 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 	set_bit(V4L2_FL_USE_FH_PRIO, &layer->vfd.flags);
 
 	video_set_drvdata(&layer->vfd, layer);
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &layer->vfd.flags);
 	layer->vfd.lock = &layer->mutex;
 	layer->vfd.v4l2_dev = &mdev->v4l2_dev;
 
-- 
1.7.10

