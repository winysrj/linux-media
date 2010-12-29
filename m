Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12871 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab0L2JsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 04:48:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LE600I4DOKKXG20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Dec 2010 09:48:21 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LE600BTHOKJ5N@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Dec 2010 09:48:20 +0000 (GMT)
Date: Wed, 29 Dec 2010 10:48:17 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/2] v4l: saa7134: quick and dirty port to videobuf2
In-reply-to: <1293616097-24167-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1293616097-24167-3-git-send-email-s.nawrocki@samsung.com>
References: <1293616097-24167-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch is meant for the videobuf2 testing purposes only, until there
exist more complete vb2 based driver for a widely available hardware.
This patch requires the kernel to be compiled with CONFIG_PM and
CONFIG_VIDEO_SAA7134_RC disabled.

Signed-off: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/saa7134/Kconfig         |    2 +-
 drivers/media/video/saa7134/saa7134-core.c  |  291 ++++++++-------
 drivers/media/video/saa7134/saa7134-video.c |  576 ++++++++++++++-------------
 drivers/media/video/saa7134/saa7134.h       |   13 +-
 4 files changed, 461 insertions(+), 421 deletions(-)

diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index 380f1b2..b418ef8 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_SAA7134
 	tristate "Philips SAA7134 support"
 	depends on VIDEO_DEV && PCI && I2C
-	select VIDEOBUF_DMA_SG
+	select VIDEOBUF2_DMA_SG
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select CRC32
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index dc7b592..0ea471b 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm.h>
+#include <media/videobuf2-dma-sg.h>
 
 #include "saa7134-reg.h"
 #include "saa7134.h"
@@ -44,27 +45,27 @@ MODULE_LICENSE("GPL");
 
 static unsigned int irq_debug;
 module_param(irq_debug, int, 0644);
-MODULE_PARM_DESC(irq_debug,"enable debug messages [IRQ handler]");
+MODULE_PARM_DESC(irq_debug, "enable debug messages [IRQ handler]");
 
 static unsigned int core_debug;
 module_param(core_debug, int, 0644);
-MODULE_PARM_DESC(core_debug,"enable debug messages [core]");
+MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
 
 static unsigned int gpio_tracking;
 module_param(gpio_tracking, int, 0644);
-MODULE_PARM_DESC(gpio_tracking,"enable debug messages [gpio]");
+MODULE_PARM_DESC(gpio_tracking, "enable debug messages [gpio]");
 
 static unsigned int alsa = 1;
 module_param(alsa, int, 0644);
-MODULE_PARM_DESC(alsa,"enable/disable ALSA DMA sound [dmasound]");
+MODULE_PARM_DESC(alsa, "enable/disable ALSA DMA sound [dmasound]");
 
 static unsigned int latency = UNSET;
 module_param(latency, int, 0444);
-MODULE_PARM_DESC(latency,"pci latency timer");
+MODULE_PARM_DESC(latency, "pci latency timer");
 
-int saa7134_no_overlay=-1;
+int saa7134_no_overlay = -1;
 module_param_named(no_overlay, saa7134_no_overlay, int, 0444);
-MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enables)"
+MODULE_PARM_DESC(no_overlay, "allow override overlay default (0 disables, 1 enables)"
 		" [some VIA/SIS chipsets are known to have problem with overlay]");
 
 static unsigned int video_nr[] = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
@@ -87,6 +88,8 @@ EXPORT_SYMBOL(saa7134_devlist);
 static LIST_HEAD(mops_list);
 static unsigned int saa7134_devcount;
 
+struct vb2_alloc_ctx *alloc_ctx;
+
 int (*saa7134_dmasound_init)(struct saa7134_dev *dev);
 int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 
@@ -95,13 +98,13 @@ int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg)
 {
-	unsigned long mode,status;
+	unsigned long mode, status;
 
 	if (!gpio_tracking)
 		return;
 	/* rising SAA7134_GPIO_GPRESCAN reads the status */
-	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,0);
-	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,SAA7134_GPIO_GPRESCAN);
+	saa_andorb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN, 0);
+	saa_andorb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN, SAA7134_GPIO_GPRESCAN);
 	mode   = saa_readl(SAA7134_GPIO_GPMODE0   >> 2) & 0xfffffff;
 	status = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & 0xfffffff;
 	printk(KERN_DEBUG
@@ -116,7 +119,8 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 	index = 1 << bit_no;
 	switch (value) {
 	case 0: /* static value */
-	case 1:	dprintk("setting GPIO%d to static %d\n", bit_no, value);
+	case 1:
+		printk("setting GPIO%d to static %d\n", bit_no, value);
 		/* turn sync mode off if necessary */
 		if (index & 0x00c00000)
 			saa_andorb(SAA7134_VIDEO_PORT_CTRL6, 0x0f, 0x00);
@@ -128,7 +132,7 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, index, bitval);
 		break;
 	case 3:	/* tristate */
-		dprintk("setting GPIO%d to tristate\n", bit_no);
+		printk("setting GPIO%d to tristate\n", bit_no);
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, index, 0);
 		break;
 	}
@@ -142,8 +146,9 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
 
-static void request_module_async(struct work_struct *work){
-	struct saa7134_dev* dev = container_of(work, struct saa7134_dev, request_module_wk);
+static void request_module_async(struct work_struct *work)
+{
+	struct saa7134_dev *dev = container_of(work, struct saa7134_dev, request_module_wk);
 	if (card_is_empress(dev))
 		request_module("saa7134-empress");
 	if (card_is_dvb(dev))
@@ -189,13 +194,14 @@ int saa7134_buffer_count(unsigned int size, unsigned int count)
 
 int saa7134_buffer_startpage(struct saa7134_buf *buf)
 {
-	return saa7134_buffer_pages(buf->vb.bsize) * buf->vb.i;
+	return saa7134_buffer_pages(vb2_plane_size(&buf->vb2, 0)) * buf->vb2.v4l2_buf.index;
 }
 
 unsigned long saa7134_buffer_base(struct saa7134_buf *buf)
 {
 	unsigned long base;
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+	/* struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb2); */
+	struct vb2_dma_sg_desc *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 
 	base  = saa7134_buffer_startpage(buf) * 4096;
 	base += dma->sglist[0].offset;
@@ -223,7 +229,7 @@ int saa7134_pgtable_build(struct pci_dev *pci, struct saa7134_pgtable *pt,
 			  unsigned int startpage)
 {
 	__le32        *ptr;
-	unsigned int  i,p;
+	unsigned int  i, p;
 
 	BUG_ON(NULL == pt || NULL == pt->cpu);
 
@@ -244,15 +250,11 @@ void saa7134_pgtable_free(struct pci_dev *pci, struct saa7134_pgtable *pt)
 
 /* ------------------------------------------------------------------ */
 
-void saa7134_dma_free(struct videobuf_queue *q,struct saa7134_buf *buf)
+void saa7134_dma_free(struct vb2_queue *q, struct saa7134_buf *buf)
 {
-	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
+	/* struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb); */
+	struct vb2_dma_sg_desc *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 	BUG_ON(in_interrupt());
-
-	videobuf_waiton(q, &buf->vb, 0, 0);
-	videobuf_dma_unmap(q->dev, dma);
-	videobuf_dma_free(dma);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
 /* ------------------------------------------------------------------ */
@@ -262,26 +264,25 @@ int saa7134_buffer_queue(struct saa7134_dev *dev,
 			 struct saa7134_buf *buf)
 {
 	struct saa7134_buf *next = NULL;
+	unsigned long flags;
 
-	assert_spin_locked(&dev->slock);
-	dprintk("buffer_queue %p\n",buf);
+	spin_lock_irqsave(&dev->slock, flags);
+	printk("buffer_queue %p\n", buf);
 	if (NULL == q->curr) {
 		if (!q->need_two) {
 			q->curr = buf;
-			buf->activate(dev,buf,NULL);
+			buf->activate(dev, buf, NULL);
 		} else if (list_empty(&q->queue)) {
-			list_add_tail(&buf->vb.queue,&q->queue);
-			buf->vb.state = VIDEOBUF_QUEUED;
+			list_add_tail(&buf->entry, &q->queue);
 		} else {
-			next = list_entry(q->queue.next,struct saa7134_buf,
-					  vb.queue);
+			next = list_entry(q->queue.next, struct saa7134_buf, entry);
 			q->curr = buf;
-			buf->activate(dev,buf,next);
+			buf->activate(dev, buf, next);
 		}
 	} else {
-		list_add_tail(&buf->vb.queue,&q->queue);
-		buf->vb.state = VIDEOBUF_QUEUED;
+		list_add_tail(&buf->entry, &q->queue);
 	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 	return 0;
 }
 
@@ -289,40 +290,37 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 			   struct saa7134_dmaqueue *q,
 			   unsigned int state)
 {
-	assert_spin_locked(&dev->slock);
-	dprintk("buffer_finish %p\n",q->curr);
+	printk("buffer_finish %p\n", q->curr);
 
 	/* finish current buffer */
-	q->curr->vb.state = state;
-	do_gettimeofday(&q->curr->vb.ts);
-	wake_up(&q->curr->vb.done);
+	do_gettimeofday(&q->curr->vb2.v4l2_buf.timestamp);
+	vb2_buffer_done(&q->curr->vb2, VB2_BUF_STATE_DONE);
 	q->curr = NULL;
 }
 
 void saa7134_buffer_next(struct saa7134_dev *dev,
 			 struct saa7134_dmaqueue *q)
 {
-	struct saa7134_buf *buf,*next = NULL;
+	struct saa7134_buf *buf, *next = NULL;
 
 	assert_spin_locked(&dev->slock);
 	BUG_ON(NULL != q->curr);
 
 	if (!list_empty(&q->queue)) {
 		/* activate next one from queue */
-		buf = list_entry(q->queue.next,struct saa7134_buf,vb.queue);
-		dprintk("buffer_next %p [prev=%p/next=%p]\n",
-			buf,q->queue.prev,q->queue.next);
-		list_del(&buf->vb.queue);
+		buf = list_entry(q->queue.next, struct saa7134_buf, entry);
+		printk("buffer_next %p [prev=%p/next=%p]\n",
+			buf, q->queue.prev, q->queue.next);
+		list_del(&buf->entry);
 		if (!list_empty(&q->queue))
-			next = list_entry(q->queue.next,struct saa7134_buf,
-					  vb.queue);
+			next = list_entry(q->queue.next, struct saa7134_buf, entry);
 		q->curr = buf;
-		buf->activate(dev,buf,next);
-		dprintk("buffer_next #2 prev=%p/next=%p\n",
-			q->queue.prev,q->queue.next);
+		buf->activate(dev, buf, next);
+		printk("buffer_next #2 prev=%p/next=%p\n",
+			q->queue.prev, q->queue.next);
 	} else {
 		/* nothing to do -- just stop DMA */
-		dprintk("buffer_next %p\n",NULL);
+		printk("buffer_next %p\n", NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
 	}
@@ -330,11 +328,11 @@ void saa7134_buffer_next(struct saa7134_dev *dev,
 
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
@@ -344,23 +342,44 @@ void saa7134_buffer_timeout(unsigned long data)
 	/* flag current buffer as failed,
 	   try to start over with the next one. */
 	if (q->curr) {
-		dprintk("timeout on %p\n",q->curr);
-		saa7134_buffer_finish(dev,q,VIDEOBUF_ERROR);
+		printk("timeout on %p\n", q->curr);
+		saa7134_buffer_finish(dev, q, VIDEOBUF_ERROR);
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
+		list_for_each_safe(pos, n, &q->queue){
+			 tmp = list_entry(pos, struct saa7134_buf, entry);
+			 vb2_buffer_done(&tmp->vb2, VB2_BUF_STATE_ERROR);
+			 list_del(pos);
+			 tmp = NULL;
+		}
+	}
+	spin_unlock_irqrestore(&dev->slock,flags);
+	saa7134_buffer_timeout((unsigned long)q); /* also calls del_timer(&q->timeout) */
+}
+
 /* ------------------------------------------------------------------ */
 
 int saa7134_set_dmabits(struct saa7134_dev *dev)
 {
-	u32 split, task=0, ctrl=0, irq=0;
+	u32 split, task = 0, ctrl = 0, irq = 0;
 	enum v4l2_field cap = V4L2_FIELD_ANY;
 	enum v4l2_field ov  = V4L2_FIELD_ANY;
 
 	assert_spin_locked(&dev->slock);
 
+	printk("%s\n", __func__);
+
 	if (dev->insuspend)
 		return 0;
 
@@ -370,7 +389,7 @@ int saa7134_set_dmabits(struct saa7134_dev *dev)
 		ctrl |= SAA7134_MAIN_CTRL_TE0;
 		irq  |= SAA7134_IRQ1_INTE_RA0_1 |
 			SAA7134_IRQ1_INTE_RA0_0;
-		cap = dev->video_q.curr->vb.field;
+		cap = dev->video_q.curr->vb2.v4l2_buf.field;
 	}
 
 	/* video capture -- dma 1+2 (planar modes) */
@@ -437,7 +456,7 @@ int saa7134_set_dmabits(struct saa7134_dev *dev)
 		   SAA7134_MAIN_CTRL_TE5 |
 		   SAA7134_MAIN_CTRL_TE6,
 		   ctrl);
-	dprintk("dmabits: task=0x%02x ctrl=0x%02x irq=0x%x split=%s\n",
+	printk("dmabits: task=0x%02x ctrl=0x%02x irq=0x%x split=%s\n",
 		task, ctrl, irq, split ? "no" : "yes");
 
 	return 0;
@@ -460,11 +479,11 @@ static void print_irqstatus(struct saa7134_dev *dev, int loop,
 	unsigned int i;
 
 	printk(KERN_DEBUG "%s/irq[%d,%ld]: r=0x%lx s=0x%02lx",
-	       dev->name,loop,jiffies,report,status);
+	       dev->name, loop, jiffies, report, status);
 	for (i = 0; i < IRQBITS; i++) {
 		if (!(report & (1 << i)))
 			continue;
-		printk(" %s",irqbits[i]);
+		printk(" %s", irqbits[i]);
 	}
 	if (report & SAA7134_IRQ_REPORT_DONE_RA0) {
 		printk(" | RA0=%s,%s,%s,%ld",
@@ -478,8 +497,8 @@ static void print_irqstatus(struct saa7134_dev *dev, int loop,
 
 static irqreturn_t saa7134_irq(int irq, void *dev_id)
 {
-	struct saa7134_dev *dev = (struct saa7134_dev*) dev_id;
-	unsigned long report,status;
+	struct saa7134_dev *dev = (struct saa7134_dev *)dev_id;
+	unsigned long report, status;
 	int loop, handled = 0;
 
 	if (dev->insuspend)
@@ -493,25 +512,21 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 		 * mask out the report and let the saa7134-alsa module deal
 		 * with it */
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA3) &&
-			(dev->dmasound.priv_data != NULL) )
-		{
-			if (irq_debug > 1)
+			(dev->dmasound.priv_data != NULL)) {
 				printk(KERN_DEBUG "%s/irq: preserving DMA sound interrupt\n",
 				       dev->name);
 			report &= ~SAA7134_IRQ_REPORT_DONE_RA3;
 		}
 
 		if (0 == report) {
-			if (irq_debug > 1)
 				printk(KERN_DEBUG "%s/irq: no (more) work\n",
 				       dev->name);
 			goto out;
 		}
 
 		handled = 1;
-		saa_writel(SAA7134_IRQ_REPORT,report);
-		if (irq_debug)
-			print_irqstatus(dev,loop,report,status);
+		saa_writel(SAA7134_IRQ_REPORT, report);
+			print_irqstatus(dev, loop, report, status);
 
 
 		if ((report & SAA7134_IRQ_REPORT_RDCAP) ||
@@ -521,73 +536,72 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA0) &&
 		    (status & 0x60) == 0)
-			saa7134_irq_video_done(dev,status);
+			saa7134_irq_video_done(dev, status);
 
 
 
 		if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			switch (dev->has_remote) {
-				case SAA7134_REMOTE_GPIO:
-					if (!dev->remote)
-						break;
-					if  (dev->remote->mask_keydown & 0x10000) {
-						saa7134_input_irq(dev);
-					}
+			case SAA7134_REMOTE_GPIO:
+				if (!dev->remote)
 					break;
+				if  (dev->remote->mask_keydown & 0x10000)
+					saa7134_input_irq(dev);
+				break;
 
-				case SAA7134_REMOTE_I2C:
-					break;			/* FIXME: invoke I2C get_key() */
+			case SAA7134_REMOTE_I2C:
+				break;			/* FIXME: invoke I2C get_key() */
 
-				default:			/* GPIO16 not used by IR remote */
-					break;
+			default:			/* GPIO16 not used by IR remote */
+				break;
 			}
 		}
 
 		if (report & SAA7134_IRQ_REPORT_GPIO18) {
 			switch (dev->has_remote) {
-				case SAA7134_REMOTE_GPIO:
-					if (!dev->remote)
-						break;
-					if ((dev->remote->mask_keydown & 0x40000) ||
-					    (dev->remote->mask_keyup & 0x40000)) {
-						saa7134_input_irq(dev);
-					}
+			case SAA7134_REMOTE_GPIO:
+				if (!dev->remote)
 					break;
+				if ((dev->remote->mask_keydown & 0x40000) ||
+				    (dev->remote->mask_keyup & 0x40000)) {
+					saa7134_input_irq(dev);
+				}
+				break;
 
-				case SAA7134_REMOTE_I2C:
-					break;			/* FIXME: invoke I2C get_key() */
+			case SAA7134_REMOTE_I2C:
+				break;			/* FIXME: invoke I2C get_key() */
 
-				default:			/* GPIO18 not used by IR remote */
-					break;
+			default:			/* GPIO18 not used by IR remote */
+				break;
 			}
 		}
 	}
 
 	if (10 == loop) {
-		print_irqstatus(dev,loop,report,status);
+		print_irqstatus(dev, loop, report, status);
 		if (report & SAA7134_IRQ_REPORT_PE) {
 			/* disable all parity error */
 			printk(KERN_WARNING "%s/irq: looping -- "
-			       "clearing PE (parity error!) enable bit\n",dev->name);
-			saa_clearl(SAA7134_IRQ2,SAA7134_IRQ2_INTE_PE);
+			       "clearing PE (parity error!) enable bit\n", dev->name);
+			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_PE);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			/* disable gpio16 IRQ */
 			printk(KERN_WARNING "%s/irq: looping -- "
-			       "clearing GPIO16 enable bit\n",dev->name);
+			       "clearing GPIO16 enable bit\n", dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16_N);
 		} else if (report & SAA7134_IRQ_REPORT_GPIO18) {
 			/* disable gpio18 IRQs */
 			printk(KERN_WARNING "%s/irq: looping -- "
-			       "clearing GPIO18 enable bit\n",dev->name);
+			       "clearing GPIO18 enable bit\n", dev->name);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 			saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_N);
 		} else {
 			/* disable all irqs */
 			printk(KERN_WARNING "%s/irq: looping -- "
-			       "clearing all enable bits\n",dev->name);
-			saa_writel(SAA7134_IRQ1,0);
-			saa_writel(SAA7134_IRQ2,0);
+			       "clearing all enable bits\n", dev->name);
+			saa_writel(SAA7134_IRQ1, 0);
+			saa_writel(SAA7134_IRQ2, 0);
 		}
 	}
 
@@ -633,7 +647,7 @@ static int saa7134_hw_enable1(struct saa7134_dev *dev)
 
 static int saa7134_hwinit1(struct saa7134_dev *dev)
 {
-	dprintk("hwinit1\n");
+	printk("hwinit1\n");
 
 	saa_writel(SAA7134_IRQ1, 0);
 	saa_writel(SAA7134_IRQ2, 0);
@@ -644,7 +658,7 @@ static int saa7134_hwinit1(struct saa7134_dev *dev)
 	mutex_init(&dev->lock);
 	spin_lock_init(&dev->slock);
 
-	saa7134_track_gpio(dev,"pre-init");
+	saa7134_track_gpio(dev, "pre-init");
 	saa7134_video_init1(dev);
 
 	saa7134_input_init1(dev);
@@ -680,9 +694,8 @@ static int saa7134_hw_enable2(struct saa7134_dev *dev)
 		}
 	}
 
-	if (dev->has_remote == SAA7134_REMOTE_I2C) {
+	if (dev->has_remote == SAA7134_REMOTE_I2C)
 		request_module("ir-kbd-i2c");
-	}
 
 	saa_writel(SAA7134_IRQ1, 0);
 	saa_writel(SAA7134_IRQ2, irq2_mask);
@@ -693,11 +706,10 @@ static int saa7134_hw_enable2(struct saa7134_dev *dev)
 static int saa7134_hwinit2(struct saa7134_dev *dev)
 {
 
-	dprintk("hwinit2\n");
+	printk("hwinit2\n");
 
 	saa7134_video_init2(dev);
 
-
 	saa7134_hw_enable2(dev);
 
 	return 0;
@@ -707,7 +719,7 @@ static int saa7134_hwinit2(struct saa7134_dev *dev)
 /* shutdown */
 static int saa7134_hwfini(struct saa7134_dev *dev)
 {
-	dprintk("hwfini\n");
+	printk("hwfini\n");
 
 
 	saa7134_input_fini(dev);
@@ -717,7 +729,7 @@ static int saa7134_hwfini(struct saa7134_dev *dev)
 
 static void __devinit must_configure_manually(void)
 {
-	unsigned int i,p;
+	unsigned int i, p;
 
 	printk(KERN_WARNING
 	       "saa7134: <rant>\n"
@@ -730,7 +742,7 @@ static void __devinit must_configure_manually(void)
 	       "saa7134: which board do you have.  The list:\n");
 	for (i = 0; i < saa7134_bcount; i++) {
 		printk(KERN_WARNING "saa7134:   card=%d -> %-40.40s",
-		       i,saa7134_boards[i].name);
+		       i, saa7134_boards[i].name);
 		for (p = 0; saa7134_pci_tbl[p].driver_data; p++) {
 			if (saa7134_pci_tbl[p].driver_data != i)
 				continue;
@@ -785,7 +797,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	if (saa7134_devcount == SAA7134_MAXBOARDS)
 		return -ENOMEM;
 
-	dev = kzalloc(sizeof(*dev),GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (NULL == dev)
 		return -ENOMEM;
 
@@ -801,7 +813,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	}
 
 	dev->nr = saa7134_devcount;
-	sprintf(dev->name,"saa%x[%d]",pci_dev->device,dev->nr);
+	sprintf(dev->name, "saa%x[%d]", pci_dev->device, dev->nr);
 
 	/* pci quirks */
 	if (pci_pci_problems) {
@@ -812,7 +824,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		if (pci_pci_problems & PCIPCI_VIAETBF)
 			printk(KERN_INFO "%s: quirk: PCIPCI_VIAETBF\n", dev->name);
 		if (pci_pci_problems & PCIPCI_VSFX)
-			printk(KERN_INFO "%s: quirk: PCIPCI_VSFX\n",dev->name);
+			printk(KERN_INFO "%s: quirk: PCIPCI_VSFX\n", dev->name);
 #ifdef PCIPCI_ALIMAGIK
 		if (pci_pci_problems & PCIPCI_ALIMAGIK) {
 			printk(KERN_INFO "%s: quirk: PCIPCI_ALIMAGIK -- latency fixup\n",
@@ -823,7 +835,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		if (pci_pci_problems & (PCIPCI_FAIL|PCIAGP_FAIL)) {
 			printk(KERN_INFO "%s: quirk: this driver and your "
 					"chipset may not work together"
-					" in overlay mode.\n",dev->name);
+					" in overlay mode.\n", dev->name);
 			if (!saa7134_no_overlay) {
 				printk(KERN_INFO "%s: quirk: overlay "
 						"mode will be disabled.\n",
@@ -839,7 +851,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	}
 	if (UNSET != latency) {
 		printk(KERN_INFO "%s: setting pci latency timer to %d\n",
-		       dev->name,latency);
+		       dev->name, latency);
 		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, latency);
 	}
 
@@ -849,10 +861,10 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	printk(KERN_INFO "%s: found at %s, rev: %d, irq: %d, "
 	       "latency: %d, mmio: 0x%llx\n", dev->name,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
-	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
+	       dev->pci_lat, (unsigned long long)pci_resource_start(pci_dev, 0));
 	pci_set_master(pci_dev);
 	if (!pci_dma_supported(pci_dev, DMA_BIT_MASK(32))) {
-		printk("%s: Oops: no 32bit PCI DMA ???\n",dev->name);
+		printk("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail1;
 	}
@@ -873,18 +885,18 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	if (UNSET != tuner[dev->nr])
 		dev->tuner_type = tuner[dev->nr];
 	printk(KERN_INFO "%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
-		dev->name,pci_dev->subsystem_vendor,
-		pci_dev->subsystem_device,saa7134_boards[dev->board].name,
+		dev->name, pci_dev->subsystem_vendor,
+		pci_dev->subsystem_device, saa7134_boards[dev->board].name,
 		dev->board, dev->autodetected ?
 		"autodetected" : "insmod option");
 
 	/* get mmio */
-	if (!request_mem_region(pci_resource_start(pci_dev,0),
-				pci_resource_len(pci_dev,0),
+	if (!request_mem_region(pci_resource_start(pci_dev, 0),
+				pci_resource_len(pci_dev, 0),
 				dev->name)) {
 		err = -EBUSY;
 		printk(KERN_ERR "%s: can't get MMIO memory @ 0x%llx\n",
-		       dev->name,(unsigned long long)pci_resource_start(pci_dev,0));
+		       dev->name, (unsigned long long)pci_resource_start(pci_dev, 0));
 		goto fail1;
 	}
 	dev->lmmio = ioremap(pci_resource_start(pci_dev, 0),
@@ -906,7 +918,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
-		       dev->name,pci_dev->irq);
+		       dev->name, pci_dev->irq);
 		goto fail3;
 	}
 
@@ -944,8 +956,8 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	if (saa7134_no_overlay > 0)
 		printk(KERN_INFO "%s: Overlay support disabled.\n", dev->name);
 
-	dev->video_dev = vdev_init(dev,&saa7134_video_template,"video");
-	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
+	dev->video_dev = vdev_init(dev, &saa7134_video_template, "video");
+	err = video_register_device(dev->video_dev, VFL_TYPE_GRABBER,
 				    video_nr[dev->nr]);
 	if (err < 0) {
 		printk(KERN_INFO "%s: can't register video device\n",
@@ -971,8 +983,8 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	saa7134_hwfini(dev);
 	iounmap(dev->lmmio);
  fail2:
-	release_mem_region(pci_resource_start(pci_dev,0),
-			   pci_resource_len(pci_dev,0));
+	release_mem_region(pci_resource_start(pci_dev, 0),
+			   pci_resource_len(pci_dev, 0));
  fail1:
 	v4l2_device_unregister(&dev->v4l2_dev);
  fail0:
@@ -985,24 +997,23 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct saa7134_dev *dev = container_of(v4l2_dev, struct saa7134_dev, v4l2_dev);
 	/* Release DMA sound modules if present */
-	if (saa7134_dmasound_exit && dev->dmasound.priv_data) {
+	if (saa7134_dmasound_exit && dev->dmasound.priv_data)
 		saa7134_dmasound_exit(dev);
-	}
 
 	/* debugging ... */
 	if (irq_debug) {
 		u32 report = saa_readl(SAA7134_IRQ_REPORT);
 		u32 status = saa_readl(SAA7134_IRQ_STATUS);
-		print_irqstatus(dev,42,report,status);
+		print_irqstatus(dev, 42, report, status);
 	}
 
 	/* disable peripheral devices */
-	saa_writeb(SAA7134_SPECIAL_MODE,0);
+	saa_writeb(SAA7134_SPECIAL_MODE, 0);
 
 	/* shutdown hardware */
-	saa_writel(SAA7134_IRQ1,0);
-	saa_writel(SAA7134_IRQ2,0);
-	saa_writel(SAA7134_MAIN_CTRL,0);
+	saa_writel(SAA7134_IRQ1, 0);
+	saa_writel(SAA7134_IRQ2, 0);
+	saa_writel(SAA7134_MAIN_CTRL, 0);
 
 	/* shutdown subsystems */
 	saa7134_hwfini(dev);
@@ -1026,8 +1037,8 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 	/* release resources */
 	free_irq(pci_dev->irq, dev);
 	iounmap(dev->lmmio);
-	release_mem_region(pci_resource_start(pci_dev,0),
-			   pci_resource_len(pci_dev,0));
+	release_mem_region(pci_resource_start(pci_dev, 0),
+			   pci_resource_len(pci_dev, 0));
 
 
 	v4l2_device_unregister(&dev->v4l2_dev);
@@ -1039,6 +1050,10 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 #ifdef CONFIG_PM
 
 /* resends a current buffer in queue after resume */
+/*
+ * For tests kernel compiled w/o CONFIG_PM, so no need to port this now.
+ *
+ */
 static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 				  struct saa7134_dmaqueue *q)
 {
@@ -1048,12 +1063,12 @@ static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 
 	buf  = q->curr;
 	next = buf;
-	dprintk("buffer_requeue\n");
+	printk("buffer_requeue\n");
 
 	if (!buf)
 		return 0;
 
-	dprintk("buffer_requeue : resending active buffers \n");
+	printk("buffer_requeue : resending active buffers\n");
 
 	if (!list_empty(&q->queue))
 		next = list_entry(q->queue.next, struct saa7134_buf,
@@ -1063,6 +1078,9 @@ static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 	return 0;
 }
 
+/*
+ * For tests kernel compiled w/o CONFIG_PM, so no need to port this now.
+ */
 static int saa7134_suspend(struct pci_dev *pci_dev , pm_message_t state)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
@@ -1100,6 +1118,9 @@ static int saa7134_suspend(struct pci_dev *pci_dev , pm_message_t state)
 	return 0;
 }
 
+/*
+ * For tests kernel compiled w/o CONFIG_PM, so no need to port this now.
+ */
 static int saa7134_resume(struct pci_dev *pci_dev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 0202d20..a83d455 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -41,14 +41,15 @@ static unsigned int gbufsize      = 720*576*4;
 static unsigned int gbufsize_max  = 720*576*4;
 static char secam[] = "--";
 module_param(video_debug, int, 0644);
-MODULE_PARM_DESC(video_debug,"enable debug messages [video]");
+MODULE_PARM_DESC(video_debug, "enable debug messages [video]");
 module_param(gbuffers, int, 0444);
-MODULE_PARM_DESC(gbuffers,"number of capture buffers, range 2-32");
+MODULE_PARM_DESC(gbuffers, "number of capture buffers, range 2-32");
 module_param(noninterlaced, int, 0644);
-MODULE_PARM_DESC(noninterlaced,"capture non interlaced video");
+MODULE_PARM_DESC(noninterlaced, "capture non interlaced video");
 module_param_string(secam, secam, sizeof(secam), 0644);
 MODULE_PARM_DESC(secam, "force SECAM variant, either DK,L or Lc");
 
+extern struct vb2_alloc_ctx *alloc_ctx;
 
 #define dprintk(fmt, arg...)	if (video_debug&0x04) \
 	printk(KERN_DEBUG "%s/video: " fmt, dev->name , ## arg)
@@ -103,65 +104,65 @@ static struct saa7134_format formats[] = {
 		.fourcc   = V4L2_PIX_FMT_GREY,
 		.depth    = 8,
 		.pm       = 0x06,
-	},{
+	}, {
 		.name     = "15 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_RGB555,
 		.depth    = 16,
 		.pm       = 0x13 | 0x80,
-	},{
+	}, {
 		.name     = "15 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB555X,
 		.depth    = 16,
 		.pm       = 0x13 | 0x80,
 		.bswap    = 1,
-	},{
+	}, {
 		.name     = "16 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_RGB565,
 		.depth    = 16,
 		.pm       = 0x10 | 0x80,
-	},{
+	}, {
 		.name     = "16 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB565X,
 		.depth    = 16,
 		.pm       = 0x10 | 0x80,
 		.bswap    = 1,
-	},{
+	}, {
 		.name     = "24 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_BGR24,
 		.depth    = 24,
 		.pm       = 0x11,
-	},{
+	}, {
 		.name     = "24 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB24,
 		.depth    = 24,
 		.pm       = 0x11,
 		.bswap    = 1,
-	},{
+	}, {
 		.name     = "32 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_BGR32,
 		.depth    = 32,
 		.pm       = 0x12,
-	},{
+	}, {
 		.name     = "32 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB32,
 		.depth    = 32,
 		.pm       = 0x12,
 		.bswap    = 1,
 		.wswap    = 1,
-	},{
+	}, {
 		.name     = "4:2:2 packed, YUYV",
 		.fourcc   = V4L2_PIX_FMT_YUYV,
 		.depth    = 16,
 		.pm       = 0x00,
 		.bswap    = 1,
 		.yuv      = 1,
-	},{
+	}, {
 		.name     = "4:2:2 packed, UYVY",
 		.fourcc   = V4L2_PIX_FMT_UYVY,
 		.depth    = 16,
 		.pm       = 0x00,
 		.yuv      = 1,
-	},{
+	}, {
 		.name     = "4:2:2 planar, Y-Cb-Cr",
 		.fourcc   = V4L2_PIX_FMT_YUV422P,
 		.depth    = 16,
@@ -170,7 +171,7 @@ static struct saa7134_format formats[] = {
 		.planar   = 1,
 		.hshift   = 1,
 		.vshift   = 0,
-	},{
+	}, {
 		.name     = "4:2:0 planar, Y-Cb-Cr",
 		.fourcc   = V4L2_PIX_FMT_YUV420,
 		.depth    = 12,
@@ -179,7 +180,7 @@ static struct saa7134_format formats[] = {
 		.planar   = 1,
 		.hshift   = 1,
 		.vshift   = 1,
-	},{
+	}, {
 		.name     = "4:2:0 planar, Y-Cb-Cr",
 		.fourcc   = V4L2_PIX_FMT_YVU420,
 		.depth    = 12,
@@ -220,7 +221,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x06,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "PAL-BG",
 		.id            = V4L2_STD_PAL_BG,
 		NORM_625_50,
@@ -232,7 +233,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x06,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "PAL-I",
 		.id            = V4L2_STD_PAL_I,
 		NORM_625_50,
@@ -244,7 +245,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x06,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "PAL-DK",
 		.id            = V4L2_STD_PAL_DK,
 		NORM_625_50,
@@ -256,7 +257,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x06,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "NTSC",
 		.id            = V4L2_STD_NTSC,
 		NORM_525_60,
@@ -268,7 +269,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x0e,
 		.vgate_misc    = 0x18,
 
-	},{
+	}, {
 		.name          = "SECAM",
 		.id            = V4L2_STD_SECAM,
 		NORM_625_50,
@@ -280,7 +281,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x00,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "SECAM-DK",
 		.id            = V4L2_STD_SECAM_DK,
 		NORM_625_50,
@@ -292,7 +293,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x00,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "SECAM-L",
 		.id            = V4L2_STD_SECAM_L,
 		NORM_625_50,
@@ -304,7 +305,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x00,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "SECAM-Lc",
 		.id            = V4L2_STD_SECAM_LC,
 		NORM_625_50,
@@ -316,7 +317,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x00,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "PAL-M",
 		.id            = V4L2_STD_PAL_M,
 		NORM_525_60,
@@ -328,7 +329,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x0e,
 		.vgate_misc    = 0x18,
 
-	},{
+	}, {
 		.name          = "PAL-Nc",
 		.id            = V4L2_STD_PAL_Nc,
 		NORM_625_50,
@@ -340,7 +341,7 @@ static struct saa7134_tvnorm tvnorms[] = {
 		.chroma_ctrl2  = 0x06,
 		.vgate_misc    = 0x1c,
 
-	},{
+	}, {
 		.name          = "PAL-60",
 		.id            = V4L2_STD_PAL_60,
 
@@ -383,7 +384,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.step          = 1,
 		.default_value = 128,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
+	}, {
 		.id            = V4L2_CID_CONTRAST,
 		.name          = "Contrast",
 		.minimum       = 0,
@@ -391,7 +392,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.step          = 1,
 		.default_value = 68,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
+	}, {
 		.id            = V4L2_CID_SATURATION,
 		.name          = "Saturation",
 		.minimum       = 0,
@@ -399,7 +400,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.step          = 1,
 		.default_value = 64,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
+	}, {
 		.id            = V4L2_CID_HUE,
 		.name          = "Hue",
 		.minimum       = -128,
@@ -407,7 +408,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.step          = 1,
 		.default_value = 0,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
+	}, {
 		.id            = V4L2_CID_HFLIP,
 		.name          = "Mirror",
 		.minimum       = 0,
@@ -421,7 +422,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.minimum       = 0,
 		.maximum       = 1,
 		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
+	}, {
 		.id            = V4L2_CID_AUDIO_VOLUME,
 		.name          = "Volume",
 		.minimum       = -15,
@@ -437,7 +438,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.minimum       = 0,
 		.maximum       = 1,
 		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
+	}, {
 		.id            = V4L2_CID_PRIVATE_Y_ODD,
 		.name          = "y offset odd field",
 		.minimum       = 0,
@@ -445,7 +446,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.step          = 1,
 		.default_value = 0,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
+	}, {
 		.id            = V4L2_CID_PRIVATE_Y_EVEN,
 		.name          = "y offset even field",
 		.minimum       = 0,
@@ -453,7 +454,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 		.step          = 1,
 		.default_value = 0,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
+	}, {
 		.id            = V4L2_CID_PRIVATE_AUTOMUTE,
 		.name          = "automute",
 		.minimum       = 0,
@@ -464,7 +465,7 @@ static const struct v4l2_queryctrl video_ctrls[] = {
 };
 static const unsigned int CTRLS = ARRAY_SIZE(video_ctrls);
 
-static const struct v4l2_queryctrl* ctrl_by_id(unsigned int id)
+static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
 {
 	unsigned int i;
 
@@ -474,7 +475,7 @@ static const struct v4l2_queryctrl* ctrl_by_id(unsigned int id)
 	return NULL;
 }
 
-static struct saa7134_format* format_by_fourcc(unsigned int fourcc)
+static struct saa7134_format *format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -503,19 +504,19 @@ static int res_get(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int
 	/* it's free, grab it */
 	fh->resources  |= bit;
 	dev->resources |= bit;
-	dprintk("res: get %d\n",bit);
+	dprintk("res: get %d\n", bit);
 	mutex_unlock(&dev->lock);
 	return 1;
 }
 
 static int res_check(struct saa7134_fh *fh, unsigned int bit)
 {
-	return (fh->resources & bit);
+	return fh->resources & bit;
 }
 
 static int res_locked(struct saa7134_dev *dev, unsigned int bit)
 {
-	return (dev->resources & bit);
+	return dev->resources & bit;
 }
 
 static
@@ -526,7 +527,7 @@ void res_free(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int bits)
 	mutex_lock(&dev->lock);
 	fh->resources  &= ~bits;
 	dev->resources &= ~bits;
-	dprintk("res: put %d\n",bits);
+	dprintk("res: put %d\n", bits);
 	mutex_unlock(&dev->lock);
 }
 
@@ -534,20 +535,20 @@ void res_free(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int bits)
 
 static void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
 {
-	dprintk("set tv norm = %s\n",norm->name);
+	dprintk("set tv norm = %s\n", norm->name);
 	dev->tvnorm = norm;
 
 	/* setup cropping */
 	dev->crop_bounds.left    = norm->h_start;
 	dev->crop_defrect.left   = norm->h_start;
-	dev->crop_bounds.width   = norm->h_stop - norm->h_start +1;
-	dev->crop_defrect.width  = norm->h_stop - norm->h_start +1;
+	dev->crop_bounds.width   = norm->h_stop - norm->h_start + 1;
+	dev->crop_defrect.width  = norm->h_stop - norm->h_start + 1;
 
 	dev->crop_bounds.top     = (norm->vbi_v_stop_0+1)*2;
 	dev->crop_defrect.top    = norm->video_v_start*2;
 	dev->crop_bounds.height  = ((norm->id & V4L2_STD_525_60) ? 524 : 624)
 		- dev->crop_bounds.top;
-	dev->crop_defrect.height = (norm->video_v_stop - norm->video_v_start +1)*2;
+	dev->crop_defrect.height = (norm->video_v_stop - norm->video_v_start + 1) * 2;
 
 	dev->crop_current = dev->crop_defrect;
 
@@ -665,7 +666,7 @@ static void set_h_prescale(struct saa7134_dev *dev, int task, int prescale)
 
 static void set_v_scale(struct saa7134_dev *dev, int task, int yscale)
 {
-	int val,mirror;
+	int val, mirror;
 
 	saa_writeb(SAA7134_V_SCALE_RATIO1(task), yscale &  0xff);
 	saa_writeb(SAA7134_V_SCALE_RATIO2(task), yscale >> 8);
@@ -673,14 +674,14 @@ static void set_v_scale(struct saa7134_dev *dev, int task, int yscale)
 	mirror = (dev->ctl_mirror) ? 0x02 : 0x00;
 	if (yscale < 2048) {
 		/* LPI */
-		dprintk("yscale LPI yscale=%d\n",yscale);
+		dprintk("yscale LPI yscale=%d\n", yscale);
 		saa_writeb(SAA7134_V_FILTER(task), 0x00 | mirror);
 		saa_writeb(SAA7134_LUMA_CONTRAST(task), 0x40);
 		saa_writeb(SAA7134_CHROMA_SATURATION(task), 0x40);
 	} else {
 		/* ACM */
 		val = 0x40 * 1024 / yscale;
-		dprintk("yscale ACM yscale=%d val=0x%x\n",yscale,val);
+		dprintk("yscale ACM yscale=%d val=0x%x\n", yscale, val);
 		saa_writeb(SAA7134_V_FILTER(task), 0x01 | mirror);
 		saa_writeb(SAA7134_LUMA_CONTRAST(task), val);
 		saa_writeb(SAA7134_CHROMA_SATURATION(task), val);
@@ -691,15 +692,15 @@ static void set_v_scale(struct saa7134_dev *dev, int task, int yscale)
 static void set_size(struct saa7134_dev *dev, int task,
 		     int width, int height, int interlace)
 {
-	int prescale,xscale,yscale,y_even,y_odd;
+	int prescale, xscale, yscale, y_even, y_odd;
 	int h_start, h_stop, v_start, v_stop;
 	int div = interlace ? 2 : 1;
 
 	/* setup video scaler */
 	h_start = dev->crop_current.left;
 	v_start = dev->crop_current.top/2;
-	h_stop  = (dev->crop_current.left + dev->crop_current.width -1);
-	v_stop  = (dev->crop_current.top + dev->crop_current.height -1)/2;
+	h_stop  = (dev->crop_current.left + dev->crop_current.width - 1);
+	v_stop  = (dev->crop_current.top + dev->crop_current.height - 1) / 2;
 
 	saa_writeb(SAA7134_VIDEO_H_START1(task), h_start &  0xff);
 	saa_writeb(SAA7134_VIDEO_H_START2(task), h_start >> 8);
@@ -715,11 +716,11 @@ static void set_size(struct saa7134_dev *dev, int task,
 		prescale = 1;
 	xscale = 1024 * dev->crop_current.width / prescale / width;
 	yscale = 512 * div * dev->crop_current.height / height;
-	dprintk("prescale=%d xscale=%d yscale=%d\n",prescale,xscale,yscale);
-	set_h_prescale(dev,task,prescale);
+	dprintk("prescale=%d xscale=%d yscale=%d\n", prescale, xscale, yscale);
+	set_h_prescale(dev, task, prescale);
 	saa_writeb(SAA7134_H_SCALE_INC1(task),      xscale &  0xff);
 	saa_writeb(SAA7134_H_SCALE_INC2(task),      xscale >> 8);
-	set_v_scale(dev,task,yscale);
+	set_v_scale(dev, task, yscale);
 
 	saa_writeb(SAA7134_VIDEO_PIXELS1(task),     width  & 0xff);
 	saa_writeb(SAA7134_VIDEO_PIXELS2(task),     width  >> 8);
@@ -758,11 +759,11 @@ static void set_cliplist(struct saa7134_dev *dev, int reg,
 		saa_writeb(reg + 2, cl[i].position & 0xff);
 		saa_writeb(reg + 3, cl[i].position >> 8);
 		dprintk("clip: %s winbits=%02x pos=%d\n",
-			name,winbits,cl[i].position);
+			name, winbits, cl[i].position);
 		reg += 8;
 	}
 	for (; reg < 0x400; reg += 8) {
-		saa_writeb(reg+ 0, 0);
+		saa_writeb(reg + 0, 0);
 		saa_writeb(reg + 1, 0);
 		saa_writeb(reg + 2, 0);
 		saa_writeb(reg + 3, 0);
@@ -814,8 +815,8 @@ static int setup_clipping(struct saa7134_dev *dev, struct v4l2_clip *clips,
 	}
 	sort(col, cols, sizeof col[0], cliplist_cmp, NULL);
 	sort(row, rows, sizeof row[0], cliplist_cmp, NULL);
-	set_cliplist(dev,0x380,col,cols,"cols");
-	set_cliplist(dev,0x384,row,rows,"rows");
+	set_cliplist(dev, 0x380, col, cols, "cols");
+	set_cliplist(dev, 0x384, row, rows, "rows");
 	return 0;
 }
 
@@ -863,23 +864,23 @@ static int verify_preview(struct saa7134_dev *dev, struct v4l2_window *win)
 
 static int start_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
 {
-	unsigned long base,control,bpl;
+	unsigned long base, control, bpl;
 	int err;
 
-	err = verify_preview(dev,&fh->win);
+	err = verify_preview(dev, &fh->win);
 	if (0 != err)
 		return err;
 
 	dev->ovfield = fh->win.field;
 	dprintk("start_preview %dx%d+%d+%d %s field=%s\n",
-		fh->win.w.width,fh->win.w.height,
-		fh->win.w.left,fh->win.w.top,
-		dev->ovfmt->name,v4l2_field_names[dev->ovfield]);
+		fh->win.w.width, fh->win.w.height,
+		fh->win.w.left, fh->win.w.top,
+		dev->ovfmt->name, v4l2_field_names[dev->ovfield]);
 
 	/* setup window + clipping */
-	set_size(dev,TASK_B,fh->win.w.width,fh->win.w.height,
+	set_size(dev, TASK_B, fh->win.w.width, fh->win.w.height,
 		 V4L2_FIELD_HAS_BOTH(dev->ovfield));
-	setup_clipping(dev,fh->clips,fh->nclips,
+	setup_clipping(dev, fh->clips, fh->nclips,
 		       V4L2_FIELD_HAS_BOTH(dev->ovfield));
 	if (dev->ovfmt->yuv)
 		saa_andorb(SAA7134_DATA_PATH(TASK_B), 0x3f, 0x03);
@@ -898,15 +899,15 @@ static int start_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
 	if (dev->ovfmt->wswap)
 		control |= SAA7134_RS_CONTROL_WSWAP;
 	if (V4L2_FIELD_HAS_BOTH(dev->ovfield)) {
-		saa_writel(SAA7134_RS_BA1(1),base);
-		saa_writel(SAA7134_RS_BA2(1),base+bpl);
-		saa_writel(SAA7134_RS_PITCH(1),bpl*2);
-		saa_writel(SAA7134_RS_CONTROL(1),control);
+		saa_writel(SAA7134_RS_BA1(1), base);
+		saa_writel(SAA7134_RS_BA2(1), base + bpl);
+		saa_writel(SAA7134_RS_PITCH(1), bpl * 2);
+		saa_writel(SAA7134_RS_CONTROL(1), control);
 	} else {
-		saa_writel(SAA7134_RS_BA1(1),base);
-		saa_writel(SAA7134_RS_BA2(1),base);
-		saa_writel(SAA7134_RS_PITCH(1),bpl);
-		saa_writel(SAA7134_RS_CONTROL(1),control);
+		saa_writel(SAA7134_RS_BA1(1), base);
+		saa_writel(SAA7134_RS_BA2(1), base);
+		saa_writel(SAA7134_RS_PITCH(1), bpl);
+		saa_writel(SAA7134_RS_CONTROL(1), control);
 	}
 
 	/* start dma */
@@ -929,15 +930,15 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
-	unsigned long base,control,bpl;
-	unsigned long bpl_uv,lines_uv,base2,base3,tmp; /* planar */
+	unsigned long base, control, bpl;
+	unsigned long bpl_uv, lines_uv, base2, base3, tmp; /* planar */
 
-	dprintk("buffer_activate buf=%p\n",buf);
-	buf->vb.state = VIDEOBUF_ACTIVE;
+	printk("buffer_activate buf=%p\n", buf);
+	/* buf->vb.state = VIDEOBUF_ACTIVE; */
 	buf->top_seen = 0;
 
-	set_size(dev,TASK_A,buf->vb.width,buf->vb.height,
-		 V4L2_FIELD_HAS_BOTH(buf->vb.field));
+	set_size(dev, TASK_A, buf->width, buf->height,
+		 V4L2_FIELD_HAS_BOTH(buf->vb2.v4l2_buf.field));
 	if (buf->fmt->yuv)
 		saa_andorb(SAA7134_DATA_PATH(TASK_A), 0x3f, 0x03);
 	else
@@ -947,9 +948,9 @@ static int buffer_activate(struct saa7134_dev *dev,
 	/* DMA: setup channel 0 (= Video Task A0) */
 	base  = saa7134_buffer_base(buf);
 	if (buf->fmt->planar)
-		bpl = buf->vb.width;
+		bpl = buf->width;
 	else
-		bpl = (buf->vb.width * buf->fmt->depth) / 8;
+		bpl = (buf->width * buf->fmt->depth) / 8;
 	control = SAA7134_RS_CONTROL_BURST_16 |
 		SAA7134_RS_CONTROL_ME |
 		(buf->pt->dma >> 12);
@@ -957,48 +958,48 @@ static int buffer_activate(struct saa7134_dev *dev,
 		control |= SAA7134_RS_CONTROL_BSWAP;
 	if (buf->fmt->wswap)
 		control |= SAA7134_RS_CONTROL_WSWAP;
-	if (V4L2_FIELD_HAS_BOTH(buf->vb.field)) {
+	if (V4L2_FIELD_HAS_BOTH(buf->vb2.v4l2_buf.field)) {
 		/* interlaced */
-		saa_writel(SAA7134_RS_BA1(0),base);
-		saa_writel(SAA7134_RS_BA2(0),base+bpl);
-		saa_writel(SAA7134_RS_PITCH(0),bpl*2);
+		saa_writel(SAA7134_RS_BA1(0), base);
+		saa_writel(SAA7134_RS_BA2(0), base + bpl);
+		saa_writel(SAA7134_RS_PITCH(0), bpl * 2);
 	} else {
 		/* non-interlaced */
-		saa_writel(SAA7134_RS_BA1(0),base);
-		saa_writel(SAA7134_RS_BA2(0),base);
-		saa_writel(SAA7134_RS_PITCH(0),bpl);
+		saa_writel(SAA7134_RS_BA1(0), base);
+		saa_writel(SAA7134_RS_BA2(0), base);
+		saa_writel(SAA7134_RS_PITCH(0), bpl);
 	}
-	saa_writel(SAA7134_RS_CONTROL(0),control);
+	saa_writel(SAA7134_RS_CONTROL(0), control);
 
 	if (buf->fmt->planar) {
 		/* DMA: setup channel 4+5 (= planar task A) */
 		bpl_uv   = bpl >> buf->fmt->hshift;
-		lines_uv = buf->vb.height >> buf->fmt->vshift;
-		base2    = base + bpl * buf->vb.height;
+		lines_uv = buf->height >> buf->fmt->vshift;
+		base2    = base + bpl * buf->height;
 		base3    = base2 + bpl_uv * lines_uv;
 		if (buf->fmt->uvswap)
 			tmp = base2, base2 = base3, base3 = tmp;
-		dprintk("uv: bpl=%ld lines=%ld base2/3=%ld/%ld\n",
-			bpl_uv,lines_uv,base2,base3);
-		if (V4L2_FIELD_HAS_BOTH(buf->vb.field)) {
+		printk("uv: bpl=%ld lines=%ld base2/3=%ld/%ld\n",
+			bpl_uv, lines_uv, base2, base3);
+		if (V4L2_FIELD_HAS_BOTH(buf->vb2.v4l2_buf.field)) {
 			/* interlaced */
-			saa_writel(SAA7134_RS_BA1(4),base2);
-			saa_writel(SAA7134_RS_BA2(4),base2+bpl_uv);
-			saa_writel(SAA7134_RS_PITCH(4),bpl_uv*2);
-			saa_writel(SAA7134_RS_BA1(5),base3);
-			saa_writel(SAA7134_RS_BA2(5),base3+bpl_uv);
-			saa_writel(SAA7134_RS_PITCH(5),bpl_uv*2);
+			saa_writel(SAA7134_RS_BA1(4), base2);
+			saa_writel(SAA7134_RS_BA2(4), base2 + bpl_uv);
+			saa_writel(SAA7134_RS_PITCH(4), bpl_uv * 2);
+			saa_writel(SAA7134_RS_BA1(5), base3);
+			saa_writel(SAA7134_RS_BA2(5), base3 + bpl_uv);
+			saa_writel(SAA7134_RS_PITCH(5), bpl_uv * 2);
 		} else {
 			/* non-interlaced */
-			saa_writel(SAA7134_RS_BA1(4),base2);
-			saa_writel(SAA7134_RS_BA2(4),base2);
-			saa_writel(SAA7134_RS_PITCH(4),bpl_uv);
-			saa_writel(SAA7134_RS_BA1(5),base3);
-			saa_writel(SAA7134_RS_BA2(5),base3);
-			saa_writel(SAA7134_RS_PITCH(5),bpl_uv);
+			saa_writel(SAA7134_RS_BA1(4), base2);
+			saa_writel(SAA7134_RS_BA2(4), base2);
+			saa_writel(SAA7134_RS_PITCH(4), bpl_uv);
+			saa_writel(SAA7134_RS_BA1(5), base3);
+			saa_writel(SAA7134_RS_BA2(5), base3);
+			saa_writel(SAA7134_RS_PITCH(5), bpl_uv);
 		}
-		saa_writel(SAA7134_RS_CONTROL(4),control);
-		saa_writel(SAA7134_RS_CONTROL(5),control);
+		saa_writel(SAA7134_RS_CONTROL(4), control);
+		saa_writel(SAA7134_RS_CONTROL(5), control);
 	}
 
 	/* start DMA */
@@ -1007,15 +1008,30 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-static int buffer_prepare(struct videobuf_queue *q,
-			  struct videobuf_buffer *vb,
-			  enum v4l2_field field)
+static int buffer_init(struct vb2_buffer *vb2)
 {
-	struct saa7134_fh *fh = q->priv_data;
+	struct saa7134_fh *fh = vb2->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = fh->dev;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+
+	buf->width  = fh->width;
+	buf->height = fh->height;
+	buf->fmt       = fh->fmt; /* -"- */
+	buf->pt        = &fh->pt_cap; /* -"- */
+	dev->video_q.curr = NULL;
+	buf->activate = buffer_activate;
+
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb2)
+{
+	struct saa7134_fh *fh = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 	unsigned int size;
 	int err;
+	struct vb2_dma_sg_desc *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 
 	/* sanity checks */
 	if (NULL == fh->fmt)
@@ -1028,89 +1044,123 @@ static int buffer_prepare(struct videobuf_queue *q,
 	    fh->height   > dev->crop_bounds.height)
 		return -EINVAL;
 	size = (fh->width * fh->height * fh->fmt->depth) >> 3;
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
+	/*if (0 != buf->vb.baddr  &&  vb2_plane_size(buf->vb2, 0) < size)*/
+	if (vb2_plane_size(vb2, 0) < size)
 		return -EINVAL;
 
-	dprintk("buffer_prepare [%d,size=%dx%d,bytes=%d,fields=%s,%s]\n",
-		vb->i,fh->width,fh->height,size,v4l2_field_names[field],
-		fh->fmt->name);
-	if (buf->vb.width  != fh->width  ||
-	    buf->vb.height != fh->height ||
-	    buf->vb.size   != size       ||
-	    buf->vb.field  != field      ||
+#if 0
+	if (buf->width  != fh->width  ||
+	    buf->height != fh->height ||
+	    vb2_plane_size(&buf->vb2, 0) != size ||
+	    /* buf->vb2.v4l2_buf.field  != field || */
 	    buf->fmt       != fh->fmt) {
-		saa7134_dma_free(q,buf);
+		saa7134_dma_free(vb2->vb2_queue, buf);
+		printk("%s freeing dma!\n", __func__);
 	}
+#endif
+
+	vb2_set_plane_payload(vb2, 0, fh->fmt->depth * fh->width * fh->height >> 3);
+
+	printk("%s: sglist:%p num_pages:%d\n", __func__, dma->sglist, dma->num_pages);
+	dma_map_sg(&(dev->pci->dev), dma->sglist, dma->num_pages, DMA_FROM_DEVICE);
 
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-
-		buf->vb.width  = fh->width;
-		buf->vb.height = fh->height;
-		buf->vb.size   = size;
-		buf->vb.field  = field;
-		buf->fmt       = fh->fmt;
-		buf->pt        = &fh->pt_cap;
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
+	err = saa7134_pgtable_build(dev->pci, buf->pt,
+				    dma->sglist,
+				    dma->num_pages,
+				    saa7134_buffer_startpage(buf));
+
+	if (err) {
+		printk("%s: saa7134_pgtable_build failed with %d\n", __func__, err);
+		dma_unmap_sg(&(dev->pci->dev), dma->sglist, dma->num_pages, DMA_FROM_DEVICE);
 	}
-	buf->vb.state = VIDEOBUF_PREPARED;
-	buf->activate = buffer_activate;
-	return 0;
 
- oops:
-	saa7134_dma_free(q,buf);
 	return err;
 }
 
-static int
-buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
+static int buffer_finish(struct vb2_buffer *vb2)
 {
-	struct saa7134_fh *fh = q->priv_data;
+	struct saa7134_fh *fh = vb2->vb2_queue->drv_priv;
+	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct vb2_dma_sg_desc *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+
+	dma_unmap_sg(&(dev->pci->dev), dma->sglist, dma->num_pages, DMA_FROM_DEVICE);
 
-	*size = fh->fmt->depth * fh->width * fh->height >> 3;
-	if (0 == *count)
-		*count = gbuffers;
-	*count = saa7134_buffer_count(*size,*count);
 	return 0;
 }
 
-static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static int queue_setup(struct vb2_queue *q, unsigned int *nbuffers,
+				unsigned int *nplanes, unsigned long sizes[],
+				void *alloc_ctxs[])
 {
-	struct saa7134_fh *fh = q->priv_data;
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_fh *fh = q->drv_priv;
+	int size = fh->fmt->depth * fh->width * fh->height >> 3;
 
-	saa7134_buffer_queue(fh->dev,&fh->dev->video_q,buf);
+	printk("%s\n", __func__);
+
+	*nbuffers = saa7134_buffer_count(size, *nbuffers);
+	*nplanes = 1;
+	sizes[0] = size;
+	/* use default alloc_ctx */
+	return 0;
 }
 
-static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+/*
+ * move buffer to hardware queue
+ */
+static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct saa7134_buf *buf = container_of(vb,struct saa7134_buf,vb);
+	struct saa7134_fh *fh = vb->vb2_queue->drv_priv;
+	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb2);
+
+	printk("%s\n", __func__);
 
-	saa7134_dma_free(q,buf);
+	saa7134_buffer_queue(fh->dev, &fh->dev->video_q, buf);
 }
 
-static struct videobuf_queue_ops video_qops = {
-	.buf_setup    = buffer_setup,
-	.buf_prepare  = buffer_prepare,
-	.buf_queue    = buffer_queue,
-	.buf_release  = buffer_release,
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct saa7134_fh *fh = vq->drv_priv;
+	struct saa7134_dev *dev = fh->dev;
+	printk("%s\n", __func__);
+	saa7134_stop_streaming(dev, &dev->video_q);
+
+	return 0;
+}
+
+static void wait_prepare(struct vb2_queue *vq)
+{
+	struct saa7134_fh *fh = vq->drv_priv;
+	struct saa7134_dev *dev = fh->dev;
+
+	mutex_lock(&dev->lock);
+}
+
+static void wait_finish(struct vb2_queue *vq)
+{
+	struct saa7134_fh *fh = vq->drv_priv;
+	struct saa7134_dev *dev = fh->dev;
+
+	mutex_unlock(&dev->lock);
+}
+
+static struct vb2_ops vb2_qops = {
+	.queue_setup	= queue_setup,
+	.buf_init	= buffer_init,
+	.buf_prepare	= buffer_prepare,
+	.buf_queue	= buffer_queue,
+	.buf_finish	= buffer_finish,
+	.wait_prepare	= wait_prepare,
+	.wait_finish	= wait_finish,
+	/*.start_streaming default */
+	.stop_streaming = stop_streaming,
 };
 
 /* ------------------------------------------------------------------ */
 
 int saa7134_g_ctrl_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, struct v4l2_control *c)
 {
-	const struct v4l2_queryctrl* ctrl;
+	const struct v4l2_queryctrl *ctrl;
 
 	ctrl = ctrl_by_id(c->id);
 	if (NULL == ctrl)
@@ -1165,7 +1215,7 @@ static int saa7134_g_ctrl(struct file *file, void *priv, struct v4l2_control *c)
 
 int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c)
 {
-	const struct v4l2_queryctrl* ctrl;
+	const struct v4l2_queryctrl *ctrl;
 	unsigned long flags;
 	int restart_overlay = 0;
 	int err;
@@ -1186,7 +1236,7 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
 	if (NULL == ctrl)
 		goto error;
 
-	dprintk("set_control name=%s val=%d\n",ctrl->name,c->value);
+	dprintk("set_control name=%s val=%d\n", ctrl->name, c->value);
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_BOOLEAN:
 	case V4L2_CTRL_TYPE_MENU:
@@ -1260,10 +1310,10 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
 		goto error;
 	}
 	if (restart_overlay && fh && res_check(fh, RESOURCE_OVERLAY)) {
-		spin_lock_irqsave(&dev->slock,flags);
-		stop_preview(dev,fh);
-		start_preview(dev,fh);
-		spin_unlock_irqrestore(&dev->slock,flags);
+		spin_lock_irqsave(&dev->slock, flags);
+		stop_preview(dev, fh);
+		start_preview(dev, fh);
+		spin_unlock_irqrestore(&dev->slock, flags);
 	}
 	err = 0;
 
@@ -1282,9 +1332,9 @@ static int saa7134_s_ctrl(struct file *file, void *f, struct v4l2_control *c)
 
 /* ------------------------------------------------------------------ */
 
-static struct videobuf_queue* saa7134_queue(struct saa7134_fh *fh)
+static struct vb2_queue *saa7134_queue(struct saa7134_fh *fh)
 {
-	struct videobuf_queue* q = NULL;
+	struct vb2_queue *q = NULL;
 
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
@@ -1314,6 +1364,7 @@ static int video_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh;
+	struct vb2_queue *q;
 	enum v4l2_buf_type type = 0;
 
 
@@ -1328,9 +1379,8 @@ static int video_open(struct file *file)
 	}
 
 
-
 	/* allocate + initialize per filehandle data */
-	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh)
 		return -ENOMEM;
 
@@ -1343,88 +1393,42 @@ static int video_open(struct file *file)
 	fh->height   = 576;
 	v4l2_prio_open(&dev->prio, &fh->prio);
 
-	videobuf_queue_sg_init(&fh->cap, &video_qops,
+	/* videobuf_queue_sg_init(&fh->cap, &video_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7134_buf),
-			    fh, NULL);
-
-	saa7134_pgtable_alloc(dev->pci,&fh->pt_cap);
-
-
-
-		/* switch to video/vbi mode */
-		video_mux(dev,dev->ctl_input);
+			    fh, NULL); */
+	/* alloc_ctx - in probe put it into dev */
+	/* vb2_queue_init dev comes from queue priv*/
+	q = &fh->cap;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = fh;
+	q->ops = &vb2_qops;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->buf_struct_size = sizeof(struct saa7134_buf);
+
+	vb2_queue_init(q);
+	saa7134_pgtable_alloc(dev->pci, &fh->pt_cap);
+
+	/* switch to video/vbi mode */
+	video_mux(dev, dev->ctl_input);
 
 	return 0;
 }
 
-static ssize_t
-video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
-{
-	struct saa7134_fh *fh = file->private_data;
-
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (res_locked(fh->dev,RESOURCE_VIDEO))
-			return -EBUSY;
-		return videobuf_read_one(saa7134_queue(fh),
-					 data, count, ppos,
-					 file->f_flags & O_NONBLOCK);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (!res_get(fh->dev,fh,RESOURCE_VBI))
-			return -EBUSY;
-		return videobuf_read_stream(saa7134_queue(fh),
-					    data, count, ppos, 1,
-					    file->f_flags & O_NONBLOCK);
-		break;
-	default:
-		BUG();
-		return 0;
-	}
-}
 
 static unsigned int
 video_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct saa7134_fh *fh = file->private_data;
-	struct videobuf_buffer *buf = NULL;
-	unsigned int rc = 0;
-
-
-
-	if (res_check(fh,RESOURCE_VIDEO)) {
-		mutex_lock(&fh->cap.vb_lock);
-		if (!list_empty(&fh->cap.stream))
-			buf = list_entry(fh->cap.stream.next, struct videobuf_buffer, stream);
-	} else {
-		mutex_lock(&fh->cap.vb_lock);
-		if (UNSET == fh->cap.read_off) {
-			/* need to capture a new frame */
-			if (res_locked(fh->dev,RESOURCE_VIDEO))
-				goto err;
-			if (0 != fh->cap.ops->buf_prepare(&fh->cap,fh->cap.read_buf,fh->cap.field))
-				goto err;
-			fh->cap.ops->buf_queue(&fh->cap,fh->cap.read_buf);
-			fh->cap.read_off = 0;
-		}
-		buf = fh->cap.read_buf;
-	}
-
-	if (!buf)
-		goto err;
-
-	poll_wait(file, &buf->done, wait);
-	if (buf->state == VIDEOBUF_DONE ||
-	    buf->state == VIDEOBUF_ERROR)
-		rc = POLLIN|POLLRDNORM;
-	mutex_unlock(&fh->cap.vb_lock);
-	return rc;
+	/*
+	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)
+		return videobuf_poll_stream(file, &fh->vbi, wait);*/
 
-err:
-	mutex_unlock(&fh->cap.vb_lock);
-	return POLLERR;
+	printk("%s: %p\n", __func__, saa7134_queue(fh));
+	return vb2_poll(saa7134_queue(fh), file, wait);
 }
 
 static int video_release(struct file *file)
@@ -1436,21 +1440,22 @@ static int video_release(struct file *file)
 
 	/* turn off overlay */
 	if (res_check(fh, RESOURCE_OVERLAY)) {
-		spin_lock_irqsave(&dev->slock,flags);
-		stop_preview(dev,fh);
-		spin_unlock_irqrestore(&dev->slock,flags);
-		res_free(dev,fh,RESOURCE_OVERLAY);
+		spin_lock_irqsave(&dev->slock, flags);
+		stop_preview(dev, fh);
+		spin_unlock_irqrestore(&dev->slock, flags);
+		res_free(dev, fh, RESOURCE_OVERLAY);
 	}
 
 	/* stop video capture */
 	if (res_check(fh, RESOURCE_VIDEO)) {
-		videobuf_streamoff(&fh->cap);
-		res_free(dev,fh,RESOURCE_VIDEO);
+		//videobuf_streamoff(&fh->cap);
+		res_free(dev, fh, RESOURCE_VIDEO);
 	}
+	/*
 	if (fh->cap.read_buf) {
 		buffer_release(&fh->cap,fh->cap.read_buf);
 		kfree(fh->cap.read_buf);
-	}
+	}*/
 
 	/* stop vbi capture */
 
@@ -1459,10 +1464,9 @@ static int video_release(struct file *file)
 
 
 	/* free stuff */
-	videobuf_mmap_free(&fh->cap);
-
-	saa7134_pgtable_free(dev->pci,&fh->pt_cap);
-
+	saa7134_pgtable_free(dev->pci, &fh->pt_cap);
+	/* vb2_queue_release */
+	vb2_queue_release(&fh->cap);
 
 	v4l2_prio_close(&dev->prio, fh->prio);
 	file->private_data = NULL;
@@ -1474,7 +1478,7 @@ static int video_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct saa7134_fh *fh = file->private_data;
 
-	return videobuf_mmap_mapper(saa7134_queue(fh), vma);
+	return vb2_mmap(saa7134_queue(fh), vma);
 }
 
 
@@ -1487,7 +1491,8 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width        = fh->width;
 	f->fmt.pix.height       = fh->height;
-	f->fmt.pix.field        = fh->cap.field;
+	/* f->fmt.pix.field        = fh->cap.field; */
+	f->fmt.pix.field        =  0; /* fh->dev->video_q.curr->vb2.v4l2_buf.field; */
 	f->fmt.pix.pixelformat  = fh->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fh->fmt->depth) >> 3;
@@ -1588,7 +1593,7 @@ static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 	fh->fmt       = format_by_fourcc(f->fmt.pix.pixelformat);
 	fh->width     = f->fmt.pix.width;
 	fh->height    = f->fmt.pix.height;
-	fh->cap.field = f->fmt.pix.field;
+	/* fh->dev->video_q.curr->vb2.v4l2_buf.field = f->fmt.pix.field; */
 	return 0;
 }
 
@@ -2096,7 +2101,7 @@ static int saa7134_overlay(struct file *file, void *f, unsigned int on)
 
 	if (on) {
 		if (saa7134_no_overlay > 0) {
-			dprintk("no_overlay\n");
+			printk("no_overlay\n");
 			return -EINVAL;
 		}
 
@@ -2121,26 +2126,30 @@ static int saa7134_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
 {
 	struct saa7134_fh *fh = priv;
-	return videobuf_reqbufs(saa7134_queue(fh), p);
+	printk("%s: %p %p\n", __func__, saa7134_queue(fh), p);
+	return vb2_reqbufs(saa7134_queue(fh), p);
 }
 
 static int saa7134_querybuf(struct file *file, void *priv,
 					struct v4l2_buffer *b)
 {
 	struct saa7134_fh *fh = priv;
-	return videobuf_querybuf(saa7134_queue(fh), b);
+	printk("%s: %p %p\n", __func__, saa7134_queue(fh), b);
+	return vb2_querybuf(saa7134_queue(fh), b);
 }
 
 static int saa7134_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct saa7134_fh *fh = priv;
-	return videobuf_qbuf(saa7134_queue(fh), b);
+	printk("%s: %p %p\n", __func__, saa7134_queue(fh), b);
+	return vb2_qbuf(saa7134_queue(fh), b);
 }
 
 static int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct saa7134_fh *fh = priv;
-	return videobuf_dqbuf(saa7134_queue(fh), b,
+	printk("%s: %p %p\n", __func__, saa7134_queue(fh), b);
+	return vb2_dqbuf(saa7134_queue(fh), b,
 				file->f_flags & O_NONBLOCK);
 }
 
@@ -2150,11 +2159,12 @@ static int saa7134_streamon(struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 	int res = saa7134_resource(fh);
+	printk("%s: %p\n", __func__, saa7134_queue(fh));
 
 	if (!res_get(dev, fh, res))
 		return -EBUSY;
 
-	return videobuf_streamon(saa7134_queue(fh));
+	return vb2_streamon(saa7134_queue(fh), V4L2_BUF_TYPE_VIDEO_CAPTURE);
 }
 
 static int saa7134_streamoff(struct file *file, void *priv,
@@ -2164,8 +2174,9 @@ static int saa7134_streamoff(struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 	int res = saa7134_resource(fh);
+	printk("%s: %p\n", __func__, saa7134_queue(fh));
 
-	err = videobuf_streamoff(saa7134_queue(fh));
+	err = vb2_streamoff(saa7134_queue(fh), V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (err < 0)
 		return err;
 	res_free(dev, fh, res);
@@ -2179,7 +2190,7 @@ static int saa7134_g_parm(struct file *file, void *fh,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int vidioc_g_register (struct file *file, void *priv,
+static int vidioc_g_register(struct file *file, void *priv,
 			      struct v4l2_dbg_register *reg)
 {
 	struct saa7134_fh *fh = priv;
@@ -2192,7 +2203,7 @@ static int vidioc_g_register (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_register (struct file *file, void *priv,
+static int vidioc_s_register(struct file *file, void *priv,
 				struct v4l2_dbg_register *reg)
 {
 	struct saa7134_fh *fh = priv;
@@ -2205,15 +2216,13 @@ static int vidioc_s_register (struct file *file, void *priv,
 }
 #endif
 
-static const struct v4l2_file_operations video_fops =
-{
+static const struct v4l2_file_operations video_fops = {
 	.owner	  = THIS_MODULE,
 	.open	  = video_open,
 	.release  = video_release,
-	.read	  = video_read,
 	.poll     = video_poll,
 	.mmap	  = video_mmap,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl  = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -2270,7 +2279,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 struct video_device saa7134_video_template = {
 	.name				= "saa7134-video",
 	.fops				= &video_fops,
-	.ioctl_ops 			= &video_ioctl_ops,
+	.ioctl_ops			= &video_ioctl_ops,
 	.tvnorms			= SAA7134_NORMS,
 	.current_norm			= V4L2_STD_PAL,
 };
@@ -2292,7 +2301,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
 	dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
 	dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
-	dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
+	dev->ctl_mute       = 1;
 	dev->ctl_invert     = ctrl_by_id(V4L2_CID_PRIVATE_INVERT)->default_value;
 	dev->ctl_automute   = ctrl_by_id(V4L2_CID_PRIVATE_AUTOMUTE)->default_value;
 
@@ -2351,21 +2360,24 @@ int saa7134_videoport_init(struct saa7134_dev *dev)
 int saa7134_video_init2(struct saa7134_dev *dev)
 {
 	/* init video hw */
-	set_tvnorm(dev,&tvnorms[0]);
-	video_mux(dev,0);
+	set_tvnorm(dev, &tvnorms[0]);
+	video_mux(dev, 0);
 
 	return 0;
 }
 
+/*
+ * Called from driver's init, resume and ISR
+ */
 void saa7134_irq_video_signalchange(struct saa7134_dev *dev)
 {
 	static const char *st[] = {
 		"(no signal)", "NTSC", "PAL", "SECAM" };
-	u32 st1,st2;
+	u32 st1, st2;
 
 	st1 = saa_readb(SAA7134_STATUS_VIDEO1);
 	st2 = saa_readb(SAA7134_STATUS_VIDEO2);
-	dprintk("DCSDT: pll: %s, sync: %s, norm: %s\n",
+	printk("DCSDT: pll: %s, sync: %s, norm: %s\n",
 		(st1 & 0x40) ? "not locked" : "locked",
 		(st2 & 0x40) ? "no"         : "yes",
 		st[st1 & 0x03]);
@@ -2398,7 +2410,7 @@ void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status)
 	spin_lock(&dev->slock);
 	if (dev->video_q.curr) {
 		dev->video_fieldcount++;
-		field = dev->video_q.curr->vb.field;
+		field = dev->video_q.curr->vb2.v4l2_buf.field;
 		if (V4L2_FIELD_HAS_BOTH(field)) {
 			/* make sure we have seen both fields */
 			if ((status & 0x10) == 0x00) {
@@ -2414,10 +2426,10 @@ void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status)
 			if ((status & 0x10) != 0x00)
 				goto done;
 		}
-		dev->video_q.curr->vb.field_count = dev->video_fieldcount;
-		saa7134_buffer_finish(dev,&dev->video_q,VIDEOBUF_DONE);
+		/* dev->video_q.curr->vb2.v4l2_buf.field_count = dev->video_fieldcount; */
+		saa7134_buffer_finish(dev, &dev->video_q, VIDEOBUF_DONE);
 	}
-	saa7134_buffer_next(dev,&dev->video_q);
+	saa7134_buffer_next(dev, &dev->video_q);
 
  done:
 	spin_unlock(&dev->slock);
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index bc521e8..37a09cd 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -40,6 +40,7 @@
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/videobuf-dma-sg.h>
+#include <media/videobuf2-dma-sg.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
@@ -436,7 +437,8 @@ struct saa7134_thread {
 /* buffer for one video/vbi/ts frame */
 struct saa7134_buf {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
+	/* struct videobuf_buffer vb; */
+	struct vb2_buffer vb2;
 
 	/* saa7134 specific */
 	struct saa7134_format   *fmt;
@@ -447,6 +449,8 @@ struct saa7134_buf {
 
 	/* page tables */
 	struct saa7134_pgtable  *pt;
+	struct list_head	entry;
+	unsigned int            width,height;
 };
 
 struct saa7134_dmaqueue {
@@ -473,7 +477,8 @@ struct saa7134_fh {
 	/* video capture */
 	struct saa7134_format      *fmt;
 	unsigned int               width,height;
-	struct videobuf_queue      cap;
+	/* struct videobuf_queue      cap; */
+	struct vb2_queue	   cap;
 	struct saa7134_pgtable     pt_cap;
 
 	/* vbi capture */
@@ -718,7 +723,9 @@ void saa7134_buffer_finish(struct saa7134_dev *dev, struct saa7134_dmaqueue *q,
 			   unsigned int state);
 void saa7134_buffer_next(struct saa7134_dev *dev, struct saa7134_dmaqueue *q);
 void saa7134_buffer_timeout(unsigned long data);
-void saa7134_dma_free(struct videobuf_queue *q,struct saa7134_buf *buf);
+void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q);
+
+void saa7134_dma_free(struct vb2_queue *q,struct saa7134_buf *buf);
 
 int saa7134_set_dmabits(struct saa7134_dev *dev);
 
-- 
1.7.2.3

