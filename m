Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35989 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754620AbdBGPQ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 10:16:26 -0500
Received: by mail-pg0-f66.google.com with SMTP id 75so12378840pgf.3
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 07:16:26 -0800 (PST)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH -next] [media] mtk-vcodec: remove redundant return value check of platform_get_resource()
Date: Tue,  7 Feb 2017 15:16:20 +0000
Message-Id: <20170207151620.12711-1-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Remove unneeded error handling on the result of a call
to platform_get_resource() when the value is passed to
devm_ioremap_resource().

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index aa81f3c..83f859e 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -269,11 +269,6 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 
 	for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, j);
-		if (res == NULL) {
-			dev_err(&pdev->dev, "get memory resource failed.");
-			ret = -ENXIO;
-			goto err_res;
-		}
 		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR((__force void *)dev->reg_base[i])) {
 			ret = PTR_ERR((__force void *)dev->reg_base[i]);



