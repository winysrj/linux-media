Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2153 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3DNP1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 21/30] cx25821: switch to v4l2_fh, add event and prio handling.
Date: Sun, 14 Apr 2013 17:27:17 +0200
Message-Id: <1365953246-8972-22-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It is now possible to remove cx25821_fh and replace it with v4l2_fh,
which in turn makes event handling and core prio handling possible.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |  193 +++++++++--------------------
 drivers/media/pci/cx25821/cx25821-video.h |    1 +
 drivers/media/pci/cx25821/cx25821.h       |   13 +-
 3 files changed, 59 insertions(+), 148 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index e7a2db1..f82da1e 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -337,7 +337,6 @@ static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buff
 	u32 line0_offset;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int bpl_local = LINE_SIZE_D1;
-	int channel_opened = chan->id;
 
 	BUG_ON(NULL == chan->fmt);
 	if (chan->width < 48 || chan->width > 720 ||
@@ -371,33 +370,22 @@ static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buff
 	dprintk(1, "init_buffer=%d\n", init_buffer);
 
 	if (init_buffer) {
-		channel_opened = dev->channel_opened;
-		if (channel_opened < 0 || channel_opened > 7)
-			channel_opened = 7;
-
-		if (dev->channels[channel_opened].pixel_formats ==
-				PIXEL_FRMT_411)
+		if (chan->pixel_formats == PIXEL_FRMT_411)
 			buf->bpl = (buf->fmt->depth * buf->vb.width) >> 3;
 		else
 			buf->bpl = (buf->fmt->depth >> 3) * (buf->vb.width);
 
-		if (dev->channels[channel_opened].pixel_formats ==
-				PIXEL_FRMT_411) {
+		if (chan->pixel_formats == PIXEL_FRMT_411) {
 			bpl_local = buf->bpl;
 		} else {
 			bpl_local = buf->bpl;   /* Default */
 
-			if (channel_opened >= 0 && channel_opened <= 7) {
-				if (dev->channels[channel_opened]
-						.use_cif_resolution) {
-					if (dev->tvnorm & V4L2_STD_PAL_BG ||
-					    dev->tvnorm & V4L2_STD_PAL_DK)
-						bpl_local = 352 << 1;
-					else
-						bpl_local = dev->channels[
-							channel_opened].
-							cif_width << 1;
-				}
+			if (chan->use_cif_resolution) {
+				if (dev->tvnorm & V4L2_STD_PAL_BG ||
+						dev->tvnorm & V4L2_STD_PAL_DK)
+					bpl_local = 352 << 1;
+				else
+					bpl_local = chan->cif_width << 1;
 			}
 		}
 
@@ -534,36 +522,12 @@ static struct videobuf_queue_ops cx25821_video_qops = {
 	.buf_release = cx25821_buffer_release,
 };
 
-static int video_open(struct file *file)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	struct cx25821_fh *fh;
-
-	/* allocate + initialize per filehandle data */
-	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh)
-		return -ENOMEM;
-
-	file->private_data = fh;
-	fh->dev = dev;
-	fh->channel_id = chan->id;
-
-	dev->channel_opened = fh->channel_id;
-
-	v4l2_prio_open(&chan->prio, &fh->prio);
-
-	dprintk(1, "post videobuf_queue_init()\n");
-
-	return 0;
-}
-
 static ssize_t video_read(struct file *file, char __user * data, size_t count,
 			 loff_t *ppos)
 {
-	struct cx25821_fh *fh = file->private_data;
+	struct v4l2_fh *fh = file->private_data;
 	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_dev *dev = chan->dev;
 	int err = 0;
 
 	if (mutex_lock_interruptible(&dev->lock))
@@ -585,8 +549,12 @@ static unsigned int video_poll(struct file *file,
 			      struct poll_table_struct *wait)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned int res = v4l2_ctrl_poll(file, wait);
 
-	return videobuf_poll_stream(file, &chan->vidq, wait);
+	if (req_events & (POLLIN | POLLRDNORM))
+		res |= videobuf_poll_stream(file, &chan->vidq, wait);
+	return res;
 
 	/* This doesn't belong in poll(). This can be done
 	 * much better with vb2. We keep this code here as a
@@ -608,7 +576,7 @@ static unsigned int video_poll(struct file *file,
 static int video_release(struct file *file)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_fh *fh = file->private_data;
+	struct v4l2_fh *fh = file->private_data;
 	struct cx25821_dev *dev = chan->dev;
 	const struct sram_channel *sram_ch =
 		dev->channels[0].sram_channels;
@@ -631,11 +599,7 @@ static int video_release(struct file *file)
 	videobuf_mmap_free(&chan->vidq);
 	mutex_unlock(&dev->lock);
 
-	v4l2_prio_close(&chan->prio, fh->prio);
-	file->private_data = NULL;
-	kfree(fh);
-
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 /* VIDEO IOCTLS */
@@ -705,14 +669,13 @@ static int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_fh *fh = priv;
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (chan->streaming_fh && chan->streaming_fh != fh)
+	if (chan->streaming_fh && chan->streaming_fh != priv)
 		return -EBUSY;
-	chan->streaming_fh = fh;
+	chan->streaming_fh = priv;
 
 	return videobuf_streamon(&chan->vidq);
 }
@@ -720,12 +683,11 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_fh *fh = priv;
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (chan->streaming_fh && chan->streaming_fh != fh)
+	if (chan->streaming_fh && chan->streaming_fh != priv)
 		return -EBUSY;
 	if (chan->streaming_fh == NULL)
 		return 0;
@@ -774,20 +736,12 @@ static int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm)
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct cx25821_fh *fh = priv;
 	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	struct cx25821_dev *dev = chan->dev;
 	struct v4l2_mbus_framefmt mbus_fmt;
 	int err;
 	int pix_format = PIXEL_FRMT_422;
 
-	if (fh) {
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	}
-
 	err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
 
 	if (0 != err)
@@ -840,10 +794,9 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 
 static int vidioc_log_status(struct file *file, void *priv)
 {
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	struct cx25821_fh *fh = priv;
-	const struct sram_channel *sram_ch =
-		dev->channels[fh->channel_id].sram_channels;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
+	const struct sram_channel *sram_ch = chan->sram_channels;
 	u32 tmp = 0;
 
 	cx25821_call_all(dev, core, log_status);
@@ -857,8 +810,8 @@ static int vidioc_log_status(struct file *file, void *priv)
 static int cx25821_vidioc_querycap(struct file *file, void *priv,
 			    struct v4l2_capability *cap)
 {
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	struct cx25821_fh *fh = priv;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	const u32 cap_input = V4L2_CAP_VIDEO_CAPTURE |
 			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT;
@@ -866,7 +819,7 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 	strcpy(cap->driver, "cx25821");
 	strlcpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
-	if (fh->channel_id >= VID_CHANNEL_NUM)
+	if (chan->id >= VID_CHANNEL_NUM)
 		cap->device_caps = cap_output;
 	else
 		cap->device_caps = cap_input;
@@ -909,46 +862,18 @@ static int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer
 	return videobuf_qbuf(&chan->vidq, p);
 }
 
-static int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
-{
-	struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;
-	struct cx25821_fh *fh = f;
-
-	*p = v4l2_prio_max(&dev->channels[fh->channel_id].prio);
-
-	return 0;
-}
-
-static int cx25821_vidioc_s_priority(struct file *file, void *f,
-			      enum v4l2_priority prio)
-{
-	struct cx25821_fh *fh = f;
-	struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;
-
-	return v4l2_prio_change(&dev->channels[fh->channel_id].prio, &fh->prio,
-			prio);
-}
-
 static int cx25821_vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
 {
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
 
-	*tvnorms = dev->tvnorm;
+	*tvnorms = chan->dev->tvnorm;
 	return 0;
 }
 
 int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 {
-	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	int err;
-
-	if (fh) {
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	}
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 
 	if (dev->tvnorm == tvnorms)
 		return 0;
@@ -968,7 +893,8 @@ static int cx25821_vidioc_enum_input(struct file *file, void *priv,
 		[CX25821_VMUX_SVIDEO] = "S-Video",
 		[CX25821_VMUX_DEBUG] = "for debug only",
 	};
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	unsigned int n;
 
 	n = i->index;
@@ -987,7 +913,8 @@ static int cx25821_vidioc_enum_input(struct file *file, void *priv,
 
 static int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 
 	*i = dev->input;
 	return 0;
@@ -995,16 +922,8 @@ static int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i
 
 static int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
-	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	int err;
-
-	if (fh) {
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	}
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 
 	if (i >= CX25821_NR_INPUT || INPUT(i)->type == 0)
 		return -EINVAL;
@@ -1017,7 +936,8 @@ static int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 int cx25821_vidioc_g_register(struct file *file, void *fh,
 		      struct v4l2_dbg_register *reg)
 {
-	struct cx25821_dev *dev = ((struct cx25821_fh *)fh)->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 
 	if (!v4l2_chip_match_host(&reg->match))
 		return -EINVAL;
@@ -1030,7 +950,8 @@ int cx25821_vidioc_g_register(struct file *file, void *fh,
 int cx25821_vidioc_s_register(struct file *file, void *fh,
 		      const struct v4l2_dbg_register *reg)
 {
-	struct cx25821_dev *dev = ((struct cx25821_fh *)fh)->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 
 	if (!v4l2_chip_match_host(&reg->match))
 		return -EINVAL;
@@ -1070,8 +991,8 @@ static int cx25821_s_ctrl(struct v4l2_ctrl *ctrl)
 static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
-	struct cx25821_fh *fh = file->private_data;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	int command = 0;
 	struct upstream_user_struct *data_from_user;
 
@@ -1110,8 +1031,8 @@ static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
-	struct cx25821_fh *fh = file->private_data;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	int command = 0;
 	struct upstream_user_struct *data_from_user;
 
@@ -1150,8 +1071,8 @@ static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
 static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
-	struct cx25821_fh *fh = file->private_data;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	int command = 0;
 	struct upstream_user_struct *data_from_user;
 
@@ -1190,8 +1111,8 @@ static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 static long video_ioctl_set(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
-	struct cx25821_fh *fh = file->private_data;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	struct downstream_user_struct *data_from_user;
 	int command;
 	int width = 720;
@@ -1300,18 +1221,17 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 static long cx25821_video_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
+	struct cx25821_channel *chan = video_drvdata(file);
 	int ret = 0;
 
-	struct cx25821_fh *fh = file->private_data;
-
 	/* check to see if it's the video upstream */
-	if (fh->channel_id == SRAM_CH09) {
+	if (chan->id == SRAM_CH09) {
 		ret = video_ioctl_upstream9(file, cmd, arg);
 		return ret;
-	} else if (fh->channel_id == SRAM_CH10) {
+	} else if (chan->id == SRAM_CH10) {
 		ret = video_ioctl_upstream10(file, cmd, arg);
 		return ret;
-	} else if (fh->channel_id == SRAM_CH11) {
+	} else if (chan->id == SRAM_CH11) {
 		ret = video_ioctl_upstream11(file, cmd, arg);
 		ret = video_ioctl_set(file, cmd, arg);
 		return ret;
@@ -1326,7 +1246,7 @@ static const struct v4l2_ctrl_ops cx25821_ctrl_ops = {
 
 static const struct v4l2_file_operations video_fops = {
 	.owner = THIS_MODULE,
-	.open = video_open,
+	.open = v4l2_fh_open,
 	.release = video_release,
 	.read = video_read,
 	.poll = video_poll,
@@ -1352,8 +1272,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_log_status = vidioc_log_status,
-	.vidioc_g_priority = cx25821_vidioc_g_priority,
-	.vidioc_s_priority = cx25821_vidioc_s_priority,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register = cx25821_vidioc_g_register,
 	.vidioc_s_register = cx25821_vidioc_s_register,
@@ -1454,6 +1374,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		vdev->v4l2_dev = &dev->v4l2_dev;
 		vdev->ctrl_handler = hdl;
 		vdev->lock = &dev->lock;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
 		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
 		video_set_drvdata(vdev, chan);
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index b0f0d53..eb54e53 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -39,6 +39,7 @@
 #include "cx25821.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 
 #define VIDEO_DEBUG 0
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 128c9f3..40b16b0 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -116,15 +116,6 @@ struct cx25821_tvnorm {
 	u32 cxoformat;
 };
 
-struct cx25821_fh {
-	struct cx25821_dev *dev;
-
-	enum v4l2_priority prio;
-
-	/* video capture */
-	int channel_id;
-};
-
 enum cx25821_itype {
 	CX25821_VMUX_COMPOSITE = 1,
 	CX25821_VMUX_SVIDEO,
@@ -207,8 +198,7 @@ struct cx25821_dev;
 struct cx25821_channel {
 	unsigned id;
 	struct cx25821_dev *dev;
-	struct cx25821_fh *streaming_fh;
-	struct v4l2_prio_state prio;
+	struct v4l2_fh *streaming_fh;
 
 	struct v4l2_ctrl_handler hdl;
 	struct cx25821_data timeout_data;
@@ -360,7 +350,6 @@ struct cx25821_dev {
 	int pixel_format;
 	int channel_select;
 	int command;
-	int channel_opened;
 };
 
 struct upstream_user_struct {
-- 
1.7.10.4

