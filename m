Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3937 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2FJKzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 06/11] cx88: move fmt, width and height to cx8800_dev.
Date: Sun, 10 Jun 2012 12:54:52 +0200
Message-Id: <baa93f0f23da11ec870d4672d9c79986c89753e1.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are global properties and do not belong in the filehandle struct.

Note: the overlay related fields were just removed: they weren't used at all.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-video.c |   49 ++++++++++++++++++---------------
 drivers/media/video/cx88/cx88.h       |    9 ++----
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index e5e5510..bd1f52f 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -519,8 +519,9 @@ static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
 	struct cx8800_fh *fh = q->priv_data;
+	struct cx8800_dev  *dev = fh->dev;
 
-	*size = fh->fmt->depth*fh->width*fh->height >> 3;
+	*size = dev->fmt->depth * dev->width * dev->height >> 3;
 	if (0 == *count)
 		*count = 32;
 	if (*size * *count > vid_limit * 1024 * 1024)
@@ -539,21 +540,21 @@ buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 	int rc, init_buffer = 0;
 
-	BUG_ON(NULL == fh->fmt);
-	if (fh->width  < 48 || fh->width  > norm_maxw(core->tvnorm) ||
-	    fh->height < 32 || fh->height > norm_maxh(core->tvnorm))
+	BUG_ON(NULL == dev->fmt);
+	if (dev->width  < 48 || dev->width  > norm_maxw(core->tvnorm) ||
+	    dev->height < 32 || dev->height > norm_maxh(core->tvnorm))
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
@@ -603,7 +604,7 @@ buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	}
 	dprintk(2,"[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
 		buf, buf->vb.i,
-		fh->width, fh->height, fh->fmt->depth, fh->fmt->name,
+		dev->width, dev->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
 
 	buf->vb.state = VIDEOBUF_PREPARED;
@@ -745,9 +746,6 @@ static int video_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev      = dev;
-	fh->width    = 320;
-	fh->height   = 240;
-	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
 	mutex_lock(&core->lock);
 
@@ -1005,15 +1003,17 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct cx8800_fh  *fh   = priv;
+	struct cx8800_dev *dev = fh->dev;
 
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
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	return 0;
 }
 
@@ -1065,13 +1065,14 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct cx8800_fh  *fh   = priv;
+	struct cx8800_dev *dev = fh->dev;
 	int err = vidioc_try_fmt_vid_cap (file,priv,f);
 
 	if (0 != err)
 		return err;
-	fh->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
-	fh->width      = f->fmt.pix.width;
-	fh->height     = f->fmt.pix.height;
+	dev->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
+	dev->width      = f->fmt.pix.width;
+	dev->height     = f->fmt.pix.height;
 	fh->vidq.field = f->fmt.pix.field;
 	return 0;
 }
@@ -1787,6 +1788,10 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	/* Sets device info at pci_dev */
 	pci_set_drvdata(pci_dev, dev);
 
+	dev->width   = 320;
+	dev->height  = 240;
+	dev->fmt     = format_by_fourcc(V4L2_PIX_FMT_BGR24);
+
 	/* initial device configuration */
 	mutex_lock(&core->lock);
 	cx88_set_tvnorm(core, core->tvnorm);
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 1426993..94af48e 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -457,14 +457,7 @@ struct cx8800_fh {
 	struct cx8800_dev          *dev;
 	unsigned int               resources;
 
-	/* video overlay */
-	struct v4l2_window         win;
-	struct v4l2_clip           *clips;
-	unsigned int               nclips;
-
 	/* video capture */
-	const struct cx8800_fmt    *fmt;
-	unsigned int               width,height;
 	struct videobuf_queue      vidq;
 
 	/* vbi capture */
@@ -489,6 +482,8 @@ struct cx8800_dev {
 	struct pci_dev             *pci;
 	unsigned char              pci_rev,pci_lat;
 
+	const struct cx8800_fmt    *fmt;
+	unsigned int               width, height;
 
 	/* capture queues */
 	struct cx88_dmaqueue       vidq;
-- 
1.7.10

