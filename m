Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60658 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967722AbaLLN2j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:28:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/7] btcx-risc: move to bt8xx
Date: Fri, 12 Dec 2014 14:27:56 +0100
Message-Id: <1418390880-39009-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
References: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The btcx-risc module is no longer used by other drivers except for bttv.
So move it from common to bt8xx and make it part of the bttv driver instead
of as a separate module.

This module should never have been a common module since most of the code
has always been bttv specific.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/Kconfig                    |  4 ---
 drivers/media/common/Makefile                   |  1 -
 drivers/media/pci/bt8xx/Kconfig                 |  1 -
 drivers/media/pci/bt8xx/Makefile                |  2 +-
 drivers/media/{common => pci/bt8xx}/btcx-risc.c | 36 ++++++-------------------
 drivers/media/{common => pci/bt8xx}/btcx-risc.h |  8 ------
 6 files changed, 9 insertions(+), 43 deletions(-)
 rename drivers/media/{common => pci/bt8xx}/btcx-risc.c (90%)
 rename drivers/media/{common => pci/bt8xx}/btcx-risc.h (92%)

diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index b85f88c..21154dd 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -8,10 +8,6 @@ comment "common driver options"
 config VIDEO_CX2341X
 	tristate
 
-config VIDEO_BTCX
-	depends on PCI
-	tristate
-
 config VIDEO_TVEEPROM
 	tristate
 	depends on I2C
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index d208de3..89b795d 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1,5 +1,4 @@
 obj-y += b2c2/ saa7146/ siano/
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
-obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
diff --git a/drivers/media/pci/bt8xx/Kconfig b/drivers/media/pci/bt8xx/Kconfig
index 61d09e0..496cf6b 100644
--- a/drivers/media/pci/bt8xx/Kconfig
+++ b/drivers/media/pci/bt8xx/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_BT848
 	tristate "BT848 Video For Linux"
 	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L2
 	select I2C_ALGOBIT
-	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
 	depends on RC_CORE
 	select VIDEO_TUNER
diff --git a/drivers/media/pci/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
index f9fe7c4..2d4c3dd 100644
--- a/drivers/media/pci/bt8xx/Makefile
+++ b/drivers/media/pci/bt8xx/Makefile
@@ -1,6 +1,6 @@
 bttv-objs      :=      bttv-driver.o bttv-cards.o bttv-if.o \
 		       bttv-risc.o bttv-vbi.o bttv-i2c.o bttv-gpio.o \
-		       bttv-input.o bttv-audio-hook.o
+		       bttv-input.o bttv-audio-hook.o btcx-risc.o
 
 obj-$(CONFIG_VIDEO_BT848) += bttv.o
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
diff --git a/drivers/media/common/btcx-risc.c b/drivers/media/pci/bt8xx/btcx-risc.c
similarity index 90%
rename from drivers/media/common/btcx-risc.c
rename to drivers/media/pci/bt8xx/btcx-risc.c
index ac1b268..00f0880 100644
--- a/drivers/media/common/btcx-risc.c
+++ b/drivers/media/pci/bt8xx/btcx-risc.c
@@ -32,13 +32,9 @@
 
 #include "btcx-risc.h"
 
-MODULE_DESCRIPTION("some code shared by bttv and cx88xx drivers");
-MODULE_AUTHOR("Gerd Knorr");
-MODULE_LICENSE("GPL");
-
-static unsigned int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"debug messages, default is 0 (no)");
+static unsigned int btcx_debug;
+module_param(btcx_debug, int, 0644);
+MODULE_PARM_DESC(btcx_debug,"debug messages, default is 0 (no)");
 
 /* ---------------------------------------------------------- */
 /* allocate/free risc memory                                  */
@@ -50,7 +46,7 @@ void btcx_riscmem_free(struct pci_dev *pci,
 {
 	if (NULL == risc->cpu)
 		return;
-	if (debug) {
+	if (btcx_debug) {
 		memcnt--;
 		printk("btcx: riscmem free [%d] dma=%lx\n",
 		       memcnt, (unsigned long)risc->dma);
@@ -75,7 +71,7 @@ int btcx_riscmem_alloc(struct pci_dev *pci,
 		risc->cpu  = cpu;
 		risc->dma  = dma;
 		risc->size = size;
-		if (debug) {
+		if (btcx_debug) {
 			memcnt++;
 			printk("btcx: riscmem alloc [%d] dma=%lx cpu=%p size=%d\n",
 			       memcnt, (unsigned long)dma, cpu, size);
@@ -141,7 +137,7 @@ btcx_align(struct v4l2_rect *win, struct v4l2_clip *clips, unsigned int n, int m
 	dx = nx - win->left;
 	win->left  = nx;
 	win->width = nw;
-	if (debug)
+	if (btcx_debug)
 		printk(KERN_DEBUG "btcx: window align %dx%d+%d+%d [dx=%d]\n",
 		       win->width, win->height, win->left, win->top, dx);
 
@@ -153,7 +149,7 @@ btcx_align(struct v4l2_rect *win, struct v4l2_clip *clips, unsigned int n, int m
 			nw += mask+1;
 		clips[i].c.left  = nx;
 		clips[i].c.width = nw;
-		if (debug)
+		if (btcx_debug)
 			printk(KERN_DEBUG "btcx:   clip align %dx%d+%d+%d\n",
 			       clips[i].c.width, clips[i].c.height,
 			       clips[i].c.left, clips[i].c.top);
@@ -234,7 +230,7 @@ btcx_calc_skips(int line, int width, int *maxy,
 	*nskips = skip;
 	*maxy = maxline;
 
-	if (debug) {
+	if (btcx_debug) {
 		printk(KERN_DEBUG "btcx: skips line %d-%d:",line,maxline);
 		for (skip = 0; skip < *nskips; skip++) {
 			printk(" %d-%d",skips[skip].start,skips[skip].end);
@@ -242,19 +238,3 @@ btcx_calc_skips(int line, int width, int *maxy,
 		printk("\n");
 	}
 }
-
-/* ---------------------------------------------------------- */
-
-EXPORT_SYMBOL(btcx_riscmem_alloc);
-EXPORT_SYMBOL(btcx_riscmem_free);
-
-EXPORT_SYMBOL(btcx_screen_clips);
-EXPORT_SYMBOL(btcx_align);
-EXPORT_SYMBOL(btcx_sort_clips);
-EXPORT_SYMBOL(btcx_calc_skips);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/common/btcx-risc.h b/drivers/media/pci/bt8xx/btcx-risc.h
similarity index 92%
rename from drivers/media/common/btcx-risc.h
rename to drivers/media/pci/bt8xx/btcx-risc.h
index f8bc6e8..1ed7a00 100644
--- a/drivers/media/common/btcx-risc.h
+++ b/drivers/media/pci/bt8xx/btcx-risc.h
@@ -1,5 +1,3 @@
-/*
- */
 struct btcx_riscmem {
 	unsigned int   size;
 	__le32         *cpu;
@@ -26,9 +24,3 @@ void btcx_sort_clips(struct v4l2_clip *clips, unsigned int nclips);
 void btcx_calc_skips(int line, int width, int *maxy,
 		     struct btcx_skiplist *skips, unsigned int *nskips,
 		     const struct v4l2_clip *clips, unsigned int nclips);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
2.1.3

