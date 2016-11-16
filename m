Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49622 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/35] [media] bt8xx: use pr_foo() macros instead of printk()
Date: Wed, 16 Nov 2016 14:42:36 -0200
Message-Id: <1a0774cd15de89ddd5f15dc0eb92dbdd82c3fb20.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk() macros by their pr_foo() counterparts, using
pr_cont() for continuation lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/btcx-risc.c | 46 +++++++++++++++++++++----------------
 drivers/media/pci/bt8xx/dvb-bt8xx.c | 25 +++++++++++---------
 2 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/media/pci/bt8xx/btcx-risc.c b/drivers/media/pci/bt8xx/btcx-risc.c
index 57c7f58c3af2..70bdf93fc020 100644
--- a/drivers/media/pci/bt8xx/btcx-risc.c
+++ b/drivers/media/pci/bt8xx/btcx-risc.c
@@ -22,6 +22,8 @@
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
@@ -36,6 +38,13 @@ static unsigned int btcx_debug;
 module_param(btcx_debug, int, 0644);
 MODULE_PARM_DESC(btcx_debug,"debug messages, default is 0 (no)");
 
+#define dprintk(fmt, arg...) do {				\
+	if (btcx_debug)						\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),		\
+		       __func__, ##arg);			\
+} while (0)
+
+
 /* ---------------------------------------------------------- */
 /* allocate/free risc memory                                  */
 
@@ -46,11 +55,11 @@ void btcx_riscmem_free(struct pci_dev *pci,
 {
 	if (NULL == risc->cpu)
 		return;
-	if (btcx_debug) {
-		memcnt--;
-		printk("btcx: riscmem free [%d] dma=%lx\n",
-		       memcnt, (unsigned long)risc->dma);
-	}
+
+	memcnt--;
+	dprintk("btcx: riscmem free [%d] dma=%lx\n",
+		memcnt, (unsigned long)risc->dma);
+
 	pci_free_consistent(pci, risc->size, risc->cpu, risc->dma);
 	memset(risc,0,sizeof(*risc));
 }
@@ -71,11 +80,10 @@ int btcx_riscmem_alloc(struct pci_dev *pci,
 		risc->cpu  = cpu;
 		risc->dma  = dma;
 		risc->size = size;
-		if (btcx_debug) {
-			memcnt++;
-			printk("btcx: riscmem alloc [%d] dma=%lx cpu=%p size=%d\n",
-			       memcnt, (unsigned long)dma, cpu, size);
-		}
+
+		memcnt++;
+		dprintk("btcx: riscmem alloc [%d] dma=%lx cpu=%p size=%d\n",
+			memcnt, (unsigned long)dma, cpu, size);
 	}
 	memset(risc->cpu,0,risc->size);
 	return 0;
@@ -137,9 +145,8 @@ btcx_align(struct v4l2_rect *win, struct v4l2_clip *clips, unsigned int n, int m
 	dx = nx - win->left;
 	win->left  = nx;
 	win->width = nw;
-	if (btcx_debug)
-		printk(KERN_DEBUG "btcx: window align %dx%d+%d+%d [dx=%d]\n",
-		       win->width, win->height, win->left, win->top, dx);
+	dprintk("btcx: window align %dx%d+%d+%d [dx=%d]\n",
+	       win->width, win->height, win->left, win->top, dx);
 
 	/* fixup clips */
 	for (i = 0; i < n; i++) {
@@ -149,10 +156,9 @@ btcx_align(struct v4l2_rect *win, struct v4l2_clip *clips, unsigned int n, int m
 			nw += mask+1;
 		clips[i].c.left  = nx;
 		clips[i].c.width = nw;
-		if (btcx_debug)
-			printk(KERN_DEBUG "btcx:   clip align %dx%d+%d+%d\n",
-			       clips[i].c.width, clips[i].c.height,
-			       clips[i].c.left, clips[i].c.top);
+		dprintk("btcx:   clip align %dx%d+%d+%d\n",
+		       clips[i].c.width, clips[i].c.height,
+		       clips[i].c.left, clips[i].c.top);
 	}
 	return 0;
 }
@@ -228,10 +234,10 @@ btcx_calc_skips(int line, int width, int *maxy,
 	*maxy = maxline;
 
 	if (btcx_debug) {
-		printk(KERN_DEBUG "btcx: skips line %d-%d:",line,maxline);
+		dprintk("btcx: skips line %d-%d:", line, maxline);
 		for (skip = 0; skip < *nskips; skip++) {
-			printk(" %d-%d",skips[skip].start,skips[skip].end);
+			pr_cont(" %d-%d", skips[skip].start, skips[skip].end);
 		}
-		printk("\n");
+		pr_cont("\n");
 	}
 }
diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index e69d338ab9be..6100fa71ece8 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -19,7 +19,7 @@
  *
  */
 
-#define pr_fmt(fmt) "dvb_bt8xx: " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bitops.h>
 #include <linux/module.h>
@@ -44,10 +44,12 @@ MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define dprintk( args... ) \
-	do { \
-		if (debug) printk(KERN_DEBUG args); \
-	} while (0)
+#define dprintk(fmt, arg...) do {				\
+	if (debug)						\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),		\
+		       __func__, ##arg);			\
+} while (0)
+
 
 #define IF_FREQUENCYx6 217    /* 6 * 36.16666666667MHz */
 
@@ -55,7 +57,7 @@ static void dvb_bt8xx_task(unsigned long data)
 {
 	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *)data;
 
-	//printk("%d ", card->bt->finished_block);
+	dprintk("%d\n", card->bt->finished_block);
 
 	while (card->bt->last_block != card->bt->finished_block) {
 		(card->bt->TS_Size ? dvb_dmx_swfilter_204 : dvb_dmx_swfilter)
@@ -443,7 +445,7 @@ static void or51211_reset(struct dvb_frontend * fe)
 	/* reset & PRM1,2&4 are outputs */
 	int ret = bttv_gpio_enable(bt->bttv_nr, 0x001F, 0x001F);
 	if (ret != 0)
-		printk(KERN_WARNING "or51211: Init Error - Can't Reset DVR (%i)\n", ret);
+		pr_warn("or51211: Init Error - Can't Reset DVR (%i)\n", ret);
 	bttv_write_gpio(bt->bttv_nr, 0x001F, 0x0000);   /* Reset */
 	msleep(20);
 	/* Now set for normal operation */
@@ -560,7 +562,8 @@ static void digitv_alps_tded4_reset(struct dvb_bt8xx_card *bt)
 
 	int ret = bttv_gpio_enable(bt->bttv_nr, 0x08, 0x08);
 	if (ret != 0)
-		printk(KERN_WARNING "digitv_alps_tded4: Init Error - Can't Reset DVR (%i)\n", ret);
+		pr_warn("digitv_alps_tded4: Init Error - Can't Reset DVR (%i)\n",
+			ret);
 
 	/* Pulse the reset line */
 	bttv_write_gpio(bt->bttv_nr, 0x08, 0x08); /* High */
@@ -620,7 +623,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 			dvb_attach(simple_tuner_attach, card->fe,
 				   card->i2c_adapter, 0x61,
 				   TUNER_LG_TDVS_H06XF);
-			dprintk ("dvb_bt8xx: lgdt330x detected\n");
+			dprintk("dvb_bt8xx: lgdt330x detected\n");
 		}
 		break;
 
@@ -635,7 +638,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 		card->fe = dvb_attach(nxt6000_attach, &vp3021_alps_tded4_config, card->i2c_adapter);
 		if (card->fe != NULL) {
 			card->fe->ops.tuner_ops.set_params = vp3021_alps_tded4_tuner_set_params;
-			dprintk ("dvb_bt8xx: an nxt6000 was detected on your digitv card\n");
+			dprintk("dvb_bt8xx: an nxt6000 was detected on your digitv card\n");
 			break;
 		}
 
@@ -645,7 +648,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 
 		if (card->fe != NULL) {
 			card->fe->ops.tuner_ops.calc_regs = digitv_alps_tded4_tuner_calc_regs;
-			dprintk ("dvb_bt8xx: an mt352 was detected on your digitv card\n");
+			dprintk("dvb_bt8xx: an mt352 was detected on your digitv card\n");
 		}
 		break;
 
-- 
2.7.4


