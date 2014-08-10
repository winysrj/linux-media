Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2782 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaHJL6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/19] cx23885: fmt, width and height are global, not per-fh.
Date: Sun, 10 Aug 2014 13:57:49 +0200
Message-Id: <1407671876-39386-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Move these fields from cx23885_fh to cx23885_dev.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 125 +++++++-----------------------
 drivers/media/pci/cx23885/cx23885.h       |   8 +-
 2 files changed, 34 insertions(+), 99 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index a68ab59..3dcee0a 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -77,77 +77,14 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 /* static data                                                         */
 
 #define FORMAT_FLAGS_PACKED       0x01
-#if 0
 static struct cx23885_fmt formats[] = {
 	{
-		.name     = "8 bpp, gray",
-		.fourcc   = V4L2_PIX_FMT_GREY,
-		.depth    = 8,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "15 bpp RGB, le",
-		.fourcc   = V4L2_PIX_FMT_RGB555,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "15 bpp RGB, be",
-		.fourcc   = V4L2_PIX_FMT_RGB555X,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "16 bpp RGB, le",
-		.fourcc   = V4L2_PIX_FMT_RGB565,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "16 bpp RGB, be",
-		.fourcc   = V4L2_PIX_FMT_RGB565X,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "24 bpp RGB, le",
-		.fourcc   = V4L2_PIX_FMT_BGR24,
-		.depth    = 24,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "32 bpp RGB, le",
-		.fourcc   = V4L2_PIX_FMT_BGR32,
-		.depth    = 32,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "32 bpp RGB, be",
-		.fourcc   = V4L2_PIX_FMT_RGB32,
-		.depth    = 32,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "4:2:2, packed, YUYV",
-		.fourcc   = V4L2_PIX_FMT_YUYV,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-		.name     = "4:2:2, packed, UYVY",
-		.fourcc   = V4L2_PIX_FMT_UYVY,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	},
-};
-#else
-static struct cx23885_fmt formats[] = {
-	{
-#if 0
-		.name     = "4:2:2, packed, UYVY",
-		.fourcc   = V4L2_PIX_FMT_UYVY,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	}, {
-#endif
 		.name     = "4:2:2, packed, YUYV",
 		.fourcc   = V4L2_PIX_FMT_YUYV,
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}
 };
-#endif
 
 static struct cx23885_fmt *format_by_fourcc(unsigned int fourcc)
 {
@@ -156,13 +93,6 @@ static struct cx23885_fmt *format_by_fourcc(unsigned int fourcc)
 	for (i = 0; i < ARRAY_SIZE(formats); i++)
 		if (formats[i].fourcc == fourcc)
 			return formats+i;
-
-	printk(KERN_ERR "%s(%c%c%c%c) NOT FOUND\n", __func__,
-		(fourcc & 0xff),
-		((fourcc >> 8) & 0xff),
-		((fourcc >> 16) & 0xff),
-		((fourcc >> 24) & 0xff)
-		);
 	return NULL;
 }
 
@@ -502,8 +432,9 @@ static int buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	unsigned int *size)
 {
 	struct cx23885_fh *fh = q->priv_data;
+	struct cx23885_dev *dev = fh->dev;
 
-	*size = fh->fmt->depth*fh->width*fh->height >> 3;
+	*size = (dev->fmt->depth * dev->width * dev->height) >> 3;
 	if (0 == *count)
 		*count = 32;
 	if (*size * *count > vid_limit * 1024 * 1024)
@@ -523,21 +454,23 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int field_tff;
 
-	BUG_ON(NULL == fh->fmt);
-	if (fh->width  < 48 || fh->width  > norm_maxw(dev->tvnorm) ||
-	    fh->height < 32 || fh->height > norm_maxh(dev->tvnorm))
+	if (WARN_ON(NULL == dev->fmt))
+		return -EINVAL;
+
+	if (dev->width  < 48 || dev->width  > norm_maxw(dev->tvnorm) ||
+	    dev->height < 32 || dev->height > norm_maxh(dev->tvnorm))
 		return -EINVAL;
-	buf->vb.size = (fh->width * fh->height * fh->fmt->depth) >> 3;
+	buf->vb.size = (dev->width * dev->height * dev->fmt->depth) >> 3;
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
 		return -EINVAL;
 
-	if (buf->fmt       != fh->fmt    ||
-	    buf->vb.width  != fh->width  ||
-	    buf->vb.height != fh->height ||
+	if (buf->fmt       != dev->fmt    ||
+	    buf->vb.width  != dev->width  ||
+	    buf->vb.height != dev->height ||
 	    buf->vb.field  != field) {
-		buf->fmt       = fh->fmt;
-		buf->vb.width  = fh->width;
-		buf->vb.height = fh->height;
+		buf->fmt       = dev->fmt;
+		buf->vb.width  = dev->width;
+		buf->vb.height = dev->height;
 		buf->vb.field  = field;
 		init_buffer = 1;
 	}
@@ -612,7 +545,7 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	}
 	dprintk(2, "[%p/%d] buffer_prep - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
 		buf, buf->vb.i,
-		fh->width, fh->height, fh->fmt->depth, fh->fmt->name,
+		dev->width, dev->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
 
 	buf->vb.state = VIDEOBUF_PREPARED;
@@ -738,9 +671,6 @@ static int video_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = &fh->fh;
 	fh->dev      = dev;
-	fh->width    = 320;
-	fh->height   = 240;
-	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_YUYV);
 
 	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
 			    &dev->pci->dev, &dev->slock,
@@ -887,13 +817,14 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_format *f)
 {
 	struct cx23885_fh *fh   = priv;
+	struct cx23885_dev *dev = fh->dev;
 
-	f->fmt.pix.width        = fh->width;
-	f->fmt.pix.height       = fh->height;
+	f->fmt.pix.width        = dev->width;
+	f->fmt.pix.height       = dev->height;
 	f->fmt.pix.field        = fh->vidq.field;
-	f->fmt.pix.pixelformat  = fh->fmt->fourcc;
+	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
-		(f->fmt.pix.width * fh->fmt->depth) >> 3;
+		(f->fmt.pix.width * dev->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
@@ -951,7 +882,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_format *f)
 {
 	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev  = fh->dev;
 	struct v4l2_mbus_framefmt mbus_fmt;
 	int err;
 
@@ -960,12 +891,12 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	if (0 != err)
 		return err;
-	fh->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
-	fh->width      = f->fmt.pix.width;
-	fh->height     = f->fmt.pix.height;
+	dev->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
+	dev->width      = f->fmt.pix.width;
+	dev->height     = f->fmt.pix.height;
 	fh->vidq.field = f->fmt.pix.field;
 	dprintk(2, "%s() width=%d height=%d field=%d\n", __func__,
-		fh->width, fh->height, fh->vidq.field);
+		dev->width, dev->height, fh->vidq.field);
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
 	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
@@ -976,7 +907,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct v4l2_capability *cap)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_fh *fh = priv;
+	struct cx23885_dev *dev = fh->dev;
 
 	strcpy(cap->driver, "cx23885");
 	strlcpy(cap->card, cx23885_boards[dev->board].name,
@@ -1619,6 +1551,9 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	strcpy(cx23885_vbi_template.name, "cx23885-vbi");
 
 	dev->tvnorm = V4L2_STD_NTSC_M;
+	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
+	dev->width = norm_maxw(dev->tvnorm);
+	dev->height = norm_maxh(dev->tvnorm);
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index a88e951..260d177 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -145,10 +145,6 @@ struct cx23885_fh {
 	struct cx23885_dev         *dev;
 	u32                        resources;
 
-	/* video capture */
-	struct cx23885_fmt         *fmt;
-	unsigned int               width, height;
-
 	/* vbi capture */
 	struct videobuf_queue      vidq;
 	struct videobuf_queue      vbiq;
@@ -424,6 +420,10 @@ struct cx23885_dev {
 	struct video_device        *video_dev;
 	struct video_device        *vbi_dev;
 
+	/* video capture */
+	struct cx23885_fmt         *fmt;
+	unsigned int               width, height;
+
 	struct cx23885_dmaqueue    vidq;
 	struct cx23885_dmaqueue    vbiq;
 	spinlock_t                 slock;
-- 
2.0.1

