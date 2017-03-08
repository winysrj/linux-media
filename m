Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:54885 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752796AbdCHMa6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 07:30:58 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] [media] coda: restore original firmware locations
Date: Wed,  8 Mar 2017 13:30:50 +0100
Message-Id: <20170308123050.17537-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recently, an unfinished patch was merged that added a third entry to the
beginning of the array of firmware locations without changing the code
to also look at the third element, thus pushing an old firmware location
off the list.

Fixes: 8af7779f3cbc ("[media] coda: add Freescale firmware compatibility location")
Cc: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Changes since v1:
 - moved fw assignment after ARRAY_SIZE check, to avoid reading into fw
   from undefined memory
---
 drivers/media/platform/coda/coda-common.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index eb6548f46cbac..5024b460fb66a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2126,7 +2126,12 @@ static void coda_fw_callback(const struct firmware *fw, void *context);
 
 static int coda_firmware_request(struct coda_dev *dev)
 {
-	char *fw = dev->devtype->firmware[dev->firmware];
+	char *fw;
+
+	if (dev->firmware >= ARRAY_SIZE(dev->devtype->firmware))
+		return -EINVAL;
+
+	fw = dev->devtype->firmware[dev->firmware];
 
 	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
 		coda_product_name(dev->devtype->product));
@@ -2142,16 +2147,16 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
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
