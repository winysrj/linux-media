Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2611 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbaITMmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/16] cx88: move width, height and field to core struct
Date: Sat, 20 Sep 2014 14:41:46 +0200
Message-Id: <1411216911-7950-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The width, height and field values are core fields since both vbi, video
and blackbird use the same video input.

Move those fields to the correct struct.

Also fix the field checks in the try_fmt functions: add V4L2_FIELD_SEQ_BT/TB
support and map incorrect field values to a correct field value instead of
returning an error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 85 +++++++++++++++++++--------------
 drivers/media/pci/cx88/cx88-cards.c     |  5 ++
 drivers/media/pci/cx88/cx88-dvb.c       |  2 +-
 drivers/media/pci/cx88/cx88-mpeg.c      |  4 +-
 drivers/media/pci/cx88/cx88-video.c     | 75 ++++++++++++++---------------
 drivers/media/pci/cx88/cx88.h           |  9 ++--
 6 files changed, 98 insertions(+), 82 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 32fb935..58e5254 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -515,12 +515,14 @@ DB* DVD | MPEG2 | 720x576PAL | CBR     | 600 :Good    | 6000 Kbps  | 25fps   | M
 
 static void blackbird_codec_settings(struct cx8802_dev *dev)
 {
+	struct cx88_core *core = dev->core;
+
 	/* assign frame size */
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
-				dev->height, dev->width);
+				core->height, core->width);
 
-	dev->cxhdl.width = dev->width;
-	dev->cxhdl.height = dev->height;
+	dev->cxhdl.width = core->width;
+	dev->cxhdl.height = core->height;
 	cx2341x_handler_set_50hz(&dev->cxhdl, dev->core->tvnorm & V4L2_STD_625_50);
 	cx2341x_handler_setup(&dev->cxhdl);
 }
@@ -658,7 +660,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 
-	return cx8802_buf_prepare(vb->vb2_queue, dev, buf, dev->field);
+	return cx8802_buf_prepare(vb->vb2_queue, dev, buf);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
@@ -796,55 +798,75 @@ static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_g_fmt_vid_cap (struct file *file, void *priv,
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
 	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.width        = dev->width;
-	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = dev->field;
-	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d, f: %d\n",
-		dev->width, dev->height, dev->field);
+	f->fmt.pix.width        = core->width;
+	f->fmt.pix.height       = core->height;
+	f->fmt.pix.field        = core->field;
 	return 0;
 }
 
-static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
+	unsigned maxw, maxh;
+	enum v4l2_field field;
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
 	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
-	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
-		dev->width, dev->height, dev->field);
+
+	maxw = norm_maxw(core->tvnorm);
+	maxh = norm_maxh(core->tvnorm);
+
+	field = f->fmt.pix.field;
+
+	switch (field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_SEQ_BT:
+	case V4L2_FIELD_SEQ_TB:
+		break;
+	default:
+		field = (f->fmt.pix.height > maxh / 2)
+			? V4L2_FIELD_INTERLACED
+			: V4L2_FIELD_BOTTOM;
+		break;
+	}
+	if (V4L2_FIELD_HAS_T_OR_B(field))
+		maxh /= 2;
+
+	v4l_bound_align_image(&f->fmt.pix.width, 48, maxw, 2,
+			      &f->fmt.pix.height, 32, maxh, 0, 0);
+	f->fmt.pix.field = field;
 	return 0;
 }
 
-static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core  *core = dev->core;
 
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
-	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count;
-	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
-	dev->width              = f->fmt.pix.width;
-	dev->height             = f->fmt.pix.height;
-	dev->field         = f->fmt.pix.field;
+	vidioc_try_fmt_vid_cap(file, priv, f);
+	core->width = f->fmt.pix.width;
+	core->height = f->fmt.pix.height;
+	core->field = f->fmt.pix.field;
 	cx88_set_scale(core, f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
 				f->fmt.pix.height, f->fmt.pix.width);
-	dprintk(1, "VIDIOC_S_FMT: w: %d, h: %d, f: %d\n",
-		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field );
 	return 0;
 }
 
@@ -863,8 +885,8 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 
 	cx88_set_freq (core,f);
 	blackbird_initialize_codec(dev);
-	cx88_set_scale(dev->core, dev->width, dev->height,
-			dev->field);
+	cx88_set_scale(core, core->width, core->height,
+			core->field);
 	return 0;
 }
 
@@ -1128,16 +1150,9 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	if (!(core->board.mpeg & CX88_MPEG_BLACKBIRD))
 		goto fail_core;
 
-	dev->width = 720;
-	if (core->tvnorm & V4L2_STD_525_60) {
-		dev->height = 480;
-	} else {
-		dev->height = 576;
-	}
-	dev->field = V4L2_FIELD_INTERLACED;
 	dev->cxhdl.port = CX2341X_PORT_STREAMING;
-	dev->cxhdl.width = dev->width;
-	dev->cxhdl.height = dev->height;
+	dev->cxhdl.width = core->width;
+	dev->cxhdl.height = core->height;
 	dev->cxhdl.func = blackbird_mbox_func;
 	dev->cxhdl.priv = dev;
 	err = cx2341x_handler_init(&dev->cxhdl, 36);
@@ -1156,7 +1171,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 //	init_controls(core);
 	cx88_set_tvnorm(core,core->tvnorm);
 	cx88_video_mux(core,0);
-	cx2341x_handler_set_50hz(&dev->cxhdl, dev->height == 576);
+	cx2341x_handler_set_50hz(&dev->cxhdl, core->height == 576);
 	cx2341x_handler_setup(&dev->cxhdl);
 
 	q = &dev->vb2_mpegq;
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index e18a7ac..eb72185 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3691,6 +3691,11 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	core->nr = nr;
 	sprintf(core->name, "cx88[%d]", core->nr);
 
+	core->tvnorm = V4L2_STD_NTSC_M;
+	core->width   = 320;
+	core->height  = 240;
+	core->field   = V4L2_FIELD_INTERLACED;
+
 	strcpy(core->v4l2_dev.name, core->name);
 	if (v4l2_device_register(NULL, &core->v4l2_dev)) {
 		kfree(core);
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index dd0deb1..c344bfd 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -101,7 +101,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 
-	return cx8802_buf_prepare(vb->vb2_queue, dev, buf, dev->field);
+	return cx8802_buf_prepare(vb->vb2_queue, dev, buf);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 746c0ea..f181a3a 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -93,7 +93,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 	struct cx88_core *core = dev->core;
 
 	dprintk(1, "cx8802_start_dma w: %d, h: %d, f: %d\n",
-		dev->width, dev->height, dev->field);
+		core->width, core->height, core->field);
 
 	/* setup fifo + format */
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH28],
@@ -224,7 +224,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 /* ------------------------------------------------------------------ */
 
 int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
-			struct cx88_buffer *buf, enum v4l2_field field)
+			struct cx88_buffer *buf)
 {
 	int size = dev->ts_packet_size * dev->ts_packet_count;
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 85c3d0c..eadceeb 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -365,7 +365,7 @@ static int start_video_dma(struct cx8800_dev    *dev,
 	/* setup fifo + format */
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH21],
 				buf->bpl, buf->risc.dma);
-	cx88_set_scale(core, dev->width, dev->height, dev->field);
+	cx88_set_scale(core, core->width, core->height, core->field);
 	cx_write(MO_COLOR_CTRL, dev->fmt->cxformat | ColorFormatGamma);
 
 	/* reset counter */
@@ -436,9 +436,10 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct cx8800_dev *dev = q->drv_priv;
+	struct cx88_core *core = dev->core;
 
 	*num_planes = 1;
-	sizes[0] = (dev->fmt->depth * dev->width * dev->height) >> 3;
+	sizes[0] = (dev->fmt->depth * core->width * core->height) >> 3;
 	return 0;
 }
 
@@ -450,52 +451,52 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	int rc;
 
-	buf->bpl = dev->width * dev->fmt->depth >> 3;
+	buf->bpl = core->width * dev->fmt->depth >> 3;
 
-	if (vb2_plane_size(vb, 0) < dev->height * buf->bpl)
+	if (vb2_plane_size(vb, 0) < core->height * buf->bpl)
 		return -EINVAL;
-	vb2_set_plane_payload(vb, 0, dev->height * buf->bpl);
+	vb2_set_plane_payload(vb, 0, core->height * buf->bpl);
 
 	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 	if (!rc)
 		return -EIO;
 
-	switch (dev->field) {
+	switch (core->field) {
 	case V4L2_FIELD_TOP:
 		cx88_risc_buffer(dev->pci, &buf->risc,
 				 sgt->sgl, 0, UNSET,
-				 buf->bpl, 0, dev->height);
+				 buf->bpl, 0, core->height);
 		break;
 	case V4L2_FIELD_BOTTOM:
 		cx88_risc_buffer(dev->pci, &buf->risc,
 				 sgt->sgl, UNSET, 0,
-				 buf->bpl, 0, dev->height);
+				 buf->bpl, 0, core->height);
 		break;
 	case V4L2_FIELD_SEQ_TB:
 		cx88_risc_buffer(dev->pci, &buf->risc,
 				 sgt->sgl,
-				 0, buf->bpl * (dev->height >> 1),
+				 0, buf->bpl * (core->height >> 1),
 				 buf->bpl, 0,
-				 dev->height >> 1);
+				 core->height >> 1);
 		break;
 	case V4L2_FIELD_SEQ_BT:
 		cx88_risc_buffer(dev->pci, &buf->risc,
 				 sgt->sgl,
-				 buf->bpl * (dev->height >> 1), 0,
+				 buf->bpl * (core->height >> 1), 0,
 				 buf->bpl, 0,
-				 dev->height >> 1);
+				 core->height >> 1);
 		break;
 	case V4L2_FIELD_INTERLACED:
 	default:
 		cx88_risc_buffer(dev->pci, &buf->risc,
 				 sgt->sgl, 0, buf->bpl,
 				 buf->bpl, buf->bpl,
-				 dev->height >> 1);
+				 core->height >> 1);
 		break;
 	}
 	dprintk(2,"[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
 		buf, buf->vb.v4l2_buf.index,
-		dev->width, dev->height, dev->fmt->depth, dev->fmt->name,
+		core->width, core->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
 	return 0;
 }
@@ -723,10 +724,11 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 
-	f->fmt.pix.width        = dev->width;
-	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = dev->field;
+	f->fmt.pix.width        = core->width;
+	f->fmt.pix.height       = core->height;
+	f->fmt.pix.field        = core->field;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
@@ -749,30 +751,30 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	if (NULL == fmt)
 		return -EINVAL;
 
-	field = f->fmt.pix.field;
-	maxw  = norm_maxw(core->tvnorm);
-	maxh  = norm_maxh(core->tvnorm);
+	maxw = norm_maxw(core->tvnorm);
+	maxh = norm_maxh(core->tvnorm);
 
-	if (V4L2_FIELD_ANY == field) {
-		field = (f->fmt.pix.height > maxh/2)
-			? V4L2_FIELD_INTERLACED
-			: V4L2_FIELD_BOTTOM;
-	}
+	field = f->fmt.pix.field;
 
 	switch (field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
-		maxh = maxh / 2;
-		break;
 	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_SEQ_BT:
+	case V4L2_FIELD_SEQ_TB:
 		break;
 	default:
-		return -EINVAL;
+		field = (f->fmt.pix.height > maxh / 2)
+			? V4L2_FIELD_INTERLACED
+			: V4L2_FIELD_BOTTOM;
+		break;
 	}
+	if (V4L2_FIELD_HAS_T_OR_B(field))
+		maxh /= 2;
 
-	f->fmt.pix.field = field;
 	v4l_bound_align_image(&f->fmt.pix.width, 48, maxw, 2,
 			      &f->fmt.pix.height, 32, maxh, 0, 0);
+	f->fmt.pix.field = field;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
@@ -785,14 +787,15 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
+	struct cx88_core *core = dev->core;
 	int err = vidioc_try_fmt_vid_cap (file,priv,f);
 
 	if (0 != err)
 		return err;
-	dev->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
-	dev->width      = f->fmt.pix.width;
-	dev->height     = f->fmt.pix.height;
-	dev->field = f->fmt.pix.field;
+	dev->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
+	core->width = f->fmt.pix.width;
+	core->height = f->fmt.pix.height;
+	core->field = f->fmt.pix.field;
 	return 0;
 }
 
@@ -1343,7 +1346,6 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* initialize driver struct */
 	spin_lock_init(&dev->slock);
-	core->tvnorm = V4L2_STD_NTSC_M;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
@@ -1438,10 +1440,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	/* Sets device info at pci_dev */
 	pci_set_drvdata(pci_dev, dev);
 
-	dev->width   = 320;
-	dev->height  = 240;
-	dev->field   = V4L2_FIELD_INTERLACED;
-	dev->fmt     = format_by_fourcc(V4L2_PIX_FMT_BGR24);
+	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
 	/* initial device configuration */
 	mutex_lock(&core->lock);
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index dd50177..862c609 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -379,6 +379,8 @@ struct cx88_core {
 	/* state info */
 	struct task_struct         *kthread;
 	v4l2_std_id                tvnorm;
+	unsigned		   width, height;
+	unsigned		   field;
 	enum cx88_tvaudio          tvaudio;
 	u32                        audiomode_manual;
 	u32                        audiomode_current;
@@ -479,8 +481,6 @@ struct cx8800_dev {
 	unsigned char              pci_rev,pci_lat;
 
 	const struct cx8800_fmt    *fmt;
-	unsigned int               width, height;
-	unsigned		   field;
 
 	/* capture queues */
 	struct cx88_dmaqueue       vidq;
@@ -557,9 +557,6 @@ struct cx8802_dev {
 #if IS_ENABLED(CONFIG_VIDEO_CX88_BLACKBIRD)
 	struct video_device        *mpeg_dev;
 	u32                        mailbox;
-	int                        width;
-	int                        height;
-	unsigned                   field;
 	unsigned char              mpeg_active; /* nonzero if mpeg encoder is active */
 
 	/* mpeg params */
@@ -721,7 +718,7 @@ extern void cx88_i2c_init_ir(struct cx88_core *core);
 /* cx88-mpeg.c                                                 */
 
 int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
-			struct cx88_buffer *buf, enum v4l2_field field);
+			struct cx88_buffer *buf);
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf);
 void cx8802_cancel_buffers(struct cx8802_dev *dev);
 int cx8802_start_dma(struct cx8802_dev    *dev,
-- 
2.1.0

