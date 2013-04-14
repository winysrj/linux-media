Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4534 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3DNP17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 20/30] cx25821: replace resource management functions with fh ownership.
Date: Sun, 14 Apr 2013 17:27:16 +0200
Message-Id: <1365953246-8972-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just remember which filehandle is streaming instead of using complicated
resource masks.

After this patch we can replace cx25821_fh with v4l2_fh.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |  130 ++++++++---------------------
 drivers/media/pci/cx25821/cx25821.h       |    5 +-
 2 files changed, 35 insertions(+), 100 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index d88316c5..e7a2db1 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -144,48 +144,6 @@ static int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 	return 0;
 }
 
-/* resource management */
-static int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
-		    unsigned int bit)
-{
-	dprintk(1, "%s()\n", __func__);
-	if (fh->resources & bit)
-		/* have it already allocated */
-		return 1;
-
-	/* is it free? */
-	if (dev->channels[fh->channel_id].resources & bit) {
-		/* no, someone else uses it */
-		return 0;
-	}
-	/* it's free, grab it */
-	fh->resources |= bit;
-	dev->channels[fh->channel_id].resources |= bit;
-	dprintk(1, "res: get %d\n", bit);
-	return 1;
-}
-
-static int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit)
-{
-	return fh->resources & bit;
-}
-
-static int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit)
-{
-	return fh->dev->channels[fh->channel_id].resources & bit;
-}
-
-static void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
-		      unsigned int bits)
-{
-	BUG_ON((fh->resources & bits) != bits);
-	dprintk(1, "%s()\n", __func__);
-
-	fh->resources &= ~bits;
-	dev->channels[fh->channel_id].resources &= ~bits;
-	dprintk(1, "res: put %d\n", bits);
-}
-
 static int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input)
 {
 	struct v4l2_routing route;
@@ -503,11 +461,6 @@ static void cx25821_buffer_release(struct videobuf_queue *q,
 	cx25821_free_buffer(q, buf);
 }
 
-static int cx25821_get_resource(struct cx25821_fh *fh, int resource)
-{
-	return resource;
-}
-
 static int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
@@ -611,15 +564,19 @@ static ssize_t video_read(struct file *file, char __user * data, size_t count,
 	struct cx25821_fh *fh = file->private_data;
 	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_dev *dev = fh->dev;
-	int err;
+	int err = 0;
 
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
-	if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
+	if (chan->streaming_fh && chan->streaming_fh != fh) {
 		err = -EBUSY;
-	else
-		err = videobuf_read_one(&chan->vidq, data, count, ppos,
+		goto unlock;
+	}
+	chan->streaming_fh = fh;
+
+	err = videobuf_read_one(&chan->vidq, data, count, ppos,
 				file->f_flags & O_NONBLOCK);
+unlock:
 	mutex_unlock(&dev->lock);
 	return err;
 }
@@ -627,41 +584,25 @@ static ssize_t video_read(struct file *file, char __user * data, size_t count,
 static unsigned int video_poll(struct file *file,
 			      struct poll_table_struct *wait)
 {
-	struct cx25821_fh *fh = file->private_data;
 	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_buffer *buf;
 
-	if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
-		/* streaming capture */
-		if (list_empty(&chan->vidq.stream))
-			return POLLERR;
-		buf = list_entry(chan->vidq.stream.next,
-				struct cx25821_buffer, vb.stream);
-	} else {
-		/* read() capture */
-		buf = (struct cx25821_buffer *)chan->vidq.read_buf;
-		if (NULL == buf)
-			return POLLERR;
-	}
+	return videobuf_poll_stream(file, &chan->vidq, wait);
 
-	poll_wait(file, &buf->vb.done, wait);
-	if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-		if (buf->vb.state == VIDEOBUF_DONE) {
-			struct cx25821_dev *dev = fh->dev;
-
-			if (dev && chan->use_cif_resolution) {
-				u8 cam_id = *((char *)buf->vb.baddr + 3);
-				memcpy((char *)buf->vb.baddr,
-				      (char *)buf->vb.baddr + (chan->width * 2),
-				      (chan->width * 2));
-				*((char *)buf->vb.baddr + 3) = cam_id;
-			}
-		}
+	/* This doesn't belong in poll(). This can be done
+	 * much better with vb2. We keep this code here as a
+	 * reminder.
+	if ((res & POLLIN) && buf->vb.state == VIDEOBUF_DONE) {
+		struct cx25821_dev *dev = chan->dev;
 
-		return POLLIN | POLLRDNORM;
+		if (dev && chan->use_cif_resolution) {
+			u8 cam_id = *((char *)buf->vb.baddr + 3);
+			memcpy((char *)buf->vb.baddr,
+					(char *)buf->vb.baddr + (chan->width * 2),
+					(chan->width * 2));
+			*((char *)buf->vb.baddr + 3) = cam_id;
+		}
 	}
-
-	return 0;
+	 */
 }
 
 static int video_release(struct file *file)
@@ -677,11 +618,10 @@ static int video_release(struct file *file)
 	cx_write(sram_ch->dma_ctl, 0); /* FIFO and RISC disable */
 
 	/* stop video capture */
-	if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
+	if (chan->streaming_fh == fh) {
 		videobuf_queue_cancel(&chan->vidq);
-		cx25821_res_free(dev, fh, RESOURCE_VIDEO0);
+		chan->streaming_fh = NULL;
 	}
-	mutex_unlock(&dev->lock);
 
 	if (chan->vidq.read_buf) {
 		cx25821_buffer_release(&chan->vidq, chan->vidq.read_buf);
@@ -689,6 +629,7 @@ static int video_release(struct file *file)
 	}
 
 	videobuf_mmap_free(&chan->vidq);
+	mutex_unlock(&dev->lock);
 
 	v4l2_prio_close(&chan->prio, fh->prio);
 	file->private_data = NULL;
@@ -765,14 +706,13 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = fh->dev;
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (!cx25821_res_get(dev, fh,
-			cx25821_get_resource(fh, RESOURCE_VIDEO0)))
+	if (chan->streaming_fh && chan->streaming_fh != fh)
 		return -EBUSY;
+	chan->streaming_fh = fh;
 
 	return videobuf_streamon(&chan->vidq);
 }
@@ -781,18 +721,17 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = fh->dev;
-	int err, res;
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	res = cx25821_get_resource(fh, RESOURCE_VIDEO0);
-	err = videobuf_streamoff(&chan->vidq);
-	if (err < 0)
-		return err;
-	cx25821_res_free(dev, fh, res);
-	return 0;
+	if (chan->streaming_fh && chan->streaming_fh != fh)
+		return -EBUSY;
+	if (chan->streaming_fh == NULL)
+		return 0;
+
+	chan->streaming_fh = NULL;
+	return videobuf_streamoff(&chan->vidq);
 }
 
 static int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm)
@@ -1483,7 +1422,6 @@ int cx25821_video_register(struct cx25821_dev *dev)
 			chan->sram_channels->dma_ctl, 0x11, 0);
 
 		chan->sram_channels = &cx25821_sram_channels[i];
-		chan->resources = 0;
 		chan->width = 720;
 		if (dev->tvnorm & V4L2_STD_625_50)
 			chan->height = 576;
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 06dadb5..128c9f3 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -118,7 +118,6 @@ struct cx25821_tvnorm {
 
 struct cx25821_fh {
 	struct cx25821_dev *dev;
-	u32 resources;
 
 	enum v4l2_priority prio;
 
@@ -208,6 +207,7 @@ struct cx25821_dev;
 struct cx25821_channel {
 	unsigned id;
 	struct cx25821_dev *dev;
+	struct cx25821_fh *streaming_fh;
 	struct v4l2_prio_state prio;
 
 	struct v4l2_ctrl_handler hdl;
@@ -219,8 +219,6 @@ struct cx25821_channel {
 
 	const struct sram_channel *sram_channels;
 
-	int resources;
-
 	const struct cx25821_fmt *fmt;
 	unsigned int width, height;
 	int pixel_formats;
@@ -260,7 +258,6 @@ struct cx25821_dev {
 	char name[32];
 
 	/* Analog video */
-	u32 resources;
 	unsigned int input;
 	v4l2_std_id tvnorm;
 	unsigned short _max_num_decoders;
-- 
1.7.10.4

