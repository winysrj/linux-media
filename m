Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2249 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3FBK4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/16] saa7134: move the queue data from saa7134_fh to saa7134_dev.
Date: Sun,  2 Jun 2013 12:55:56 +0200
Message-Id: <1370170567-7004-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These fields are global, not per-filehandle.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-core.c  |    1 +
 drivers/media/pci/saa7134/saa7134-vbi.c   |   11 ++--
 drivers/media/pci/saa7134/saa7134-video.c |  102 +++++++++++++++--------------
 drivers/media/pci/saa7134/saa7134.h       |   13 ++--
 4 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 45f0aca..e256f4a 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -751,6 +751,7 @@ static int saa7134_hwfini(struct saa7134_dev *dev)
 	saa7134_input_fini(dev);
 	saa7134_vbi_fini(dev);
 	saa7134_tvaudio_fini(dev);
+	saa7134_video_fini(dev);
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index e9aa94b..d4da18d 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -117,8 +117,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 			  struct videobuf_buffer *vb,
 			  enum v4l2_field field)
 {
-	struct saa7134_fh *fh   = q->priv_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	struct saa7134_tvnorm *norm = dev->tvnorm;
 	unsigned int lines, llength, size;
@@ -141,7 +140,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 		buf->vb.width  = llength;
 		buf->vb.height = lines;
 		buf->vb.size   = size;
-		buf->pt        = &fh->pt_vbi;
+		buf->pt        = &dev->pt_vbi;
 
 		err = videobuf_iolock(q,&buf->vb,NULL);
 		if (err)
@@ -166,8 +165,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
-	struct saa7134_fh *fh   = q->priv_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = q->priv_data;
 	int llength,lines;
 
 	lines   = dev->tvnorm->vbi_v_stop_0 - dev->tvnorm->vbi_v_start_0 +1;
@@ -181,8 +179,7 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 
 static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
-	struct saa7134_fh *fh = q->priv_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 
 	saa7134_buffer_queue(dev,&dev->vbi_q,buf);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 2f6ba71..9465a1d 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1017,8 +1017,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 			  struct videobuf_buffer *vb,
 			  enum v4l2_field field)
 {
-	struct saa7134_fh *fh = q->priv_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 	unsigned int size;
 	int err;
@@ -1056,7 +1055,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 		buf->vb.size   = size;
 		buf->vb.field  = field;
 		buf->fmt       = dev->fmt;
-		buf->pt        = &fh->pt_cap;
+		buf->pt        = &dev->pt_cap;
 		dev->video_q.curr = NULL;
 
 		err = videobuf_iolock(q,&buf->vb,&dev->ovbuf);
@@ -1081,8 +1080,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
-	struct saa7134_fh *fh = q->priv_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = q->priv_data;
 
 	*size = dev->fmt->depth * dev->width * dev->height >> 3;
 	if (0 == *count)
@@ -1093,10 +1091,10 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 
 static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
-	struct saa7134_fh *fh = q->priv_data;
+	struct saa7134_dev *dev = q->priv_data;
 	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
 
-	saa7134_buffer_queue(fh->dev,&fh->dev->video_q,buf);
+	saa7134_buffer_queue(dev, &dev->video_q, buf);
 }
 
 static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
@@ -1292,14 +1290,15 @@ static struct videobuf_queue *saa7134_queue(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_fh *fh = file->private_data;
+	struct saa7134_dev *dev = fh->dev;
 	struct videobuf_queue *q = NULL;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
-		q = &fh->cap;
+		q = &dev->cap;
 		break;
 	case VFL_TYPE_VBI:
-		q = &fh->vbi;
+		q = &dev->vbi;
 		break;
 	default:
 		BUG();
@@ -1336,21 +1335,6 @@ static int video_open(struct file *file)
 	file->private_data = fh;
 	fh->dev      = dev;
 
-	videobuf_queue_sg_init(&fh->cap, &video_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			    V4L2_FIELD_INTERLACED,
-			    sizeof(struct saa7134_buf),
-			    fh, NULL);
-	videobuf_queue_sg_init(&fh->vbi, &saa7134_vbi_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VBI_CAPTURE,
-			    V4L2_FIELD_SEQ_TB,
-			    sizeof(struct saa7134_buf),
-			    fh, NULL);
-	saa7134_pgtable_alloc(dev->pci,&fh->pt_cap);
-	saa7134_pgtable_alloc(dev->pci,&fh->pt_vbi);
-
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
 		/* switch to radio mode */
 		saa7134_tvaudio_setinput(dev,&card(dev).radio);
@@ -1395,28 +1379,30 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_fh *fh = file->private_data;
+	struct saa7134_dev *dev = fh->dev;
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
 
 	if (vdev->vfl_type == VFL_TYPE_VBI)
-		return videobuf_poll_stream(file, &fh->vbi, wait);
+		return videobuf_poll_stream(file, &dev->vbi, wait);
 
 	if (res_check(fh,RESOURCE_VIDEO)) {
-		mutex_lock(&fh->cap.vb_lock);
-		if (!list_empty(&fh->cap.stream))
-			buf = list_entry(fh->cap.stream.next, struct videobuf_buffer, stream);
+		mutex_lock(&dev->cap.vb_lock);
+		if (!list_empty(&dev->cap.stream))
+			buf = list_entry(dev->cap.stream.next, struct videobuf_buffer, stream);
 	} else {
-		mutex_lock(&fh->cap.vb_lock);
-		if (UNSET == fh->cap.read_off) {
+		mutex_lock(&dev->cap.vb_lock);
+		if (UNSET == dev->cap.read_off) {
 			/* need to capture a new frame */
 			if (res_locked(fh->dev,RESOURCE_VIDEO))
 				goto err;
-			if (0 != fh->cap.ops->buf_prepare(&fh->cap,fh->cap.read_buf,fh->cap.field))
+			if (0 != dev->cap.ops->buf_prepare(&dev->cap,
+					dev->cap.read_buf, dev->cap.field))
 				goto err;
-			fh->cap.ops->buf_queue(&fh->cap,fh->cap.read_buf);
-			fh->cap.read_off = 0;
+			dev->cap.ops->buf_queue(&dev->cap, dev->cap.read_buf);
+			dev->cap.read_off = 0;
 		}
-		buf = fh->cap.read_buf;
+		buf = dev->cap.read_buf;
 	}
 
 	if (!buf)
@@ -1426,11 +1412,11 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 	if (buf->state == VIDEOBUF_DONE ||
 	    buf->state == VIDEOBUF_ERROR)
 		rc = POLLIN|POLLRDNORM;
-	mutex_unlock(&fh->cap.vb_lock);
+	mutex_unlock(&dev->cap.vb_lock);
 	return rc;
 
 err:
-	mutex_unlock(&fh->cap.vb_lock);
+	mutex_unlock(&dev->cap.vb_lock);
 	return POLLERR;
 }
 
@@ -1454,18 +1440,20 @@ static int video_release(struct file *file)
 
 	/* stop video capture */
 	if (res_check(fh, RESOURCE_VIDEO)) {
-		videobuf_streamoff(&fh->cap);
+		videobuf_streamoff(&dev->cap);
 		res_free(dev,fh,RESOURCE_VIDEO);
+		videobuf_mmap_free(&dev->cap);
 	}
-	if (fh->cap.read_buf) {
-		buffer_release(&fh->cap,fh->cap.read_buf);
-		kfree(fh->cap.read_buf);
+	if (dev->cap.read_buf) {
+		buffer_release(&dev->cap, dev->cap.read_buf);
+		kfree(dev->cap.read_buf);
 	}
 
 	/* stop vbi capture */
 	if (res_check(fh, RESOURCE_VBI)) {
-		videobuf_stop(&fh->vbi);
+		videobuf_stop(&dev->vbi);
 		res_free(dev,fh,RESOURCE_VBI);
+		videobuf_mmap_free(&dev->vbi);
 	}
 
 	/* ts-capture will not work in planar mode, so turn it off Hac: 04.05*/
@@ -1478,12 +1466,6 @@ static int video_release(struct file *file)
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
 		saa_call_all(dev, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
 
-	/* free stuff */
-	videobuf_mmap_free(&fh->cap);
-	videobuf_mmap_free(&fh->vbi);
-	saa7134_pgtable_free(dev->pci,&fh->pt_cap);
-	saa7134_pgtable_free(dev->pci,&fh->pt_vbi);
-
 	v4l2_fh_del(&fh->fh);
 	v4l2_fh_exit(&fh->fh);
 	file->private_data = NULL;
@@ -1558,7 +1540,7 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = fh->cap.field;
+	f->fmt.pix.field        = dev->cap.field;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
@@ -1661,7 +1643,7 @@ static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->fmt       = format_by_fourcc(f->fmt.pix.pixelformat);
 	dev->width     = f->fmt.pix.width;
 	dev->height    = f->fmt.pix.height;
-	fh->cap.field = f->fmt.pix.field;
+	dev->cap.field = f->fmt.pix.field;
 	return 0;
 }
 
@@ -2463,9 +2445,31 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	if (saa7134_boards[dev->board].video_out)
 		saa7134_videoport_init(dev);
 
+	videobuf_queue_sg_init(&dev->cap, &video_qops,
+			    &dev->pci->dev, &dev->slock,
+			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			    V4L2_FIELD_INTERLACED,
+			    sizeof(struct saa7134_buf),
+			    dev, NULL);
+	videobuf_queue_sg_init(&dev->vbi, &saa7134_vbi_qops,
+			    &dev->pci->dev, &dev->slock,
+			    V4L2_BUF_TYPE_VBI_CAPTURE,
+			    V4L2_FIELD_SEQ_TB,
+			    sizeof(struct saa7134_buf),
+			    dev, NULL);
+	saa7134_pgtable_alloc(dev->pci, &dev->pt_cap);
+	saa7134_pgtable_alloc(dev->pci, &dev->pt_vbi);
+
 	return 0;
 }
 
+void saa7134_video_fini(struct saa7134_dev *dev)
+{
+	/* free stuff */
+	saa7134_pgtable_free(dev->pci, &dev->pt_cap);
+	saa7134_pgtable_free(dev->pci, &dev->pt_vbi);
+}
+
 int saa7134_videoport_init(struct saa7134_dev *dev)
 {
 	/* enable video output */
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 8d1453a..96b7ccf 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -472,14 +472,6 @@ struct saa7134_fh {
 	struct v4l2_fh             fh;
 	struct saa7134_dev         *dev;
 	unsigned int               resources;
-
-	/* video capture */
-	struct videobuf_queue      cap;
-	struct saa7134_pgtable     pt_cap;
-
-	/* vbi capture */
-	struct videobuf_queue      vbi;
-	struct saa7134_pgtable     pt_vbi;
 };
 
 /* dmasound dsp status */
@@ -589,7 +581,11 @@ struct saa7134_dev {
 
 	/* video+ts+vbi capture */
 	struct saa7134_dmaqueue    video_q;
+	struct videobuf_queue      cap;
+	struct saa7134_pgtable     pt_cap;
 	struct saa7134_dmaqueue    vbi_q;
+	struct videobuf_queue      vbi;
+	struct saa7134_pgtable     pt_vbi;
 	unsigned int               video_fieldcount;
 	unsigned int               vbi_fieldcount;
 	struct saa7134_format      *fmt;
@@ -773,6 +769,7 @@ int saa7134_video_init1(struct saa7134_dev *dev);
 int saa7134_video_init2(struct saa7134_dev *dev);
 void saa7134_irq_video_signalchange(struct saa7134_dev *dev);
 void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status);
+void saa7134_video_fini(struct saa7134_dev *dev);
 
 
 /* ----------------------------------------------------------- */
-- 
1.7.10.4

