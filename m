Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33187 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387480AbeKFTkT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:40:19 -0500
Received: by mail-qt1-f194.google.com with SMTP id l11so1922398qtp.0
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 02:15:49 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 2/3] media: imx-pxp: Check for pxp_soft_reset() error
Date: Tue,  6 Nov 2018 08:16:04 -0200
Message-Id: <1541499365-10069-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1541499365-10069-1-git-send-email-festevam@gmail.com>
References: <1541499365-10069-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pxp_soft_reset() may fail with a timeout, so it is better to propagate
the error in this case.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
- Jump to err_clck when pxp_soft_reset() fails. (Philipp)

 drivers/media/platform/imx-pxp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index 27780f1..986764d 100644
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
+		goto err_clk;
 
 	spin_lock_init(&dev->irqlock);
 
-- 
2.7.4
