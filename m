Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60810 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 09/21] [media] coda: initialize SRAM on probe
Date: Fri, 23 Jan 2015 17:51:23 +0100
Message-Id: <1422031895-7740-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zeroing the SRAM on probe helps with debugging SRAM contents.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 7a6cb08..5386b2c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2174,6 +2174,7 @@ static int coda_probe(struct platform_device *pdev)
 	if (!dev->iram.vaddr) {
 		dev_warn(&pdev->dev, "unable to alloc iram\n");
 	} else {
+		memset(dev->iram.vaddr, 0, dev->iram.size);
 		dev->iram.blob.data = dev->iram.vaddr;
 		dev->iram.blob.size = dev->iram.size;
 		dev->iram.dentry = debugfs_create_blob("iram", 0644,
-- 
2.1.4

