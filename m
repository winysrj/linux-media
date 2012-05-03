Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43538 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758940Ab2ECWWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 18:22:40 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so3032872pbb.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 15:22:40 -0700 (PDT)
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 6/6] video/omap24xxcam: use __iomem annotations
Date: Thu,  3 May 2012 16:22:27 -0600
Message-Id: <1336083747-3142-7-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

MMIO registers are __iomem tokens in virtual address space,
not integers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/video/omap24xxcam-dma.c |   20 ++++++++++----------
 drivers/media/video/omap24xxcam.c     |    3 +--
 drivers/media/video/omap24xxcam.h     |   14 +++++++-------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/omap24xxcam-dma.c b/drivers/media/video/omap24xxcam-dma.c
index 3ea38a8..b5ae170 100644
--- a/drivers/media/video/omap24xxcam-dma.c
+++ b/drivers/media/video/omap24xxcam-dma.c
@@ -38,7 +38,7 @@
  */
 
 /* Ack all interrupt on CSR and IRQSTATUS_L0 */
-static void omap24xxcam_dmahw_ack_all(unsigned long base)
+static void omap24xxcam_dmahw_ack_all(void __iomem *base)
 {
 	u32 csr;
 	int i;
@@ -52,7 +52,7 @@ static void omap24xxcam_dmahw_ack_all(unsigned long base)
 }
 
 /* Ack dmach on CSR and IRQSTATUS_L0 */
-static u32 omap24xxcam_dmahw_ack_ch(unsigned long base, int dmach)
+static u32 omap24xxcam_dmahw_ack_ch(void __iomem *base, int dmach)
 {
 	u32 csr;
 
@@ -65,12 +65,12 @@ static u32 omap24xxcam_dmahw_ack_ch(unsigned long base, int dmach)
 	return csr;
 }
 
-static int omap24xxcam_dmahw_running(unsigned long base, int dmach)
+static int omap24xxcam_dmahw_running(void __iomem *base, int dmach)
 {
 	return omap24xxcam_reg_in(base, CAMDMA_CCR(dmach)) & CAMDMA_CCR_ENABLE;
 }
 
-static void omap24xxcam_dmahw_transfer_setup(unsigned long base, int dmach,
+static void omap24xxcam_dmahw_transfer_setup(void __iomem *base, int dmach,
 					     dma_addr_t start, u32 len)
 {
 	omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
@@ -112,7 +112,7 @@ static void omap24xxcam_dmahw_transfer_setup(unsigned long base, int dmach,
 			    | CAMDMA_CICR_DROP_IE);
 }
 
-static void omap24xxcam_dmahw_transfer_start(unsigned long base, int dmach)
+static void omap24xxcam_dmahw_transfer_start(void __iomem *base, int dmach)
 {
 	omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
 			    CAMDMA_CCR_SEL_SRC_DST_SYNC
@@ -124,7 +124,7 @@ static void omap24xxcam_dmahw_transfer_start(unsigned long base, int dmach)
 			    | CAMDMA_CCR_SYNCHRO_CAMERA);
 }
 
-static void omap24xxcam_dmahw_transfer_chain(unsigned long base, int dmach,
+static void omap24xxcam_dmahw_transfer_chain(void __iomem *base, int dmach,
 					     int free_dmach)
 {
 	int prev_dmach, ch;
@@ -160,7 +160,7 @@ static void omap24xxcam_dmahw_transfer_chain(unsigned long base, int dmach,
  * controller may not be idle after this routine completes, because
  * the completion routines might start new transfers.
  */
-static void omap24xxcam_dmahw_abort_ch(unsigned long base, int dmach)
+static void omap24xxcam_dmahw_abort_ch(void __iomem *base, int dmach)
 {
 	/* mask all interrupts from this channel */
 	omap24xxcam_reg_out(base, CAMDMA_CICR(dmach), 0);
@@ -171,7 +171,7 @@ static void omap24xxcam_dmahw_abort_ch(unsigned long base, int dmach)
 	omap24xxcam_reg_merge(base, CAMDMA_CCR(dmach), 0, CAMDMA_CCR_ENABLE);
 }
 
-static void omap24xxcam_dmahw_init(unsigned long base)
+static void omap24xxcam_dmahw_init(void __iomem *base)
 {
 	omap24xxcam_reg_out(base, CAMDMA_OCP_SYSCONFIG,
 			    CAMDMA_OCP_SYSCONFIG_MIDLEMODE_FSTANDBY
@@ -362,7 +362,7 @@ void omap24xxcam_dma_hwinit(struct omap24xxcam_dma *dma)
 }
 
 static void omap24xxcam_dma_init(struct omap24xxcam_dma *dma,
-				 unsigned long base)
+				 void __iomem *base)
 {
 	int ch;
 
@@ -577,7 +577,7 @@ void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma)
 }
 
 void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
-			    unsigned long base,
+			    void __iomem *base,
 			    void (*reset_callback)(unsigned long data),
 			    unsigned long reset_callback_data)
 {
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 7d38641..e5015b0 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1776,8 +1776,7 @@ static int __devinit omap24xxcam_probe(struct platform_device *pdev)
 	cam->mmio_size = resource_size(mem);
 
 	/* map the region */
-	cam->mmio_base = (unsigned long)
-		ioremap_nocache(cam->mmio_base_phys, cam->mmio_size);
+	cam->mmio_base = ioremap_nocache(cam->mmio_base_phys, cam->mmio_size);
 	if (!cam->mmio_base) {
 		dev_err(cam->dev, "cannot map camera register I/O region\n");
 		goto err;
diff --git a/drivers/media/video/omap24xxcam.h b/drivers/media/video/omap24xxcam.h
index 2ce67f5..d59727a 100644
--- a/drivers/media/video/omap24xxcam.h
+++ b/drivers/media/video/omap24xxcam.h
@@ -429,7 +429,7 @@ struct sgdma_state {
 struct omap24xxcam_dma {
 	spinlock_t lock;	/* Lock for the whole structure. */
 
-	unsigned long base;	/* base address for dma controller */
+	void __iomem *base;	/* base address for dma controller */
 
 	/* While dma_stop!=0, an attempt to start a new DMA transfer will
 	 * fail.
@@ -491,7 +491,7 @@ struct omap24xxcam_device {
 
 	/*** hardware resources ***/
 	unsigned int irq;
-	unsigned long mmio_base;
+	void __iomem *mmio_base;
 	unsigned long mmio_base_phys;
 	unsigned long mmio_size;
 
@@ -544,22 +544,22 @@ struct omap24xxcam_fh {
  *
  */
 
-static inline u32 omap24xxcam_reg_in(unsigned long base, u32 offset)
+static inline u32 omap24xxcam_reg_in(u32 __iomem *base, u32 offset)
 {
 	return readl(base + offset);
 }
 
-static inline u32 omap24xxcam_reg_out(unsigned long base, u32 offset,
+static inline u32 omap24xxcam_reg_out(u32 __iomem *base, u32 offset,
 					  u32 val)
 {
 	writel(val, base + offset);
 	return val;
 }
 
-static inline u32 omap24xxcam_reg_merge(unsigned long base, u32 offset,
+static inline u32 omap24xxcam_reg_merge(u32 __iomem *base, u32 offset,
 					    u32 val, u32 mask)
 {
-	u32 addr = base + offset;
+	u32 __iomem *addr = base + offset;
 	u32 new_val = (readl(addr) & ~mask) | (val & mask);
 
 	writel(new_val, addr);
@@ -585,7 +585,7 @@ int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
 			    int len, sgdma_callback_t callback, void *arg);
 void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma);
 void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
-			    unsigned long base,
+			    void __iomem *base,
 			    void (*reset_callback)(unsigned long data),
 			    unsigned long reset_callback_data);
 void omap24xxcam_sgdma_exit(struct omap24xxcam_sgdma *sgdma);
-- 
1.7.5.4

