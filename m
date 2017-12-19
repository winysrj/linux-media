Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:39660 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933276AbdLSA7S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 19:59:18 -0500
Received: by mail-qk0-f194.google.com with SMTP id u184so20671836qkd.6
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 16:59:18 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, hansverk@cisco.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH]  [media] coda/imx-vdoa: Remove irq member from vdoa_data struct
Date: Mon, 18 Dec 2017 22:58:44 -0200
Message-Id: <1513645124-5825-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

The 'irq' member of the vdoa_data struct is only used inside probe,
so there is no need for it. Use a local variable 'ret' instead.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/platform/coda/imx-vdoa.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index 8eb3e0c..eec27d3 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -86,7 +86,6 @@ struct vdoa_data {
 	struct device		*dev;
 	struct clk		*vdoa_clk;
 	void __iomem		*regs;
-	int			irq;
 };
 
 struct vdoa_q_data {
@@ -293,6 +292,7 @@ static int vdoa_probe(struct platform_device *pdev)
 {
 	struct vdoa_data *vdoa;
 	struct resource *res;
+	int ret;
 
 	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 
@@ -316,12 +316,12 @@ static int vdoa_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res)
 		return -EINVAL;
-	vdoa->irq = devm_request_threaded_irq(&pdev->dev, res->start, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, res->start, NULL,
 					vdoa_irq_handler, IRQF_ONESHOT,
 					"vdoa", vdoa);
-	if (vdoa->irq < 0) {
+	if (ret < 0) {
 		dev_err(vdoa->dev, "Failed to get irq\n");
-		return vdoa->irq;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, vdoa);
-- 
2.7.4
