Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3231 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3DNP1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 18/30] cx25821: remove 'type' field from cx25821_fh.
Date: Sun, 14 Apr 2013 17:27:14 +0200
Message-Id: <1365953246-8972-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |   56 ++++++++---------------------
 drivers/media/pci/cx25821/cx25821.h       |    1 -
 2 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index ab79bd5..2aba24f 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -506,24 +506,12 @@ static void cx25821_buffer_release(struct videobuf_queue *q,
 
 static struct videobuf_queue *get_queue(struct cx25821_fh *fh)
 {
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		return &fh->vidq;
-	default:
-		BUG();
-		return NULL;
-	}
+	return &fh->vidq;
 }
 
 static int cx25821_get_resource(struct cx25821_fh *fh, int resource)
 {
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		return resource;
-	default:
-		BUG();
-		return 0;
-	}
+	return resource;
 }
 
 static int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
@@ -605,7 +593,6 @@ static int video_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 	int ch_id;
 
@@ -624,7 +611,6 @@ static int video_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev = dev;
-	fh->type = type;
 	fh->width = 720;
 	fh->channel_id = ch_id;
 
@@ -659,22 +645,15 @@ static ssize_t video_read(struct file *file, char __user * data, size_t count,
 	struct cx25821_dev *dev = fh->dev;
 	int err;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (mutex_lock_interruptible(&dev->lock))
-			return -ERESTARTSYS;
-		if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
-			err = -EBUSY;
-		else
-			err = videobuf_read_one(&fh->vidq, data, count, ppos,
-					file->f_flags & O_NONBLOCK);
-		mutex_unlock(&dev->lock);
-		return err;
-
-	default:
-		return -ENODEV;
-	}
-
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
+	if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
+		err = -EBUSY;
+	else
+		err = videobuf_read_one(&fh->vidq, data, count, ppos,
+				file->f_flags & O_NONBLOCK);
+	mutex_unlock(&dev->lock);
+	return err;
 }
 
 static unsigned int video_poll(struct file *file,
@@ -818,14 +797,11 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev = fh->dev;
 
-	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
-		return -EINVAL;
-
-	if (unlikely(i != fh->type))
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh,
-						RESOURCE_VIDEO0))))
+	if (!cx25821_res_get(dev, fh,
+			cx25821_get_resource(fh, RESOURCE_VIDEO0)))
 		return -EBUSY;
 
 	return videobuf_streamon(get_queue(fh));
@@ -837,9 +813,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	struct cx25821_dev *dev = fh->dev;
 	int err, res;
 
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	if (i != fh->type)
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	res = cx25821_get_resource(fh, RESOURCE_VIDEO0);
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index ad56232..d1c91c9 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -118,7 +118,6 @@ struct cx25821_tvnorm {
 
 struct cx25821_fh {
 	struct cx25821_dev *dev;
-	enum v4l2_buf_type type;
 	u32 resources;
 
 	enum v4l2_priority prio;
-- 
1.7.10.4

