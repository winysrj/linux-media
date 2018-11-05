Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46780 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbeKFGGb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 01:06:31 -0500
Received: by mail-qt1-f194.google.com with SMTP id c16-v6so195056qtj.13
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 12:45:02 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 2/3] media: imx-pxp: Check for pxp_soft_reset() error
Date: Mon,  5 Nov 2018 18:45:15 -0200
Message-Id: <1541450716-25523-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1541450716-25523-1-git-send-email-festevam@gmail.com>
References: <1541450716-25523-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pxp_soft_reset() may fail with a timeout, so it is better to propagate
the error in this case.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- None

 drivers/media/platform/imx-pxp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index 27780f1..b3700b8 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -1607,7 +1607,7 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= pxp_job_abort,
 };
 
-static void pxp_soft_reset(struct pxp_dev *dev)
+static int pxp_soft_reset(struct pxp_dev *dev)
 {
 	int ret;
 	u32 val;
@@ -1619,11 +1619,15 @@ static void pxp_soft_reset(struct pxp_dev *dev)
 
 	ret = readl_poll_timeout(dev->mmio + HW_PXP_CTRL, val,
 				 val & BM_PXP_CTRL_CLKGATE, 0, 100);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("PXP reset timeout\n");
+		return ret;
+	}
 
 	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);
 	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);
+
+	return 0;
 }
 
 static int pxp_probe(struct platform_device *pdev)
@@ -1670,7 +1674,9 @@ static int pxp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	pxp_soft_reset(dev);
+	ret = pxp_soft_reset(dev);
+	if (ret < 0)
+		return ret;
 
 	spin_lock_init(&dev->irqlock);
 
-- 
2.7.4
