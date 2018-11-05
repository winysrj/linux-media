Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42802 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbeKFGGe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 01:06:34 -0500
Received: by mail-qt1-f193.google.com with SMTP id z20-v6so193170qti.9
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 12:45:04 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 3/3] media: imx-pxp: Improve pxp_soft_reset() error message
Date: Mon,  5 Nov 2018 18:45:16 -0200
Message-Id: <1541450716-25523-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1541450716-25523-1-git-send-email-festevam@gmail.com>
References: <1541450716-25523-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the pxp_soft_reset() error message by moving it to the
caller function, associating it with a proper device and also
by displaying the error code.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Newly introduced in this version

 drivers/media/platform/imx-pxp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index b3700b8..1b765c9 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -1619,10 +1619,8 @@ static int pxp_soft_reset(struct pxp_dev *dev)
 
 	ret = readl_poll_timeout(dev->mmio + HW_PXP_CTRL, val,
 				 val & BM_PXP_CTRL_CLKGATE, 0, 100);
-	if (ret < 0) {
-		pr_err("PXP reset timeout\n");
+	if (ret < 0)
 		return ret;
-	}
 
 	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);
 	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);
@@ -1675,8 +1673,10 @@ static int pxp_probe(struct platform_device *pdev)
 		return ret;
 
 	ret = pxp_soft_reset(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(&pdev->dev, "PXP reset timeout: %d\n", ret);
 		return ret;
+	}
 
 	spin_lock_init(&dev->irqlock);
 
-- 
2.7.4
