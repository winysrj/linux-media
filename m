Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34248 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387480AbeKFTkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:40:21 -0500
Received: by mail-qt1-f196.google.com with SMTP id r14so1921393qtp.1
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 02:15:51 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 3/3] media: imx-pxp: Improve pxp_soft_reset() error message
Date: Tue,  6 Nov 2018 08:16:05 -0200
Message-Id: <1541499365-10069-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1541499365-10069-1-git-send-email-festevam@gmail.com>
References: <1541499365-10069-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the pxp_soft_reset() error message by moving it to the
caller function, associating it with a proper device and also
by displaying the error code.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
- None (only rebased against the change made in 2/3)

 drivers/media/platform/imx-pxp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index 986764d..b80d206 100644
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
 		goto err_clk;
+	}
 
 	spin_lock_init(&dev->irqlock);
 
-- 
2.7.4
