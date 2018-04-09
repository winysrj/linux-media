Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41281 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753384AbeDIQsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:08 -0400
Received: by mail-wr0-f194.google.com with SMTP id s12so10252855wrc.8
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:08 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 13/19] [media] ddbridge: make DMA buffer count and size modparam-configurable
Date: Mon,  9 Apr 2018 18:47:46 +0200
Message-Id: <20180409164752.641-14-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Make the number of DMA buffers and their size configurable using module
parameters. Being able to set these to a higher number might help on
busy systems when handling overall high data rates without having to
edit the driver sources and recompile things.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 30 ++++++++++++++++++++++++------
 drivers/media/pci/ddbridge/ddbridge.h      | 12 ------------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index e9c2e3e5d64b..8907551b02e4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -96,6 +96,15 @@ static int stv0910_single;
 module_param(stv0910_single, int, 0444);
 MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
 
+static int dma_buf_num = 8;
+module_param(dma_buf_num, int, 0444);
+MODULE_PARM_DESC(dma_buf_num, "Number of DMA buffers, possible values: 8-32");
+
+static int dma_buf_size = 21;
+module_param(dma_buf_size, int, 0444);
+MODULE_PARM_DESC(dma_buf_size,
+		 "DMA buffer size as multiple of 128*47, possible values: 1-43");
+
 /****************************************************************************/
 
 static DEFINE_MUTEX(redirect_lock);
@@ -2187,16 +2196,16 @@ static void ddb_dma_init(struct ddb_io *io, int nr, int out)
 		INIT_WORK(&dma->work, output_work);
 		dma->regs = rm->odma->base + rm->odma->size * nr;
 		dma->bufregs = rm->odma_buf->base + rm->odma_buf->size * nr;
-		dma->num = OUTPUT_DMA_BUFS;
-		dma->size = OUTPUT_DMA_SIZE;
-		dma->div = OUTPUT_DMA_IRQ_DIV;
+		dma->num = dma_buf_num;
+		dma->size = dma_buf_size * 128 * 47;
+		dma->div = 1;
 	} else {
 		INIT_WORK(&dma->work, input_work);
 		dma->regs = rm->idma->base + rm->idma->size * nr;
 		dma->bufregs = rm->idma_buf->base + rm->idma_buf->size * nr;
-		dma->num = INPUT_DMA_BUFS;
-		dma->size = INPUT_DMA_SIZE;
-		dma->div = INPUT_DMA_IRQ_DIV;
+		dma->num = dma_buf_num;
+		dma->size = dma_buf_size * 128 * 47;
+		dma->div = 1;
 	}
 	ddbwritel(io->port->dev, 0, DMA_BUFFER_ACK(dma));
 	dev_dbg(io->port->dev->dev, "init link %u, io %u, dma %u, dmaregs %08x bufregs %08x\n",
@@ -3353,6 +3362,15 @@ int ddb_exit_ddbridge(int stage, int error)
 
 int ddb_init_ddbridge(void)
 {
+	if (dma_buf_num < 8)
+		dma_buf_num = 8;
+	if (dma_buf_num > 32)
+		dma_buf_num = 32;
+	if (dma_buf_size < 1)
+		dma_buf_size = 1;
+	if (dma_buf_size > 43)
+		dma_buf_size = 43;
+
 	if (ddb_class_create() < 0)
 		return -1;
 	ddb_wq = alloc_workqueue("ddbridge", 0, 0);
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index de9ddf1068bf..86db6f19369a 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -136,20 +136,8 @@ struct ddb_info {
 	const struct ddb_regmap *regmap;
 };
 
-/* DMA_SIZE MUST be smaller than 256k and
- * MUST be divisible by 188 and 128 !!!
- */
-
 #define DMA_MAX_BUFS 32      /* hardware table limit */
 
-#define INPUT_DMA_BUFS 8
-#define INPUT_DMA_SIZE (128 * 47 * 21)
-#define INPUT_DMA_IRQ_DIV 1
-
-#define OUTPUT_DMA_BUFS 8
-#define OUTPUT_DMA_SIZE (128 * 47 * 21)
-#define OUTPUT_DMA_IRQ_DIV 1
-
 struct ddb;
 struct ddb_port;
 
-- 
2.16.1
