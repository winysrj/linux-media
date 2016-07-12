Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:60091 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbcGLLB6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 07:01:58 -0400
From: weiyj_lk@163.com
To: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Matthias Brugger <matthias.bgg@gmail.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH -next] [media] VPU: mediatek: remove redundant dev_err call in mtk_vpu_probe()
Date: Tue, 12 Jul 2016 11:01:26 +0000
Message-Id: <1468321286-15939-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index b60d02c..532d2a4 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -774,17 +774,13 @@ static int mtk_vpu_probe(struct platform_device *pdev)
 	vpu->dev = &pdev->dev;
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "tcm");
 	vpu->reg.tcm = devm_ioremap_resource(dev, res);
-	if (IS_ERR((__force void *)vpu->reg.tcm)) {
-		dev_err(dev, "devm_ioremap_resource vpu tcm failed.\n");
+	if (IS_ERR((__force void *)vpu->reg.tcm))
 		return PTR_ERR((__force void *)vpu->reg.tcm);
-	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg_reg");
 	vpu->reg.cfg = devm_ioremap_resource(dev, res);
-	if (IS_ERR((__force void *)vpu->reg.cfg)) {
-		dev_err(dev, "devm_ioremap_resource vpu cfg failed.\n");
+	if (IS_ERR((__force void *)vpu->reg.cfg))
 		return PTR_ERR((__force void *)vpu->reg.cfg);
-	}
 
 	/* Get VPU clock */
 	vpu->clk = devm_clk_get(dev, "main");


