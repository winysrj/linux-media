Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1883 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3DNP2B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:28:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 19/30] cx25821: move vidq from cx25821_fh to cx25821_channel.
Date: Sun, 14 Apr 2013 17:27:15 +0200
Message-Id: <1365953246-8972-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is not a per-filehandle object, it's a per-channel object.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |  235 ++++++++++++++---------------
 drivers/media/pci/cx25821/cx25821.h       |    8 +-
 2 files changed, 115 insertions(+), 128 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 2aba24f..d88316c5 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -288,7 +288,7 @@ static void cx25821_vid_timeout(unsigned long data)
 	struct cx25821_data *timeout_data = (struct cx25821_data *)data;
 	struct cx25821_dev *dev = timeout_data->dev;
 	const struct sram_channel *channel = timeout_data->channel;
-	struct cx25821_dmaqueue *q = &dev->channels[channel->i].vidq;
+	struct cx25821_dmaqueue *q = &dev->channels[channel->i].dma_vidq;
 	struct cx25821_buffer *buf;
 	unsigned long flags;
 
@@ -334,7 +334,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	if (status & FLD_VID_DST_RISC1) {
 		spin_lock(&dev->slock);
 		count = cx_read(channel->gpcnt);
-		cx25821_video_wakeup(dev, &dev->channels[channel->i].vidq,
+		cx25821_video_wakeup(dev, &dev->channels[channel->i].dma_vidq,
 				count);
 		spin_unlock(&dev->slock);
 		handled++;
@@ -345,7 +345,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 		dprintk(2, "stopper video\n");
 		spin_lock(&dev->slock);
 		cx25821_restart_video_queue(dev,
-				&dev->channels[channel->i].vidq, channel);
+				&dev->channels[channel->i].dma_vidq, channel);
 		spin_unlock(&dev->slock);
 		handled++;
 	}
@@ -355,9 +355,9 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 static int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		 unsigned int *size)
 {
-	struct cx25821_fh *fh = q->priv_data;
+	struct cx25821_channel *chan = q->priv_data;
 
-	*size = fh->fmt->depth * fh->width * fh->height >> 3;
+	*size = chan->fmt->depth * chan->width * chan->height >> 3;
 
 	if (0 == *count)
 		*count = 32;
@@ -371,32 +371,32 @@ static int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		   enum v4l2_field field)
 {
-	struct cx25821_fh *fh = q->priv_data;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_channel *chan = q->priv_data;
+	struct cx25821_dev *dev = chan->dev;
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
 	int rc, init_buffer = 0;
 	u32 line0_offset;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int bpl_local = LINE_SIZE_D1;
-	int channel_opened = fh->channel_id;
+	int channel_opened = chan->id;
 
-	BUG_ON(NULL == fh->fmt);
-	if (fh->width < 48 || fh->width > 720 ||
-	    fh->height < 32 || fh->height > 576)
+	BUG_ON(NULL == chan->fmt);
+	if (chan->width < 48 || chan->width > 720 ||
+	    chan->height < 32 || chan->height > 576)
 		return -EINVAL;
 
-	buf->vb.size = (fh->width * fh->height * fh->fmt->depth) >> 3;
+	buf->vb.size = (chan->width * chan->height * chan->fmt->depth) >> 3;
 
 	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size)
 		return -EINVAL;
 
-	if (buf->fmt != fh->fmt ||
-	    buf->vb.width != fh->width ||
-	    buf->vb.height != fh->height || buf->vb.field != field) {
-		buf->fmt = fh->fmt;
-		buf->vb.width = fh->width;
-		buf->vb.height = fh->height;
+	if (buf->fmt != chan->fmt ||
+	    buf->vb.width != chan->width ||
+	    buf->vb.height != chan->height || buf->vb.field != field) {
+		buf->fmt = chan->fmt;
+		buf->vb.width = chan->width;
+		buf->vb.height = chan->height;
 		buf->vb.field = field;
 		init_buffer = 1;
 	}
@@ -413,7 +413,6 @@ static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buff
 	dprintk(1, "init_buffer=%d\n", init_buffer);
 
 	if (init_buffer) {
-
 		channel_opened = dev->channel_opened;
 		if (channel_opened < 0 || channel_opened > 7)
 			channel_opened = 7;
@@ -483,8 +482,8 @@ static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buff
 	}
 
 	dprintk(2, "[%p/%d] buffer_prep - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
-		buf, buf->vb.i, fh->width, fh->height, fh->fmt->depth,
-		fh->fmt->name, (unsigned long)buf->risc.dma);
+		buf, buf->vb.i, chan->width, chan->height, chan->fmt->depth,
+		chan->fmt->name, (unsigned long)buf->risc.dma);
 
 	buf->vb.state = VIDEOBUF_PREPARED;
 
@@ -504,11 +503,6 @@ static void cx25821_buffer_release(struct videobuf_queue *q,
 	cx25821_free_buffer(q, buf);
 }
 
-static struct videobuf_queue *get_queue(struct cx25821_fh *fh)
-{
-	return &fh->vidq;
-}
-
 static int cx25821_get_resource(struct cx25821_fh *fh, int resource)
 {
 	return resource;
@@ -516,9 +510,9 @@ static int cx25821_get_resource(struct cx25821_fh *fh, int resource)
 
 static int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_channel *chan = video_drvdata(file);
 
-	return videobuf_mmap_mapper(get_queue(fh), vma);
+	return videobuf_mmap_mapper(&chan->vidq, vma);
 }
 
 
@@ -527,9 +521,9 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
 	struct cx25821_buffer *prev;
-	struct cx25821_fh *fh = vq->priv_data;
-	struct cx25821_dev *dev = fh->dev;
-	struct cx25821_dmaqueue *q = &dev->channels[fh->channel_id].vidq;
+	struct cx25821_channel *chan = vq->priv_data;
+	struct cx25821_dev *dev = chan->dev;
+	struct cx25821_dmaqueue *q = &dev->channels[chan->id].dma_vidq;
 
 	/* add jump to stopper */
 	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
@@ -546,8 +540,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	} else if (list_empty(&q->active)) {
 		list_add_tail(&buf->vb.queue, &q->active);
-		cx25821_start_video_dma(dev, q, buf,
-				dev->channels[fh->channel_id].sram_channels);
+		cx25821_start_video_dma(dev, q, buf, chan->sram_channels);
 		buf->vb.state = VIDEOBUF_ACTIVE;
 		buf->count = q->count++;
 		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
@@ -590,19 +583,9 @@ static struct videobuf_queue_ops cx25821_video_qops = {
 
 static int video_open(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct cx25821_dev *dev = video_drvdata(file);
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	struct cx25821_fh *fh;
-	u32 pix_format;
-	int ch_id;
-
-	for (ch_id = 0; ch_id < MAX_VID_CHANNEL_NUM - 1; ch_id++)
-		if (&dev->channels[ch_id].vdev == vdev)
-			break;
-
-	/* Can't happen */
-	if (ch_id >= MAX_VID_CHANNEL_NUM - 1)
-		return -ENODEV;
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
@@ -611,27 +594,11 @@ static int video_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev = dev;
-	fh->width = 720;
-	fh->channel_id = ch_id;
-
-	if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-		fh->height = 576;
-	else
-		fh->height = 480;
+	fh->channel_id = chan->id;
 
 	dev->channel_opened = fh->channel_id;
-	if (dev->channels[ch_id].pixel_formats == PIXEL_FRMT_411)
-		pix_format = V4L2_PIX_FMT_Y41P;
-	else
-		pix_format = V4L2_PIX_FMT_YUYV;
-	fh->fmt = cx25821_format_by_fourcc(pix_format);
-
-	v4l2_prio_open(&dev->channels[ch_id].prio, &fh->prio);
 
-	videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops, &dev->pci->dev,
-			&dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			V4L2_FIELD_INTERLACED, sizeof(struct cx25821_buffer),
-			fh, &dev->lock);
+	v4l2_prio_open(&chan->prio, &fh->prio);
 
 	dprintk(1, "post videobuf_queue_init()\n");
 
@@ -642,6 +609,7 @@ static ssize_t video_read(struct file *file, char __user * data, size_t count,
 			 loff_t *ppos)
 {
 	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_dev *dev = fh->dev;
 	int err;
 
@@ -650,7 +618,7 @@ static ssize_t video_read(struct file *file, char __user * data, size_t count,
 	if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
 		err = -EBUSY;
 	else
-		err = videobuf_read_one(&fh->vidq, data, count, ppos,
+		err = videobuf_read_one(&chan->vidq, data, count, ppos,
 				file->f_flags & O_NONBLOCK);
 	mutex_unlock(&dev->lock);
 	return err;
@@ -660,17 +628,18 @@ static unsigned int video_poll(struct file *file,
 			      struct poll_table_struct *wait)
 {
 	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_buffer *buf;
 
 	if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
 		/* streaming capture */
-		if (list_empty(&fh->vidq.stream))
+		if (list_empty(&chan->vidq.stream))
 			return POLLERR;
-		buf = list_entry(fh->vidq.stream.next,
+		buf = list_entry(chan->vidq.stream.next,
 				struct cx25821_buffer, vb.stream);
 	} else {
 		/* read() capture */
-		buf = (struct cx25821_buffer *)fh->vidq.read_buf;
+		buf = (struct cx25821_buffer *)chan->vidq.read_buf;
 		if (NULL == buf)
 			return POLLERR;
 	}
@@ -680,12 +649,11 @@ static unsigned int video_poll(struct file *file,
 		if (buf->vb.state == VIDEOBUF_DONE) {
 			struct cx25821_dev *dev = fh->dev;
 
-			if (dev && dev->channels[fh->channel_id]
-					.use_cif_resolution) {
+			if (dev && chan->use_cif_resolution) {
 				u8 cam_id = *((char *)buf->vb.baddr + 3);
 				memcpy((char *)buf->vb.baddr,
-				      (char *)buf->vb.baddr + (fh->width * 2),
-				      (fh->width * 2));
+				      (char *)buf->vb.baddr + (chan->width * 2),
+				      (chan->width * 2));
 				*((char *)buf->vb.baddr + 3) = cam_id;
 			}
 		}
@@ -698,8 +666,9 @@ static unsigned int video_poll(struct file *file,
 
 static int video_release(struct file *file)
 {
+	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_fh *fh = file->private_data;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_dev *dev = chan->dev;
 	const struct sram_channel *sram_ch =
 		dev->channels[0].sram_channels;
 
@@ -709,19 +678,19 @@ static int video_release(struct file *file)
 
 	/* stop video capture */
 	if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
-		videobuf_queue_cancel(&fh->vidq);
+		videobuf_queue_cancel(&chan->vidq);
 		cx25821_res_free(dev, fh, RESOURCE_VIDEO0);
 	}
 	mutex_unlock(&dev->lock);
 
-	if (fh->vidq.read_buf) {
-		cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-		kfree(fh->vidq.read_buf);
+	if (chan->vidq.read_buf) {
+		cx25821_buffer_release(&chan->vidq, chan->vidq.read_buf);
+		kfree(chan->vidq.read_buf);
 	}
 
-	videobuf_mmap_free(&fh->vidq);
+	videobuf_mmap_free(&chan->vidq);
 
-	v4l2_prio_close(&dev->channels[fh->channel_id].prio, fh->prio);
+	v4l2_prio_close(&chan->prio, fh->prio);
 	file->private_data = NULL;
 	kfree(fh);
 
@@ -732,13 +701,13 @@ static int video_release(struct file *file)
 static int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 				 struct v4l2_format *f)
 {
-	struct cx25821_fh *fh = priv;
+	struct cx25821_channel *chan = video_drvdata(file);
 
-	f->fmt.pix.width = fh->width;
-	f->fmt.pix.height = fh->height;
-	f->fmt.pix.field = fh->vidq.field;
-	f->fmt.pix.pixelformat = fh->fmt->fourcc;
-	f->fmt.pix.bytesperline = (f->fmt.pix.width * fh->fmt->depth) >> 3;
+	f->fmt.pix.width = chan->width;
+	f->fmt.pix.height = chan->height;
+	f->fmt.pix.field = chan->vidq.field;
+	f->fmt.pix.pixelformat = chan->fmt->fourcc;
+	f->fmt.pix.bytesperline = (f->fmt.pix.width * chan->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 
 	return 0;
@@ -794,6 +763,7 @@ static int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 }
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
+	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev = fh->dev;
 
@@ -804,11 +774,12 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 			cx25821_get_resource(fh, RESOURCE_VIDEO0)))
 		return -EBUSY;
 
-	return videobuf_streamon(get_queue(fh));
+	return videobuf_streamon(&chan->vidq);
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
+	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev = fh->dev;
 	int err, res;
@@ -817,7 +788,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 		return -EINVAL;
 
 	res = cx25821_get_resource(fh, RESOURCE_VIDEO0);
-	err = videobuf_streamoff(get_queue(fh));
+	err = videobuf_streamoff(&chan->vidq);
 	if (err < 0)
 		return err;
 	cx25821_res_free(dev, fh, res);
@@ -865,6 +836,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct cx25821_fh *fh = priv;
+	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	struct v4l2_mbus_framefmt mbus_fmt;
 	int err;
@@ -882,15 +854,15 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (0 != err)
 		return err;
 
-	fh->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
-	fh->vidq.field = f->fmt.pix.field;
+	chan->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
+	chan->vidq.field = f->fmt.pix.field;
 
 	/* check if width and height is valid based on set standard */
 	if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm))
-		fh->width = f->fmt.pix.width;
+		chan->width = f->fmt.pix.width;
 
 	if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm))
-		fh->height = f->fmt.pix.height;
+		chan->height = f->fmt.pix.height;
 
 	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
 		pix_format = PIXEL_FRMT_411;
@@ -902,13 +874,13 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	cx25821_set_pixel_format(dev, SRAM_CH00, pix_format);
 
 	/* check if cif resolution */
-	if (fh->width == 320 || fh->width == 352)
-		dev->channels[fh->channel_id].use_cif_resolution = 1;
+	if (chan->width == 320 || chan->width == 352)
+		chan->use_cif_resolution = 1;
 	else
-		dev->channels[fh->channel_id].use_cif_resolution = 0;
+		chan->use_cif_resolution = 0;
 
-	dev->channels[fh->channel_id].cif_width = fh->width;
-	medusa_set_resolution(dev, fh->width, SRAM_CH00);
+	chan->cif_width = chan->width;
+	medusa_set_resolution(dev, chan->width, SRAM_CH00);
 
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
 	cx25821_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
@@ -919,12 +891,10 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	int ret_val = 0;
-	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	struct cx25821_channel *chan = video_drvdata(file);
 
-	ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-	p->sequence = dev->channels[fh->channel_id].vidq.count;
+	ret_val = videobuf_dqbuf(&chan->vidq, p, file->f_flags & O_NONBLOCK);
+	p->sequence = chan->dma_vidq.count;
 
 	return ret_val;
 }
@@ -980,21 +950,24 @@ static int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 static int cx25821_vidioc_reqbufs(struct file *file, void *priv,
 			   struct v4l2_requestbuffers *p)
 {
-	struct cx25821_fh *fh = priv;
-	return videobuf_reqbufs(get_queue(fh), p);
+	struct cx25821_channel *chan = video_drvdata(file);
+
+	return videobuf_reqbufs(&chan->vidq, p);
 }
 
 static int cx25821_vidioc_querybuf(struct file *file, void *priv,
 			    struct v4l2_buffer *p)
 {
-	struct cx25821_fh *fh = priv;
-	return videobuf_querybuf(get_queue(fh), p);
+	struct cx25821_channel *chan = video_drvdata(file);
+
+	return videobuf_querybuf(&chan->vidq, p);
 }
 
 static int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct cx25821_fh *fh = priv;
-	return videobuf_qbuf(get_queue(fh), p);
+	struct cx25821_channel *chan = video_drvdata(file);
+
+	return videobuf_qbuf(&chan->vidq, p);
 }
 
 static int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
@@ -1466,7 +1439,7 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 		v4l2_ctrl_handler_free(&dev->channels[chan_num].hdl);
 
 		btcx_riscmem_free(dev->pci,
-				&dev->channels[chan_num].vidq.stopper);
+				&dev->channels[chan_num].dma_vidq.stopper);
 	}
 }
 
@@ -1482,8 +1455,9 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	spin_lock_init(&dev->slock);
 
 	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
-		struct video_device *vdev = &dev->channels[i].vdev;
-		struct v4l2_ctrl_handler *hdl = &dev->channels[i].hdl;
+		struct cx25821_channel *chan = &dev->channels[i];
+		struct video_device *vdev = &chan->vdev;
+		struct v4l2_ctrl_handler *hdl = &chan->hdl;
 
 		if (i == SRAM_CH08) /* audio channel */
 			continue;
@@ -1505,24 +1479,37 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		if (err)
 			goto fail_unreg;
 
-		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
-			dev->channels[i].sram_channels->dma_ctl, 0x11, 0);
+		cx25821_risc_stopper(dev->pci, &chan->dma_vidq.stopper,
+			chan->sram_channels->dma_ctl, 0x11, 0);
 
-		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
-		dev->channels[i].resources = 0;
+		chan->sram_channels = &cx25821_sram_channels[i];
+		chan->resources = 0;
+		chan->width = 720;
+		if (dev->tvnorm & V4L2_STD_625_50)
+			chan->height = 576;
+		else
+			chan->height = 480;
 
-		cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
+		if (chan->pixel_formats == PIXEL_FRMT_411)
+			chan->fmt = cx25821_format_by_fourcc(V4L2_PIX_FMT_Y41P);
+		else
+			chan->fmt = cx25821_format_by_fourcc(V4L2_PIX_FMT_YUYV);
 
-		INIT_LIST_HEAD(&dev->channels[i].vidq.active);
-		INIT_LIST_HEAD(&dev->channels[i].vidq.queued);
+		cx_write(chan->sram_channels->int_stat, 0xffffffff);
 
-		dev->channels[i].timeout_data.dev = dev;
-		dev->channels[i].timeout_data.channel =
-			&cx25821_sram_channels[i];
-		dev->channels[i].vidq.timeout.function = cx25821_vid_timeout;
-		dev->channels[i].vidq.timeout.data =
-			(unsigned long)&dev->channels[i].timeout_data;
-		init_timer(&dev->channels[i].vidq.timeout);
+		INIT_LIST_HEAD(&chan->dma_vidq.active);
+		INIT_LIST_HEAD(&chan->dma_vidq.queued);
+
+		chan->timeout_data.dev = dev;
+		chan->timeout_data.channel = &cx25821_sram_channels[i];
+		chan->dma_vidq.timeout.function = cx25821_vid_timeout;
+		chan->dma_vidq.timeout.data = (unsigned long)&chan->timeout_data;
+		init_timer(&chan->dma_vidq.timeout);
+
+		videobuf_queue_sg_init(&chan->vidq, &cx25821_video_qops, &dev->pci->dev,
+			&dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			V4L2_FIELD_INTERLACED, sizeof(struct cx25821_buffer),
+			chan, &dev->lock);
 
 		/* register v4l devices */
 		*vdev = cx25821_video_device;
@@ -1530,7 +1517,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		vdev->ctrl_handler = hdl;
 		vdev->lock = &dev->lock;
 		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
-		video_set_drvdata(vdev, dev);
+		video_set_drvdata(vdev, chan);
 
 		err = video_register_device(vdev, VFL_TYPE_GRABBER,
 					    video_nr[dev->nr]);
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index d1c91c9..06dadb5 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -123,10 +123,7 @@ struct cx25821_fh {
 	enum v4l2_priority prio;
 
 	/* video capture */
-	const struct cx25821_fmt *fmt;
-	unsigned int width, height;
 	int channel_id;
-	struct videobuf_queue vidq;
 };
 
 enum cx25821_itype {
@@ -217,12 +214,15 @@ struct cx25821_channel {
 	struct cx25821_data timeout_data;
 
 	struct video_device vdev;
-	struct cx25821_dmaqueue vidq;
+	struct cx25821_dmaqueue dma_vidq;
+	struct videobuf_queue vidq;
 
 	const struct sram_channel *sram_channels;
 
 	int resources;
 
+	const struct cx25821_fmt *fmt;
+	unsigned int width, height;
 	int pixel_formats;
 	int use_cif_resolution;
 	int cif_width;
-- 
1.7.10.4

