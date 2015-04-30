Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60156 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbbD3OI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 15/22] saa7134: better handle core debug messages
Date: Thu, 30 Apr 2015 11:08:35 -0300
Message-Id: <4d2cbc7c846bdd78b2b0afef4e0f6258f3325ff2.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On media drivers, debugging messages should be grouped into
categories, as this makes easier to debug the driver.

In the case of saa7134, the core has 2 debug categories, one
for IRQ, and another one for the core itself. The IRQ have
actually 2 levels of debug.

So, instead of using pr_dbg(), where everything would be in
the same box, let's define two macros that use pr_fmt(),
one for the core, and another one for irq.

With that, we can replace the remaining printk() occurrences
at the core to use either core_dbg() or irq_dbg(), depending
on the group of debug macros that need to be enabled.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 83dbb443214e..e88e4ec8c0ee 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -102,8 +102,11 @@ static unsigned int saa7134_devcount;
 int (*saa7134_dmasound_init)(struct saa7134_dev *dev);
 int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 
-#define dprintk(fmt, arg...)	if (core_debug) \
-	printk(KERN_DEBUG "%s/core: " fmt, dev->name , ## arg)
+#define core_dbg(fmt, arg...)    if (core_debug) \
+	printk(KERN_DEBUG pr_fmt("core: " fmt), ## arg)
+
+#define irq_dbg(level, fmt, arg...)    if (irq_debug > level) \
+	printk(KERN_DEBUG pr_fmt("irq: " fmt), ## arg)
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg)
 {
@@ -116,8 +119,7 @@ void saa7134_track_gpio(struct saa7134_dev *dev, char *msg)
 	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,SAA7134_GPIO_GPRESCAN);
 	mode   = saa_readl(SAA7134_GPIO_GPMODE0   >> 2) & 0xfffffff;
 	status = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & 0xfffffff;
-	printk(KERN_DEBUG
-	       "%s: gpio: mode=0x%07lx in=0x%07lx out=0x%07lx [%s]\n",
+	core_dbg("%s: gpio: mode=0x%07lx in=0x%07lx out=0x%07lx [%s]\n",
 	       dev->name, mode, (~mode) & status, mode & status, msg);
 }
 
@@ -128,7 +130,7 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 	index = 1 << bit_no;
 	switch (value) {
 	case 0: /* static value */
-	case 1:	dprintk("setting GPIO%d to static %d\n", bit_no, value);
+	case 1:	core_dbg("setting GPIO%d to static %d\n", bit_no, value);
 		/* turn sync mode off if necessary */
 		if (index & 0x00c00000)
 			saa_andorb(SAA7134_VIDEO_PORT_CTRL6, 0x0f, 0x00);
@@ -140,7 +142,7 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, index, bitval);
 		break;
 	case 3:	/* tristate */
-		dprintk("setting GPIO%d to tristate\n", bit_no);
+		core_dbg("setting GPIO%d to tristate\n", bit_no);
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, index, 0);
 		break;
 	}
@@ -274,7 +276,7 @@ int saa7134_buffer_queue(struct saa7134_dev *dev,
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->slock, flags);
-	dprintk("buffer_queue %p\n", buf);
+	core_dbg("buffer_queue %p\n", buf);
 	if (NULL == q->curr) {
 		if (!q->need_two) {
 			q->curr = buf;
@@ -298,7 +300,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 			   struct saa7134_dmaqueue *q,
 			   unsigned int state)
 {
-	dprintk("buffer_finish %p\n", q->curr);
+	core_dbg("buffer_finish %p\n", q->curr);
 
 	/* finish current buffer */
 	v4l2_get_timestamp(&q->curr->vb2.v4l2_buf.timestamp);
@@ -318,18 +320,18 @@ void saa7134_buffer_next(struct saa7134_dev *dev,
 	if (!list_empty(&q->queue)) {
 		/* activate next one from queue */
 		buf = list_entry(q->queue.next, struct saa7134_buf, entry);
-		dprintk("buffer_next %p [prev=%p/next=%p]\n",
+		core_dbg("buffer_next %p [prev=%p/next=%p]\n",
 			buf, q->queue.prev, q->queue.next);
 		list_del(&buf->entry);
 		if (!list_empty(&q->queue))
 			next = list_entry(q->queue.next, struct saa7134_buf, entry);
 		q->curr = buf;
 		buf->activate(dev, buf, next);
-		dprintk("buffer_next #2 prev=%p/next=%p\n",
+		core_dbg("buffer_next #2 prev=%p/next=%p\n",
 			q->queue.prev, q->queue.next);
 	} else {
 		/* nothing to do -- just stop DMA */
-		dprintk("buffer_next %p\n", NULL);
+		core_dbg("buffer_next %p\n", NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
 	}
@@ -351,7 +353,7 @@ void saa7134_buffer_timeout(unsigned long data)
 	/* flag current buffer as failed,
 	   try to start over with the next one. */
 	if (q->curr) {
-		dprintk("timeout on %p\n", q->curr);
+		core_dbg("timeout on %p\n", q->curr);
 		saa7134_buffer_finish(dev, q, VB2_BUF_STATE_ERROR);
 	}
 	saa7134_buffer_next(dev, q);
@@ -474,7 +476,7 @@ int saa7134_set_dmabits(struct saa7134_dev *dev)
 		   SAA7134_MAIN_CTRL_TE5 |
 		   SAA7134_MAIN_CTRL_TE6,
 		   ctrl);
-	dprintk("dmabits: task=0x%02x ctrl=0x%02x irq=0x%x split=%s\n",
+	core_dbg("dmabits: task=0x%02x ctrl=0x%02x irq=0x%x split=%s\n",
 		task, ctrl, irq, split ? "no" : "yes");
 
 	return 0;
@@ -496,21 +498,21 @@ static void print_irqstatus(struct saa7134_dev *dev, int loop,
 {
 	unsigned int i;
 
-	printk(KERN_DEBUG "%s/irq[%d,%ld]: r=0x%lx s=0x%02lx",
-	       dev->name,loop,jiffies,report,status);
+	irq_dbg(1, "[%d,%ld]: r=0x%lx s=0x%02lx",
+	       loop, jiffies, report,status);
 	for (i = 0; i < IRQBITS; i++) {
 		if (!(report & (1 << i)))
 			continue;
-		printk(" %s",irqbits[i]);
+		pr_cont(" %s",irqbits[i]);
 	}
 	if (report & SAA7134_IRQ_REPORT_DONE_RA0) {
-		printk(" | RA0=%s,%s,%s,%ld",
-		       (status & 0x40) ? "vbi"  : "video",
-		       (status & 0x20) ? "b"    : "a",
-		       (status & 0x10) ? "odd"  : "even",
-		       (status & 0x0f));
+		pr_cont(" | RA0=%s,%s,%s,%ld",
+			(status & 0x40) ? "vbi"  : "video",
+			(status & 0x20) ? "b"    : "a",
+			(status & 0x10) ? "odd"  : "even",
+			(status & 0x0f));
 	}
-	printk("\n");
+	pr_cont("\n");
 }
 
 static irqreturn_t saa7134_irq(int irq, void *dev_id)
@@ -532,16 +534,12 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA3) &&
 			(dev->dmasound.priv_data != NULL) )
 		{
-			if (irq_debug > 1)
-				printk(KERN_DEBUG "%s/irq: preserving DMA sound interrupt\n",
-				       dev->name);
+			irq_dbg(2, "preserving DMA sound interrupt\n");
 			report &= ~SAA7134_IRQ_REPORT_DONE_RA3;
 		}
 
 		if (0 == report) {
-			if (irq_debug > 1)
-				printk(KERN_DEBUG "%s/irq: no (more) work\n",
-				       dev->name);
+			irq_dbg(2,"no (more) work\n");
 			goto out;
 		}
 
@@ -680,7 +678,7 @@ static int saa7134_hw_enable1(struct saa7134_dev *dev)
 
 static int saa7134_hwinit1(struct saa7134_dev *dev)
 {
-	dprintk("hwinit1\n");
+	core_dbg("hwinit1\n");
 
 	saa_writel(SAA7134_IRQ1, 0);
 	saa_writel(SAA7134_IRQ2, 0);
@@ -742,7 +740,7 @@ static int saa7134_hw_enable2(struct saa7134_dev *dev)
 static int saa7134_hwinit2(struct saa7134_dev *dev)
 {
 
-	dprintk("hwinit2\n");
+	core_dbg("hwinit2\n");
 
 	saa7134_video_init2(dev);
 	saa7134_tvaudio_init2(dev);
@@ -756,7 +754,7 @@ static int saa7134_hwinit2(struct saa7134_dev *dev)
 /* shutdown */
 static int saa7134_hwfini(struct saa7134_dev *dev)
 {
-	dprintk("hwfini\n");
+	core_dbg("hwfini\n");
 
 	if (card_has_mpeg(dev))
 		saa7134_ts_fini(dev);
@@ -793,11 +791,11 @@ static void must_configure_manually(int has_eeprom)
 		for (p = 0; saa7134_pci_tbl[p].driver_data; p++) {
 			if (saa7134_pci_tbl[p].driver_data != i)
 				continue;
-			printk(" %04x:%04x",
+			pr_cont(" %04x:%04x",
 			       saa7134_pci_tbl[p].subvendor,
 			       saa7134_pci_tbl[p].subdevice);
 		}
-		printk("\n");
+		pr_cont("\n");
 	}
 }
 
@@ -1202,12 +1200,12 @@ static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 
 	buf  = q->curr;
 	next = buf;
-	dprintk("buffer_requeue\n");
+	core_dbg("buffer_requeue\n");
 
 	if (!buf)
 		return 0;
 
-	dprintk("buffer_requeue : resending active buffers \n");
+	core_dbg("buffer_requeue : resending active buffers \n");
 
 	if (!list_empty(&q->queue))
 		next = list_entry(q->queue.next, struct saa7134_buf,
-- 
2.1.0

