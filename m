Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36317 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdG0RCM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 13:02:12 -0400
From: Diwakar Sharma <sharmalxmail@gmail.com>
Cc: sharmalxmail@gmail.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        simran singhal <singhalsimran0@gmail.com>,
        Derek Robson <robsonde@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: davinci_vpfe: use __func__ for function names
Date: Thu, 27 Jul 2017 22:31:23 +0530
Message-Id: <1501174889-29572-1-git-send-email-sharmalxmail@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checkpatch reported warnings for use of embedded function names.
Use __func__ instead of embedded function names.

Signed-off-by: Diwakar Sharma <sharmalxmail@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c     | 10 +++++-----
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 6a3434c..a59ab6f 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -696,21 +696,21 @@ static int ipipe_get_gamma_params(struct vpfe_ipipe_device *ipipe, void *param)
 
 	if (!gamma->bypass_r && !gamma_param->table_r) {
 		dev_err(dev,
-			"ipipe_get_gamma_params: table ptr empty for R\n");
+			"%s: table ptr empty for R\n", __func__);
 		return -EINVAL;
 	}
 	memcpy(gamma_param->table_r, gamma->table_r,
 	       (table_size * sizeof(struct vpfe_ipipe_gamma_entry)));
 
 	if (!gamma->bypass_g && !gamma_param->table_g) {
-		dev_err(dev, "ipipe_get_gamma_params: table ptr empty for G\n");
+		dev_err(dev, "%s: table ptr empty for G\n", __func__);
 		return -EINVAL;
 	}
 	memcpy(gamma_param->table_g, gamma->table_g,
 	       (table_size * sizeof(struct vpfe_ipipe_gamma_entry)));
 
 	if (!gamma->bypass_b && !gamma_param->table_b) {
-		dev_err(dev, "ipipe_get_gamma_params: table ptr empty for B\n");
+		dev_err(dev, "%s: table ptr empty for B\n", __func__);
 		return -EINVAL;
 	}
 	memcpy(gamma_param->table_b, gamma->table_b,
@@ -743,7 +743,7 @@ static int ipipe_get_3d_lut_params(struct vpfe_ipipe_device *ipipe, void *param)
 
 	lut_param->en = lut->en;
 	if (!lut_param->table) {
-		dev_err(dev, "ipipe_get_3d_lut_params: Invalid table ptr\n");
+		dev_err(dev, "%s: Invalid table ptr\n", __func__);
 		return -EINVAL;
 	}
 
@@ -924,7 +924,7 @@ static int ipipe_get_gbce_params(struct vpfe_ipipe_device *ipipe, void *param)
 	gbce_param->en = gbce->en;
 	gbce_param->type = gbce->type;
 	if (!gbce_param->table) {
-		dev_err(dev, "ipipe_get_gbce_params: Invalid table ptr\n");
+		dev_err(dev, "%s: Invalid table ptr\n", __func__);
 		return -EINVAL;
 	}
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index bffe215..16e2e7e 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -161,7 +161,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 {
 	struct vpfe_device *vpfe_dev = dev_id;
 
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_isr\n");
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "%s\n", __func__);
 	vpfe_isif_buffer_isr(&vpfe_dev->vpfe_isif);
 	vpfe_resizer_buffer_isr(&vpfe_dev->vpfe_resizer);
 	return IRQ_HANDLED;
@@ -172,7 +172,7 @@ static irqreturn_t vpfe_vdint1_isr(int irq, void *dev_id)
 {
 	struct vpfe_device *vpfe_dev = dev_id;
 
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_vdint1_isr\n");
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "%s\n", __func__);
 	vpfe_isif_vidint1_isr(&vpfe_dev->vpfe_isif);
 	return IRQ_HANDLED;
 }
@@ -182,7 +182,7 @@ static irqreturn_t vpfe_imp_dma_isr(int irq, void *dev_id)
 {
 	struct vpfe_device *vpfe_dev = dev_id;
 
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_imp_dma_isr\n");
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "%s\n", __func__);
 	vpfe_ipipeif_ss_buffer_isr(&vpfe_dev->vpfe_ipipeif);
 	vpfe_resizer_dma_isr(&vpfe_dev->vpfe_resizer);
 	return IRQ_HANDLED;
@@ -693,7 +693,7 @@ static int vpfe_remove(struct platform_device *pdev)
 {
 	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
 
-	v4l2_info(pdev->dev.driver, "vpfe_remove\n");
+	v4l2_info(pdev->dev.driver, "%s\n", __func__);
 
 	kzfree(vpfe_dev->sd);
 	vpfe_detach_irq(vpfe_dev);
-- 
1.9.1
