Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2351 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaDQKjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 02/11] saa7134: coding style cleanups.
Date: Thu, 17 Apr 2014 12:39:05 +0200
Message-Id: <1397731154-34337-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just white space changes to reduce the noise in the following patches.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-alsa.c    | 13 ++++----
 drivers/media/pci/saa7134/saa7134-core.c    | 47 ++++++++++++-----------------
 drivers/media/pci/saa7134/saa7134-dvb.c     |  7 -----
 drivers/media/pci/saa7134/saa7134-empress.c |  7 -----
 drivers/media/pci/saa7134/saa7134-i2c.c     |  7 -----
 drivers/media/pci/saa7134/saa7134-reg.h     |  7 -----
 drivers/media/pci/saa7134/saa7134-ts.c      | 17 +++--------
 drivers/media/pci/saa7134/saa7134-tvaudio.c |  7 -----
 drivers/media/pci/saa7134/saa7134-vbi.c     | 37 +++++++++--------------
 drivers/media/pci/saa7134/saa7134-video.c   | 31 ++++++++-----------
 10 files changed, 59 insertions(+), 121 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index e04a4d5..ff6f373 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -648,19 +648,20 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 		return err;
 	}
 
-	if (0 != (err = videobuf_dma_map(&dev->pci->dev, &dev->dmasound.dma))) {
+	err = videobuf_dma_map(&dev->pci->dev, &dev->dmasound.dma);
+	if (err) {
 		dsp_buffer_free(dev);
 		return err;
 	}
-	if (0 != (err = saa7134_pgtable_alloc(dev->pci,&dev->dmasound.pt))) {
+	err = saa7134_pgtable_alloc(dev->pci, &dev->dmasound.pt);
+	if (err) {
 		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		return err;
 	}
-	if (0 != (err = saa7134_pgtable_build(dev->pci,&dev->dmasound.pt,
-						dev->dmasound.dma.sglist,
-						dev->dmasound.dma.sglen,
-						0))) {
+	err = saa7134_pgtable_build(dev->pci, &dev->dmasound.pt,
+				dev->dmasound.sglist, dev->dmasound.sglen, 0);
+	if (err) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
 		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 1362b4a..2495a9d 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -209,7 +209,7 @@ int saa7134_buffer_startpage(struct saa7134_buf *buf)
 unsigned long saa7134_buffer_base(struct saa7134_buf *buf)
 {
 	unsigned long base;
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 
 	base  = saa7134_buffer_startpage(buf) * 4096;
 	base += dma->sglist[0].offset;
@@ -237,7 +237,7 @@ int saa7134_pgtable_build(struct pci_dev *pci, struct saa7134_pgtable *pt,
 			  unsigned int startpage)
 {
 	__le32        *ptr;
-	unsigned int  i,p;
+	unsigned int  i, p;
 
 	BUG_ON(NULL == pt || NULL == pt->cpu);
 
@@ -278,22 +278,22 @@ int saa7134_buffer_queue(struct saa7134_dev *dev,
 	struct saa7134_buf *next = NULL;
 
 	assert_spin_locked(&dev->slock);
-	dprintk("buffer_queue %p\n",buf);
+	dprintk("buffer_queue %p\n", buf);
 	if (NULL == q->curr) {
 		if (!q->need_two) {
 			q->curr = buf;
-			buf->activate(dev,buf,NULL);
+			buf->activate(dev, buf, NULL);
 		} else if (list_empty(&q->queue)) {
 			list_add_tail(&buf->vb.queue,&q->queue);
 			buf->vb.state = VIDEOBUF_QUEUED;
 		} else {
-			next = list_entry(q->queue.next,struct saa7134_buf,
+			next = list_entry(q->queue.next, struct saa7134_buf,
 					  vb.queue);
 			q->curr = buf;
-			buf->activate(dev,buf,next);
+			buf->activate(dev, buf, next);
 		}
 	} else {
-		list_add_tail(&buf->vb.queue,&q->queue);
+		list_add_tail(&buf->vb.queue, &q->queue);
 		buf->vb.state = VIDEOBUF_QUEUED;
 	}
 	return 0;
@@ -304,7 +304,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 			   unsigned int state)
 {
 	assert_spin_locked(&dev->slock);
-	dprintk("buffer_finish %p\n",q->curr);
+	dprintk("buffer_finish %p\n", q->curr);
 
 	/* finish current buffer */
 	q->curr->vb.state = state;
@@ -323,20 +323,20 @@ void saa7134_buffer_next(struct saa7134_dev *dev,
 
 	if (!list_empty(&q->queue)) {
 		/* activate next one from queue */
-		buf = list_entry(q->queue.next,struct saa7134_buf,vb.queue);
+		buf = list_entry(q->queue.next, struct saa7134_buf, vb.queue);
 		dprintk("buffer_next %p [prev=%p/next=%p]\n",
-			buf,q->queue.prev,q->queue.next);
+			buf, q->queue.prev, q->queue.next);
 		list_del(&buf->vb.queue);
 		if (!list_empty(&q->queue))
-			next = list_entry(q->queue.next,struct saa7134_buf,
+			next = list_entry(q->queue.next, struct saa7134_buf,
 					  vb.queue);
 		q->curr = buf;
-		buf->activate(dev,buf,next);
+		buf->activate(dev, buf, next);
 		dprintk("buffer_next #2 prev=%p/next=%p\n",
-			q->queue.prev,q->queue.next);
+			q->queue.prev, q->queue.next);
 	} else {
 		/* nothing to do -- just stop DMA */
-		dprintk("buffer_next %p\n",NULL);
+		dprintk("buffer_next %p\n", NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
 
@@ -348,11 +348,11 @@ void saa7134_buffer_next(struct saa7134_dev *dev,
 
 void saa7134_buffer_timeout(unsigned long data)
 {
-	struct saa7134_dmaqueue *q = (struct saa7134_dmaqueue*)data;
+	struct saa7134_dmaqueue *q = (struct saa7134_dmaqueue *)data;
 	struct saa7134_dev *dev = q->dev;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->slock,flags);
+	spin_lock_irqsave(&dev->slock, flags);
 
 	/* try to reset the hardware (SWRST) */
 	saa_writeb(SAA7134_REGION_ENABLE, 0x00);
@@ -362,11 +362,11 @@ void saa7134_buffer_timeout(unsigned long data)
 	/* flag current buffer as failed,
 	   try to start over with the next one. */
 	if (q->curr) {
-		dprintk("timeout on %p\n",q->curr);
-		saa7134_buffer_finish(dev,q,VIDEOBUF_ERROR);
+		dprintk("timeout on %p\n", q->curr);
+		saa7134_buffer_finish(dev, q, VIDEOBUF_ERROR);
 	}
-	saa7134_buffer_next(dev,q);
-	spin_unlock_irqrestore(&dev->slock,flags);
+	saa7134_buffer_next(dev, q);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
 /* ------------------------------------------------------------------ */
@@ -1360,10 +1360,3 @@ EXPORT_SYMBOL(saa7134_pgtable_free);
 EXPORT_SYMBOL(saa7134_pgtable_build);
 EXPORT_SYMBOL(saa7134_pgtable_alloc);
 EXPORT_SYMBOL(saa7134_set_dmabits);
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 4a08ae3..8b55e6d 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1955,10 +1955,3 @@ static void __exit dvb_unregister(void)
 
 module_init(dvb_register);
 module_exit(dvb_unregister);
-
-/* ------------------------------------------------------------------ */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 0a9047e..07bd06c 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -395,10 +395,3 @@ static void __exit empress_unregister(void)
 
 module_init(empress_register);
 module_exit(empress_unregister);
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index c68169d..f4da674 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -427,10 +427,3 @@ int saa7134_i2c_unregister(struct saa7134_dev *dev)
 	i2c_del_adapter(&dev->i2c_adap);
 	return 0;
 }
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/saa7134/saa7134-reg.h b/drivers/media/pci/saa7134/saa7134-reg.h
index e7e0af1..b28b151 100644
--- a/drivers/media/pci/saa7134/saa7134-reg.h
+++ b/drivers/media/pci/saa7134/saa7134-reg.h
@@ -369,10 +369,3 @@
 #define SAA7135_DSP_RWCLEAR_RERR		    1
 
 #define SAA7133_I2S_AUDIO_CONTROL               0x591
-/* ------------------------------------------------------------------ */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 2e3f4b4..240d280 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -76,11 +76,11 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		enum v4l2_field field)
 {
 	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb);
 	unsigned int lines, llength, size;
 	int err;
 
-	dprintk("buffer_prepare [%p,%s]\n",buf,v4l2_field_names[field]);
+	dprintk("buffer_prepare [%p,%s]\n", buf, v4l2_field_names[field]);
 
 	llength = TS_PACKET_SIZE;
 	lines = dev->ts.nr_packets;
@@ -213,7 +213,7 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
 	dev->ts_started            = 0;
-	saa7134_pgtable_alloc(dev->pci,&dev->ts.pt_ts);
+	saa7134_pgtable_alloc(dev->pci, &dev->ts.pt_ts);
 
 	/* init TS hw */
 	saa7134_ts_init_hw(dev);
@@ -293,7 +293,7 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 
 int saa7134_ts_fini(struct saa7134_dev *dev)
 {
-	saa7134_pgtable_free(dev->pci,&dev->ts.pt_ts);
+	saa7134_pgtable_free(dev->pci, &dev->ts.pt_ts);
 	return 0;
 }
 
@@ -311,17 +311,10 @@ void saa7134_irq_ts_done(struct saa7134_dev *dev, unsigned long status)
 			if ((status & 0x100000) != 0x100000)
 				goto done;
 		}
-		saa7134_buffer_finish(dev,&dev->ts_q,VIDEOBUF_DONE);
+		saa7134_buffer_finish(dev, &dev->ts_q, VIDEOBUF_DONE);
 	}
 	saa7134_buffer_next(dev,&dev->ts_q);
 
  done:
 	spin_unlock(&dev->slock);
 }
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 0f34e09..3afbcb7 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -1079,10 +1079,3 @@ int saa7134_tvaudio_do_scan(struct saa7134_dev *dev)
 
 EXPORT_SYMBOL(saa_dsp_writel);
 EXPORT_SYMBOL(saa7134_tvaudio_setmute);
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index d4da18d..e044539 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -81,14 +81,14 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
-	unsigned long control,base;
+	unsigned long control, base;
 
-	dprintk("buffer_activate [%p]\n",buf);
+	dprintk("buffer_activate [%p]\n", buf);
 	buf->vb.state = VIDEOBUF_ACTIVE;
 	buf->top_seen = 0;
 
-	task_init(dev,buf,TASK_A);
-	task_init(dev,buf,TASK_B);
+	task_init(dev, buf, TASK_A);
+	task_init(dev, buf, TASK_B);
 	saa_writeb(SAA7134_OFMT_DATA_A, 0x06);
 	saa_writeb(SAA7134_OFMT_DATA_B, 0x06);
 
@@ -97,18 +97,18 @@ static int buffer_activate(struct saa7134_dev *dev,
 	control = SAA7134_RS_CONTROL_BURST_16 |
 		SAA7134_RS_CONTROL_ME |
 		(buf->pt->dma >> 12);
-	saa_writel(SAA7134_RS_BA1(2),base);
-	saa_writel(SAA7134_RS_BA2(2),base + buf->vb.size/2);
-	saa_writel(SAA7134_RS_PITCH(2),buf->vb.width);
-	saa_writel(SAA7134_RS_CONTROL(2),control);
-	saa_writel(SAA7134_RS_BA1(3),base);
-	saa_writel(SAA7134_RS_BA2(3),base + buf->vb.size/2);
-	saa_writel(SAA7134_RS_PITCH(3),buf->vb.width);
-	saa_writel(SAA7134_RS_CONTROL(3),control);
+	saa_writel(SAA7134_RS_BA1(2), base);
+	saa_writel(SAA7134_RS_BA2(2), base + buf->vb.size / 2);
+	saa_writel(SAA7134_RS_PITCH(2), buf->vb.width);
+	saa_writel(SAA7134_RS_CONTROL(2), control);
+	saa_writel(SAA7134_RS_BA1(3), base);
+	saa_writel(SAA7134_RS_BA2(3), base + buf->vb.size / 2);
+	saa_writel(SAA7134_RS_PITCH(3), buf->vb.width);
+	saa_writel(SAA7134_RS_CONTROL(3), control);
 
 	/* start DMA */
 	saa7134_set_dmabits(dev);
-	mod_timer(&dev->vbi_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dev->vbi_q.timeout, jiffies + BUFFER_TIMEOUT);
 
 	return 0;
 }
@@ -236,17 +236,10 @@ void saa7134_irq_vbi_done(struct saa7134_dev *dev, unsigned long status)
 			goto done;
 
 		dev->vbi_q.curr->vb.field_count = dev->vbi_fieldcount;
-		saa7134_buffer_finish(dev,&dev->vbi_q,VIDEOBUF_DONE);
+		saa7134_buffer_finish(dev, &dev->vbi_q, VIDEOBUF_DONE);
 	}
-	saa7134_buffer_next(dev,&dev->vbi_q);
+	saa7134_buffer_next(dev, &dev->vbi_q);
 
  done:
 	spin_unlock(&dev->slock);
 }
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 40396e8..edf9ec3 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -824,7 +824,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 	buf->vb.state = VIDEOBUF_ACTIVE;
 	buf->top_seen = 0;
 
-	set_size(dev,TASK_A,buf->vb.width,buf->vb.height,
+	set_size(dev, TASK_A, buf->vb.width, buf->vb.height,
 		 V4L2_FIELD_HAS_BOTH(buf->vb.field));
 	if (buf->fmt->yuv)
 		saa_andorb(SAA7134_DATA_PATH(TASK_A), 0x3f, 0x03);
@@ -891,7 +891,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 
 	/* start DMA */
 	saa7134_set_dmabits(dev);
-	mod_timer(&dev->video_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dev->video_q.timeout, jiffies + BUFFER_TIMEOUT);
 	return 0;
 }
 
@@ -900,7 +900,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 			  enum v4l2_field field)
 {
 	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb);
 	unsigned int size;
 	int err;
 
@@ -974,14 +974,14 @@ buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
 	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb);
 
 	saa7134_buffer_queue(dev, &dev->video_q, buf);
 }
 
 static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb);
 
 	saa7134_dma_free(q,buf);
 }
@@ -1130,11 +1130,11 @@ static int video_open(struct file *file)
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
 		/* switch to radio mode */
-		saa7134_tvaudio_setinput(dev,&card(dev).radio);
+		saa7134_tvaudio_setinput(dev, &card(dev).radio);
 		saa_call_all(dev, tuner, s_radio);
 	} else {
 		/* switch to video/vbi mode */
-		video_mux(dev,dev->ctl_input);
+		video_mux(dev, dev->ctl_input);
 	}
 	v4l2_fh_add(&fh->fh);
 
@@ -1459,9 +1459,9 @@ static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 	if (0 != err)
 		return err;
 
-	dev->fmt       = format_by_fourcc(f->fmt.pix.pixelformat);
-	dev->width     = f->fmt.pix.width;
-	dev->height    = f->fmt.pix.height;
+	dev->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
+	dev->width = f->fmt.pix.width;
+	dev->height = f->fmt.pix.height;
 	dev->cap.field = f->fmt.pix.field;
 	return 0;
 }
@@ -2382,17 +2382,10 @@ void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status)
 				goto done;
 		}
 		dev->video_q.curr->vb.field_count = dev->video_fieldcount;
-		saa7134_buffer_finish(dev,&dev->video_q,VIDEOBUF_DONE);
+		saa7134_buffer_finish(dev, &dev->video_q, VIDEOBUF_DONE);
 	}
-	saa7134_buffer_next(dev,&dev->video_q);
+	saa7134_buffer_next(dev, &dev->video_q);
 
  done:
 	spin_unlock(&dev->slock);
 }
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
1.9.2

