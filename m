Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40407 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753594AbdCOLbi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 07:31:38 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 03/14] [media] coda: simplify optional reset handling
Date: Wed, 15 Mar 2017 12:31:35 +0100
Message-Id: <20170315113135.14519-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As of commit bb475230b8e5 ("reset: make optional functions really
optional"), the reset framework API calls use NULL pointers to
describe optional, non-present reset controls.

This allows to return errors from devm_reset_control_get_optional
without special cases and to call reset_control_reset unconditionally.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index eb6548f46cbac..0cf667ab44bfb 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1982,8 +1982,7 @@ static int coda_hw_init(struct coda_dev *dev)
 	if (ret)
 		goto err_clk_ahb;
 
-	if (dev->rstc)
-		reset_control_reset(dev->rstc);
+	reset_control_reset(dev->rstc);
 
 	/*
 	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
@@ -2362,13 +2361,8 @@ static int coda_probe(struct platform_device *pdev)
 	dev->rstc = devm_reset_control_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(dev->rstc)) {
 		ret = PTR_ERR(dev->rstc);
-		if (ret == -ENOENT || ret == -ENOTSUPP) {
-			dev->rstc = NULL;
-		} else {
-			dev_err(&pdev->dev, "failed get reset control: %d\n",
-				ret);
-			return ret;
-		}
+		dev_err(&pdev->dev, "failed get reset control: %d\n", ret);
+		return ret;
 	}
 
 	/* Get IRAM pool from device tree or platform data */
-- 
2.11.0
