Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45743 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbeDIQsG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:06 -0400
Received: by mail-wr0-f196.google.com with SMTP id u11so10255915wri.12
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:05 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 10/19] [media] ddbridge: use spin_lock_irqsave() in output_work()
Date: Mon,  9 Apr 2018 18:47:43 +0200
Message-Id: <20180409164752.641-11-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Make sure to save IRQ states before taking the dma lock, as already done
in it's input_work() counterpart.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9d91221dacc4..c22537eceee5 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2132,18 +2132,18 @@ static void output_work(struct work_struct *work)
 	struct ddb_dma *dma = container_of(work, struct ddb_dma, work);
 	struct ddb_output *output = (struct ddb_output *)dma->io;
 	struct ddb *dev = output->port->dev;
+	unsigned long flags;
 
-	spin_lock(&dma->lock);
-	if (!dma->running) {
-		spin_unlock(&dma->lock);
-		return;
-	}
+	spin_lock_irqsave(&dma->lock, flags);
+	if (!dma->running)
+		goto unlock_exit;
 	dma->stat = ddbreadl(dev, DMA_BUFFER_CURRENT(dma));
 	dma->ctrl = ddbreadl(dev, DMA_BUFFER_CONTROL(dma));
 	if (output->redi)
 		output_ack_input(output, output->redi);
 	wake_up(&dma->wq);
-	spin_unlock(&dma->lock);
+unlock_exit:
+	spin_unlock_irqrestore(&dma->lock, flags);
 }
 
 static void output_handler(void *data)
-- 
2.16.1
