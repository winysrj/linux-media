Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52262 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaHERBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:01:03 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 08/15] [media] coda: allow running coda without iram on mx6dl
Date: Tue,  5 Aug 2014 19:00:13 +0200
Message-Id: <1407258020-12078-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    |  3 +++
 drivers/media/platform/coda/coda-common.c | 14 +++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index cc9afb7..fddd10d 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -474,6 +474,9 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 	iram_info->next_paddr = dev->iram.paddr;
 	iram_info->remaining = dev->iram.size;
 
+	if (!dev->iram.vaddr)
+		return;
+
 	switch (dev->devtype->product) {
 	case CODA_7541:
 		dbk_bits = CODA7_USE_HOST_DBK_ENABLE | CODA7_USE_DBK_ENABLE;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 4e85e38..3bf30b8 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1947,15 +1947,15 @@ static int coda_probe(struct platform_device *pdev)
 	dev->iram.vaddr = gen_pool_dma_alloc(dev->iram_pool, dev->iram.size,
 					     &dev->iram.paddr);
 	if (!dev->iram.vaddr) {
-		dev_err(&pdev->dev, "unable to alloc iram\n");
-		return -ENOMEM;
+		dev_warn(&pdev->dev, "unable to alloc iram\n");
+	} else {
+		dev->iram.blob.data = dev->iram.vaddr;
+		dev->iram.blob.size = dev->iram.size;
+		dev->iram.dentry = debugfs_create_blob("iram", 0644,
+						       dev->debugfs_root,
+						       &dev->iram.blob);
 	}
 
-	dev->iram.blob.data = dev->iram.vaddr;
-	dev->iram.blob.size = dev->iram.size;
-	dev->iram.dentry = debugfs_create_blob("iram", 0644, dev->debugfs_root,
-					       &dev->iram.blob);
-
 	dev->workqueue = alloc_workqueue("coda", WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
 	if (!dev->workqueue) {
 		dev_err(&pdev->dev, "unable to alloc workqueue\n");
-- 
2.0.1

