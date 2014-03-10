Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1508 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaCJMVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 08:21:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/3] saa7134: convert to vb2
Date: Mon, 10 Mar 2014 13:20:49 +0100
Message-Id: <1394454049-12879-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl>
References: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert the saa7134 driver to vb2.

Note that while this uses the vb2-dma-sg version, the VB2_USERPTR mode is
disabled. The DMA hardware only supports DMAing full pages, and in the
USERPTR memory model the first and last scatter-gather buffer is almost
never a full page.

In practice this means that we can't use the VB2_USERPTR mode.

This has been tested with raw video, compressed video, VBI, radio, DVB and
video overlays.

Unfortunately, a vb2 conversion is one of those things you cannot split
up in smaller patches, it's all or nothing. This patch switches the whole
driver over to vb2, using the vb2 ioctl and fop helper functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/Kconfig           |   4 +-
 drivers/media/pci/saa7134/saa7134-alsa.c    | 106 ++++-
 drivers/media/pci/saa7134/saa7134-core.c    | 107 ++---
 drivers/media/pci/saa7134/saa7134-dvb.c     |  43 +-
 drivers/media/pci/saa7134/saa7134-empress.c | 178 +++-----
 drivers/media/pci/saa7134/saa7134-ts.c      | 185 ++++----
 drivers/media/pci/saa7134/saa7134-vbi.c     | 170 ++++---
 drivers/media/pci/saa7134/saa7134-video.c   | 659 ++++++++++------------------
 drivers/media/pci/saa7134/saa7134.h         | 106 +++--
 9 files changed, 715 insertions(+), 843 deletions(-)

diff --git a/drivers/media/pci/saa7134/Kconfig b/drivers/media/pci/saa7134/Kconfig
index 7883393..18ae755 100644
--- a/drivers/media/pci/saa7134/Kconfig
+++ b/drivers/media/pci/saa7134/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_SAA7134
 	tristate "Philips SAA7134 support"
 	depends on VIDEO_DEV && PCI && I2C
-	select VIDEOBUF_DMA_SG
+	select VIDEOBUF2_DMA_SG
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select CRC32
@@ -37,7 +37,7 @@ config VIDEO_SAA7134_RC
 config VIDEO_SAA7134_DVB
 	tristate "DVB/ATSC Support for saa7134 based TV cards"
 	depends on VIDEO_SAA7134 && DVB_CORE
-	select VIDEOBUF_DVB
+	select VIDEOBUF2_DVB
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA1004X if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index dd67c8a..413d5cf 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -274,6 +274,82 @@ static int snd_card_saa7134_capture_trigger(struct snd_pcm_substream * substream
 	return err;
 }
 
+static int saa7134_alsa_dma_init(struct saa7134_dev *dev, int nr_pages)
+{
+	struct saa7134_dmasound *dma = &dev->dmasound;
+	struct page *pg;
+	int i;
+
+	dma->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
+	if (NULL == dma->vaddr) {
+		dprintk("vmalloc_32(%d pages) failed\n", nr_pages);
+		return -ENOMEM;
+	}
+
+	dprintk("vmalloc is at addr 0x%08lx, size=%d\n",
+				(unsigned long)dma->vaddr,
+				nr_pages << PAGE_SHIFT);
+
+	memset(dma->vaddr, 0, nr_pages << PAGE_SHIFT);
+	dma->nr_pages = nr_pages;
+
+	dma->sglist = vzalloc(dma->nr_pages * sizeof(*dma->sglist));
+	if (NULL == dma->sglist)
+		goto vzalloc_err;
+
+	sg_init_table(dma->sglist, dma->nr_pages);
+	for (i = 0; i < dma->nr_pages; i++) {
+		pg = vmalloc_to_page(dma->vaddr + i * PAGE_SIZE);
+		if (NULL == pg)
+			goto vmalloc_to_page_err;
+		sg_set_page(&dma->sglist[i], pg, PAGE_SIZE, 0);
+	}
+	return 0;
+
+vmalloc_to_page_err:
+	vfree(dma->sglist);
+	dma->sglist = NULL;
+vzalloc_err:
+	vfree(dma->vaddr);
+	dma->vaddr = NULL;
+	return -ENOMEM;
+}
+
+static int saa7134_alsa_dma_map(struct saa7134_dev *dev)
+{
+	struct saa7134_dmasound *dma = &dev->dmasound;
+
+	dma->sglen = dma_map_sg(&dev->pci->dev, dma->sglist,
+			dma->nr_pages, PCI_DMA_FROMDEVICE);
+
+	if (0 == dma->sglen) {
+		pr_warn("%s: saa7134_alsa_map_sg failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int saa7134_alsa_dma_unmap(struct saa7134_dev *dev)
+{
+	struct saa7134_dmasound *dma = &dev->dmasound;
+
+	if (!dma->sglen)
+		return 0;
+
+	dma_unmap_sg(&dev->pci->dev, dma->sglist, dma->sglen, PCI_DMA_FROMDEVICE);
+	dma->sglen = 0;
+	return 0;
+}
+
+static int saa7134_alsa_dma_free(struct saa7134_dmasound *dma)
+{
+	vfree(dma->sglist);
+	dma->sglist = NULL;
+	vfree(dma->vaddr);
+	dma->vaddr = NULL;
+	return 0;
+}
+
 /*
  * DMA buffer initialization
  *
@@ -291,9 +367,8 @@ static int dsp_buffer_init(struct saa7134_dev *dev)
 
 	BUG_ON(!dev->dmasound.bufsize);
 
-	videobuf_dma_init(&dev->dmasound.dma);
-	err = videobuf_dma_init_kernel(&dev->dmasound.dma, PCI_DMA_FROMDEVICE,
-				       (dev->dmasound.bufsize + PAGE_SIZE) >> PAGE_SHIFT);
+	err = saa7134_alsa_dma_init(dev,
+			       (dev->dmasound.bufsize + PAGE_SIZE) >> PAGE_SHIFT);
 	if (0 != err)
 		return err;
 	return 0;
@@ -310,7 +385,7 @@ static int dsp_buffer_free(struct saa7134_dev *dev)
 {
 	BUG_ON(!dev->dmasound.blksize);
 
-	videobuf_dma_free(&dev->dmasound.dma);
+	saa7134_alsa_dma_free(&dev->dmasound);
 
 	dev->dmasound.blocks  = 0;
 	dev->dmasound.blksize = 0;
@@ -632,7 +707,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 	/* release the old buffer */
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		saa7134_alsa_dma_unmap(dev);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
@@ -648,21 +723,22 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 		return err;
 	}
 
-	if (0 != (err = videobuf_dma_map(&dev->pci->dev, &dev->dmasound.dma))) {
+	err = saa7134_alsa_dma_map(dev);
+	if (err) {
 		dsp_buffer_free(dev);
 		return err;
 	}
-	if (0 != (err = saa7134_pgtable_alloc(dev->pci,&dev->dmasound.pt))) {
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+	err = saa7134_pgtable_alloc(dev->pci, &dev->dmasound.pt);
+	if (err) {
+		saa7134_alsa_dma_unmap(dev);
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
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		saa7134_alsa_dma_unmap(dev);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -671,7 +747,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 	   byte, but it doesn't work. So I allocate the DMA using the
 	   V4L functions, and force ALSA to use that as the DMA area */
 
-	substream->runtime->dma_area = dev->dmasound.dma.vaddr;
+	substream->runtime->dma_area = dev->dmasound.vaddr;
 	substream->runtime->dma_bytes = dev->dmasound.bufsize;
 	substream->runtime->dma_addr = 0;
 
@@ -698,7 +774,7 @@ static int snd_card_saa7134_hw_free(struct snd_pcm_substream * substream)
 
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		saa7134_alsa_dma_unmap(dev);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 1362b4a..9130781 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -203,16 +203,16 @@ int saa7134_buffer_count(unsigned int size, unsigned int count)
 
 int saa7134_buffer_startpage(struct saa7134_buf *buf)
 {
-	return saa7134_buffer_pages(buf->vb.bsize) * buf->vb.i;
+	return saa7134_buffer_pages(vb2_plane_size(&buf->vb2, 0)) * buf->vb2.v4l2_buf.index;
 }
 
 unsigned long saa7134_buffer_base(struct saa7134_buf *buf)
 {
 	unsigned long base;
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 
 	base  = saa7134_buffer_startpage(buf) * 4096;
-	base += dma->sglist[0].offset;
+	base += dma->sgl[0].offset;
 	return base;
 }
 
@@ -237,14 +237,16 @@ int saa7134_pgtable_build(struct pci_dev *pci, struct saa7134_pgtable *pt,
 			  unsigned int startpage)
 {
 	__le32        *ptr;
-	unsigned int  i,p;
+	unsigned int  i, p;
 
 	BUG_ON(NULL == pt || NULL == pt->cpu);
 
 	ptr = pt->cpu + startpage;
-	for (i = 0; i < length; i++, list++)
+	for (i = 0; i < length; i++, list = sg_next(list)) {
 		for (p = 0; p * 4096 < list->length; p++, ptr++)
-			*ptr = cpu_to_le32(sg_dma_address(list) - list->offset);
+			*ptr = cpu_to_le32(sg_dma_address(list) +
+						list->offset + p * 4096);
+	}
 	return 0;
 }
 
@@ -258,44 +260,31 @@ void saa7134_pgtable_free(struct pci_dev *pci, struct saa7134_pgtable *pt)
 
 /* ------------------------------------------------------------------ */
 
-void saa7134_dma_free(struct videobuf_queue *q,struct saa7134_buf *buf)
-{
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-	BUG_ON(in_interrupt());
-
-	videobuf_waiton(q, &buf->vb, 0, 0);
-	videobuf_dma_unmap(q->dev, dma);
-	videobuf_dma_free(dma);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
-}
-
-/* ------------------------------------------------------------------ */
-
 int saa7134_buffer_queue(struct saa7134_dev *dev,
 			 struct saa7134_dmaqueue *q,
 			 struct saa7134_buf *buf)
 {
 	struct saa7134_buf *next = NULL;
+	unsigned long flags;
 
-	assert_spin_locked(&dev->slock);
+	spin_lock_irqsave(&dev->slock, flags);
 	dprintk("buffer_queue %p\n",buf);
 	if (NULL == q->curr) {
 		if (!q->need_two) {
 			q->curr = buf;
 			buf->activate(dev,buf,NULL);
 		} else if (list_empty(&q->queue)) {
-			list_add_tail(&buf->vb.queue,&q->queue);
-			buf->vb.state = VIDEOBUF_QUEUED;
+			list_add_tail(&buf->entry, &q->queue);
 		} else {
-			next = list_entry(q->queue.next,struct saa7134_buf,
-					  vb.queue);
+			next = list_entry(q->queue.next, struct saa7134_buf,
+					  entry);
 			q->curr = buf;
 			buf->activate(dev,buf,next);
 		}
 	} else {
-		list_add_tail(&buf->vb.queue,&q->queue);
-		buf->vb.state = VIDEOBUF_QUEUED;
+		list_add_tail(&buf->entry, &q->queue);
 	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 	return 0;
 }
 
@@ -303,13 +292,12 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 			   struct saa7134_dmaqueue *q,
 			   unsigned int state)
 {
-	assert_spin_locked(&dev->slock);
-	dprintk("buffer_finish %p\n",q->curr);
+	dprintk("buffer_finish %p\n", q->curr);
 
 	/* finish current buffer */
-	q->curr->vb.state = state;
-	v4l2_get_timestamp(&q->curr->vb.ts);
-	wake_up(&q->curr->vb.done);
+	v4l2_get_timestamp(&q->curr->vb2.v4l2_buf.timestamp);
+	q->curr->vb2.v4l2_buf.sequence = q->seq_nr++;
+	vb2_buffer_done(&q->curr->vb2, state);
 	q->curr = NULL;
 }
 
@@ -323,26 +311,21 @@ void saa7134_buffer_next(struct saa7134_dev *dev,
 
 	if (!list_empty(&q->queue)) {
 		/* activate next one from queue */
-		buf = list_entry(q->queue.next,struct saa7134_buf,vb.queue);
+		buf = list_entry(q->queue.next, struct saa7134_buf, entry);
 		dprintk("buffer_next %p [prev=%p/next=%p]\n",
-			buf,q->queue.prev,q->queue.next);
-		list_del(&buf->vb.queue);
+			buf, q->queue.prev, q->queue.next);
+		list_del(&buf->entry);
 		if (!list_empty(&q->queue))
-			next = list_entry(q->queue.next,struct saa7134_buf,
-					  vb.queue);
+			next = list_entry(q->queue.next, struct saa7134_buf, entry);
 		q->curr = buf;
-		buf->activate(dev,buf,next);
+		buf->activate(dev, buf, next);
 		dprintk("buffer_next #2 prev=%p/next=%p\n",
-			q->queue.prev,q->queue.next);
+			q->queue.prev, q->queue.next);
 	} else {
 		/* nothing to do -- just stop DMA */
 		dprintk("buffer_next %p\n",NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
-
-		if (card_has_mpeg(dev))
-			if (dev->ts_started)
-				saa7134_ts_stop(dev);
 	}
 }
 
@@ -363,12 +346,32 @@ void saa7134_buffer_timeout(unsigned long data)
 	   try to start over with the next one. */
 	if (q->curr) {
 		dprintk("timeout on %p\n",q->curr);
-		saa7134_buffer_finish(dev,q,VIDEOBUF_ERROR);
+		saa7134_buffer_finish(dev, q, VB2_BUF_STATE_ERROR);
 	}
 	saa7134_buffer_next(dev,q);
 	spin_unlock_irqrestore(&dev->slock,flags);
 }
 
+void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q)
+{
+	unsigned long flags;
+	struct list_head *pos, *n;
+	struct saa7134_buf *tmp;
+
+	spin_lock_irqsave(&dev->slock, flags);
+	if (!list_empty(&q->queue)) {
+		list_for_each_safe(pos, n, &q->queue) {
+			 tmp = list_entry(pos, struct saa7134_buf, entry);
+			 vb2_buffer_done(&tmp->vb2, VB2_BUF_STATE_ERROR);
+			 list_del(pos);
+			 tmp = NULL;
+		}
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
+	saa7134_buffer_timeout((unsigned long)q); /* also calls del_timer(&q->timeout) */
+}
+EXPORT_SYMBOL_GPL(saa7134_stop_streaming);
+
 /* ------------------------------------------------------------------ */
 
 int saa7134_set_dmabits(struct saa7134_dev *dev)
@@ -383,17 +386,16 @@ int saa7134_set_dmabits(struct saa7134_dev *dev)
 		return 0;
 
 	/* video capture -- dma 0 + video task A */
-	if (dev->video_q.curr) {
+	if (dev->vid_q.curr) {
 		task |= 0x01;
 		ctrl |= SAA7134_MAIN_CTRL_TE0;
 		irq  |= SAA7134_IRQ1_INTE_RA0_1 |
 			SAA7134_IRQ1_INTE_RA0_0;
-		cap = dev->video_q.curr->vb.field;
+		cap = dev->field;
 	}
 
 	/* video capture -- dma 1+2 (planar modes) */
-	if (dev->video_q.curr &&
-	    dev->video_q.curr->fmt->planar) {
+	if (dev->vid_q.curr && dev->fmt->planar) {
 		ctrl |= SAA7134_MAIN_CTRL_TE4 |
 			SAA7134_MAIN_CTRL_TE5;
 	}
@@ -1047,6 +1049,8 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 
 	dev->video_dev = vdev_init(dev,&saa7134_video_template,"video");
 	dev->video_dev->ctrl_handler = &dev->ctrl_handler;
+	dev->video_dev->lock = &dev->lock;
+	dev->video_dev->queue = &dev->vid_q.q;
 	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
 				    video_nr[dev->nr]);
 	if (err < 0) {
@@ -1059,6 +1063,8 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 
 	dev->vbi_dev = vdev_init(dev, &saa7134_video_template, "vbi");
 	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
+	dev->vbi_dev->lock = &dev->lock;
+	dev->vbi_dev->queue = &dev->vbi_q.q;
 
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
 				    vbi_nr[dev->nr]);
@@ -1070,6 +1076,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	if (card_has_radio(dev)) {
 		dev->radio_dev = vdev_init(dev,&saa7134_radio_template,"radio");
 		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
+		dev->radio_dev->lock = &dev->lock;
 		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
 					    radio_nr[dev->nr]);
 		if (err < 0)
@@ -1189,7 +1196,7 @@ static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 
 	if (!list_empty(&q->queue))
 		next = list_entry(q->queue.next, struct saa7134_buf,
-					  vb.queue);
+					  entry);
 	buf->activate(dev, buf, next);
 
 	return 0;
@@ -1219,7 +1226,7 @@ static int saa7134_suspend(struct pci_dev *pci_dev , pm_message_t state)
 	/* Disable timeout timers - if we have active buffers, we will
 	   fill them on resume*/
 
-	del_timer(&dev->video_q.timeout);
+	del_timer(&dev->vid_q.timeout);
 	del_timer(&dev->vbi_q.timeout);
 	del_timer(&dev->ts_q.timeout);
 
@@ -1271,7 +1278,7 @@ static int saa7134_resume(struct pci_dev *pci_dev)
 
 	/*resume unfinished buffer(s)*/
 	spin_lock_irqsave(&dev->slock, flags);
-	saa7134_buffer_requeue(dev, &dev->video_q);
+	saa7134_buffer_requeue(dev, &dev->vid_q);
 	saa7134_buffer_requeue(dev, &dev->vbi_q);
 	saa7134_buffer_requeue(dev, &dev->ts_q);
 
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 4a08ae3..4836f27 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -602,10 +602,10 @@ static int configure_tda827x_fe(struct saa7134_dev *dev,
 				struct tda1004x_config *cdec_conf,
 				struct tda827x_config *tuner_conf)
 {
-	struct videobuf_dvb_frontend *fe0;
+	struct vb2_dvb_frontend *fe0;
 
 	/* Get the first frontend */
-	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	fe0 = vb2_dvb_get_frontend(&dev->frontends, 1);
 
 	if (!fe0)
 		return -EINVAL;
@@ -1215,29 +1215,38 @@ static int dvb_init(struct saa7134_dev *dev)
 {
 	int ret;
 	int attach_xc3028 = 0;
-	struct videobuf_dvb_frontend *fe0;
+	struct vb2_dvb_frontend *fe0;
+	struct vb2_queue *q;
 
 	/* FIXME: add support for multi-frontend */
 	mutex_init(&dev->frontends.lock);
 	INIT_LIST_HEAD(&dev->frontends.felist);
 
 	printk(KERN_INFO "%s() allocating 1 frontend\n", __func__);
-	fe0 = videobuf_dvb_alloc_frontend(&dev->frontends, 1);
+	fe0 = vb2_dvb_alloc_frontend(&dev->frontends, 1);
 	if (!fe0) {
 		printk(KERN_ERR "%s() failed to alloc\n", __func__);
 		return -ENOMEM;
 	}
 
-	/* init struct videobuf_dvb */
+	/* init struct vb2_dvb */
 	dev->ts.nr_bufs    = 32;
 	dev->ts.nr_packets = 32*4;
 	fe0->dvb.name = dev->name;
-	videobuf_queue_sg_init(&fe0->dvb.dvbq, &saa7134_ts_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			    V4L2_FIELD_ALTERNATE,
-			    sizeof(struct saa7134_buf),
-			    dev, NULL);
+	q = &fe0->dvb.dvbq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_READ;
+	q->drv_priv = &dev->ts_q;
+	q->ops = &saa7134_ts_qops;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->buf_struct_size = sizeof(struct saa7134_buf);
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &dev->lock;
+	ret = vb2_queue_init(q);
+	if (ret) {
+		vb2_dvb_dealloc_frontends(&dev->frontends);
+		return ret;
+	}
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_300I_DVBT_PAL:
@@ -1876,7 +1885,7 @@ static int dvb_init(struct saa7134_dev *dev)
 	fe0->dvb.frontend->callback = saa7134_tuner_callback;
 
 	/* register everything else */
-	ret = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
+	ret = vb2_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
 					&dev->pci->dev, adapter_nr, 0);
 
 	/* this sequence is necessary to make the tda1004x load its firmware
@@ -1893,16 +1902,17 @@ static int dvb_init(struct saa7134_dev *dev)
 	return ret;
 
 detach_frontend:
-	videobuf_dvb_dealloc_frontends(&dev->frontends);
+	vb2_dvb_dealloc_frontends(&dev->frontends);
+	vb2_queue_release(&fe0->dvb.dvbq);
 	return -EINVAL;
 }
 
 static int dvb_fini(struct saa7134_dev *dev)
 {
-	struct videobuf_dvb_frontend *fe0;
+	struct vb2_dvb_frontend *fe0;
 
 	/* Get the first frontend */
-	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	fe0 = vb2_dvb_get_frontend(&dev->frontends, 1);
 	if (!fe0)
 		return -EINVAL;
 
@@ -1933,7 +1943,8 @@ static int dvb_fini(struct saa7134_dev *dev)
 			}
 		}
 	}
-	videobuf_dvb_unregister_bus(&dev->frontends);
+	vb2_dvb_unregister_bus(&dev->frontends);
+	vb2_queue_release(&fe0->dvb.dvbq);
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 0a9047e..26ddfb9 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -48,21 +48,16 @@ MODULE_PARM_DESC(debug,"enable debug messages");
 
 /* ------------------------------------------------------------------ */
 
-static void ts_reset_encoder(struct saa7134_dev* dev)
-{
-	if (!dev->empress_started)
-		return;
-
-	saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
-	msleep(10);
-	saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
-	msleep(100);
-	dev->empress_started = 0;
-}
-
-static int ts_init_encoder(struct saa7134_dev* dev)
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
+	struct saa7134_dmaqueue *dmaq = vq->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
 	u32 leading_null_bytes = 0;
+	int err;
+
+	err = saa7134_ts_start_streaming(vq, count);
+	if (err)
+		return err;
 
 	/* If more cards start to need this, then this
 	   should probably be added to the card definitions. */
@@ -73,97 +68,44 @@ static int ts_init_encoder(struct saa7134_dev* dev)
 		leading_null_bytes = 1;
 		break;
 	}
-	ts_reset_encoder(dev);
 	saa_call_all(dev, core, init, leading_null_bytes);
-	dev->empress_started = 1;
-	return 0;
-}
-
-/* ------------------------------------------------------------------ */
-
-static int ts_open(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh;
-
-	/* allocate + initialize per filehandle data */
-	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh)
-		return -ENOMEM;
-
-	v4l2_fh_init(&fh->fh, vdev);
-	file->private_data = fh;
-	fh->is_empress = true;
-	v4l2_fh_add(&fh->fh);
-
 	/* Unmute audio */
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
-		saa_readb(SAA7134_AUDIO_MUTE_CTRL) & ~(1 << 6));
-
+			saa_readb(SAA7134_AUDIO_MUTE_CTRL) & ~(1 << 6));
+	dev->empress_started = 1;
 	return 0;
 }
 
-static int ts_release(struct file *file)
+static int stop_streaming(struct vb2_queue *vq)
 {
-	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh = file->private_data;
-
-	if (res_check(fh, RESOURCE_EMPRESS)) {
-		videobuf_stop(&dev->empress_tsq);
-		videobuf_mmap_free(&dev->empress_tsq);
+	struct saa7134_dmaqueue *dmaq = vq->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
 
-		/* stop the encoder */
-		ts_reset_encoder(dev);
-
-		/* Mute audio */
-		saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
-				saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
-	}
-
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
+	saa7134_ts_stop_streaming(vq);
+	saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
+	msleep(20);
+	saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
+	msleep(100);
+	/* Mute audio */
+	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
+			saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
+	dev->empress_started = 0;
 	return 0;
 }
 
-static ssize_t
-ts_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-
-	if (res_locked(dev, RESOURCE_EMPRESS))
-		return -EBUSY;
-	if (!dev->empress_started)
-		ts_init_encoder(dev);
-
-	return videobuf_read_stream(&dev->empress_tsq,
-				    data, count, ppos, 0,
-				    file->f_flags & O_NONBLOCK);
-}
-
-static unsigned int
-ts_poll(struct file *file, struct poll_table_struct *wait)
-{
-	unsigned long req_events = poll_requested_events(wait);
-	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh = file->private_data;
-	unsigned int rc = 0;
-
-	if (v4l2_event_pending(&fh->fh))
-		rc = POLLPRI;
-	else if (req_events & POLLPRI)
-		poll_wait(file, &fh->fh.wait, wait);
-	return rc | videobuf_poll_stream(file, &dev->empress_tsq, wait);
-}
-
-
-static int
-ts_mmap(struct file *file, struct vm_area_struct * vma)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
+static struct vb2_ops saa7134_empress_qops = {
+	.queue_setup	= saa7134_ts_queue_setup,
+	.buf_init	= saa7134_ts_buffer_init,
+	.buf_prepare	= saa7134_ts_buffer_prepare,
+	.buf_finish	= saa7134_ts_buffer_finish,
+	.buf_queue	= saa7134_vb2_buffer_queue,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
+};
 
-	return videobuf_mmap_mapper(&dev->empress_tsq, vma);
-}
+/* ------------------------------------------------------------------ */
 
 static int empress_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
@@ -233,11 +175,11 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 static const struct v4l2_file_operations ts_fops =
 {
 	.owner	  = THIS_MODULE,
-	.open	  = ts_open,
-	.release  = ts_release,
-	.read	  = ts_read,
-	.poll	  = ts_poll,
-	.mmap	  = ts_mmap,
+	.open	  = v4l2_fh_open,
+	.release  = vb2_fop_release,
+	.read	  = vb2_fop_read,
+	.poll	  = vb2_fop_poll,
+	.mmap	  = vb2_fop_mmap,
 	.ioctl	  = video_ioctl2,
 };
 
@@ -247,12 +189,12 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap		= empress_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= empress_s_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap		= empress_g_fmt_vid_cap,
-	.vidioc_reqbufs			= saa7134_reqbufs,
-	.vidioc_querybuf		= saa7134_querybuf,
-	.vidioc_qbuf			= saa7134_qbuf,
-	.vidioc_dqbuf			= saa7134_dqbuf,
-	.vidioc_streamon		= saa7134_streamon,
-	.vidioc_streamoff		= saa7134_streamoff,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	.vidioc_g_frequency		= saa7134_g_frequency,
 	.vidioc_s_frequency		= saa7134_s_frequency,
 	.vidioc_g_tuner			= saa7134_g_tuner,
@@ -314,6 +256,7 @@ static bool empress_ctrl_filter(const struct v4l2_ctrl *ctrl)
 static int empress_init(struct saa7134_dev *dev)
 {
 	struct v4l2_ctrl_handler *hdl = &dev->empress_ctrl_handler;
+	struct vb2_queue *q;
 	int err;
 
 	dprintk("%s: %s\n",dev->name,__func__);
@@ -323,6 +266,7 @@ static int empress_init(struct saa7134_dev *dev)
 	*(dev->empress_dev) = saa7134_empress_template;
 	dev->empress_dev->v4l2_dev  = &dev->v4l2_dev;
 	dev->empress_dev->release = video_device_release;
+	dev->empress_dev->lock = &dev->lock;
 	snprintf(dev->empress_dev->name, sizeof(dev->empress_dev->name),
 		 "%s empress (%s)", dev->name,
 		 saa7134_boards[dev->board].name);
@@ -339,6 +283,26 @@ static int empress_init(struct saa7134_dev *dev)
 
 	INIT_WORK(&dev->empress_workqueue, empress_signal_update);
 
+	q = &dev->ts_q.q;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	/*
+	 * Do not add VB2_USERPTR: the saa7134 DMA engine cannot handle
+	 * transfers that do not start at the beginning of a page. A USERPTR
+	 * can start anywhere in a page, so USERPTR support is a no-go.
+	 */
+	q->io_modes = VB2_MMAP | VB2_READ;
+	q->drv_priv = &dev->ts_q;
+	q->ops = &saa7134_empress_qops;
+	q->gfp_flags = GFP_DMA32;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->buf_struct_size = sizeof(struct saa7134_buf);
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &dev->lock;
+	err = vb2_queue_init(q);
+	if (err)
+		return err;
+	dev->empress_dev->queue = q;
+
 	video_set_drvdata(dev->empress_dev, dev);
 	err = video_register_device(dev->empress_dev,VFL_TYPE_GRABBER,
 				    empress_nr[dev->nr]);
@@ -352,13 +316,6 @@ static int empress_init(struct saa7134_dev *dev)
 	printk(KERN_INFO "%s: registered device %s [mpeg]\n",
 	       dev->name, video_device_node_name(dev->empress_dev));
 
-	videobuf_queue_sg_init(&dev->empress_tsq, &saa7134_ts_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			    V4L2_FIELD_ALTERNATE,
-			    sizeof(struct saa7134_buf),
-			    dev, NULL);
-
 	empress_signal_update(&dev->empress_workqueue);
 	return 0;
 }
@@ -371,6 +328,7 @@ static int empress_fini(struct saa7134_dev *dev)
 		return 0;
 	flush_work(&dev->empress_workqueue);
 	video_unregister_device(dev->empress_dev);
+	vb2_queue_release(&dev->ts_q.q);
 	v4l2_ctrl_handler_free(&dev->empress_ctrl_handler);
 	dev->empress_dev = NULL;
 	return 0;
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 2e3f4b4..9522d35 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -39,26 +39,29 @@ MODULE_PARM_DESC(ts_debug,"enable debug messages [ts]");
 	printk(KERN_DEBUG "%s/ts: " fmt, dev->name , ## arg)
 
 /* ------------------------------------------------------------------ */
-
 static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
 
 	dprintk("buffer_activate [%p]",buf);
-	buf->vb.state = VIDEOBUF_ACTIVE;
 	buf->top_seen = 0;
 
+	if (!dev->ts_started)
+		dev->ts_field = V4L2_FIELD_TOP;
+
 	if (NULL == next)
 		next = buf;
-	if (V4L2_FIELD_TOP == buf->vb.field) {
+	if (V4L2_FIELD_TOP == dev->ts_field) {
 		dprintk("- [top]     buf=%p next=%p\n",buf,next);
 		saa_writel(SAA7134_RS_BA1(5),saa7134_buffer_base(buf));
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(next));
+		dev->ts_field = V4L2_FIELD_BOTTOM;
 	} else {
 		dprintk("- [bottom]  buf=%p next=%p\n",buf,next);
 		saa_writel(SAA7134_RS_BA1(5),saa7134_buffer_base(next));
 		saa_writel(SAA7134_RS_BA2(5),saa7134_buffer_base(buf));
+		dev->ts_field = V4L2_FIELD_TOP;
 	}
 
 	/* start DMA */
@@ -72,96 +75,124 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-		enum v4l2_field field)
+int saa7134_ts_buffer_init(struct vb2_buffer *vb2)
+{
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+
+	dmaq->curr = NULL;
+	buf->activate = buffer_activate;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(saa7134_ts_buffer_init);
+
+int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 {
-	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
 	unsigned int lines, llength, size;
-	int err;
+	int ret;
 
-	dprintk("buffer_prepare [%p,%s]\n",buf,v4l2_field_names[field]);
+	dprintk("buffer_prepare [%p]\n", buf);
 
 	llength = TS_PACKET_SIZE;
 	lines = dev->ts.nr_packets;
 
 	size = lines * llength;
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
+	if (vb2_plane_size(vb2, 0) < size)
 		return -EINVAL;
 
-	if (buf->vb.size != size) {
-		saa7134_dma_free(q,buf);
-	}
-
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
+	vb2_set_plane_payload(vb2, 0, size);
+	vb2->v4l2_buf.field = dev->field;
 
-		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-
-		dprintk("buffer_prepare: needs_init\n");
-
-		buf->vb.width  = llength;
-		buf->vb.height = lines;
-		buf->vb.size   = size;
-		buf->pt        = &dev->ts.pt_ts;
-
-		err = videobuf_iolock(q,&buf->vb,NULL);
-		if (err)
-			goto oops;
-		err = saa7134_pgtable_build(dev->pci,buf->pt,
-					    dma->sglist,
-					    dma->sglen,
-					    saa7134_buffer_startpage(buf));
-		if (err)
-			goto oops;
-	}
-
-	buf->vb.state = VIDEOBUF_PREPARED;
-	buf->activate = buffer_activate;
-	buf->vb.field = field;
-	return 0;
-
- oops:
-	saa7134_dma_free(q,buf);
-	return err;
+	ret = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
+	if (!ret)
+		return -EIO;
+	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
+				    saa7134_buffer_startpage(buf));
 }
+EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
-static int
-buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
+void saa7134_ts_buffer_finish(struct vb2_buffer *vb2)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 
-	*size = TS_PACKET_SIZE * dev->ts.nr_packets;
-	if (0 == *count)
-		*count = dev->ts.nr_bufs;
-	*count = saa7134_buffer_count(*size,*count);
+	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
+}
+EXPORT_SYMBOL_GPL(saa7134_ts_buffer_finish);
 
+int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct saa7134_dmaqueue *dmaq = q->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	int size = TS_PACKET_SIZE * dev->ts.nr_packets;
+
+	if (0 == *nbuffers)
+		*nbuffers = dev->ts.nr_bufs;
+	*nbuffers = saa7134_buffer_count(size, *nbuffers);
+	if (*nbuffers < 3)
+		*nbuffers = 3;
+	*nplanes = 1;
+	sizes[0] = size;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_ts_queue_setup);
 
-static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
-
-	saa7134_buffer_queue(dev,&dev->ts_q,buf);
+	struct saa7134_dmaqueue *dmaq = vq->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+
+	/*
+	 * Planar video capture and TS share the same DMA channel,
+	 * so only one can be active at a time.
+	 */
+	if (vb2_is_busy(&dev->vid_q.q) && dev->fmt->planar) {
+		struct saa7134_buf *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &dmaq->queue, entry) {
+			list_del(&buf->entry);
+			vb2_buffer_done(&buf->vb2, VB2_BUF_STATE_QUEUED);
+		}
+		if (dmaq->curr) {
+			vb2_buffer_done(&dmaq->curr->vb2, VB2_BUF_STATE_QUEUED);
+			dmaq->curr = NULL;
+		}
+		return -EBUSY;
+	}
+	dmaq->seq_nr = 0;
+	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_ts_start_streaming);
 
-static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+int saa7134_ts_stop_streaming(struct vb2_queue *vq)
 {
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
-	struct saa7134_dev *dev = q->priv_data;
-
-	if (dev->ts_started)
-		saa7134_ts_stop(dev);
+	struct saa7134_dmaqueue *dmaq = vq->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
 
-	saa7134_dma_free(q,buf);
+	saa7134_ts_stop(dev);
+	saa7134_stop_streaming(dev, dmaq);
+	return 0;
 }
-
-struct videobuf_queue_ops saa7134_ts_qops = {
-	.buf_setup    = buffer_setup,
-	.buf_prepare  = buffer_prepare,
-	.buf_queue    = buffer_queue,
-	.buf_release  = buffer_release,
+EXPORT_SYMBOL_GPL(saa7134_ts_stop_streaming);
+
+struct vb2_ops saa7134_ts_qops = {
+	.queue_setup	= saa7134_ts_queue_setup,
+	.buf_init	= saa7134_ts_buffer_init,
+	.buf_prepare	= saa7134_ts_buffer_prepare,
+	.buf_finish	= saa7134_ts_buffer_finish,
+	.buf_queue	= saa7134_vb2_buffer_queue,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+	.stop_streaming = saa7134_ts_stop_streaming,
 };
 EXPORT_SYMBOL_GPL(saa7134_ts_qops);
 
@@ -213,7 +244,7 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
 	dev->ts_started            = 0;
-	saa7134_pgtable_alloc(dev->pci,&dev->ts.pt_ts);
+	saa7134_pgtable_alloc(dev->pci, &dev->ts_q.pt);
 
 	/* init TS hw */
 	saa7134_ts_init_hw(dev);
@@ -226,7 +257,8 @@ int saa7134_ts_stop(struct saa7134_dev *dev)
 {
 	dprintk("TS stop\n");
 
-	BUG_ON(!dev->ts_started);
+	if (!dev->ts_started)
+		return 0;
 
 	/* Stop TS stream */
 	switch (saa7134_boards[dev->board].ts_type) {
@@ -247,7 +279,8 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 {
 	dprintk("TS start\n");
 
-	BUG_ON(dev->ts_started);
+	if (WARN_ON(dev->ts_started))
+		return 0;
 
 	/* dma: setup channel 5 (= TS) */
 	saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
@@ -259,7 +292,7 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 	saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
 	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
 					  SAA7134_RS_CONTROL_ME |
-					  (dev->ts.pt_ts.dma >> 12));
+					  (dev->ts_q.pt.dma >> 12));
 
 	/* reset hardware TS buffers */
 	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
@@ -293,7 +326,7 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 
 int saa7134_ts_fini(struct saa7134_dev *dev)
 {
-	saa7134_pgtable_free(dev->pci,&dev->ts.pt_ts);
+	saa7134_pgtable_free(dev->pci, &dev->ts_q.pt);
 	return 0;
 }
 
@@ -303,15 +336,15 @@ void saa7134_irq_ts_done(struct saa7134_dev *dev, unsigned long status)
 
 	spin_lock(&dev->slock);
 	if (dev->ts_q.curr) {
-		field = dev->ts_q.curr->vb.field;
-		if (field == V4L2_FIELD_TOP) {
+		field = dev->ts_field;
+		if (field != V4L2_FIELD_TOP) {
 			if ((status & 0x100000) != 0x000000)
 				goto done;
 		} else {
 			if ((status & 0x100000) != 0x100000)
 				goto done;
 		}
-		saa7134_buffer_finish(dev,&dev->ts_q,VIDEOBUF_DONE);
+		saa7134_buffer_finish(dev, &dev->ts_q, VB2_BUF_STATE_DONE);
 	}
 	saa7134_buffer_next(dev,&dev->ts_q);
 
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index d4da18d..ec6e290 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -67,28 +67,27 @@ static void task_init(struct saa7134_dev *dev, struct saa7134_buf *buf,
 	saa_writeb(SAA7134_VBI_PHASE_OFFSET_LUMA(task),   0x00);
 	saa_writeb(SAA7134_VBI_PHASE_OFFSET_CHROMA(task), 0x00);
 
-	saa_writeb(SAA7134_VBI_H_LEN1(task), buf->vb.width   & 0xff);
-	saa_writeb(SAA7134_VBI_H_LEN2(task), buf->vb.width   >> 8);
-	saa_writeb(SAA7134_VBI_V_LEN1(task), buf->vb.height  & 0xff);
-	saa_writeb(SAA7134_VBI_V_LEN2(task), buf->vb.height  >> 8);
+	saa_writeb(SAA7134_VBI_H_LEN1(task), dev->vbi_hlen & 0xff);
+	saa_writeb(SAA7134_VBI_H_LEN2(task), dev->vbi_hlen >> 8);
+	saa_writeb(SAA7134_VBI_V_LEN1(task), dev->vbi_vlen & 0xff);
+	saa_writeb(SAA7134_VBI_V_LEN2(task), dev->vbi_vlen >> 8);
 
 	saa_andorb(SAA7134_DATA_PATH(task), 0xc0, 0x00);
 }
 
 /* ------------------------------------------------------------------ */
-
 static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
+	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_queue->drv_priv;
 	unsigned long control,base;
 
 	dprintk("buffer_activate [%p]\n",buf);
-	buf->vb.state = VIDEOBUF_ACTIVE;
 	buf->top_seen = 0;
 
-	task_init(dev,buf,TASK_A);
-	task_init(dev,buf,TASK_B);
+	task_init(dev, buf, TASK_A);
+	task_init(dev, buf, TASK_B);
 	saa_writeb(SAA7134_OFMT_DATA_A, 0x06);
 	saa_writeb(SAA7134_OFMT_DATA_B, 0x06);
 
@@ -96,107 +95,95 @@ static int buffer_activate(struct saa7134_dev *dev,
 	base    = saa7134_buffer_base(buf);
 	control = SAA7134_RS_CONTROL_BURST_16 |
 		SAA7134_RS_CONTROL_ME |
-		(buf->pt->dma >> 12);
-	saa_writel(SAA7134_RS_BA1(2),base);
-	saa_writel(SAA7134_RS_BA2(2),base + buf->vb.size/2);
-	saa_writel(SAA7134_RS_PITCH(2),buf->vb.width);
-	saa_writel(SAA7134_RS_CONTROL(2),control);
-	saa_writel(SAA7134_RS_BA1(3),base);
-	saa_writel(SAA7134_RS_BA2(3),base + buf->vb.size/2);
-	saa_writel(SAA7134_RS_PITCH(3),buf->vb.width);
-	saa_writel(SAA7134_RS_CONTROL(3),control);
+		(dmaq->pt.dma >> 12);
+	saa_writel(SAA7134_RS_BA1(2), base);
+	saa_writel(SAA7134_RS_BA2(2), base + dev->vbi_hlen * dev->vbi_vlen);
+	saa_writel(SAA7134_RS_PITCH(2), dev->vbi_hlen);
+	saa_writel(SAA7134_RS_CONTROL(2), control);
+	saa_writel(SAA7134_RS_BA1(3), base);
+	saa_writel(SAA7134_RS_BA2(3), base + dev->vbi_hlen * dev->vbi_vlen);
+	saa_writel(SAA7134_RS_PITCH(3), dev->vbi_hlen);
+	saa_writel(SAA7134_RS_CONTROL(3), control);
 
 	/* start DMA */
 	saa7134_set_dmabits(dev);
-	mod_timer(&dev->vbi_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dmaq->timeout, jiffies+BUFFER_TIMEOUT);
 
 	return 0;
 }
 
-static int buffer_prepare(struct videobuf_queue *q,
-			  struct videobuf_buffer *vb,
-			  enum v4l2_field field)
+static int buffer_init(struct vb2_buffer *vb2)
 {
-	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
-	struct saa7134_tvnorm *norm = dev->tvnorm;
-	unsigned int lines, llength, size;
-	int err;
-
-	lines   = norm->vbi_v_stop_0 - norm->vbi_v_start_0 +1;
-	if (lines > VBI_LINE_COUNT)
-		lines = VBI_LINE_COUNT;
-	llength = VBI_LINE_LENGTH;
-	size = lines * llength * 2;
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
-		return -EINVAL;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 
-	if (buf->vb.size != size)
-		saa7134_dma_free(q,buf);
-
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-
-		buf->vb.width  = llength;
-		buf->vb.height = lines;
-		buf->vb.size   = size;
-		buf->pt        = &dev->pt_vbi;
-
-		err = videobuf_iolock(q,&buf->vb,NULL);
-		if (err)
-			goto oops;
-		err = saa7134_pgtable_build(dev->pci,buf->pt,
-					    dma->sglist,
-					    dma->sglen,
-					    saa7134_buffer_startpage(buf));
-		if (err)
-			goto oops;
-	}
-	buf->vb.state = VIDEOBUF_PREPARED;
+	dmaq->curr = NULL;
 	buf->activate = buffer_activate;
-	buf->vb.field = field;
 	return 0;
-
- oops:
-	saa7134_dma_free(q,buf);
-	return err;
 }
 
-static int
-buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
+static int buffer_prepare(struct vb2_buffer *vb2)
 {
-	struct saa7134_dev *dev = q->priv_data;
-	int llength,lines;
-
-	lines   = dev->tvnorm->vbi_v_stop_0 - dev->tvnorm->vbi_v_start_0 +1;
-	llength = VBI_LINE_LENGTH;
-	*size = lines * llength * 2;
-	if (0 == *count)
-		*count = vbibufs;
-	*count = saa7134_buffer_count(*size,*count);
-	return 0;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+	unsigned int size;
+	int ret;
+
+	size = dev->vbi_hlen * dev->vbi_vlen * 2;
+	if (vb2_plane_size(vb2, 0) < size)
+		return -EINVAL;
+
+	vb2_set_plane_payload(vb2, 0, size);
+
+	ret = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
+	if (!ret)
+		return -EIO;
+	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
+				    saa7134_buffer_startpage(buf));
 }
 
-static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static void buffer_finish(struct vb2_buffer *vb2)
 {
-	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 
-	saa7134_buffer_queue(dev,&dev->vbi_q,buf);
+	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
 }
 
-static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
-
-	saa7134_dma_free(q,buf);
+	struct saa7134_dmaqueue *dmaq = q->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	unsigned int size;
+
+	dev->vbi_vlen = dev->tvnorm->vbi_v_stop_0 - dev->tvnorm->vbi_v_start_0 + 1;
+	if (dev->vbi_vlen > VBI_LINE_COUNT)
+		dev->vbi_vlen = VBI_LINE_COUNT;
+	dev->vbi_hlen = VBI_LINE_LENGTH;
+	size = dev->vbi_hlen * dev->vbi_vlen * 2;
+
+	*nbuffers = saa7134_buffer_count(size, *nbuffers);
+	*nplanes = 1;
+	sizes[0] = size;
+	return 0;
 }
 
-struct videobuf_queue_ops saa7134_vbi_qops = {
-	.buf_setup    = buffer_setup,
-	.buf_prepare  = buffer_prepare,
-	.buf_queue    = buffer_queue,
-	.buf_release  = buffer_release,
+struct vb2_ops saa7134_vbi_qops = {
+	.queue_setup	= queue_setup,
+	.buf_init	= buffer_init,
+	.buf_prepare	= buffer_prepare,
+	.buf_finish	= buffer_finish,
+	.buf_queue	= saa7134_vb2_buffer_queue,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+	.start_streaming = saa7134_vb2_start_streaming,
+	.stop_streaming = saa7134_vb2_stop_streaming,
 };
 
 /* ------------------------------------------------------------------ */
@@ -226,7 +213,6 @@ void saa7134_irq_vbi_done(struct saa7134_dev *dev, unsigned long status)
 {
 	spin_lock(&dev->slock);
 	if (dev->vbi_q.curr) {
-		dev->vbi_fieldcount++;
 		/* make sure we have seen both fields */
 		if ((status & 0x10) == 0x00) {
 			dev->vbi_q.curr->top_seen = 1;
@@ -235,18 +221,10 @@ void saa7134_irq_vbi_done(struct saa7134_dev *dev, unsigned long status)
 		if (!dev->vbi_q.curr->top_seen)
 			goto done;
 
-		dev->vbi_q.curr->vb.field_count = dev->vbi_fieldcount;
-		saa7134_buffer_finish(dev,&dev->vbi_q,VIDEOBUF_DONE);
+		saa7134_buffer_finish(dev, &dev->vbi_q, VB2_BUF_STATE_DONE);
 	}
 	saa7134_buffer_next(dev,&dev->vbi_q);
 
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
index eb472b5..2d678a8 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -381,42 +381,6 @@ static struct saa7134_format* format_by_fourcc(unsigned int fourcc)
 	return NULL;
 }
 
-/* ----------------------------------------------------------------------- */
-/* resource management                                                     */
-
-static int res_get(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int bit)
-{
-	if (fh->resources & bit)
-		/* have it already allocated */
-		return 1;
-
-	/* is it free? */
-	mutex_lock(&dev->lock);
-	if (dev->resources & bit) {
-		/* no, someone else uses it */
-		mutex_unlock(&dev->lock);
-		return 0;
-	}
-	/* it's free, grab it */
-	fh->resources  |= bit;
-	dev->resources |= bit;
-	dprintk("res: get %d\n",bit);
-	mutex_unlock(&dev->lock);
-	return 1;
-}
-
-static
-void res_free(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int bits)
-{
-	BUG_ON((fh->resources & bits) != bits);
-
-	mutex_lock(&dev->lock);
-	fh->resources  &= ~bits;
-	dev->resources &= ~bits;
-	dprintk("res: put %d\n",bits);
-	mutex_unlock(&dev->lock);
-}
-
 /* ------------------------------------------------------------------ */
 
 static void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
@@ -817,35 +781,35 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
+	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_queue->drv_priv;
 	unsigned long base,control,bpl;
 	unsigned long bpl_uv,lines_uv,base2,base3,tmp; /* planar */
 
 	dprintk("buffer_activate buf=%p\n",buf);
-	buf->vb.state = VIDEOBUF_ACTIVE;
 	buf->top_seen = 0;
 
-	set_size(dev,TASK_A,buf->vb.width,buf->vb.height,
-		 V4L2_FIELD_HAS_BOTH(buf->vb.field));
-	if (buf->fmt->yuv)
+	set_size(dev, TASK_A, dev->width, dev->height,
+		 V4L2_FIELD_HAS_BOTH(dev->field));
+	if (dev->fmt->yuv)
 		saa_andorb(SAA7134_DATA_PATH(TASK_A), 0x3f, 0x03);
 	else
 		saa_andorb(SAA7134_DATA_PATH(TASK_A), 0x3f, 0x01);
-	saa_writeb(SAA7134_OFMT_VIDEO_A, buf->fmt->pm);
+	saa_writeb(SAA7134_OFMT_VIDEO_A, dev->fmt->pm);
 
 	/* DMA: setup channel 0 (= Video Task A0) */
 	base  = saa7134_buffer_base(buf);
-	if (buf->fmt->planar)
-		bpl = buf->vb.width;
+	if (dev->fmt->planar)
+		bpl = dev->width;
 	else
-		bpl = (buf->vb.width * buf->fmt->depth) / 8;
+		bpl = (dev->width * dev->fmt->depth) / 8;
 	control = SAA7134_RS_CONTROL_BURST_16 |
 		SAA7134_RS_CONTROL_ME |
-		(buf->pt->dma >> 12);
-	if (buf->fmt->bswap)
+		(dmaq->pt.dma >> 12);
+	if (dev->fmt->bswap)
 		control |= SAA7134_RS_CONTROL_BSWAP;
-	if (buf->fmt->wswap)
+	if (dev->fmt->wswap)
 		control |= SAA7134_RS_CONTROL_WSWAP;
-	if (V4L2_FIELD_HAS_BOTH(buf->vb.field)) {
+	if (V4L2_FIELD_HAS_BOTH(dev->field)) {
 		/* interlaced */
 		saa_writel(SAA7134_RS_BA1(0),base);
 		saa_writel(SAA7134_RS_BA2(0),base+bpl);
@@ -858,17 +822,17 @@ static int buffer_activate(struct saa7134_dev *dev,
 	}
 	saa_writel(SAA7134_RS_CONTROL(0),control);
 
-	if (buf->fmt->planar) {
+	if (dev->fmt->planar) {
 		/* DMA: setup channel 4+5 (= planar task A) */
-		bpl_uv   = bpl >> buf->fmt->hshift;
-		lines_uv = buf->vb.height >> buf->fmt->vshift;
-		base2    = base + bpl * buf->vb.height;
+		bpl_uv   = bpl >> dev->fmt->hshift;
+		lines_uv = dev->height >> dev->fmt->vshift;
+		base2    = base + bpl * dev->height;
 		base3    = base2 + bpl_uv * lines_uv;
-		if (buf->fmt->uvswap)
+		if (dev->fmt->uvswap)
 			tmp = base2, base2 = base3, base3 = tmp;
 		dprintk("uv: bpl=%ld lines=%ld base2/3=%ld/%ld\n",
 			bpl_uv,lines_uv,base2,base3);
-		if (V4L2_FIELD_HAS_BOTH(buf->vb.field)) {
+		if (V4L2_FIELD_HAS_BOTH(dev->field)) {
 			/* interlaced */
 			saa_writel(SAA7134_RS_BA1(4),base2);
 			saa_writel(SAA7134_RS_BA2(4),base2+bpl_uv);
@@ -891,22 +855,61 @@ static int buffer_activate(struct saa7134_dev *dev,
 
 	/* start DMA */
 	saa7134_set_dmabits(dev);
-	mod_timer(&dev->video_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dmaq->timeout, jiffies + BUFFER_TIMEOUT);
 	return 0;
 }
 
-static int buffer_prepare(struct videobuf_queue *q,
-			  struct videobuf_buffer *vb,
-			  enum v4l2_field field)
+static int buffer_init(struct vb2_buffer *vb2)
 {
-	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+
+	dmaq->curr = NULL;
+	buf->activate = buffer_activate;
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb2)
+{
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 	unsigned int size;
-	int err;
+	int ret;
 
-	/* sanity checks */
-	if (NULL == dev->fmt)
+	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
+	if (vb2_plane_size(vb2, 0) < size)
 		return -EINVAL;
+
+	vb2_set_plane_payload(vb2, 0, size);
+	vb2->v4l2_buf.field = dev->field;
+
+	ret = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
+	if (!ret)
+		return -EIO;
+	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
+				    saa7134_buffer_startpage(buf));
+}
+
+static void buffer_finish(struct vb2_buffer *vb2)
+{
+	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+
+	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
+}
+
+static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct saa7134_dmaqueue *dmaq = q->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	int size = dev->fmt->depth * dev->width * dev->height >> 3;
+
 	if (dev->width    < 48 ||
 	    dev->height   < 32 ||
 	    dev->width/4  > dev->crop_current.width  ||
@@ -914,83 +917,89 @@ static int buffer_prepare(struct videobuf_queue *q,
 	    dev->width    > dev->crop_bounds.width  ||
 	    dev->height   > dev->crop_bounds.height)
 		return -EINVAL;
-	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
-		return -EINVAL;
 
-	dprintk("buffer_prepare [%d,size=%dx%d,bytes=%d,fields=%s,%s]\n",
-		vb->i, dev->width, dev->height, size, v4l2_field_names[field],
-		dev->fmt->name);
-	if (buf->vb.width  != dev->width  ||
-	    buf->vb.height != dev->height ||
-	    buf->vb.size   != size       ||
-	    buf->vb.field  != field      ||
-	    buf->fmt       != dev->fmt) {
-		saa7134_dma_free(q,buf);
-	}
-
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-
-		buf->vb.width  = dev->width;
-		buf->vb.height = dev->height;
-		buf->vb.size   = size;
-		buf->vb.field  = field;
-		buf->fmt       = dev->fmt;
-		buf->pt        = &dev->pt_cap;
-		dev->video_q.curr = NULL;
-
-		err = videobuf_iolock(q,&buf->vb,&dev->ovbuf);
-		if (err)
-			goto oops;
-		err = saa7134_pgtable_build(dev->pci,buf->pt,
-					    dma->sglist,
-					    dma->sglen,
-					    saa7134_buffer_startpage(buf));
-		if (err)
-			goto oops;
-	}
-	buf->vb.state = VIDEOBUF_PREPARED;
-	buf->activate = buffer_activate;
+	*nbuffers = saa7134_buffer_count(size, *nbuffers);
+	*nplanes = 1;
+	sizes[0] = size;
 	return 0;
-
- oops:
-	saa7134_dma_free(q,buf);
-	return err;
 }
 
-static int
-buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
+/*
+ * move buffer to hardware queue
+ */
+void saa7134_vb2_buffer_queue(struct vb2_buffer *vb)
 {
-	struct saa7134_dev *dev = q->priv_data;
+	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb2);
 
-	*size = dev->fmt->depth * dev->width * dev->height >> 3;
-	if (0 == *count)
-		*count = gbuffers;
-	*count = saa7134_buffer_count(*size,*count);
-	return 0;
+	saa7134_buffer_queue(dev, dmaq, buf);
 }
+EXPORT_SYMBOL_GPL(saa7134_vb2_buffer_queue);
 
-static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+int saa7134_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct saa7134_dev *dev = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_dmaqueue *dmaq = vq->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
+
+	/*
+	 * Planar video capture and TS share the same DMA channel,
+	 * so only one can be active at a time.
+	 */
+	if (card_is_empress(dev) && vb2_is_busy(&dev->ts_q.q) &&
+	    dmaq == &dev->vid_q && dev->fmt->planar) {
+		struct saa7134_buf *buf, *tmp;
 
-	saa7134_buffer_queue(dev, &dev->video_q, buf);
+		list_for_each_entry_safe(buf, tmp, &dmaq->queue, entry) {
+			list_del(&buf->entry);
+			vb2_buffer_done(&buf->vb2, VB2_BUF_STATE_QUEUED);
+		}
+		if (dmaq->curr) {
+			vb2_buffer_done(&dmaq->curr->vb2, VB2_BUF_STATE_QUEUED);
+			dmaq->curr = NULL;
+		}
+		return -EBUSY;
+	}
+
+	/* The SAA7134 has a 1K FIFO; the datasheet suggests that when
+	 * configured conservatively, there's 22 usec of buffering for video.
+	 * We therefore request a DMA latency of 20 usec, giving us 2 usec of
+	 * margin in case the FIFO is configured differently to the datasheet.
+	 * Unfortunately, I lack register-level documentation to check the
+	 * Linux FIFO setup and confirm the perfect value.
+	 */
+	if ((dmaq == &dev->vid_q && !vb2_is_streaming(&dev->vbi_q.q)) ||
+	    (dmaq == &dev->vbi_q && !vb2_is_streaming(&dev->vid_q.q)))
+		pm_qos_add_request(&dev->qos_request,
+			PM_QOS_CPU_DMA_LATENCY, 20);
+	dmaq->seq_nr = 0;
+
+	return 0;
 }
 
-static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+int saa7134_vb2_stop_streaming(struct vb2_queue *vq)
 {
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_dmaqueue *dmaq = vq->drv_priv;
+	struct saa7134_dev *dev = dmaq->dev;
 
-	saa7134_dma_free(q,buf);
+	saa7134_stop_streaming(dev, dmaq);
+
+	if ((dmaq == &dev->vid_q && !vb2_is_streaming(&dev->vbi_q.q)) ||
+	    (dmaq == &dev->vbi_q && !vb2_is_streaming(&dev->vid_q.q)))
+		pm_qos_remove_request(&dev->qos_request);
+	return 0;
 }
 
-static struct videobuf_queue_ops video_qops = {
-	.buf_setup    = buffer_setup,
-	.buf_prepare  = buffer_prepare,
-	.buf_queue    = buffer_queue,
-	.buf_release  = buffer_release,
+static struct vb2_ops vb2_qops = {
+	.queue_setup	= queue_setup,
+	.buf_init	= buffer_init,
+	.buf_prepare	= buffer_prepare,
+	.buf_finish	= buffer_finish,
+	.buf_queue	= saa7134_vb2_buffer_queue,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+	.start_streaming = saa7134_vb2_start_streaming,
+	.stop_streaming = saa7134_vb2_stop_streaming,
 };
 
 /* ------------------------------------------------------------------ */
@@ -1068,7 +1077,7 @@ static int saa7134_s_ctrl(struct v4l2_ctrl *ctrl)
 	default:
 		return -EINVAL;
 	}
-	if (restart_overlay && res_locked(dev, RESOURCE_OVERLAY)) {
+	if (restart_overlay && dev->overlay_owner) {
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		start_preview(dev);
@@ -1079,182 +1088,57 @@ static int saa7134_s_ctrl(struct v4l2_ctrl *ctrl)
 
 /* ------------------------------------------------------------------ */
 
-static struct videobuf_queue *saa7134_queue(struct file *file)
+static inline struct vb2_queue *saa7134_queue(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh = file->private_data;
-	struct videobuf_queue *q = NULL;
-
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		q = fh->is_empress ? &dev->empress_tsq : &dev->cap;
-		break;
-	case VFL_TYPE_VBI:
-		q = &dev->vbi;
-		break;
-	default:
-		BUG();
-	}
-	return q;
-}
-
-static int saa7134_resource(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct saa7134_fh *fh = file->private_data;
-
-	if (vdev->vfl_type == VFL_TYPE_GRABBER)
-		return fh->is_empress ? RESOURCE_EMPRESS : RESOURCE_VIDEO;
-
-	if (vdev->vfl_type == VFL_TYPE_VBI)
-		return RESOURCE_VBI;
-
-	BUG();
-	return 0;
+	return video_devdata(file)->queue;
 }
 
 static int video_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh;
-
-	/* allocate + initialize per filehandle data */
-	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
-	if (NULL == fh)
-		return -ENOMEM;
+	int ret = v4l2_fh_open(file);
 
-	v4l2_fh_init(&fh->fh, vdev);
-	file->private_data = fh;
+	if (ret < 0)
+		return ret;
 
+	mutex_lock(&dev->lock);
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
-	v4l2_fh_add(&fh->fh);
+	mutex_unlock(&dev->lock);
 
 	return 0;
 }
 
-static ssize_t
-video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh = file->private_data;
-
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		if (res_locked(dev, RESOURCE_VIDEO))
-			return -EBUSY;
-		return videobuf_read_one(saa7134_queue(file),
-					 data, count, ppos,
-					 file->f_flags & O_NONBLOCK);
-	case VFL_TYPE_VBI:
-		if (!res_get(dev, fh, RESOURCE_VBI))
-			return -EBUSY;
-		return videobuf_read_stream(saa7134_queue(file),
-					    data, count, ppos, 1,
-					    file->f_flags & O_NONBLOCK);
-		break;
-	default:
-		BUG();
-		return 0;
-	}
-}
-
-static unsigned int
-video_poll(struct file *file, struct poll_table_struct *wait)
-{
-	unsigned long req_events = poll_requested_events(wait);
-	struct video_device *vdev = video_devdata(file);
-	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh = file->private_data;
-	struct videobuf_buffer *buf = NULL;
-	unsigned int rc = 0;
-
-	if (v4l2_event_pending(&fh->fh))
-		rc = POLLPRI;
-	else if (req_events & POLLPRI)
-		poll_wait(file, &fh->fh.wait, wait);
-
-	if (vdev->vfl_type == VFL_TYPE_VBI)
-		return rc | videobuf_poll_stream(file, &dev->vbi, wait);
-
-	if (res_check(fh, RESOURCE_VIDEO)) {
-		mutex_lock(&dev->cap.vb_lock);
-		if (!list_empty(&dev->cap.stream))
-			buf = list_entry(dev->cap.stream.next, struct videobuf_buffer, stream);
-	} else {
-		mutex_lock(&dev->cap.vb_lock);
-		if (UNSET == dev->cap.read_off) {
-			/* need to capture a new frame */
-			if (res_locked(dev, RESOURCE_VIDEO))
-				goto err;
-			if (0 != dev->cap.ops->buf_prepare(&dev->cap,
-					dev->cap.read_buf, dev->cap.field))
-				goto err;
-			dev->cap.ops->buf_queue(&dev->cap, dev->cap.read_buf);
-			dev->cap.read_off = 0;
-		}
-		buf = dev->cap.read_buf;
-	}
-
-	if (!buf)
-		goto err;
-
-	poll_wait(file, &buf->done, wait);
-	if (buf->state == VIDEOBUF_DONE || buf->state == VIDEOBUF_ERROR)
-		rc |= POLLIN | POLLRDNORM;
-	mutex_unlock(&dev->cap.vb_lock);
-	return rc;
-
-err:
-	mutex_unlock(&dev->cap.vb_lock);
-	return rc | POLLERR;
-}
-
 static int video_release(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh = file->private_data;
+	struct v4l2_fh *fh = file->private_data;
 	struct saa6588_command cmd;
 	unsigned long flags;
 
+	mutex_lock(&dev->lock);
 	saa7134_tvaudio_close(dev);
 
 	/* turn off overlay */
-	if (res_check(fh, RESOURCE_OVERLAY)) {
+	if (fh == dev->overlay_owner) {
 		spin_lock_irqsave(&dev->slock,flags);
 		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock,flags);
-		res_free(dev, fh, RESOURCE_OVERLAY);
+		dev->overlay_owner = NULL;
 	}
 
-	/* stop video capture */
-	if (res_check(fh, RESOURCE_VIDEO)) {
-		pm_qos_remove_request(&dev->qos_request);
-		videobuf_streamoff(&dev->cap);
-		res_free(dev, fh, RESOURCE_VIDEO);
-		videobuf_mmap_free(&dev->cap);
-	}
-	if (dev->cap.read_buf) {
-		buffer_release(&dev->cap, dev->cap.read_buf);
-		kfree(dev->cap.read_buf);
-	}
-
-	/* stop vbi capture */
-	if (res_check(fh, RESOURCE_VBI)) {
-		videobuf_stop(&dev->vbi);
-		res_free(dev, fh, RESOURCE_VBI);
-		videobuf_mmap_free(&dev->vbi);
-	}
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		v4l2_fh_release(file);
+	else
+		_vb2_fop_release(file, NULL);
 
 	/* ts-capture will not work in planar mode, so turn it off Hac: 04.05*/
 	saa_andorb(SAA7134_OFMT_VIDEO_A, 0x1f, 0);
@@ -1265,19 +1149,11 @@ static int video_release(struct file *file)
 	saa_call_all(dev, core, s_power, 0);
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
 		saa_call_all(dev, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
+	mutex_unlock(&dev->lock);
 
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
-	file->private_data = NULL;
-	kfree(fh);
 	return 0;
 }
 
-static int video_mmap(struct file *file, struct vm_area_struct * vma)
-{
-	return videobuf_mmap_mapper(saa7134_queue(file), vma);
-}
-
 static ssize_t radio_read(struct file *file, char __user *data,
 			 size_t count, loff_t *ppos)
 {
@@ -1290,7 +1166,9 @@ static ssize_t radio_read(struct file *file, char __user *data,
 	cmd.instance = file;
 	cmd.result = -ENODEV;
 
+	mutex_lock(&dev->lock);
 	saa_call_all(dev, core, ioctl, SAA6588_CMD_READ, &cmd);
+	mutex_unlock(&dev->lock);
 
 	return cmd.result;
 }
@@ -1304,7 +1182,9 @@ static unsigned int radio_poll(struct file *file, poll_table *wait)
 	cmd.instance = file;
 	cmd.event_list = wait;
 	cmd.result = 0;
+	mutex_lock(&dev->lock);
 	saa_call_all(dev, core, ioctl, SAA6588_CMD_POLL, &cmd);
+	mutex_unlock(&dev->lock);
 
 	return rc | cmd.result;
 }
@@ -1338,7 +1218,7 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = dev->cap.field;
+	f->fmt.pix.field        = dev->field;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
@@ -1362,7 +1242,6 @@ static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
-	mutex_lock(&dev->lock);
 	f->fmt.win = dev->win;
 	f->fmt.win.clips = clips;
 	if (clips == NULL)
@@ -1376,7 +1255,6 @@ static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 					sizeof(struct v4l2_rect)))
 			err = -EFAULT;
 	}
-	mutex_unlock(&dev->lock);
 
 	return err;
 }
@@ -1457,10 +1335,10 @@ static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 	if (0 != err)
 		return err;
 
-	dev->fmt       = format_by_fourcc(f->fmt.pix.pixelformat);
-	dev->width     = f->fmt.pix.width;
-	dev->height    = f->fmt.pix.height;
-	dev->cap.field = f->fmt.pix.field;
+	dev->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
+	dev->width = f->fmt.pix.width;
+	dev->height = f->fmt.pix.height;
+	dev->field = f->fmt.pix.field;
 	return 0;
 }
 
@@ -1481,25 +1359,20 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 	if (0 != err)
 		return err;
 
-	mutex_lock(&dev->lock);
-
 	dev->win    = f->fmt.win;
 	dev->nclips = f->fmt.win.clipcount;
 
 	if (copy_from_user(dev->clips, f->fmt.win.clips,
-			   sizeof(struct v4l2_clip) * dev->nclips)) {
-		mutex_unlock(&dev->lock);
+			   sizeof(struct v4l2_clip) * dev->nclips))
 		return -EFAULT;
-	}
 
-	if (res_check(priv, RESOURCE_OVERLAY)) {
+	if (priv == dev->overlay_owner) {
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		start_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 	}
 
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -1551,9 +1424,7 @@ int saa7134_s_input(struct file *file, void *priv, unsigned int i)
 		return -EINVAL;
 	if (NULL == card_in(dev, i).name)
 		return -EINVAL;
-	mutex_lock(&dev->lock);
 	video_mux(dev, i);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(saa7134_s_input);
@@ -1563,7 +1434,6 @@ int saa7134_querycap(struct file *file, void *priv,
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
-	struct saa7134_fh *fh = priv;
 	u32 radio_caps, video_caps, vbi_caps;
 
 	unsigned int tuner_type = dev->tuner_type;
@@ -1582,7 +1452,7 @@ int saa7134_querycap(struct file *file, void *priv,
 		radio_caps |= V4L2_CAP_RDS_CAPTURE;
 
 	video_caps = V4L2_CAP_VIDEO_CAPTURE;
-	if (saa7134_no_overlay <= 0 && !fh->is_empress)
+	if (saa7134_no_overlay <= 0 && !is_empress(file))
 		video_caps |= V4L2_CAP_VIDEO_OVERLAY;
 
 	vbi_caps = V4L2_CAP_VBI_CAPTURE;
@@ -1613,12 +1483,12 @@ EXPORT_SYMBOL_GPL(saa7134_querycap);
 int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
-	struct saa7134_fh *fh = priv;
+	struct v4l2_fh *fh = priv;
 	unsigned long flags;
 	unsigned int i;
 	v4l2_std_id fixup;
 
-	if (fh->is_empress && res_locked(dev, RESOURCE_OVERLAY)) {
+	if (is_empress(file) && dev->overlay_owner) {
 		/* Don't change the std from the mpeg device
 		   if overlay is active. */
 		return -EBUSY;
@@ -1657,8 +1527,7 @@ int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
 
 	id = tvnorms[i].id;
 
-	mutex_lock(&dev->lock);
-	if (!fh->is_empress && res_check(fh, RESOURCE_OVERLAY)) {
+	if (!is_empress(file) && fh == dev->overlay_owner) {
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
@@ -1672,7 +1541,6 @@ int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
 		set_tvnorm(dev, &tvnorms[i]);
 
 	saa7134_tvaudio_do_scan(dev);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(saa7134_s_std);
@@ -1730,9 +1598,9 @@ static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *cr
 	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
 
-	if (res_locked(dev, RESOURCE_OVERLAY))
+	if (dev->overlay_owner)
 		return -EBUSY;
-	if (res_locked(dev, RESOURCE_VIDEO))
+	if (vb2_is_streaming(&dev->vid_q.q))
 		return -EBUSY;
 
 	*c = crop->c;
@@ -1826,12 +1694,10 @@ int saa7134_s_frequency(struct file *file, void *priv,
 
 	if (0 != f->tuner)
 		return -EINVAL;
-	mutex_lock(&dev->lock);
 
 	saa_call_all(dev, tuner, s_frequency, f);
 
 	saa7134_tvaudio_do_scan(dev);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(saa7134_s_frequency);
@@ -1915,92 +1781,24 @@ static int saa7134_overlay(struct file *file, void *priv, unsigned int on)
 			return -EINVAL;
 		}
 
-		if (!res_get(dev, priv, RESOURCE_OVERLAY))
+		if (dev->overlay_owner && priv != dev->overlay_owner)
 			return -EBUSY;
+		dev->overlay_owner = priv;
 		spin_lock_irqsave(&dev->slock, flags);
 		start_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 	}
 	if (!on) {
-		if (!res_check(priv, RESOURCE_OVERLAY))
+		if (priv != dev->overlay_owner)
 			return -EINVAL;
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
-		res_free(dev, priv, RESOURCE_OVERLAY);
+		dev->overlay_owner = NULL;
 	}
 	return 0;
 }
 
-int saa7134_reqbufs(struct file *file, void *priv,
-					struct v4l2_requestbuffers *p)
-{
-	return videobuf_reqbufs(saa7134_queue(file), p);
-}
-EXPORT_SYMBOL_GPL(saa7134_reqbufs);
-
-int saa7134_querybuf(struct file *file, void *priv,
-					struct v4l2_buffer *b)
-{
-	return videobuf_querybuf(saa7134_queue(file), b);
-}
-EXPORT_SYMBOL_GPL(saa7134_querybuf);
-
-int saa7134_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	return videobuf_qbuf(saa7134_queue(file), b);
-}
-EXPORT_SYMBOL_GPL(saa7134_qbuf);
-
-int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	return videobuf_dqbuf(saa7134_queue(file), b,
-				file->f_flags & O_NONBLOCK);
-}
-EXPORT_SYMBOL_GPL(saa7134_dqbuf);
-
-int saa7134_streamon(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-	int res = saa7134_resource(file);
-
-	if (!res_get(dev, priv, res))
-		return -EBUSY;
-
-	/* The SAA7134 has a 1K FIFO; the datasheet suggests that when
-	 * configured conservatively, there's 22 usec of buffering for video.
-	 * We therefore request a DMA latency of 20 usec, giving us 2 usec of
-	 * margin in case the FIFO is configured differently to the datasheet.
-	 * Unfortunately, I lack register-level documentation to check the
-	 * Linux FIFO setup and confirm the perfect value.
-	 */
-	if (res != RESOURCE_EMPRESS)
-		pm_qos_add_request(&dev->qos_request,
-			   PM_QOS_CPU_DMA_LATENCY, 20);
-
-	return videobuf_streamon(saa7134_queue(file));
-}
-EXPORT_SYMBOL_GPL(saa7134_streamon);
-
-int saa7134_streamoff(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-	int err;
-	int res = saa7134_resource(file);
-
-	if (res != RESOURCE_EMPRESS)
-		pm_qos_remove_request(&dev->qos_request);
-
-	err = videobuf_streamoff(saa7134_queue(file));
-	if (err < 0)
-		return err;
-	res_free(dev, priv, res);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(saa7134_streamoff);
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register (struct file *file, void *priv,
 			      struct v4l2_dbg_register *reg)
@@ -2058,10 +1856,10 @@ static const struct v4l2_file_operations video_fops =
 	.owner	  = THIS_MODULE,
 	.open	  = video_open,
 	.release  = video_release,
-	.read	  = video_read,
-	.poll     = video_poll,
-	.mmap	  = video_mmap,
-	.ioctl	  = video_ioctl2,
+	.read	  = vb2_fop_read,
+	.poll     = vb2_fop_poll,
+	.mmap	  = vb2_fop_mmap,
+	.unlocked_ioctl	  = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -2078,17 +1876,17 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
 	.vidioc_cropcap			= saa7134_cropcap,
-	.vidioc_reqbufs			= saa7134_reqbufs,
-	.vidioc_querybuf		= saa7134_querybuf,
-	.vidioc_qbuf			= saa7134_qbuf,
-	.vidioc_dqbuf			= saa7134_dqbuf,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
 	.vidioc_s_std			= saa7134_s_std,
 	.vidioc_g_std			= saa7134_g_std,
 	.vidioc_enum_input		= saa7134_enum_input,
 	.vidioc_g_input			= saa7134_g_input,
 	.vidioc_s_input			= saa7134_s_input,
-	.vidioc_streamon		= saa7134_streamon,
-	.vidioc_streamoff		= saa7134_streamoff,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	.vidioc_g_tuner			= saa7134_g_tuner,
 	.vidioc_s_tuner			= saa7134_s_tuner,
 	.vidioc_g_crop			= saa7134_g_crop,
@@ -2112,7 +1910,7 @@ static const struct v4l2_file_operations radio_fops = {
 	.open	  = video_open,
 	.read     = radio_read,
 	.release  = video_release,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.poll     = radio_poll,
 };
 
@@ -2190,6 +1988,8 @@ static const struct v4l2_ctrl_config saa7134_ctrl_automute = {
 int saa7134_video_init1(struct saa7134_dev *dev)
 {
 	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+	struct vb2_queue *q;
+	int ret;
 
 	/* sanitycheck insmod options */
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
@@ -2233,14 +2033,15 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 		dev->tda9887_conf |= TDA9887_AUTOMUTE;
 	dev->automute       = 0;
 
-	INIT_LIST_HEAD(&dev->video_q.queue);
-	init_timer(&dev->video_q.timeout);
-	dev->video_q.timeout.function = saa7134_buffer_timeout;
-	dev->video_q.timeout.data     = (unsigned long)(&dev->video_q);
-	dev->video_q.dev              = dev;
+	INIT_LIST_HEAD(&dev->vid_q.queue);
+	init_timer(&dev->vid_q.timeout);
+	dev->vid_q.timeout.function = saa7134_buffer_timeout;
+	dev->vid_q.timeout.data     = (unsigned long)(&dev->vid_q);
+	dev->vid_q.dev              = dev;
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	dev->width    = 720;
 	dev->height   = 576;
+	dev->field = V4L2_FIELD_INTERLACED;
 	dev->win.w.width = dev->width;
 	dev->win.w.height = dev->height;
 	dev->win.field = V4L2_FIELD_INTERLACED;
@@ -2252,20 +2053,41 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	if (saa7134_boards[dev->board].video_out)
 		saa7134_videoport_init(dev);
 
-	videobuf_queue_sg_init(&dev->cap, &video_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			    V4L2_FIELD_INTERLACED,
-			    sizeof(struct saa7134_buf),
-			    dev, NULL);
-	videobuf_queue_sg_init(&dev->vbi, &saa7134_vbi_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VBI_CAPTURE,
-			    V4L2_FIELD_SEQ_TB,
-			    sizeof(struct saa7134_buf),
-			    dev, NULL);
-	saa7134_pgtable_alloc(dev->pci, &dev->pt_cap);
-	saa7134_pgtable_alloc(dev->pci, &dev->pt_vbi);
+	q = &dev->vid_q.q;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	/*
+	 * Do not add VB2_USERPTR: the saa7134 DMA engine cannot handle
+	 * transfers that do not start at the beginning of a page. A USERPTR
+	 * can start anywhere in a page, so USERPTR support is a no-go.
+	 */
+	q->io_modes = VB2_MMAP | VB2_READ;
+	q->drv_priv = &dev->vid_q;
+	q->ops = &vb2_qops;
+	q->gfp_flags = GFP_DMA32;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->buf_struct_size = sizeof(struct saa7134_buf);
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &dev->lock;
+	ret = vb2_queue_init(q);
+	if (ret)
+		return ret;
+	saa7134_pgtable_alloc(dev->pci, &dev->vid_q.pt);
+
+	q = &dev->vbi_q.q;
+	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
+	/* Don't add VB2_USERPTR, see comment above */
+	q->io_modes = VB2_MMAP | VB2_READ;
+	q->drv_priv = &dev->vbi_q;
+	q->ops = &saa7134_vbi_qops;
+	q->gfp_flags = GFP_DMA32;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->buf_struct_size = sizeof(struct saa7134_buf);
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &dev->lock;
+	ret = vb2_queue_init(q);
+	if (ret)
+		return ret;
+	saa7134_pgtable_alloc(dev->pci, &dev->vbi_q.pt);
 
 	return 0;
 }
@@ -2273,8 +2095,10 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 void saa7134_video_fini(struct saa7134_dev *dev)
 {
 	/* free stuff */
-	saa7134_pgtable_free(dev->pci, &dev->pt_cap);
-	saa7134_pgtable_free(dev->pci, &dev->pt_vbi);
+	vb2_queue_release(&dev->vid_q.q);
+	saa7134_pgtable_free(dev->pci, &dev->vid_q.pt);
+	vb2_queue_release(&dev->vbi_q.q);
+	saa7134_pgtable_free(dev->pci, &dev->vbi_q.pt);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	if (card_has_radio(dev))
 		v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
@@ -2366,16 +2190,15 @@ void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status)
 	enum v4l2_field field;
 
 	spin_lock(&dev->slock);
-	if (dev->video_q.curr) {
-		dev->video_fieldcount++;
-		field = dev->video_q.curr->vb.field;
+	if (dev->vid_q.curr) {
+		field = dev->field;
 		if (V4L2_FIELD_HAS_BOTH(field)) {
 			/* make sure we have seen both fields */
 			if ((status & 0x10) == 0x00) {
-				dev->video_q.curr->top_seen = 1;
+				dev->vid_q.curr->top_seen = 1;
 				goto done;
 			}
-			if (!dev->video_q.curr->top_seen)
+			if (!dev->vid_q.curr->top_seen)
 				goto done;
 		} else if (field == V4L2_FIELD_TOP) {
 			if ((status & 0x10) != 0x10)
@@ -2384,18 +2207,10 @@ void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status)
 			if ((status & 0x10) != 0x00)
 				goto done;
 		}
-		dev->video_q.curr->vb.field_count = dev->video_fieldcount;
-		saa7134_buffer_finish(dev,&dev->video_q,VIDEOBUF_DONE);
+		saa7134_buffer_finish(dev, &dev->vid_q, VB2_BUF_STATE_DONE);
 	}
-	saa7134_buffer_next(dev,&dev->video_q);
+	saa7134_buffer_next(dev, &dev->vid_q);
 
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
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 2474e84..39c3d0d 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -41,11 +41,11 @@
 #include <media/tuner.h>
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #if IS_ENABLED(CONFIG_VIDEO_SAA7134_DVB)
-#include <media/videobuf-dvb.h>
+#include <media/videobuf2-dvb.h>
 #endif
 #include "tda8290.h"
 
@@ -453,17 +453,15 @@ struct saa7134_thread {
 /* buffer for one video/vbi/ts frame */
 struct saa7134_buf {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
+	struct vb2_buffer vb2;
 
 	/* saa7134 specific */
-	struct saa7134_format   *fmt;
 	unsigned int            top_seen;
 	int (*activate)(struct saa7134_dev *dev,
 			struct saa7134_buf *buf,
 			struct saa7134_buf *next);
 
-	/* page tables */
-	struct saa7134_pgtable  *pt;
+	struct list_head	entry;
 };
 
 struct saa7134_dmaqueue {
@@ -472,13 +470,9 @@ struct saa7134_dmaqueue {
 	struct list_head           queue;
 	struct timer_list          timeout;
 	unsigned int               need_two;
-};
-
-/* video filehandle status */
-struct saa7134_fh {
-	struct v4l2_fh             fh;
-	bool			   is_empress;
-	unsigned int               resources;
+	unsigned int               seq_nr;
+	struct saa7134_pgtable     pt;
+	struct vb2_queue           q;
 };
 
 /* dmasound dsp status */
@@ -504,7 +498,10 @@ struct saa7134_dmasound {
 	unsigned int               blksize;
 	unsigned int               bufsize;
 	struct saa7134_pgtable     pt;
-	struct videobuf_dmabuf     dma;
+	void			   *vaddr;
+	struct scatterlist	   *sglist;
+	int                        sglen;
+	int                        nr_pages;
 	unsigned int               dma_blk;
 	unsigned int               read_offset;
 	unsigned int               read_count;
@@ -515,7 +512,6 @@ struct saa7134_dmasound {
 /* ts/mpeg status */
 struct saa7134_ts {
 	/* TS capture */
-	struct saa7134_pgtable     pt_ts;
 	int                        nr_packets;
 	int                        nr_bufs;
 };
@@ -584,21 +580,32 @@ struct saa7134_dev {
 	struct v4l2_window         win;
 	struct v4l2_clip           clips[8];
 	unsigned int               nclips;
+	struct v4l2_fh		   *overlay_owner;
 
 
 	/* video+ts+vbi capture */
-	struct saa7134_dmaqueue    video_q;
-	struct videobuf_queue      cap;
-	struct saa7134_pgtable     pt_cap;
+	struct saa7134_dmaqueue    vid_q;
 	struct saa7134_dmaqueue    vbi_q;
-	struct videobuf_queue      vbi;
-	struct saa7134_pgtable     pt_vbi;
-	unsigned int               video_fieldcount;
-	unsigned int               vbi_fieldcount;
+	enum v4l2_field		   field;
 	struct saa7134_format      *fmt;
 	unsigned int               width, height;
+	unsigned int               vbi_hlen, vbi_vlen;
 	struct pm_qos_request	   qos_request;
 
+	/* SAA7134_MPEG_* */
+	struct saa7134_ts          ts;
+	struct saa7134_dmaqueue    ts_q;
+	enum v4l2_field		   ts_field;
+	int                        ts_started;
+	struct saa7134_mpeg_ops    *mops;
+
+	/* SAA7134_MPEG_EMPRESS only */
+	struct video_device        *empress_dev;
+	struct v4l2_subdev	   *empress_sd;
+	struct work_struct         empress_workqueue;
+	int                        empress_started;
+	struct v4l2_ctrl_handler   empress_ctrl_handler;
+
 	/* various v4l controls */
 	struct saa7134_tvnorm      *tvnorm;              /* video */
 	struct saa7134_tvaudio     *tvaudio;
@@ -635,23 +642,9 @@ struct saa7134_dev {
 	/* I2C keyboard data */
 	struct IR_i2c_init_data    init_data;
 
-	/* SAA7134_MPEG_* */
-	struct saa7134_ts          ts;
-	struct saa7134_dmaqueue    ts_q;
-	int                        ts_started;
-	struct saa7134_mpeg_ops    *mops;
-
-	/* SAA7134_MPEG_EMPRESS only */
-	struct video_device        *empress_dev;
-	struct v4l2_subdev	   *empress_sd;
-	struct videobuf_queue      empress_tsq;
-	struct work_struct         empress_workqueue;
-	int                        empress_started;
-	struct v4l2_ctrl_handler   empress_ctrl_handler;
-
 #if IS_ENABLED(CONFIG_VIDEO_SAA7134_DVB)
 	/* SAA7134_MPEG_DVB only */
-	struct videobuf_dvb_frontends frontends;
+	struct vb2_dvb_frontends frontends;
 	int (*original_demod_sleep)(struct dvb_frontend *fe);
 	int (*original_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
 	int (*original_set_high_voltage)(struct dvb_frontend *fe, long arg);
@@ -705,14 +698,12 @@ struct saa7134_dev {
 	_rc;								\
 })
 
-static inline int res_check(struct saa7134_fh *fh, unsigned int bit)
+static inline bool is_empress(struct file *file)
 {
-	return fh->resources & bit;
-}
+	struct video_device *vdev = video_devdata(file);
+	struct saa7134_dev *dev = video_get_drvdata(vdev);
 
-static inline int res_locked(struct saa7134_dev *dev, unsigned int bit)
-{
-	return dev->resources & bit;
+	return vdev->queue == &dev->ts_q.q;
 }
 
 /* ----------------------------------------------------------- */
@@ -743,7 +734,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev, struct saa7134_dmaqueue *q,
 			   unsigned int state);
 void saa7134_buffer_next(struct saa7134_dev *dev, struct saa7134_dmaqueue *q);
 void saa7134_buffer_timeout(unsigned long data);
-void saa7134_dma_free(struct videobuf_queue *q,struct saa7134_buf *buf);
+void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q);
 
 int saa7134_set_dmabits(struct saa7134_dev *dev);
 
@@ -777,6 +768,10 @@ extern unsigned int video_debug;
 extern struct video_device saa7134_video_template;
 extern struct video_device saa7134_radio_template;
 
+void saa7134_vb2_buffer_queue(struct vb2_buffer *vb);
+int saa7134_vb2_start_streaming(struct vb2_queue *vq, unsigned int count);
+int saa7134_vb2_stop_streaming(struct vb2_queue *vq);
+
 int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id);
 int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id);
 int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i);
@@ -792,16 +787,6 @@ int saa7134_g_frequency(struct file *file, void *priv,
 					struct v4l2_frequency *f);
 int saa7134_s_frequency(struct file *file, void *priv,
 					const struct v4l2_frequency *f);
-int saa7134_reqbufs(struct file *file, void *priv,
-					struct v4l2_requestbuffers *p);
-int saa7134_querybuf(struct file *file, void *priv,
-					struct v4l2_buffer *b);
-int saa7134_qbuf(struct file *file, void *priv, struct v4l2_buffer *b);
-int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b);
-int saa7134_streamon(struct file *file, void *priv,
-					enum v4l2_buf_type type);
-int saa7134_streamoff(struct file *file, void *priv,
-					enum v4l2_buf_type type);
 
 int saa7134_videoport_init(struct saa7134_dev *dev);
 void saa7134_set_tvnorm_hw(struct saa7134_dev *dev);
@@ -818,7 +803,16 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 #define TS_PACKET_SIZE 188 /* TS packets 188 bytes */
 
-extern struct videobuf_queue_ops saa7134_ts_qops;
+int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
+int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
+void saa7134_ts_buffer_finish(struct vb2_buffer *vb2);
+int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[]);
+int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count);
+int saa7134_ts_stop_streaming(struct vb2_queue *vq);
+
+extern struct vb2_ops saa7134_ts_qops;
 
 int saa7134_ts_init1(struct saa7134_dev *dev);
 int saa7134_ts_fini(struct saa7134_dev *dev);
@@ -835,7 +829,7 @@ int saa7134_ts_stop(struct saa7134_dev *dev);
 /* ----------------------------------------------------------- */
 /* saa7134-vbi.c                                               */
 
-extern struct videobuf_queue_ops saa7134_vbi_qops;
+extern struct vb2_ops saa7134_vbi_qops;
 extern struct video_device saa7134_vbi_template;
 
 int saa7134_vbi_init1(struct saa7134_dev *dev);
-- 
1.9.0

