Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60658 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967722AbaLLN24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:28:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/7] cx25821: convert to vb2
Date: Fri, 12 Dec 2014 14:27:58 +0100
Message-Id: <1418390880-39009-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
References: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch converts the cx25821 driver from the old videobuf framework to
the new vb2 framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/Kconfig         |   2 +-
 drivers/media/pci/cx25821/cx25821-core.c  |  76 ++--
 drivers/media/pci/cx25821/cx25821-video.c | 682 ++++++++----------------------
 drivers/media/pci/cx25821/cx25821.h       |  24 +-
 4 files changed, 207 insertions(+), 577 deletions(-)

diff --git a/drivers/media/pci/cx25821/Kconfig b/drivers/media/pci/cx25821/Kconfig
index 0e69cab..1755d3d 100644
--- a/drivers/media/pci/cx25821/Kconfig
+++ b/drivers/media/pci/cx25821/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
 	depends on VIDEO_DEV && PCI && I2C
 	select I2C_ALGOBIT
-	select VIDEOBUF_DMA_SG
+	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a video4linux driver for Conexant 25821 based
 	  TV cards.
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index c8c65b7..c1ea24e 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -874,10 +874,9 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	if (dev->pci->device != 0x8210) {
 		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
 			__func__, dev->pci->device);
-		return -1;
-	} else {
-		pr_info("Athena Hardware device = 0x%02x\n", dev->pci->device);
+		return -ENODEV;
 	}
+	pr_info("Athena Hardware device = 0x%02x\n", dev->pci->device);
 
 	/* Apply a sensible clock frequency for the PCIe bridge */
 	dev->clk_freq = 28000000;
@@ -1003,11 +1002,17 @@ EXPORT_SYMBOL(cx25821_riscmem_alloc);
 static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
 				  unsigned int offset, u32 sync_line,
 				  unsigned int bpl, unsigned int padding,
-				  unsigned int lines)
+				  unsigned int lines, bool jump)
 {
 	struct scatterlist *sg;
 	unsigned int line, todo;
 
+	if (jump) {
+		*(rp++) = cpu_to_le32(RISC_JUMP);
+		*(rp++) = cpu_to_le32(0);
+		*(rp++) = cpu_to_le32(0); /* bits 63-32 */
+	}
+
 	/* sync instruction */
 	if (sync_line != NO_SYNC_LINE)
 		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
@@ -1073,13 +1078,13 @@ int cx25821_risc_buffer(struct pci_dev *pci, struct cx25821_riscmem *risc,
 		fields++;
 
 	/* estimate risc mem: worst case is one write per page border +
-	   one write per scan line + syncs + jump (all 2 dwords).  Padding
+	   one write per scan line + syncs + jump (all 3 dwords).  Padding
 	   can cause next bpl to start close to a page border.  First DMA
 	   region may be smaller than PAGE_SIZE */
 	/* write and jump need and extra dword */
 	instructions = fields * (1 + ((bpl + padding) * lines) / PAGE_SIZE +
 			lines);
-	instructions += 2;
+	instructions += 5;
 	rc = cx25821_riscmem_alloc(pci, risc, instructions * 12);
 
 	if (rc < 0)
@@ -1090,17 +1095,17 @@ int cx25821_risc_buffer(struct pci_dev *pci, struct cx25821_riscmem *risc,
 
 	if (UNSET != top_offset) {
 		rp = cx25821_risc_field(rp, sglist, top_offset, 0, bpl, padding,
-					lines);
+					lines, true);
 	}
 
 	if (UNSET != bottom_offset) {
 		rp = cx25821_risc_field(rp, sglist, bottom_offset, 0x200, bpl,
-					padding, lines);
+					padding, lines, UNSET == top_offset);
 	}
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
-	BUG_ON((risc->jmp - risc->cpu + 2) * sizeof(*risc->cpu) > risc->size);
+	BUG_ON((risc->jmp - risc->cpu + 3) * sizeof(*risc->cpu) > risc->size);
 
 	return 0;
 }
@@ -1200,41 +1205,14 @@ int cx25821_risc_databuffer_audio(struct pci_dev *pci,
 }
 EXPORT_SYMBOL(cx25821_risc_databuffer_audio);
 
-int cx25821_risc_stopper(struct pci_dev *pci, struct cx25821_riscmem *risc,
-			 u32 reg, u32 mask, u32 value)
+void cx25821_free_buffer(struct cx25821_dev *dev, struct cx25821_buffer *buf)
 {
-	__le32 *rp;
-	int rc;
-
-	rc = cx25821_riscmem_alloc(pci, risc, 4 * 16);
-
-	if (rc < 0)
-		return rc;
-
-	/* write risc instructions */
-	rp = risc->cpu;
-
-	*(rp++) = cpu_to_le32(RISC_WRITECR | RISC_IRQ1);
-	*(rp++) = cpu_to_le32(reg);
-	*(rp++) = cpu_to_le32(value);
-	*(rp++) = cpu_to_le32(mask);
-	*(rp++) = cpu_to_le32(RISC_JUMP);
-	*(rp++) = cpu_to_le32(risc->dma);
-	*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
-	return 0;
-}
-
-void cx25821_free_buffer(struct videobuf_queue *q, struct cx25821_buffer *buf)
-{
-	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
-
 	BUG_ON(in_interrupt());
-	videobuf_waiton(q, &buf->vb, 0, 0);
-	videobuf_dma_unmap(q->dev, dma);
-	videobuf_dma_free(dma);
-	pci_free_consistent(to_pci_dev(q->dev),
+	if (WARN_ON(buf->risc.size == 0))
+		return;
+	pci_free_consistent(dev->pci,
 			buf->risc.size, buf->risc.cpu, buf->risc.dma);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+	memset(&buf->risc, 0, sizeof(buf->risc));
 }
 
 static irqreturn_t cx25821_irq(int irq, void *dev_id)
@@ -1319,14 +1297,15 @@ static int cx25821_initdev(struct pci_dev *pci_dev,
 
 		goto fail_unregister_device;
 	}
+	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
+	if (IS_ERR(dev->alloc_ctx)) {
+		err = PTR_ERR(dev->alloc_ctx);
+		goto fail_unregister_pci;
+	}
 
 	err = cx25821_dev_setup(dev);
-	if (err) {
-		if (err == -EBUSY)
-			goto fail_unregister_device;
-		else
-			goto fail_unregister_pci;
-	}
+	if (err)
+		goto fail_free_ctx;
 
 	/* print pci info */
 	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
@@ -1356,6 +1335,8 @@ fail_irq:
 	pr_info("cx25821_initdev() can't get IRQ !\n");
 	cx25821_dev_unregister(dev);
 
+fail_free_ctx:
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 fail_unregister_pci:
 	pci_disable_device(pci_dev);
 fail_unregister_device:
@@ -1379,6 +1360,7 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 		free_irq(pci_dev->irq, dev);
 
 	cx25821_dev_unregister(dev);
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
 }
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 3eda1a1..3497946 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2009 Conexant Systems Inc.
  *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
+ *  Based on Steven Toth <stoth@linuxtv.org> cx25821 driver
  *  Parts adapted/taken from Eduardo Moscoso Rubino
  *  Copyright (C) 2009 Eduardo Moscoso Rubino <moscoso@TopoLogica.com>
  *
@@ -46,10 +46,6 @@ static unsigned int irq_debug;
 module_param(irq_debug, int, 0644);
 MODULE_PARM_DESC(irq_debug, "enable debug messages [IRQ handler]");
 
-static unsigned int vid_limit = 16;
-module_param(vid_limit, int, 0644);
-MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
-
 #define FORMAT_FLAGS_PACKED       0x01
 
 static const struct cx25821_fmt formats[] = {
@@ -76,41 +72,6 @@ static const struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
 	return NULL;
 }
 
-void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
-			  u32 count)
-{
-	struct cx25821_buffer *buf;
-	int bc;
-
-	for (bc = 0;; bc++) {
-		if (list_empty(&q->active)) {
-			dprintk(1, "bc=%d (=0: active empty)\n", bc);
-			break;
-		}
-
-		buf = list_entry(q->active.next, struct cx25821_buffer,
-				vb.queue);
-
-		/* count comes from the hw and it is 16bit wide --
-		 * this trick handles wrap-arounds correctly for
-		 * up to 32767 buffers in flight... */
-		if ((s16) (count - buf->count) < 0)
-			break;
-
-		v4l2_get_timestamp(&buf->vb.ts);
-		buf->vb.state = VIDEOBUF_DONE;
-		list_del(&buf->vb.queue);
-		wake_up(&buf->vb.done);
-	}
-
-	if (list_empty(&q->active))
-		del_timer(&q->timeout);
-	else
-		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-	if (bc != 1)
-		pr_err("%s: %d buffers handled (should be 1)\n", __func__, bc);
-}
-
 int cx25821_start_video_dma(struct cx25821_dev *dev,
 			    struct cx25821_dmaqueue *q,
 			    struct cx25821_buffer *buf,
@@ -123,7 +84,6 @@ int cx25821_start_video_dma(struct cx25821_dev *dev,
 
 	/* reset counter */
 	cx_write(channel->gpcnt_ctl, 3);
-	q->count = 1;
 
 	/* enable irq */
 	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | (1 << channel->i));
@@ -139,86 +99,8 @@ int cx25821_start_video_dma(struct cx25821_dev *dev,
 	return 0;
 }
 
-static int cx25821_restart_video_queue(struct cx25821_dev *dev,
-				       struct cx25821_dmaqueue *q,
-				       const struct sram_channel *channel)
-{
-	struct cx25821_buffer *buf, *prev;
-	struct list_head *item;
-
-	if (!list_empty(&q->active)) {
-		buf = list_entry(q->active.next, struct cx25821_buffer,
-				vb.queue);
-
-		cx25821_start_video_dma(dev, q, buf, channel);
-
-		list_for_each(item, &q->active) {
-			buf = list_entry(item, struct cx25821_buffer, vb.queue);
-			buf->count = q->count++;
-		}
-
-		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-		return 0;
-	}
-
-	prev = NULL;
-	for (;;) {
-		if (list_empty(&q->queued))
-			return 0;
-
-		buf = list_entry(q->queued.next, struct cx25821_buffer,
-				vb.queue);
-
-		if (NULL == prev) {
-			list_move_tail(&buf->vb.queue, &q->active);
-			cx25821_start_video_dma(dev, q, buf, channel);
-			buf->vb.state = VIDEOBUF_ACTIVE;
-			buf->count = q->count++;
-			mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-		} else if (prev->vb.width == buf->vb.width &&
-			   prev->vb.height == buf->vb.height &&
-			   prev->fmt == buf->fmt) {
-			list_move_tail(&buf->vb.queue, &q->active);
-			buf->vb.state = VIDEOBUF_ACTIVE;
-			buf->count = q->count++;
-			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-			prev->risc.jmp[2] = cpu_to_le32(0); /* Bits 63 - 32 */
-		} else {
-			return 0;
-		}
-		prev = buf;
-	}
-}
-
-static void cx25821_vid_timeout(unsigned long data)
-{
-	struct cx25821_data *timeout_data = (struct cx25821_data *)data;
-	struct cx25821_dev *dev = timeout_data->dev;
-	const struct sram_channel *channel = timeout_data->channel;
-	struct cx25821_dmaqueue *q = &dev->channels[channel->i].dma_vidq;
-	struct cx25821_buffer *buf;
-	unsigned long flags;
-
-	/* cx25821_sram_channel_dump(dev, channel); */
-	cx_clear(channel->dma_ctl, 0x11);
-
-	spin_lock_irqsave(&dev->slock, flags);
-	while (!list_empty(&q->active)) {
-		buf = list_entry(q->active.next, struct cx25821_buffer,
-				vb.queue);
-		list_del(&buf->vb.queue);
-
-		buf->vb.state = VIDEOBUF_ERROR;
-		wake_up(&buf->vb.done);
-	}
-
-	cx25821_restart_video_queue(dev, q, channel);
-	spin_unlock_irqrestore(&dev->slock, flags);
-}
-
 int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 {
-	u32 count = 0;
 	int handled = 0;
 	u32 mask;
 	const struct sram_channel *channel = dev->channels[chan_num].sram_channels;
@@ -239,317 +121,197 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 
 	/* risc1 y */
 	if (status & FLD_VID_DST_RISC1) {
-		spin_lock(&dev->slock);
-		count = cx_read(channel->gpcnt);
-		cx25821_video_wakeup(dev, &dev->channels[channel->i].dma_vidq,
-				count);
-		spin_unlock(&dev->slock);
-		handled++;
-	}
+		struct cx25821_dmaqueue *dmaq =
+			&dev->channels[channel->i].dma_vidq;
+		struct cx25821_buffer *buf;
 
-	/* risc2 y */
-	if (status & 0x10) {
-		dprintk(2, "stopper video\n");
 		spin_lock(&dev->slock);
-		cx25821_restart_video_queue(dev,
-				&dev->channels[channel->i].dma_vidq, channel);
+		if (!list_empty(&dmaq->active)) {
+			buf = list_entry(dmaq->active.next,
+					 struct cx25821_buffer, queue);
+
+			v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+			buf->vb.v4l2_buf.sequence = dmaq->count++;
+			list_del(&buf->queue);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+		}
 		spin_unlock(&dev->slock);
 		handled++;
 	}
 	return handled;
 }
 
-static int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
-		 unsigned int *size)
+static int cx25821_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct cx25821_channel *chan = q->priv_data;
-
-	*size = chan->fmt->depth * chan->width * chan->height >> 3;
-
-	if (0 == *count)
-		*count = 32;
-
-	if (*size * *count > vid_limit * 1024 * 1024)
-		*count = (vid_limit * 1024 * 1024) / *size;
+	struct cx25821_channel *chan = q->drv_priv;
 
+	*num_planes = 1;
+	sizes[0] = (chan->fmt->depth * chan->width * chan->height) >> 3;
+	alloc_ctxs[0] = chan->dev->alloc_ctx;
 	return 0;
 }
 
-static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-		   enum v4l2_field field)
+static int cx25821_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct cx25821_channel *chan = q->priv_data;
+	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
-	int rc, init_buffer = 0;
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	u32 line0_offset;
-	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int bpl_local = LINE_SIZE_D1;
+	int ret;
 
-	BUG_ON(NULL == chan->fmt);
-	if (chan->width < 48 || chan->width > 720 ||
-	    chan->height < 32 || chan->height > 576)
-		return -EINVAL;
-
-	buf->vb.size = (chan->width * chan->height * chan->fmt->depth) >> 3;
+	if (chan->pixel_formats == PIXEL_FRMT_411)
+		buf->bpl = (chan->fmt->depth * chan->width) >> 3;
+	else
+		buf->bpl = (chan->fmt->depth >> 3) * chan->width;
 
-	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size)
+	if (vb2_plane_size(vb, 0) < chan->height * buf->bpl)
 		return -EINVAL;
+	vb2_set_plane_payload(vb, 0, chan->height * buf->bpl);
+	buf->vb.v4l2_buf.field = chan->field;
 
-	if (buf->fmt != chan->fmt ||
-	    buf->vb.width != chan->width ||
-	    buf->vb.height != chan->height || buf->vb.field != field) {
-		buf->fmt = chan->fmt;
-		buf->vb.width = chan->width;
-		buf->vb.height = chan->height;
-		buf->vb.field = field;
-		init_buffer = 1;
-	}
+	if (chan->pixel_formats == PIXEL_FRMT_411) {
+		bpl_local = buf->bpl;
+	} else {
+		bpl_local = buf->bpl;   /* Default */
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		init_buffer = 1;
-		rc = videobuf_iolock(q, &buf->vb, NULL);
-		if (0 != rc) {
-			printk(KERN_DEBUG pr_fmt("videobuf_iolock failed!\n"));
-			goto fail;
+		if (chan->use_cif_resolution) {
+			if (dev->tvnorm & V4L2_STD_625_50)
+				bpl_local = 352 << 1;
+			else
+				bpl_local = chan->cif_width << 1;
 		}
 	}
 
-	dprintk(1, "init_buffer=%d\n", init_buffer);
-
-	if (init_buffer) {
-		if (chan->pixel_formats == PIXEL_FRMT_411)
-			buf->bpl = (buf->fmt->depth * buf->vb.width) >> 3;
-		else
-			buf->bpl = (buf->fmt->depth >> 3) * (buf->vb.width);
-
-		if (chan->pixel_formats == PIXEL_FRMT_411) {
-			bpl_local = buf->bpl;
-		} else {
-			bpl_local = buf->bpl;   /* Default */
-
-			if (chan->use_cif_resolution) {
-				if (dev->tvnorm & V4L2_STD_625_50)
-					bpl_local = 352 << 1;
-				else
-					bpl_local = chan->cif_width << 1;
-			}
-		}
-
-		switch (buf->vb.field) {
-		case V4L2_FIELD_TOP:
-			cx25821_risc_buffer(dev->pci, &buf->risc,
-					    dma->sglist, 0, UNSET,
-					    buf->bpl, 0, buf->vb.height);
-			break;
-		case V4L2_FIELD_BOTTOM:
-			cx25821_risc_buffer(dev->pci, &buf->risc,
-					    dma->sglist, UNSET, 0,
-					    buf->bpl, 0, buf->vb.height);
-			break;
-		case V4L2_FIELD_INTERLACED:
-			/* All other formats are top field first */
-			line0_offset = 0;
-			dprintk(1, "top field first\n");
-
-			cx25821_risc_buffer(dev->pci, &buf->risc,
-					    dma->sglist, line0_offset,
-					    bpl_local, bpl_local, bpl_local,
-					    buf->vb.height >> 1);
-			break;
-		case V4L2_FIELD_SEQ_TB:
-			cx25821_risc_buffer(dev->pci, &buf->risc,
-					    dma->sglist,
-					    0, buf->bpl * (buf->vb.height >> 1),
-					    buf->bpl, 0, buf->vb.height >> 1);
-			break;
-		case V4L2_FIELD_SEQ_BT:
-			cx25821_risc_buffer(dev->pci, &buf->risc,
-					    dma->sglist,
-					    buf->bpl * (buf->vb.height >> 1), 0,
-					    buf->bpl, 0, buf->vb.height >> 1);
-			break;
-		default:
-			BUG();
-		}
+	switch (chan->field) {
+	case V4L2_FIELD_TOP:
+		ret = cx25821_risc_buffer(dev->pci, &buf->risc,
+				sgt->sgl, 0, UNSET,
+				buf->bpl, 0, chan->height);
+		break;
+	case V4L2_FIELD_BOTTOM:
+		ret = cx25821_risc_buffer(dev->pci, &buf->risc,
+				sgt->sgl, UNSET, 0,
+				buf->bpl, 0, chan->height);
+		break;
+	case V4L2_FIELD_INTERLACED:
+		/* All other formats are top field first */
+		line0_offset = 0;
+		dprintk(1, "top field first\n");
+
+		ret = cx25821_risc_buffer(dev->pci, &buf->risc,
+				sgt->sgl, line0_offset,
+				bpl_local, bpl_local, bpl_local,
+				chan->height >> 1);
+		break;
+	case V4L2_FIELD_SEQ_TB:
+		ret = cx25821_risc_buffer(dev->pci, &buf->risc,
+				sgt->sgl,
+				0, buf->bpl * (chan->height >> 1),
+				buf->bpl, 0, chan->height >> 1);
+		break;
+	case V4L2_FIELD_SEQ_BT:
+		ret = cx25821_risc_buffer(dev->pci, &buf->risc,
+				sgt->sgl,
+				buf->bpl * (chan->height >> 1), 0,
+				buf->bpl, 0, chan->height >> 1);
+		break;
+	default:
+		WARN_ON(1);
+		ret = -EINVAL;
+		break;
 	}
 
 	dprintk(2, "[%p/%d] buffer_prep - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
-		buf, buf->vb.i, chan->width, chan->height, chan->fmt->depth,
-		chan->fmt->name, (unsigned long)buf->risc.dma);
-
-	buf->vb.state = VIDEOBUF_PREPARED;
-
-	return 0;
+		buf, buf->vb.v4l2_buf.index, chan->width, chan->height,
+		chan->fmt->depth, chan->fmt->name,
+		(unsigned long)buf->risc.dma);
 
-fail:
-	cx25821_free_buffer(q, buf);
-	return rc;
+	return ret;
 }
 
-static void cx25821_buffer_release(struct videobuf_queue *q,
-			    struct videobuf_buffer *vb)
+static void cx25821_buffer_finish(struct vb2_buffer *vb)
 {
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
+	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
+	struct cx25821_dev *dev = chan->dev;
 
-	cx25821_free_buffer(q, buf);
-}
-
-static int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	return videobuf_mmap_mapper(&chan->vidq, vma);
+	cx25821_free_buffer(dev, buf);
 }
 
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+static void cx25821_buffer_queue(struct vb2_buffer *vb)
 {
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
-	struct cx25821_buffer *prev;
-	struct cx25821_channel *chan = vq->priv_data;
+	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
+	struct cx25821_buffer *prev;
 	struct cx25821_dmaqueue *q = &dev->channels[chan->id].dma_vidq;
 
-	/* add jump to stopper */
-	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-	buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-	buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-	dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-	if (!list_empty(&q->queued)) {
-		list_add_tail(&buf->vb.queue, &q->queued);
-		buf->vb.state = VIDEOBUF_QUEUED;
-		dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-				buf->vb.i);
-
-	} else if (list_empty(&q->active)) {
-		list_add_tail(&buf->vb.queue, &q->active);
-		cx25821_start_video_dma(dev, q, buf, chan->sram_channels);
-		buf->vb.state = VIDEOBUF_ACTIVE;
-		buf->count = q->count++;
-		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-		dprintk(2, "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-				buf, buf->vb.i, buf->count, q->count);
+	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 12);
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
+	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 12);
+	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
+
+	if (list_empty(&q->active)) {
+		list_add_tail(&buf->queue, &q->active);
 	} else {
+		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
 		prev = list_entry(q->active.prev, struct cx25821_buffer,
-				vb.queue);
-		if (prev->vb.width == buf->vb.width
-		   && prev->vb.height == buf->vb.height
-		   && prev->fmt == buf->fmt) {
-			list_add_tail(&buf->vb.queue, &q->active);
-			buf->vb.state = VIDEOBUF_ACTIVE;
-			buf->count = q->count++;
-			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-			/* 64 bit bits 63-32 */
-			prev->risc.jmp[2] = cpu_to_le32(0);
-			dprintk(2, "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-					buf, buf->vb.i, buf->count);
-
-		} else {
-			list_add_tail(&buf->vb.queue, &q->queued);
-			buf->vb.state = VIDEOBUF_QUEUED;
-			dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-					buf->vb.i);
-		}
+				queue);
+		list_add_tail(&buf->queue, &q->active);
+		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 	}
-
-	if (list_empty(&q->active))
-		dprintk(2, "active queue empty!\n");
 }
 
-static struct videobuf_queue_ops cx25821_video_qops = {
-	.buf_setup = cx25821_buffer_setup,
-	.buf_prepare = cx25821_buffer_prepare,
-	.buf_queue = buffer_queue,
-	.buf_release = cx25821_buffer_release,
-};
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-			 loff_t *ppos)
+static int cx25821_start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	struct v4l2_fh *fh = file->private_data;
-	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_channel *chan = q->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
-	int err = 0;
-
-	if (mutex_lock_interruptible(&dev->lock))
-		return -ERESTARTSYS;
-	if (chan->streaming_fh && chan->streaming_fh != fh) {
-		err = -EBUSY;
-		goto unlock;
-	}
-	chan->streaming_fh = fh;
+	struct cx25821_dmaqueue *dmaq = &dev->channels[chan->id].dma_vidq;
+	struct cx25821_buffer *buf = list_entry(dmaq->active.next,
+			struct cx25821_buffer, queue);
 
-	err = videobuf_read_one(&chan->vidq, data, count, ppos,
-				file->f_flags & O_NONBLOCK);
-unlock:
-	mutex_unlock(&dev->lock);
-	return err;
-}
-
-static unsigned int video_poll(struct file *file,
-			      struct poll_table_struct *wait)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-	unsigned long req_events = poll_requested_events(wait);
-	unsigned int res = v4l2_ctrl_poll(file, wait);
-
-	if (req_events & (POLLIN | POLLRDNORM))
-		res |= videobuf_poll_stream(file, &chan->vidq, wait);
-	return res;
-
-	/* This doesn't belong in poll(). This can be done
-	 * much better with vb2. We keep this code here as a
-	 * reminder.
-	if ((res & POLLIN) && buf->vb.state == VIDEOBUF_DONE) {
-		struct cx25821_dev *dev = chan->dev;
-
-		if (dev && chan->use_cif_resolution) {
-			u8 cam_id = *((char *)buf->vb.baddr + 3);
-			memcpy((char *)buf->vb.baddr,
-					(char *)buf->vb.baddr + (chan->width * 2),
-					(chan->width * 2));
-			*((char *)buf->vb.baddr + 3) = cam_id;
-		}
-	}
-	 */
+	dmaq->count = 0;
+	cx25821_start_video_dma(dev, dmaq, buf, chan->sram_channels);
+	return 0;
 }
 
-static int video_release(struct file *file)
+static void cx25821_stop_streaming(struct vb2_queue *q)
 {
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct v4l2_fh *fh = file->private_data;
+	struct cx25821_channel *chan = q->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
-	const struct sram_channel *sram_ch =
-		dev->channels[0].sram_channels;
-
-	mutex_lock(&dev->lock);
-	/* stop the risc engine and fifo */
-	cx_write(sram_ch->dma_ctl, 0); /* FIFO and RISC disable */
+	struct cx25821_dmaqueue *dmaq = &dev->channels[chan->id].dma_vidq;
+	unsigned long flags;
 
-	/* stop video capture */
-	if (chan->streaming_fh == fh) {
-		videobuf_queue_cancel(&chan->vidq);
-		chan->streaming_fh = NULL;
-	}
+	cx_write(chan->sram_channels->dma_ctl, 0); /* FIFO and RISC disable */
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct cx25821_buffer *buf = list_entry(dmaq->active.next,
+			struct cx25821_buffer, queue);
 
-	if (chan->vidq.read_buf) {
-		cx25821_buffer_release(&chan->vidq, chan->vidq.read_buf);
-		kfree(chan->vidq.read_buf);
+		list_del(&buf->queue);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-
-	videobuf_mmap_free(&chan->vidq);
-	mutex_unlock(&dev->lock);
-
-	return v4l2_fh_release(file);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
+static struct vb2_ops cx25821_video_qops = {
+	.queue_setup    = cx25821_queue_setup,
+	.buf_prepare  = cx25821_buffer_prepare,
+	.buf_finish = cx25821_buffer_finish,
+	.buf_queue    = cx25821_buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = cx25821_start_streaming,
+	.stop_streaming = cx25821_stop_streaming,
+};
+
 /* VIDEO IOCTLS */
 
 static int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
@@ -571,7 +333,7 @@ static int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width = chan->width;
 	f->fmt.pix.height = chan->height;
-	f->fmt.pix.field = chan->vidq.field;
+	f->fmt.pix.field = chan->field;
 	f->fmt.pix.pixelformat = chan->fmt->fourcc;
 	f->fmt.pix.bytesperline = (chan->width * chan->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = chan->height * f->fmt.pix.bytesperline;
@@ -632,7 +394,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		return err;
 
 	chan->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
-	chan->vidq.field = f->fmt.pix.field;
+	chan->field = f->fmt.pix.field;
 	chan->width = f->fmt.pix.width;
 	chan->height = f->fmt.pix.height;
 
@@ -654,47 +416,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	if (chan->streaming_fh && chan->streaming_fh != priv)
-		return -EBUSY;
-	chan->streaming_fh = priv;
-
-	return videobuf_streamon(&chan->vidq);
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	if (chan->streaming_fh && chan->streaming_fh != priv)
-		return -EBUSY;
-	if (chan->streaming_fh == NULL)
-		return 0;
-
-	chan->streaming_fh = NULL;
-	return videobuf_streamoff(&chan->vidq);
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	int ret_val = 0;
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	ret_val = videobuf_dqbuf(&chan->vidq, p, file->f_flags & O_NONBLOCK);
-	p->sequence = chan->dma_vidq.count;
-
-	return ret_val;
-}
-
 static int vidioc_log_status(struct file *file, void *priv)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
@@ -729,29 +450,6 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int cx25821_vidioc_reqbufs(struct file *file, void *priv,
-			   struct v4l2_requestbuffers *p)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	return videobuf_reqbufs(&chan->vidq, p);
-}
-
-static int cx25821_vidioc_querybuf(struct file *file, void *priv,
-			    struct v4l2_buffer *p)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	return videobuf_querybuf(&chan->vidq, p);
-}
-
-static int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	return videobuf_qbuf(&chan->vidq, p);
-}
-
 static int cx25821_vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
@@ -880,7 +578,7 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 		return err;
 
 	chan->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
-	chan->vidq.field = f->fmt.pix.field;
+	chan->field = f->fmt.pix.field;
 	chan->width = f->fmt.pix.width;
 	chan->height = f->fmt.pix.height;
 	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
@@ -890,52 +588,6 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	return 0;
 }
 
-static ssize_t video_write(struct file *file, const char __user *data, size_t count,
-			 loff_t *ppos)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	struct v4l2_fh *fh = file->private_data;
-	int err = 0;
-
-	if (mutex_lock_interruptible(&dev->lock))
-		return -ERESTARTSYS;
-	if (chan->streaming_fh && chan->streaming_fh != fh) {
-		err = -EBUSY;
-		goto unlock;
-	}
-	if (!chan->streaming_fh) {
-		err = cx25821_vidupstream_init(chan, chan->pixel_formats);
-		if (err)
-			goto unlock;
-		chan->streaming_fh = fh;
-	}
-
-	err = cx25821_write_frame(chan, data, count);
-	count -= err;
-	*ppos += err;
-
-unlock:
-	mutex_unlock(&dev->lock);
-	return err;
-}
-
-static int video_out_release(struct file *file)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	struct v4l2_fh *fh = file->private_data;
-
-	mutex_lock(&dev->lock);
-	if (chan->streaming_fh == fh) {
-		cx25821_stop_upstream_video(chan);
-		chan->streaming_fh = NULL;
-	}
-	mutex_unlock(&dev->lock);
-
-	return v4l2_fh_release(file);
-}
-
 static const struct v4l2_ctrl_ops cx25821_ctrl_ops = {
 	.s_ctrl = cx25821_s_ctrl,
 };
@@ -943,11 +595,11 @@ static const struct v4l2_ctrl_ops cx25821_ctrl_ops = {
 static const struct v4l2_file_operations video_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
+	.release        = vb2_fop_release,
+	.read           = vb2_fop_read,
+	.poll		= vb2_fop_poll,
 	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -956,17 +608,18 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-	.vidioc_reqbufs = cx25821_vidioc_reqbufs,
-	.vidioc_querybuf = cx25821_vidioc_querybuf,
-	.vidioc_qbuf = cx25821_vidioc_qbuf,
-	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_g_std = cx25821_vidioc_g_std,
 	.vidioc_s_std = cx25821_vidioc_s_std,
 	.vidioc_enum_input = cx25821_vidioc_enum_input,
 	.vidioc_g_input = cx25821_vidioc_g_input,
 	.vidioc_s_input = cx25821_vidioc_s_input,
-	.vidioc_streamon = vidioc_streamon,
-	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_log_status = vidioc_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
@@ -984,9 +637,11 @@ static const struct video_device cx25821_video_device = {
 static const struct v4l2_file_operations video_out_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
-	.write = video_write,
-	.release = video_out_release,
+	.release        = vb2_fop_release,
+	.write          = vb2_fop_write,
+	.poll		= vb2_fop_poll,
 	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
 };
 
 static const struct v4l2_ioctl_ops video_out_ioctl_ops = {
@@ -1017,13 +672,8 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 	cx_clear(PCI_INT_MSK, 1);
 
 	if (video_is_registered(&dev->channels[chan_num].vdev)) {
-		struct cx25821_riscmem *risc =
-			&dev->channels[chan_num].dma_vidq.stopper;
-
 		video_unregister_device(&dev->channels[chan_num].vdev);
 		v4l2_ctrl_handler_free(&dev->channels[chan_num].hdl);
-
-		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
 	}
 }
 
@@ -1041,6 +691,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		struct cx25821_channel *chan = &dev->channels[i];
 		struct video_device *vdev = &chan->vdev;
 		struct v4l2_ctrl_handler *hdl = &chan->hdl;
+		struct vb2_queue *q;
 		bool is_output = i > SRAM_CH08;
 
 		if (i == SRAM_CH08) /* audio channel */
@@ -1068,11 +719,9 @@ int cx25821_video_register(struct cx25821_dev *dev)
 			chan->out->chan = chan;
 		}
 
-		cx25821_risc_stopper(dev->pci, &chan->dma_vidq.stopper,
-			chan->sram_channels->dma_ctl, 0x11, 0);
-
 		chan->sram_channels = &cx25821_sram_channels[i];
 		chan->width = 720;
+		chan->field = V4L2_FIELD_INTERLACED;
 		if (dev->tvnorm & V4L2_STD_625_50)
 			chan->height = 576;
 		else
@@ -1086,19 +735,27 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		cx_write(chan->sram_channels->int_stat, 0xffffffff);
 
 		INIT_LIST_HEAD(&chan->dma_vidq.active);
-		INIT_LIST_HEAD(&chan->dma_vidq.queued);
 
-		chan->timeout_data.dev = dev;
-		chan->timeout_data.channel = &cx25821_sram_channels[i];
-		chan->dma_vidq.timeout.function = cx25821_vid_timeout;
-		chan->dma_vidq.timeout.data = (unsigned long)&chan->timeout_data;
-		init_timer(&chan->dma_vidq.timeout);
+		q = &chan->vidq;
+
+		q->type = is_output ? V4L2_BUF_TYPE_VIDEO_OUTPUT :
+				      V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+		q->io_modes |= is_output ? VB2_WRITE : VB2_READ;
+		q->gfp_flags = GFP_DMA32;
+		q->min_buffers_needed = 2;
+		q->drv_priv = chan;
+		q->buf_struct_size = sizeof(struct cx25821_buffer);
+		q->ops = &cx25821_video_qops;
+		q->mem_ops = &vb2_dma_sg_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->lock = &dev->lock;
 
-		if (!is_output)
-			videobuf_queue_sg_init(&chan->vidq, &cx25821_video_qops, &dev->pci->dev,
-				&dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				V4L2_FIELD_INTERLACED, sizeof(struct cx25821_buffer),
-				chan, &dev->lock);
+		if (!is_output) {
+			err = vb2_queue_init(q);
+			if (err < 0)
+				goto fail_unreg;
+		}
 
 		/* register v4l devices */
 		*vdev = is_output ? cx25821_video_out_device : cx25821_video_device;
@@ -1108,6 +765,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		else
 			vdev->vfl_dir = VFL_DIR_TX;
 		vdev->lock = &dev->lock;
+		vdev->queue = q;
 		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
 		video_set_drvdata(vdev, chan);
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 38beec2..34c5ff1 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -34,7 +34,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 
 #include "cx25821-reg.h"
 #include "cx25821-medusa-reg.h"
@@ -120,13 +120,13 @@ struct cx25821_riscmem {
 /* buffer for one video frame */
 struct cx25821_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
+	struct vb2_buffer vb;
+	struct list_head queue;
 
 	/* cx25821 specific */
 	unsigned int bpl;
 	struct cx25821_riscmem risc;
 	const struct cx25821_fmt *fmt;
-	u32 count;
 };
 
 enum port {
@@ -165,17 +165,9 @@ struct cx25821_i2c {
 
 struct cx25821_dmaqueue {
 	struct list_head active;
-	struct list_head queued;
-	struct timer_list timeout;
-	struct cx25821_riscmem stopper;
 	u32 count;
 };
 
-struct cx25821_data {
-	struct cx25821_dev *dev;
-	const struct sram_channel *channel;
-};
-
 struct cx25821_dev;
 
 struct cx25821_channel;
@@ -213,18 +205,17 @@ struct cx25821_video_out_data {
 struct cx25821_channel {
 	unsigned id;
 	struct cx25821_dev *dev;
-	struct v4l2_fh *streaming_fh;
 
 	struct v4l2_ctrl_handler hdl;
-	struct cx25821_data timeout_data;
 
 	struct video_device vdev;
 	struct cx25821_dmaqueue dma_vidq;
-	struct videobuf_queue vidq;
+	struct vb2_queue vidq;
 
 	const struct sram_channel *sram_channels;
 
 	const struct cx25821_fmt *fmt;
+	unsigned field;
 	unsigned int width, height;
 	int pixel_formats;
 	int use_cif_resolution;
@@ -250,6 +241,7 @@ struct cx25821_dev {
 	int hwrevision;
 	/* used by cx25821-alsa */
 	struct snd_card *card;
+	void *alloc_ctx;
 
 	u32 clk_freq;
 
@@ -425,10 +417,8 @@ extern int cx25821_risc_databuffer_audio(struct pci_dev *pci,
 					 struct scatterlist *sglist,
 					 unsigned int bpl,
 					 unsigned int lines, unsigned int lpi);
-extern void cx25821_free_buffer(struct videobuf_queue *q,
+extern void cx25821_free_buffer(struct cx25821_dev *dev,
 				struct cx25821_buffer *buf);
-extern int cx25821_risc_stopper(struct pci_dev *pci, struct cx25821_riscmem *risc,
-				u32 reg, u32 mask, u32 value);
 extern void cx25821_sram_channel_dump(struct cx25821_dev *dev,
 				      const struct sram_channel *ch);
 extern void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
-- 
2.1.3

