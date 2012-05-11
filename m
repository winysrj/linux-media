Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1844 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2EKHzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 11/16] saa7146: rename vbi/video_q to vbi/video_dmaq.
Date: Fri, 11 May 2012 09:55:05 +0200
Message-Id: <7910be33fad123bd63c870ebe76b0e5b8a8a2c28.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There was also a vbi_q and video_q in saa7146_fh, so that was confusing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_vbi.c   |   31 +++++++++++++++----------------
 drivers/media/common/saa7146_video.c |   16 ++++++++--------
 include/media/saa7146_vv.h           |    4 ++--
 3 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
index c930aa0..1e71e37 100644
--- a/drivers/media/common/saa7146_vbi.c
+++ b/drivers/media/common/saa7146_vbi.c
@@ -211,7 +211,7 @@ static int buffer_activate(struct saa7146_dev *dev,
 	DEB_VBI("dev:%p, buf:%p, next:%p\n", dev, buf, next);
 	saa7146_set_vbi_capture(dev,buf,next);
 
-	mod_timer(&vv->vbi_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&vv->vbi_dmaq.timeout, jiffies+BUFFER_TIMEOUT);
 	return 0;
 }
 
@@ -294,7 +294,7 @@ static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 
 	DEB_VBI("vb:%p\n", vb);
-	saa7146_buffer_queue(dev,&vv->vbi_q,buf);
+	saa7146_buffer_queue(dev, &vv->vbi_dmaq, buf);
 }
 
 static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
@@ -335,15 +335,14 @@ static void vbi_stop(struct saa7146_fh *fh, struct file *file)
 	/* shut down dma 3 transfers */
 	saa7146_write(dev, MC1, MASK_20);
 
-	if (vv->vbi_q.curr) {
-		saa7146_buffer_finish(dev,&vv->vbi_q,VIDEOBUF_DONE);
-	}
+	if (vv->vbi_dmaq.curr)
+		saa7146_buffer_finish(dev, &vv->vbi_dmaq, VIDEOBUF_DONE);
 
 	videobuf_queue_cancel(&fh->vbi_q);
 
 	vv->vbi_streaming = NULL;
 
-	del_timer(&vv->vbi_q.timeout);
+	del_timer(&vv->vbi_dmaq.timeout);
 	del_timer(&vv->vbi_read_timeout);
 
 	spin_unlock_irqrestore(&dev->slock, flags);
@@ -364,12 +363,12 @@ static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 {
 	DEB_VBI("dev:%p\n", dev);
 
-	INIT_LIST_HEAD(&vv->vbi_q.queue);
+	INIT_LIST_HEAD(&vv->vbi_dmaq.queue);
 
-	init_timer(&vv->vbi_q.timeout);
-	vv->vbi_q.timeout.function = saa7146_buffer_timeout;
-	vv->vbi_q.timeout.data     = (unsigned long)(&vv->vbi_q);
-	vv->vbi_q.dev              = dev;
+	init_timer(&vv->vbi_dmaq.timeout);
+	vv->vbi_dmaq.timeout.function = saa7146_buffer_timeout;
+	vv->vbi_dmaq.timeout.data     = (unsigned long)(&vv->vbi_dmaq);
+	vv->vbi_dmaq.dev              = dev;
 
 	init_waitqueue_head(&vv->vbi_wq);
 }
@@ -440,16 +439,16 @@ static void vbi_irq_done(struct saa7146_dev *dev, unsigned long status)
 	struct saa7146_vv *vv = dev->vv_data;
 	spin_lock(&dev->slock);
 
-	if (vv->vbi_q.curr) {
-		DEB_VBI("dev:%p, curr:%p\n", dev, vv->vbi_q.curr);
+	if (vv->vbi_dmaq.curr) {
+		DEB_VBI("dev:%p, curr:%p\n", dev, vv->vbi_dmaq.curr);
 		/* this must be += 2, one count for each field */
 		vv->vbi_fieldcount+=2;
-		vv->vbi_q.curr->vb.field_count = vv->vbi_fieldcount;
-		saa7146_buffer_finish(dev,&vv->vbi_q,VIDEOBUF_DONE);
+		vv->vbi_dmaq.curr->vb.field_count = vv->vbi_fieldcount;
+		saa7146_buffer_finish(dev, &vv->vbi_dmaq, VIDEOBUF_DONE);
 	} else {
 		DEB_VBI("dev:%p\n", dev);
 	}
-	saa7146_buffer_next(dev,&vv->vbi_q,1);
+	saa7146_buffer_next(dev, &vv->vbi_dmaq, 1);
 
 	spin_unlock(&dev->slock);
 }
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 9a99835..8507990 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1035,7 +1035,7 @@ static int buffer_activate (struct saa7146_dev *dev,
 	buf->vb.state = VIDEOBUF_ACTIVE;
 	saa7146_set_capture(dev,buf,next);
 
-	mod_timer(&vv->video_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&vv->video_dmaq.timeout, jiffies+BUFFER_TIMEOUT);
 	return 0;
 }
 
@@ -1158,7 +1158,7 @@ static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 
 	DEB_CAP("vbuf:%p\n", vb);
-	saa7146_buffer_queue(fh->dev,&vv->video_q,buf);
+	saa7146_buffer_queue(fh->dev, &vv->video_dmaq, buf);
 }
 
 static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
@@ -1187,12 +1187,12 @@ static struct videobuf_queue_ops video_qops = {
 
 static void video_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 {
-	INIT_LIST_HEAD(&vv->video_q.queue);
+	INIT_LIST_HEAD(&vv->video_dmaq.queue);
 
-	init_timer(&vv->video_q.timeout);
-	vv->video_q.timeout.function = saa7146_buffer_timeout;
-	vv->video_q.timeout.data     = (unsigned long)(&vv->video_q);
-	vv->video_q.dev              = dev;
+	init_timer(&vv->video_dmaq.timeout);
+	vv->video_dmaq.timeout.function = saa7146_buffer_timeout;
+	vv->video_dmaq.timeout.data     = (unsigned long)(&vv->video_dmaq);
+	vv->video_dmaq.dev              = dev;
 
 	/* set some default values */
 	vv->standard = &dev->ext_vv_data->stds[0];
@@ -1237,7 +1237,7 @@ static void video_close(struct saa7146_dev *dev, struct file *file)
 static void video_irq_done(struct saa7146_dev *dev, unsigned long st)
 {
 	struct saa7146_vv *vv = dev->vv_data;
-	struct saa7146_dmaqueue *q = &vv->video_q;
+	struct saa7146_dmaqueue *q = &vv->video_dmaq;
 
 	spin_lock(&dev->slock);
 	DEB_CAP("called\n");
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index e9f434c..2cc32c5 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -101,7 +101,7 @@ struct saa7146_fh {
 struct saa7146_vv
 {
 	/* vbi capture */
-	struct saa7146_dmaqueue		vbi_q;
+	struct saa7146_dmaqueue		vbi_dmaq;
 	struct v4l2_vbi_format		vbi_fmt;
 	struct timer_list		vbi_read_timeout;
 	/* vbi workaround interrupt queue */
@@ -119,7 +119,7 @@ struct saa7146_vv
 	struct saa7146_fh		*ov_suspend;
 
 	/* video capture */
-	struct saa7146_dmaqueue		video_q;
+	struct saa7146_dmaqueue		video_dmaq;
 	struct v4l2_pix_format		video_fmt;
 	enum v4l2_field			last_field;
 
-- 
1.7.10

