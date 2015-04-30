Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbD3OIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 10/22] saa7134-alsa: use pr_debug() instead of printk
Date: Thu, 30 Apr 2015 11:08:30 -0300
Message-Id: <e9d606a1bff5206c81f62aa42d3e2a43ba3782b8.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On saa7134-alsa, there is just one printk macro that use a
different debug level.

It should be easy to enable/disable this one using dynamic_printk,
if one need to individually control it.

So, this module can easily use pr_debug() instead of using its
own macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index f8764a4c2f15..4199fbf9bc44 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -32,10 +32,6 @@
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
 
-static unsigned int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"enable debug messages [alsa]");
-
 /*
  * Configuration macros
  */
@@ -57,11 +53,6 @@ module_param_array(enable, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for SAA7134 capture interface(s).");
 MODULE_PARM_DESC(enable, "Enable (or not) the SAA7134 capture interface(s).");
 
-#define dprintk(fmt, arg...)    if (debug) \
-	printk(KERN_DEBUG "%s/alsa: " fmt, dev->name , ##arg)
-
-
-
 /*
  * Main chip structure
  */
@@ -149,11 +140,11 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
 
 	spin_lock(&dev->slock);
 	if (UNSET == dev->dmasound.dma_blk) {
-		dprintk("irq: recording stopped\n");
+		pr_debug("irq: recording stopped\n");
 		goto done;
 	}
 	if (0 != (status & 0x0f000000))
-		dprintk("irq: lost %ld\n", (status >> 24) & 0x0f);
+		pr_debug("irq: lost %ld\n", (status >> 24) & 0x0f);
 	if (0 == (status & 0x10000000)) {
 		/* odd */
 		if (0 == (dev->dmasound.dma_blk & 0x01))
@@ -164,13 +155,13 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
 			reg = SAA7134_RS_BA2(6);
 	}
 	if (0 == reg) {
-		dprintk("irq: field oops [%s]\n",
+		pr_debug("irq: field oops [%s]\n",
 			(status & 0x10000000) ? "even" : "odd");
 		goto done;
 	}
 
 	if (dev->dmasound.read_count >= dev->dmasound.blksize * (dev->dmasound.blocks-2)) {
-		dprintk("irq: overrun [full=%d/%d] - Blocks in %d\n",dev->dmasound.read_count,
+		pr_debug("irq: overrun [full=%d/%d] - Blocks in %d\n",dev->dmasound.read_count,
 			dev->dmasound.bufsize, dev->dmasound.blocks);
 		spin_unlock(&dev->slock);
 		snd_pcm_stop_xrun(dev->dmasound.substream);
@@ -180,10 +171,9 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
 	/* next block addr */
 	next_blk = (dev->dmasound.dma_blk + 2) % dev->dmasound.blocks;
 	saa_writel(reg,next_blk * dev->dmasound.blksize);
-	if (debug > 2)
-		dprintk("irq: ok, %s, next_blk=%d, addr=%x, blocks=%u, size=%u, read=%u\n",
-			(status & 0x10000000) ? "even" : "odd ", next_blk,
-			next_blk * dev->dmasound.blksize, dev->dmasound.blocks, dev->dmasound.blksize, dev->dmasound.read_count);
+	pr_debug("irq: ok, %s, next_blk=%d, addr=%x, blocks=%u, size=%u, read=%u\n",
+		(status & 0x10000000) ? "even" : "odd ", next_blk,
+		next_blk * dev->dmasound.blksize, dev->dmasound.blocks, dev->dmasound.blksize, dev->dmasound.read_count);
 
 	/* update status & wake waiting readers */
 	dev->dmasound.dma_blk = (dev->dmasound.dma_blk + 1) % dev->dmasound.blocks;
@@ -233,7 +223,7 @@ static irqreturn_t saa7134_alsa_irq(int irq, void *dev_id)
 	}
 
 	if (loop == 10) {
-		dprintk("error! looping IRQ!");
+		pr_debug("error! looping IRQ!");
 	}
 
 out:
@@ -281,11 +271,11 @@ static int saa7134_alsa_dma_init(struct saa7134_dev *dev, int nr_pages)
 
 	dma->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
 	if (NULL == dma->vaddr) {
-		dprintk("vmalloc_32(%d pages) failed\n", nr_pages);
+		pr_debug("vmalloc_32(%d pages) failed\n", nr_pages);
 		return -ENOMEM;
 	}
 
-	dprintk("vmalloc is at addr 0x%08lx, size=%d\n",
+	pr_debug("vmalloc is at addr 0x%08lx, size=%d\n",
 				(unsigned long)dma->vaddr,
 				nr_pages << PAGE_SHIFT);
 
@@ -572,7 +562,7 @@ static int snd_card_saa7134_capture_prepare(struct snd_pcm_substream * substream
 		break;
 	}
 
-	dprintk("rec_start: afmt=%d ch=%d  =>  fmt=0x%x swap=%c\n",
+	pr_debug("rec_start: afmt=%d ch=%d  =>  fmt=0x%x swap=%c\n",
 		runtime->format, runtime->channels, fmt,
 		bswap ? 'b' : '-');
 	/* dma: setup channel 6 (= AUDIO) */
-- 
2.1.0

