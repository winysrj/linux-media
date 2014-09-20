Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4841 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbaITMmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/16] cx88: convert to vb2
Date: Sat, 20 Sep 2014 14:41:39 +0200
Message-Id: <1411216911-7950-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As usual, this patch is very large due to the fact that half a vb2 conversion
isn't possible. And since this affects blackbird, alsa, core, dvb, vbi and
video the changes are all over.

What made this more difficult was the peculiar way the risc program was setup.
The driver allowed for running out of buffers in which case the DMA would stop
and restart when the next buffer was queued. There was also a complicated
timeout system for when buffers weren't filled. This was replaced by a much
simpler scheme where there is always one buffer around and the DMA will just
cycle that buffer until a new buffer is queued. In that case the previous
buffer will be chained to the new buffer. An interrupt is generated at the
start of the new buffer telling the driver that the previous buffer can be
passed on to userspace.

Much simpler and more robust.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/Kconfig          |   4 +-
 drivers/media/pci/cx88/cx88-blackbird.c | 438 +++++++++-----------
 drivers/media/pci/cx88/cx88-core.c      |  83 +---
 drivers/media/pci/cx88/cx88-dvb.c       | 155 ++++---
 drivers/media/pci/cx88/cx88-mpeg.c      | 117 ++----
 drivers/media/pci/cx88/cx88-vbi.c       | 193 ++++-----
 drivers/media/pci/cx88/cx88-video.c     | 697 +++++++++-----------------------
 drivers/media/pci/cx88/cx88.h           |  64 ++-
 8 files changed, 651 insertions(+), 1100 deletions(-)

diff --git a/drivers/media/pci/cx88/Kconfig b/drivers/media/pci/cx88/Kconfig
index a63a9ad..d5b125e 100644
--- a/drivers/media/pci/cx88/Kconfig
+++ b/drivers/media/pci/cx88/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_CX88
 	depends on VIDEO_DEV && PCI && I2C && RC_CORE
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
-	select VIDEOBUF_DMA_SG
+	select VIDEOBUF2_DMA_SG
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_WM8775 if MEDIA_SUBDRV_AUTOSELECT
@@ -45,7 +45,7 @@ config VIDEO_CX88_BLACKBIRD
 config VIDEO_CX88_DVB
 	tristate "DVB/ATSC Support for cx2388x based TV cards"
 	depends on VIDEO_CX88 && DVB_CORE
-	select VIDEOBUF_DVB
+	select VIDEOBUF2_DVB
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 150bb76..25d06f3 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -45,10 +45,6 @@ MODULE_AUTHOR("Jelle Foks <jelle@foks.us>, Gerd Knorr <kraxel@bytesex.org> [SuSE
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CX88_VERSION);
 
-static unsigned int mpegbufs = 32;
-module_param(mpegbufs,int,0644);
-MODULE_PARM_DESC(mpegbufs,"number of mpeg buffers, range 2-32");
-
 static unsigned int debug;
 module_param(debug,int,0644);
 MODULE_PARM_DESC(debug,"enable debug messages [blackbird]");
@@ -589,9 +585,8 @@ static int blackbird_initialize_codec(struct cx8802_dev *dev)
 	return 0;
 }
 
-static int blackbird_start_codec(struct file *file, void *priv)
+static int blackbird_start_codec(struct cx8802_dev *dev)
 {
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
 	struct cx88_core *core = dev->core;
 	/* start capturing to the host interface */
 	u32 reg;
@@ -647,45 +642,131 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 
 /* ------------------------------------------------------------------ */
 
-static int bb_buf_setup(struct videobuf_queue *q,
-			unsigned int *count, unsigned int *size)
+static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct cx8802_fh *fh = q->priv_data;
-
-	fh->dev->ts_packet_size  = 188 * 4; /* was: 512 */
-	fh->dev->ts_packet_count = mpegbufs; /* was: 100 */
+	struct cx8802_dev *dev = q->drv_priv;
 
-	*size = fh->dev->ts_packet_size * fh->dev->ts_packet_count;
-	*count = fh->dev->ts_packet_count;
+	*num_planes = 1;
+	dev->ts_packet_size  = 188 * 4;
+	dev->ts_packet_count  = 32;
+	sizes[0] = dev->ts_packet_size * dev->ts_packet_count;
 	return 0;
 }
 
-static int
-bb_buf_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-	       enum v4l2_field field)
+static int buffer_prepare(struct vb2_buffer *vb)
 {
-	struct cx8802_fh *fh = q->priv_data;
-	return cx8802_buf_prepare(q, fh->dev, (struct cx88_buffer*)vb, field);
+	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+
+	return cx8802_buf_prepare(vb->vb2_queue, dev, buf, dev->field);
 }
 
-static void
-bb_buf_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static void buffer_finish(struct vb2_buffer *vb)
 {
-	struct cx8802_fh *fh = q->priv_data;
-	cx8802_buf_queue(fh->dev, (struct cx88_buffer*)vb);
+	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+
+	cx88_free_buffer(vb->vb2_queue, buf);
+
+	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
-static void
-bb_buf_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static void buffer_queue(struct vb2_buffer *vb)
 {
-	cx88_free_buffer(q, (struct cx88_buffer*)vb);
+	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
+
+	cx8802_buf_queue(dev, buf);
 }
 
-static struct videobuf_queue_ops blackbird_qops = {
-	.buf_setup    = bb_buf_setup,
-	.buf_prepare  = bb_buf_prepare,
-	.buf_queue    = bb_buf_queue,
-	.buf_release  = bb_buf_release,
+static int start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct cx8802_dev *dev = q->drv_priv;
+	struct cx88_dmaqueue *dmaq = &dev->mpegq;
+	struct cx8802_driver *drv;
+	struct cx88_buffer *buf;
+	unsigned long flags;
+	int err;
+
+	/* Make sure we can acquire the hardware */
+	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
+	if (!drv) {
+		dprintk(1, "%s: blackbird driver is not loaded\n", __func__);
+		err = -ENODEV;
+		goto fail;
+	}
+
+	err = drv->request_acquire(drv);
+	if (err != 0) {
+		dprintk(1, "%s: Unable to acquire hardware, %d\n", __func__, err);
+		goto fail;
+	}
+
+	if (blackbird_initialize_codec(dev) < 0) {
+		drv->request_release(drv);
+		err = -EINVAL;
+		goto fail;
+	}
+
+	err = blackbird_start_codec(dev);
+	if (err == 0) {
+		buf = list_entry(dmaq->active.next, struct cx88_buffer, list);
+		cx8802_start_dma(dev, dmaq, buf);
+		return 0;
+	}
+
+fail:
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct cx88_buffer *buf = list_entry(dmaq->active.next,
+			struct cx88_buffer, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
+	return err;
+}
+
+static void stop_streaming(struct vb2_queue *q)
+{
+	struct cx8802_dev *dev = q->drv_priv;
+	struct cx88_dmaqueue *dmaq = &dev->mpegq;
+	struct cx8802_driver *drv = NULL;
+	unsigned long flags;
+
+	cx8802_cancel_buffers(dev);
+	blackbird_stop_codec(dev);
+
+	/* Make sure we release the hardware */
+	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
+	WARN_ON(!drv);
+	if (drv)
+		drv->request_release(drv);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct cx88_buffer *buf = list_entry(dmaq->active.next,
+			struct cx88_buffer, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+static struct vb2_ops blackbird_qops = {
+	.queue_setup    = queue_setup,
+	.buf_prepare  = buffer_prepare,
+	.buf_finish = buffer_finish,
+	.buf_queue    = buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
 };
 
 /* ------------------------------------------------------------------ */
@@ -693,8 +774,8 @@ static struct videobuf_queue_ops blackbird_qops = {
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
-	struct cx88_core  *core = dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	strcpy(cap->driver, "cx88_blackbird");
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
@@ -717,50 +798,47 @@ static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
 static int vidioc_g_fmt_vid_cap (struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct cx8802_fh  *fh   = priv;
-	struct cx8802_dev *dev  = fh->dev;
+	struct cx8802_dev *dev = video_drvdata(file);
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
+	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = fh->mpegq.field;
+	f->fmt.pix.field        = dev->field;
 	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d, f: %d\n",
-		dev->width, dev->height, fh->mpegq.field );
+		dev->width, dev->height, dev->field);
 	return 0;
 }
 
 static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
 			struct v4l2_format *f)
 {
-	struct cx8802_fh  *fh   = priv;
-	struct cx8802_dev *dev  = fh->dev;
+	struct cx8802_dev *dev = video_drvdata(file);
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
+	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
-		dev->width, dev->height, fh->mpegq.field );
+		dev->width, dev->height, dev->field);
 	return 0;
 }
 
 static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct cx8802_fh  *fh   = priv;
-	struct cx8802_dev *dev  = fh->dev;
+	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core  *core = dev->core;
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
+	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	dev->width              = f->fmt.pix.width;
 	dev->height             = f->fmt.pix.height;
-	fh->mpegq.field         = f->fmt.pix.field;
+	dev->field         = f->fmt.pix.field;
 	cx88_set_scale(core, f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
 				f->fmt.pix.height, f->fmt.pix.width);
@@ -769,57 +847,11 @@ static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_reqbufs (struct file *file, void *priv, struct v4l2_requestbuffers *p)
-{
-	struct cx8802_fh  *fh   = priv;
-	return (videobuf_reqbufs(&fh->mpegq, p));
-}
-
-static int vidioc_querybuf (struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct cx8802_fh  *fh   = priv;
-	return (videobuf_querybuf(&fh->mpegq, p));
-}
-
-static int vidioc_qbuf (struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct cx8802_fh  *fh   = priv;
-	return (videobuf_qbuf(&fh->mpegq, p));
-}
-
-static int vidioc_dqbuf (struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct cx8802_fh  *fh   = priv;
-	return (videobuf_dqbuf(&fh->mpegq, p,
-				file->f_flags & O_NONBLOCK));
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct cx8802_fh  *fh   = priv;
-	struct cx8802_dev *dev  = fh->dev;
-
-	if (!dev->mpeg_active)
-		blackbird_start_codec(file, fh);
-	return videobuf_streamon(&fh->mpegq);
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct cx8802_fh  *fh   = priv;
-	struct cx8802_dev *dev  = fh->dev;
-
-	if (dev->mpeg_active)
-		blackbird_stop_codec(dev);
-	return videobuf_streamoff(&fh->mpegq);
-}
-
 static int vidioc_s_frequency (struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
-	struct cx8802_fh  *fh   = priv;
-	struct cx8802_dev *dev  = fh->dev;
-	struct cx88_core  *core = dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
@@ -831,14 +863,14 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	cx88_set_freq (core,f);
 	blackbird_initialize_codec(dev);
 	cx88_set_scale(dev->core, dev->width, dev->height,
-			fh->mpegq.field);
+			dev->field);
 	return 0;
 }
 
 static int vidioc_log_status (struct file *file, void *priv)
 {
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
-	struct cx88_core  *core = dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 	char name[32 + 2];
 
 	snprintf(name, sizeof(name), "%s/2", core->name);
@@ -850,15 +882,16 @@ static int vidioc_log_status (struct file *file, void *priv)
 static int vidioc_enum_input (struct file *file, void *priv,
 				struct v4l2_input *i)
 {
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 	return cx88_enum_input (core,i);
 }
 
 static int vidioc_g_frequency (struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct cx8802_fh  *fh   = priv;
-	struct cx88_core  *core = fh->dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
@@ -873,7 +906,8 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 
 static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
 {
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	*i = core->input;
 	return 0;
@@ -881,24 +915,24 @@ static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
 
 static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
 {
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (i >= 4)
 		return -EINVAL;
 	if (0 == INPUT(i).type)
 		return -EINVAL;
 
-	mutex_lock(&core->lock);
 	cx88_newstation(core);
 	cx88_video_mux(core,i);
-	mutex_unlock(&core->lock);
 	return 0;
 }
 
 static int vidioc_g_tuner (struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 	u32 reg;
 
 	if (unlikely(UNSET == core->board.tuner_type))
@@ -920,7 +954,8 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 static int vidioc_s_tuner (struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (UNSET == core->board.tuner_type)
 		return -EINVAL;
@@ -933,7 +968,8 @@ static int vidioc_s_tuner (struct file *file, void *priv,
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
 {
-	struct cx88_core *core = ((struct cx8802_fh *)priv)->dev->core;
+	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	*tvnorm = core->tvnorm;
 	return 0;
@@ -941,155 +977,21 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
-
-	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core, id);
-	mutex_unlock(&core->lock);
-	return 0;
-}
-
-/* FIXME: cx88_ioctl_hook not implemented */
-
-static int mpeg_open(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
 	struct cx8802_dev *dev = video_drvdata(file);
-	struct cx8802_fh *fh;
-	struct cx8802_driver *drv = NULL;
-	int err;
-
-	dprintk( 1, "%s\n", __func__);
-
-	mutex_lock(&dev->core->lock);
-
-	/* Make sure we can acquire the hardware */
-	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
-	if (!drv) {
-		dprintk(1, "%s: blackbird driver is not loaded\n", __func__);
-		mutex_unlock(&dev->core->lock);
-		return -ENODEV;
-	}
-
-	err = drv->request_acquire(drv);
-	if (err != 0) {
-		dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
-		mutex_unlock(&dev->core->lock);
-		return err;
-	}
-
-	if (!dev->core->mpeg_users && blackbird_initialize_codec(dev) < 0) {
-		drv->request_release(drv);
-		mutex_unlock(&dev->core->lock);
-		return -EINVAL;
-	}
-	dprintk(1, "open dev=%s\n", video_device_node_name(vdev));
-
-	/* allocate + initialize per filehandle data */
-	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
-	if (NULL == fh) {
-		drv->request_release(drv);
-		mutex_unlock(&dev->core->lock);
-		return -ENOMEM;
-	}
-	v4l2_fh_init(&fh->fh, vdev);
-	file->private_data = fh;
-	fh->dev      = dev;
-
-	videobuf_queue_sg_init(&fh->mpegq, &blackbird_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			    V4L2_FIELD_INTERLACED,
-			    sizeof(struct cx88_buffer),
-			    fh, NULL);
-
-	/* FIXME: locking against other video device */
-	cx88_set_scale(dev->core, dev->width, dev->height,
-			fh->mpegq.field);
-
-	dev->core->mpeg_users++;
-	mutex_unlock(&dev->core->lock);
-	v4l2_fh_add(&fh->fh);
-	return 0;
-}
-
-static int mpeg_release(struct file *file)
-{
-	struct cx8802_fh  *fh  = file->private_data;
-	struct cx8802_dev *dev = fh->dev;
-	struct cx8802_driver *drv = NULL;
-
-	mutex_lock(&dev->core->lock);
-
-	if (dev->mpeg_active && dev->core->mpeg_users == 1)
-		blackbird_stop_codec(dev);
-
-	cx8802_cancel_buffers(fh->dev);
-	/* stop mpeg capture */
-	videobuf_stop(&fh->mpegq);
-
-	videobuf_mmap_free(&fh->mpegq);
-
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
-	file->private_data = NULL;
-	kfree(fh);
-
-	/* Make sure we release the hardware */
-	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
-	WARN_ON(!drv);
-	if (drv)
-		drv->request_release(drv);
-
-	dev->core->mpeg_users--;
-
-	mutex_unlock(&dev->core->lock);
+	struct cx88_core *core = dev->core;
 
+	cx88_set_tvnorm(core, id);
 	return 0;
 }
 
-static ssize_t
-mpeg_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
-{
-	struct cx8802_fh *fh = file->private_data;
-	struct cx8802_dev *dev = fh->dev;
-
-	if (!dev->mpeg_active)
-		blackbird_start_codec(file, fh);
-
-	return videobuf_read_stream(&fh->mpegq, data, count, ppos, 0,
-				    file->f_flags & O_NONBLOCK);
-}
-
-static unsigned int
-mpeg_poll(struct file *file, struct poll_table_struct *wait)
-{
-	unsigned long req_events = poll_requested_events(wait);
-	struct cx8802_fh *fh = file->private_data;
-	struct cx8802_dev *dev = fh->dev;
-
-	if (!dev->mpeg_active && (req_events & (POLLIN | POLLRDNORM)))
-		blackbird_start_codec(file, fh);
-
-	return v4l2_ctrl_poll(file, wait) | videobuf_poll_stream(file, &fh->mpegq, wait);
-}
-
-static int
-mpeg_mmap(struct file *file, struct vm_area_struct * vma)
-{
-	struct cx8802_fh *fh = file->private_data;
-
-	return videobuf_mmap_mapper(&fh->mpegq, vma);
-}
-
 static const struct v4l2_file_operations mpeg_fops =
 {
 	.owner	       = THIS_MODULE,
-	.open	       = mpeg_open,
-	.release       = mpeg_release,
-	.read	       = mpeg_read,
-	.poll          = mpeg_poll,
-	.mmap	       = mpeg_mmap,
+	.open	       = v4l2_fh_open,
+	.release       = vb2_fop_release,
+	.read	       = vb2_fop_read,
+	.poll          = vb2_fop_poll,
+	.mmap	       = vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
 
@@ -1099,12 +1001,12 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
-	.vidioc_reqbufs       = vidioc_reqbufs,
-	.vidioc_querybuf      = vidioc_querybuf,
-	.vidioc_qbuf          = vidioc_qbuf,
-	.vidioc_dqbuf         = vidioc_dqbuf,
-	.vidioc_streamon      = vidioc_streamon,
-	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_log_status    = vidioc_log_status,
 	.vidioc_enum_input    = vidioc_enum_input,
@@ -1189,11 +1091,12 @@ static int blackbird_register_video(struct cx8802_dev *dev)
 {
 	int err;
 
-	dev->mpeg_dev = cx88_vdev_init(dev->core,dev->pci,
-				       &cx8802_mpeg_template,"mpeg");
+	dev->mpeg_dev = cx88_vdev_init(dev->core, dev->pci,
+				       &cx8802_mpeg_template, "mpeg");
 	dev->mpeg_dev->ctrl_handler = &dev->cxhdl.hdl;
 	video_set_drvdata(dev->mpeg_dev, dev);
-	err = video_register_device(dev->mpeg_dev,VFL_TYPE_GRABBER, -1);
+	dev->mpeg_dev->queue = &dev->vb2_mpegq;
+	err = video_register_device(dev->mpeg_dev, VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
 		printk(KERN_INFO "%s/2: can't register mpeg device\n",
 		       dev->core->name);
@@ -1210,6 +1113,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 	struct cx8802_dev *dev = core->dvbdev;
+	struct vb2_queue *q;
 	int err;
 
 	dprintk( 1, "%s\n", __func__);
@@ -1229,6 +1133,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	} else {
 		dev->height = 576;
 	}
+	dev->field = V4L2_FIELD_INTERLACED;
 	dev->cxhdl.port = CX2341X_PORT_STREAMING;
 	dev->cxhdl.width = dev->width;
 	dev->cxhdl.height = dev->height;
@@ -1252,11 +1157,28 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	cx88_video_mux(core,0);
 	cx2341x_handler_set_50hz(&dev->cxhdl, dev->height == 576);
 	cx2341x_handler_setup(&dev->cxhdl);
+
+	q = &dev->vb2_mpegq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	q->gfp_flags = GFP_DMA32;
+	q->min_buffers_needed = 2;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct cx88_buffer);
+	q->ops = &blackbird_qops;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &core->lock;
+
+	err = vb2_queue_init(q);
+	if (err < 0)
+		goto fail_core;
+
 	blackbird_register_video(dev);
 
 	return 0;
 
- fail_core:
+fail_core:
 	return err;
 }
 
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 7163023..f027408 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -76,11 +76,16 @@ static DEFINE_MUTEX(devlist);
 static __le32* cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
 			    unsigned int offset, u32 sync_line,
 			    unsigned int bpl, unsigned int padding,
-			    unsigned int lines, unsigned int lpi)
+			    unsigned int lines, unsigned int lpi, bool jump)
 {
 	struct scatterlist *sg;
 	unsigned int line,todo,sol;
 
+	if (jump) {
+		(*rp++) = cpu_to_le32(RISC_JUMP);
+		(*rp++) = 0;
+	}
+
 	/* sync instruction */
 	if (sync_line != NO_SYNC_LINE)
 		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
@@ -147,7 +152,7 @@ int cx88_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	   can cause next bpl to start close to a page border.  First DMA
 	   region may be smaller than PAGE_SIZE */
 	instructions  = fields * (1 + ((bpl + padding) * lines) / PAGE_SIZE + lines);
-	instructions += 2;
+	instructions += 4;
 	if ((rc = btcx_riscmem_alloc(pci,risc,instructions*8)) < 0)
 		return rc;
 
@@ -155,10 +160,10 @@ int cx88_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	rp = risc->cpu;
 	if (UNSET != top_offset)
 		rp = cx88_risc_field(rp, sglist, top_offset, 0,
-				     bpl, padding, lines, 0);
+				     bpl, padding, lines, 0, true);
 	if (UNSET != bottom_offset)
 		rp = cx88_risc_field(rp, sglist, bottom_offset, 0x200,
-				     bpl, padding, lines, 0);
+				     bpl, padding, lines, 0, top_offset == UNSET);
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
@@ -179,13 +184,13 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	   there is no padding and no sync.  First DMA region may be smaller
 	   than PAGE_SIZE */
 	instructions  = 1 + (bpl * lines) / PAGE_SIZE + lines;
-	instructions += 1;
+	instructions += 3;
 	if ((rc = btcx_riscmem_alloc(pci,risc,instructions*8)) < 0)
 		return rc;
 
 	/* write risc instructions */
 	rp = risc->cpu;
-	rp = cx88_risc_field(rp, sglist, 0, NO_SYNC_LINE, bpl, 0, lines, lpi);
+	rp = cx88_risc_field(rp, sglist, 0, NO_SYNC_LINE, bpl, 0, lines, lpi, !lpi);
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
@@ -193,37 +198,10 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	return 0;
 }
 
-int cx88_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
-		      u32 reg, u32 mask, u32 value)
-{
-	__le32 *rp;
-	int rc;
-
-	if ((rc = btcx_riscmem_alloc(pci, risc, 4*16)) < 0)
-		return rc;
-
-	/* write risc instructions */
-	rp = risc->cpu;
-	*(rp++) = cpu_to_le32(RISC_WRITECR  | RISC_IRQ2 | RISC_IMM);
-	*(rp++) = cpu_to_le32(reg);
-	*(rp++) = cpu_to_le32(value);
-	*(rp++) = cpu_to_le32(mask);
-	*(rp++) = cpu_to_le32(RISC_JUMP);
-	*(rp++) = cpu_to_le32(risc->dma);
-	return 0;
-}
-
 void
-cx88_free_buffer(struct videobuf_queue *q, struct cx88_buffer *buf)
+cx88_free_buffer(struct vb2_queue *q, struct cx88_buffer *buf)
 {
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-
-	BUG_ON(in_interrupt());
-	videobuf_waiton(q, &buf->vb, 0, 0);
-	videobuf_dma_unmap(q->dev, dma);
-	videobuf_dma_free(dma);
-	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+	btcx_riscmem_free(to_pci_dev(q->drv_priv), &buf->risc);
 }
 
 /* ------------------------------------------------------------------ */
@@ -539,33 +517,12 @@ void cx88_wakeup(struct cx88_core *core,
 		 struct cx88_dmaqueue *q, u32 count)
 {
 	struct cx88_buffer *buf;
-	int bc;
-
-	for (bc = 0;; bc++) {
-		if (list_empty(&q->active))
-			break;
-		buf = list_entry(q->active.next,
-				 struct cx88_buffer, vb.queue);
-		/* count comes from the hw and is is 16bit wide --
-		 * this trick handles wrap-arounds correctly for
-		 * up to 32767 buffers in flight... */
-		if ((s16) (count - buf->count) < 0)
-			break;
-		v4l2_get_timestamp(&buf->vb.ts);
-		dprintk(2,"[%p/%d] wakeup reg=%d buf=%d\n",buf,buf->vb.i,
-			count, buf->count);
-		buf->vb.state = VIDEOBUF_DONE;
-		list_del(&buf->vb.queue);
-		wake_up(&buf->vb.done);
-	}
-	if (list_empty(&q->active)) {
-		del_timer(&q->timeout);
-	} else {
-		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
-	}
-	if (bc != 1)
-		dprintk(2, "%s: %d buffers handled (should be 1)\n",
-			__func__, bc);
+
+	buf = list_entry(q->active.next,
+			 struct cx88_buffer, list);
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	list_del(&buf->list);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 }
 
 void cx88_shutdown(struct cx88_core *core)
@@ -1043,6 +1000,7 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
 	vfd->v4l2_dev = &core->v4l2_dev;
 	vfd->dev_parent = &pci->dev;
 	vfd->release = video_device_release;
+	vfd->lock = &core->lock;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 core->name, type, core->board.name);
 	return vfd;
@@ -1114,7 +1072,6 @@ EXPORT_SYMBOL(cx88_shutdown);
 
 EXPORT_SYMBOL(cx88_risc_buffer);
 EXPORT_SYMBOL(cx88_risc_databuffer);
-EXPORT_SYMBOL(cx88_risc_stopper);
 EXPORT_SYMBOL(cx88_free_buffer);
 
 EXPORT_SYMBOL(cx88_sram_channels);
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 053ed1b..d7e5c45 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -82,43 +82,86 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
-static int dvb_buf_setup(struct videobuf_queue *q,
-			 unsigned int *count, unsigned int *size)
+static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct cx8802_dev *dev = q->priv_data;
+	struct cx8802_dev *dev = q->drv_priv;
 
+	*num_planes = 1;
 	dev->ts_packet_size  = 188 * 4;
 	dev->ts_packet_count = dvb_buf_tscnt;
-
-	*size  = dev->ts_packet_size * dev->ts_packet_count;
-	*count = dvb_buf_tscnt;
+	sizes[0] = dev->ts_packet_size * dev->ts_packet_count;
+	*num_buffers = dvb_buf_tscnt;
 	return 0;
 }
 
-static int dvb_buf_prepare(struct videobuf_queue *q,
-			   struct videobuf_buffer *vb, enum v4l2_field field)
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+
+	return cx8802_buf_prepare(vb->vb2_queue, dev, buf, dev->field);
+}
+
+static void buffer_finish(struct vb2_buffer *vb)
+{
+	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+
+	cx88_free_buffer(vb->vb2_queue, buf);
+
+	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct cx8802_dev *dev = q->priv_data;
-	return cx8802_buf_prepare(q, dev, (struct cx88_buffer*)vb,field);
+	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
+
+	cx8802_buf_queue(dev, buf);
 }
 
-static void dvb_buf_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct cx8802_dev *dev = q->priv_data;
-	cx8802_buf_queue(dev, (struct cx88_buffer*)vb);
+	struct cx8802_dev *dev = q->drv_priv;
+	struct cx88_dmaqueue *dmaq = &dev->mpegq;
+	struct cx88_buffer *buf;
+
+	buf = list_entry(dmaq->active.next, struct cx88_buffer, list);
+	cx8802_start_dma(dev, dmaq, buf);
+	return 0;
 }
 
-static void dvb_buf_release(struct videobuf_queue *q,
-			    struct videobuf_buffer *vb)
+static void stop_streaming(struct vb2_queue *q)
 {
-	cx88_free_buffer(q, (struct cx88_buffer*)vb);
+	struct cx8802_dev *dev = q->drv_priv;
+	struct cx88_dmaqueue *dmaq = &dev->mpegq;
+	unsigned long flags;
+
+	cx8802_cancel_buffers(dev);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct cx88_buffer *buf = list_entry(dmaq->active.next,
+			struct cx88_buffer, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static const struct videobuf_queue_ops dvb_qops = {
-	.buf_setup    = dvb_buf_setup,
-	.buf_prepare  = dvb_buf_prepare,
-	.buf_queue    = dvb_buf_queue,
-	.buf_release  = dvb_buf_release,
+static struct vb2_ops dvb_qops = {
+	.queue_setup    = queue_setup,
+	.buf_prepare  = buffer_prepare,
+	.buf_finish = buffer_finish,
+	.buf_queue    = buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
 };
 
 /* ------------------------------------------------------------------ */
@@ -130,7 +173,7 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 	int ret = 0;
 	int fe_id;
 
-	fe_id = videobuf_dvb_find_frontend(&dev->frontends, fe);
+	fe_id = vb2_dvb_find_frontend(&dev->frontends, fe);
 	if (!fe_id) {
 		printk(KERN_ERR "%s() No frontend found\n", __func__);
 		return -EINVAL;
@@ -154,8 +197,8 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 
 static void cx88_dvb_gate_ctrl(struct cx88_core  *core, int open)
 {
-	struct videobuf_dvb_frontends *f;
-	struct videobuf_dvb_frontend *fe;
+	struct vb2_dvb_frontends *f;
+	struct vb2_dvb_frontend *fe;
 
 	if (!core->dvbdev)
 		return;
@@ -166,9 +209,9 @@ static void cx88_dvb_gate_ctrl(struct cx88_core  *core, int open)
 		return;
 
 	if (f->gate <= 1) /* undefined or fe0 */
-		fe = videobuf_dvb_get_frontend(f, 1);
+		fe = vb2_dvb_get_frontend(f, 1);
 	else
-		fe = videobuf_dvb_get_frontend(f, f->gate);
+		fe = vb2_dvb_get_frontend(f, f->gate);
 
 	if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
 		fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
@@ -565,7 +608,7 @@ static const struct xc5000_config dvico_fusionhdtv7_tuner_config = {
 static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 {
 	struct dvb_frontend *fe;
-	struct videobuf_dvb_frontend *fe0 = NULL;
+	struct vb2_dvb_frontend *fe0 = NULL;
 	struct xc2028_ctrl ctl;
 	struct xc2028_config cfg = {
 		.i2c_adap  = &dev->core->i2c_adap,
@@ -574,7 +617,7 @@ static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 	};
 
 	/* Get the first frontend */
-	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	fe0 = vb2_dvb_get_frontend(&dev->frontends, 1);
 	if (!fe0)
 		return -EINVAL;
 
@@ -611,10 +654,10 @@ static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 static int attach_xc4000(struct cx8802_dev *dev, struct xc4000_config *cfg)
 {
 	struct dvb_frontend *fe;
-	struct videobuf_dvb_frontend *fe0 = NULL;
+	struct vb2_dvb_frontend *fe0 = NULL;
 
 	/* Get the first frontend */
-	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	fe0 = vb2_dvb_get_frontend(&dev->frontends, 1);
 	if (!fe0)
 		return -EINVAL;
 
@@ -745,7 +788,7 @@ static const struct stv0288_config tevii_tuner_earda_config = {
 static int cx8802_alloc_frontends(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
-	struct videobuf_dvb_frontend *fe = NULL;
+	struct vb2_dvb_frontend *fe = NULL;
 	int i;
 
 	mutex_init(&dev->frontends.lock);
@@ -757,10 +800,10 @@ static int cx8802_alloc_frontends(struct cx8802_dev *dev)
 	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
 			 core->board.num_frontends);
 	for (i = 1; i <= core->board.num_frontends; i++) {
-		fe = videobuf_dvb_alloc_frontend(&dev->frontends, i);
+		fe = vb2_dvb_alloc_frontend(&dev->frontends, i);
 		if (!fe) {
 			printk(KERN_ERR "%s() failed to alloc\n", __func__);
-			videobuf_dvb_dealloc_frontends(&dev->frontends);
+			vb2_dvb_dealloc_frontends(&dev->frontends);
 			return -ENOMEM;
 		}
 	}
@@ -958,7 +1001,7 @@ static const struct stv0299_config samsung_stv0299_config = {
 static int dvb_register(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
-	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
+	struct vb2_dvb_frontend *fe0, *fe1 = NULL;
 	int mfe_shared = 0; /* bus not shared by default */
 	int res = -EINVAL;
 
@@ -968,7 +1011,7 @@ static int dvb_register(struct cx8802_dev *dev)
 	}
 
 	/* Get the first frontend */
-	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	fe0 = vb2_dvb_get_frontend(&dev->frontends, 1);
 	if (!fe0)
 		goto frontend_detach;
 
@@ -1046,7 +1089,7 @@ static int dvb_register(struct cx8802_dev *dev)
 				goto frontend_detach;
 		}
 		/* MFE frontend 2 */
-		fe1 = videobuf_dvb_get_frontend(&dev->frontends, 2);
+		fe1 = vb2_dvb_get_frontend(&dev->frontends, 2);
 		if (!fe1)
 			goto frontend_detach;
 		/* DVB-T init */
@@ -1415,7 +1458,7 @@ static int dvb_register(struct cx8802_dev *dev)
 				goto frontend_detach;
 		}
 		/* MFE frontend 2 */
-		fe1 = videobuf_dvb_get_frontend(&dev->frontends, 2);
+		fe1 = vb2_dvb_get_frontend(&dev->frontends, 2);
 		if (!fe1)
 			goto frontend_detach;
 		/* DVB-T Init */
@@ -1594,7 +1637,7 @@ static int dvb_register(struct cx8802_dev *dev)
 	call_all(core, core, s_power, 0);
 
 	/* register everything */
-	res = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
+	res = vb2_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
 		&dev->pci->dev, adapter_nr, mfe_shared);
 	if (res)
 		goto frontend_detach;
@@ -1602,7 +1645,7 @@ static int dvb_register(struct cx8802_dev *dev)
 
 frontend_detach:
 	core->gate_ctrl = NULL;
-	videobuf_dvb_dealloc_frontends(&dev->frontends);
+	vb2_dvb_dealloc_frontends(&dev->frontends);
 	return res;
 }
 
@@ -1697,7 +1740,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 	struct cx88_core *core = drv->core;
 	struct cx8802_dev *dev = drv->core->dvbdev;
 	int err;
-	struct videobuf_dvb_frontend *fe;
+	struct vb2_dvb_frontend *fe;
 	int i;
 
 	dprintk( 1, "%s\n", __func__);
@@ -1726,19 +1769,31 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 
 	err = -ENODEV;
 	for (i = 1; i <= core->board.num_frontends; i++) {
-		fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
+		struct vb2_queue *q;
+
+		fe = vb2_dvb_get_frontend(&core->dvbdev->frontends, i);
 		if (fe == NULL) {
 			printk(KERN_ERR "%s() failed to get frontend(%d)\n",
 					__func__, i);
 			goto fail_probe;
 		}
-		videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
-				    &dev->pci->dev, &dev->slock,
-				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				    V4L2_FIELD_TOP,
-				    sizeof(struct cx88_buffer),
-				    dev, NULL);
-		/* init struct videobuf_dvb */
+		q = &fe->dvb.dvbq;
+		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->gfp_flags = GFP_DMA32;
+		q->min_buffers_needed = 2;
+		q->drv_priv = dev;
+		q->buf_struct_size = sizeof(struct cx88_buffer);
+		q->ops = &dvb_qops;
+		q->mem_ops = &vb2_dma_sg_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->lock = &core->lock;
+
+		err = vb2_queue_init(q);
+		if (err < 0)
+			goto fail_probe;
+
+		/* init struct vb2_dvb */
 		fe->dvb.name = dev->core->name;
 	}
 
@@ -1749,7 +1804,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 		       core->name, err);
 	return err;
 fail_probe:
-	videobuf_dvb_dealloc_frontends(&core->dvbdev->frontends);
+	vb2_dvb_dealloc_frontends(&core->dvbdev->frontends);
 fail_core:
 	return err;
 }
@@ -1761,7 +1816,7 @@ static int cx8802_dvb_remove(struct cx8802_driver *drv)
 
 	dprintk( 1, "%s\n", __func__);
 
-	videobuf_dvb_unregister_bus(&dev->frontends);
+	vb2_dvb_unregister_bus(&dev->frontends);
 
 	vp3054_i2c_remove(dev);
 
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 5f59901..7986ee0 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -86,21 +86,21 @@ static LIST_HEAD(cx8802_devlist);
 static DEFINE_MUTEX(cx8802_mutex);
 /* ------------------------------------------------------------------ */
 
-static int cx8802_start_dma(struct cx8802_dev    *dev,
+int cx8802_start_dma(struct cx8802_dev    *dev,
 			    struct cx88_dmaqueue *q,
 			    struct cx88_buffer   *buf)
 {
 	struct cx88_core *core = dev->core;
 
 	dprintk(1, "cx8802_start_dma w: %d, h: %d, f: %d\n",
-		buf->vb.width, buf->vb.height, buf->vb.field);
+		dev->width, dev->height, dev->field);
 
 	/* setup fifo + format */
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH28],
 				dev->ts_packet_size, buf->risc.dma);
 
 	/* write TS length to chip */
-	cx_write(MO_TS_LNGTH, buf->vb.width);
+	cx_write(MO_TS_LNGTH, dev->ts_packet_size);
 
 	/* FIXME: this needs a review.
 	 * also: move to cx88-blackbird + cx88-dvb source files? */
@@ -212,47 +212,35 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 	if (list_empty(&q->active))
 		return 0;
 
-	buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
+	buf = list_entry(q->active.next, struct cx88_buffer, list);
 	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
-		buf, buf->vb.i);
+		buf, buf->vb.v4l2_buf.index);
 	cx8802_start_dma(dev, q, buf);
-	list_for_each_entry(buf, &q->active, vb.queue)
+	list_for_each_entry(buf, &q->active, list)
 		buf->count = q->count++;
-	mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
 	return 0;
 }
 
 /* ------------------------------------------------------------------ */
 
-int cx8802_buf_prepare(struct videobuf_queue *q, struct cx8802_dev *dev,
+int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 			struct cx88_buffer *buf, enum v4l2_field field)
 {
 	int size = dev->ts_packet_size * dev->ts_packet_count;
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
 	int rc;
 
-	dprintk(1, "%s: %p\n", __func__, buf);
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
+	if (vb2_plane_size(&buf->vb, 0) < size)
 		return -EINVAL;
+	vb2_set_plane_payload(&buf->vb, 0, size);
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		buf->vb.width  = dev->ts_packet_size;
-		buf->vb.height = dev->ts_packet_count;
-		buf->vb.size   = size;
-		buf->vb.field  = field /*V4L2_FIELD_TOP*/;
-
-		if (0 != (rc = videobuf_iolock(q,&buf->vb,NULL)))
-			goto fail;
-		cx88_risc_databuffer(dev->pci, &buf->risc,
-				     dma->sglist,
-				     buf->vb.width, buf->vb.height, 0);
-	}
-	buf->vb.state = VIDEOBUF_PREPARED;
-	return 0;
+	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
+	if (!rc)
+		return -EIO;
 
- fail:
-	cx88_free_buffer(q,buf);
-	return rc;
+	cx88_risc_databuffer(dev->pci, &buf->risc, sgt->sgl,
+			     dev->ts_packet_size, dev->ts_packet_count, 0);
+	return 0;
 }
 
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
@@ -261,35 +249,33 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 	struct cx88_dmaqueue  *cx88q = &dev->mpegq;
 
 	dprintk( 1, "cx8802_buf_queue\n" );
-	/* add jump to stopper */
-	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-	buf->risc.jmp[1] = cpu_to_le32(cx88q->stopper.dma);
+	/* add jump to start */
+	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 8);
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
+	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 8);
 
 	if (list_empty(&cx88q->active)) {
 		dprintk( 1, "queue is empty - first active\n" );
-		list_add_tail(&buf->vb.queue,&cx88q->active);
-		cx8802_start_dma(dev, cx88q, buf);
-		buf->vb.state = VIDEOBUF_ACTIVE;
+		list_add_tail(&buf->list, &cx88q->active);
 		buf->count    = cx88q->count++;
-		mod_timer(&cx88q->timeout, jiffies+BUFFER_TIMEOUT);
 		dprintk(1,"[%p/%d] %s - first active\n",
-			buf, buf->vb.i, __func__);
+			buf, buf->vb.v4l2_buf.index, __func__);
 
 	} else {
+		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
 		dprintk( 1, "queue is not empty - append to active\n" );
-		prev = list_entry(cx88q->active.prev, struct cx88_buffer, vb.queue);
-		list_add_tail(&buf->vb.queue,&cx88q->active);
-		buf->vb.state = VIDEOBUF_ACTIVE;
+		prev = list_entry(cx88q->active.prev, struct cx88_buffer, list);
+		list_add_tail(&buf->list, &cx88q->active);
 		buf->count    = cx88q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk( 1, "[%p/%d] %s - append to active\n",
-			buf, buf->vb.i, __func__);
+			buf, buf->vb.v4l2_buf.index, __func__);
 	}
 }
 
 /* ----------------------------------------------------------- */
 
-static void do_cancel_buffers(struct cx8802_dev *dev, const char *reason, int restart)
+static void do_cancel_buffers(struct cx8802_dev *dev)
 {
 	struct cx88_dmaqueue *q = &dev->mpegq;
 	struct cx88_buffer *buf;
@@ -297,41 +283,18 @@ static void do_cancel_buffers(struct cx8802_dev *dev, const char *reason, int re
 
 	spin_lock_irqsave(&dev->slock,flags);
 	while (!list_empty(&q->active)) {
-		buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
-		list_del(&buf->vb.queue);
-		buf->vb.state = VIDEOBUF_ERROR;
-		wake_up(&buf->vb.done);
-		dprintk(1,"[%p/%d] %s - dma=0x%08lx\n",
-			buf, buf->vb.i, reason, (unsigned long)buf->risc.dma);
-	}
-	if (restart)
-	{
-		dprintk(1, "restarting queue\n" );
-		cx8802_restart_queue(dev,q);
+		buf = list_entry(q->active.next, struct cx88_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock,flags);
 }
 
 void cx8802_cancel_buffers(struct cx8802_dev *dev)
 {
-	struct cx88_dmaqueue *q = &dev->mpegq;
-
 	dprintk( 1, "cx8802_cancel_buffers" );
-	del_timer_sync(&q->timeout);
-	cx8802_stop_dma(dev);
-	do_cancel_buffers(dev,"cancel",0);
-}
-
-static void cx8802_timeout(unsigned long data)
-{
-	struct cx8802_dev *dev = (struct cx8802_dev*)data;
-
-	dprintk(1, "%s\n",__func__);
-
-	if (debug)
-		cx88_sram_channel_dump(dev->core, &cx88_sram_channels[SRAM_CH28]);
 	cx8802_stop_dma(dev);
-	do_cancel_buffers(dev,"timeout",1);
+	do_cancel_buffers(dev);
 }
 
 static const char * cx88_mpeg_irqs[32] = {
@@ -377,19 +340,11 @@ static void cx8802_mpeg_irq(struct cx8802_dev *dev)
 		spin_unlock(&dev->slock);
 	}
 
-	/* risc2 y */
-	if (status & 0x10) {
-		spin_lock(&dev->slock);
-		cx8802_restart_queue(dev,&dev->mpegq);
-		spin_unlock(&dev->slock);
-	}
-
 	/* other general errors */
 	if (status & 0x1f0100) {
 		dprintk( 0, "general errors: 0x%08x\n", status & 0x1f0100 );
 		spin_lock(&dev->slock);
 		cx8802_stop_dma(dev);
-		cx8802_restart_queue(dev,&dev->mpegq);
 		spin_unlock(&dev->slock);
 	}
 }
@@ -456,11 +411,6 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 
 	/* init dma queue */
 	INIT_LIST_HEAD(&dev->mpegq.active);
-	dev->mpegq.timeout.function = cx8802_timeout;
-	dev->mpegq.timeout.data     = (unsigned long)dev;
-	init_timer(&dev->mpegq.timeout);
-	cx88_risc_stopper(dev->pci,&dev->mpegq.stopper,
-			  MO_TS_DMACNTRL,0x11,0x00);
 
 	/* get irq */
 	err = request_irq(dev->pci->irq, cx8802_irq,
@@ -485,9 +435,6 @@ static void cx8802_fini_common(struct cx8802_dev *dev)
 
 	/* unregister stuff */
 	free_irq(dev->pci->irq, dev);
-
-	/* free memory */
-	btcx_riscmem_free(dev->pci,&dev->mpegq.stopper);
 }
 
 /* ----------------------------------------------------------- */
@@ -504,7 +451,6 @@ static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 		dprintk( 2, "suspend\n" );
 		printk("%s: suspend mpeg\n", core->name);
 		cx8802_stop_dma(dev);
-		del_timer(&dev->mpegq.timeout);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 
@@ -872,6 +818,7 @@ module_pci_driver(cx8802_pci_driver);
 EXPORT_SYMBOL(cx8802_buf_prepare);
 EXPORT_SYMBOL(cx8802_buf_queue);
 EXPORT_SYMBOL(cx8802_cancel_buffers);
+EXPORT_SYMBOL(cx8802_start_dma);
 
 EXPORT_SYMBOL(cx8802_register_driver);
 EXPORT_SYMBOL(cx8802_unregister_driver);
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index f8f8389..26a1533 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -6,10 +6,6 @@
 
 #include "cx88.h"
 
-static unsigned int vbibufs = 4;
-module_param(vbibufs,int,0644);
-MODULE_PARM_DESC(vbibufs,"number of vbi buffers, range 2-32");
-
 static unsigned int vbi_debug;
 module_param(vbi_debug,int,0644);
 MODULE_PARM_DESC(vbi_debug,"enable debug messages [vbi]");
@@ -22,8 +18,7 @@ MODULE_PARM_DESC(vbi_debug,"enable debug messages [vbi]");
 int cx8800_vbi_fmt (struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct cx8800_fh  *fh   = priv;
-	struct cx8800_dev *dev  = fh->dev;
+	struct cx8800_dev *dev = video_drvdata(file);
 
 	f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
@@ -54,7 +49,7 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 
 	/* setup fifo + format */
 	cx88_sram_channel_setup(dev->core, &cx88_sram_channels[SRAM_CH24],
-				buf->vb.width, buf->risc.dma);
+				VBI_LINE_LENGTH, buf->risc.dma);
 
 	cx_write(MO_VBOS_CONTROL, ( (1 << 18) |  // comb filter delay fixup
 				    (1 << 15) |  // enable vbi capture
@@ -78,7 +73,7 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 	return 0;
 }
 
-int cx8800_stop_vbi_dma(struct cx8800_dev *dev)
+void cx8800_stop_vbi_dma(struct cx8800_dev *dev)
 {
 	struct cx88_core *core = dev->core;
 
@@ -91,7 +86,6 @@ int cx8800_stop_vbi_dma(struct cx8800_dev *dev)
 	/* disable irqs */
 	cx_clear(MO_PCI_INTMSK, PCI_INT_VIDINT);
 	cx_clear(MO_VID_INTMSK, 0x0f0088);
-	return 0;
 }
 
 int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
@@ -102,144 +96,133 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 	if (list_empty(&q->active))
 		return 0;
 
-	buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
+	buf = list_entry(q->active.next, struct cx88_buffer, list);
 	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
-		buf, buf->vb.i);
+		buf, buf->vb.v4l2_buf.index);
 	cx8800_start_vbi_dma(dev, q, buf);
-	list_for_each_entry(buf, &q->active, vb.queue)
+	list_for_each_entry(buf, &q->active, list)
 		buf->count = q->count++;
-	mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
 	return 0;
 }
 
-void cx8800_vbi_timeout(unsigned long data)
-{
-	struct cx8800_dev *dev = (struct cx8800_dev*)data;
-	struct cx88_core *core = dev->core;
-	struct cx88_dmaqueue *q = &dev->vbiq;
-	struct cx88_buffer *buf;
-	unsigned long flags;
-
-	cx88_sram_channel_dump(dev->core, &cx88_sram_channels[SRAM_CH24]);
-
-	cx_clear(MO_VID_DMACNTRL, 0x88);
-	cx_clear(VID_CAPTURE_CONTROL, 0x18);
-
-	spin_lock_irqsave(&dev->slock,flags);
-	while (!list_empty(&q->active)) {
-		buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
-		list_del(&buf->vb.queue);
-		buf->vb.state = VIDEOBUF_ERROR;
-		wake_up(&buf->vb.done);
-		printk("%s/0: [%p/%d] timeout - dma=0x%08lx\n", dev->core->name,
-		       buf, buf->vb.i, (unsigned long)buf->risc.dma);
-	}
-	cx8800_restart_vbi_queue(dev,q);
-	spin_unlock_irqrestore(&dev->slock,flags);
-}
-
 /* ------------------------------------------------------------------ */
 
-static int
-vbi_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
+static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	*size = VBI_LINE_COUNT * VBI_LINE_LENGTH * 2;
-	if (0 == *count)
-		*count = vbibufs;
-	if (*count < 2)
-		*count = 2;
-	if (*count > 32)
-		*count = 32;
+	*num_planes = 1;
+	sizes[0] = VBI_LINE_COUNT * VBI_LINE_LENGTH * 2;
 	return 0;
 }
 
-static int
-vbi_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-	    enum v4l2_field field)
+
+static int buffer_prepare(struct vb2_buffer *vb)
 {
-	struct cx8800_fh   *fh  = q->priv_data;
-	struct cx8800_dev  *dev = fh->dev;
-	struct cx88_buffer *buf = container_of(vb,struct cx88_buffer,vb);
+	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned int size;
 	int rc;
 
 	size = VBI_LINE_COUNT * VBI_LINE_LENGTH * 2;
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
+	if (vb2_plane_size(vb, 0) < size)
 		return -EINVAL;
+	vb2_set_plane_payload(vb, 0, size);
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-		buf->vb.width  = VBI_LINE_LENGTH;
-		buf->vb.height = VBI_LINE_COUNT;
-		buf->vb.size   = size;
-		buf->vb.field  = V4L2_FIELD_SEQ_TB;
-
-		if (0 != (rc = videobuf_iolock(q,&buf->vb,NULL)))
-			goto fail;
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 dma->sglist,
-				 0, buf->vb.width * buf->vb.height,
-				 buf->vb.width, 0,
-				 buf->vb.height);
-	}
-	buf->vb.state = VIDEOBUF_PREPARED;
+	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
+	if (!rc)
+		return -EIO;
+
+	cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
+			 0, VBI_LINE_LENGTH * VBI_LINE_COUNT,
+			 VBI_LINE_LENGTH, 0,
+			 VBI_LINE_COUNT);
 	return 0;
+}
 
- fail:
-	cx88_free_buffer(q,buf);
-	return rc;
+static void buffer_finish(struct vb2_buffer *vb)
+{
+	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+
+	cx88_free_buffer(vb->vb2_queue, buf);
+
+	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
-static void
-vbi_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct cx88_buffer    *buf = container_of(vb,struct cx88_buffer,vb);
+	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_buffer    *prev;
-	struct cx8800_fh      *fh   = vq->priv_data;
-	struct cx8800_dev     *dev  = fh->dev;
 	struct cx88_dmaqueue  *q    = &dev->vbiq;
 
-	/* add jump to stopper */
-	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-	buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
+	/* add jump to start */
+	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 8);
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
+	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 8);
 
 	if (list_empty(&q->active)) {
-		list_add_tail(&buf->vb.queue,&q->active);
+		list_add_tail(&buf->list, &q->active);
 		cx8800_start_vbi_dma(dev, q, buf);
-		buf->vb.state = VIDEOBUF_ACTIVE;
 		buf->count    = q->count++;
-		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
 		dprintk(2,"[%p/%d] vbi_queue - first active\n",
-			buf, buf->vb.i);
+			buf, buf->vb.v4l2_buf.index);
 
 	} else {
-		prev = list_entry(q->active.prev, struct cx88_buffer, vb.queue);
-		list_add_tail(&buf->vb.queue,&q->active);
-		buf->vb.state = VIDEOBUF_ACTIVE;
+		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
+		prev = list_entry(q->active.prev, struct cx88_buffer, list);
+		list_add_tail(&buf->list, &q->active);
 		buf->count    = q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2,"[%p/%d] buffer_queue - append to active\n",
-			buf, buf->vb.i);
+			buf, buf->vb.v4l2_buf.index);
 	}
 }
 
-static void vbi_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct cx88_buffer *buf = container_of(vb,struct cx88_buffer,vb);
+	struct cx8800_dev *dev = q->drv_priv;
+	struct cx88_dmaqueue *dmaq = &dev->vbiq;
+	struct cx88_buffer *buf = list_entry(dmaq->active.next,
+			struct cx88_buffer, list);
 
-	cx88_free_buffer(q,buf);
+	cx8800_start_vbi_dma(dev, dmaq, buf);
+	return 0;
 }
 
-const struct videobuf_queue_ops cx8800_vbi_qops = {
-	.buf_setup    = vbi_setup,
-	.buf_prepare  = vbi_prepare,
-	.buf_queue    = vbi_queue,
-	.buf_release  = vbi_release,
-};
+static void stop_streaming(struct vb2_queue *q)
+{
+	struct cx8800_dev *dev = q->drv_priv;
+	struct cx88_core *core = dev->core;
+	struct cx88_dmaqueue *dmaq = &dev->vbiq;
+	unsigned long flags;
 
-/* ------------------------------------------------------------------ */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
+	cx88_sram_channel_dump(core, &cx88_sram_channels[SRAM_CH21]);
+
+	cx_clear(MO_VID_DMACNTRL, 0x11);
+	cx_clear(VID_CAPTURE_CONTROL, 0x06);
+	cx8800_stop_vbi_dma(dev);
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct cx88_buffer *buf = list_entry(dmaq->active.next,
+			struct cx88_buffer, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+const struct vb2_ops cx8800_vbi_qops = {
+	.queue_setup    = queue_setup,
+	.buf_prepare  = buffer_prepare,
+	.buf_finish = buffer_finish,
+	.buf_queue    = buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
+};
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 10fea4d..9887da5 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -70,10 +70,6 @@ static unsigned int irq_debug;
 module_param(irq_debug,int,0644);
 MODULE_PARM_DESC(irq_debug,"enable debug messages [IRQ handler]");
 
-static unsigned int vid_limit = 16;
-module_param(vid_limit,int,0644);
-MODULE_PARM_DESC(vid_limit,"capture memory limit in megabytes");
-
 #define dprintk(level,fmt, arg...)	if (video_debug >= level) \
 	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
 
@@ -297,56 +293,6 @@ enum {
 	CX8800_AUD_CTLS = ARRAY_SIZE(cx8800_aud_ctls),
 };
 
-/* ------------------------------------------------------------------- */
-/* resource management                                                 */
-
-static int res_get(struct cx8800_dev *dev, struct cx8800_fh *fh, unsigned int bit)
-{
-	struct cx88_core *core = dev->core;
-	if (fh->resources & bit)
-		/* have it already allocated */
-		return 1;
-
-	/* is it free? */
-	mutex_lock(&core->lock);
-	if (dev->resources & bit) {
-		/* no, someone else uses it */
-		mutex_unlock(&core->lock);
-		return 0;
-	}
-	/* it's free, grab it */
-	fh->resources  |= bit;
-	dev->resources |= bit;
-	dprintk(1,"res: get %d\n",bit);
-	mutex_unlock(&core->lock);
-	return 1;
-}
-
-static
-int res_check(struct cx8800_fh *fh, unsigned int bit)
-{
-	return (fh->resources & bit);
-}
-
-static
-int res_locked(struct cx8800_dev *dev, unsigned int bit)
-{
-	return (dev->resources & bit);
-}
-
-static
-void res_free(struct cx8800_dev *dev, struct cx8800_fh *fh, unsigned int bits)
-{
-	struct cx88_core *core = dev->core;
-	BUG_ON((fh->resources & bits) != bits);
-
-	mutex_lock(&core->lock);
-	fh->resources  &= ~bits;
-	dev->resources &= ~bits;
-	dprintk(1,"res: put %d\n",bits);
-	mutex_unlock(&core->lock);
-}
-
 /* ------------------------------------------------------------------ */
 
 int cx88_video_mux(struct cx88_core *core, unsigned int input)
@@ -419,7 +365,7 @@ static int start_video_dma(struct cx8800_dev    *dev,
 	/* setup fifo + format */
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH21],
 				buf->bpl, buf->risc.dma);
-	cx88_set_scale(core, buf->vb.width, buf->vb.height, buf->vb.field);
+	cx88_set_scale(core, dev->width, dev->height, dev->field);
 	cx_write(MO_COLOR_CTRL, dev->fmt->cxformat | ColorFormatGamma);
 
 	/* reset counter */
@@ -473,376 +419,206 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 	struct cx88_buffer *buf;
 
 	if (!list_empty(&q->active)) {
-		buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
+		buf = list_entry(q->active.next, struct cx88_buffer, list);
 		dprintk(2,"restart_queue [%p/%d]: restart dma\n",
-			buf, buf->vb.i);
+			buf, buf->vb.v4l2_buf.index);
 		start_video_dma(dev, q, buf);
-		list_for_each_entry(buf, &q->active, vb.queue)
+		list_for_each_entry(buf, &q->active, list)
 			buf->count = q->count++;
-		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
 	}
 	return 0;
 }
 
 /* ------------------------------------------------------------------ */
 
-static int
-buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
+static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct cx8800_fh *fh = q->priv_data;
-	struct cx8800_dev  *dev = fh->dev;
-
-	*size = dev->fmt->depth * dev->width * dev->height >> 3;
-	if (0 == *count)
-		*count = 32;
-	if (*size * *count > vid_limit * 1024 * 1024)
-		*count = (vid_limit * 1024 * 1024) / *size;
+	struct cx8800_dev *dev = q->drv_priv;
+
+	*num_planes = 1;
+	sizes[0] = (dev->fmt->depth * dev->width * dev->height) >> 3;
 	return 0;
 }
 
-static int
-buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-	       enum v4l2_field field)
+static int buffer_prepare(struct vb2_buffer *vb)
 {
-	struct cx8800_fh   *fh  = q->priv_data;
-	struct cx8800_dev  *dev = fh->dev;
+	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
-	struct cx88_buffer *buf = container_of(vb,struct cx88_buffer,vb);
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	int rc;
 
-	BUG_ON(NULL == dev->fmt);
-	if (dev->width  < 48 || dev->width  > norm_maxw(core->tvnorm) ||
-	    dev->height < 32 || dev->height > norm_maxh(core->tvnorm))
-		return -EINVAL;
-	buf->vb.size = (dev->width * dev->height * dev->fmt->depth) >> 3;
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
+	buf->bpl = dev->width * dev->fmt->depth >> 3;
+
+	if (vb2_plane_size(vb, 0) < dev->height * buf->bpl)
 		return -EINVAL;
+	vb2_set_plane_payload(vb, 0, dev->height * buf->bpl);
 
-	buf->vb.width  = dev->width;
-	buf->vb.height = dev->height;
-	buf->vb.field  = field;
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		if (0 != (rc = videobuf_iolock(q,&buf->vb,NULL)))
-			goto fail;
-	}
+	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
+	if (!rc)
+		return -EIO;
 
-	buf->bpl = buf->vb.width * dev->fmt->depth >> 3;
-	switch (buf->vb.field) {
+	switch (dev->field) {
 	case V4L2_FIELD_TOP:
 		cx88_risc_buffer(dev->pci, &buf->risc,
-				 dma->sglist, 0, UNSET,
-				 buf->bpl, 0, buf->vb.height);
+				 sgt->sgl, 0, UNSET,
+				 buf->bpl, 0, dev->height);
 		break;
 	case V4L2_FIELD_BOTTOM:
 		cx88_risc_buffer(dev->pci, &buf->risc,
-				 dma->sglist, UNSET, 0,
-				 buf->bpl, 0, buf->vb.height);
+				 sgt->sgl, UNSET, 0,
+				 buf->bpl, 0, dev->height);
 		break;
 	case V4L2_FIELD_SEQ_TB:
 		cx88_risc_buffer(dev->pci, &buf->risc,
-				 dma->sglist,
-				 0, buf->bpl * (buf->vb.height >> 1),
+				 sgt->sgl,
+				 0, buf->bpl * (dev->height >> 1),
 				 buf->bpl, 0,
-				 buf->vb.height >> 1);
+				 dev->height >> 1);
 		break;
 	case V4L2_FIELD_SEQ_BT:
 		cx88_risc_buffer(dev->pci, &buf->risc,
-				 dma->sglist,
-				 buf->bpl * (buf->vb.height >> 1), 0,
+				 sgt->sgl,
+				 buf->bpl * (dev->height >> 1), 0,
 				 buf->bpl, 0,
-				 buf->vb.height >> 1);
+				 dev->height >> 1);
 		break;
 	case V4L2_FIELD_INTERLACED:
 	default:
 		cx88_risc_buffer(dev->pci, &buf->risc,
-				 dma->sglist, 0, buf->bpl,
+				 sgt->sgl, 0, buf->bpl,
 				 buf->bpl, buf->bpl,
-				 buf->vb.height >> 1);
+				 dev->height >> 1);
 		break;
 	}
 	dprintk(2,"[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
-		buf, buf->vb.i,
+		buf, buf->vb.v4l2_buf.index,
 		dev->width, dev->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
-
-	buf->vb.state = VIDEOBUF_PREPARED;
 	return 0;
+}
+
+static void buffer_finish(struct vb2_buffer *vb)
+{
+	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+
+	cx88_free_buffer(vb->vb2_queue, buf);
 
- fail:
-	cx88_free_buffer(q,buf);
-	return rc;
+	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
-static void
-buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct cx88_buffer    *buf = container_of(vb,struct cx88_buffer,vb);
+	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_buffer    *prev;
-	struct cx8800_fh      *fh   = vq->priv_data;
-	struct cx8800_dev     *dev  = fh->dev;
 	struct cx88_core      *core = dev->core;
 	struct cx88_dmaqueue  *q    = &dev->vidq;
 
-	/* add jump to stopper */
-	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-	buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
+	/* add jump to start */
+	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 8);
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
+	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 8);
 
 	if (list_empty(&q->active)) {
-		list_add_tail(&buf->vb.queue,&q->active);
+		list_add_tail(&buf->list, &q->active);
 		start_video_dma(dev, q, buf);
-		buf->vb.state = VIDEOBUF_ACTIVE;
 		buf->count    = q->count++;
-		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
 		dprintk(2,"[%p/%d] buffer_queue - first active\n",
-			buf, buf->vb.i);
+			buf, buf->vb.v4l2_buf.index);
 
 	} else {
-		prev = list_entry(q->active.prev, struct cx88_buffer, vb.queue);
-		list_add_tail(&buf->vb.queue, &q->active);
-		buf->vb.state = VIDEOBUF_ACTIVE;
+		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
+		prev = list_entry(q->active.prev, struct cx88_buffer, list);
+		list_add_tail(&buf->list, &q->active);
 		buf->count    = q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
-			buf, buf->vb.i);
+			buf, buf->vb.v4l2_buf.index);
 	}
 }
 
-static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct cx88_buffer *buf = container_of(vb,struct cx88_buffer,vb);
+	struct cx8800_dev *dev = q->drv_priv;
+	struct cx88_dmaqueue *dmaq = &dev->vidq;
+	struct cx88_buffer *buf = list_entry(dmaq->active.next,
+			struct cx88_buffer, list);
 
-	cx88_free_buffer(q,buf);
+	start_video_dma(dev, dmaq, buf);
+	return 0;
 }
 
-static const struct videobuf_queue_ops cx8800_video_qops = {
-	.buf_setup    = buffer_setup,
-	.buf_prepare  = buffer_prepare,
-	.buf_queue    = buffer_queue,
-	.buf_release  = buffer_release,
-};
-
-/* ------------------------------------------------------------------ */
-
+static void stop_streaming(struct vb2_queue *q)
+{
+	struct cx8800_dev *dev = q->drv_priv;
+	struct cx88_core *core = dev->core;
+	struct cx88_dmaqueue *dmaq = &dev->vidq;
+	unsigned long flags;
 
-/* ------------------------------------------------------------------ */
+	cx88_sram_channel_dump(core, &cx88_sram_channels[SRAM_CH21]);
 
-static struct videobuf_queue *get_queue(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct cx8800_fh *fh = file->private_data;
+	cx_clear(MO_VID_DMACNTRL, 0x11);
+	cx_clear(VID_CAPTURE_CONTROL, 0x06);
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct cx88_buffer *buf = list_entry(dmaq->active.next,
+			struct cx88_buffer, list);
 
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		return &fh->vidq;
-	case VFL_TYPE_VBI:
-		return &fh->vbiq;
-	default:
-		BUG();
-		return NULL;
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static int get_resource(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
+static struct vb2_ops cx8800_video_qops = {
+	.queue_setup    = queue_setup,
+	.buf_prepare  = buffer_prepare,
+	.buf_finish = buffer_finish,
+	.buf_queue    = buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
+};
 
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		return RESOURCE_VIDEO;
-	case VFL_TYPE_VBI:
-		return RESOURCE_VBI;
-	default:
-		BUG();
-		return 0;
-	}
-}
+/* ------------------------------------------------------------------ */
 
-static int video_open(struct file *file)
+static int radio_open(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
-	struct cx8800_fh *fh;
-	enum v4l2_buf_type type = 0;
-	int radio = 0;
-
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		break;
-	case VFL_TYPE_VBI:
-		type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		break;
-	case VFL_TYPE_RADIO:
-		radio = 1;
-		break;
-	}
-
-	dprintk(1, "open dev=%s radio=%d type=%s\n",
-		video_device_node_name(vdev), radio, v4l2_type_names[type]);
+	int ret = v4l2_fh_open(file);
 
-	/* allocate + initialize per filehandle data */
-	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
-	if (unlikely(!fh))
-		return -ENOMEM;
-
-	v4l2_fh_init(&fh->fh, vdev);
-	file->private_data = fh;
-	fh->dev      = dev;
-
-	mutex_lock(&core->lock);
+	if (ret)
+		return ret;
 
-	videobuf_queue_sg_init(&fh->vidq, &cx8800_video_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			    V4L2_FIELD_INTERLACED,
-			    sizeof(struct cx88_buffer),
-			    fh, NULL);
-	videobuf_queue_sg_init(&fh->vbiq, &cx8800_vbi_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VBI_CAPTURE,
-			    V4L2_FIELD_SEQ_TB,
-			    sizeof(struct cx88_buffer),
-			    fh, NULL);
-
-	if (vdev->vfl_type == VFL_TYPE_RADIO) {
-		dprintk(1,"video_open: setting radio device\n");
-		cx_write(MO_GP3_IO, core->board.radio.gpio3);
-		cx_write(MO_GP0_IO, core->board.radio.gpio0);
-		cx_write(MO_GP1_IO, core->board.radio.gpio1);
-		cx_write(MO_GP2_IO, core->board.radio.gpio2);
-		if (core->board.radio.audioroute) {
-			if (core->sd_wm8775) {
-				call_all(core, audio, s_routing,
+	cx_write(MO_GP3_IO, core->board.radio.gpio3);
+	cx_write(MO_GP0_IO, core->board.radio.gpio0);
+	cx_write(MO_GP1_IO, core->board.radio.gpio1);
+	cx_write(MO_GP2_IO, core->board.radio.gpio2);
+	if (core->board.radio.audioroute) {
+		if (core->sd_wm8775) {
+			call_all(core, audio, s_routing,
 					core->board.radio.audioroute, 0, 0);
-			}
-			/* "I2S ADC mode" */
-			core->tvaudio = WW_I2SADC;
-			cx88_set_tvaudio(core);
-		} else {
-			/* FM Mode */
-			core->tvaudio = WW_FM;
-			cx88_set_tvaudio(core);
-			cx88_set_stereo(core,V4L2_TUNER_MODE_STEREO,1);
 		}
-		call_all(core, tuner, s_radio);
-	}
-
-	core->users++;
-	mutex_unlock(&core->lock);
-	v4l2_fh_add(&fh->fh);
-
-	return 0;
-}
-
-static ssize_t
-video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct cx8800_fh *fh = file->private_data;
-
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		if (res_locked(fh->dev,RESOURCE_VIDEO))
-			return -EBUSY;
-		return videobuf_read_one(&fh->vidq, data, count, ppos,
-					 file->f_flags & O_NONBLOCK);
-	case VFL_TYPE_VBI:
-		if (!res_get(fh->dev,fh,RESOURCE_VBI))
-			return -EBUSY;
-		return videobuf_read_stream(&fh->vbiq, data, count, ppos, 1,
-					    file->f_flags & O_NONBLOCK);
-	default:
-		BUG();
-		return 0;
-	}
-}
-
-static unsigned int
-video_poll(struct file *file, struct poll_table_struct *wait)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct cx8800_fh *fh = file->private_data;
-	struct cx88_buffer *buf;
-	unsigned int rc = v4l2_ctrl_poll(file, wait);
-
-	if (vdev->vfl_type == VFL_TYPE_VBI) {
-		if (!res_get(fh->dev,fh,RESOURCE_VBI))
-			return rc | POLLERR;
-		return rc | videobuf_poll_stream(file, &fh->vbiq, wait);
-	}
-	mutex_lock(&fh->vidq.vb_lock);
-	if (res_check(fh,RESOURCE_VIDEO)) {
-		/* streaming capture */
-		if (list_empty(&fh->vidq.stream))
-			goto done;
-		buf = list_entry(fh->vidq.stream.next,struct cx88_buffer,vb.stream);
+		/* "I2S ADC mode" */
+		core->tvaudio = WW_I2SADC;
+		cx88_set_tvaudio(core);
 	} else {
-		/* read() capture */
-		buf = (struct cx88_buffer*)fh->vidq.read_buf;
-		if (NULL == buf)
-			goto done;
+		/* FM Mode */
+		core->tvaudio = WW_FM;
+		cx88_set_tvaudio(core);
+		cx88_set_stereo(core, V4L2_TUNER_MODE_STEREO, 1);
 	}
-	poll_wait(file, &buf->vb.done, wait);
-	if (buf->vb.state == VIDEOBUF_DONE ||
-	    buf->vb.state == VIDEOBUF_ERROR)
-		rc |= POLLIN|POLLRDNORM;
-done:
-	mutex_unlock(&fh->vidq.vb_lock);
-	return rc;
-}
-
-static int video_release(struct file *file)
-{
-	struct cx8800_fh  *fh  = file->private_data;
-	struct cx8800_dev *dev = fh->dev;
-
-	/* turn off overlay */
-	if (res_check(fh, RESOURCE_OVERLAY)) {
-		/* FIXME */
-		res_free(dev,fh,RESOURCE_OVERLAY);
-	}
-
-	/* stop video capture */
-	if (res_check(fh, RESOURCE_VIDEO)) {
-		videobuf_queue_cancel(&fh->vidq);
-		res_free(dev,fh,RESOURCE_VIDEO);
-	}
-	if (fh->vidq.read_buf) {
-		buffer_release(&fh->vidq,fh->vidq.read_buf);
-		kfree(fh->vidq.read_buf);
-	}
-
-	/* stop vbi capture */
-	if (res_check(fh, RESOURCE_VBI)) {
-		videobuf_stop(&fh->vbiq);
-		res_free(dev,fh,RESOURCE_VBI);
-	}
-
-	videobuf_mmap_free(&fh->vidq);
-	videobuf_mmap_free(&fh->vbiq);
-
-	mutex_lock(&dev->core->lock);
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
-	file->private_data = NULL;
-	kfree(fh);
-
-	dev->core->users--;
-	if (!dev->core->users)
-		call_all(dev->core, core, s_power, 0);
-	mutex_unlock(&dev->core->lock);
-
+	call_all(core, tuner, s_radio);
 	return 0;
 }
 
-static int
-video_mmap(struct file *file, struct vm_area_struct * vma)
-{
-	return videobuf_mmap_mapper(get_queue(file), vma);
-}
-
 /* ------------------------------------------------------------------ */
 /* VIDEO CTRL IOCTLS                                                  */
 
@@ -945,12 +721,11 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct cx8800_fh  *fh   = priv;
-	struct cx8800_dev *dev = fh->dev;
+	struct cx8800_dev *dev = video_drvdata(file);
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = fh->vidq.field;
+	f->fmt.pix.field        = dev->field;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
@@ -963,7 +738,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *f)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 	const struct cx8800_fmt *fmt;
 	enum v4l2_field   field;
 	unsigned int      maxw, maxh;
@@ -1007,8 +783,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct cx8800_fh  *fh   = priv;
-	struct cx8800_dev *dev = fh->dev;
+	struct cx8800_dev *dev = video_drvdata(file);
 	int err = vidioc_try_fmt_vid_cap (file,priv,f);
 
 	if (0 != err)
@@ -1016,7 +791,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
 	dev->width      = f->fmt.pix.width;
 	dev->height     = f->fmt.pix.height;
-	fh->vidq.field = f->fmt.pix.field;
+	dev->field = f->fmt.pix.field;
 	return 0;
 }
 
@@ -1050,8 +825,8 @@ EXPORT_SYMBOL(cx88_querycap);
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct cx8800_dev *dev  = ((struct cx8800_fh *)priv)->dev;
-	struct cx88_core  *core = dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	strcpy(cap->driver, "cx8800");
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
@@ -1071,64 +846,10 @@ static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_reqbufs (struct file *file, void *priv, struct v4l2_requestbuffers *p)
-{
-	return videobuf_reqbufs(get_queue(file), p);
-}
-
-static int vidioc_querybuf (struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	return videobuf_querybuf(get_queue(file), p);
-}
-
-static int vidioc_qbuf (struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	return videobuf_qbuf(get_queue(file), p);
-}
-
-static int vidioc_dqbuf (struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	return videobuf_dqbuf(get_queue(file), p,
-				file->f_flags & O_NONBLOCK);
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct cx8800_fh  *fh   = priv;
-	struct cx8800_dev *dev  = fh->dev;
-
-	if ((vdev->vfl_type == VFL_TYPE_GRABBER && i != V4L2_BUF_TYPE_VIDEO_CAPTURE) ||
-	    (vdev->vfl_type == VFL_TYPE_VBI && i != V4L2_BUF_TYPE_VBI_CAPTURE))
-		return -EINVAL;
-
-	if (unlikely(!res_get(dev, fh, get_resource(file))))
-		return -EBUSY;
-	return videobuf_streamon(get_queue(file));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct cx8800_fh  *fh   = priv;
-	struct cx8800_dev *dev  = fh->dev;
-	int               err, res;
-
-	if ((vdev->vfl_type == VFL_TYPE_GRABBER && i != V4L2_BUF_TYPE_VIDEO_CAPTURE) ||
-	    (vdev->vfl_type == VFL_TYPE_VBI && i != V4L2_BUF_TYPE_VBI_CAPTURE))
-		return -EINVAL;
-
-	res = get_resource(file);
-	err = videobuf_streamoff(get_queue(file));
-	if (err < 0)
-		return err;
-	res_free(dev,fh,res);
-	return 0;
-}
-
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
 {
-	struct cx88_core *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	*tvnorm = core->tvnorm;
 	return 0;
@@ -1136,11 +857,10 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorm)
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
-	mutex_lock(&core->lock);
 	cx88_set_tvnorm(core, tvnorms);
-	mutex_unlock(&core->lock);
 
 	return 0;
 }
@@ -1179,13 +899,15 @@ EXPORT_SYMBOL(cx88_enum_input);
 static int vidioc_enum_input (struct file *file, void *priv,
 				struct v4l2_input *i)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 	return cx88_enum_input (core,i);
 }
 
 static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	*i = core->input;
 	return 0;
@@ -1193,24 +915,24 @@ static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
 
 static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (i >= 4)
 		return -EINVAL;
 	if (0 == INPUT(i).type)
 		return -EINVAL;
 
-	mutex_lock(&core->lock);
 	cx88_newstation(core);
 	cx88_video_mux(core,i);
-	mutex_unlock(&core->lock);
 	return 0;
 }
 
 static int vidioc_g_tuner (struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 	u32 reg;
 
 	if (unlikely(UNSET == core->board.tuner_type))
@@ -1232,7 +954,8 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 static int vidioc_s_tuner (struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (UNSET == core->board.tuner_type)
 		return -EINVAL;
@@ -1246,8 +969,8 @@ static int vidioc_s_tuner (struct file *file, void *priv,
 static int vidioc_g_frequency (struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct cx8800_fh  *fh   = priv;
-	struct cx88_core  *core = fh->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
@@ -1271,7 +994,6 @@ int cx88_set_freq (struct cx88_core  *core,
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
 
-	mutex_lock(&core->lock);
 	cx88_newstation(core);
 	call_all(core, tuner, s_frequency, f);
 	call_all(core, tuner, g_frequency, &new_freq);
@@ -1281,8 +1003,6 @@ int cx88_set_freq (struct cx88_core  *core,
 	msleep (10);
 	cx88_set_tvaudio(core);
 
-	mutex_unlock(&core->lock);
-
 	return 0;
 }
 EXPORT_SYMBOL(cx88_set_freq);
@@ -1290,8 +1010,8 @@ EXPORT_SYMBOL(cx88_set_freq);
 static int vidioc_s_frequency (struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
-	struct cx8800_fh  *fh   = priv;
-	struct cx88_core  *core = fh->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	return cx88_set_freq(core, f);
 }
@@ -1300,7 +1020,8 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 static int vidioc_g_register (struct file *file, void *fh,
 				struct v4l2_dbg_register *reg)
 {
-	struct cx88_core *core = ((struct cx8800_fh*)fh)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	/* cx2388x has a 24-bit register space */
 	reg->val = cx_read(reg->reg & 0xfffffc);
@@ -1311,7 +1032,8 @@ static int vidioc_g_register (struct file *file, void *fh,
 static int vidioc_s_register (struct file *file, void *fh,
 				const struct v4l2_dbg_register *reg)
 {
-	struct cx88_core *core = ((struct cx8800_fh*)fh)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	cx_write(reg->reg & 0xfffffc, reg->val);
 	return 0;
@@ -1325,7 +1047,8 @@ static int vidioc_s_register (struct file *file, void *fh,
 static int radio_g_tuner (struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (unlikely(t->index > 0))
 		return -EINVAL;
@@ -1339,7 +1062,8 @@ static int radio_g_tuner (struct file *file, void *priv,
 static int radio_s_tuner (struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	if (0 != t->index)
 		return -EINVAL;
@@ -1350,32 +1074,6 @@ static int radio_s_tuner (struct file *file, void *priv,
 
 /* ----------------------------------------------------------- */
 
-static void cx8800_vid_timeout(unsigned long data)
-{
-	struct cx8800_dev *dev = (struct cx8800_dev*)data;
-	struct cx88_core *core = dev->core;
-	struct cx88_dmaqueue *q = &dev->vidq;
-	struct cx88_buffer *buf;
-	unsigned long flags;
-
-	cx88_sram_channel_dump(core, &cx88_sram_channels[SRAM_CH21]);
-
-	cx_clear(MO_VID_DMACNTRL, 0x11);
-	cx_clear(VID_CAPTURE_CONTROL, 0x06);
-
-	spin_lock_irqsave(&dev->slock,flags);
-	while (!list_empty(&q->active)) {
-		buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
-		list_del(&buf->vb.queue);
-		buf->vb.state = VIDEOBUF_ERROR;
-		wake_up(&buf->vb.done);
-		printk("%s/0: [%p/%d] timeout - dma=0x%08lx\n", core->name,
-		       buf, buf->vb.i, (unsigned long)buf->risc.dma);
-	}
-	restart_video_queue(dev,q);
-	spin_unlock_irqrestore(&dev->slock,flags);
-}
-
 static const char *cx88_vid_irqs[32] = {
 	"y_risci1", "u_risci1", "v_risci1", "vbi_risc1",
 	"y_risci2", "u_risci2", "v_risci2", "vbi_risc2",
@@ -1422,22 +1120,6 @@ static void cx8800_vid_irq(struct cx8800_dev *dev)
 		cx88_wakeup(core, &dev->vbiq, count);
 		spin_unlock(&dev->slock);
 	}
-
-	/* risc2 y */
-	if (status & 0x10) {
-		dprintk(2,"stopper video\n");
-		spin_lock(&dev->slock);
-		restart_video_queue(dev,&dev->vidq);
-		spin_unlock(&dev->slock);
-	}
-
-	/* risc2 vbi */
-	if (status & 0x80) {
-		dprintk(2,"stopper vbi\n");
-		spin_lock(&dev->slock);
-		cx8800_restart_vbi_queue(dev,&dev->vbiq);
-		spin_unlock(&dev->slock);
-	}
 }
 
 static irqreturn_t cx8800_irq(int irq, void *dev_id)
@@ -1476,11 +1158,11 @@ static irqreturn_t cx8800_irq(int irq, void *dev_id)
 static const struct v4l2_file_operations video_fops =
 {
 	.owner	       = THIS_MODULE,
-	.open	       = video_open,
-	.release       = video_release,
-	.read	       = video_read,
-	.poll          = video_poll,
-	.mmap	       = video_mmap,
+	.open	       = v4l2_fh_open,
+	.release       = vb2_fop_release,
+	.read	       = vb2_fop_read,
+	.poll          = vb2_fop_poll,
+	.mmap	       = vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
 
@@ -1490,17 +1172,17 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
-	.vidioc_reqbufs       = vidioc_reqbufs,
-	.vidioc_querybuf      = vidioc_querybuf,
-	.vidioc_qbuf          = vidioc_qbuf,
-	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
 	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_streamon      = vidioc_streamon,
-	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_g_tuner       = vidioc_g_tuner,
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
@@ -1525,17 +1207,17 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_g_fmt_vbi_cap     = cx8800_vbi_fmt,
 	.vidioc_try_fmt_vbi_cap   = cx8800_vbi_fmt,
 	.vidioc_s_fmt_vbi_cap     = cx8800_vbi_fmt,
-	.vidioc_reqbufs       = vidioc_reqbufs,
-	.vidioc_querybuf      = vidioc_querybuf,
-	.vidioc_qbuf          = vidioc_qbuf,
-	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
 	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_streamon      = vidioc_streamon,
-	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_g_tuner       = vidioc_g_tuner,
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
@@ -1556,9 +1238,9 @@ static const struct video_device cx8800_vbi_template = {
 static const struct v4l2_file_operations radio_fops =
 {
 	.owner         = THIS_MODULE,
-	.open          = video_open,
+	.open          = radio_open,
 	.poll          = v4l2_ctrl_poll,
-	.release       = video_release,
+	.release       = v4l2_fh_release,
 	.unlocked_ioctl = video_ioctl2,
 };
 
@@ -1622,6 +1304,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 {
 	struct cx8800_dev *dev;
 	struct cx88_core *core;
+	struct vb2_queue *q;
 	int err;
 	int i;
 
@@ -1663,19 +1346,9 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
-	dev->vidq.timeout.function = cx8800_vid_timeout;
-	dev->vidq.timeout.data     = (unsigned long)dev;
-	init_timer(&dev->vidq.timeout);
-	cx88_risc_stopper(dev->pci,&dev->vidq.stopper,
-			  MO_VID_DMACNTRL,0x11,0x00);
 
 	/* init vbi dma queues */
 	INIT_LIST_HEAD(&dev->vbiq.active);
-	dev->vbiq.timeout.function = cx8800_vbi_timeout;
-	dev->vbiq.timeout.data     = (unsigned long)dev;
-	init_timer(&dev->vbiq.timeout);
-	cx88_risc_stopper(dev->pci,&dev->vbiq.stopper,
-			  MO_VID_DMACNTRL,0x88,0x00);
 
 	/* get irq */
 	err = request_irq(pci_dev->irq, cx8800_irq,
@@ -1766,6 +1439,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	dev->width   = 320;
 	dev->height  = 240;
+	dev->field   = V4L2_FIELD_INTERLACED;
 	dev->fmt     = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
 	/* initial device configuration */
@@ -1775,11 +1449,44 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	v4l2_ctrl_handler_setup(&core->audio_hdl);
 	cx88_video_mux(core, 0);
 
+	q = &dev->vb2_vidq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	q->gfp_flags = GFP_DMA32;
+	q->min_buffers_needed = 2;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct cx88_buffer);
+	q->ops = &cx8800_video_qops;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &core->lock;
+
+	err = vb2_queue_init(q);
+	if (err < 0)
+		goto fail_unreg;
+
+	q = &dev->vb2_vbiq;
+	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	q->gfp_flags = GFP_DMA32;
+	q->min_buffers_needed = 2;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct cx88_buffer);
+	q->ops = &cx8800_vbi_qops;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &core->lock;
+
+	err = vb2_queue_init(q);
+	if (err < 0)
+		goto fail_unreg;
+
 	/* register v4l devices */
 	dev->video_dev = cx88_vdev_init(core,dev->pci,
 					&cx8800_video_template,"video");
 	video_set_drvdata(dev->video_dev, dev);
 	dev->video_dev->ctrl_handler = &core->video_hdl;
+	dev->video_dev->queue = &dev->vb2_vidq;
 	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
 				    video_nr[core->nr]);
 	if (err < 0) {
@@ -1792,6 +1499,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	dev->vbi_dev = cx88_vdev_init(core,dev->pci,&cx8800_vbi_template,"vbi");
 	video_set_drvdata(dev->vbi_dev, dev);
+	dev->vbi_dev->queue = &dev->vb2_vbiq;
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
 				    vbi_nr[core->nr]);
 	if (err < 0) {
@@ -1865,7 +1573,6 @@ static void cx8800_finidev(struct pci_dev *pci_dev)
 	cx8800_unregister_video(dev);
 
 	/* free memory */
-	btcx_riscmem_free(dev->pci,&dev->vidq.stopper);
 	cx88_core_put(core,dev->pci);
 	kfree(dev);
 }
@@ -1882,12 +1589,10 @@ static int cx8800_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	if (!list_empty(&dev->vidq.active)) {
 		printk("%s/0: suspend video\n", core->name);
 		stop_video_dma(dev);
-		del_timer(&dev->vidq.timeout);
 	}
 	if (!list_empty(&dev->vbiq.active)) {
 		printk("%s/0: suspend vbi\n", core->name);
 		cx8800_stop_vbi_dma(dev);
-		del_timer(&dev->vbiq.timeout);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 77ec542..2dadaa6 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -29,9 +29,9 @@
 #include <media/v4l2-fh.h>
 #include <media/tuner.h>
 #include <media/tveeprom.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 #include <media/cx2341x.h>
-#include <media/videobuf-dvb.h>
+#include <media/videobuf2-dvb.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/wm8775.h>
 
@@ -41,7 +41,7 @@
 
 #include <linux/mutex.h>
 
-#define CX88_VERSION "0.0.9"
+#define CX88_VERSION "1.0.0"
 
 #define UNSET (-1U)
 
@@ -95,13 +95,13 @@ enum cx8802_board_access {
 
 static inline unsigned int norm_maxw(v4l2_std_id norm)
 {
-	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
+	return 720;
 }
 
 
 static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
-	return (norm & V4L2_STD_625_50) ? 576 : 480;
+	return (norm & V4L2_STD_525_60) ? 480 : 576;
 }
 
 /* ----------------------------------------------------------- */
@@ -314,7 +314,8 @@ enum cx88_tvaudio {
 /* buffer for one video frame */
 struct cx88_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
+	struct vb2_buffer vb;
+	struct list_head       list;
 
 	/* cx88 specific */
 	unsigned int           bpl;
@@ -324,8 +325,6 @@ struct cx88_buffer {
 
 struct cx88_dmaqueue {
 	struct list_head       active;
-	struct timer_list      timeout;
-	struct btcx_riscmem    stopper;
 	u32                    count;
 };
 
@@ -393,8 +392,6 @@ struct cx88_core {
 	struct mutex               lock;
 	/* various v4l controls */
 	u32                        freq;
-	int                        users;
-	int                        mpeg_users;
 
 	/* cx88-video needs to access cx8802 for hybrid tuner pll access. */
 	struct cx8802_dev          *dvbdev;
@@ -457,18 +454,6 @@ struct cx8802_dev;
 /* ----------------------------------------------------------- */
 /* function 0: video stuff                                     */
 
-struct cx8800_fh {
-	struct v4l2_fh		   fh;
-	struct cx8800_dev          *dev;
-	unsigned int               resources;
-
-	/* video capture */
-	struct videobuf_queue      vidq;
-
-	/* vbi capture */
-	struct videobuf_queue      vbiq;
-};
-
 struct cx8800_suspend_state {
 	int                        disabled;
 };
@@ -489,10 +474,13 @@ struct cx8800_dev {
 
 	const struct cx8800_fmt    *fmt;
 	unsigned int               width, height;
+	unsigned		   field;
 
 	/* capture queues */
 	struct cx88_dmaqueue       vidq;
+	struct vb2_queue           vb2_vidq;
 	struct cx88_dmaqueue       vbiq;
+	struct vb2_queue           vb2_vbiq;
 
 	/* various v4l controls */
 
@@ -508,12 +496,6 @@ struct cx8800_dev {
 /* ----------------------------------------------------------- */
 /* function 2: mpeg stuff                                      */
 
-struct cx8802_fh {
-	struct v4l2_fh		   fh;
-	struct cx8802_dev          *dev;
-	struct videobuf_queue      mpegq;
-};
-
 struct cx8802_suspend_state {
 	int                        disabled;
 };
@@ -557,6 +539,7 @@ struct cx8802_dev {
 
 	/* dma queues */
 	struct cx88_dmaqueue       mpegq;
+	struct vb2_queue           vb2_mpegq;
 	u32                        ts_packet_size;
 	u32                        ts_packet_count;
 
@@ -570,6 +553,7 @@ struct cx8802_dev {
 	u32                        mailbox;
 	int                        width;
 	int                        height;
+	unsigned                   field;
 	unsigned char              mpeg_active; /* nonzero if mpeg encoder is active */
 
 	/* mpeg params */
@@ -578,7 +562,7 @@ struct cx8802_dev {
 
 #if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
 	/* for dvb only */
-	struct videobuf_dvb_frontends frontends;
+	struct vb2_dvb_frontends frontends;
 #endif
 
 #if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
@@ -640,11 +624,8 @@ extern int
 cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 		     struct scatterlist *sglist, unsigned int bpl,
 		     unsigned int lines, unsigned int lpi);
-extern int
-cx88_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
-		  u32 reg, u32 mask, u32 value);
 extern void
-cx88_free_buffer(struct videobuf_queue *q, struct cx88_buffer *buf);
+cx88_free_buffer(struct vb2_queue *q, struct cx88_buffer *buf);
 
 extern void cx88_risc_disasm(struct cx88_core *core,
 			     struct btcx_riscmem *risc);
@@ -662,7 +643,7 @@ extern struct video_device *cx88_vdev_init(struct cx88_core *core,
 					   struct pci_dev *pci,
 					   const struct video_device *template_,
 					   const char *type);
-extern struct cx88_core* cx88_core_get(struct pci_dev *pci);
+extern struct cx88_core *cx88_core_get(struct pci_dev *pci);
 extern void cx88_core_put(struct cx88_core *core,
 			  struct pci_dev *pci);
 
@@ -682,12 +663,10 @@ int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 			 struct cx88_dmaqueue *q,
 			 struct cx88_buffer   *buf);
 */
-int cx8800_stop_vbi_dma(struct cx8800_dev *dev);
-int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
-			     struct cx88_dmaqueue *q);
-void cx8800_vbi_timeout(unsigned long data);
+void cx8800_stop_vbi_dma(struct cx8800_dev *dev);
+int cx8800_restart_vbi_queue(struct cx8800_dev *dev, struct cx88_dmaqueue *q);
 
-extern const struct videobuf_queue_ops cx8800_vbi_qops;
+extern const struct vb2_ops cx8800_vbi_qops;
 
 /* ----------------------------------------------------------- */
 /* cx88-i2c.c                                                  */
@@ -737,14 +716,17 @@ extern void cx88_i2c_init_ir(struct cx88_core *core);
 /* ----------------------------------------------------------- */
 /* cx88-mpeg.c                                                 */
 
-int cx8802_buf_prepare(struct videobuf_queue *q,struct cx8802_dev *dev,
+int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 			struct cx88_buffer *buf, enum v4l2_field field);
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf);
 void cx8802_cancel_buffers(struct cx8802_dev *dev);
+int cx8802_start_dma(struct cx8802_dev    *dev,
+			    struct cx88_dmaqueue *q,
+			    struct cx88_buffer   *buf);
 
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
-int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i);
+int cx88_enum_input(struct cx88_core *core, struct v4l2_input *i);
 int cx88_set_freq(struct cx88_core  *core, const struct v4l2_frequency *f);
 int cx88_video_mux(struct cx88_core *core, unsigned int input);
 void cx88_querycap(struct file *file, struct cx88_core *core,
-- 
2.1.0

