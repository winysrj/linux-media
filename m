Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3316 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaDQKje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 08/11] saa7134: rename vbi/cap to vbi_vbq/cap_vbq
Date: Thu, 17 Apr 2014 12:39:11 +0200
Message-Id: <1397731154-34337-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use consistent _vbq suffix for videobuf_queue fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c | 52 +++++++++++++++----------------
 drivers/media/pci/saa7134/saa7134.h       |  4 +--
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index e5b2beb..9eb5564 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1086,10 +1086,10 @@ static struct videobuf_queue *saa7134_queue(struct file *file)
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
-		q = fh->is_empress ? &dev->empress_vbq : &dev->cap;
+		q = fh->is_empress ? &dev->empress_vbq : &dev->video_vbq;
 		break;
 	case VFL_TYPE_VBI:
-		q = &dev->vbi;
+		q = &dev->vbi_vbq;
 		break;
 	default:
 		BUG();
@@ -1174,6 +1174,7 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh = file->private_data;
 	struct videobuf_buffer *buf = NULL;
+	struct videobuf_queue *q = &dev->video_vbq;
 	unsigned int rc = 0;
 
 	if (v4l2_event_pending(&fh->fh))
@@ -1182,25 +1183,24 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 		poll_wait(file, &fh->fh.wait, wait);
 
 	if (vdev->vfl_type == VFL_TYPE_VBI)
-		return rc | videobuf_poll_stream(file, &dev->vbi, wait);
+		return rc | videobuf_poll_stream(file, &dev->vbi_vbq, wait);
 
 	if (res_check(fh, RESOURCE_VIDEO)) {
-		mutex_lock(&dev->cap.vb_lock);
-		if (!list_empty(&dev->cap.stream))
-			buf = list_entry(dev->cap.stream.next, struct videobuf_buffer, stream);
+		mutex_lock(&q->vb_lock);
+		if (!list_empty(&q->stream))
+			buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
 	} else {
-		mutex_lock(&dev->cap.vb_lock);
-		if (UNSET == dev->cap.read_off) {
+		mutex_lock(&q->vb_lock);
+		if (UNSET == q->read_off) {
 			/* need to capture a new frame */
 			if (res_locked(dev, RESOURCE_VIDEO))
 				goto err;
-			if (0 != dev->cap.ops->buf_prepare(&dev->cap,
-					dev->cap.read_buf, dev->cap.field))
+			if (0 != q->ops->buf_prepare(q, q->read_buf, q->field))
 				goto err;
-			dev->cap.ops->buf_queue(&dev->cap, dev->cap.read_buf);
-			dev->cap.read_off = 0;
+			q->ops->buf_queue(q, q->read_buf);
+			q->read_off = 0;
 		}
-		buf = dev->cap.read_buf;
+		buf = q->read_buf;
 	}
 
 	if (!buf)
@@ -1209,11 +1209,11 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 	poll_wait(file, &buf->done, wait);
 	if (buf->state == VIDEOBUF_DONE || buf->state == VIDEOBUF_ERROR)
 		rc |= POLLIN | POLLRDNORM;
-	mutex_unlock(&dev->cap.vb_lock);
+	mutex_unlock(&q->vb_lock);
 	return rc;
 
 err:
-	mutex_unlock(&dev->cap.vb_lock);
+	mutex_unlock(&q->vb_lock);
 	return rc | POLLERR;
 }
 
@@ -1238,21 +1238,21 @@ static int video_release(struct file *file)
 	/* stop video capture */
 	if (res_check(fh, RESOURCE_VIDEO)) {
 		pm_qos_remove_request(&dev->qos_request);
-		videobuf_streamoff(&dev->cap);
+		videobuf_streamoff(&dev->video_vbq);
 		res_free(dev, fh, RESOURCE_VIDEO);
-		videobuf_mmap_free(&dev->cap);
+		videobuf_mmap_free(&dev->video_vbq);
 		INIT_LIST_HEAD(&dev->cap.stream);
 	}
-	if (dev->cap.read_buf) {
-		buffer_release(&dev->cap, dev->cap.read_buf);
-		kfree(dev->cap.read_buf);
+	if (dev->video_vbq.read_buf) {
+		buffer_release(&dev->video_vbq, dev->video_vbq.read_buf);
+		kfree(dev->video_vbq.read_buf);
 	}
 
 	/* stop vbi capture */
 	if (res_check(fh, RESOURCE_VBI)) {
-		videobuf_stop(&dev->vbi);
+		videobuf_stop(&dev->vbi_vbq);
 		res_free(dev, fh, RESOURCE_VBI);
-		videobuf_mmap_free(&dev->vbi);
+		videobuf_mmap_free(&dev->vbi_vbq);
 		INIT_LIST_HEAD(&dev->vbi.stream);
 	}
 
@@ -1338,7 +1338,7 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = dev->cap.field;
+	f->fmt.pix.field        = dev->video_vbq.field;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
@@ -1460,7 +1460,7 @@ static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 	dev->width = f->fmt.pix.width;
 	dev->height = f->fmt.pix.height;
-	dev->cap.field = f->fmt.pix.field;
+	dev->video_vbq.field = f->fmt.pix.field;
 	return 0;
 }
 
@@ -2247,13 +2247,13 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	if (saa7134_boards[dev->board].video_out)
 		saa7134_videoport_init(dev);
 
-	videobuf_queue_sg_init(&dev->cap, &video_qops,
+	videobuf_queue_sg_init(&dev->video_vbq, &video_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7134_buf),
 			    dev, NULL);
-	videobuf_queue_sg_init(&dev->vbi, &saa7134_vbi_qops,
+	videobuf_queue_sg_init(&dev->vbi_vbq, &saa7134_vbi_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
 			    V4L2_FIELD_SEQ_TB,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 482489a..0c325e5 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -590,11 +590,11 @@ struct saa7134_dev {
 
 	/* video+ts+vbi capture */
 	struct saa7134_dmaqueue    video_q;
-	struct videobuf_queue      cap;
 	struct saa7134_pgtable     pt_cap;
+	struct videobuf_queue      video_vbq;
 	struct saa7134_dmaqueue    vbi_q;
-	struct videobuf_queue      vbi;
 	struct saa7134_pgtable     pt_vbi;
+	struct videobuf_queue      vbi_vbq;
 	unsigned int               video_fieldcount;
 	unsigned int               vbi_fieldcount;
 	struct saa7134_format      *fmt;
-- 
1.9.2

