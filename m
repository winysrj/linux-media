Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1271 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab2EKHzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 08/16] saa7146: move video_fmt from saa7146_fh to saa7146_vv.
Date: Fri, 11 May 2012 09:55:02 +0200
Message-Id: <feb5f2e73b9ff3f9f5444c15483f6f8ea128f93e.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is a global structure and does not belong to saa7146_fh.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c  |   10 ++++++
 drivers/media/common/saa7146_video.c |   62 +++++++++++++++-------------------
 include/media/saa7146_vv.h           |    2 +-
 3 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 05818ec..bb25573 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -504,6 +504,16 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	fmt->bytesperline = 2 * fmt->width;
 	fmt->sizeimage = fmt->bytesperline * fmt->height;
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt = &vv->video_fmt;
+	fmt->width = 384;
+	fmt->height = 288;
+	fmt->pixelformat = V4L2_PIX_FMT_BGR24;
+	fmt->field = V4L2_FIELD_ANY;
+	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	fmt->bytesperline = 3 * fmt->width;
+	fmt->sizeimage = fmt->bytesperline * fmt->height;
+
 	vv->ov_fb.capability = V4L2_FBUF_CAP_LIST_CLIPPING;
 	vv->ov_fb.flags = V4L2_FBUF_FLAG_PRIMARY;
 	dev->vv_data = vv;
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index e1b639b..f57dccf 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -353,7 +353,7 @@ static int video_begin(struct saa7146_fh *fh)
 		}
 	}
 
-	fmt = saa7146_format_by_fourcc(dev,fh->video_fmt.pixelformat);
+	fmt = saa7146_format_by_fourcc(dev, vv->video_fmt.pixelformat);
 	/* we need to have a valid format set here */
 	BUG_ON(NULL == fmt);
 
@@ -405,7 +405,7 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 		return -EBUSY;
 	}
 
-	fmt = saa7146_format_by_fourcc(dev,fh->video_fmt.pixelformat);
+	fmt = saa7146_format_by_fourcc(dev, vv->video_fmt.pixelformat);
 	/* we need to have a valid format set here */
 	BUG_ON(NULL == fmt);
 
@@ -595,7 +595,10 @@ static int vidioc_g_parm(struct file *file, void *fh,
 
 static int vidioc_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f)
 {
-	f->fmt.pix = ((struct saa7146_fh *)fh)->video_fmt;
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct saa7146_vv *vv = dev->vv_data;
+
+	f->fmt.pix = vv->video_fmt;
 	return 0;
 }
 
@@ -754,9 +757,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *__fh, struct v4l2_forma
 	err = vidioc_try_fmt_vid_cap(file, fh, f);
 	if (0 != err)
 		return err;
-	fh->video_fmt = f->fmt.pix;
+	vv->video_fmt = f->fmt.pix;
 	DEB_EE("set to pixelformat '%4.4s'\n",
-	       (char *)&fh->video_fmt.pixelformat);
+	       (char *)&vv->video_fmt.pixelformat);
 	return 0;
 }
 
@@ -1053,44 +1056,44 @@ static int buffer_prepare(struct videobuf_queue *q,
 	DEB_CAP("vbuf:%p\n", vb);
 
 	/* sanity checks */
-	if (fh->video_fmt.width  < 48 ||
-	    fh->video_fmt.height < 32 ||
-	    fh->video_fmt.width  > vv->standard->h_max_out ||
-	    fh->video_fmt.height > vv->standard->v_max_out) {
+	if (vv->video_fmt.width  < 48 ||
+	    vv->video_fmt.height < 32 ||
+	    vv->video_fmt.width  > vv->standard->h_max_out ||
+	    vv->video_fmt.height > vv->standard->v_max_out) {
 		DEB_D("w (%d) / h (%d) out of bounds\n",
-		      fh->video_fmt.width, fh->video_fmt.height);
+		      vv->video_fmt.width, vv->video_fmt.height);
 		return -EINVAL;
 	}
 
-	size = fh->video_fmt.sizeimage;
+	size = vv->video_fmt.sizeimage;
 	if (0 != buf->vb.baddr && buf->vb.bsize < size) {
 		DEB_D("size mismatch\n");
 		return -EINVAL;
 	}
 
 	DEB_CAP("buffer_prepare [size=%dx%d,bytes=%d,fields=%s]\n",
-		fh->video_fmt.width, fh->video_fmt.height,
-		size, v4l2_field_names[fh->video_fmt.field]);
-	if (buf->vb.width  != fh->video_fmt.width  ||
-	    buf->vb.bytesperline != fh->video_fmt.bytesperline ||
-	    buf->vb.height != fh->video_fmt.height ||
+		vv->video_fmt.width, vv->video_fmt.height,
+		size, v4l2_field_names[vv->video_fmt.field]);
+	if (buf->vb.width  != vv->video_fmt.width  ||
+	    buf->vb.bytesperline != vv->video_fmt.bytesperline ||
+	    buf->vb.height != vv->video_fmt.height ||
 	    buf->vb.size   != size ||
 	    buf->vb.field  != field      ||
-	    buf->vb.field  != fh->video_fmt.field  ||
-	    buf->fmt       != &fh->video_fmt) {
+	    buf->vb.field  != vv->video_fmt.field  ||
+	    buf->fmt       != &vv->video_fmt) {
 		saa7146_dma_free(dev,q,buf);
 	}
 
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
 		struct saa7146_format *sfmt;
 
-		buf->vb.bytesperline  = fh->video_fmt.bytesperline;
-		buf->vb.width  = fh->video_fmt.width;
-		buf->vb.height = fh->video_fmt.height;
+		buf->vb.bytesperline  = vv->video_fmt.bytesperline;
+		buf->vb.width  = vv->video_fmt.width;
+		buf->vb.height = vv->video_fmt.height;
 		buf->vb.size   = size;
 		buf->vb.field  = field;
-		buf->fmt       = &fh->video_fmt;
-		buf->vb.field  = fh->video_fmt.field;
+		buf->fmt       = &vv->video_fmt;
+		buf->vb.field  = vv->video_fmt.field;
 
 		sfmt = saa7146_format_by_fourcc(dev,buf->fmt->pixelformat);
 
@@ -1126,11 +1129,12 @@ static int buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned
 {
 	struct file *file = q->priv_data;
 	struct saa7146_fh *fh = file->private_data;
+	struct saa7146_vv *vv = fh->dev->vv_data;
 
 	if (0 == *count || *count > MAX_SAA7146_CAPTURE_BUFFERS)
 		*count = MAX_SAA7146_CAPTURE_BUFFERS;
 
-	*size = fh->video_fmt.sizeimage;
+	*size = vv->video_fmt.sizeimage;
 
 	/* check if we exceed the "max_memory" parameter */
 	if( (*count * *size) > (max_memory*1048576) ) {
@@ -1199,16 +1203,6 @@ static void video_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 static int video_open(struct saa7146_dev *dev, struct file *file)
 {
 	struct saa7146_fh *fh = file->private_data;
-	struct saa7146_format *sfmt;
-
-	fh->video_fmt.width = 384;
-	fh->video_fmt.height = 288;
-	fh->video_fmt.pixelformat = V4L2_PIX_FMT_BGR24;
-	fh->video_fmt.bytesperline = 0;
-	fh->video_fmt.field = V4L2_FIELD_ANY;
-	fh->video_fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	sfmt = saa7146_format_by_fourcc(dev,fh->video_fmt.pixelformat);
-	fh->video_fmt.sizeimage = (fh->video_fmt.width * fh->video_fmt.height * sfmt->depth)/8;
 
 	videobuf_queue_sg_init(&fh->video_q, &video_qops,
 			    &dev->pci->dev, &dev->slock,
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index feb444b..7f61645 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -90,7 +90,6 @@ struct saa7146_fh {
 
 	/* video capture */
 	struct videobuf_queue	video_q;
-	struct v4l2_pix_format	video_fmt;
 
 	/* vbi capture */
 	struct videobuf_queue	vbi_q;
@@ -123,6 +122,7 @@ struct saa7146_vv
 
 	/* video capture */
 	struct saa7146_dmaqueue		video_q;
+	struct v4l2_pix_format		video_fmt;
 	enum v4l2_field			last_field;
 
 	/* common: fixme? shouldn't this be in saa7146_fh?
-- 
1.7.10

