Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:54209 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932696AbdGSP2k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 11:28:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Subject: [PATCH 034/102] coda: explicitly request exclusive reset control
Date: Wed, 19 Jul 2017 17:25:38 +0200
Message-Id: <20170719152646.25903-35-p.zabel@pengutronix.de>
In-Reply-To: <20170719152646.25903-1-p.zabel@pengutronix.de>
References: <20170719152646.25903-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit a53e35db70d1 ("reset: Ensure drivers are explicit when requesting
reset lines") started to transition the reset control request API calls
to explicitly state whether the driver needs exclusive or shared reset
control behavior. Convert all drivers requesting exclusive resets to the
explicit API call so the temporary transition helpers can be removed.

No functional changes.

Cc: linux-media@vger.kernel.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f92cc7df58fb8..8e0b1a4e2546b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2470,7 +2470,8 @@ static int coda_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	dev->rstc = devm_reset_control_get_optional(&pdev->dev, NULL);
+	dev->rstc = devm_reset_control_get_optional_exclusive(&pdev->dev,
+							      NULL);
 	if (IS_ERR(dev->rstc)) {
 		ret = PTR_ERR(dev->rstc);
 		dev_err(&pdev->dev, "failed get reset control: %d\n", ret);
-- 
2.11.0
