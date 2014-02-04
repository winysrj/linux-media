Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.56.216.30]:49938 "EHLO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932957AbaBDV0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Feb 2014 16:26:39 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway07.websitewelcome.com (Postfix) with ESMTP id B2A6B930B17ED
	for <linux-media@vger.kernel.org>; Tue,  4 Feb 2014 15:05:04 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: refactoring s2255_channel to s2255_vc
Date: Tue,  4 Feb 2014 13:04:58 -0800
Message-Id: <1391547898-7593-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Renaming s2255_channel and all instances of channel to vc (video channel).

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |  469 ++++++++++++++++++------------------
 1 file changed, 235 insertions(+), 234 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 5f09a56..e8b7096 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -212,7 +212,8 @@ struct s2255_pipeinfo {
 struct s2255_fmt; /*forward declaration */
 struct s2255_dev;
 
-struct s2255_channel {
+/* 2255 video channel */
+struct s2255_vc {
 	struct s2255_dev        *dev;
 	struct video_device	vdev;
 	struct v4l2_ctrl_handler hdl;
@@ -254,7 +255,7 @@ struct s2255_channel {
 
 
 struct s2255_dev {
-	struct s2255_channel    channel[MAX_CHANNELS];
+	struct s2255_vc         vc[MAX_CHANNELS];
 	struct v4l2_device      v4l2_dev;
 	atomic_t                num_channels;
 	int			frames;
@@ -298,7 +299,7 @@ struct s2255_fh {
 	struct s2255_dev	*dev;
 	struct videobuf_queue	vb_vidq;
 	enum v4l2_buf_type	type;
-	struct s2255_channel	*channel;
+	struct s2255_vc	*vc;
 	int			resources;
 };
 
@@ -351,11 +352,11 @@ static int debug;
 
 static int s2255_start_readpipe(struct s2255_dev *dev);
 static void s2255_stop_readpipe(struct s2255_dev *dev);
-static int s2255_start_acquire(struct s2255_channel *channel);
-static int s2255_stop_acquire(struct s2255_channel *channel);
-static void s2255_fillbuff(struct s2255_channel *chn, struct s2255_buffer *buf,
+static int s2255_start_acquire(struct s2255_vc *vc);
+static int s2255_stop_acquire(struct s2255_vc *vc);
+static void s2255_fillbuff(struct s2255_vc *chn, struct s2255_buffer *buf,
 			   int jpgsize);
-static int s2255_set_mode(struct s2255_channel *chan, struct s2255_mode *mode);
+static int s2255_set_mode(struct s2255_vc *chan, struct s2255_mode *mode);
 static int s2255_board_shutdown(struct s2255_dev *dev);
 static void s2255_fwload_start(struct s2255_dev *dev, int reset);
 static void s2255_destroy(struct s2255_dev *dev);
@@ -434,27 +435,27 @@ static const struct s2255_fmt formats[] = {
 	}
 };
 
-static int norm_maxw(struct s2255_channel *channel)
+static int norm_maxw(struct s2255_vc *vc)
 {
-	return (channel->std & V4L2_STD_525_60) ?
+	return (vc->std & V4L2_STD_525_60) ?
 	    LINE_SZ_4CIFS_NTSC : LINE_SZ_4CIFS_PAL;
 }
 
-static int norm_maxh(struct s2255_channel *channel)
+static int norm_maxh(struct s2255_vc *vc)
 {
-	return (channel->std & V4L2_STD_525_60) ?
+	return (vc->std & V4L2_STD_525_60) ?
 	    (NUM_LINES_1CIFS_NTSC * 2) : (NUM_LINES_1CIFS_PAL * 2);
 }
 
-static int norm_minw(struct s2255_channel *channel)
+static int norm_minw(struct s2255_vc *vc)
 {
-	return (channel->std & V4L2_STD_525_60) ?
+	return (vc->std & V4L2_STD_525_60) ?
 	    LINE_SZ_1CIFS_NTSC : LINE_SZ_1CIFS_PAL;
 }
 
-static int norm_minh(struct s2255_channel *channel)
+static int norm_minh(struct s2255_vc *vc)
 {
-	return (channel->std & V4L2_STD_525_60) ?
+	return (vc->std & V4L2_STD_525_60) ?
 	    (NUM_LINES_1CIFS_NTSC) : (NUM_LINES_1CIFS_PAL);
 }
 
@@ -567,23 +568,23 @@ static void s2255_fwchunk_complete(struct urb *urb)
 
 }
 
-static int s2255_got_frame(struct s2255_channel *channel, int jpgsize)
+static int s2255_got_frame(struct s2255_vc *vc, int jpgsize)
 {
 	struct s2255_buffer *buf;
-	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
+	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
 	unsigned long flags = 0;
 	int rc = 0;
 	spin_lock_irqsave(&dev->slock, flags);
-	if (list_empty(&channel->buf_list)) {
+	if (list_empty(&vc->buf_list)) {
 		dprintk(dev, 1, "No active queue to serve\n");
 		rc = -1;
 		goto unlock;
 	}
-	buf = list_entry(channel->buf_list.next,
+	buf = list_entry(vc->buf_list.next,
 			 struct s2255_buffer, vb.queue);
 	list_del(&buf->vb.queue);
 	v4l2_get_timestamp(&buf->vb.ts);
-	s2255_fillbuff(channel, buf, jpgsize);
+	s2255_fillbuff(vc, buf, jpgsize);
 	wake_up(&buf->vb.done);
 	dprintk(dev, 2, "%s: [buf/i] [%p/%d]\n", __func__, buf, buf->vb.i);
 unlock:
@@ -614,21 +615,21 @@ static const struct s2255_fmt *format_by_fourcc(int fourcc)
  *                  http://v4l.videotechnology.com/
  *
  */
-static void s2255_fillbuff(struct s2255_channel *channel,
+static void s2255_fillbuff(struct s2255_vc *vc,
 			   struct s2255_buffer *buf, int jpgsize)
 {
 	int pos = 0;
 	const char *tmpbuf;
 	char *vbuf = videobuf_to_vmalloc(&buf->vb);
 	unsigned long last_frame;
-	struct s2255_dev *dev = channel->dev;
+	struct s2255_dev *dev = vc->dev;
 
 	if (!vbuf)
 		return;
-	last_frame = channel->last_frame;
+	last_frame = vc->last_frame;
 	if (last_frame != -1) {
 		tmpbuf =
-		    (const char *)channel->buffer.frame[last_frame].lpvbits;
+		    (const char *)vc->buffer.frame[last_frame].lpvbits;
 		switch (buf->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
 		case V4L2_PIX_FMT_UYVY:
@@ -652,7 +653,7 @@ static void s2255_fillbuff(struct s2255_channel *channel,
 		default:
 			pr_info("s2255: unknown format?\n");
 		}
-		channel->last_frame = -1;
+		vc->last_frame = -1;
 	} else {
 		pr_err("s2255: =======no frame\n");
 		return;
@@ -660,7 +661,7 @@ static void s2255_fillbuff(struct s2255_channel *channel,
 	dprintk(dev, 2, "s2255fill at : Buffer 0x%08lx size= %d\n",
 		(unsigned long)vbuf, pos);
 	/* tell v4l buffer was filled */
-	buf->vb.field_count = channel->frame_count * 2;
+	buf->vb.field_count = vc->frame_count * 2;
 	v4l2_get_timestamp(&buf->vb.ts);
 	buf->vb.state = VIDEOBUF_DONE;
 }
@@ -674,8 +675,8 @@ static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
 			unsigned int *size)
 {
 	struct s2255_fh *fh = vq->priv_data;
-	struct s2255_channel *channel = fh->channel;
-	*size = channel->width * channel->height * (channel->fmt->depth >> 3);
+	struct s2255_vc *vc = fh->vc;
+	*size = vc->width * vc->height * (vc->fmt->depth >> 3);
 
 	if (0 == *count)
 		*count = S2255_DEF_BUFS;
@@ -696,29 +697,29 @@ static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 			  enum v4l2_field field)
 {
 	struct s2255_fh *fh = vq->priv_data;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	int rc;
-	int w = channel->width;
-	int h = channel->height;
+	int w = vc->width;
+	int h = vc->height;
 	dprintk(fh->dev, 4, "%s, field=%d\n", __func__, field);
-	if (channel->fmt == NULL)
+	if (vc->fmt == NULL)
 		return -EINVAL;
 
-	if ((w < norm_minw(channel)) ||
-	    (w > norm_maxw(channel)) ||
-	    (h < norm_minh(channel)) ||
-	    (h > norm_maxh(channel))) {
+	if ((w < norm_minw(vc)) ||
+	    (w > norm_maxw(vc)) ||
+	    (h < norm_minh(vc)) ||
+	    (h > norm_maxh(vc))) {
 		dprintk(fh->dev, 4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
-	buf->vb.size = w * h * (channel->fmt->depth >> 3);
+	buf->vb.size = w * h * (vc->fmt->depth >> 3);
 	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size) {
 		dprintk(fh->dev, 4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
 
-	buf->fmt = channel->fmt;
+	buf->fmt = vc->fmt;
 	buf->vb.width = w;
 	buf->vb.height = h;
 	buf->vb.field = field;
@@ -740,10 +741,10 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	struct s2255_fh *fh = vq->priv_data;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	dprintk(fh->dev, 1, "%s\n", __func__);
 	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &channel->buf_list);
+	list_add_tail(&buf->vb.queue, &vc->buf_list);
 }
 
 static void buffer_release(struct videobuf_queue *vq,
@@ -751,7 +752,7 @@ static void buffer_release(struct videobuf_queue *vq,
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	struct s2255_fh *fh = vq->priv_data;
-	dprintk(fh->dev, 4, "%s %d\n", __func__, fh->channel->idx);
+	dprintk(fh->dev, 4, "%s %d\n", __func__, fh->vc->idx);
 	free_buffer(vq, buf);
 }
 
@@ -765,12 +766,12 @@ static struct videobuf_queue_ops s2255_video_qops = {
 
 static int res_get(struct s2255_fh *fh)
 {
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	/* is it free? */
-	if (channel->resources)
+	if (vc->resources)
 		return 0; /* no, someone else uses it */
 	/* it's free, grab it */
-	channel->resources = 1;
+	vc->resources = 1;
 	fh->resources = 1;
 	dprintk(fh->dev, 1, "s2255: res: get\n");
 	return 1;
@@ -778,7 +779,7 @@ static int res_get(struct s2255_fh *fh)
 
 static int res_locked(struct s2255_fh *fh)
 {
-	return fh->channel->resources;
+	return fh->vc->resources;
 }
 
 static int res_check(struct s2255_fh *fh)
@@ -789,8 +790,8 @@ static int res_check(struct s2255_fh *fh)
 
 static void res_free(struct s2255_fh *fh)
 {
-	struct s2255_channel *channel = fh->channel;
-	channel->resources = 0;
+	struct s2255_vc *vc = fh->vc;
+	vc->resources = 0;
 	fh->resources = 0;
 }
 
@@ -827,18 +828,18 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
-	int is_ntsc = channel->std & V4L2_STD_525_60;
+	struct s2255_vc *vc = fh->vc;
+	int is_ntsc = vc->std & V4L2_STD_525_60;
 
-	f->fmt.pix.width = channel->width;
-	f->fmt.pix.height = channel->height;
+	f->fmt.pix.width = vc->width;
+	f->fmt.pix.height = vc->height;
 	if (f->fmt.pix.height >=
 	    (is_ntsc ? NUM_LINES_1CIFS_NTSC : NUM_LINES_1CIFS_PAL) * 2)
 		f->fmt.pix.field = V4L2_FIELD_INTERLACED;
 	else
 		f->fmt.pix.field = V4L2_FIELD_TOP;
-	f->fmt.pix.pixelformat = channel->fmt->fourcc;
-	f->fmt.pix.bytesperline = f->fmt.pix.width * (channel->fmt->depth >> 3);
+	f->fmt.pix.pixelformat = vc->fmt->fourcc;
+	f->fmt.pix.bytesperline = f->fmt.pix.width * (vc->fmt->depth >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.priv = 0;
@@ -851,8 +852,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	const struct s2255_fmt *fmt;
 	enum v4l2_field field;
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
-	int is_ntsc = channel->std & V4L2_STD_525_60;
+	struct s2255_vc *vc = fh->vc;
+	int is_ntsc = vc->std & V4L2_STD_525_60;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 
@@ -912,7 +913,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	const struct s2255_fmt *fmt;
 	struct videobuf_queue *q = &fh->vb_vidq;
 	struct s2255_mode mode;
@@ -941,15 +942,15 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		ret = -EBUSY;
 		goto out_s_fmt;
 	}
-	mode = channel->mode;
-	channel->fmt = fmt;
-	channel->width = f->fmt.pix.width;
-	channel->height = f->fmt.pix.height;
+	mode = vc->mode;
+	vc->fmt = fmt;
+	vc->width = f->fmt.pix.width;
+	vc->height = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type = f->type;
-	if (channel->width > norm_minw(channel)) {
-		if (channel->height > norm_minh(channel)) {
-			if (channel->cap_parm.capturemode &
+	if (vc->width > norm_minw(vc)) {
+		if (vc->height > norm_minh(vc)) {
+			if (vc->cap_parm.capturemode &
 			    V4L2_MODE_HIGHQUALITY)
 				mode.scale = SCALE_4CIFSI;
 			else
@@ -961,7 +962,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		mode.scale = SCALE_1CIFS;
 	}
 	/* color mode */
-	switch (channel->fmt->fourcc) {
+	switch (vc->fmt->fourcc) {
 	case V4L2_PIX_FMT_GREY:
 		mode.color &= ~MASK_COLOR;
 		mode.color |= COLOR_Y8;
@@ -970,7 +971,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	case V4L2_PIX_FMT_MJPEG:
 		mode.color &= ~MASK_COLOR;
 		mode.color |= COLOR_JPG;
-		mode.color |= (channel->jpegqual << 8);
+		mode.color |= (vc->jpegqual << 8);
 		break;
 	case V4L2_PIX_FMT_YUV422P:
 		mode.color &= ~MASK_COLOR;
@@ -983,14 +984,14 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		mode.color |= COLOR_YUVPK;
 		break;
 	}
-	if ((mode.color & MASK_COLOR) != (channel->mode.color & MASK_COLOR))
+	if ((mode.color & MASK_COLOR) != (vc->mode.color & MASK_COLOR))
 		mode.restart = 1;
-	else if (mode.scale != channel->mode.scale)
+	else if (mode.scale != vc->mode.scale)
 		mode.restart = 1;
-	else if (mode.format != channel->mode.format)
+	else if (mode.format != vc->mode.format)
 		mode.restart = 1;
-	channel->mode = mode;
-	(void) s2255_set_mode(channel, &mode);
+	vc->mode = mode;
+	(void) s2255_set_mode(vc, &mode);
 	ret = 0;
 out_s_fmt:
 	mutex_unlock(&q->vb_lock);
@@ -1126,28 +1127,28 @@ static void s2255_print_cfg(struct s2255_dev *sdev, struct s2255_mode *mode)
  * When the restart parameter is set, we sleep for ONE frame to allow the
  * DSP time to get the new frame
  */
-static int s2255_set_mode(struct s2255_channel *channel,
+static int s2255_set_mode(struct s2255_vc *vc,
 			  struct s2255_mode *mode)
 {
 	int res;
 	__le32 *buffer;
 	unsigned long chn_rev;
-	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
+	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
 	int i;
 
-	chn_rev = G_chnmap[channel->idx];
-	dprintk(dev, 3, "%s channel: %d\n", __func__, channel->idx);
+	chn_rev = G_chnmap[vc->idx];
+	dprintk(dev, 3, "%s channel: %d\n", __func__, vc->idx);
 	/* if JPEG, set the quality */
 	if ((mode->color & MASK_COLOR) == COLOR_JPG) {
 		mode->color &= ~MASK_COLOR;
 		mode->color |= COLOR_JPG;
 		mode->color &= ~MASK_JPG_QUALITY;
-		mode->color |= (channel->jpegqual << 8);
+		mode->color |= (vc->jpegqual << 8);
 	}
 	/* save the mode */
-	channel->mode = *mode;
-	channel->req_image_size = get_transfer_size(mode);
-	dprintk(dev, 1, "%s: reqsize %ld\n", __func__, channel->req_image_size);
+	vc->mode = *mode;
+	vc->req_image_size = get_transfer_size(mode);
+	dprintk(dev, 1, "%s: reqsize %ld\n", __func__, vc->req_image_size);
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -1158,36 +1159,36 @@ static int s2255_set_mode(struct s2255_channel *channel,
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
 	buffer[2] = CMD_SET_MODE;
 	for (i = 0; i < sizeof(struct s2255_mode) / sizeof(u32); i++)
-		buffer[3 + i] = cpu_to_le32(((u32 *)&channel->mode)[i]);
-	channel->setmode_ready = 0;
+		buffer[3 + i] = cpu_to_le32(((u32 *)&vc->mode)[i]);
+	vc->setmode_ready = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
 		s2255_print_cfg(dev, mode);
 	kfree(buffer);
 	/* wait at least 3 frames before continuing */
 	if (mode->restart) {
-		wait_event_timeout(channel->wait_setmode,
-				   (channel->setmode_ready != 0),
+		wait_event_timeout(vc->wait_setmode,
+				   (vc->setmode_ready != 0),
 				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
-		if (channel->setmode_ready != 1) {
+		if (vc->setmode_ready != 1) {
 			dprintk(dev, 0, "s2255: no set mode response\n");
 			res = -EFAULT;
 		}
 	}
 	/* clear the restart flag */
-	channel->mode.restart = 0;
-	dprintk(dev, 1, "%s chn %d, result: %d\n", __func__, channel->idx, res);
+	vc->mode.restart = 0;
+	dprintk(dev, 1, "%s chn %d, result: %d\n", __func__, vc->idx, res);
 	return res;
 }
 
-static int s2255_cmd_status(struct s2255_channel *channel, u32 *pstatus)
+static int s2255_cmd_status(struct s2255_vc *vc, u32 *pstatus)
 {
 	int res;
 	__le32 *buffer;
 	u32 chn_rev;
-	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
-	chn_rev = G_chnmap[channel->idx];
-	dprintk(dev, 4, "%s chan %d\n", __func__, channel->idx);
+	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
+	chn_rev = G_chnmap[vc->idx];
+	dprintk(dev, 4, "%s chan %d\n", __func__, vc->idx);
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -1198,17 +1199,17 @@ static int s2255_cmd_status(struct s2255_channel *channel, u32 *pstatus)
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
 	buffer[2] = CMD_STATUS;
 	*pstatus = 0;
-	channel->vidstatus_ready = 0;
+	vc->vidstatus_ready = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	kfree(buffer);
-	wait_event_timeout(channel->wait_vidstatus,
-			   (channel->vidstatus_ready != 0),
+	wait_event_timeout(vc->wait_vidstatus,
+			   (vc->vidstatus_ready != 0),
 			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
-	if (channel->vidstatus_ready != 1) {
+	if (vc->vidstatus_ready != 1) {
 		dprintk(dev, 0, "s2255: no vidstatus response\n");
 		res = -EFAULT;
 	}
-	*pstatus = channel->vidstatus;
+	*pstatus = vc->vidstatus;
 	dprintk(dev, 4, "%s, vid status %d\n", __func__, *pstatus);
 	return res;
 }
@@ -1218,7 +1219,7 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	int res;
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	int j;
 	dprintk(dev, 4, "%s\n", __func__);
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
@@ -1234,18 +1235,18 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 		s2255_dev_err(&dev->udev->dev, "stream busy\n");
 		return -EBUSY;
 	}
-	channel->last_frame = -1;
-	channel->bad_payload = 0;
-	channel->cur_frame = 0;
-	channel->frame_count = 0;
+	vc->last_frame = -1;
+	vc->bad_payload = 0;
+	vc->cur_frame = 0;
+	vc->frame_count = 0;
 	for (j = 0; j < SYS_FRAMES; j++) {
-		channel->buffer.frame[j].ulState = S2255_READ_IDLE;
-		channel->buffer.frame[j].cur_size = 0;
+		vc->buffer.frame[j].ulState = S2255_READ_IDLE;
+		vc->buffer.frame[j].cur_size = 0;
 	}
 	res = videobuf_streamon(&fh->vb_vidq);
 	if (res == 0) {
-		s2255_start_acquire(channel);
-		channel->b_acquire = 1;
+		s2255_start_acquire(vc);
+		vc->b_acquire = 1;
 	} else
 		res_free(fh);
 
@@ -1255,14 +1256,14 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct s2255_fh *fh = priv;
-	dprintk(fh->dev, 4, "%s\n, channel: %d", __func__, fh->channel->idx);
+	dprintk(fh->dev, 4, "%s\n, channel: %d", __func__, fh->vc->idx);
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		dprintk(fh->dev, 1, "invalid fh type0\n");
 		return -EINVAL;
 	}
 	if (i != fh->type)
 		return -EINVAL;
-	s2255_stop_acquire(fh->channel);
+	s2255_stop_acquire(fh->vc);
 	videobuf_streamoff(&fh->vb_vidq);
 	res_free(fh);
 	return 0;
@@ -1273,7 +1274,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 	struct s2255_fh *fh = priv;
 	struct s2255_mode mode;
 	struct videobuf_queue *q = &fh->vb_vidq;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	int ret = 0;
 
 	mutex_lock(&q->vb_lock);
@@ -1282,7 +1283,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 		ret = -EBUSY;
 		goto out_s_std;
 	}
-	mode = fh->channel->mode;
+	mode = fh->vc->mode;
 	if (i & V4L2_STD_525_60) {
 		dprintk(fh->dev, 4, "%s 60 Hz\n", __func__);
 		/* if changing format, reset frame decimation/intervals */
@@ -1290,8 +1291,8 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 			mode.restart = 1;
 			mode.format = FORMAT_NTSC;
 			mode.fdec = FDEC_1;
-			channel->width = LINE_SZ_4CIFS_NTSC;
-			channel->height = NUM_LINES_4CIFS_NTSC * 2;
+			vc->width = LINE_SZ_4CIFS_NTSC;
+			vc->height = NUM_LINES_4CIFS_NTSC * 2;
 		}
 	} else if (i & V4L2_STD_625_50) {
 		dprintk(fh->dev, 4, "%s 50 Hz\n", __func__);
@@ -1299,16 +1300,16 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 			mode.restart = 1;
 			mode.format = FORMAT_PAL;
 			mode.fdec = FDEC_1;
-			channel->width = LINE_SZ_4CIFS_PAL;
-			channel->height = NUM_LINES_4CIFS_PAL * 2;
+			vc->width = LINE_SZ_4CIFS_PAL;
+			vc->height = NUM_LINES_4CIFS_PAL * 2;
 		}
 	} else {
 		ret = -EINVAL;
 		goto out_s_std;
 	}
-	fh->channel->std = i;
+	fh->vc->std = i;
 	if (mode.restart)
-		s2255_set_mode(fh->channel, &mode);
+		s2255_set_mode(fh->vc, &mode);
 out_s_std:
 	mutex_unlock(&q->vb_lock);
 	return ret;
@@ -1318,7 +1319,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *i)
 {
 	struct s2255_fh *fh = priv;
 
-	*i = fh->channel->std;
+	*i = fh->vc->std;
 	return 0;
 }
 
@@ -1334,7 +1335,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	u32 status = 0;
 	if (inp->index != 0)
 		return -EINVAL;
@@ -1343,7 +1344,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	inp->status = 0;
 	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
 		int rc;
-		rc = s2255_cmd_status(fh->channel, &status);
+		rc = s2255_cmd_status(fh->vc, &status);
 		dprintk(dev, 4, "s2255_cmd_status rc: %d status %x\n",
 			rc, status);
 		if (rc == 0)
@@ -1356,7 +1357,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		strlcpy(inp->name, "Composite", sizeof(inp->name));
 		break;
 	case 0x2257:
-		strlcpy(inp->name, (channel->idx < 2) ? "Composite" : "S-Video",
+		strlcpy(inp->name, (vc->idx < 2) ? "Composite" : "S-Video",
 			sizeof(inp->name));
 		break;
 	}
@@ -1377,10 +1378,10 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct s2255_channel *channel =
-		container_of(ctrl->handler, struct s2255_channel, hdl);
+	struct s2255_vc *vc =
+		container_of(ctrl->handler, struct s2255_vc, hdl);
 	struct s2255_mode mode;
-	mode = channel->mode;
+	mode = vc->mode;
 	/* update the mode to the corresponding value */
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
@@ -1400,7 +1401,7 @@ static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
 		mode.color |= !ctrl->val << 16;
 		break;
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
-		channel->jpegqual = ctrl->val;
+		vc->jpegqual = ctrl->val;
 		return 0;
 	default:
 		return -EINVAL;
@@ -1410,7 +1411,7 @@ static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
 	   some V4L programs restart stream unnecessarily
 	   after a s_crtl.
 	*/
-	s2255_set_mode(channel, &mode);
+	s2255_set_mode(vc, &mode);
 	return 0;
 }
 
@@ -1418,10 +1419,10 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 			 struct v4l2_jpegcompression *jc)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 
 	memset(jc, 0, sizeof(*jc));
-	jc->quality = channel->jpegqual;
+	jc->quality = vc->jpegqual;
 	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
@@ -1430,10 +1431,10 @@ static int vidioc_s_jpegcomp(struct file *file, void *priv,
 			 const struct v4l2_jpegcompression *jc)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	if (jc->quality < 0 || jc->quality > 100)
 		return -EINVAL;
-	v4l2_ctrl_s_ctrl(channel->jpegqual_ctrl, jc->quality);
+	v4l2_ctrl_s_ctrl(vc->jpegqual_ctrl, jc->quality);
 	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
@@ -1443,15 +1444,15 @@ static int vidioc_g_parm(struct file *file, void *priv,
 {
 	struct s2255_fh *fh = priv;
 	__u32 def_num, def_dem;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-	sp->parm.capture.capturemode = channel->cap_parm.capturemode;
-	def_num = (channel->mode.format == FORMAT_NTSC) ? 1001 : 1000;
-	def_dem = (channel->mode.format == FORMAT_NTSC) ? 30000 : 25000;
+	sp->parm.capture.capturemode = vc->cap_parm.capturemode;
+	def_num = (vc->mode.format == FORMAT_NTSC) ? 1001 : 1000;
+	def_dem = (vc->mode.format == FORMAT_NTSC) ? 30000 : 25000;
 	sp->parm.capture.timeperframe.denominator = def_dem;
-	switch (channel->mode.fdec) {
+	switch (vc->mode.fdec) {
 	default:
 	case FDEC_1:
 		sp->parm.capture.timeperframe.numerator = def_num;
@@ -1478,15 +1479,15 @@ static int vidioc_s_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *sp)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	struct s2255_mode mode;
 	int fdec = FDEC_1;
 	__u32 def_num, def_dem;
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	mode = channel->mode;
+	mode = vc->mode;
 	/* high quality capture mode requires a stream restart */
-	if (channel->cap_parm.capturemode
+	if (vc->cap_parm.capturemode
 	    != sp->parm.capture.capturemode && res_locked(fh))
 		return -EBUSY;
 	def_num = (mode.format == FORMAT_NTSC) ? 1001 : 1000;
@@ -1507,7 +1508,7 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	}
 	mode.fdec = fdec;
 	sp->parm.capture.timeperframe.denominator = def_dem;
-	s2255_set_mode(channel, &mode);
+	s2255_set_mode(vc, &mode);
 	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
 		__func__,
 		sp->parm.capture.capturemode,
@@ -1532,8 +1533,8 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 			    struct v4l2_frmsizeenum *fe)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
-	int is_ntsc = channel->std & V4L2_STD_525_60;
+	struct s2255_vc *vc = fh->vc;
+	int is_ntsc = vc->std & V4L2_STD_525_60;
 	const struct s2255_fmt *fmt;
 
 	if (fe->index >= NUM_SIZE_ENUMS)
@@ -1551,10 +1552,10 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 			    struct v4l2_frmivalenum *fe)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	const struct s2255_fmt *fmt;
 	const struct v4l2_frmsize_discrete *sizes;
-	int is_ntsc = channel->std & V4L2_STD_525_60;
+	int is_ntsc = vc->std & V4L2_STD_525_60;
 #define NUM_FRAME_ENUMS 4
 	int frm_dec[NUM_FRAME_ENUMS] = {1, 2, 3, 5};
 	int i;
@@ -1586,7 +1587,7 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 static int __s2255_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct s2255_channel *channel = video_drvdata(file);
+	struct s2255_vc *vc = video_drvdata(file);
 	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
 	struct s2255_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1663,19 +1664,19 @@ static int __s2255_open(struct file *file)
 	file->private_data = &fh->fh;
 	fh->dev = dev;
 	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	fh->channel = channel;
-	if (!channel->configured) {
+	fh->vc = vc;
+	if (!vc->configured) {
 		/* configure channel to default state */
-		channel->fmt = &formats[0];
-		s2255_set_mode(channel, &channel->mode);
-		channel->configured = 1;
+		vc->fmt = &formats[0];
+		s2255_set_mode(vc, &vc->mode);
+		vc->configured = 1;
 	}
 	dprintk(dev, 1, "%s: dev=%s type=%s\n", __func__,
 		video_device_node_name(vdev), v4l2_type_names[type]);
 	dprintk(dev, 2, "%s: fh=0x%08lx, dev=0x%08lx\n", __func__,
 		(unsigned long)fh, (unsigned long)dev);
 	dprintk(dev, 4, "%s: list_empty active=%d\n", __func__,
-		list_empty(&channel->buf_list));
+		list_empty(&vc->buf_list));
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
 				    NULL, &dev->slock,
 				    fh->type,
@@ -1741,14 +1742,14 @@ static int s2255_release(struct file *file)
 	struct s2255_fh *fh = file->private_data;
 	struct s2255_dev *dev = fh->dev;
 	struct video_device *vdev = video_devdata(file);
-	struct s2255_channel *channel = fh->channel;
+	struct s2255_vc *vc = fh->vc;
 	if (!dev)
 		return -ENODEV;
 	mutex_lock(&dev->lock);
 	/* turn off stream */
 	if (res_check(fh)) {
-		if (channel->b_acquire)
-			s2255_stop_acquire(fh->channel);
+		if (vc->b_acquire)
+			s2255_stop_acquire(fh->vc);
 		videobuf_streamoff(&fh->vb_vidq);
 		res_free(fh);
 	}
@@ -1820,13 +1821,13 @@ static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
 static void s2255_video_device_release(struct video_device *vdev)
 {
 	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
-	struct s2255_channel *channel =
-		container_of(vdev, struct s2255_channel, vdev);
+	struct s2255_vc *vc =
+		container_of(vdev, struct s2255_vc, vdev);
 
 	dprintk(dev, 4, "%s, chnls: %d\n", __func__,
 		atomic_read(&dev->num_channels));
 
-	v4l2_ctrl_handler_free(&channel->hdl);
+	v4l2_ctrl_handler_free(&vc->hdl);
 
 	if (atomic_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
@@ -1860,52 +1861,52 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 	int ret;
 	int i;
 	int cur_nr = video_nr;
-	struct s2255_channel *channel;
+	struct s2255_vc *vc;
 	ret = v4l2_device_register(&dev->interface->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
 	/* initialize all video 4 linux */
 	/* register 4 video devices */
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		channel = &dev->channel[i];
-		INIT_LIST_HEAD(&channel->buf_list);
+		vc = &dev->vc[i];
+		INIT_LIST_HEAD(&vc->buf_list);
 
-		v4l2_ctrl_handler_init(&channel->hdl, 6);
-		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+		v4l2_ctrl_handler_init(&vc->hdl, 6);
+		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
 				V4L2_CID_BRIGHTNESS, -127, 127, 1, DEF_BRIGHT);
-		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
 				V4L2_CID_CONTRAST, 0, 255, 1, DEF_CONTRAST);
-		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
 				V4L2_CID_SATURATION, 0, 255, 1, DEF_SATURATION);
-		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
+		v4l2_ctrl_new_std(&vc->hdl, &s2255_ctrl_ops,
 				V4L2_CID_HUE, 0, 255, 1, DEF_HUE);
-		channel->jpegqual_ctrl = v4l2_ctrl_new_std(&channel->hdl,
+		vc->jpegqual_ctrl = v4l2_ctrl_new_std(&vc->hdl,
 				&s2255_ctrl_ops,
 				V4L2_CID_JPEG_COMPRESSION_QUALITY,
 				0, 100, 1, S2255_DEF_JPEG_QUAL);
 		if (dev->dsp_fw_ver >= S2255_MIN_DSP_COLORFILTER &&
-		    (dev->pid != 0x2257 || channel->idx <= 1))
-			v4l2_ctrl_new_custom(&channel->hdl, &color_filter_ctrl,
+		    (dev->pid != 0x2257 || vc->idx <= 1))
+			v4l2_ctrl_new_custom(&vc->hdl, &color_filter_ctrl,
 					     NULL);
-		if (channel->hdl.error) {
-			ret = channel->hdl.error;
-			v4l2_ctrl_handler_free(&channel->hdl);
+		if (vc->hdl.error) {
+			ret = vc->hdl.error;
+			v4l2_ctrl_handler_free(&vc->hdl);
 			dev_err(&dev->udev->dev, "couldn't register control\n");
 			break;
 		}
 		/* register 4 video devices */
-		channel->vdev = template;
-		channel->vdev.ctrl_handler = &channel->hdl;
-		channel->vdev.lock = &dev->lock;
-		channel->vdev.v4l2_dev = &dev->v4l2_dev;
-		set_bit(V4L2_FL_USE_FH_PRIO, &channel->vdev.flags);
-		video_set_drvdata(&channel->vdev, channel);
+		vc->vdev = template;
+		vc->vdev.ctrl_handler = &vc->hdl;
+		vc->vdev.lock = &dev->lock;
+		vc->vdev.v4l2_dev = &dev->v4l2_dev;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vc->vdev.flags);
+		video_set_drvdata(&vc->vdev, vc);
 		if (video_nr == -1)
-			ret = video_register_device(&channel->vdev,
+			ret = video_register_device(&vc->vdev,
 						    VFL_TYPE_GRABBER,
 						    video_nr);
 		else
-			ret = video_register_device(&channel->vdev,
+			ret = video_register_device(&vc->vdev,
 						    VFL_TYPE_GRABBER,
 						    cur_nr + i);
 
@@ -1916,7 +1917,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 		}
 		atomic_inc(&dev->num_channels);
 		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
-			  video_device_node_name(&channel->vdev));
+			  video_device_node_name(&vc->vdev));
 
 	}
 	pr_info("Sensoray 2255 V4L driver Revision: %s\n",
@@ -1953,9 +1954,9 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 	s32 idx = -1;
 	struct s2255_framei *frm;
 	unsigned char *pdata;
-	struct s2255_channel *ch;
+	struct s2255_vc *ch;
 	dprintk(dev, 100, "buffer to user\n");
-	ch = &dev->channel[dev->cc];
+	ch = &dev->vc[dev->cc];
 	idx = ch->cur_frame;
 	frm = &ch->buffer.frame[idx];
 	if (frm->ulState == S2255_READ_IDLE) {
@@ -1981,7 +1982,7 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 				}
 				/* reverse it */
 				dev->cc = G_chnmap[cc];
-				ch = &dev->channel[dev->cc];
+				ch = &dev->vc[dev->cc];
 				payload =  le32_to_cpu(pdword[3]);
 				if (payload > ch->req_image_size) {
 					ch->bad_payload++;
@@ -2000,7 +2001,7 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 				cc = G_chnmap[le32_to_cpu(pdword[1])];
 				if (cc >= MAX_CHANNELS)
 					break;
-				ch = &dev->channel[cc];
+				ch = &dev->vc[cc];
 				switch (pdword[2]) {
 				case S2255_RESPONSE_SETMODE:
 					/* check if channel valid */
@@ -2039,7 +2040,7 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 		if (!bframe)
 			return -EINVAL;
 	}
-	ch = &dev->channel[dev->cc];
+	ch = &dev->vc[dev->cc];
 	idx = ch->cur_frame;
 	frm = &ch->buffer.frame[idx];
 	/* search done.  now find out if should be acquiring on this channel */
@@ -2162,11 +2163,11 @@ static int s2255_get_fx2fw(struct s2255_dev *dev)
  * Create the system ring buffer to copy frames into from the
  * usb read pipe.
  */
-static int s2255_create_sys_buffers(struct s2255_channel *channel)
+static int s2255_create_sys_buffers(struct s2255_vc *vc)
 {
 	unsigned long i;
 	unsigned long reqsize;
-	channel->buffer.dwFrames = SYS_FRAMES;
+	vc->buffer.dwFrames = SYS_FRAMES;
 	/* always allocate maximum size(PAL) for system buffers */
 	reqsize = SYS_FRAMES_MAXSIZE;
 
@@ -2175,33 +2176,33 @@ static int s2255_create_sys_buffers(struct s2255_channel *channel)
 
 	for (i = 0; i < SYS_FRAMES; i++) {
 		/* allocate the frames */
-		channel->buffer.frame[i].lpvbits = vmalloc(reqsize);
-		channel->buffer.frame[i].size = reqsize;
-		if (channel->buffer.frame[i].lpvbits == NULL) {
+		vc->buffer.frame[i].lpvbits = vmalloc(reqsize);
+		vc->buffer.frame[i].size = reqsize;
+		if (vc->buffer.frame[i].lpvbits == NULL) {
 			pr_info("out of memory.  using less frames\n");
-			channel->buffer.dwFrames = i;
+			vc->buffer.dwFrames = i;
 			break;
 		}
 	}
 
 	/* make sure internal states are set */
 	for (i = 0; i < SYS_FRAMES; i++) {
-		channel->buffer.frame[i].ulState = 0;
-		channel->buffer.frame[i].cur_size = 0;
+		vc->buffer.frame[i].ulState = 0;
+		vc->buffer.frame[i].cur_size = 0;
 	}
 
-	channel->cur_frame = 0;
-	channel->last_frame = -1;
+	vc->cur_frame = 0;
+	vc->last_frame = -1;
 	return 0;
 }
 
-static int s2255_release_sys_buffers(struct s2255_channel *channel)
+static int s2255_release_sys_buffers(struct s2255_vc *vc)
 {
 	unsigned long i;
 	for (i = 0; i < SYS_FRAMES; i++) {
-		if (channel->buffer.frame[i].lpvbits)
-			vfree(channel->buffer.frame[i].lpvbits);
-		channel->buffer.frame[i].lpvbits = NULL;
+		if (vc->buffer.frame[i].lpvbits)
+			vfree(vc->buffer.frame[i].lpvbits);
+		vc->buffer.frame[i].lpvbits = NULL;
 	}
 	return 0;
 }
@@ -2235,21 +2236,21 @@ static int s2255_board_init(struct s2255_dev *dev)
 		pr_info("s2255: newer USB firmware available\n");
 
 	for (j = 0; j < MAX_CHANNELS; j++) {
-		struct s2255_channel *channel = &dev->channel[j];
-		channel->b_acquire = 0;
-		channel->mode = mode_def;
+		struct s2255_vc *vc = &dev->vc[j];
+		vc->b_acquire = 0;
+		vc->mode = mode_def;
 		if (dev->pid == 0x2257 && j > 1)
-			channel->mode.color |= (1 << 16);
-		channel->jpegqual = S2255_DEF_JPEG_QUAL;
-		channel->width = LINE_SZ_4CIFS_NTSC;
-		channel->height = NUM_LINES_4CIFS_NTSC * 2;
-		channel->std = V4L2_STD_NTSC_M;
-		channel->fmt = &formats[0];
-		channel->mode.restart = 1;
-		channel->req_image_size = get_transfer_size(&mode_def);
-		channel->frame_count = 0;
+			vc->mode.color |= (1 << 16);
+		vc->jpegqual = S2255_DEF_JPEG_QUAL;
+		vc->width = LINE_SZ_4CIFS_NTSC;
+		vc->height = NUM_LINES_4CIFS_NTSC * 2;
+		vc->std = V4L2_STD_NTSC_M;
+		vc->fmt = &formats[0];
+		vc->mode.restart = 1;
+		vc->req_image_size = get_transfer_size(&mode_def);
+		vc->frame_count = 0;
 		/* create the system buffers */
-		s2255_create_sys_buffers(channel);
+		s2255_create_sys_buffers(vc);
 	}
 	/* start read pipe */
 	s2255_start_readpipe(dev);
@@ -2263,12 +2264,12 @@ static int s2255_board_shutdown(struct s2255_dev *dev)
 	dprintk(dev, 1, "%s: dev: %p", __func__,  dev);
 
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		if (dev->channel[i].b_acquire)
-			s2255_stop_acquire(&dev->channel[i]);
+		if (dev->vc[i].b_acquire)
+			s2255_stop_acquire(&dev->vc[i]);
 	}
 	s2255_stop_readpipe(dev);
 	for (i = 0; i < MAX_CHANNELS; i++)
-		s2255_release_sys_buffers(&dev->channel[i]);
+		s2255_release_sys_buffers(&dev->vc[i]);
 	/* release transfer buffer */
 	kfree(dev->pipe.transfer_buffer);
 	return 0;
@@ -2357,26 +2358,26 @@ static int s2255_start_readpipe(struct s2255_dev *dev)
 }
 
 /* starts acquisition process */
-static int s2255_start_acquire(struct s2255_channel *channel)
+static int s2255_start_acquire(struct s2255_vc *vc)
 {
 	unsigned char *buffer;
 	int res;
 	unsigned long chn_rev;
 	int j;
-	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
-	chn_rev = G_chnmap[channel->idx];
+	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
+	chn_rev = G_chnmap[vc->idx];
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
 		return -ENOMEM;
 	}
 
-	channel->last_frame = -1;
-	channel->bad_payload = 0;
-	channel->cur_frame = 0;
+	vc->last_frame = -1;
+	vc->bad_payload = 0;
+	vc->cur_frame = 0;
 	for (j = 0; j < SYS_FRAMES; j++) {
-		channel->buffer.frame[j].ulState = 0;
-		channel->buffer.frame[j].cur_size = 0;
+		vc->buffer.frame[j].ulState = 0;
+		vc->buffer.frame[j].cur_size = 0;
 	}
 
 	/* send the start command */
@@ -2387,18 +2388,18 @@ static int s2255_start_acquire(struct s2255_channel *channel)
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_START error\n");
 
-	dprintk(dev, 2, "start acquire exit[%d] %d\n", channel->idx, res);
+	dprintk(dev, 2, "start acquire exit[%d] %d\n", vc->idx, res);
 	kfree(buffer);
 	return 0;
 }
 
-static int s2255_stop_acquire(struct s2255_channel *channel)
+static int s2255_stop_acquire(struct s2255_vc *vc)
 {
 	unsigned char *buffer;
 	int res;
 	unsigned long chn_rev;
-	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
-	chn_rev = G_chnmap[channel->idx];
+	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
+	chn_rev = G_chnmap[vc->idx];
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -2412,8 +2413,8 @@ static int s2255_stop_acquire(struct s2255_channel *channel)
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_STOP error\n");
 	kfree(buffer);
-	channel->b_acquire = 0;
-	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, channel->idx, res);
+	vc->b_acquire = 0;
+	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, vc->idx, res);
 	return res;
 }
 
@@ -2503,11 +2504,11 @@ static int s2255_probe(struct usb_interface *interface,
 	dev->timer.data = (unsigned long)dev->fw_data;
 	init_waitqueue_head(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		struct s2255_channel *channel = &dev->channel[i];
-		channel->idx = i;
-		channel->dev = dev;
-		init_waitqueue_head(&channel->wait_setmode);
-		init_waitqueue_head(&channel->wait_vidstatus);
+		struct s2255_vc *vc = &dev->vc[i];
+		vc->idx = i;
+		vc->dev = dev;
+		init_waitqueue_head(&vc->wait_setmode);
+		init_waitqueue_head(&vc->wait_vidstatus);
 	}
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2595,15 +2596,15 @@ static void s2255_disconnect(struct usb_interface *interface)
 	atomic_inc(&dev->num_channels);
 	/* unregister each video device. */
 	for (i = 0; i < channels; i++)
-		video_unregister_device(&dev->channel[i].vdev);
+		video_unregister_device(&dev->vc[i].vdev);
 	/* wake up any of our timers */
 	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
 	wake_up(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		dev->channel[i].setmode_ready = 1;
-		wake_up(&dev->channel[i].wait_setmode);
-		dev->channel[i].vidstatus_ready = 1;
-		wake_up(&dev->channel[i].wait_vidstatus);
+		dev->vc[i].setmode_ready = 1;
+		wake_up(&dev->vc[i].wait_setmode);
+		dev->vc[i].vidstatus_ready = 1;
+		wake_up(&dev->vc[i].wait_vidstatus);
 	}
 	if (atomic_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
-- 
1.7.9.5

