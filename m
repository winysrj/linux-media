Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33299 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752319AbbCGVmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:15 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 01/18] omap3isp: Fix error handling in probe
Date: Sat,  7 Mar 2015 23:40:58 +0200
Message-Id: <1425764475-27691-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutex was not destroyed correctly if dma_coerce_mask_and_coherent()
failed for some reason.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index deca809..fb193b6 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2252,7 +2252,7 @@ static int isp_probe(struct platform_device *pdev)
 
 	ret = dma_coerce_mask_and_coherent(isp->dev, DMA_BIT_MASK(32));
 	if (ret)
-		return ret;
+		goto error;
 
 	platform_set_drvdata(pdev, isp);
 
-- 
1.7.10.4

