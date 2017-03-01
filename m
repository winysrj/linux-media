Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58671 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751853AbdCAPhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Mar 2017 10:37:14 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] [media] coda: restore original firmware locations
Date: Wed,  1 Mar 2017 16:36:25 +0100
Message-Id: <20170301153625.16249-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recently, an unfinished patch was merged that added a third entry to the
beginning of the array of firmware locations without changing the code
to also look at the third element, thus pushing an old firmware location
off the list.

Fixes: 8af7779f3cbc ("[media] coda: add Freescale firmware compatibility location")
Cc: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index eb6548f46cbac..e1a2e8c70db01 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2128,6 +2128,9 @@ static int coda_firmware_request(struct coda_dev *dev)
 {
 	char *fw = dev->devtype->firmware[dev->firmware];
 
+	if (dev->firmware >= ARRAY_SIZE(dev->devtype->firmware))
+		return -EINVAL;
+
 	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
 		coda_product_name(dev->devtype->product));
 
@@ -2142,16 +2145,16 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	struct platform_device *pdev = dev->plat_dev;
 	int i, ret;
 
-	if (!fw && dev->firmware == 1) {
-		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
-		goto put_pm;
-	}
 	if (!fw) {
-		dev->firmware = 1;
-		coda_firmware_request(dev);
+		dev->firmware++;
+		ret = coda_firmware_request(dev);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
+			goto put_pm;
+		}
 		return;
 	}
-	if (dev->firmware == 1) {
+	if (dev->firmware > 0) {
 		/*
 		 * Since we can't suppress warnings for failed asynchronous
 		 * firmware requests, report that the fallback firmware was
-- 
2.11.0
