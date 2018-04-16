Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44515 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbeDPRgF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 13:36:05 -0400
Received: by mail-wr0-f193.google.com with SMTP id u46so28291453wrc.11
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 10:36:04 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] ddbridge: don't uselessly check for dma in start/stop functions
Date: Mon, 16 Apr 2018 19:36:00 +0200
Message-Id: <20180416173600.23158-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The check for a valid ptr in ddb_io->dma isn't really necessary since only
devices that do data transport using DMA are supported by the driver, and
all previous initialisation code (through input_init(), output_init() and
dma_init(), has_dma is always true as it's set in ddb_probe() during
driver load) guarantees the ptr is set.

As a side effect, this silences these sparse warnings (albeit them being
false positives as ddb_io->dma won't change in these functions so the
condition always equals to the same result):

    drivers/media/pci/ddbridge/ddbridge-core.c:495:9: warning: context imbalance in 'ddb_output_start' - different lock contexts for basic block
    drivers/media/pci/ddbridge/ddbridge-core.c:510:9: warning: context imbalance in 'ddb_output_stop' - different lock contexts for basic block
    drivers/media/pci/ddbridge/ddbridge-core.c:525:9: warning: context imbalance in 'ddb_input_stop' - different lock contexts for basic block
    drivers/media/pci/ddbridge/ddbridge-core.c:560:9: warning: context imbalance in 'ddb_input_start' - different lock contexts for basic block

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
Superseds https://patchwork.linuxtv.org/patch/48593/

 drivers/media/pci/ddbridge/ddbridge-core.c | 85 ++++++++++++------------------
 1 file changed, 35 insertions(+), 50 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 90687eff5909..c90f2933df8d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -410,13 +410,11 @@ static void ddb_output_start(struct ddb_output *output)
 	struct ddb *dev = output->port->dev;
 	u32 con = 0x11c, con2 = 0;
 
-	if (output->dma) {
-		spin_lock_irq(&output->dma->lock);
-		output->dma->cbuf = 0;
-		output->dma->coff = 0;
-		output->dma->stat = 0;
-		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma));
-	}
+	spin_lock_irq(&output->dma->lock);
+	output->dma->cbuf = 0;
+	output->dma->coff = 0;
+	output->dma->stat = 0;
+	ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma));
 
 	if (output->port->input[0]->port->class == DDB_PORT_LOOP)
 		con = (1UL << 13) | 0x14;
@@ -429,36 +427,29 @@ static void ddb_output_start(struct ddb_output *output)
 	ddbwritel(dev, con, TS_CONTROL(output));
 	ddbwritel(dev, con2, TS_CONTROL2(output));
 
-	if (output->dma) {
-		ddbwritel(dev, output->dma->bufval,
-			  DMA_BUFFER_SIZE(output->dma));
-		ddbwritel(dev, 0, DMA_BUFFER_ACK(output->dma));
-		ddbwritel(dev, 1, DMA_BASE_READ);
-		ddbwritel(dev, 7, DMA_BUFFER_CONTROL(output->dma));
-	}
+	ddbwritel(dev, output->dma->bufval,
+		  DMA_BUFFER_SIZE(output->dma));
+	ddbwritel(dev, 0, DMA_BUFFER_ACK(output->dma));
+	ddbwritel(dev, 1, DMA_BASE_READ);
+	ddbwritel(dev, 7, DMA_BUFFER_CONTROL(output->dma));
 
 	ddbwritel(dev, con | 1, TS_CONTROL(output));
 
-	if (output->dma) {
-		output->dma->running = 1;
-		spin_unlock_irq(&output->dma->lock);
-	}
+	output->dma->running = 1;
+	spin_unlock_irq(&output->dma->lock);
 }
 
 static void ddb_output_stop(struct ddb_output *output)
 {
 	struct ddb *dev = output->port->dev;
 
-	if (output->dma)
-		spin_lock_irq(&output->dma->lock);
+	spin_lock_irq(&output->dma->lock);
 
 	ddbwritel(dev, 0, TS_CONTROL(output));
 
-	if (output->dma) {
-		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma));
-		output->dma->running = 0;
-		spin_unlock_irq(&output->dma->lock);
-	}
+	ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma));
+	output->dma->running = 0;
+	spin_unlock_irq(&output->dma->lock);
 }
 
 static void ddb_input_stop(struct ddb_input *input)
@@ -466,45 +457,39 @@ static void ddb_input_stop(struct ddb_input *input)
 	struct ddb *dev = input->port->dev;
 	u32 tag = DDB_LINK_TAG(input->port->lnr);
 
-	if (input->dma)
-		spin_lock_irq(&input->dma->lock);
+	spin_lock_irq(&input->dma->lock);
+
 	ddbwritel(dev, 0, tag | TS_CONTROL(input));
-	if (input->dma) {
-		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma));
-		input->dma->running = 0;
-		spin_unlock_irq(&input->dma->lock);
-	}
+
+	ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma));
+	input->dma->running = 0;
+	spin_unlock_irq(&input->dma->lock);
 }
 
 static void ddb_input_start(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
 
-	if (input->dma) {
-		spin_lock_irq(&input->dma->lock);
-		input->dma->cbuf = 0;
-		input->dma->coff = 0;
-		input->dma->stat = 0;
-		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma));
-	}
+	spin_lock_irq(&input->dma->lock);
+	input->dma->cbuf = 0;
+	input->dma->coff = 0;
+	input->dma->stat = 0;
+	ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma));
+
 	ddbwritel(dev, 0, TS_CONTROL(input));
 	ddbwritel(dev, 2, TS_CONTROL(input));
 	ddbwritel(dev, 0, TS_CONTROL(input));
 
-	if (input->dma) {
-		ddbwritel(dev, input->dma->bufval,
-			  DMA_BUFFER_SIZE(input->dma));
-		ddbwritel(dev, 0, DMA_BUFFER_ACK(input->dma));
-		ddbwritel(dev, 1, DMA_BASE_WRITE);
-		ddbwritel(dev, 3, DMA_BUFFER_CONTROL(input->dma));
-	}
+	ddbwritel(dev, input->dma->bufval,
+		  DMA_BUFFER_SIZE(input->dma));
+	ddbwritel(dev, 0, DMA_BUFFER_ACK(input->dma));
+	ddbwritel(dev, 1, DMA_BASE_WRITE);
+	ddbwritel(dev, 3, DMA_BUFFER_CONTROL(input->dma));
 
 	ddbwritel(dev, 0x09, TS_CONTROL(input));
 
-	if (input->dma) {
-		input->dma->running = 1;
-		spin_unlock_irq(&input->dma->lock);
-	}
+	input->dma->running = 1;
+	spin_unlock_irq(&input->dma->lock);
 }
 
 static void ddb_input_start_all(struct ddb_input *input)
-- 
2.16.1
