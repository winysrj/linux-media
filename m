Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3990 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3FBK4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/16] saa7134: move fmt/width/height from saa7134_fh to saa7134_dev
Date: Sun,  2 Jun 2013 12:55:54 +0200
Message-Id: <1370170567-7004-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These fields are global, not per-filehandle.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |   57 +++++++++++++++--------------
 drivers/media/pci/saa7134/saa7134.h       |    4 +-
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index f7662a5..9c45dd9 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1024,38 +1024,38 @@ static int buffer_prepare(struct videobuf_queue *q,
 	int err;
 
 	/* sanity checks */
-	if (NULL == fh->fmt)
+	if (NULL == dev->fmt)
 		return -EINVAL;
-	if (fh->width    < 48 ||
-	    fh->height   < 32 ||
-	    fh->width/4  > dev->crop_current.width  ||
-	    fh->height/4 > dev->crop_current.height ||
-	    fh->width    > dev->crop_bounds.width  ||
-	    fh->height   > dev->crop_bounds.height)
+	if (dev->width    < 48 ||
+	    dev->height   < 32 ||
+	    dev->width/4  > dev->crop_current.width  ||
+	    dev->height/4 > dev->crop_current.height ||
+	    dev->width    > dev->crop_bounds.width  ||
+	    dev->height   > dev->crop_bounds.height)
 		return -EINVAL;
-	size = (fh->width * fh->height * fh->fmt->depth) >> 3;
+	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
 
 	dprintk("buffer_prepare [%d,size=%dx%d,bytes=%d,fields=%s,%s]\n",
-		vb->i,fh->width,fh->height,size,v4l2_field_names[field],
-		fh->fmt->name);
-	if (buf->vb.width  != fh->width  ||
-	    buf->vb.height != fh->height ||
+		vb->i, dev->width, dev->height, size, v4l2_field_names[field],
+		dev->fmt->name);
+	if (buf->vb.width  != dev->width  ||
+	    buf->vb.height != dev->height ||
 	    buf->vb.size   != size       ||
 	    buf->vb.field  != field      ||
-	    buf->fmt       != fh->fmt) {
+	    buf->fmt       != dev->fmt) {
 		saa7134_dma_free(q,buf);
 	}
 
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
 		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 
-		buf->vb.width  = fh->width;
-		buf->vb.height = fh->height;
+		buf->vb.width  = dev->width;
+		buf->vb.height = dev->height;
 		buf->vb.size   = size;
 		buf->vb.field  = field;
-		buf->fmt       = fh->fmt;
+		buf->fmt       = dev->fmt;
 		buf->pt        = &fh->pt_cap;
 		dev->video_q.curr = NULL;
 
@@ -1082,8 +1082,9 @@ static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
 	struct saa7134_fh *fh = q->priv_data;
+	struct saa7134_dev *dev = fh->dev;
 
-	*size = fh->fmt->depth * fh->width * fh->height >> 3;
+	*size = dev->fmt->depth * dev->width * dev->height >> 3;
 	if (0 == *count)
 		*count = gbuffers;
 	*count = saa7134_buffer_count(*size,*count);
@@ -1334,9 +1335,6 @@ static int video_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev      = dev;
-	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
-	fh->width    = 720;
-	fh->height   = 576;
 
 	videobuf_queue_sg_init(&fh->cap, &video_qops,
 			    &dev->pci->dev, &dev->slock,
@@ -1556,13 +1554,14 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7134_fh *fh = priv;
+	struct saa7134_dev *dev = fh->dev;
 
-	f->fmt.pix.width        = fh->width;
-	f->fmt.pix.height       = fh->height;
+	f->fmt.pix.width        = dev->width;
+	f->fmt.pix.height       = dev->height;
 	f->fmt.pix.field        = fh->cap.field;
-	f->fmt.pix.pixelformat  = fh->fmt->fourcc;
+	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
-		(f->fmt.pix.width * fh->fmt->depth) >> 3;
+		(f->fmt.pix.width * dev->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
 	return 0;
@@ -1652,15 +1651,16 @@ static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct saa7134_fh *fh = priv;
+	struct saa7134_dev *dev = fh->dev;
 	int err;
 
 	err = saa7134_try_fmt_vid_cap(file, priv, f);
 	if (0 != err)
 		return err;
 
-	fh->fmt       = format_by_fourcc(f->fmt.pix.pixelformat);
-	fh->width     = f->fmt.pix.width;
-	fh->height    = f->fmt.pix.height;
+	dev->fmt       = format_by_fourcc(f->fmt.pix.pixelformat);
+	dev->width     = f->fmt.pix.width;
+	dev->height    = f->fmt.pix.height;
 	fh->cap.field = f->fmt.pix.field;
 	return 0;
 }
@@ -2456,6 +2456,9 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	dev->video_q.timeout.function = saa7134_buffer_timeout;
 	dev->video_q.timeout.data     = (unsigned long)(&dev->video_q);
 	dev->video_q.dev              = dev;
+	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_BGR24);
+	dev->width    = 720;
+	dev->height   = 576;
 
 	if (saa7134_boards[dev->board].video_out)
 		saa7134_videoport_init(dev);
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index fa21d14..8a62ff7 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -475,8 +475,6 @@ struct saa7134_fh {
 	struct pm_qos_request	   qos_request;
 
 	/* video capture */
-	struct saa7134_format      *fmt;
-	unsigned int               width,height;
 	struct videobuf_queue      cap;
 	struct saa7134_pgtable     pt_cap;
 
@@ -595,6 +593,8 @@ struct saa7134_dev {
 	struct saa7134_dmaqueue    vbi_q;
 	unsigned int               video_fieldcount;
 	unsigned int               vbi_fieldcount;
+	struct saa7134_format      *fmt;
+	unsigned int               width, height;
 
 	/* various v4l controls */
 	struct saa7134_tvnorm      *tvnorm;              /* video */
-- 
1.7.10.4

