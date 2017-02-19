Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:22002 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdBSRd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 12:33:57 -0500
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: kyungmin.park@samsung.com, kamil@wypas.org, a.hajda@samsung.com,
        mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] [media] s5p-g2d: Fix error handling
Date: Sun, 19 Feb 2017 18:30:22 +0100
Message-Id: <20170219173022.18707-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the surrounding goto, it is likely that 'unprep_clk_gate' was
expected here.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/platform/s5p-g2d/g2d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 62c0dec30b59..81ed5cd5cd5d 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -679,7 +679,7 @@ static int g2d_probe(struct platform_device *pdev)
 						0, pdev->name, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install IRQ\n");
-		goto put_clk_gate;
+		goto unprep_clk_gate;
 	}
 
 	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
-- 
2.9.3
