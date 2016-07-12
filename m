Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:59881 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbcGLLBg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 07:01:36 -0400
From: weiyj_lk@163.com
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	"Mauro Carvalho Chehab mchehab @ s-opensource . com Matthias Brugger"
	<matthias.bgg@gmail.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH -next] [media] VPU: mediatek: fix return value check in mtk_vpu_probe()
Date: Tue, 12 Jul 2016 11:00:55 +0000
Message-Id: <1468321255-15840-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function devm_clk_get() returns ERR_PTR()
and not returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index b60d02c..c8b2c72 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -788,9 +788,9 @@ static int mtk_vpu_probe(struct platform_device *pdev)
 
 	/* Get VPU clock */
 	vpu->clk = devm_clk_get(dev, "main");
-	if (!vpu->clk) {
+	if (IS_ERR(vpu->clk)) {
 		dev_err(dev, "get vpu clock failed\n");
-		return -EINVAL;
+		return PTR_ERR(vpu->clk);
 	}
 
 	platform_set_drvdata(pdev, vpu);


