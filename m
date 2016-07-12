Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:46087 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428AbcGLPPU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 11:15:20 -0400
From: weiyj_lk@163.com
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] [media] rcar_vin: remove redundant return value check of platform_get_resource()
Date: Tue, 12 Jul 2016 15:14:52 +0000
Message-Id: <1468336492-10389-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove unneeded error handling on the result of a call
to platform_get_resource() when the value is passed to
devm_ioremap_resource(). And move those two call together
to make the connection between them more clear.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 9c13752..bf52262 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1888,10 +1888,6 @@ static int rcar_vin_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "pdata_flags = %08x\n", pdata_flags);
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (mem == NULL)
-		return -EINVAL;
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0)
 		return -EINVAL;
@@ -1901,6 +1897,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);


